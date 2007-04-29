Return-Path: <linux-kernel-owner+w=401wt.eu-S1161616AbXD2Xt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161616AbXD2Xt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161599AbXD2XrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:47:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:38472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161598AbXD2Xq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:26 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: andreas.herrmann@amd.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [15/26] x86: Don't use MWAIT on AMD Family 10
Message-Id: <20070429234624.AF710150F2@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It doesn't put the CPU into deeper sleep states, so it's better to use the standard
idle loop to save power. But allow to reenable it anyways for benchmarking.

I also removed the obsolete idle=halt on i386

Cc: andreas.herrmann@amd.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 Documentation/kernel-parameters.txt |   11 +++++++++--
 arch/i386/kernel/cpu/amd.c          |    5 +++++
 arch/i386/kernel/process.c          |   17 ++++++++---------
 arch/x86_64/kernel/process.c        |   12 +++++++-----
 arch/x86_64/kernel/setup.c          |    6 ++++++
 include/asm-i386/processor.h        |    2 ++
 include/asm-x86_64/proto.h          |    2 ++
 7 files changed, 39 insertions(+), 16 deletions(-)

Index: linux/Documentation/kernel-parameters.txt
===================================================================
--- linux.orig/Documentation/kernel-parameters.txt
+++ linux/Documentation/kernel-parameters.txt
@@ -673,8 +673,15 @@ and is between 256 and 4096 characters. 
 	idebus=		[HW] (E)IDE subsystem - VLB/PCI bus speed
 			See Documentation/ide.txt.
 
-	idle=		[HW]
-			Format: idle=poll or idle=halt
+	idle=		[X86]
+			Format: idle=poll or idle=mwait
+			Poll forces a polling idle loop that can slightly improves the performance
+			of waking up a idle CPU, but will use a lot of power and make the system
+			run hot. Not recommended.
+			idle=mwait. On systems which support MONITOR/MWAIT but the kernel chose
+			to not use it because it doesn't save as much power as a normal idle
+			loop use the MONITOR/MWAIT idle loop anyways. Performance should be the same
+			as idle=poll.
 
 	ignore_loglevel	[KNL]
 			Ignore loglevel setting - this will print /all/
Index: linux/arch/i386/kernel/cpu/amd.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/amd.c
+++ linux/arch/i386/kernel/cpu/amd.c
@@ -53,6 +53,8 @@ static __cpuinit int amd_apic_timer_brok
 	return 0;
 }
 
+int force_mwait __cpuinitdata;
+
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
@@ -275,6 +277,9 @@ static void __cpuinit init_amd(struct cp
 
 	if (amd_apic_timer_broken())
 		set_bit(X86_FEATURE_LAPIC_TIMER_BROKEN, c->x86_capability);
+
+	if (c->x86 == 0x10 && !force_mwait)
+		clear_bit(X86_FEATURE_MWAIT, c->x86_capability);
 }
 
 static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 * c, unsigned int size)
Index: linux/arch/i386/kernel/process.c
===================================================================
--- linux.orig/arch/i386/kernel/process.c
+++ linux/arch/i386/kernel/process.c
@@ -272,25 +272,24 @@ void __devinit select_idle_routine(const
 	}
 }
 
-static int __init idle_setup (char *str)
+static int __init idle_setup(char *str)
 {
-	if (!strncmp(str, "poll", 4)) {
+	if (!strcmp(str, "poll")) {
 		printk("using polling idle threads.\n");
 		pm_idle = poll_idle;
 #ifdef CONFIG_X86_SMP
 		if (smp_num_siblings > 1)
 			printk("WARNING: polling idle and HT enabled, performance may degrade.\n");
 #endif
-	} else if (!strncmp(str, "halt", 4)) {
-		printk("using halt in idle threads.\n");
-		pm_idle = default_idle;
-	}
+	} else if (!strcmp(str, "mwait"))
+		force_mwait = 1;
+	else
+		return -1;
 
 	boot_option_idle_override = 1;
-	return 1;
+	return 0;
 }
-
-__setup("idle=", idle_setup);
+early_param("idle", idle_setup);
 
 void show_regs(struct pt_regs * regs)
 {
Index: linux/arch/x86_64/kernel/process.c
===================================================================
--- linux.orig/arch/x86_64/kernel/process.c
+++ linux/arch/x86_64/kernel/process.c
@@ -288,16 +288,18 @@ void __cpuinit select_idle_routine(const
 
 static int __init idle_setup (char *str)
 {
-	if (!strncmp(str, "poll", 4)) {
+	if (!strcmp(str, "poll")) {
 		printk("using polling idle threads.\n");
 		pm_idle = poll_idle;
-	}
+	} else if (!strcmp(str, "mwait"))
+		force_mwait = 1;
+	else
+		return -1;
 
 	boot_option_idle_override = 1;
-	return 1;
+	return 0;
 }
-
-__setup("idle=", idle_setup);
+early_param("idle", idle_setup);
 
 /* Prints also some state that isn't saved in the pt_regs */ 
 void __show_regs(struct pt_regs * regs)
Index: linux/arch/x86_64/kernel/setup.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup.c
+++ linux/arch/x86_64/kernel/setup.c
@@ -79,6 +79,8 @@ int bootloader_type;
 
 unsigned long saved_video_mode;
 
+int force_mwait __cpuinitdata;
+
 /* 
  * Early DMI memory
  */
@@ -604,6 +606,10 @@ static void __cpuinit init_amd(struct cp
 
 	/* RDTSC can be speculated around */
 	clear_bit(X86_FEATURE_SYNC_RDTSC, &c->x86_capability);
+
+	/* Family 10 doesn't support C states in MWAIT so don't use it */
+	if (c->x86 == 0x10 && !force_mwait)
+		clear_bit(X86_FEATURE_MWAIT, &c->x86_capability);
 }
 
 static void __cpuinit detect_ht(struct cpuinfo_x86 *c)
Index: linux/include/asm-i386/processor.h
===================================================================
--- linux.orig/include/asm-i386/processor.h
+++ linux/include/asm-i386/processor.h
@@ -779,4 +779,6 @@ extern int sysenter_setup(void);
 extern void cpu_set_gdt(int);
 extern void cpu_init(void);
 
+extern int force_mwait;
+
 #endif /* __ASM_I386_PROCESSOR_H */
Index: linux/include/asm-x86_64/proto.h
===================================================================
--- linux.orig/include/asm-x86_64/proto.h
+++ linux/include/asm-x86_64/proto.h
@@ -119,6 +119,8 @@ extern int gsi_irq_sharing(int gsi);
 
 extern void smp_local_timer_interrupt(void);
 
+extern int force_mwait;
+
 long do_arch_prctl(struct task_struct *task, int code, unsigned long addr);
 
 void i8254_timer_resume(void);
