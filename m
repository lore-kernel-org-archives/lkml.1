Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbZDOKoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbZDOKoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbZDOKoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:44:21 -0400
Received: from ozlabs.org ([203.10.76.45]:34538 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbZDOKoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:44:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Date: Wed, 15 Apr 2009 20:14:11 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <20090414020544.GA3738@elte.hu> <20090415054417.GA5272@elte.hu>
In-Reply-To: <20090415054417.GA5272@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904152014.11717.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 03:14:17 pm Ingo Molnar wrote:
> No, that warning is back and triggered in overnight testing:
> 
> [   54.888193] BUG: using smp_processor_id() in preemptible [00000000] code: S99local/7753
> [   54.888267] caller is smp_call_function_many+0x29/0x210
> [   54.888309] Pid: 7753, comm: S99local Not tainted 2.6.30-rc1-tip #1750
> [   54.888352] Call Trace:
> [   54.888389]  [<c054d06d>] debug_smp_processor_id+0xcd/0xd0
> [   54.888432]  [<c016e989>] smp_call_function_many+0x29/0x210
> [   54.888477]  [<c0115860>] ? do_drv_write+0x0/0x70
> [   54.888519]  [<c0115851>] drv_write+0x21/0x30
> [   54.888559]  [<c0115e06>] acpi_cpufreq_target+0x146/0x310
> 
> fuller log below. I think this is because smp_call_function_many() 
> was essentially unused before - an IPI function should not trigger 
> this warning, it will naturally be called in preemptible context. 
> 
> Rusty?

Hi Ingo,

   Thanks for the ping, but this code hasn't changed from the original
smp_call_function_mask (I just checked).  Andrew's patch is incorrect.

   The API is screwy.  It excludes the current CPU from the mask,
unconditionally.  It's a tlb flush helper masquerading as a general function.

(smp_call_function has the same issue).

Something like this?

Subject: smp_call_function_many: add explicit exclude_self flag

Impact: clarify and extend confusing API

It's not clear that smp_call_function_many (like smp_call_function)
will exclude the current CPU.  Make it explicit and at the same time
make it generically useful.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/powerpc/mm/tlb_nohash.c |    4 ++--
 arch/sparc/kernel/smp_64.c   |    2 +-
 arch/x86/xen/mmu.c           |    2 +-
 include/linux/smp.h          |    9 +++++----
 kernel/smp.c                 |   41 ++++++++++++++++++++++++++++++-----------
 virt/kvm/kvm_main.c          |    4 ++--
 6 files changed, 41 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/mm/tlb_nohash.c b/arch/powerpc/mm/tlb_nohash.c
--- a/arch/powerpc/mm/tlb_nohash.c
+++ b/arch/powerpc/mm/tlb_nohash.c
@@ -136,7 +136,7 @@ void flush_tlb_mm(struct mm_struct *mm)
 		struct tlb_flush_param p = { .pid = pid };
 		/* Ignores smp_processor_id() even if set. */
 		smp_call_function_many(mm_cpumask(mm),
-				       do_flush_tlb_mm_ipi, &p, 1);
+				       do_flush_tlb_mm_ipi, &p, 1, 1);
 	}
 	_tlbil_pid(pid);
  no_context:
@@ -168,7 +168,7 @@ void flush_tlb_page(struct vm_area_struc
 			struct tlb_flush_param p = { .pid = pid, .addr = vmaddr };
 			/* Ignores smp_processor_id() even if set in cpu_mask */
 			smp_call_function_many(cpu_mask,
-					       do_flush_tlb_page_ipi, &p, 1);
+					       do_flush_tlb_page_ipi, &p, 1, 1);
 		}
 	}
 	_tlbil_va(vmaddr, pid);
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -850,7 +850,7 @@ static void tsb_sync(void *info)
 
 void smp_tsb_sync(struct mm_struct *mm)
 {
-	smp_call_function_many(mm_cpumask(mm), tsb_sync, mm, 1);
+	smp_call_function_many(mm_cpumask(mm), tsb_sync, mm, 1, 1);
 }
 
 extern unsigned long xcall_flush_tlb_mm;
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1161,7 +1161,7 @@ static void xen_drop_mm_ref(struct mm_st
 	}
 
 	if (!cpumask_empty(mask))
-		smp_call_function_many(mask, drop_other_mm_ref, mm, 1);
+		smp_call_function_many(mask, drop_other_mm_ref, mm, 1, 1);
 	free_cpumask_var(mask);
 }
 #else
diff --git a/include/linux/smp.h b/include/linux/smp.h
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -71,14 +71,15 @@ extern void smp_cpus_done(unsigned int m
  */
 int smp_call_function(void(*func)(void *info), void *info, int wait);
 void smp_call_function_many(const struct cpumask *mask,
-			    void (*func)(void *info), void *info, bool wait);
+			    void (*func)(void *info), void *info, bool wait,
+			    bool exclude_self);
 
 /* Deprecated: Use smp_call_function_many which takes a pointer to the mask. */
 static inline int
 smp_call_function_mask(cpumask_t mask, void(*func)(void *info), void *info,
 		       int wait)
 {
-	smp_call_function_many(&mask, func, info, wait);
+	smp_call_function_many(&mask, func, info, wait, 1);
 	return 0;
 }
 
