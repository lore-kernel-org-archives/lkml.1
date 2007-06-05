Return-Path: <linux-kernel-owner+w=401wt.eu-S932202AbXFEH5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbXFEH5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 03:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762237AbXFEH5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 03:57:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52958 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760141AbXFEH5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 03:57:46 -0400
Date: Tue, 5 Jun 2007 09:57:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, pranith-kumar_d@mentorg.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] CFS scheduler, -v14
Message-ID: <20070605075706.GA2496@elte.hu>
References: <20070523120616.GA23407@elte.hu> <20070524064235.GA2386@linux.vnet.ibm.com> <20070524080959.GA29151@elte.hu> <20070525124652.GA24038@elte.hu> <4657128F.7000600@linux.vnet.ibm.com> <20070528110748.GG25331@elte.hu> <20070529102356.GB12620@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529102356.GB12620@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> +		/*
> +		 * Split up sched_exec_time according to the utime and
> +		 * stime ratio. At this point utime contains the summed
> +		 * sched_exec_runtime and stime is zero
> +		 */
> +		if (sum_us_time) {
> +			utime = ((tu_time * total_time) / sum_us_time);
> +			stime = ((ts_time * total_time) / sum_us_time);
> +		}
> +	}

hm, Dmitry Adamushko found out that this will cause rounding problems 
and might confuse 'top' - because total_time is a 10 msecs granular 
value, so under the above calculation the total of 'utime+stime' can 
shrink a bit as time goes forward. The symptom is that top will display 
a '99.9%' entry for tasks, sporadically.

I've attached below my current delta (ontop of -v15) which does the 
stime/utime splitup correctly and which includes some more enhancements 
from Dmitry - could you please take a look at this and add any deltas 
you might have ontop of it?

	Ingo

---
 Makefile                  |    2 +-
 fs/proc/array.c           |   33 ++++++++++++++++++++++++---------
 include/linux/sched.h     |    3 +--
 kernel/posix-cpu-timers.c |    2 +-
 kernel/sched.c            |   17 ++++++++++-------
 kernel/sched_debug.c      |   16 +++++++++++++++-
 kernel/sched_fair.c       |    2 +-
 kernel/sched_rt.c         |   12 ++++++++----
 8 files changed, 61 insertions(+), 26 deletions(-)

Index: linux/Makefile
===================================================================
--- linux.orig/Makefile
+++ linux/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 21
-EXTRAVERSION = .3-cfs-v15
+EXTRAVERSION = .3-cfs-v16
 NAME = Nocturnal Monster Puppy
 
 # *DOCUMENTATION*
Index: linux/fs/proc/array.c
===================================================================
--- linux.orig/fs/proc/array.c
+++ linux/fs/proc/array.c
@@ -172,8 +172,8 @@ static inline char * task_state(struct t
 		"Uid:\t%d\t%d\t%d\t%d\n"
 		"Gid:\t%d\t%d\t%d\t%d\n",
 		get_task_state(p),
-		p->tgid, p->pid,
-		pid_alive(p) ? rcu_dereference(p->real_parent)->tgid : 0,
+	       	p->tgid, p->pid,
+	       	pid_alive(p) ? rcu_dereference(p->real_parent)->tgid : 0,
 		pid_alive(p) && p->ptrace ? rcu_dereference(p->parent)->pid : 0,
 		p->uid, p->euid, p->suid, p->fsuid,
 		p->gid, p->egid, p->sgid, p->fsgid);
