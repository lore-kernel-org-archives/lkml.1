Return-Path: <linux-kernel-owner+w=401wt.eu-S1759567AbYFXQU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbYFXQU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYFXQUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:20:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:36535 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbYFXQUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:20:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=OYj2ib7UqNLaOUYDfLbKeusC3FZmtq8ctbUJcgVBvdi4s+JQN9cMQ0vyWBxK89fXMc
         sLpDPq99YnU4KKu3nDZ8bePIzzztaKsztbufy6KTGffwMm0hxWSgPdvEoP9PbE3LE9Ni
         al3zJjPW/+A/mHoINwXyypAWY+PzqROSVsi10=
References: <20080624161624.124913675@gmail.com>>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:04 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, macro@linux-mips.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org
Subject: [patch 4/5] x86: nmi_watchdog - use NMI_NONE by default
Content-Disposition: inline; filename=nmi-watchdog-use-none
Message-ID: <48611ec4.1836440a.79e4.22e4@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to keep NMI_DISABLED definition and use it
for nmi_watchdog by default. Here is the point why:

- IO-APIC and APIC chips are programmed for nmi_watchdog support at very
  early stage of kernel booting and not having nmi_watchdog specified as
  boot option lead only to nmi_watchdog becomes to NMI_NONE anyway
- enable nmi_watchdog thru /proc/sys/kernel/nmi if it was not specified at
  boot is not possible too (even having this sysfs entry)

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/include/asm-x86/nmi.h
====================================================================
--- linux-2.6.git.orig/include/asm-x86/nmi.h	2008-06-24 19:30:34.000000000 +0400
+++ linux-2.6.git/include/asm-x86/nmi.h	2008-06-24 19:32:44.000000000 +0400
@@ -20,7 +20,6 @@ extern void default_do_nmi(struct pt_reg
 #endif
 
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
-extern void nmi_watchdog_default(void);
 extern int check_nmi_watchdog(void);
 extern int nmi_watchdog_enabled;
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
@@ -38,12 +37,10 @@ extern int nmi_watchdog_tick(struct pt_r
 
 extern atomic_t nmi_active;
 extern unsigned int nmi_watchdog;
-#define NMI_DISABLED    -1
 #define NMI_NONE	0
 #define NMI_IO_APIC	1
 #define NMI_LOCAL_APIC	2
 #define NMI_INVALID	3
-#define NMI_DEFAULT	NMI_DISABLED
 
 struct ctl_table;
 struct file;
Index: linux-2.6.git/arch/x86/kernel/apic_64.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_64.c	2008-06-24 19:30:59.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_64.c	2008-06-24 19:31:03.000000000 +0400
@@ -826,7 +826,6 @@ static void __cpuinit lapic_setup_esr(vo
 void __cpuinit end_local_APIC_setup(void)
 {
 	lapic_setup_esr();
-	nmi_watchdog_default();
 	setup_apic_nmi_watchdog(NULL);
 	apic_pm_activate();
 }
Index: linux-2.6.git/arch/x86/kernel/io_apic_64.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_apic_64.c	2008-06-24 19:30:34.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/io_apic_64.c	2008-06-24 19:31:03.000000000 +0400
@@ -1729,7 +1729,6 @@ static inline void __init check_timer(vo
 		}
 		unmask_IO_APIC_irq(0);
 		if (!no_timer_check && timer_irq_works()) {
-			nmi_watchdog_default();
 			if (nmi_watchdog == NMI_IO_APIC) {
 				setup_nmi();
 				enable_8259A_irq(0);
@@ -1758,7 +1757,6 @@ static inline void __init check_timer(vo
 		if (timer_irq_works()) {
 			apic_printk(APIC_VERBOSE," works.\n");
 			timer_through_8259 = 1;
-			nmi_watchdog_default();
 			if (nmi_watchdog == NMI_IO_APIC) {
 				disable_8259A_irq(0);
 				setup_nmi();
Index: linux-2.6.git/arch/x86/kernel/smpboot.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/smpboot.c	2008-06-24 19:30:34.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/smpboot.c	2008-06-24 19:31:03.000000000 +0400
@@ -1140,7 +1140,6 @@ static void __init smp_cpu_index_default
 void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
 	preempt_disable();
-	nmi_watchdog_default();
 	smp_cpu_index_default();
 	current_cpu_data = boot_cpu_data;
 	cpu_callin_map = cpumask_of_cpu(0);
Index: linux-2.6.git/arch/x86/kernel/nmi.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi.c	2008-06-24 19:31:01.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi.c	2008-06-24 19:32:09.000000000 +0400
@@ -49,7 +49,7 @@ static cpumask_t backtrace_mask = CPU_MA
 atomic_t nmi_active = ATOMIC_INIT(0);		/* oprofile uses this */
 EXPORT_SYMBOL(nmi_active);
 
-unsigned int nmi_watchdog = NMI_DEFAULT;
+unsigned int nmi_watchdog = NMI_NONE;
 EXPORT_SYMBOL(nmi_watchdog);
 
 static int panic_on_timeout;
@@ -89,14 +89,6 @@ static inline unsigned int get_timer_irq
 #endif
 }
 
-/* Run after command line and cpu_init init, but before all other checks */
-void nmi_watchdog_default(void)
-{
-	if (nmi_watchdog != NMI_DEFAULT)
-		return;
-	nmi_watchdog = NMI_NONE;
-}
-
 #ifdef CONFIG_SMP
 /*
  * The performance counters used by NMI_LOCAL_APIC don't trigger when
@@ -124,7 +116,7 @@ int __init check_nmi_watchdog(void)
 	unsigned int *prev_nmi_count;
 	int cpu;
 
-	if (nmi_watchdog == NMI_NONE || nmi_watchdog == NMI_DISABLED)
+	if (nmi_watchdog == NMI_NONE)
 		return 0;
 
 	if (!atomic_read(&nmi_active))
@@ -481,24 +473,12 @@ int proc_nmi_enabled(struct ctl_table *t
 	if (!!old_state == !!nmi_watchdog_enabled)
 		return 0;
 
-	if (atomic_read(&nmi_active) < 0 || nmi_watchdog == NMI_DISABLED) {
+	if (atomic_read(&nmi_active) < 0 || nmi_watchdog == NMI_NONE) {
 		printk(KERN_WARNING
 			"NMI watchdog is permanently disabled\n");
 		return -EIO;
 	}
 
-	/* if nmi_watchdog is not set yet, then set it */
-	nmi_watchdog_default();
-
-#ifdef CONFIG_X86_32
-	if (nmi_watchdog == NMI_NONE) {
-		if (lapic_watchdog_ok())
-			nmi_watchdog = NMI_LOCAL_APIC;
-		else
-			nmi_watchdog = NMI_IO_APIC;
-	}
-#endif
-
 	if (nmi_watchdog == NMI_LOCAL_APIC) {
 		if (nmi_watchdog_enabled)
 			enable_lapic_nmi_watchdog();

-- 
