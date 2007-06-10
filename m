Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbXFJJd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbXFJJd5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbXFJJbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:31:08 -0400
Received: from www.osadl.org ([213.239.205.134]:43058 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752701AbXFJJa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:30:59 -0400
Message-Id: <20070610092446.699645374@inhelltoy.tec.linutronix.de>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 10 Jun 2007 09:44:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 09/23] clockevents: Fix device replacement
Content-Disposition: inline;
	filename=clockevents-broadcast-fix-device-replacement.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When a device is replaced by a better rated device, then the broadcast
mode needs to be evaluated again. When the new device has no requirement
for broadcasting, then the broadcast bits for the CPU must be cleared.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/time/tick-broadcast.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc4-mm/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/kernel/time/tick-broadcast.c	2007-06-10 10:44:38.000000000 +0200
+++ linux-2.6.22-rc4-mm/kernel/time/tick-broadcast.c	2007-06-10 10:44:38.000000000 +0200
@@ -31,6 +31,12 @@ struct tick_device tick_broadcast_device
 static cpumask_t tick_broadcast_mask;
 static DEFINE_SPINLOCK(tick_broadcast_lock);
 
+#ifdef CONFIG_TICK_ONESHOT
+static void tick_broadcast_clear_oneshot(int cpu);
+#else
+static inline void tick_broadcast_clear_oneshot(int cpu) { }
+#endif
+
 /*
  * Debugging: see timer_list.c
  */
@@ -99,8 +105,19 @@ int tick_device_uses_broadcast(struct cl
 		cpu_set(cpu, tick_broadcast_mask);
 		tick_broadcast_start_periodic(tick_broadcast_device.evtdev);
 		ret = 1;
-	}
+	} else {
+		/*
+		 * When the new device is not affected by the stop
+		 * feature and the cpu is marked in the broadcast mask
+		 * then clear the broadcast bit.
+		 */
+		if (!(dev->features & CLOCK_EVT_FEAT_C3STOP)) {
+			int cpu = smp_processor_id();
 
+			cpu_clear(cpu, tick_broadcast_mask);
+			tick_broadcast_clear_oneshot(cpu);
+		}
+	}
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 	return ret;
 }
@@ -487,6 +504,16 @@ out:
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
+/*
+ * Reset the one shot broadcast for a cpu
+ *
+ * Called with tick_broadcast_lock held
+ */
+static void tick_broadcast_clear_oneshot(int cpu)
+{
+	cpu_clear(cpu, tick_broadcast_oneshot_mask);
+}
+
 /**
  * tick_broadcast_setup_highres - setup the broadcast device for highres
  */

-- 