@@ -312,24 +312,39 @@ int proc_pid_status(struct task_struct *
 
 static clock_t task_utime(struct task_struct *p)
 {
+	clock_t utime = cputime_to_clock_t(p->utime),
+		total = utime + cputime_to_clock_t(p->stime);
+
 	/*
 	 * Use CFS's precise accounting, if available:
 	 */
-	if (!has_rt_policy(p) && !(sysctl_sched_load_smoothing & 128))
-		return nsec_to_clock_t(p->sum_exec_runtime);
+	if (!(sysctl_sched_load_smoothing & 128)) {
+		u64 temp = (u64)nsec_to_clock_t(p->sum_exec_runtime);
+
+		if (total) {
+			temp *= utime;
+			do_div(temp, total);
+		}
+		utime = (clock_t)temp;
+	}
 
-	return cputime_to_clock_t(p->utime);
+	return utime;
 }
 
 static clock_t task_stime(struct task_struct *p)
 {
+	clock_t stime = cputime_to_clock_t(p->stime),
+		total = stime + cputime_to_clock_t(p->utime);
+
 	/*
-	 * Use CFS's precise accounting, if available:
+	 * Use CFS's precise accounting, if available (we subtract
+	 * utime from the total, to make sure the total observed
+	 * by userspace grows monotonically - apps rely on that):
 	 */
-	if (!has_rt_policy(p) && !(sysctl_sched_load_smoothing & 128))
-		return 0;
+	if (!(sysctl_sched_load_smoothing & 128))
+		stime = nsec_to_clock_t(p->sum_exec_runtime) - task_utime(p);
 
-	return cputime_to_clock_t(p->stime);
+	return stime;
 }
 
 
Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -852,7 +852,6 @@ struct task_struct {
 	u64 block_max;
 	u64 exec_max;
 	u64 wait_max;
-	u64 last_ran;
 
 	s64 wait_runtime;
 	u64 sum_exec_runtime;
@@ -1235,7 +1234,7 @@ static inline int set_cpus_allowed(struc
 extern unsigned long long sched_clock(void);
 extern void sched_clock_unstable_event(void);
 extern unsigned long long
-current_sched_runtime(const struct task_struct *current_task);
+task_sched_runtime(struct task_struct *task);
 
 /* sched_exec is called by processes performing an exec */
 #ifdef CONFIG_SMP
Index: linux/kernel/posix-cpu-timers.c
===================================================================
--- linux.orig/kernel/posix-cpu-timers.c
+++ linux/kernel/posix-cpu-timers.c
@@ -161,7 +161,7 @@ static inline cputime_t virt_ticks(struc
 }
 static inline unsigned long long sched_ns(struct task_struct *p)
 {
-	return (p == current) ? current_sched_runtime(p) : p->sum_exec_runtime;
+	return task_sched_runtime(p);
 }
 
 int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *tp)
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -1227,7 +1227,7 @@ static void task_running_tick(struct rq 
  */
 static void __sched_fork(struct task_struct *p)
 {
-	p->wait_start_fair = p->wait_start = p->exec_start = p->last_ran = 0;
+	p->wait_start_fair = p->wait_start = p->exec_start = 0;
 	p->sum_exec_runtime = 0;
 
 	p->wait_runtime = 0;
@@ -2592,17 +2592,20 @@ DEFINE_PER_CPU(struct kernel_stat, kstat
 EXPORT_PER_CPU_SYMBOL(kstat);
 
 /*
- * Return current->sum_exec_runtime plus any more ns on the sched_clock
- * that have not yet been banked.
+ * Return p->sum_exec_runtime plus any more ns on the sched_clock
+ * that have not yet been banked in case the task is currently running.
  */
-unsigned long long current_sched_runtime(const struct task_struct *p)
+unsigned long long task_sched_runtime(struct task_struct *p)
 {
 	unsigned long long ns;
 	unsigned long flags;
+	struct rq *rq;
 
-	local_irq_save(flags);
-	ns = p->sum_exec_runtime + sched_clock() - p->last_ran;
-	local_irq_restore(flags);
+	rq = task_rq_lock(p, &flags);
+	ns = p->sum_exec_runtime;
+	if (rq->curr == p)
+		ns += rq_clock(rq) - p->exec_start;
+	task_rq_unlock(rq, &flags);
 
 	return ns;
 }
Index: linux/kernel/sched_debug.c
===================================================================
--- linux.orig/kernel/sched_debug.c
+++ linux/kernel/sched_debug.c
@@ -188,6 +188,18 @@ __initcall(init_sched_debug_procfs);
 
 void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 {
+	unsigned long flags;
+	int num_threads = 1;
+
+	rcu_read_lock();
+	if (lock_task_sighand(p, &flags)) {
+		num_threads = atomic_read(&p->signal->count);
+		unlock_task_sighand(p, &flags);
+	}
+	rcu_read_unlock();
+
+	SEQ_printf(m, "%s (%d, #threads: %d)\n", p->comm, p->pid, num_threads);
+	SEQ_printf(m, "----------------------------------------------\n");
 #define P(F) \
 	SEQ_printf(m, "%-25s:%20Ld\n", #F, (long long)p->F)
 
@@ -201,11 +213,13 @@ void proc_sched_show_task(struct task_st
 	P(block_max);
 	P(exec_max);
 	P(wait_max);
-	P(last_ran);
 	P(wait_runtime);
 	P(wait_runtime_overruns);
 	P(wait_runtime_underruns);
 	P(sum_exec_runtime);
+	P(load_weight);
+	P(policy);
+	P(prio);
 #undef P
 
 	{
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -200,7 +200,7 @@ static inline void update_curr(struct rq
 	 * since the last time we changed raw_weighted_load:
 	 */
 	delta_exec = now - curr->exec_start;
-	if (unlikely(delta_exec < 0))
+	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
 	if (unlikely(delta_exec > curr->exec_max))
 		curr->exec_max = delta_exec;
Index: linux/kernel/sched_rt.c
===================================================================
--- linux.orig/kernel/sched_rt.c
+++ linux/kernel/sched_rt.c
@@ -54,6 +54,7 @@ static void check_preempt_curr_rt(struct
 static struct task_struct * pick_next_task_rt(struct rq *rq, u64 now)
 {
 	struct prio_array *array = &rq->active;
+	struct task_struct *next;
 	struct list_head *queue;
 	int idx;
 
@@ -62,14 +63,17 @@ static struct task_struct * pick_next_ta
 		return NULL;
 
 	queue = array->queue + idx;
-	return list_entry(queue->next, struct task_struct, run_list);
+	next = list_entry(queue->next, struct task_struct, run_list);
+
+	next->exec_start = now;
+
+	return next;
 }
 
-/*
- * No accounting done when RT tasks are descheduled:
- */
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p, u64 now)
 {
+	p->sum_exec_runtime += now - p->exec_start;
+	p->exec_start = 0;
 }
 
 /*
