Return-Path: <linux-kernel-owner+w=401wt.eu-S1760004AbZAWNg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004AbZAWNg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 08:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbZAWNgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 08:36:21 -0500
Received: from mail.gmx.net ([213.165.64.20]:54964 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753818AbZAWNgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 08:36:20 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/oERUGpOroGZiHGGH2loBotOK+RTobWHHYsFjajm
	r963uy4Bty8M+n
Subject: Re: [patch] ratelimit performance counter interrupts
From: Mike Galbraith <efault@gmx.de>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <b9df5fa10901230532v57acec78qe949c44c4be2fbd9@mail.gmail.com>
References: <1232716030.8750.11.camel@marge.simson.net>
	 <b9df5fa10901230532v57acec78qe949c44c4be2fbd9@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 14:36:16 +0100
Message-Id: <1232717776.8978.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-23 at 19:32 +0600, Rakib Mullick wrote:
> On 1/23/09, Mike Galbraith <efault@gmx.de> wrote:
> 
> >  + * Mamimum interrupt frequency of 100KHz per CPU
> >  + */
> 
> Hi Mike, I think you misspelled the word Maximum here.

Yup, thanks.

Ratelimit performance counter interrupts to 100KHz per CPU.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 arch/x86/kernel/apic.c             |    2 +
 arch/x86/kernel/cpu/perf_counter.c |   43 ++++++++++++++++++++++++++++++-------
 include/linux/perf_counter.h       |    2 +
 3 files changed, 40 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic.c
+++ linux-2.6/arch/x86/kernel/apic.c
@@ -781,6 +781,8 @@ static void local_apic_timer_interrupt(v
 	inc_irq_stat(apic_timer_irqs);
 
 	evt->event_handler(evt);
+
+	perf_counter_unthrottle();
 }
 
 /*
Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -33,6 +33,8 @@ static int nr_counters_fixed __read_most
 struct cpu_hw_counters {
 	struct perf_counter	*counters[X86_PMC_IDX_MAX];
 	unsigned long		used[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	unsigned long		interrupts;
+	u64			global_enable;
 };
 
 /*
@@ -468,23 +470,26 @@ perf_handle_group(struct perf_counter *s
 }
 
 /*
+ * Maximum interrupt frequency of 100KHz per CPU
+ */
+#define PERFMON_MAX_INTERRUPTS 100000/HZ
+
+/*
  * This handler is triggered by the local APIC, so the APIC IRQ handling
  * rules apply:
  */
 static void __smp_perf_counter_interrupt(struct pt_regs *regs, int nmi)
 {
 	int bit, cpu = smp_processor_id();
-	u64 ack, status, saved_global;
-	struct cpu_hw_counters *cpuc;
+	u64 ack, status;
+	struct cpu_hw_counters *cpuc = &per_cpu(cpu_hw_counters, cpu);
 
-	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, saved_global);
+	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, cpuc->global_enable);
 
 	/* Disable counters globally */
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 	ack_APIC_irq();
 
-	cpuc = &per_cpu(cpu_hw_counters, cpu);
-
 	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
 	if (!status)
 		goto out;
@@ -533,9 +538,33 @@ again:
 		goto again;
 out:
 	/*
-	 * Restore - do not reenable when global enable is off:
+	 * Restore - do not reenable when global enable is off or throttled:
 	 */
-	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, saved_global);
+	if (++cpuc->interrupts < PERFMON_MAX_INTERRUPTS)
+		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, cpuc->global_enable);
+}
+
+void perf_counter_unthrottle(void)
+{
+	struct cpu_hw_counters *cpuc;
+	u64 global_enable;
+
+	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
+		return;
+
+	if (unlikely(!perf_counters_initialized))
+		return;
+
+	cpuc = &per_cpu(cpu_hw_counters, smp_processor_id());
+	if (cpuc->interrupts >= PERFMON_MAX_INTERRUPTS) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING "PERFMON: max interrupts exceeded!\n");
+		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, cpuc->global_enable);
+	}
+	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, global_enable);
+	if (unlikely(cpuc->global_enable && !global_enable))
+		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, cpuc->global_enable);
+	cpuc->interrupts = 0;
 }
 
 void smp_perf_counter_interrupt(struct pt_regs *regs)
Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -254,6 +254,7 @@ extern void perf_counter_init_task(struc
 extern void perf_counter_exit_task(struct task_struct *child);
 extern void perf_counter_notify(struct pt_regs *regs);
 extern void perf_counter_print_debug(void);
+extern void perf_counter_unthrottle(void);
 extern u64 hw_perf_save_disable(void);
 extern void hw_perf_restore(u64 ctrl);
 extern int perf_counter_task_disable(void);
@@ -281,6 +282,7 @@ static inline void perf_counter_init_tas
 static inline void perf_counter_exit_task(struct task_struct *child)	{ }
 static inline void perf_counter_notify(struct pt_regs *regs)		{ }
 static inline void perf_counter_print_debug(void)			{ }
+static inline void perf_counter_unthrottle(void)			{ }
 static inline void hw_perf_restore(u64 ctrl)			{ }
 static inline u64 hw_perf_save_disable(void)		      { return 0; }
 static inline int perf_counter_task_disable(void)	{ return -EINVAL; }


