Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbXEAOva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbXEAOva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 10:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbXEAOva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 10:51:30 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:39729 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753132AbXEAOv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:51:28 -0400
Subject: Re: [PATCH] i386: init early_gdt_descr and idle task properly on
	voyager
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4636365F.2060208@goop.org>
References: <4633E507.7070002@goop.org>
	 <1177957615.3674.53.camel@mulgrave.il.steeleye.com>
	 <4636365F.2060208@goop.org>
Content-Type: text/plain
Date: Tue, 01 May 2007 09:51:25 -0500
Message-Id: <1178031085.4320.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 11:33 -0700, Jeremy Fitzhardinge wrote:
> Yep.  I fixed this up in a later pair of patches:
> "i386-common-smp.patch" and
> "i386-fix-voyager-build.patch".
> 
> Does it work for you when you do this?

Not quite ... the voyager build fix doesn't quite fix the build.  The
attached is what I need to fully build and boot voyager

James

---
Subject: i386: fix voyager build

This adds an smp_ops for voyager, and hooks things up appropriately.
This is the first baby-step to making subarch runtime switchable.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>

---
 arch/i386/mach-voyager/voyager_smp.c |   73 ++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 29 deletions(-)

===================================================================
Index: voyager-2.6/arch/i386/mach-voyager/voyager_smp.c
===================================================================
--- voyager-2.6.orig/arch/i386/mach-voyager/voyager_smp.c	2007-05-01 09:21:24.000000000 -0500
+++ voyager-2.6/arch/i386/mach-voyager/voyager_smp.c	2007-05-01 09:36:47.000000000 -0500
@@ -28,7 +28,6 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/arch_hooks.h>
-#include <asm/pda.h>
 
 /* TLB state -- visible externally, indexed physically */
 DEFINE_PER_CPU(struct tlb_state, cpu_tlbstate) ____cacheline_aligned = { &init_mm, 0 };
@@ -423,7 +422,7 @@ find_smp_config(void)
 	     VOYAGER_SUS_IN_CONTROL_PORT);
 
 	current_thread_info()->cpu = boot_cpu_id;
-	write_pda(cpu_number, boot_cpu_id);
+	x86_write_percpu(cpu_number, boot_cpu_id);
 }
 
 /*
@@ -436,7 +435,7 @@ smp_store_cpu_info(int id)
 
 	*c = boot_cpu_data;
 
-	identify_cpu(c);
+	identify_secondary_cpu(c);
 }
 
 /* set up the trampoline and return the physical address of the code */
@@ -460,7 +459,7 @@ start_secondary(void *unused)
 	/* external functions not defined in the headers */
 	extern void calibrate_delay(void);
 
-	secondary_cpu_init();
+	cpu_init();
 
 	/* OK, we're in the routine */
 	ack_CPI(VIC_CPU_BOOT_CPI);
@@ -571,7 +570,9 @@ do_boot_cpu(__u8 cpu)
 	/* init_tasks (in sched.c) is indexed logically */
 	stack_start.esp = (void *) idle->thread.esp;
 
-	init_gdt(cpu, idle);
+	init_gdt(cpu);
+ 	per_cpu(current_task, cpu) = idle;
+	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	irq_ctx_init(cpu);
 
 	/* Note: Don't modify initial ss override */
@@ -858,8 +859,8 @@ smp_invalidate_interrupt(void)
 
 /* This routine is called with a physical cpu mask */
 static void
-flush_tlb_others (unsigned long cpumask, struct mm_struct *mm,
-						unsigned long va)
+voyager_flush_tlb_others (unsigned long cpumask, struct mm_struct *mm,
+			  unsigned long va)
 {
 	int stuck = 50000;
 
@@ -911,7 +912,7 @@ flush_tlb_current_task(void)
 	cpu_mask = cpus_addr(mm->cpu_vm_mask)[0] & ~(1 << smp_processor_id());
 	local_flush_tlb();
 	if (cpu_mask)
-		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
+		voyager_flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
 
 	preempt_enable();
 }
@@ -933,7 +934,7 @@ flush_tlb_mm (struct mm_struct * mm)
 			leave_mm(smp_processor_id());
 	}
 	if (cpu_mask)
-		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
+		voyager_flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
 
 	preempt_enable();
 }
@@ -954,7 +955,7 @@ void flush_tlb_page(struct vm_area_struc
 	}
 
 	if (cpu_mask)
-		flush_tlb_others(cpu_mask, mm, va);
+		voyager_flush_tlb_others(cpu_mask, mm, va);
 
 	preempt_enable();
 }
@@ -1043,11 +1044,12 @@ smp_call_function_interrupt(void)
 }
 
 static int
