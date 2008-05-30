Return-Path: <linux-kernel-owner+w=401wt.eu-S1760752AbYE3EMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760752AbYE3EMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYE3EBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:01:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40543 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753592AbYE3EA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:29 -0400
Message-Id: <20080530040022.786507220@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:55 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, Tony.Luck@intel.com
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 35/41] Support for CPU ops
Content-Disposition: inline; filename=ia64_cpu_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IA64 has no efficient atomic operations. But we can get rid of the need to
add my_percpu_offset(). The address of a per cpu variable can be used directly
on IA64 since its mapped to a per processor area.

This also allows us to kill off the __ia64_get_cpu_var macro. Its nothing but
per_cpu_var().

Cc: Tony.Luck@intel.com
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/ia64/Kconfig              |    3 
 arch/ia64/kernel/perfmon.c     |    2 
 arch/ia64/kernel/setup.c       |    2 
 arch/ia64/kernel/smp.c         |    4 -
 arch/ia64/sn/kernel/setup.c    |    4 -
 include/asm-ia64/mmu_context.h |    6 -
 include/asm-ia64/percpu.h      |  133 ++++++++++++++++++++++++++++++++++++++---
 include/asm-ia64/processor.h   |    2 
 include/asm-ia64/sn/pda.h      |    2 
 9 files changed, 138 insertions(+), 20 deletions(-)

Index: linux-2.6/include/asm-ia64/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/percpu.h	2008-05-29 19:35:10.000000000 -0700
+++ linux-2.6/include/asm-ia64/percpu.h	2008-05-29 19:35:11.000000000 -0700
@@ -19,7 +19,7 @@
 # define PER_CPU_ATTRIBUTES	__attribute__((__model__ (__small__)))
 #endif
 
-#define __my_cpu_offset	__ia64_per_cpu_var(local_per_cpu_offset)
+#define __my_cpu_offset	CPU_READ(per_cpu_var(local_per_cpu_offset))
 
 extern void *per_cpu_init(void);
 
@@ -31,14 +31,6 @@ extern void *per_cpu_init(void);
 
 #endif	/* SMP */
 
-/*
- * Be extremely careful when taking the address of this variable!  Due to virtual
- * remapping, it is different from the canonical address returned by __get_cpu_var(var)!
- * On the positive side, using __ia64_per_cpu_var() instead of __get_cpu_var() is slightly
- * more efficient.
- */
-#define __ia64_per_cpu_var(var)	per_cpu__##var
-
 #include <asm-generic/percpu.h>
 
 /* Equal to __per_cpu_offset[smp_processor_id()], but faster to access: */
