Return-Path: <linux-kernel-owner+w=401wt.eu-S1752375AbZJNGFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbZJNGFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbZJNGDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:03:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:58683 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbZJNGDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:03:30 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, rostedt@goodmis.org, hpa@zytor.com,
       cebbert@redhat.com
Cc: Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: [PATCH 10/16] percpu: make percpu symbols in powerpc unique
Date: Wed, 14 Oct 2009 15:01:59 +0900
Message-Id: <1255500125-3210-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255500125-3210-1-git-send-email-tj@kernel.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:02:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates percpu related symbols in powerpc such that percpu
symbols are unique and don't clash with local symbols.  This serves
two purposes of decreasing the possibility of global percpu symbol
collision and allowing dropping per_cpu__ prefix from percpu symbols.

* arch/powerpc/kernel/perf_callchain.c: s/callchain/cpu_perf_callchain/

* arch/powerpc/kernel/setup-common.c: s/pvr/cpu_pvr/

* arch/powerpc/platforms/pseries/dtl.c: s/dtl/cpu_dtl/

* arch/powerpc/platforms/cell/interrupt.c: s/iic/cpu_iic/

Partly based on Rusty Russell's "alloc_percpu: rename percpu vars
which cause name clashes" patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
---
 arch/powerpc/include/asm/smp.h          |    2 +-
 arch/powerpc/kernel/perf_callchain.c    |    4 ++--
 arch/powerpc/kernel/setup-common.c      |    4 ++--
 arch/powerpc/kernel/smp.c               |    2 +-
 arch/powerpc/platforms/cell/interrupt.c |   14 +++++++-------
 arch/powerpc/platforms/pseries/dtl.c    |    4 ++--
 6 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/include/asm/smp.h b/arch/powerpc/include/asm/smp.h
index d9ea8d3..1d3b270 100644
--- a/arch/powerpc/include/asm/smp.h
+++ b/arch/powerpc/include/asm/smp.h
@@ -37,7 +37,7 @@ extern void cpu_die(void);
 extern void smp_send_debugger_break(int cpu);
 extern void smp_message_recv(int);
 
-DECLARE_PER_CPU(unsigned int, pvr);
+DECLARE_PER_CPU(unsigned int, cpu_pvr);
 
 #ifdef CONFIG_HOTPLUG_CPU
 extern void fixup_irqs(cpumask_t map);
