Return-Path: <linux-kernel-owner+w=401wt.eu-S1031399AbXDJS2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031399AbXDJS2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 14:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031400AbXDJS2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 14:28:14 -0400
Received: from ns.suse.de ([195.135.220.2]:33559 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031399AbXDJS2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 14:28:13 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] x86_64: prevent auto select of mwait_idle for AMD CPUs
Date: Tue, 10 Apr 2007 20:11:18 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20070410172425.GE24680@alberich.amd.com>
In-Reply-To: <20070410172425.GE24680@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704102011.18752.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 April 2007 19:24:25 Andreas Herrmann wrote:
> This fix is needed for AMD family 10h CPUs.
> 
> It prevents auto select of mwait_idle for AMD CPUs.
> MWAIT does not enter C-states on family 10h and more
> power saving is reached by entering C1 with
> default_idle.
> 
> The patch also adds an idle=mwait command line option
> to select mwait_idle for benchmarking.

I already did my own patch earlier. Applied for reference.

-Andi
Don't use MWAIT on AMD Family 10/11

It doesn't put the CPU into deeper sleep states, so it's better to use the standard
idle loop to save power. But allow to reenable it anyways for benchmarking.

I also removed the obsolete idle=halt

Signed-off-by: Andi Kleen <ak@suse.de>

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
@@ -22,6 +22,8 @@
 extern void vide(void);
 __asm__(".align 4\nvide: ret");
 
+int force_mwait __initdata;
+
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
@@ -241,6 +243,9 @@ static void __cpuinit init_amd(struct cp
 
 	if (cpuid_eax(0x80000000) >= 0x80000006)
 		num_cache_leaves = 3;
+
+	if ((c->x86 == 0x10 || c->x86 == 0x11) && !force_mwait)
+		clear_bit(X86_FEATURE_MWAIT, &c->x86_capability);
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
 
+int force_mwait __initdata;
+
 /* 
  * Early DMI memory
  */
@@ -604,6 +606,10 @@ static void __cpuinit init_amd(struct cp
 
 	/* RDTSC can be speculated around */
 	clear_bit(X86_FEATURE_SYNC_RDTSC, &c->x86_capability);
+
+	/* Family 10/11 don't support C states in MWAIT so don't use it */ 
+	if ((c->x86 == 0x10 || c->x86 == 0x11) && !force_mwait) 
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
