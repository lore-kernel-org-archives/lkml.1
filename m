Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbYIBO1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbYIBO1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 10:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYIBO1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 10:27:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38759 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751336AbYIBO1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 10:27:20 -0400
Message-ID: <48BD4D42.2090504@sgi.com>
Date: Tue, 02 Sep 2008 16:27:14 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, travis@sgi.com, mingo@elte.hu,
       Alan.Brunelle@hp.com, tglx@linutronix.de, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       akpm@linux-foundation.org, arjan@linux.intel.com, rusty@rustcorp.com.au
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <20080826072220.GB31876@elte.hu> <20080826.004607.253712060.davem@davemloft.net> <48B4542A.1050004@sgi.com> <20080826.134535.193703558.davem@davemloft.net> <48B7EEA2.7090300@sgi.com> <alpine.LFD.1.10.0808290909020.3300@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808290909020.3300@nehalem.linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------030107080506080109020908"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030107080506080109020908
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Linus Torvalds wrote:
> 
> On Fri, 29 Aug 2008, Jes Sorensen wrote:
>> I have only tested this on ia64, but it boots, so it's obviously
>> perfect<tm> :-)
> 
> Well, it probably boots because it doesn't really seem to _change_ much of 
> anything.
> 
> Things like this:
> 
> 	-static inline void arch_send_call_function_ipi(cpumask_t mask)
> 	+static inline void arch_send_call_function_ipi(cpumask_t *mask)
> 	 {
> 	-       smp_ops.send_call_func_ipi(mask);
> 	+       smp_ops.send_call_func_ipi(*mask);
> 	 }
> 
> will still do that stack allocation at the time of the call. You'd have to 
> pass the thing all the way down as a pointer..

Linus,

Ok, so here's a version which tries to do the right thing on x86 as
well. Build tested on x86_64, but don't have an easy way to test it
right now. It's booting on ia64.

Cheers,
Jes


--------------030107080506080109020908
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
 arch/alpha/include/asm/smp.h            |    2 +-
 arch/alpha/kernel/smp.c                 |    4 ++--
 arch/arm/include/asm/smp.h              |    2 +-
 arch/arm/kernel/smp.c                   |    4 ++--
 arch/ia64/include/asm/smp.h             |    2 +-
 arch/ia64/kernel/smp.c                  |    6 +++---
 arch/m32r/kernel/smp.c                  |    4 ++--
 arch/mips/kernel/smp.c                  |    4 ++--
 arch/parisc/kernel/smp.c                |    6 +++---
 arch/powerpc/include/asm/smp.h          |    2 +-
 arch/powerpc/kernel/smp.c               |    4 ++--
 arch/sh/include/asm/smp.h               |    2 +-
 arch/sh/kernel/smp.c                    |    4 ++--
 arch/sparc/include/asm/smp_64.h         |    2 +-
 arch/sparc64/kernel/smp.c               |    4 ++--
 arch/x86/kernel/apic_32.c               |    2 +-
 arch/x86/kernel/apic_64.c               |    2 +-
 arch/x86/kernel/crash.c                 |    2 +-
 arch/x86/kernel/genapic_flat_64.c       |   20 ++++++++++++--------
 arch/x86/kernel/genx2apic_uv_x.c        |   10 ++++++----
 arch/x86/kernel/io_apic_64.c            |    6 ++++--
 arch/x86/kernel/smp.c                   |   12 ++++++++----
 arch/x86/kernel/tlb_32.c                |    2 +-
 arch/x86/kernel/tlb_64.c                |    2 +-
 arch/x86/xen/smp.c                      |   13 +++++++------
 include/asm-m32r/smp.h                  |    2 +-
 include/asm-mips/smp.h                  |    2 +-
 include/asm-parisc/smp.h                |    2 +-
 include/asm-x86/genapic_32.h            |    2 +-
 include/asm-x86/genapic_64.h            |    2 +-
 include/asm-x86/mach-default/mach_ipi.h |   10 ++++++----
 include/asm-x86/smp.h                   |    6 +++---
 include/linux/smp.h                     |    2 +-
 kernel/smp.c                            |   15 ++++++++-------
 virt/kvm/kvm_main.c                     |    4 ++--
 35 files changed, 93 insertions(+), 77 deletions(-)

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
Index: linux-2.6.git/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_32.c
+++ linux-2.6.git/arch/x86/kernel/apic_32.c
@@ -291,7 +291,7 @@
 static void lapic_timer_broadcast(cpumask_t mask)
 {
 #ifdef CONFIG_SMP
-	send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
+	send_IPI_mask(&mask, LOCAL_TIMER_VECTOR);
 #endif
 }
 