@@ -144,9 +145,9 @@ static inline int up_smp_call_function(v
 static inline void smp_send_reschedule(int cpu) { }
 #define num_booting_cpus()			1
 #define smp_prepare_boot_cpu()			do {} while (0)
-#define smp_call_function_mask(mask, func, info, wait) \
+#define smp_call_function_mask(mask, func, info, wait)	\
 			(up_smp_call_function(func, info))
-#define smp_call_function_many(mask, func, info, wait) \
+#define smp_call_function_many(mask, func, info, wait, exclude_self) \
 			(up_smp_call_function(func, info))
 static inline void init_call_single_data(void)
 {
diff --git a/kernel/smp.c b/kernel/smp.c
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <linux/hardirq.h>
 
 static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
 
@@ -349,6 +350,8 @@ void __smp_call_function_single(int cpu,
  * @info: An arbitrary pointer to pass to the function.
  * @wait: If true, wait (atomically) until function has completed
  *        on other CPUs.
+ * @exclude_self: If true, don't call the function on this cpu, even if
+ *        it is set.  This implies preemption is disabled.
  *
  * If @wait is true, then returns once @func has returned. Note that @wait
  * will be implicitly turned on in case of allocation failures, since
@@ -356,30 +359,39 @@ void __smp_call_function_single(int cpu,
  *
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler. Preemption
- * must be disabled when calling this function.
+ * must be disabled when calling this function with @exclude_self set.
  */
 void smp_call_function_many(const struct cpumask *mask,
-			    void (*func)(void *), void *info, bool wait)
+			    void (*func)(void *), void *info,
+			    bool wait, bool exclude_self)
 {
 	struct call_function_data *data;
 	unsigned long flags;
-	int cpu, next_cpu, this_cpu = smp_processor_id();
+	int cpu, next_cpu, this_cpu;
 
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON_ONCE(irqs_disabled() && !oops_in_progress);
+	if (!oops_in_progress) {
+		/* Can deadlock when called with interrupts disabled */
+		WARN_ON_ONCE(irqs_disabled());
 
-	/* So, what's a CPU they want? Ignoring this one. */
+		/* Why exclude the current cpu if you don't know what it is? */
+		WARN_ON_ONCE(exclude_self && !in_atomic());
+	}
+
+	/* Disable preemption if it hasn't been already. */
+	this_cpu = get_cpu();
+
+	/* So, what's a CPU they want?  Possibly ignoring this one. */
 	cpu = cpumask_first_and(mask, cpu_online_mask);
-	if (cpu == this_cpu)
+	if (exclude_self && cpu == this_cpu)
 		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
 
 	/* No online cpus?  We're done. */
 	if (cpu >= nr_cpu_ids)
 		return;
 
-	/* Do we have another CPU which isn't us? */
+	/* Do we have another CPU?  (Which isn't us) */
 	next_cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
-	if (next_cpu == this_cpu)
+	if (exclude_self && next_cpu == this_cpu)
 		next_cpu = cpumask_next_and(next_cpu, mask, cpu_online_mask);
 
 	/* Fastpath: do that cpu by itself. */
@@ -416,12 +428,19 @@ void smp_call_function_many(const struct
 	 */
 	smp_mb();
 
-	/* Send a message to all CPUs in the map */
+	if (!exclude_self && cpumask_test_cpu(this_cpu, data->cpumask)) {
+		local_irq_save(flags);
+		func(info);
+		local_irq_restore(flags);
+	}
+
+	/* Send a message to all CPUs in the map (excludes ourselves) */
 	arch_send_call_function_ipi_mask(data->cpumask);
 
 	/* Optionally wait for the CPUs to complete */
 	if (wait)
 		csd_lock_wait(&data->csd);
+	put_cpu();
 }
 EXPORT_SYMBOL(smp_call_function_many);
 
@@ -444,7 +463,7 @@ EXPORT_SYMBOL(smp_call_function_many);
 int smp_call_function(void (*func)(void *), void *info, int wait)
 {
 	preempt_disable();
-	smp_call_function_many(cpu_online_mask, func, info, wait);
+	smp_call_function_many(cpu_online_mask, func, info, wait, true);
 	preempt_enable();
 
 	return 0;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -592,9 +592,9 @@ static bool make_all_cpus_request(struct
 			cpumask_set_cpu(cpu, cpus);
 	}
 	if (unlikely(cpus == NULL))
-		smp_call_function_many(cpu_online_mask, ack_flush, NULL, 1);
+		smp_call_function_many(cpu_online_mask, ack_flush, NULL, 1, 1);
 	else if (!cpumask_empty(cpus))
-		smp_call_function_many(cpus, ack_flush, NULL, 1);
+		smp_call_function_many(cpus, ack_flush, NULL, 1, 1);
 	else
 		called = false;
 	put_cpu();
