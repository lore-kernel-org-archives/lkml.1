Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbZDNQOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbZDNQOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbZDNQOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:14:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33114 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962AbZDNQOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:14:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Fix the section attribute on UP DECLARE_PER_CPU()
To: torvalds@osdl.org, tj@kernel.org, mingo@elte.hu, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 14 Apr 2009 17:10:53 +0100
Message-ID: <20090414161053.28145.1209.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In non-SMP mode, the section specified by DECLARE_PER_CPU() does not agree with
that of DEFINE_PER_CPU*().  This means architectures that have a small data
section references relative to a base register may throw up linkage errors due
to too great a displacement between where the base register points and the
per-CPU variable.

On FRV, the .h declaration says that the variable is in the .sdata section, but
the .c definition says it's actually in the .data section.  The linker throws
up the following errors:

kernel/built-in.o: In function `release_task':
kernel/exit.c:78: relocation truncated to fit: R_FRV_GPREL12 against symbol `per_cpu__process_counts' defined in .data section in kernel/built-in.o
kernel/exit.c:78: relocation truncated to fit: R_FRV_GPREL12 against symbol `per_cpu__process_counts' defined in .data section in kernel/built-in.o

To fix this, DECLARE_PER_CPU() should simply interpose the same section
attribute as does DEFINE_PER_CPU().  However, this is made slightly more
complex by virtue of the fact that there are several variants on DEFINE, so
these need to be matched by variants of DECLARE.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/alpha/include/asm/percpu.h  |    2 +-
 arch/ia64/include/asm/smp.h      |    2 +-
 arch/x86/include/asm/desc.h      |    2 +-
 arch/x86/include/asm/hardirq.h   |    2 +-
 arch/x86/include/asm/processor.h |    6 +++--
 arch/x86/include/asm/tlbflush.h  |    2 +-
 include/asm-generic/percpu.h     |   43 ++++++++++++++++++++++++++++++++++++--
 include/linux/percpu.h           |   24 ---------------------
 net/rds/rds.h                    |    2 +-
 9 files changed, 50 insertions(+), 35 deletions(-)


diff --git a/arch/alpha/include/asm/percpu.h b/arch/alpha/include/asm/percpu.h
index 3495e8e..e9e0bb5 100644
--- a/arch/alpha/include/asm/percpu.h
+++ b/arch/alpha/include/asm/percpu.h
@@ -73,6 +73,6 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
 
 #endif /* SMP */
 
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu_var(name)
+#include <asm-generic/percpu.h>
 
 #endif /* __ALPHA_PERCPU_H */
diff --git a/arch/ia64/include/asm/smp.h b/arch/ia64/include/asm/smp.h
index 5984083..d217d1d 100644
--- a/arch/ia64/include/asm/smp.h
+++ b/arch/ia64/include/asm/smp.h
@@ -58,7 +58,7 @@ extern struct smp_boot_data {
 extern char no_int_routing __devinitdata;
 
 extern cpumask_t cpu_core_map[NR_CPUS];
-DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
+DECLARE_PER_CPU_SHARED_ALIGNED(cpumask_t, cpu_sibling_map);
 extern int smp_num_siblings;
 extern void __iomem *ipi_base_addr;
 extern unsigned char smp_int_redirect;
diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 5623c50..c45f415 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -37,7 +37,7 @@ extern gate_desc idt_table[];
 struct gdt_page {
 	struct desc_struct gdt[GDT_ENTRIES];
 } __attribute__((aligned(PAGE_SIZE)));
-DECLARE_PER_CPU(struct gdt_page, gdt_page);
+DECLARE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page);
 
 static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
 {
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 039db6a..37555e5 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -26,7 +26,7 @@ typedef struct {
 #endif
 } ____cacheline_aligned irq_cpustat_t;
 
-DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
+DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 
 /* We can have at most NR_VECTORS irqs routed to a cpu at a time */
 #define MAX_HARDIRQS_PER_CPU NR_VECTORS
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index fcf4d92..c2cceae 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -138,7 +138,7 @@ extern struct tss_struct	doublefault_tss;
 extern __u32			cleared_cpu_caps[NCAPINTS];
 
 #ifdef CONFIG_SMP
-DECLARE_PER_CPU(struct cpuinfo_x86, cpu_info);
+DECLARE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 #define cpu_data(cpu)		per_cpu(cpu_info, cpu)
 #define current_cpu_data	__get_cpu_var(cpu_info)
 #else
@@ -270,7 +270,7 @@ struct tss_struct {
 
 } ____cacheline_aligned;
 
-DECLARE_PER_CPU(struct tss_struct, init_tss);
+DECLARE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss);
 
 /*
  * Save the original ist values for checking stack pointers during debugging
@@ -393,7 +393,7 @@ union irq_stack_union {
 	};
 };
 
-DECLARE_PER_CPU(union irq_stack_union, irq_stack_union);
+DECLARE_PER_CPU_FIRST(union irq_stack_union, irq_stack_union);
 DECLARE_INIT_PER_CPU(irq_stack_union);
 
 DECLARE_PER_CPU(char *, irq_stack_ptr);
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index d3539f9..16a5c84 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -152,7 +152,7 @@ struct tlb_state {
 	struct mm_struct *active_mm;
 	int state;
 };
-DECLARE_PER_CPU(struct tlb_state, cpu_tlbstate);
+DECLARE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate);
 
 static inline void reset_lazy_tlbstate(void)
 {
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index b0e63c6..af47b9e 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -73,11 +73,50 @@ extern void setup_per_cpu_areas(void);
 
 #endif	/* SMP */
 
+#ifndef PER_CPU_BASE_SECTION
+#ifdef CONFIG_SMP
+#define PER_CPU_BASE_SECTION ".data.percpu"
+#else
+#define PER_CPU_BASE_SECTION ".data"
+#endif
+#endif
+
+#ifdef CONFIG_SMP
+
+#ifdef MODULE
+#define PER_CPU_SHARED_ALIGNED_SECTION ""
+#else
+#define PER_CPU_SHARED_ALIGNED_SECTION ".shared_aligned"
+#endif
+#define PER_CPU_FIRST_SECTION ".first"
+
+#else
+
+#define PER_CPU_SHARED_ALIGNED_SECTION ""
+#define PER_CPU_FIRST_SECTION ""
+
+#endif
+
 #ifndef PER_CPU_ATTRIBUTES
 #define PER_CPU_ATTRIBUTES
 #endif
 
-#define DECLARE_PER_CPU(type, name) extern PER_CPU_ATTRIBUTES \
-					__typeof__(type) per_cpu_var(name)
+#define DECLARE_PER_CPU_SECTION(type, name, section)			\
+	extern \
+	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+
+#define DECLARE_PER_CPU(type, name)					\
+	DECLARE_PER_CPU_SECTION(type, name, "")
+
+#define DECLARE_PER_CPU_SHARED_ALIGNED(type, name)			\
+	DECLARE_PER_CPU_SECTION(type, name, PER_CPU_SHARED_ALIGNED_SECTION) \
+	____cacheline_aligned_in_smp
+
+#define DECLARE_PER_CPU_PAGE_ALIGNED(type, name)				\
+	DECLARE_PER_CPU_SECTION(type, name, ".page_aligned")
+
+#define DECLARE_PER_CPU_FIRST(type, name)				\
+	DECLARE_PER_CPU_SECTION(type, name, PER_CPU_FIRST_SECTION)
 
 #endif /* _ASM_GENERIC_PERCPU_H_ */
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index cfda2d5..f052d81 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -9,30 +9,6 @@
 
 #include <asm/percpu.h>
 
-#ifndef PER_CPU_BASE_SECTION
-#ifdef CONFIG_SMP
-#define PER_CPU_BASE_SECTION ".data.percpu"
-#else
-#define PER_CPU_BASE_SECTION ".data"
-#endif
-#endif
-
-#ifdef CONFIG_SMP
-
-#ifdef MODULE
-#define PER_CPU_SHARED_ALIGNED_SECTION ""
-#else
-#define PER_CPU_SHARED_ALIGNED_SECTION ".shared_aligned"
-#endif
-#define PER_CPU_FIRST_SECTION ".first"
-
-#else
-
-#define PER_CPU_SHARED_ALIGNED_SECTION ""
-#define PER_CPU_FIRST_SECTION ""
-
-#endif
-
 #define DEFINE_PER_CPU_SECTION(type, name, section)			\
 	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 619f0a3..7179444 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -638,7 +638,7 @@ struct rds_message *rds_send_get_message(struct rds_connection *,
 void rds_rdma_unuse(struct rds_sock *rs, u32 r_key, int force);
 
 /* stats.c */
-DECLARE_PER_CPU(struct rds_statistics, rds_stats);
+DECLARE_PER_CPU_SHARED_ALIGNED(struct rds_statistics, rds_stats);
 #define rds_stats_inc_which(which, member) do {		\
 	per_cpu(which, get_cpu()).member++;		\
 	put_cpu();					\

