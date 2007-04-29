Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbXD2Kzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbXD2Kzr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756324AbXD2Kxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:53:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756316AbXD2KxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:23 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [32/48] i386: clean up cpu_init()
Message-Id: <20070429105321.C899615108@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>

We now have cpu_init() and secondary_cpu_init() doing nothing but calling
_cpu_init() with the same arguments.  Rename _cpu_init() to cpu_init() and use
it as a replcement for secondary_cpu_init().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/common.c |   34 +++++++++-------------------------
 arch/i386/kernel/smpboot.c    |    8 ++++----
 include/asm-i386/processor.h  |    2 +-
 3 files changed, 14 insertions(+), 30 deletions(-)

Index: linux/arch/i386/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/common.c
+++ linux/arch/i386/kernel/cpu/common.c
@@ -644,9 +644,16 @@ struct i386_pda boot_pda = {
 	.pcurrent = &init_task,
 };
 
-/* Common CPU init for both boot and secondary CPUs */
-static void __cpuinit _cpu_init(int cpu, struct task_struct *curr)
+/*
+ * cpu_init() initializes state that is per-CPU. Some data is already
+ * initialized (naturally) in the bootstrap process, such as the GDT
+ * and IDT. We reload them nevertheless, this function acts as a
+ * 'CPU state barrier', nothing should get across.
+ */
+void __cpuinit cpu_init(void)
 {
+	int cpu = smp_processor_id();
+	struct task_struct *curr = current;
 	struct tss_struct * t = &per_cpu(init_tss, cpu);
 	struct thread_struct *thread = &curr->thread;
 
@@ -706,29 +713,6 @@ static void __cpuinit _cpu_init(int cpu,
 	mxcsr_feature_mask_init();
 }
 
-/* Entrypoint to initialize secondary CPU */
-void __cpuinit secondary_cpu_init(void)
-{
-	int cpu = smp_processor_id();
-	struct task_struct *curr = current;
-
-	_cpu_init(cpu, curr);
-}
-
-/*
- * cpu_init() initializes state that is per-CPU. Some data is already
- * initialized (naturally) in the bootstrap process, such as the GDT
- * and IDT. We reload them nevertheless, this function acts as a
- * 'CPU state barrier', nothing should get across.
- */
-void __cpuinit cpu_init(void)
-{
-	int cpu = smp_processor_id();
-	struct task_struct *curr = current;
-
-	_cpu_init(cpu, curr);
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 void __cpuinit cpu_uninit(void)
 {
Index: linux/arch/i386/kernel/smpboot.c
===================================================================
--- linux.orig/arch/i386/kernel/smpboot.c
+++ linux/arch/i386/kernel/smpboot.c
@@ -378,14 +378,14 @@ set_cpu_sibling_map(int cpu)
 static void __cpuinit start_secondary(void *unused)
 {
 	/*
-	 * Don't put *anything* before secondary_cpu_init(), SMP
-	 * booting is too fragile that we want to limit the
-	 * things done here to the most necessary things.
+	 * Don't put *anything* before cpu_init(), SMP booting is too
+	 * fragile that we want to limit the things done here to the
+	 * most necessary things.
 	 */
 #ifdef CONFIG_VMI
 	vmi_bringup();
 #endif
-	secondary_cpu_init();
+	cpu_init();
 	preempt_disable();
 	smp_callin();
 	while (!cpu_isset(smp_processor_id(), smp_commenced_mask))
Index: linux/include/asm-i386/processor.h
===================================================================
--- linux.orig/include/asm-i386/processor.h
+++ linux/include/asm-i386/processor.h
@@ -744,6 +744,6 @@ extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
 extern void cpu_set_gdt(int);
-extern void secondary_cpu_init(void);
+extern void cpu_init(void);
 
 #endif /* __ASM_I386_PROCESSOR_H */