Index: linux-2.6.git/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_64.c
+++ linux-2.6.git/arch/x86/kernel/apic_64.c
@@ -280,7 +280,7 @@
 static void lapic_timer_broadcast(cpumask_t mask)
 {
 #ifdef CONFIG_SMP
-	send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
+	send_IPI_mask(&mask, LOCAL_TIMER_VECTOR);
 #endif
 }
 
Index: linux-2.6.git/arch/x86/kernel/crash.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/crash.c
+++ linux-2.6.git/arch/x86/kernel/crash.c
@@ -80,7 +80,7 @@
 	cpumask_t mask = cpu_online_map;
 	cpu_clear(safe_smp_processor_id(), mask);
 	if (!cpus_empty(mask))
-		send_IPI_mask(mask, NMI_VECTOR);
+		send_IPI_mask(&mask, NMI_VECTOR);
 }
 
 static struct notifier_block crash_nmi_nb = {
Index: linux-2.6.git/arch/x86/kernel/genapic_flat_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/genapic_flat_64.c
+++ linux-2.6.git/arch/x86/kernel/genapic_flat_64.c
@@ -58,9 +58,9 @@
 	apic_write(APIC_LDR, val);
 }
 
-static void flat_send_IPI_mask(cpumask_t cpumask, int vector)
+static void flat_send_IPI_mask(cpumask_t *cpumask, int vector)
 {
-	unsigned long mask = cpus_addr(cpumask)[0];
+	unsigned long mask = cpus_addr(*cpumask)[0];
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -81,7 +81,7 @@
 		cpu_clear(smp_processor_id(), allbutme);
 
 		if (!cpus_empty(allbutme))
-			flat_send_IPI_mask(allbutme, vector);
+			flat_send_IPI_mask(&allbutme, vector);
 	} else if (num_online_cpus() > 1) {
 		__send_IPI_shortcut(APIC_DEST_ALLBUT, vector,APIC_DEST_LOGICAL);
 	}
@@ -89,8 +89,10 @@
 
 static void flat_send_IPI_all(int vector)
 {
+	cpumask_t tmp_online_map = cpu_online_map;
+
 	if (vector == NMI_VECTOR)
-		flat_send_IPI_mask(cpu_online_map, vector);
+		flat_send_IPI_mask(&tmp_online_map, vector);
 	else
 		__send_IPI_shortcut(APIC_DEST_ALLINC, vector, APIC_DEST_LOGICAL);
 }
@@ -141,9 +143,9 @@
 	return cpumask_of_cpu(cpu);
 }
 
-static void physflat_send_IPI_mask(cpumask_t cpumask, int vector)
+static void physflat_send_IPI_mask(cpumask_t *cpumask, int vector)
 {
-	send_IPI_mask_sequence(cpumask, vector);
+	send_IPI_mask_sequence(*cpumask, vector);
 }
 
 static void physflat_send_IPI_allbutself(int vector)
@@ -151,12 +153,14 @@
 	cpumask_t allbutme = cpu_online_map;
 
 	cpu_clear(smp_processor_id(), allbutme);
-	physflat_send_IPI_mask(allbutme, vector);
+	physflat_send_IPI_mask(&allbutme, vector);
 }
 
 static void physflat_send_IPI_all(int vector)
 {
-	physflat_send_IPI_mask(cpu_online_map, vector);
+	cpumask_t tmp_online_map = cpu_online_map;
+
+	physflat_send_IPI_mask(&tmp_online_map, vector);
 }
 
 static unsigned int physflat_cpu_mask_to_apicid(cpumask_t cpumask)
Index: linux-2.6.git/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux-2.6.git/arch/x86/kernel/genx2apic_uv_x.c
@@ -94,12 +94,12 @@
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
 
-static void uv_send_IPI_mask(cpumask_t mask, int vector)
+static void uv_send_IPI_mask(cpumask_t *mask, int vector)
 {
 	unsigned int cpu;
 
 	for_each_possible_cpu(cpu)
-		if (cpu_isset(cpu, mask))
+		if (cpu_isset(cpu, *mask))
 			uv_send_IPI_one(cpu, vector);
 }
 
@@ -110,12 +110,14 @@
 	cpu_clear(smp_processor_id(), mask);
 
 	if (!cpus_empty(mask))
