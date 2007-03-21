Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbXCUGhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbXCUGhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 02:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXCUGhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 02:37:20 -0400
Received: from ozlabs.org ([203.10.76.45]:51600 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbXCUGhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 02:37:18 -0400
Subject: [PATCH 3/4] i386 GDT cleanups: clean up cpu_init()
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1174458938.11680.150.camel@localhost.localdomain>
References: <1174457426.11680.132.camel@localhost.localdomain>
	 <1174458636.11680.143.camel@localhost.localdomain>
	 <1174458730.11680.145.camel@localhost.localdomain>
	 <1174458938.11680.150.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 17:36:54 +1100
Message-Id: <1174459014.11680.153.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We now have cpu_init() and secondary_cpu_init() doing nothing but
calling _cpu_init() with the same arguments.  Rename _cpu_init() to
cpu_init() and use it as a replcement for secondary_cpu_init().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

---
 arch/i386/kernel/cpu/common.c |   36 ++++++++++--------------------------
 arch/i386/kernel/smpboot.c    |   10 +++++-----
 include/asm-i386/processor.h  |    3 ++-
 3 files changed, 17 insertions(+), 32 deletions(-)

diff -r 18694148c020 arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c	Wed Mar 21 17:15:19 2007 +1100
+++ b/arch/i386/kernel/cpu/common.c	Wed Mar 21 17:18:37 2007 +1100
@@ -644,9 +644,16 @@ struct i386_pda boot_pda = {
 	.pcurrent = &init_task,
 };
 
-/* Common CPU init for both boot and secondary CPUs */
-static void __cpuinit _cpu_init(int cpu, struct task_struct *curr)
-{
+/*
+ * cpu_init() initializes state that is per-CPU. Some data is already
+ * initialized (naturally) in the bootstrap process, such as the GDT
+ * and IDT. We reload them nevertheless, this function acts as a
+ * 'CPU state barrier', nothing should get across.
+ */
+void __cpuinit cpu_init(void)
+{
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
diff -r 18694148c020 arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c	Wed Mar 21 17:15:19 2007 +1100
+++ b/arch/i386/kernel/smpboot.c	Wed Mar 21 17:18:37 2007 +1100
@@ -378,14 +378,14 @@ static void __cpuinit start_secondary(vo
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
diff -r 18694148c020 include/asm-i386/processor.h
--- a/include/asm-i386/processor.h	Wed Mar 21 17:15:19 2007 +1100
+++ b/include/asm-i386/processor.h	Wed Mar 21 17:18:37 2007 +1100
@@ -744,6 +744,6 @@ extern int sysenter_setup(void);
 extern int sysenter_setup(void);
 
 extern void cpu_set_gdt(int);
-extern void secondary_cpu_init(void);
+extern void cpu_init(void);
 
 #endif /* __ASM_I386_PROCESSOR_H */


