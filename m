Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbYH2Mm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbYH2Mm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 08:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbYH2MmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 08:42:19 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58189 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750934AbYH2MmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 08:42:17 -0400
Message-ID: <48B7EEA2.7090300@sgi.com>
Date: Fri, 29 Aug 2008 14:42:10 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: travis@sgi.com, mingo@elte.hu, torvalds@linux-foundation.org,
       Alan.Brunelle@hp.com, tglx@linutronix.de, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       akpm@linux-foundation.org, arjan@linux.intel.com, rusty@rustcorp.com.au
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <20080826072220.GB31876@elte.hu> <20080826.004607.253712060.davem@davemloft.net> <48B4542A.1050004@sgi.com> <20080826.134535.193703558.davem@davemloft.net>
In-Reply-To: <20080826.134535.193703558.davem@davemloft.net>
Content-Type: multipart/mixed;
 boundary="------------000105070102070306040301"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000105070102070306040301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

David Miller wrote:
>>> Otherwise you have to modify cpumask_t objects and thus pluck
>>> them onto the stack where they take up silly amounts of space.
>> Yes, I had proposed either modifying, or supplementing a new
>> smp_call function to pass the cpumask_t as a pointer (similar
>> to set_cpus_allowed_ptr.)  But an ABI change such as this was
>> not well received at the time.
> 
> What it seems to come down to is that any cpumask_t not inside of
> a dynamically allocated object should be marked const.
> 
> And that is something we can enforce at compile time.
> 
> Linus has just suggested dynamically allocating cpumask_t's
> for such cases but I don't see that as the fix either.
> 
> Just mark them const and enforce that cpumask_t objects can only
> be modified when they appear in dynamically allocated objects.

Dave and others,

Sorry if I jump into the middle of the thread. Stopped subscribing to
lkml for a while, so this is through the archives.

Ran into some of these issues with KVM too, and noticed just how much
we pass cpumask_t around in the smp_call functions :-( In fact, the
only arch that did pretty well on this front was sparc64.

I totally agree, that marking them const makes a ton of sense, but at
the same time I suggest we convert smp_call_function_mask() to take a
pointer to the cpumask_t. I whipped up the following patch, which cuts
down the amont of memcpy calls emitted quite a fair bit.

I have only tested this on ia64, but it boots, so it's obviously
perfect<tm> :-)

Comments, suggestions welcome.

I have a followup patch that makes virt/kvm/kvm_main.c use the new
interface.

Cheers,
Jes


--------------000105070102070306040301
Content-Type: text/plain;
 name="0040-smp-call-cpumask.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0040-smp-call-cpumask.patch"

Change smp_call_function_mask() to take a pointer to the cpumask_t
rather than passing it by value. This avoids recursive copies of the
cpumask_t on the stack in the IPI call. For large NR_CPUS, this is
particularly bad, and the cost of doing this for
NR_CPUS < bits_per_long is negligeble.

Signed-off-by: Jes Sorensen <jes@sgi.com>

---
 arch/alpha/include/asm/smp.h    |    2 +-
 arch/alpha/kernel/smp.c         |    4 ++--
 arch/arm/include/asm/smp.h      |    2 +-
 arch/arm/kernel/smp.c           |    4 ++--
 arch/ia64/include/asm/smp.h     |    2 +-
 arch/ia64/kernel/smp.c          |    6 +++---
 arch/m32r/kernel/smp.c          |    4 ++--
 arch/mips/kernel/smp.c          |    4 ++--
 arch/parisc/kernel/smp.c        |    6 +++---
 arch/powerpc/include/asm/smp.h  |    2 +-
 arch/powerpc/kernel/smp.c       |    4 ++--
 arch/sh/include/asm/smp.h       |    2 +-
 arch/sh/kernel/smp.c            |    4 ++--
 arch/sparc/include/asm/smp_64.h |    2 +-
 arch/sparc64/kernel/smp.c       |    4 ++--
 include/asm-m32r/smp.h          |    2 +-
 include/asm-mips/smp.h          |    2 +-
 include/asm-parisc/smp.h        |    2 +-
 include/asm-x86/smp.h           |    4 ++--
 include/linux/smp.h             |    2 +-
 kernel/smp.c                    |   15 ++++++++-------
 virt/kvm/kvm_main.c             |    4 ++--
 22 files changed, 42 insertions(+), 41 deletions(-)

Index: linux-2.6.git/arch/alpha/include/asm/smp.h
===================================================================
--- linux-2.6.git.orig/arch/alpha/include/asm/smp.h
+++ linux-2.6.git/arch/alpha/include/asm/smp.h
@@ -48,7 +48,7 @@
 #define cpu_possible_map	cpu_present_map
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi(cpumask_t *mask);
 
 #else /* CONFIG_SMP */
 
