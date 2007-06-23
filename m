Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbXFWNZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbXFWNZP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758111AbXFWNWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:22:09 -0400
Received: from www.osadl.org ([213.239.205.134]:59232 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757832AbXFWNWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:22:03 -0400
Message-Id: <20070623124030.575989896@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch -mm 10/28] highres: Improve debug output
Content-Disposition: inline; filename=highres-improve-debug-output.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

Add some more debug information to the hrtimer and clock events code.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/i386/kernel/apic.c    |    3 +++
 kernel/hrtimer.c           |    5 ++++-
 kernel/time/tick-oneshot.c |   15 ++++++++++++++-
 3 files changed, 21 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc4-mm/arch/i386/kernel/apic.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/i386/kernel/apic.c	2007-06-23 14:38:58.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/i386/kernel/apic.c	2007-06-23 14:38:58.000000000 +0200
@@ -524,6 +524,9 @@ void __init setup_boot_APIC_clock(void)
 		 */
 		if (nmi_watchdog != NMI_IO_APIC)
 			lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
+		else
+			printk(KERN_WARNING "APIC timer registered as dummy,"
+			       " due to nmi_watchdog=1!\n");
 	}
 
 	/* Setup the lapic or request the broadcast */
Index: linux-2.6.22-rc4-mm/kernel/hrtimer.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/kernel/hrtimer.c	2007-06-23 14:38:56.000000000 +0200
+++ linux-2.6.22-rc4-mm/kernel/hrtimer.c	2007-06-23 14:38:58.000000000 +0200
@@ -558,7 +558,8 @@ static inline int hrtimer_enqueue_reprog
  */
 static int hrtimer_switch_to_hres(void)
 {
-	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
+	int cpu = smp_processor_id();
+	struct hrtimer_cpu_base *base = &per_cpu(hrtimer_bases, cpu);
 	unsigned long flags;
 
 	if (base->hres_active)
@@ -568,6 +569,8 @@ static int hrtimer_switch_to_hres(void)
 
 	if (tick_init_highres()) {
 		local_irq_restore(flags);
+		printk(KERN_WARNING "Could not switch to high resolution "
+				    "mode on CPU %d\n", cpu);
 		return 0;
 	}
 	base->hres_active = 1;
Index: linux-2.6.22-rc4-mm/kernel/time/tick-oneshot.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/kernel/time/tick-oneshot.c	2007-06-23 14:38:56.000000000 +0200
+++ linux-2.6.22-rc4-mm/kernel/time/tick-oneshot.c	2007-06-23 14:38:58.000000000 +0200
@@ -73,8 +73,21 @@ int tick_switch_to_oneshot(void (*handle
 	struct clock_event_device *dev = td->evtdev;
 
 	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT) ||
-	    !tick_device_is_functional(dev))
+		    !tick_device_is_functional(dev)) {
+
+		printk(KERN_INFO "Clockevents: "
+		       "could not switch to one-shot mode:");
+		if (!dev) {
+			printk(" no tick device\n");
+		} else {
+			if (!tick_device_is_functional(dev))
+				printk(" %s is not functional.\n", dev->name);
+			else if (!(dev->features & CLOCK_EVT_FEAT_ONESHOT))
+				printk(" %s does not support one-shot mode.\n",
+				       dev->name);
+		}
 		return -EINVAL;
+	}
 
 	td->mode = TICKDEV_MODE_ONESHOT;
 	dev->event_handler = handler;

-- 