-__smp_call_function_mask (void (*func) (void *info), void *info, int retry,
-			  int wait, __u32 mask)
+voyager_smp_call_function_mask (cpumask_t cpumask, void (*func) (void *info),
+				void *info, int wait)
 {
 	struct call_data_struct data;
 
+	u32 mask = cpus_addr(cpumask)[0];
 	mask &= ~(1<<smp_processor_id());
 
 	if (!mask)
@@ -1082,47 +1084,6 @@ __smp_call_function_mask (void (*func) (
 	return 0;
 }
 
-/* Call this function on all CPUs using the function_interrupt above
-    <func> The function to run. This must be fast and non-blocking.
-    <info> An arbitrary pointer to pass to the function.
-    <retry> If true, keep retrying until ready.
-    <wait> If true, wait until function has completed on other CPUs.
-    [RETURNS] 0 on success, else a negative status code. Does not return until
-    remote CPUs are nearly ready to execute <<func>> or are or have executed.
-*/
-int
-smp_call_function(void (*func) (void *info), void *info, int retry,
-		   int wait)
-{
-	__u32 mask = cpus_addr(cpu_online_map)[0];
-
-	return __smp_call_function_mask(func, info, retry, wait, mask);
-}
-EXPORT_SYMBOL(smp_call_function);
-
-/*
- * smp_call_function_single - Run a function on another CPU
- * @func: The function to run. This must be fast and non-blocking.
- * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: Currently unused.
- * @wait: If true, wait until function has completed on other CPUs.
- *
- * Retrurns 0 on success, else a negative status code.
- *
- * Does not return until the remote CPU is nearly ready to execute <func>
- * or is or has executed.
- */
-
-int
-smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			 int nonatomic, int wait)
-{
-	__u32 mask = 1 << cpu;
-
-	return __smp_call_function_mask(func, info, nonatomic, wait, mask);
-}
-EXPORT_SYMBOL(smp_call_function_single);
-
 /* Sorry about the name.  In an APIC based system, the APICs
  * themselves are programmed to send a timer interrupt.  This is used
  * by linux to reschedule the processor.  Voyager doesn't have this,
@@ -1236,8 +1197,8 @@ smp_alloc_memory(void)
 }
 
 /* send a reschedule CPI to one CPU by physical CPU number*/
-void
-smp_send_reschedule(int cpu)
+static void
+voyager_smp_send_reschedule(int cpu)
 {
 	send_one_CPI(cpu, VIC_RESCHEDULE_CPI);
 }
@@ -1266,8 +1227,8 @@ safe_smp_processor_id(void)
 }
 
 /* broadcast a halt to all other CPUs */
-void
-smp_send_stop(void)
+static void
+voyager_smp_send_stop(void)
 {
 	smp_call_function(smp_stop_cpu_function, NULL, 1, 1);
 }
@@ -1929,23 +1890,26 @@ smp_voyager_power_off(void *dummy)
 		smp_stop_cpu_function(NULL);
 }
 
-void __init
-smp_prepare_cpus(unsigned int max_cpus)
+static void __init
+voyager_smp_prepare_cpus(unsigned int max_cpus)
 {
 	/* FIXME: ignore max_cpus for now */
 	smp_boot_cpus();
 }
 
-void __devinit smp_prepare_boot_cpu(void)
+static void __devinit voyager_smp_prepare_boot_cpu(void)
 {
+	init_gdt(smp_processor_id());
+	switch_to_new_gdt();
+
 	cpu_set(smp_processor_id(), cpu_online_map);
 	cpu_set(smp_processor_id(), cpu_callout_map);
 	cpu_set(smp_processor_id(), cpu_possible_map);
 	cpu_set(smp_processor_id(), cpu_present_map);
 }
 
-int __devinit
-__cpu_up(unsigned int cpu)
+static int __devinit
+voyager_cpu_up(unsigned int cpu)
 {
 	/* This only works at boot for x86.  See "rewrite" above. */
 	if (cpu_isset(cpu, smp_commenced_mask))
@@ -1961,8 +1925,8 @@ __cpu_up(unsigned int cpu)
 	return 0;
 }
 
-void __init 
-smp_cpus_done(unsigned int max_cpus)
+static void __init
+voyager_smp_cpus_done(unsigned int max_cpus)
 {
 	zap_low_mappings();
 }
@@ -1971,5 +1935,16 @@ void __init
 smp_setup_processor_id(void)
 {
 	current_thread_info()->cpu = hard_smp_processor_id();
-	write_pda(cpu_number, hard_smp_processor_id());
+	x86_write_percpu(cpu_number, hard_smp_processor_id());
 }
+
+struct smp_ops smp_ops = {
+	.smp_prepare_boot_cpu = voyager_smp_prepare_boot_cpu,
+	.smp_prepare_cpus = voyager_smp_prepare_cpus,
+	.cpu_up = voyager_cpu_up,
+	.smp_cpus_done = voyager_smp_cpus_done,
+
+	.smp_send_stop = voyager_smp_send_stop,
+	.smp_send_reschedule = voyager_smp_send_reschedule,
+	.smp_call_function_mask = voyager_smp_call_function_mask,
+};