Index: linux-2.6.git/arch/alpha/kernel/smp.c
===================================================================
--- linux-2.6.git.orig/arch/alpha/kernel/smp.c
+++ linux-2.6.git/arch/alpha/kernel/smp.c
@@ -637,9 +637,9 @@
 	send_ipi_message(to_whom, IPI_CPU_STOP);
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi(cpumask_t *mask)
 {
-	send_ipi_message(mask, IPI_CALL_FUNC);
+	send_ipi_message(*mask, IPI_CALL_FUNC);
 }
 
 void arch_send_call_function_single_ipi(int cpu)
Index: linux-2.6.git/arch/arm/include/asm/smp.h
===================================================================
--- linux-2.6.git.orig/arch/arm/include/asm/smp.h
+++ linux-2.6.git/arch/arm/include/asm/smp.h
@@ -102,7 +102,7 @@
 extern void platform_cpu_enable(unsigned int cpu);
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi(cpumask_t *mask);
 
 /*
  * Local timer interrupt handling function (can be IPI'ed).
Index: linux-2.6.git/arch/arm/kernel/smp.c
===================================================================
--- linux-2.6.git.orig/arch/arm/kernel/smp.c
+++ linux-2.6.git/arch/arm/kernel/smp.c
@@ -356,9 +356,9 @@
 	local_irq_restore(flags);
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi(cpumask_t *mask)
 {
-	send_ipi_message(mask, IPI_CALL_FUNC);
+	send_ipi_message(*mask, IPI_CALL_FUNC);
 }
 
 void arch_send_call_function_single_ipi(int cpu)
Index: linux-2.6.git/arch/ia64/include/asm/smp.h
===================================================================
--- linux-2.6.git.orig/arch/ia64/include/asm/smp.h
+++ linux-2.6.git/arch/ia64/include/asm/smp.h
@@ -127,7 +127,7 @@
 extern int is_multithreading_enabled(void);
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi(cpumask_t *mask);
 
 #else /* CONFIG_SMP */
 
Index: linux-2.6.git/arch/ia64/kernel/smp.c
===================================================================
--- linux-2.6.git.orig/arch/ia64/kernel/smp.c
+++ linux-2.6.git/arch/ia64/kernel/smp.c
@@ -166,11 +166,11 @@
  * Called with preemption disabled.
  */
 static inline void
