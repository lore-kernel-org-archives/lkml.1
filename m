Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbYAPWdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbYAPWdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757367AbYAPW1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:27:12 -0500
Received: from ns2.suse.de ([195.135.220.15]:39475 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393AbYAPW1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:27:11 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161127.268350000@suse.de>
In-Reply-To: <200801161127.268350000@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/7] Optimize lock prefix switching to run less frequently v2
Message-Id: <20080116222709.AE852150CA@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:27:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On VMs implemented using JITs that cache translated code changing the lock 
prefixes is a quite costly operation that forces the JIT to throw away and 
retranslate a lot of code. 

Previously a SMP kernel would rewrite the locks once for each CPU which
is quite unnecessary. This patch changes the code to never switch at boot in
 the normal case (SMP kernel booting with >1 CPU) or only once for SMP kernel 
on UP.

This makes a significant difference in boot up performance on AMD SimNow!
Also I expect it to be a little faster on native systems too because a smp 
switch does a lot of text_poke()s which each synchronize the pipeline.

v1->v2: Rename max_cpus 
v1->v2: Fix off by one in UP check (Thomas Gleixner)

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/alternative.c |   16 ++++++++++++++--
 include/linux/smp.h           |    2 ++
 init/main.c                   |   16 ++++++++--------
 3 files changed, 24 insertions(+), 10 deletions(-)

Index: linux/arch/x86/kernel/alternative.c
===================================================================
--- linux.orig/arch/x86/kernel/alternative.c
+++ linux/arch/x86/kernel/alternative.c
@@ -273,6 +273,7 @@ struct smp_alt_module {
 };
 static LIST_HEAD(smp_alt_modules);
 static DEFINE_SPINLOCK(smp_alt);
+static int smp_mode = 1;	/* protected by smp_alt */
 
 void alternatives_smp_module_add(struct module *mod, char *name,
 				 void *locks, void *locks_end,
@@ -354,7 +355,14 @@ void alternatives_smp_switch(int smp)
 	BUG_ON(!smp && (num_online_cpus() > 1));
 
 	spin_lock_irqsave(&smp_alt, flags);
-	if (smp) {
+
+	/*
+	 * Avoid unnecessary switches because it forces JIT based VMs to
+	 * throw away all cached translations, which can be quite costly.
+	 */
+	if (smp == smp_mode) {
+		/* nothing */
+	} else if (smp) {
 		printk(KERN_INFO "SMP alternatives: switching to SMP code\n");
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_UP);
 		clear_cpu_cap(&cpu_data(0), X86_FEATURE_UP);
@@ -369,6 +377,7 @@ void alternatives_smp_switch(int smp)
 			alternatives_smp_unlock(mod->locks, mod->locks_end,
 						mod->text, mod->text_end);
 	}
+	smp_mode = smp;
 	spin_unlock_irqrestore(&smp_alt, flags);
 }
 
@@ -441,7 +450,10 @@ void __init alternative_instructions(voi
 		alternatives_smp_module_add(NULL, "core kernel",
 					    __smp_locks, __smp_locks_end,
 					    _text, _etext);
-		alternatives_smp_switch(0);
+
+		/* Only switch to UP mode if we don't immediately boot others */
+		if (num_possible_cpus() == 1 || setup_max_cpus <= 1)
+			alternatives_smp_switch(0);
 	}
 #endif
  	apply_paravirt(__parainstructions, __parainstructions_end);
Index: linux/include/linux/smp.h
===================================================================
--- linux.orig/include/linux/smp.h
+++ linux/include/linux/smp.h
@@ -78,6 +78,8 @@ int on_each_cpu(void (*func) (void *info
  */
 void smp_prepare_boot_cpu(void);
 
+extern unsigned int setup_max_cpus;
+
 #else /* !SMP */
 
 /*
Index: linux/init/main.c
===================================================================
--- linux.orig/init/main.c
+++ linux/init/main.c
@@ -128,7 +128,7 @@ static char *ramdisk_execute_command;
 
 #ifdef CONFIG_SMP
 /* Setup configured maximum number of CPUs to activate */
-static unsigned int __initdata max_cpus = NR_CPUS;
+unsigned int __initdata setup_max_cpus = NR_CPUS;
 
 /*
  * Setup routine for controlling SMP activation
@@ -146,7 +146,7 @@ static inline void disable_ioapic_setup(
 
 static int __init nosmp(char *str)
 {
-	max_cpus = 0;
+	setup_max_cpus = 0;
 	disable_ioapic_setup();
 	return 0;
 }
@@ -155,8 +155,8 @@ early_param("nosmp", nosmp);
 
 static int __init maxcpus(char *str)
 {
-	get_option(&str, &max_cpus);
-	if (max_cpus == 0)
+	get_option(&str, &setup_max_cpus);
+	if (setup_max_cpus == 0)
 		disable_ioapic_setup();
 
 	return 0;
@@ -164,7 +164,7 @@ static int __init maxcpus(char *str)
 
 early_param("maxcpus", maxcpus);
 #else
-#define max_cpus NR_CPUS
+#define setup_max_cpus NR_CPUS
 #endif
 
 /*
@@ -393,7 +393,7 @@ static void __init smp_init(void)
 
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
-		if (num_online_cpus() >= max_cpus)
+		if (num_online_cpus() >= setup_max_cpus)
 			break;
 		if (!cpu_online(cpu))
 			cpu_up(cpu);
@@ -401,7 +401,7 @@ static void __init smp_init(void)
 
 	/* Any cleanup work */
 	printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
-	smp_cpus_done(max_cpus);
+	smp_cpus_done(setup_max_cpus);
 }
 
 #endif
@@ -823,7 +823,7 @@ static int __init kernel_init(void * unu
 	__set_special_pids(1, 1);
 	cad_pid = task_pid(current);
 
-	smp_prepare_cpus(max_cpus);
+	smp_prepare_cpus(setup_max_cpus);
 
 	do_pre_smp_initcalls();
 
