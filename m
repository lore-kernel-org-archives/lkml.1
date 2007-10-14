Return-Path: <linux-kernel-owner+w=401wt.eu-S1763996AbXJNVya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763996AbXJNVya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 17:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbXJNVyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 17:54:21 -0400
Received: from www.tglx.de ([62.245.132.106]:53984 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbXJNVyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 17:54:20 -0400
Date: Sun, 14 Oct 2007 23:53:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeff Garzik <jeff@garzik.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: {GIT pull] x86 bugfixes
In-Reply-To: <47128D76.5050407@garzik.org>
Message-ID: <alpine.LFD.0.9999.0710142351480.22612@localhost.localdomain>
References: <alpine.LFD.0.9999.0710142326451.22612@localhost.localdomain> <47128D76.5050407@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Oct 2007, Jeff Garzik wrote:
> Unless the size is overlarge (currently 400k, on lkml), any chance I could
> talk you into appending the associated patch onto the end of future emails?

Sure. See below.
 
> If it helps, I use the attached script when I send stuff upstream.

Cute. 

Thanks,

	tglx
---

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index bd72d94..11b03d3 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -10,6 +10,7 @@
 #include <asm/pgtable.h>
 #include <asm/mce.h>
 #include <asm/nmi.h>
+#include <asm/vsyscall.h>
 
 #define MAX_PATCH_LEN (255-1)
 
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 395928d..09b8209 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -964,8 +964,34 @@ void __init setup_boot_APIC_clock (void)
 	setup_APIC_timer();
 }
 
+/*
+ * AMD C1E enabled CPUs have a real nasty problem: Some BIOSes set the
+ * C1E flag only in the secondary CPU, so when we detect the wreckage
+ * we already have enabled the boot CPU local apic timer. Check, if
+ * disable_apic_timer is set and the DUMMY flag is cleared. If yes,
+ * set the DUMMY flag again and force the broadcast mode in the
+ * clockevents layer.
+ */
+void __cpuinit check_boot_apic_timer_broadcast(void)
+{
+	struct clock_event_device *levt = &per_cpu(lapic_events, boot_cpu_id);
+
+	if (!disable_apic_timer ||
+	    (lapic_clockevent.features & CLOCK_EVT_FEAT_DUMMY))
+		return;
+
+	printk(KERN_INFO "AMD C1E detected late. Force timer broadcast.\n");
+	lapic_clockevent.features |= CLOCK_EVT_FEAT_DUMMY;
+	levt->features |= CLOCK_EVT_FEAT_DUMMY;
+
+	local_irq_enable();
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_FORCE, &boot_cpu_id);
+	local_irq_disable();
+}
+
 void __cpuinit setup_secondary_APIC_clock(void)
 {
+	check_boot_apic_timer_broadcast();
 	setup_APIC_timer();
 }
 
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 57ccf7c..720a7d1 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -335,11 +335,6 @@ void __cpuinit start_secondary(void)
  	 */
 	check_tsc_sync_target();
 
-	Dprintk("cpu %d: setting up apic clock\n", smp_processor_id()); 	
-	setup_secondary_APIC_clock();
-
-	Dprintk("cpu %d: enabling apic timer\n", smp_processor_id());
-
 	if (nmi_watchdog == NMI_IO_APIC) {
 		disable_8259A_irq(0);
 		enable_NMI_through_LVT0(NULL);
@@ -374,6 +369,8 @@ void __cpuinit start_secondary(void)
 
 	unlock_ipi_call_lock();
 
+	setup_secondary_APIC_clock();
+
 	cpu_idle();
 }
 
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index d2ddea9..c33b0dc 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -31,6 +31,7 @@ enum clock_event_nofitiers {
 	CLOCK_EVT_NOTIFY_ADD,
 	CLOCK_EVT_NOTIFY_BROADCAST_ON,
 	CLOCK_EVT_NOTIFY_BROADCAST_OFF,
+	CLOCK_EVT_NOTIFY_BROADCAST_FORCE,
 	CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
 	CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
 	CLOCK_EVT_NOTIFY_SUSPEND,
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 298bc7c..fc3fc79 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -217,26 +217,43 @@ static void tick_do_broadcast_on_off(void *why)
 	bc = tick_broadcast_device.evtdev;
 
 	/*
-	 * Is the device in broadcast mode forever or is it not
-	 * affected by the powerstate ?
+	 * Is the device not affected by the powerstate ?
 	 */
-	if (!dev || !tick_device_is_functional(dev) ||
-	    !(dev->features & CLOCK_EVT_FEAT_C3STOP))
+	if (!dev || !(dev->features & CLOCK_EVT_FEAT_C3STOP))
 		goto out;
 
-	if (*reason == CLOCK_EVT_NOTIFY_BROADCAST_ON) {
+	/*
+	 * Defect device ?
+	 */
+	if (!tick_device_is_functional(dev)) {
+		/*
+		 * AMD C1E wreckage fixup:
+		 *
+		 * Device was registered functional in the first
+		 * place. Now the secondary CPU detected the C1E
+		 * misfeature and notifies us to fix it up
+		 */
+		if (*reason != CLOCK_EVT_NOTIFY_BROADCAST_FORCE)
+			goto out;
+	}
+
+	switch (*reason) {
+	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
+	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
 		if (!cpu_isset(cpu, tick_broadcast_mask)) {
 			cpu_set(cpu, tick_broadcast_mask);
 			if (td->mode == TICKDEV_MODE_PERIODIC)
 				clockevents_set_mode(dev,
 						     CLOCK_EVT_MODE_SHUTDOWN);
 		}
-	} else {
+		break;
+	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
 		if (cpu_isset(cpu, tick_broadcast_mask)) {
 			cpu_clear(cpu, tick_broadcast_mask);
 			if (td->mode == TICKDEV_MODE_PERIODIC)
 				tick_setup_periodic(dev, 0);
 		}
+		break;
 	}
 
 	if (cpus_empty(tick_broadcast_mask))
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 3f3ae39..1bea399 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -345,6 +345,7 @@ static int tick_notify(struct notifier_block *nb, unsigned long reason,
 
 	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
 	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
+	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
 		tick_broadcast_on_off(reason, dev);
 		break;
 