-send_IPI_mask(cpumask_t mask, int op)
+send_IPI_mask(cpumask_t *mask, int op)
 {
 	unsigned int cpu;
 
-	for_each_cpu_mask(cpu, mask) {
+	for_each_cpu_mask(cpu, *mask) {
 			send_IPI_single(cpu, op);
 	}
 }
@@ -316,7 +316,7 @@
 	send_IPI_single(cpu, IPI_CALL_FUNC_SINGLE);
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi(cpumask_t *mask)
 {
 	send_IPI_mask(mask, IPI_CALL_FUNC);
 }
Index: linux-2.6.git/arch/m32r/kernel/smp.c
===================================================================
--- linux-2.6.git.orig/arch/m32r/kernel/smp.c
+++ linux-2.6.git/arch/m32r/kernel/smp.c
@@ -546,9 +546,9 @@
 	for ( ; ; );
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi(cpumask_t *mask)
 {
-	send_IPI_mask(mask, CALL_FUNCTION_IPI, 0);
+	send_IPI_mask(*mask, CALL_FUNCTION_IPI, 0);
 }
 
 void arch_send_call_function_single_ipi(int cpu)
Index: linux-2.6.git/arch/mips/kernel/smp.c
===================================================================
--- linux-2.6.git.orig/arch/mips/kernel/smp.c
+++ linux-2.6.git/arch/mips/kernel/smp.c
@@ -131,9 +131,9 @@
 	cpu_idle();
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi(cpumask_t *mask)
 {
-	mp_ops->send_ipi_mask(mask, SMP_CALL_FUNCTION);
+	mp_ops->send_ipi_mask(*mask, SMP_CALL_FUNCTION);
 }
 
 /*
Index: linux-2.6.git/arch/parisc/kernel/smp.c
===================================================================
--- linux-2.6.git.orig/arch/parisc/kernel/smp.c
+++ linux-2.6.git/arch/parisc/kernel/smp.c
@@ -228,11 +228,11 @@
 }
 
 static void
-send_IPI_mask(cpumask_t mask, enum ipi_message_type op)
+send_IPI_mask(cpumask_t *mask, enum ipi_message_type op)
 {
 	int cpu;
 
-	for_each_cpu_mask(cpu, mask)
+	for_each_cpu_mask(cpu, *mask)
 		ipi_send(cpu, op);
 }
 
@@ -274,7 +274,7 @@
 	send_IPI_allbutself(IPI_NOP);
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi(cpumask_t *mask)
 {
 	send_IPI_mask(mask, IPI_CALL_FUNC);
 }
Index: linux-2.6.git/arch/powerpc/include/asm/smp.h
===================================================================
--- linux-2.6.git.orig/arch/powerpc/include/asm/smp.h
+++ linux-2.6.git/arch/powerpc/include/asm/smp.h
@@ -119,7 +119,7 @@
 extern struct smp_ops_t *smp_ops;
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi(cpumask_t *mask);
 
 #endif /* __ASSEMBLY__ */
 
Index: linux-2.6.git/arch/powerpc/kernel/smp.c
===================================================================
--- linux-2.6.git.orig/arch/powerpc/kernel/smp.c
+++ linux-2.6.git/arch/powerpc/kernel/smp.c
@@ -135,11 +135,11 @@
 	smp_ops->message_pass(cpu, PPC_MSG_CALL_FUNC_SINGLE);
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi(cpumask_t *mask)
 {
 	unsigned int cpu;
 
-	for_each_cpu_mask(cpu, mask)
+	for_each_cpu_mask(cpu, *mask)
 		smp_ops->message_pass(cpu, PPC_MSG_CALL_FUNCTION);
 }
 
Index: linux-2.6.git/arch/sh/include/asm/smp.h
===================================================================
--- linux-2.6.git.orig/arch/sh/include/asm/smp.h
+++ linux-2.6.git/arch/sh/include/asm/smp.h
@@ -39,7 +39,7 @@
 int plat_register_ipi_handler(unsigned int message,
 			      void (*handler)(void *), void *arg);
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi(cpumask_t *mask);
 
 #else
 
Index: linux-2.6.git/arch/sh/kernel/smp.c
===================================================================
--- linux-2.6.git.orig/arch/sh/kernel/smp.c
+++ linux-2.6.git/arch/sh/kernel/smp.c
@@ -171,11 +171,11 @@
 	smp_call_function(stop_this_cpu, 0, 0);
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi(cpumask_t *mask)
 {
 	int cpu;
 
-	for_each_cpu_mask(cpu, mask)
+	for_each_cpu_mask(cpu, *mask)
 		plat_send_ipi(cpu, SMP_MSG_FUNCTION);
 }
 
Index: linux-2.6.git/arch/sparc/include/asm/smp_64.h
===================================================================
--- linux-2.6.git.orig/arch/sparc/include/asm/smp_64.h
+++ linux-2.6.git/arch/sparc/include/asm/smp_64.h
@@ -35,7 +35,7 @@
 extern int sparc64_multi_core;
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi(cpumask_t *mask);
 
 /*
  *	General functions that each host system must provide.
Index: linux-2.6.git/arch/sparc64/kernel/smp.c
===================================================================
--- linux-2.6.git.orig/arch/sparc64/kernel/smp.c
+++ linux-2.6.git/arch/sparc64/kernel/smp.c
@@ -810,9 +810,9 @@
 
 extern unsigned long xcall_call_function;
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi(cpumask_t *mask)
 {
-	xcall_deliver((u64) &xcall_call_function, 0, 0, &mask);
+	xcall_deliver((u64) &xcall_call_function, 0, 0, mask);
 }
 
 extern unsigned long xcall_call_function_single;
Index: linux-2.6.git/include/asm-m32r/smp.h
===================================================================
--- linux-2.6.git.orig/include/asm-m32r/smp.h
+++ linux-2.6.git/include/asm-m32r/smp.h
@@ -90,7 +90,7 @@
 extern unsigned long send_IPI_mask_phys(cpumask_t, int, int);
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi(cpumask_t *mask);
 
 #endif	/* not __ASSEMBLY__ */
 
Index: linux-2.6.git/include/asm-mips/smp.h
===================================================================
--- linux-2.6.git.orig/include/asm-mips/smp.h
+++ linux-2.6.git/include/asm-mips/smp.h
@@ -58,6 +58,6 @@
 extern asmlinkage void smp_call_function_interrupt(void);
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi(cpumask_t *mask);
 
 #endif /* __ASM_SMP_H */
Index: linux-2.6.git/include/asm-parisc/smp.h
===================================================================
--- linux-2.6.git.orig/include/asm-parisc/smp.h
+++ linux-2.6.git/include/asm-parisc/smp.h
@@ -31,7 +31,7 @@
 extern void smp_send_all_nop(void);
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi(cpumask_t *mask);
 
 #endif /* !ASSEMBLY */
 
Index: linux-2.6.git/include/asm-x86/smp.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/smp.h
+++ linux-2.6.git/include/asm-x86/smp.h
@@ -101,9 +101,9 @@
 	smp_ops.send_call_func_single_ipi(cpu);
 }
 
