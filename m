Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbXIAUs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbXIAUs4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 16:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbXIAUsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 16:48:46 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:1714 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbXIAUsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 16:48:46 -0400
Subject: Re: [PATCH 2.6.23-rc5] driver/char/hpet.c: remove clocksource
	warning on !IA64
From: Daniel Walker <dwalker@mvista.com>
To: torvalds@linux-foundation.org
Cc: Bob Picco <bob.picco@hp.com>, Tony Luck <tony.luck@intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070901155140.972420930@mvista.com>
References: <20070901155140.972420930@mvista.com>
Content-Type: text/plain
Date: Sat, 01 Sep 2007 13:38:16 -0700
Message-Id: <1188679097.11196.15.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-01 at 08:51 -0700, Daniel Walker wrote:
> The warnings,
> 
> drivers/char/hpet.c:72: warning: 'clocksource_hpet' defined but not used
> drivers/char/hpet.c:81: warning: 'hpet_clocksource' defined but not used
> 
> from,
> 
> commit 3b2b64fd311c92f2137eb7cee7025794cd854057
> Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
> Date:   Fri Aug 31 20:13:57 2007 -0700

Arg, forgot the most important variable. The new function I created
needed the hpetp variable. So I added that in the patch below.. I tested
both of the ifdef blocks on i386 by just removing the ifdefs .. So it
compiles both ways ..

----

Subject: driver/char/hpet.c: remove clocksource warning on !IA64

The warnings,

drivers/char/hpet.c:72: warning: 'clocksource_hpet' defined but not used
drivers/char/hpet.c:81: warning: 'hpet_clocksource' defined but not used

from,

commit 3b2b64fd311c92f2137eb7cee7025794cd854057
Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
Date:   Fri Aug 31 20:13:57 2007 -0700


This patch eliminates the warnings when the clocksoure isn't used.
It also removes some other unused stuff that goes along with the
clocksource ..

I don't have access to an ia64 machine, or even a compiler .. So this
one is untested for that. I'm hoping one of the ia64 guys can help
test this

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/char/hpet.c |   68 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

Index: linux-2.6.22/drivers/char/hpet.c
===================================================================
--- linux-2.6.22.orig/drivers/char/hpet.c
+++ linux-2.6.22/drivers/char/hpet.c
@@ -62,24 +62,6 @@
 
 static u32 hpet_nhpet, hpet_max_freq = HPET_USER_FREQ;
 
-static void __iomem *hpet_mctr;
-
-static cycle_t read_hpet(void)
-{
-	return (cycle_t)read_counter((void __iomem *)hpet_mctr);
-}
-
-static struct clocksource clocksource_hpet = {
-        .name           = "hpet",
-        .rating         = 250,
-        .read           = read_hpet,
-        .mask           = CLOCKSOURCE_MASK(64),
-        .mult           = 0, /*to be caluclated*/
-        .shift          = 10,
-        .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
-};
-static struct clocksource *hpet_clocksource;
-
 /* A lock for concurrent access by app and isr hpet activity. */
 static DEFINE_SPINLOCK(hpet_lock);
 /* A lock for concurrent intermodule access to hpet and isr hpet activity. */
@@ -116,6 +98,42 @@ struct hpets {
 
 static struct hpets *hpets;
 
+#ifdef CONFIG_IA64
+static void __iomem *hpet_mctr;
+
+static cycle_t read_hpet(void)
+{
+	return (cycle_t)read_counter((void __iomem *)hpet_mctr);
+}
+
+static struct clocksource clocksource_hpet = {
+        .name           = "hpet",
+        .rating         = 250,
+        .read           = read_hpet,
+        .mask           = CLOCKSOURCE_MASK(64),
+        .mult           = 0, /*to be caluclated*/
+        .shift          = 10,
+        .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+static struct clocksource *hpet_clocksource;
+
+/* This clocksource driver currently only works on ia64 */
+static inline void ia64_clocksource_register(struct hpets *hpetp)
+{
+	if (!hpet_clocksource) {
+		hpet_mctr = (void __iomem *)&hpetp->hp_hpet->hpet_mc;
+		CLKSRC_FSYS_MMIO_SET(clocksource_hpet.fsys_mmio, hpet_mctr);
+		clocksource_hpet.mult = clocksource_hz2mult(hpetp->hp_tick_freq,
+						clocksource_hpet.shift);
+		clocksource_register(&clocksource_hpet);
+		hpetp->hp_clocksource = &clocksource_hpet;
+		hpet_clocksource = &clocksource_hpet;
+	}
+}
+#else
+static inline void ia64_clocksource_register(struct hpets *hpetp) { }
+#endif
+
 #define	HPET_OPEN		0x0001
 #define	HPET_IE			0x0002	/* interrupt enabled */
 #define	HPET_PERIODIC		0x0004
@@ -909,18 +927,8 @@ int hpet_alloc(struct hpet_data *hdp)
 
 	hpetp->hp_delta = hpet_calibrate(hpetp);
 
-/* This clocksource driver currently only works on ia64 */
-#ifdef CONFIG_IA64
-	if (!hpet_clocksource) {
-		hpet_mctr = (void __iomem *)&hpetp->hp_hpet->hpet_mc;
-		CLKSRC_FSYS_MMIO_SET(clocksource_hpet.fsys_mmio, hpet_mctr);
-		clocksource_hpet.mult = clocksource_hz2mult(hpetp->hp_tick_freq,
-						clocksource_hpet.shift);
-		clocksource_register(&clocksource_hpet);
-		hpetp->hp_clocksource = &clocksource_hpet;
-		hpet_clocksource = &clocksource_hpet;
-	}
-#endif
+	ia64_clocksource_register(hpetp);
+
 
 	return 0;
 }