-		uv_send_IPI_mask(mask, vector);
+		uv_send_IPI_mask(&mask, vector);
 }
 
 static void uv_send_IPI_all(int vector)
 {
-	uv_send_IPI_mask(cpu_online_map, vector);
+	cpumask_t mask = cpu_online_map;
+
+	uv_send_IPI_mask(&mask, vector);
 }
 
 static int uv_apic_id_registered(void)
Index: linux-2.6.git/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_apic_64.c
+++ linux-2.6.git/arch/x86/kernel/io_apic_64.c
@@ -1379,9 +1379,11 @@
 {
 	struct irq_cfg *cfg = &irq_cfg[irq];
 	unsigned long flags;
+	cpumask_t mask;
 
 	spin_lock_irqsave(&vector_lock, flags);
-	send_IPI_mask(cpumask_of_cpu(first_cpu(cfg->domain)), cfg->vector);
+	mask = cpumask_of_cpu(first_cpu(cfg->domain));
+	send_IPI_mask(&mask, cfg->vector);
 	spin_unlock_irqrestore(&vector_lock, flags);
 
 	return 1;
@@ -1446,7 +1448,7 @@
 
 		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
 		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
-		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		send_IPI_mask(&cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
 		cfg->move_in_progress = 0;
 	}
 }
Index: linux-2.6.git/arch/x86/kernel/smp.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/smp.c
+++ linux-2.6.git/arch/x86/kernel/smp.c
@@ -114,26 +114,30 @@
  */
 static void native_smp_send_reschedule(int cpu)
 {
+	cpumask_t mask;
+
 	if (unlikely(cpu_is_offline(cpu))) {
 		WARN_ON(1);
 		return;
 	}
-	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
+	mask = cpumask_of_cpu(cpu);
+	send_IPI_mask(&mask, RESCHEDULE_VECTOR);
 }
 
 void native_send_call_func_single_ipi(int cpu)
 {
-	send_IPI_mask(cpumask_of_cpu(cpu), CALL_FUNCTION_SINGLE_VECTOR);
+	cpumask_t mask = cpumask_of_cpu(cpu);
+	send_IPI_mask(&mask, CALL_FUNCTION_SINGLE_VECTOR);
 }
 