diff --git a/arch/powerpc/kernel/perf_callchain.c b/arch/powerpc/kernel/perf_callchain.c
index 0a03cf7..fe59c44 100644
--- a/arch/powerpc/kernel/perf_callchain.c
+++ b/arch/powerpc/kernel/perf_callchain.c
@@ -497,11 +497,11 @@ static void perf_callchain_user_32(struct pt_regs *regs,
  * Since we can't get PMU interrupts inside a PMU interrupt handler,
  * we don't need separate irq and nmi entries here.
  */
-static DEFINE_PER_CPU(struct perf_callchain_entry, callchain);
+static DEFINE_PER_CPU(struct perf_callchain_entry, cpu_perf_callchain);
 
 struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 {
-	struct perf_callchain_entry *entry = &__get_cpu_var(callchain);
+	struct perf_callchain_entry *entry = &__get_cpu_var(cpu_perf_callchain);
 
 	entry->nr = 0;
 
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 4271f7a..aa5aeb9 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -157,7 +157,7 @@ extern u32 cpu_temp_both(unsigned long cpu);
 #endif /* CONFIG_TAU */
 
 #ifdef CONFIG_SMP
-DEFINE_PER_CPU(unsigned int, pvr);
+DEFINE_PER_CPU(unsigned int, cpu_pvr);
 #endif
 
 static int show_cpuinfo(struct seq_file *m, void *v)
@@ -209,7 +209,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	}
 
 #ifdef CONFIG_SMP
-	pvr = per_cpu(pvr, cpu_id);
+	pvr = per_cpu(cpu_pvr, cpu_id);
 #else
 	pvr = mfspr(SPRN_PVR);
 #endif
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 9b86a74..2ebb484 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -232,7 +232,7 @@ struct thread_info *current_set[NR_CPUS];
 
 static void __devinit smp_store_cpu_info(int id)
 {
-	per_cpu(pvr, id) = mfspr(SPRN_PVR);
+	per_cpu(cpu_pvr, id) = mfspr(SPRN_PVR);
 }
 
 static void __init smp_create_idle(unsigned int cpu)
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 882e470..54bad90 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -54,7 +54,7 @@ struct iic {
 	struct device_node *node;
 };
 
-static DEFINE_PER_CPU(struct iic, iic);
+static DEFINE_PER_CPU(struct iic, cpu_iic);
 #define IIC_NODE_COUNT	2
 static struct irq_host *iic_host;
 
@@ -82,7 +82,7 @@ static void iic_unmask(unsigned int irq)
 
 static void iic_eoi(unsigned int irq)
 {
-	struct iic *iic = &__get_cpu_var(iic);
+	struct iic *iic = &__get_cpu_var(cpu_iic);
 	out_be64(&iic->regs->prio, iic->eoi_stack[--iic->eoi_ptr]);
 	BUG_ON(iic->eoi_ptr < 0);
 }
@@ -146,7 +146,7 @@ static unsigned int iic_get_irq(void)
 	struct iic *iic;
 	unsigned int virq;
 
-	iic = &__get_cpu_var(iic);
+	iic = &__get_cpu_var(cpu_iic);
 	*(unsigned long *) &pending =
 		in_be64((u64 __iomem *) &iic->regs->pending_destr);
 	if (!(pending.flags & CBE_IIC_IRQ_VALID))
@@ -161,12 +161,12 @@ static unsigned int iic_get_irq(void)
 
 void iic_setup_cpu(void)
 {
-	out_be64(&__get_cpu_var(iic).regs->prio, 0xff);
+	out_be64(&__get_cpu_var(cpu_iic).regs->prio, 0xff);
 }
 
 u8 iic_get_target_id(int cpu)
 {
-	return per_cpu(iic, cpu).target_id;
+	return per_cpu(cpu_iic, cpu).target_id;
 }
 
 EXPORT_SYMBOL_GPL(iic_get_target_id);
@@ -181,7 +181,7 @@ static inline int iic_ipi_to_irq(int ipi)
 
 void iic_cause_IPI(int cpu, int mesg)
 {
-	out_be64(&per_cpu(iic, cpu).regs->generate, (0xf - mesg) << 4);
+	out_be64(&per_cpu(cpu_iic, cpu).regs->generate, (0xf - mesg) << 4);
 }
 
 struct irq_host *iic_get_irq_host(int node)
@@ -348,7 +348,7 @@ static void __init init_one_iic(unsigned int hw_cpu, unsigned long addr,
 	/* XXX FIXME: should locate the linux CPU number from the HW cpu
 	 * number properly. We are lucky for now
 	 */
-	struct iic *iic = &per_cpu(iic, hw_cpu);
+	struct iic *iic = &per_cpu(cpu_iic, hw_cpu);
 
 	iic->regs = ioremap(addr, sizeof(struct cbe_iic_thread_regs));
 	BUG_ON(iic->regs == NULL);
diff --git a/arch/powerpc/platforms/pseries/dtl.c b/arch/powerpc/platforms/pseries/dtl.c
index 937a544..c5f3116 100644
--- a/arch/powerpc/platforms/pseries/dtl.c
+++ b/arch/powerpc/platforms/pseries/dtl.c
@@ -54,7 +54,7 @@ struct dtl {
 	int			buf_entries;
 	u64			last_idx;
 };
-static DEFINE_PER_CPU(struct dtl, dtl);
+static DEFINE_PER_CPU(struct dtl, cpu_dtl);
 
 /*
  * Dispatch trace log event mask:
@@ -261,7 +261,7 @@ static int dtl_init(void)
 
 	/* set up the per-cpu log structures */
 	for_each_possible_cpu(i) {
-		struct dtl *dtl = &per_cpu(dtl, i);
+		struct dtl *dtl = &per_cpu(cpu_dtl, i);
 		dtl->cpu = i;
 
 		rc = dtl_setup_file(dtl);
-- 
1.6.4.2

