Return-Path: <linux-kernel-owner+w=401wt.eu-S936553AbXGTPec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936553AbXGTPec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935118AbXGTPcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:32:54 -0400
Received: from ns.suse.de ([195.135.220.2]:50686 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758700AbXGTPcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:32:52 -0400
From: Andi Kleen <ak@suse.de>
References: <20070720532.949522000@suse.de>
In-Reply-To: <20070720532.949522000@suse.de>
To: compudj@krystal.dyndns.org, jeremy@goop.org, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [3/11] x86: Stop MCEs and NMIs during code patching
Message-Id: <20070720153247.75CAD14E7C@wotan.suse.de>
Date: Fri, 20 Jul 2007 17:32:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When a machine check or NMI occurs while multiple byte code is patched
the CPU could theoretically see an inconsistent instruction and crash.
Prevent this by temporarily disabling MCEs and returning early
in the NMI handler.

Based on discussion with Mathieu Desnoyers.

Cc:  Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: jeremy@goop.org

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/i386/kernel/alternative.c
===================================================================
--- linux.orig/arch/i386/kernel/alternative.c
+++ linux/arch/i386/kernel/alternative.c
@@ -8,6 +8,8 @@
 #include <asm/alternative.h>
 #include <asm/sections.h>
 #include <asm/pgtable.h>
+#include <asm/mce.h>
+#include <asm/nmi.h>
 
 #ifdef CONFIG_HOTPLUG_CPU
 static int smp_alt_once;
@@ -373,6 +375,12 @@ void __init alternative_instructions(voi
 {
 	unsigned long flags;
 
+	/* The patching is not fully atomic, so try to avoid local interruptions
+	   that might execute the to be patched code.
+	   Other CPUs are not running. */
+	stop_nmi();
+	stop_mce();
+
 	local_irq_save(flags);
 	apply_alternatives(__alt_instructions, __alt_instructions_end);
 
@@ -405,6 +413,9 @@ void __init alternative_instructions(voi
 #endif
  	apply_paravirt(__parainstructions, __parainstructions_end);
 	local_irq_restore(flags);
+
+	restart_nmi();
+	restart_mce();
 }
 
 /*
Index: linux/arch/x86_64/kernel/mce.c
===================================================================
--- linux.orig/arch/x86_64/kernel/mce.c
+++ linux/arch/x86_64/kernel/mce.c
@@ -667,6 +667,20 @@ static struct miscdevice mce_log_device 
 	&mce_chrdev_ops,
 };
 
+static unsigned long old_cr4 __initdata;
+
+void __init stop_mce(void) 
+{
+	old_cr4 = read_cr4();
+	clear_in_cr4(X86_CR4_MCE);
+} 
+
+void __init restart_mce(void)
+{
+	if (old_cr4 & X86_CR4_MCE)
+		set_in_cr4(X86_CR4_MCE);	
+}
+
 /* 
  * Old style boot options parsing. Only for compatibility. 
  */
Index: linux/arch/x86_64/kernel/nmi.c
===================================================================
--- linux.orig/arch/x86_64/kernel/nmi.c
+++ linux/arch/x86_64/kernel/nmi.c
@@ -384,11 +384,14 @@ int __kprobes nmi_watchdog_tick(struct p
 	return rc;
 }
 
+static unsigned ignore_nmis;
+
 asmlinkage __kprobes void do_nmi(struct pt_regs * regs, long error_code)
 {
 	nmi_enter();
 	add_pda(__nmi_count,1);
-	default_do_nmi(regs);
+	if (!ignore_nmis) 
+		default_do_nmi(regs);
 	nmi_exit();
 }
 
@@ -401,6 +404,18 @@ int do_nmi_callback(struct pt_regs * reg
 	return 0;
 }
 
+void stop_nmi(void)
+{
+	ignore_nmis++;
+	acpi_nmi_disable();
+}
+
+void restart_nmi(void)
+{
+	ignore_nmis--;
+	acpi_nmi_enable();
+}
+
 #ifdef CONFIG_SYSCTL
 
 static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
Index: linux/include/asm-x86_64/mce.h
===================================================================
--- linux.orig/include/asm-x86_64/mce.h
+++ linux/include/asm-x86_64/mce.h
@@ -107,6 +107,9 @@ extern void do_machine_check(struct pt_r
 
 extern int mce_notify_user(void);
 
+extern void stop_mce(void);
+extern void restart_mce(void);
+
 #endif
 
 #endif
Index: linux/include/asm-x86_64/nmi.h
===================================================================
--- linux.orig/include/asm-x86_64/nmi.h
+++ linux/include/asm-x86_64/nmi.h
@@ -88,5 +88,7 @@ unsigned lapic_adjust_nmi_hz(unsigned hz
 int lapic_watchdog_ok(void);
 void disable_lapic_nmi_watchdog(void);
 void enable_lapic_nmi_watchdog(void);
+void stop_nmi(void);
+void restart_nmi(void);
 
 #endif /* ASM_NMI_H */
Index: linux/arch/i386/kernel/traps.c
===================================================================
--- linux.orig/arch/i386/kernel/traps.c
+++ linux/arch/i386/kernel/traps.c
@@ -774,6 +774,8 @@ static __kprobes void default_do_nmi(str
 	reassert_nmi();
 }
 
+static int ignore_nmis;
+
 fastcall __kprobes void do_nmi(struct pt_regs * regs, long error_code)
 {
 	int cpu;
@@ -784,11 +786,24 @@ fastcall __kprobes void do_nmi(struct pt
 
 	++nmi_count(cpu);
 
-	default_do_nmi(regs);
+	if (!ignore_nmis)
+		default_do_nmi(regs);
 
 	nmi_exit();
 }
 
+void stop_nmi(void)
+{
+	ignore_nmis++;
+	acpi_nmi_disable();
+}
+
+void restart_nmi(void)
+{
+	ignore_nmis--;
+	acpi_nmi_enable();
+}
+
 #ifdef CONFIG_KPROBES
 fastcall void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
Index: linux/include/asm-i386/nmi.h
===================================================================
--- linux.orig/include/asm-i386/nmi.h
+++ linux/include/asm-i386/nmi.h
@@ -57,5 +57,7 @@ unsigned lapic_adjust_nmi_hz(unsigned hz
 int lapic_watchdog_ok(void);
 void disable_lapic_nmi_watchdog(void);
 void enable_lapic_nmi_watchdog(void);
+void stop_nmi(void);
+void restart_nmi(void);
 
 #endif /* ASM_NMI_H */
Index: linux/arch/i386/kernel/cpu/mcheck/mce.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mcheck/mce.c
+++ linux/arch/i386/kernel/cpu/mcheck/mce.c
@@ -60,6 +60,20 @@ void mcheck_init(struct cpuinfo_x86 *c)
 	}
 }
 
+static unsigned long old_cr4 __initdata;
+
+void __init stop_mce(void) 
+{
+	old_cr4 = read_cr4();
+	clear_in_cr4(X86_CR4_MCE);
+} 
+
+void __init restart_mce(void)
+{
+	if (old_cr4 & X86_CR4_MCE)
+		set_in_cr4(X86_CR4_MCE);	
+}
+
 static int __init mcheck_disable(char *str)
 {
 	mce_disabled = 1;
