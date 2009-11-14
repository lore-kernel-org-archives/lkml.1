Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZKNGfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZKNGfJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 01:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZKNGfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 01:35:08 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:43210 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbZKNGfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 01:35:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=E+DwuLuwQoMRPiRD4H8obDKsMZGREX0y9TtIFSORtSLkvIUgYc2cHkK+14GbObamGg
         jeXxNpjJytncTnu76nLvZkE9jaAVHwrrrDF9cJTKRmfklMJCEqLbzgPLUwC+/01JHxPp
         q088TesjlDvm5TcBhhh9qoycUqC55/EEA3qto=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: rostedt@goodmis.org, Ralf Baechle <ralf@linux-mips.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>,
       "Maciej W . Rozycki" <macro@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, zhangfx@lemote.com, zhouqg@gmail.com
Subject: [PATCH v8 08/16] tracing: add IRQENTRY_EXIT section for MIPS
Date: Sat, 14 Nov 2009 14:33:23 +0800
Message-Id: <99ebd8fcb19e4cccd702fca966405ffc45f8540b.1258177321.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <48676d84140dbafd46e530611766121e18abc4ef.1258177321.git.wuzhangjin@gmail.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1258177321.git.wuzhangjin@gmail.com>
 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1258177321.git.wuzhangjin@gmail.com>
 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1258177321.git.wuzhangjin@gmail.com>
 <ea337742d3ca7eec2825416041a6d4fa917d5cc4.1258177321.git.wuzhangjin@gmail.com>
 <7c7568247ad6cc109ec20387cfc3ca258d1d430f.1258177321.git.wuzhangjin@gmail.com>
 <3fcaffcfb3c8c8cd3015151ed5b7480ccaecde0f.1258177321.git.wuzhangjin@gmail.com>
 <48676d84140dbafd46e530611766121e18abc4ef.1258177321.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1258177321.git.wuzhangjin@gmail.com>
References: <cover.1258177321.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

This patch add a new section for MIPS to record the block of the hardirq
handling for function graph tracer(print_graph_irq) via adding the
__irq_entry annotation to the the entrypoints of the hardirqs(the block
with irq_enter()...irq_exit()).

Thanks goes to Steven & Frederic Weisbecker for their feedbacks.

Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/include/asm/irq.h    |   29 ++---------------------------
 arch/mips/kernel/irq.c         |   30 ++++++++++++++++++++++++++++++
 arch/mips/kernel/smp.c         |    3 ++-
 arch/mips/kernel/smtc.c        |   21 ++++++++++++++-------
 arch/mips/kernel/vmlinux.lds.S |    1 +
 arch/mips/sgi-ip22/ip22-int.c  |    3 ++-
 arch/mips/sgi-ip22/ip22-time.c |    3 ++-
 7 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/arch/mips/include/asm/irq.h b/arch/mips/include/asm/irq.h
index 09b08d0..0696036 100644
--- a/arch/mips/include/asm/irq.h
+++ b/arch/mips/include/asm/irq.h
@@ -113,36 +113,11 @@ do {									\
 
 #endif
 
-/*
- * do_IRQ handles all normal device IRQ's (the special
- * SMP cross-CPU interrupts have their own specific
- * handlers).
- *
- * Ideally there should be away to get this into kernel/irq/handle.c to
- * avoid the overhead of a call for just a tiny function ...
- */
-#define do_IRQ(irq)							\
-do {									\
-	irq_enter();							\
-	__DO_IRQ_SMTC_HOOK(irq);					\
-	generic_handle_irq(irq);					\
-	irq_exit();							\
-} while (0)
+extern void do_IRQ(unsigned int irq);
 
 #ifdef CONFIG_MIPS_MT_SMTC_IRQAFF
-/*
- * To avoid inefficient and in some cases pathological re-checking of
- * IRQ affinity, we have this variant that skips the affinity check.
- */
-
 
-#define do_IRQ_no_affinity(irq)						\
-do {									\
-	irq_enter();							\
-	__NO_AFFINITY_IRQ_SMTC_HOOK(irq);				\
-	generic_handle_irq(irq);					\
-	irq_exit();							\
-} while (0)
+extern void do_IRQ_no_affinity(unsigned int irq);
 
 #endif /* CONFIG_MIPS_MT_SMTC_IRQAFF */
 
diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index 7b845ba..dee8d5f 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -22,6 +22,7 @@
 #include <linux/seq_file.h>
 #include <linux/kallsyms.h>
 #include <linux/kgdb.h>
+#include <linux/ftrace.h>
 
 #include <asm/atomic.h>
 #include <asm/system.h>
@@ -150,3 +151,32 @@ void __init init_IRQ(void)
 		kgdb_early_setup = 1;
 #endif
 }