-static inline void arch_send_call_function_ipi(cpumask_t mask)
+static inline void arch_send_call_function_ipi(cpumask_t *mask)
 {
-	smp_ops.send_call_func_ipi(mask);
+	smp_ops.send_call_func_ipi(*mask);
 }
 
 void native_smp_prepare_boot_cpu(void);
Index: linux-2.6.git/include/linux/smp.h
===================================================================
--- linux-2.6.git.orig/include/linux/smp.h
+++ linux-2.6.git/include/linux/smp.h
@@ -62,7 +62,7 @@
  * Call a function on all other processors
  */
 int smp_call_function(void(*func)(void *info), void *info, int wait);
-int smp_call_function_mask(cpumask_t mask, void(*func)(void *info), void *info,
+int smp_call_function_mask(cpumask_t *mask, void(*func)(void *info), void *info,
 				int wait);
 int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
 				int wait);
Index: linux-2.6.git/kernel/smp.c
===================================================================
--- linux-2.6.git.orig/kernel/smp.c
+++ linux-2.6.git/kernel/smp.c
@@ -318,7 +318,7 @@
  * hardware interrupt handler or from a bottom half handler. Preemption
  * must be disabled when calling this function.
  */
-int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
+int smp_call_function_mask(cpumask_t *mask, void (*func)(void *), void *info,
 			   int wait)
 {
 	struct call_function_data d;
@@ -334,8 +334,8 @@
 	cpu = smp_processor_id();
 	allbutself = cpu_online_map;
 	cpu_clear(cpu, allbutself);
-	cpus_and(mask, mask, allbutself);
-	num_cpus = cpus_weight(mask);
+	cpus_and(*mask, *mask, allbutself);
+	num_cpus = cpus_weight(*mask);
 
 	/*
 	 * If zero CPUs, return. If just a single CPU, turn this request
@@ -344,7 +344,7 @@
 	if (!num_cpus)
 		return 0;
 	else if (num_cpus == 1) {
-		cpu = first_cpu(mask);
+		cpu = first_cpu(*mask);
 		return smp_call_function_single(cpu, func, info, wait);
 	}
 
@@ -364,7 +364,7 @@
 	data->csd.func = func;
 	data->csd.info = info;
 	data->refs = num_cpus;
-	data->cpumask = mask;
+	data->cpumask = *mask;
 
 	spin_lock_irqsave(&call_function_lock, flags);
 	list_add_tail_rcu(&data->csd.list, &call_function_queue);
@@ -377,7 +377,7 @@
 	if (wait) {
 		csd_flag_wait(&data->csd);
 		if (unlikely(slowpath))
-			smp_call_function_mask_quiesce_stack(mask);
+			smp_call_function_mask_quiesce_stack(*mask);
 	}
 
 	return 0;
@@ -402,9 +402,10 @@
 int smp_call_function(void (*func)(void *), void *info, int wait)
 {
 	int ret;
+	cpumask_t tmp_online_map = cpu_online_map;
 
 	preempt_disable();
-	ret = smp_call_function_mask(cpu_online_map, func, info, wait);
+	ret = smp_call_function_mask(&tmp_online_map, func, info, wait);
 	preempt_enable();
 	return ret;
 }
Index: linux-2.6.git/virt/kvm/kvm_main.c
===================================================================
--- linux-2.6.git.orig/virt/kvm/kvm_main.c
+++ linux-2.6.git/virt/kvm/kvm_main.c
@@ -124,7 +124,7 @@
 	if (cpus_empty(cpus))
 		goto out;
 	++kvm->stat.remote_tlb_flush;
-	smp_call_function_mask(cpus, ack_flush, NULL, 1);
+	smp_call_function_mask(&cpus, ack_flush, NULL, 1);
 out:
 	put_cpu();
 }
@@ -149,7 +149,7 @@
 	}
 	if (cpus_empty(cpus))
 		goto out;
-	smp_call_function_mask(cpus, ack_flush, NULL, 1);
+	smp_call_function_mask(&cpus, ack_flush, NULL, 1);
 out:
 	put_cpu();
 }

--------------000105070102070306040301--