@@ -46,4 +38,127 @@ DECLARE_PER_CPU(unsigned long, local_per
 
 #endif /* !__ASSEMBLY__ */
 
+/*
+ * Per cpu ops.
+ *
+ * IA64 has no instructions that would allow light weight RMW operations.
+ *
+ * However, the canonical address of a per cpu variable is mapped via
+ * a processor specific TLB entry to the per cpu area of the respective
+ * processor. The THIS_CPU() macro is therefore not necessary here
+ * since the canonical address of the per cpu variable allows access
+ * to the instance of the per cpu variable for the current processor.
+ *
+ * Sadly we cannot simply define THIS_CPU() to return an address in
+ * the per processor mapping space since the address acquired by THIS_CPU\
+ * may be passed to another processor.
+ */
+#define __CPU_READ(var)				\
+({						\
+	(var);					\
+})
+
+#define __CPU_WRITE(var, value)			\
+({						\
+	(var) = (value);			\
+})
+
+#define __CPU_ADD(var, value)			\
+({						\
+	(var) += (value);			\
+})
+
+#define __CPU_INC(var) __CPU_ADD((var), 1)
+#define __CPU_DEC(var) __CPU_ADD((var), -1)
+#define __CPU_SUB(var, value) __CPU_ADD((var), -(value))
+
+#define __CPU_CMPXCHG(var, old, new)		\
+({						\
+	typeof(obj) x;				\
+	typeof(obj) *p = &(var);		\
+	x = *p;					\
+	if (x == (old))				\
+		*p = (new);			\
+	(x);					\
+})
+
+#define __CPU_XCHG(obj, new)			\
+({						\
+	typeof(obj) x;				\
+	typeof(obj) *p = &(obj);		\
+	x = *p;					\
+	*p = (new);				\
+	(x);					\
+})
+
+#define _CPU_READ __CPU_READ
+#define _CPU_WRITE __CPU_WRITE
+
+#define _CPU_ADD(var, value)			\
+({						\
+	preempt_disable();			\
+	__CPU_ADD((var), (value));		\
+	preempt_enable();			\
+})
+
+#define _CPU_INC(var) _CPU_ADD((var), 1)
+#define _CPU_DEC(var) _CPU_ADD((var), -1)
+#define _CPU_SUB(var, value) _CPU_ADD((var), -(value))
+
+#define _CPU_CMPXCHG(var, old, new)		\
+({						\
+	typeof(addr) x;				\
+	preempt_disable();			\
+	x = __CPU_CMPXCHG((var), (old), (new));	\
+	preempt_enable();			\
+	(x);					\
+})
+
+#define _CPU_XCHG(var, new)			\
+({						\
+	typeof(var) x;				\
+	preempt_disable();			\
+	x = __CPU_XCHG((var), (new));		\
+	preempt_enable();			\
+	(x);					\
+})
+
+/*
+ * Third group: Interrupt safe CPU functions
+ */
+#define CPU_READ __CPU_READ
+#define CPU_WRITE __CPU_WRITE
+
+#define CPU_ADD(var, value)			\
+({						\
+	unsigned long flags;			\
+	local_irq_save(flags);			\
+	__CPU_ADD((var), (value));		\
+	local_irq_restore(flags);		\
+})
+
+#define CPU_INC(var) CPU_ADD((var), 1)
+#define CPU_DEC(var) CPU_ADD((var), -1)
+#define CPU_SUB(var, value) CPU_ADD((var), -(value))
+
+#define CPU_CMPXCHG(var, old, new)		\
+({						\
+	unsigned long flags;			\
+	typeof(var) x;				\
+	local_irq_save(flags);			\
+	x = __CPU_CMPXCHG((var), (old), (new));	\
+	local_irq_restore(flags);		\
+	(x);					\
+})
+
+#define CPU_XCHG(var, new)			\
+({						\
+	unsigned long flags;			\
+	typeof(var) x;				\
+	local_irq_save(flags);			\
+	x = __CPU_XCHG((var), (new));		\
+	local_irq_restore(flags);		\
+	(x);					\
+})
+
 #endif /* _ASM_IA64_PERCPU_H */
Index: linux-2.6/arch/ia64/kernel/perfmon.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/perfmon.c	2008-05-29 19:35:09.000000000 -0700
+++ linux-2.6/arch/ia64/kernel/perfmon.c	2008-05-29 19:35:13.000000000 -0700
@@ -576,7 +576,7 @@ static struct ctl_table_header *pfm_sysc
 
 static int pfm_context_unload(pfm_context_t *ctx, void *arg, int count, struct pt_regs *regs);
 
-#define pfm_get_cpu_var(v)		__ia64_per_cpu_var(v)
+#define pfm_get_cpu_var(v)		per_cpu_var(v)
 #define pfm_get_cpu_data(a,b)		per_cpu(a, b)
 
 static inline void
Index: linux-2.6/arch/ia64/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/setup.c	2008-05-29 19:35:09.000000000 -0700
+++ linux-2.6/arch/ia64/kernel/setup.c	2008-05-29 19:35:11.000000000 -0700
@@ -925,7 +925,7 @@ cpu_init (void)
 	 * depends on the data returned by identify_cpu().  We break the dependency by
 	 * accessing cpu_data() through the canonical per-CPU address.
 	 */
-	cpu_info = cpu_data + ((char *) &__ia64_per_cpu_var(cpu_info) - __per_cpu_start);
+	cpu_info = cpu_data + ((char *)&per_cpu_var(cpu_info) - __per_cpu_start);
 	identify_cpu(cpu_info);
 
 #ifdef CONFIG_MCKINLEY
Index: linux-2.6/arch/ia64/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/smp.c	2008-05-29 19:35:09.000000000 -0700
+++ linux-2.6/arch/ia64/kernel/smp.c	2008-05-29 19:35:11.000000000 -0700
@@ -150,7 +150,7 @@ irqreturn_t
 handle_IPI (int irq, void *dev_id)
 {
 	int this_cpu = get_cpu();
-	unsigned long *pending_ipis = &__ia64_per_cpu_var(ipi_operation);
+	unsigned long *pending_ipis = &per_cpu_var(ipi_operation);
 	unsigned long ops;
 
 	mb();	/* Order interrupt and bit testing. */
@@ -303,7 +303,7 @@ smp_local_flush_tlb(void)
 void
 smp_flush_tlb_cpumask(cpumask_t xcpumask)
 {
-	unsigned int *counts = __ia64_per_cpu_var(shadow_flush_counts);
+	unsigned int *counts = per_cpu_var(shadow_flush_counts);
 	cpumask_t cpumask = xcpumask;
 	int mycpu, cpu, flush_mycpu = 0;
 
Index: linux-2.6/arch/ia64/sn/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/setup.c	2008-05-29 19:35:09.000000000 -0700
+++ linux-2.6/arch/ia64/sn/kernel/setup.c	2008-05-29 19:35:11.000000000 -0700
@@ -645,7 +645,7 @@ void __cpuinit sn_cpu_init(void)
 		/* copy cpu 0's sn_cnodeid_to_nasid table to this cpu's */
 		memcpy(sn_cnodeid_to_nasid,
 		       (&per_cpu(__sn_cnodeid_to_nasid, 0)),
-		       sizeof(__ia64_per_cpu_var(__sn_cnodeid_to_nasid)));
+		       sizeof(per_cpu_var(__sn_cnodeid_to_nasid)));
 	}
 
 	/*
@@ -706,7 +706,7 @@ void __init build_cnode_tables(void)
 
 	memset(physical_node_map, -1, sizeof(physical_node_map));
 	memset(sn_cnodeid_to_nasid, -1,
-			sizeof(__ia64_per_cpu_var(__sn_cnodeid_to_nasid)));
+			sizeof(per_cpu_var(__sn_cnodeid_to_nasid)));
 
 	/*
 	 * First populate the tables with C/M bricks. This ensures that
Index: linux-2.6/include/asm-ia64/mmu_context.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/mmu_context.h	2008-05-29 19:35:10.000000000 -0700
+++ linux-2.6/include/asm-ia64/mmu_context.h	2008-05-29 19:35:13.000000000 -0700
@@ -64,11 +64,11 @@ delayed_tlb_flush (void)
 	extern void local_flush_tlb_all (void);
 	unsigned long flags;
 
-	if (unlikely(__ia64_per_cpu_var(ia64_need_tlb_flush))) {
+	if (unlikely(CPU_READ(per_cpu_var(ia64_need_tlb_flush)))) {
 		spin_lock_irqsave(&ia64_ctx.lock, flags);
-		if (__ia64_per_cpu_var(ia64_need_tlb_flush)) {
+		if (CPU_READ(per_cpu_var(ia64_need_tlb_flush))) {
 			local_flush_tlb_all();
-			__ia64_per_cpu_var(ia64_need_tlb_flush) = 0;
+			CPU_WRITE(per_cpu_var(ia64_need_tlb_flush), 0);
 		}
 		spin_unlock_irqrestore(&ia64_ctx.lock, flags);
 	}
Index: linux-2.6/include/asm-ia64/processor.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/processor.h	2008-05-29 19:35:09.000000000 -0700
+++ linux-2.6/include/asm-ia64/processor.h	2008-05-29 19:35:11.000000000 -0700
@@ -237,7 +237,7 @@ DECLARE_PER_CPU(struct cpuinfo_ia64, cpu
  * Do not use the address of local_cpu_data, since it will be different from
  * cpu_data(smp_processor_id())!
  */
-#define local_cpu_data		(&__ia64_per_cpu_var(cpu_info))
+#define local_cpu_data		(&per_cpu_var(cpu_info))
 #define cpu_data(cpu)		(&per_cpu(cpu_info, cpu))
 
 extern void print_cpu_info (struct cpuinfo_ia64 *);
Index: linux-2.6/include/asm-ia64/sn/pda.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/sn/pda.h	2008-05-29 19:35:10.000000000 -0700
+++ linux-2.6/include/asm-ia64/sn/pda.h	2008-05-29 19:35:11.000000000 -0700
@@ -62,7 +62,7 @@ typedef struct pda_s {
  */
 DECLARE_PER_CPU(struct pda_s, pda_percpu);
 
-#define pda		(&__ia64_per_cpu_var(pda_percpu))
+#define pda		(&per_cpu_var(pda_percpu))
 
 #define pdacpu(cpu)	(&per_cpu(pda_percpu, cpu))
 
Index: linux-2.6/arch/ia64/Kconfig
===================================================================
--- linux-2.6.orig/arch/ia64/Kconfig	2008-05-29 19:35:09.000000000 -0700
+++ linux-2.6/arch/ia64/Kconfig	2008-05-29 19:35:11.000000000 -0700
@@ -92,6 +92,9 @@ config GENERIC_TIME_VSYSCALL
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool y
 
+config HAVE_CPU_OPS
+	def_bool y
+
 config DMI
 	bool
 	default y

-- 