-void native_send_call_func_ipi(cpumask_t mask)
+void native_send_call_func_ipi(cpumask_t *mask)
 {
 	cpumask_t allbutself;
 
 	allbutself = cpu_online_map;
 	cpu_clear(smp_processor_id(), allbutself);
 
-	if (cpus_equal(mask, allbutself) &&
+	if (cpus_equal(*mask, allbutself) &&
 	    cpus_equal(cpu_online_map, cpu_callout_map))
 		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
 	else
Index: linux-2.6.git/arch/x86/kernel/tlb_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/tlb_32.c
+++ linux-2.6.git/arch/x86/kernel/tlb_32.c
@@ -158,7 +158,7 @@
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */
-	send_IPI_mask(cpumask, INVALIDATE_TLB_VECTOR);
+	send_IPI_mask(&cpumask, INVALIDATE_TLB_VECTOR);
 
 	while (!cpus_empty(flush_cpumask))
 		/* nothing. lockup detection does not belong here */
Index: linux-2.6.git/arch/x86/kernel/tlb_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/tlb_64.c
+++ linux-2.6.git/arch/x86/kernel/tlb_64.c
@@ -186,7 +186,7 @@
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */
-	send_IPI_mask(cpumask, INVALIDATE_TLB_VECTOR_START + sender);
+	send_IPI_mask(&cpumask, INVALIDATE_TLB_VECTOR_START + sender);
 
 	while (!cpus_empty(f->flush_cpumask))
 		cpu_relax();
Index: linux-2.6.git/arch/x86/xen/smp.c
===================================================================
--- linux-2.6.git.orig/arch/x86/xen/smp.c
+++ linux-2.6.git/arch/x86/xen/smp.c
@@ -361,24 +361,25 @@
 	xen_send_IPI_one(cpu, XEN_RESCHEDULE_VECTOR);
 }
 
-static void xen_send_IPI_mask(cpumask_t mask, enum ipi_vector vector)
+static void xen_send_IPI_mask(cpumask_t *mask, enum ipi_vector vector)
 {
 	unsigned cpu;
+	cpumask_t newmask;
 
-	cpus_and(mask, mask, cpu_online_map);
+	cpus_and(newmask, *mask, cpu_online_map);
 
-	for_each_cpu_mask_nr(cpu, mask)
+	for_each_cpu_mask_nr(cpu, newmask)
 		xen_send_IPI_one(cpu, vector);
 }
 
-static void xen_smp_send_call_function_ipi(cpumask_t mask)
+static void xen_smp_send_call_function_ipi(cpumask_t *mask)
 {
 	int cpu;
 
 	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
 
 	/* Make sure other vcpus get a chance to run if they need to. */
-	for_each_cpu_mask_nr(cpu, mask) {
+	for_each_cpu_mask_nr(cpu, *mask) {
 		if (xen_vcpu_stolen(cpu)) {
 			HYPERVISOR_sched_op(SCHEDOP_yield, 0);
 			break;
@@ -388,7 +389,7 @@
 
 static void xen_smp_send_call_function_single_ipi(int cpu)
 {
-	xen_send_IPI_mask(cpumask_of_cpu(cpu), XEN_CALL_FUNCTION_SINGLE_VECTOR);
+	xen_send_IPI_mask(&cpumask_of_cpu(cpu), XEN_CALL_FUNCTION_SINGLE_VECTOR);
 }
 
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
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
 
Index: linux-2.6.git/include/asm-x86/genapic_32.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/genapic_32.h
+++ linux-2.6.git/include/asm-x86/genapic_32.h
@@ -60,7 +60,7 @@
 
 #ifdef CONFIG_SMP
 	/* ipi */
-	void (*send_IPI_mask)(cpumask_t mask, int vector);
+	void (*send_IPI_mask)(cpumask_t *mask, int vector);
 	void (*send_IPI_allbutself)(int vector);
 	void (*send_IPI_all)(int vector);
 #endif
Index: linux-2.6.git/include/asm-x86/genapic_64.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/genapic_64.h
+++ linux-2.6.git/include/asm-x86/genapic_64.h
@@ -21,7 +21,7 @@
 	cpumask_t (*vector_allocation_domain)(int cpu);
 	void (*init_apic_ldr)(void);
 	/* ipi */
-	void (*send_IPI_mask)(cpumask_t mask, int vector);
+	void (*send_IPI_mask)(cpumask_t *mask, int vector);
 	void (*send_IPI_allbutself)(int vector);
 	void (*send_IPI_all)(int vector);
 	/* */
Index: linux-2.6.git/include/asm-x86/mach-default/mach_ipi.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/mach-default/mach_ipi.h
+++ linux-2.6.git/include/asm-x86/mach-default/mach_ipi.h
@@ -13,9 +13,9 @@
 #include <asm/genapic.h>
 #define send_IPI_mask (genapic->send_IPI_mask)
 #else
-static inline void send_IPI_mask(cpumask_t mask, int vector)
+static inline void send_IPI_mask(cpumask_t *mask, int vector)
 {
-	send_IPI_mask_bitmask(mask, vector);
+	send_IPI_mask_bitmask(*mask, vector);
 }
 #endif
 
@@ -25,15 +25,17 @@
 		cpumask_t mask = cpu_online_map;
 
 		cpu_clear(smp_processor_id(), mask);
-		send_IPI_mask(mask, vector);
+		send_IPI_mask(&mask, vector);
 	} else
 		__send_IPI_shortcut(APIC_DEST_ALLBUT, vector);
 }
 
 static inline void __local_send_IPI_all(int vector)
 {
+	cpumask_t mask = cpu_online_map;
+
 	if (no_broadcast || vector == NMI_VECTOR)
-		send_IPI_mask(cpu_online_map, vector);
+		send_IPI_mask(&mask, vector);
 	else
 		__send_IPI_shortcut(APIC_DEST_ALLINC, vector);
 }
Index: linux-2.6.git/include/asm-x86/smp.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/smp.h
+++ linux-2.6.git/include/asm-x86/smp.h
@@ -53,7 +53,7 @@
 	void (*smp_send_stop)(void);
 	void (*smp_send_reschedule)(int cpu);
 
-	void (*send_call_func_ipi)(cpumask_t mask);
+	void (*send_call_func_ipi)(cpumask_t *mask);
 	void (*send_call_func_single_ipi)(int cpu);
 };
 
@@ -101,7 +101,7 @@
 	smp_ops.send_call_func_single_ipi(cpu);
 }
 
-static inline void arch_send_call_function_ipi(cpumask_t mask)
+static inline void arch_send_call_function_ipi(cpumask_t *mask)
 {
 	smp_ops.send_call_func_ipi(mask);
 }
@@ -110,7 +110,7 @@
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
 int native_cpu_up(unsigned int cpunum);
-void native_send_call_func_ipi(cpumask_t mask);
+void native_send_call_func_ipi(cpumask_t *mask);
 void native_send_call_func_single_ipi(int cpu);
 
 extern int __cpu_disable(void);
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

--------------030107080506080109020908--
