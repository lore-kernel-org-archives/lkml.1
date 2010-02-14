Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab0BNRsi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 12:48:38 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:41366 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab0BNRsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 12:48:36 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Feb 2010 18:47:47 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/4] firewire: get_cycle_timer optimization and cleanup
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.a3f2efe539e59c19@s5r6.in-berlin.de>
Message-ID: <tkrat.f36b636501d78192@s5r6.in-berlin.de>
References: <tkrat.a3f2efe539e59c19@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ohci:  Break out of the retry loop if too many attempts were necessary.
This may theoretically happen if the chip is fatally defective or if the
get_cycle_timer ioctl was performed after a CardBus controller was
ejected.

Also micro-optimize the loop by re-using the last two register reads in
the next iteration, remove a questionable inline keyword, and shuffle a
comment around.

core:  ioctl_get_cycle_timer() is always called with interrupts on,
therefore local_irq_save() can be replaced by local_irq_disable().
Disabled local IRQs imply disabled preemption, hence preempt_disable()
can be removed.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |   17 ++++------
 drivers/firewire/ohci.c      |   57 ++++++++++++++++++-----------------
 2 files changed, 36 insertions(+), 38 deletions(-)

Index: linux-2.6.33-rc8/drivers/firewire/core-cdev.c
===================================================================
--- linux-2.6.33-rc8.orig/drivers/firewire/core-cdev.c
+++ linux-2.6.33-rc8/drivers/firewire/core-cdev.c
@@ -25,6 +25,7 @@
 #include <linux/firewire.h>
 #include <linux/firewire-cdev.h>
 #include <linux/idr.h>
+#include <linux/irqflags.h>
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/kref.h>
@@ -32,8 +33,6 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/poll.h>
-#include <linux/preempt.h>
-#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/time.h>
@@ -1035,21 +1034,19 @@ static int ioctl_get_cycle_timer(struct 
 {
 	struct fw_cdev_get_cycle_timer *request = buffer;
 	struct fw_card *card = client->device->card;
-	unsigned long long bus_time;
 	struct timeval tv;
-	unsigned long flags;
+	u32 cycle_time;
 
-	preempt_disable();
-	local_irq_save(flags);
+	local_irq_disable();
 
-	bus_time = card->driver->get_bus_time(card);
+	cycle_time = card->driver->get_bus_time(card);
 	do_gettimeofday(&tv);
 
-	local_irq_restore(flags);
-	preempt_enable();
+	local_irq_enable();
 
 	request->local_time = tv.tv_sec * 1000000ULL + tv.tv_usec;
-	request->cycle_timer = bus_time & 0xffffffff;
+	request->cycle_timer = cycle_time;
+
 	return 0;
 }
 
Index: linux-2.6.33-rc8/drivers/firewire/ohci.c
===================================================================
--- linux-2.6.33-rc8.orig/drivers/firewire/ohci.c
+++ linux-2.6.33-rc8/drivers/firewire/ohci.c
@@ -1795,60 +1795,61 @@ static int ohci_enable_phys_dma(struct f
 #endif /* CONFIG_FIREWIRE_OHCI_REMOTE_DMA */
 }
 
-static inline u32 cycle_timer_ticks(u32 cycle_timer)
+static u32 cycle_timer_ticks(u32 cycle_timer)
 {
 	u32 ticks;
 
 	ticks = cycle_timer & 0xfff;
 	ticks += 3072 * ((cycle_timer >> 12) & 0x1fff);
 	ticks += (3072 * 8000) * (cycle_timer >> 25);
+
 	return ticks;
 }
 
+/*
+ * Some controllers exhibit one or more of the following bugs when updating the
+ * iso cycle timer register:
+ *  - When the lowest six bits are wrapping around to zero, a read that happens
+ *    at the same time will return garbage in the lowest ten bits.
+ *  - When the cycleOffset field wraps around to zero, the cycleCount field is
+ *    not incremented for about 60 ns.
+ *  - Occasionally, the entire register reads zero.
+ *
+ * To catch these, we read the register three times and ensure that the
+ * difference between each two consecutive reads is approximately the same, i.e.
+ * less than twice the other.  Furthermore, any negative difference indicates an
+ * error.  (A PCI read should take at least 20 ticks of the 24.576 MHz timer to
+ * execute, so we have enough precision to compute the ratio of the differences.)
+ */
 static u64 ohci_get_bus_time(struct fw_card *card)
 {
 	struct fw_ohci *ohci = fw_ohci(card);
 	u32 c0, c1, c2;
 	u32 t0, t1, t2;
 	s32 diff01, diff12;
-	u64 bus_time;
+	int i;
+
+	c2 = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
 
-	if (!ohci->iso_cycle_timer_quirk) {
+	if (ohci->iso_cycle_timer_quirk) {
+		i = 0;
+		c1 = c2;
 		c2 = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
-	} else {
-		/*
-		 * Some controllers exhibit one or more of the following bugs
-		 * when updating the iso cycle timer register:
-		 *  - When the lowest six bits are wrapping around to zero,
-		 *    a read that happens at the same time will return garbage
-		 *    in the lowest ten bits.
-		 *  - When the cycleOffset field wraps around to zero, the
-		 *    cycleCount field is not incremented for about 60 ns.
-		 *  - Occasionally, the entire register reads zero.
-		 *
-		 * To catch these, we read the register three times and ensure
-		 * that the difference between each two consecutive reads is
-		 * approximately the same, i.e., less than twice the other.
-		 * Furthermore, any negative difference indicates an error.
-		 * (A PCI read should take at least 20 ticks of the 24.576 MHz
-		 * timer to execute, so we have enough precision to compute the
-		 * ratio of the differences.)
-		 */
 		do {
-			c0 = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
-			c1 = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
+			c0 = c1;
+			c1 = c2;
 			c2 = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
 			t0 = cycle_timer_ticks(c0);
 			t1 = cycle_timer_ticks(c1);
 			t2 = cycle_timer_ticks(c2);
 			diff01 = t1 - t0;
 			diff12 = t2 - t1;
-		} while (diff01 <= 0 || diff12 <= 0 ||
-			 diff01 / diff12 >= 2 || diff12 / diff01 >= 2);
+		} while ((diff01 <= 0 || diff12 <= 0 ||
+			  diff01 / diff12 >= 2 || diff12 / diff01 >= 2)
+			 && i++ < 20);
 	}
-	bus_time = ((u64)atomic_read(&ohci->bus_seconds) << 32) | c2;
 
-	return bus_time;
+	return ((u64)atomic_read(&ohci->bus_seconds) << 32) | c2;
 }
 
 static void copy_iso_headers(struct iso_context *ctx, void *p)

-- 
Stefan Richter
-=====-==-=- --=- -===-
http://arcgraph.de/sr/

