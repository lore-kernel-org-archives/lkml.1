Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbYCYCbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbYCYCbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 22:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbYCYCbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 22:31:22 -0400
Received: from relay1.sgi.com ([192.48.171.29]:44666 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753110AbYCYCbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 22:31:21 -0400
Message-Id: <20080325023121.063246000@polaris-admin.engr.sgi.com>
References: <20080325023120.859257000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 24 Mar 2008 19:31:21 -0700
From: Mike Travis <travis@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 01/12] cpumask: Convert cpumask_of_cpu to static array
Content-Disposition: inline; filename=cpumask_of_cpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a simple patch to use a per cpu cpumask instead of constructing 
one on the stack.

Conditioned by NR_CPUS > BITS_PER_LONG as if less than or equal,
cpumask_of_cpu() generates a simple unsigned long.  But the macro is
changed to generate an lvalue so a pointer to cpumask_of_cpu can be
provided.

This removes 25552 bytes of stack usage, as well as reduces the code
generated for each usage.

Based on linux-2.6.25-rc5-mm1

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/apic_32.c      |    1 +
 arch/x86/kernel/apic_64.c      |    1 +
 arch/x86/kernel/cpu/intel.c    |    1 +
 arch/x86/kernel/hpet.c         |    1 +
 arch/x86/kernel/smp_32.c       |    1 +
 arch/x86/kernel/smp_64.c       |    1 +
 arch/x86/kernel/smpcommon_32.c |    1 +
 arch/x86/mach-generic/bigsmp.c |    1 +
 arch/x86/mach-generic/summit.c |    1 +
 include/linux/cpumask.h        |   10 +++++++---
 include/linux/sched.h          |    5 +++++
 kernel/sched.c                 |   10 ++++++++++
 12 files changed, 31 insertions(+), 3 deletions(-)

--- linux-2.6.25-rc5.orig/arch/x86/kernel/apic_32.c
+++ linux-2.6.25-rc5/arch/x86/kernel/apic_32.c
@@ -28,6 +28,7 @@
 #include <linux/acpi_pmtmr.h>
 #include <linux/module.h>
 #include <linux/dmi.h>
+#include <linux/sched.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
--- linux-2.6.25-rc5.orig/arch/x86/kernel/apic_64.c
+++ linux-2.6.25-rc5/arch/x86/kernel/apic_64.c
@@ -27,6 +27,7 @@
 #include <linux/clockchips.h>
 #include <linux/acpi_pmtmr.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
--- linux-2.6.25-rc5.orig/arch/x86/kernel/cpu/intel.c
+++ linux-2.6.25-rc5/arch/x86/kernel/cpu/intel.c
@@ -6,6 +6,7 @@
 #include <linux/smp.h>
 #include <linux/thread_info.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 
 #include <asm/processor.h>
 #include <asm/pgtable.h>
--- linux-2.6.25-rc5.orig/arch/x86/kernel/hpet.c
+++ linux-2.6.25-rc5/arch/x86/kernel/hpet.c
@@ -6,6 +6,7 @@
 #include <linux/init.h>
 #include <linux/sysdev.h>
 #include <linux/pm.h>
+#include <linux/sched.h>
 
 #include <asm/fixmap.h>
 #include <asm/hpet.h>
--- linux-2.6.25-rc5.orig/arch/x86/kernel/smp_32.c
+++ linux-2.6.25-rc5/arch/x86/kernel/smp_32.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
--- linux-2.6.25-rc5.orig/arch/x86/kernel/smp_64.c
+++ linux-2.6.25-rc5/arch/x86/kernel/smp_64.c
@@ -18,6 +18,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/mc146818rtc.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 
 #include <asm/mtrr.h>
 #include <asm/pgalloc.h>
--- linux-2.6.25-rc5.orig/arch/x86/kernel/smpcommon_32.c
+++ linux-2.6.25-rc5/arch/x86/kernel/smpcommon_32.c
@@ -2,6 +2,7 @@
  * SMP stuff which is common to all sub-architectures.
  */
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <asm/smp.h>
 
 DEFINE_PER_CPU(unsigned long, this_cpu_off);
--- linux-2.6.25-rc5.orig/arch/x86/mach-generic/bigsmp.c
+++ linux-2.6.25-rc5/arch/x86/mach-generic/bigsmp.c
@@ -14,6 +14,7 @@
 #include <linux/smp.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
+#include <linux/sched.h>
 #include <asm/mach-bigsmp/mach_apic.h>
 #include <asm/mach-bigsmp/mach_apicdef.h>
 #include <asm/mach-bigsmp/mach_ipi.h>
--- linux-2.6.25-rc5.orig/arch/x86/mach-generic/summit.c
+++ linux-2.6.25-rc5/arch/x86/mach-generic/summit.c
@@ -13,6 +13,7 @@
 #include <linux/string.h>
 #include <linux/smp.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <asm/mach-summit/mach_apic.h>
 #include <asm/mach-summit/mach_apicdef.h>
 #include <asm/mach-summit/mach_ipi.h>
--- linux-2.6.25-rc5.orig/include/linux/cpumask.h
+++ linux-2.6.25-rc5/include/linux/cpumask.h
@@ -226,8 +226,11 @@ int __next_cpu(int n, const cpumask_t *s
 #define next_cpu(n, src)	({ (void)(src); 1; })
 #endif
 
+#if NR_CPUS > BITS_PER_LONG
+#define cpumask_of_cpu(cpu)    per_cpu(cpu_mask, cpu)
+#else
 #define cpumask_of_cpu(cpu)						\
-({									\
+(*({									\
 	typeof(_unused_cpumask_arg_) m;					\
 	if (sizeof(m) == sizeof(unsigned long)) {			\
 		m.bits[0] = 1UL<<(cpu);					\
@@ -235,8 +238,9 @@ int __next_cpu(int n, const cpumask_t *s
 		cpus_clear(m);						\
 		cpu_set((cpu), m);					\
 	}								\
-	m;								\
-})
+	&m;								\
+}))
+#endif
 
 #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)
 
--- linux-2.6.25-rc5.orig/include/linux/sched.h
+++ linux-2.6.25-rc5/include/linux/sched.h
@@ -2130,6 +2130,11 @@ static inline void migration_init(void)
 
 #define TASK_STATE_TO_CHAR_STR "RSDTtZX"
 
+#if NR_CPUS > BITS_PER_LONG
+/* for cpumask_of_cpu() */
+DECLARE_PER_CPU(cpumask_t, cpu_mask);
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif
--- linux-2.6.25-rc5.orig/kernel/sched.c
+++ linux-2.6.25-rc5/kernel/sched.c
@@ -7198,6 +7198,12 @@ static void init_tg_rt_entry(struct rq *
 }
 #endif
 
+#if NR_CPUS > BITS_PER_LONG
+/* for cpumask_of_cpu() */
+DEFINE_PER_CPU(cpumask_t, cpu_mask);
+EXPORT_PER_CPU_SYMBOL(cpu_mask);
+#endif
+
 void __init sched_init(void)
 {
 	int i, j;
@@ -7242,6 +7248,10 @@ void __init sched_init(void)
 	for_each_possible_cpu(i) {
 		struct rq *rq;
 
+#if NR_CPUS > BITS_PER_LONG
+		/* This makes cpumask_of_cpu() work */
+		cpu_set(i, per_cpu(cpu_mask, i));
+#endif
 		rq = cpu_rq(i);
 		spin_lock_init(&rq->lock);
 		lockdep_set_class(&rq->lock, &rq->rq_lock_key);

-- 
