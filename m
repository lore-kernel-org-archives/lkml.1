Return-Path: <linux-kernel-owner+w=401wt.eu-S1750916AbXCQP7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750916AbXCQP7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 11:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbXCQP7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 11:59:38 -0400
Received: from sunrise.pg.gda.pl ([153.19.40.230]:37911 "EHLO
	sunrise.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbXCQP7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 11:59:37 -0400
X-Greylist: delayed 723 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Mar 2007 11:59:36 EDT
Date: Sat, 17 Mar 2007 16:47:22 +0100
From: Tomasz =?ISO-8859-2?Q?Noi=F1ski?= <noix@sphere.pl>
To: linux-kernel@vger.kernel.org
Cc: timm@kip.uni-heidelberg.de, arne.wiebalck@kip.uni-heidelberg.de
Subject: more precise CPU time accounting for x86
Message-Id: <20070317164722.1fed2b27.noix@sphere.pl>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've written a small patch for more precise process CPU time accounting
for processors with TSC.

Currently, accounting is sample-based and it can be fooled by, for
example, a process that always gives away the rest of it's timeslice.
Instead of a sample-base approach, in this approach I increment a
ticks counter (from TSC) on every context switch, not counting the time
spent inside interrupt handlers.
The patch doesn't introduce new /proc/<pid>/* files or anything - it
completely replaces current CPU time accounting, so such CPU time can
be read with wait(), times(), BSD Process Accounting etc.

The big downside it that all CPU time is accounted as "user time" and
"system time" is always 0.
I didn't know how to reasonably code this and it wasn't necessary for
my needs (I just needed a reliable sum of user and system CPU time).

The patch is based on a patch for 2.6.7 by Timm Morten Steinbeck and
Arne Wiebalck.

I would be grateful for any comments!


Best regards,
Tomasz Noinski


P.S. I think I might have found a minor bug in kernel/sched.c: in the
schedule() function, sched_info_switch(prev,next) is called even when
prev==next, but is seems inlogical and a __sched_info_switch comment
says "We are only called when prev != next."


-----------------------------8<------------------------------------

diff -urNp linux-2.6.20.3/arch/i386/kernel/irq.c linux-2.6.20.3-tscacct/arch/i386/kernel/irq.c
--- linux-2.6.20.3/arch/i386/kernel/irq.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20.3-tscacct/arch/i386/kernel/irq.c	2007-03-17 14:54:18.327759833 +0100
@@ -19,6 +19,10 @@
 #include <linux/cpu.h>
 #include <linux/delay.h>
 
+#ifdef CONFIG_TSC_ACCT
+#include <linux/timer.h>
+#endif
+
 DEFINE_PER_CPU(irq_cpustat_t, irq_stat) ____cacheline_internodealigned_in_smp;
 EXPORT_PER_CPU_SYMBOL(irq_stat);
 
@@ -61,6 +65,12 @@ fastcall unsigned int do_IRQ(struct pt_r
 	union irq_ctx *curctx, *irqctx;
 	u32 *isp;
 #endif
+#ifdef CONFIG_TSC_ACCT
+	cycles_t td, t;
+	int susp_cycles;
+	susp_cycles = last_cycles_start_susp();
+	t = get_cycles();
+#endif
 
 	if (unlikely((unsigned)irq >= NR_IRQS)) {
 		printk(KERN_EMERG "%s: cannot handle IRQ %d\n",
@@ -127,6 +137,15 @@ fastcall unsigned int do_IRQ(struct pt_r
 
 	irq_exit();
 	set_irq_regs(old_regs);
+
+#ifdef CONFIG_TSC_ACCT
+	if (likely(susp_cycles)) {
+		td = get_cycles() - t;
+		per_cpu(last_cycles, smp_processor_id()) += td;
+		last_cycles_end_susp();
+	}
+#endif
+
 	return 1;
 }
 
diff -urNp linux-2.6.20.3/arch/i386/kernel/tsc.c linux-2.6.20.3-tscacct/arch/i386/kernel/tsc.c
--- linux-2.6.20.3/arch/i386/kernel/tsc.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20.3-tscacct/arch/i386/kernel/tsc.c	2007-03-17 14:54:18.328759727 +0100
@@ -95,7 +95,7 @@ static inline void set_cyc2ns_scale(unsi
 	cyc2ns_scale = (1000000 << CYC2NS_SCALE_FACTOR)/cpu_khz;
 }
 
-static inline unsigned long long cycles_2_ns(unsigned long long cyc)
+inline unsigned long long cycles_2_ns(unsigned long long cyc)
 {
 	return (cyc * cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
 }
diff -urNp linux-2.6.20.3/include/linux/sched.h linux-2.6.20.3-tscacct/include/linux/sched.h
--- linux-2.6.20.3/include/linux/sched.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20.3-tscacct/include/linux/sched.h	2007-03-17 14:54:18.347757706 +0100
@@ -3,6 +3,10 @@
 
 #include <linux/auxvec.h>	/* For AT_VECTOR_SIZE */
 
+#ifdef CONFIG_TSC_ACCT
+#include <asm/tsc.h>
+#endif
+
 /*
  * cloning flags:
  */
@@ -884,6 +888,9 @@ struct task_struct {
 
 	unsigned long rt_priority;
 	cputime_t utime, stime;
+#ifdef CONFIG_TSC_ACCT
+	long long utime_nsecs;
+#endif
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time;
 /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
diff -urNp linux-2.6.20.3/include/linux/timer.h linux-2.6.20.3-tscacct/include/linux/timer.h
--- linux-2.6.20.3/include/linux/timer.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20.3-tscacct/include/linux/timer.h	2007-03-17 14:54:18.359756430 +0100
@@ -5,6 +5,11 @@
 #include <linux/spinlock.h>
 #include <linux/stddef.h>
 
+#ifdef CONFIG_TSC_ACCT
+#include <asm/percpu.h>
+#include <asm/tsc.h>
+#endif
+
 struct tvec_t_base_s;
 
 struct timer_list {
@@ -104,4 +109,15 @@ unsigned long round_jiffies(unsigned lon
 unsigned long round_jiffies_relative(unsigned long j);
 
 
+#ifdef CONFIG_TSC_ACCT
+DECLARE_PER_CPU(cycles_t, last_cycles);
+
+int last_cycles_start_susp(void);
+
+void last_cycles_end_susp(void);
+
+void update_process_cycles(struct task_struct *p);
+#endif
+
+
 #endif
diff -urNp linux-2.6.20.3/init/Kconfig linux-2.6.20.3-tscacct/init/Kconfig
--- linux-2.6.20.3/init/Kconfig	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20.3-tscacct/init/Kconfig	2007-03-17 14:54:18.360756324 +0100
@@ -313,6 +313,17 @@ config TASK_IO_ACCOUNTING
 
 	  Say N if unsure.
 
+config TSC_ACCT
+	bool "Precise process accounting"
+	depends on X86 && X86_TSC
+	default n
+	help
+	  Enables precise process time accounting based on a CPU timestamp
+	  counter granularity.
+	  With this option on, all processes' "cpu time" is calculated from
+	  TSC and accounted as "user cpu time". "System cpu time" for all
+	  processes is always 0.
+
 config SYSCTL
 	bool
 
diff -urNp linux-2.6.20.3/kernel/fork.c linux-2.6.20.3-tscacct/kernel/fork.c
--- linux-2.6.20.3/kernel/fork.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20.3-tscacct/kernel/fork.c	2007-03-17 14:54:18.386753560 +0100
@@ -1037,6 +1037,9 @@ static struct task_struct *copy_process(
 
 	p->utime = cputime_zero;
 	p->stime = cputime_zero;
+#ifdef CONFIG_TSC_ACCT
+	p->utime_nsecs = 0;
+#endif
  	p->sched_time = 0;
 	p->rchar = 0;		/* I/O counter: bytes read */
 	p->wchar = 0;		/* I/O counter: bytes written */
diff -urNp linux-2.6.20.3/kernel/sched.c linux-2.6.20.3-tscacct/kernel/sched.c
--- linux-2.6.20.3/kernel/sched.c	2007-03-17 13:59:24.869937402 +0100
+++ linux-2.6.20.3-tscacct/kernel/sched.c	2007-03-17 14:55:57.266238207 +0100
@@ -3547,6 +3547,9 @@ switch_tasks:
 
 	sched_info_switch(prev, next);
 	if (likely(prev != next)) {
+#ifdef CONFIG_TSC_ACCT
+		update_process_cycles(prev);
+#endif
 		next->timestamp = next->last_ran = now;
 		rq->nr_switches++;
 		rq->curr = next;
@@ -6900,6 +6903,10 @@ void __init sched_init(void)
 		struct prio_array *array;
 		struct rq *rq;
 
+#ifdef CONFIG_TSC_ACCT
+		per_cpu(last_cycles, i) = get_cycles();
+#endif
+
 		rq = cpu_rq(i);
 		spin_lock_init(&rq->lock);
 		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
diff -urNp linux-2.6.20.3/kernel/softirq.c linux-2.6.20.3-tscacct/kernel/softirq.c
--- linux-2.6.20.3/kernel/softirq.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20.3-tscacct/kernel/softirq.c	2007-03-17 14:54:18.487742820 +0100
@@ -18,6 +18,10 @@
 #include <linux/rcupdate.h>
 #include <linux/smp.h>
 
+#ifdef CONFIG_TSC_ACCT
+#include <linux/timer.h>
+#endif
+
 #include <asm/irq.h>
 /*
    - No shared variables, all the data are CPU local.
@@ -37,6 +41,7 @@
    - Tasklets: serialized wrt itself.
  */
 
+
 #ifndef __ARCH_IRQ_STAT
 irq_cpustat_t irq_stat[NR_CPUS] ____cacheline_aligned;
 EXPORT_SYMBOL(irq_stat);
@@ -209,6 +214,10 @@ asmlinkage void __do_softirq(void)
 	__u32 pending;
 	int max_restart = MAX_SOFTIRQ_RESTART;
 	int cpu;
+#ifdef CONFIG_TSC_ACCT
+	cycles_t td, t;
+	int susp_cycles;
+#endif
 
 	pending = local_softirq_pending();
 	account_system_vtime(current);
@@ -227,8 +236,19 @@ restart:
 
 	do {
 		if (pending & 1) {
+#ifdef CONFIG_TSC_ACCT
+			susp_cycles = last_cycles_start_susp();
+			t = get_cycles();
+#endif
 			h->action(h);
 			rcu_bh_qsctr_inc(cpu);
+#ifdef CONFIG_TSC_ACCT
+			if (likely(susp_cycles)) {
+				td = get_cycles() - t;
+				per_cpu(last_cycles, cpu) += td;
+				last_cycles_end_susp();
+			}
+#endif
 		}
 		h++;
 		pending >>= 1;
diff -urNp linux-2.6.20.3/kernel/timer.c linux-2.6.20.3-tscacct/kernel/timer.c
--- linux-2.6.20.3/kernel/timer.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20.3-tscacct/kernel/timer.c	2007-03-17 16:02:03.809253701 +0100
@@ -1106,10 +1106,12 @@ void update_process_times(int user_tick)
 	int cpu = smp_processor_id();
 
 	/* Note: this timer irq context must be accounted for as well. */
+#ifndef CONFIG_TSC_ACCT
 	if (user_tick)
 		account_user_time(p, jiffies_to_cputime(1));
 	else
 		account_system_time(p, HARDIRQ_OFFSET, jiffies_to_cputime(1));
+#endif
 	run_local_timers();
 	if (rcu_pending(cpu))
 		rcu_check_callbacks(cpu, user_tick);
@@ -1834,3 +1836,55 @@ unsigned long msleep_interruptible(unsig
 }
 
 EXPORT_SYMBOL(msleep_interruptible);
+
+#ifdef CONFIG_TSC_ACCT
+DEFINE_PER_CPU(cycles_t, last_cycles);
+
+static DEFINE_PER_CPU(int, last_cycles_susp) = 0;
+static DEFINE_PER_CPU(spinlock_t, last_cycles_susp_lock) = SPIN_LOCK_UNLOCKED;
+
+
+unsigned long long cycles_2_ns(unsigned long long cyc);
+
+int last_cycles_start_susp(void)
+{
+	unsigned long flags;
+	int cpu = smp_processor_id();
+	bool ret = 0;
+	spin_lock_irqsave(&per_cpu(last_cycles_susp_lock, cpu), flags);
+	if (likely(!per_cpu(last_cycles_susp, cpu))) {
+		per_cpu(last_cycles_susp, cpu) = 1;
+		ret = 1;
+	} else {
+		ret = 0;
+	}
+	spin_unlock_irqrestore(&per_cpu(last_cycles_susp_lock, cpu), flags);
+	return ret;
+}
+
+void last_cycles_end_susp(void) {
+	per_cpu(last_cycles_susp, smp_processor_id()) = 0;
+}
+
+void update_process_cycles(struct task_struct *p)
+{
+	cputime_t cputime;
+	cycles_t cycles;
+	long long msecs;
+	int cpu = smp_processor_id();
+	cycles_t t;
+	unsigned long flags;
+	
+	t = get_cycles();
+	cycles = t - per_cpu(last_cycles, cpu);
+	msecs = cycles_2_ns(cycles); /* msecs is still in nanoseconds here */
+	p->utime_nsecs += do_div(msecs, 1000000); /* in milliseconds now */
+	while (p->utime_nsecs >= 1000000) {
+		p->utime_nsecs -= 1000000;
+		msecs++;
+	}
+	cputime = msecs_to_cputime(msecs);
+	account_user_time(p, cputime);
+	per_cpu(last_cycles, cpu) = t;
+}
+#endif
diff -urNp linux-2.6.20.3/localversion-tscacct linux-2.6.20.3-tscacct/localversion-tscacct
--- linux-2.6.20.3/localversion-tscacct	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.20.3-tscacct/localversion-tscacct	2007-03-17 14:56:43.796289963 +0100
@@ -0,0 +1 @@
+-tscacct

-----------------------------8<------------------------------------