+
+/*
+ * do_IRQ handles all normal device IRQ's (the special
+ * SMP cross-CPU interrupts have their own specific
+ * handlers).
+ */
+void __irq_entry do_IRQ(unsigned int irq)
+{
+	irq_enter();
+	__DO_IRQ_SMTC_HOOK(irq);
+	generic_handle_irq(irq);
+	irq_exit();
+}
+
+#ifdef CONFIG_MIPS_MT_SMTC_IRQAFF
+/*
+ * To avoid inefficient and in some cases pathological re-checking of
+ * IRQ affinity, we have this variant that skips the affinity check.
+ */
+
+void __irq_entry do_IRQ_no_affinity(unsigned int irq)
+{
+	irq_enter();
+	__NO_AFFINITY_IRQ_SMTC_HOOK(irq);
+	generic_handle_irq(irq);
+	irq_exit();
+}
+
+#endif /* CONFIG_MIPS_MT_SMTC_IRQAFF */
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index e72e684..6cdca19 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -32,6 +32,7 @@
 #include <linux/cpumask.h>
 #include <linux/cpu.h>
 #include <linux/err.h>
+#include <linux/ftrace.h>
 
 #include <asm/atomic.h>
 #include <asm/cpu.h>
@@ -130,7 +131,7 @@ asmlinkage __cpuinit void start_secondary(void)
 /*
  * Call into both interrupt handlers, as we share the IPI for them
  */
-void smp_call_function_interrupt(void)
+void __irq_entry smp_call_function_interrupt(void)
 {
 	irq_enter();
 	generic_smp_call_function_single_interrupt();
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index 24630fd..75034a8 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/module.h>
+#include <linux/ftrace.h>
 
 #include <asm/cpu.h>
 #include <asm/processor.h>
@@ -939,23 +940,29 @@ static void ipi_call_interrupt(void)
 
 DECLARE_PER_CPU(struct clock_event_device, mips_clockevent_device);
 
-void ipi_decode(struct smtc_ipi *pipi)
+static void __irq_entry smtc_clock_tick_interrupt(void)
 {
 	unsigned int cpu = smp_processor_id();
 	struct clock_event_device *cd;
+	int irq = MIPS_CPU_IRQ_BASE + 1;
+
+	irq_enter();
+	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
+	cd = &per_cpu(mips_clockevent_device, cpu);
+	cd->event_handler(cd);
+	irq_exit();
+}
+
+void ipi_decode(struct smtc_ipi *pipi)
+{
 	void *arg_copy = pipi->arg;
 	int type_copy = pipi->type;
-	int irq = MIPS_CPU_IRQ_BASE + 1;
 
 	smtc_ipi_nq(&freeIPIq, pipi);
 
 	switch (type_copy) {
 	case SMTC_CLOCK_TICK:
-		irq_enter();
-		kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
-		cd = &per_cpu(mips_clockevent_device, cpu);
-		cd->event_handler(cd);
-		irq_exit();
+		smtc_clock_tick_interrupt();
 		break;
 
 	case LINUX_SMP_IPI:
diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 162b299..f25df73 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -46,6 +46,7 @@ SECTIONS
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
+		IRQENTRY_TEXT
 		*(.text.*)
 		*(.fixup)
 		*(.gnu.warning)
diff --git a/arch/mips/sgi-ip22/ip22-int.c b/arch/mips/sgi-ip22/ip22-int.c
index 0ecd5fe..383f11d 100644
--- a/arch/mips/sgi-ip22/ip22-int.c
+++ b/arch/mips/sgi-ip22/ip22-int.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/kernel_stat.h>
 #include <linux/interrupt.h>
+#include <linux/ftrace.h>
 
 #include <asm/irq_cpu.h>
 #include <asm/sgi/hpc3.h>
@@ -150,7 +151,7 @@ static void indy_local1_irqdispatch(void)
 
 extern void ip22_be_interrupt(int irq);
 
-static void indy_buserror_irq(void)
+static void __irq_entry indy_buserror_irq(void)
 {
 	int irq = SGI_BUSERR_IRQ;
 
diff --git a/arch/mips/sgi-ip22/ip22-time.c b/arch/mips/sgi-ip22/ip22-time.c
index c8f7d23..603fc91 100644
--- a/arch/mips/sgi-ip22/ip22-time.c
+++ b/arch/mips/sgi-ip22/ip22-time.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/time.h>
+#include <linux/ftrace.h>
 
 #include <asm/cpu.h>
 #include <asm/mipsregs.h>
@@ -115,7 +116,7 @@ __init void plat_time_init(void)
 }
 
 /* Generic SGI handler for (spurious) 8254 interrupts */
-void indy_8254timer_irq(void)
+void __irq_entry indy_8254timer_irq(void)
 {
 	int irq = SGI_8254_0_IRQ;
 	ULONG cnt;
-- 
1.6.2.1

