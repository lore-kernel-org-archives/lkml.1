Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbZBHFPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbZBHFPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 00:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbZBHFPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 00:15:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:55312 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbZBHFPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 00:15:36 -0500
Message-ID: <498E6A3C.6020004@kernel.org>
Date: Sat, 07 Feb 2009 21:14:36 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: check_timer cleanup
References: <20090206220716.GA15319@elte.hu> <498D55A4.7000608@kernel.org> <20090207165901.GA32116@elte.hu>
In-Reply-To: <20090207165901.GA32116@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: remove extra unmask, and pair disable/enable

for edge trigger io-apic routing, already unmasked via setup_IO_APIC_irq,
so don't unmask it again.

also do call local_irq_disable() between timer_irq_works(), between it does call
local_irq_enable() inside.
also remove not needed apic version reading for 64bit

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/io_apic.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -1660,7 +1660,7 @@ static void __init setup_timer_IRQ0_pin(
 	 * to the first CPU.
 	 */
 	entry.dest_mode = apic->irq_dest_mode;
-	entry.mask = 1;					/* mask IRQ now */
+	entry.mask = 0;			/* don't mask IRQ for edge */
 	entry.dest = apic->cpu_mask_to_apicid(apic->target_cpus());
 	entry.delivery_mode = apic->irq_delivery_mode;
 	entry.polarity = 0;
@@ -2866,14 +2866,10 @@ static inline void __init check_timer(vo
 	int cpu = boot_cpu_id;
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
-	unsigned int ver;
 	int no_pin1 = 0;
 
 	local_irq_save(flags);
 
-	ver = apic_read(APIC_LVR);
-	ver = GET_APIC_VERSION(ver);
-
 	/*
 	 * get/set the timer IRQ vector:
 	 */
@@ -2892,7 +2888,13 @@ static inline void __init check_timer(vo
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
 	init_8259A(1);
 #ifdef CONFIG_X86_32
-	timer_ack = (nmi_watchdog == NMI_IO_APIC && !APIC_INTEGRATED(ver));
+	{
+		unsigned int ver;
+
+		ver = apic_read(APIC_LVR);
+		ver = GET_APIC_VERSION(ver);
+		timer_ack = (nmi_watchdog == NMI_IO_APIC && !APIC_INTEGRATED(ver));
+	}
 #endif
 
 	pin1  = find_isa_irq_pin(0, mp_INT);
@@ -2931,8 +2933,17 @@ static inline void __init check_timer(vo
 		if (no_pin1) {
 			add_pin_to_irq_cpu(cfg, cpu, apic1, pin1);
 			setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
+		} else {
+			/* for edge trigger, setup_IO_APIC_irq already
+			 * leave it unmasked.
+			 * so only need to unmask if it is level-trigger
+			 * do we really have level trigger timer?
+			 */
+			int idx;
+			idx = find_irq_entry(apic1, pin1, mp_INT);
+			if (idx != -1 && irq_trigger(idx))
+				unmask_IO_APIC_irq_desc(desc);
 		}
-		unmask_IO_APIC_irq_desc(desc);
 		if (timer_irq_works()) {
 			if (nmi_watchdog == NMI_IO_APIC) {
 				setup_nmi();
@@ -2946,6 +2957,7 @@ static inline void __init check_timer(vo
 		if (intr_remapping_enabled)
 			panic("timer doesn't work through Interrupt-remapped IO-APIC");
 #endif
+		local_irq_disable();
 		clear_IO_APIC_pin(apic1, pin1);
 		if (!no_pin1)
 			apic_printk(APIC_QUIET, KERN_ERR "..MP-BIOS bug: "
@@ -2960,7 +2972,6 @@ static inline void __init check_timer(vo
 		 */
 		replace_pin_at_irq_cpu(cfg, cpu, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
-		unmask_IO_APIC_irq_desc(desc);
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
 			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
@@ -2975,6 +2986,7 @@ static inline void __init check_timer(vo
 		/*
 		 * Cleanup, just in case ...
 		 */
+		local_irq_disable();
 		disable_8259A_irq(0);
 		clear_IO_APIC_pin(apic2, pin2);
 		apic_printk(APIC_QUIET, KERN_INFO "....... failed.\n");
@@ -3000,6 +3012,7 @@ static inline void __init check_timer(vo
 		apic_printk(APIC_QUIET, KERN_INFO "..... works.\n");
 		goto out;
 	}
+	local_irq_disable();
 	disable_8259A_irq(0);
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | cfg->vector);
 	apic_printk(APIC_QUIET, KERN_INFO "..... failed.\n");
@@ -3017,6 +3030,7 @@ static inline void __init check_timer(vo
 		apic_printk(APIC_QUIET, KERN_INFO "..... works.\n");
 		goto out;
 	}
+	local_irq_disable();
 	apic_printk(APIC_QUIET, KERN_INFO "..... failed :(.\n");
 	panic("IO-APIC + timer doesn't work!  Boot with apic=debug and send a "
 		"report.  Then try booting with the 'noapic' option.\n");
