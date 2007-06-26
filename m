Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbXFZIjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbXFZIjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbXFZIjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:39:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55388 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbXFZIjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:39:09 -0400
Date: Tue, 26 Jun 2007 10:38:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070626083813.GA16151@elte.hu>
References: <20070622220202.GA16872@elte.hu> <200706230109.08310.caglar@pardus.org.tr> <200706230116.29615.caglar@pardus.org.tr> <20070622222036.GC27445@elte.hu> <20070625200235.9d24f6cd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625200235.9d24f6cd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> So I locally generated the diff to take -mm up to the above version of 
> CFS.

thx. I released a diff against mm2:

 http://people.redhat.com/mingo/cfs-scheduler/sched-cfs-v2.6.22-rc4-mm2-v18.patch

but indeed the -git diff serves you better if you updated -mm to Linus' 
latest.

firstly, thanks a ton for your review feedback!

> - sys_sched_yield_to() went away?  I guess I missed that.

yep. Nobody tried it and sent any feedback on it, it was causing 
patch-logistical complications both in -mm and for packagers that bundle 
CFS (the experimental-schedulers site has a CFS repo and Fedora rawhide 
started carrying CFS recently as well), and i dont really agree with 
adding yet another yield interface anyway. So we can and should do this 
independently of CFS.

> - Curious.  the simplification of task_tick_rt() seems to go only
>   halfway.  Could do
> 
> 	if (p->policy != SCHED_RR)
> 		return;
> 
> 	if (--p->time_slice)
> 		return;
> 
> 	/* stuff goes here */

yeah. I have fixed it in my v19 tree for it to look like you suggest.

> - dud macro:
> 					
> #define is_rt_policy(p)		((p) == SCHED_FIFO || (p) == SCHED_RR)
> 
>   It evaluates its arg twice and could and should be coded in C.
> 
>   There are a bunch of other don't-need-to-be-implemented-as-a-macro
>   macros around there too.  Generally, I suggest you review all the
>   patchset for macros-which-don't-need-to-be-macros.

yep, fixed. (is a historic macro)

> - Extraneous newline:
> 
> enum cpu_idle_type
> {

fixed. (is a pre-existing enum)

> - Style thing:
> 
> struct sched_entity {

> 	u64 sleep_start, sleep_start_fair;

fixed.

> - None of these fields have comments describing what they do ;)

one of them has ;-) Will fill this in.

> - __exit_signal() does apparently-unlocked 64-bit arith.  Is there 
>   some implicit locking here or do we not care about the occasional 
>   race-induced inaccuracy?

do you mean the tsk->se.sum_exec_runtime addition, etc? That runs with 
interrupts disabled so sum_sched_runtime is protected.

>   (ditto, lots of places, I expect)

which places do you mean?

>   (Gee, there's shitloads of 64-bit stuff in there.  Does it all 
>   _really_ need to be 64-bit on 32-bit?)

yes - CFS is fundamentally designed for 64-bit, with still pretty OK 
arithmetics performance for 32-bit.

> - weight_s64() (what does this do?) looks too big to inline on 32-bit.

ok, i've uninlined it.

> - update_stats_enqueue() looks too big to inline even on 64-bit.

done.

> - Overall, this change is tremendously huge for something which is
>   supposedly ready-to-merge. [...]

hey, that's not fair, your review comments just made it 10K larger ;-)

> [...] Looks like a lot of that is the sched_entity conversion, but 
> afaict there's quite a lot besides.
> 
> - Should "4" in
> 
> 	(sysctl_sched_features & 4)
> 
>   be enumerated?

yep, done.

> - Maybe even __check_preempt_curr_fair() is too porky to inline.

yep - undone.

> - There really is an astonishing amount of 64-bit arith in here...
> 
> - Some opportunities for useful comments have been missed ;)
> 
> #define NICE_0_LOAD	SCHED_LOAD_SCALE
> #define NICE_0_SHIFT	SCHED_LOAD_SHIFT
> 
>   <wonders what these mean>

SCHED_LOAD_SCALE is the smpnice stuff. CFS reuses that and also makes it 
clear via this define that a nice-0 task has a 'load' contribution to 
the CPU as of NICE_0_LOAD. Sometimes, when doing smpnice load-balancing 
calculations we want to use 'SCHED_LOAD_SCALE', sometimes we want to 
stress it's NICE_0_LOAD.

> - Should any of those new 64-bit arith functions in sched.c be pulled 
>   out and made generic?

yep, the plan is to put this all into reciprocal_div.h and to convert 
existing users of reciprocal_div to the cleaner stuff from Thomas. The 
patch wont get any smaller due to that though ;-)

> - update_curr_load() is huge, inlined and has several callsites?

this is a reasonable tradeoff i think - update_curr_load()'s slowpath is 
in __update_curr_load(). Anyway, it probably wont get inlined when the 
kernel is built with -Os and without forced-inlining.

> - lots more macros-which-dont-need-to-be-macros in sched.c:
>   load_weight(), PRIO_TO_load_weight(), RTPRIO_TO_load_weight(), maybe
>   others.  People are more inclined to comment functions than they are
>   macros, for some reason.

these are mostly ancient macros. I fixed up some of them in my current 
tree.

> - inc_load(), dec_load(), inc_nr_running(), dec_nr_running(): these will
>   generate plenty of code on 32-bit and they're all inlined with 
>   multiple callsites.

yep - i'll revisit the inlining picture. This is not really a primary 
worry i think because it's easy to tweak and people can already express 
their inlining preference via CONFIG_CC_OPTIMIZE_FOR_SIZE and 
CONFIG_FORCED_INLINING.

> - overall, CFS takes sched.o from 41157 of .text up to 48781 on x86_64,
>   which at 18% is rather a large bloat.  Hopefully a lot of this is 
>   the new debug stuff.

> - On i386 sched.o went from 33755 up to 43660 which is 29% growth. 
>   Possibly acceptable, but why did it increase a lot more than the x86_64
>   version?  All that 64-bit arith, I assume?

the main reason is the sched debugging stuff:

   text    data     bss     dec     hex filename
  37570    2538      20   40128    9cc0 kernel/sched.o
  30692    2426      20   33138    8172 kernel/sched-no_sched_debug.o

i can make it depend on CONFIG_SCHEDSTATS, although i'd prefer it to be 
always on.

> - style (or the lack thereof):
> 
> 	p->se.sum_wait_runtime = p->se.sum_sleep_runtime = 0;
> 	p->se.sleep_start = p->se.sleep_start_fair = p->se.block_start = 0;
> 	p->se.sleep_max = p->se.block_max = p->se.exec_max = p->se.wait_max = 0;
> 	p->se.wait_runtime_overruns = p->se.wait_runtime_underruns = 0;
> 
>   bit of an eyesore?

fixed. (this heap grew gradually and now is/was an eyesore indeed.)

> - in sched_init() this looks funny:
> 
> 		rq->ls.load_update_last = sched_clock();
> 		rq->ls.load_update_start = sched_clock();
> 
>   was it intended that these both get the same value?

it doesnt really matter, i fixed them to be initialized to the same 
'now' value.

i've attached my current fixes. (Please dont apply it yet.)

	Ingo

Not-Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 Makefile              |    2 
 include/linux/sched.h |  120 +++++++++++++++++++++++++++++---------------------
 kernel/exit.c         |    2 
 kernel/sched.c        |   58 ++++++++++++++++--------
 kernel/sched_debug.c  |    2 
 kernel/sched_fair.c   |   61 ++++++++++++-------------
 kernel/sched_rt.c     |   15 +++---
 7 files changed, 149 insertions(+), 111 deletions(-)

Index: linux/Makefile
===================================================================
--- linux.orig/Makefile
+++ linux/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 22
-EXTRAVERSION = -rc6-cfs-v18
+EXTRAVERSION = -rc6-cfs-v19
 NAME = Holy Dancing Manatees, Batman!
 
 # *DOCUMENTATION*
Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -528,31 +528,6 @@ struct signal_struct {
 #define SIGNAL_STOP_CONTINUED	0x00000004 /* SIGCONT since WCONTINUED reap */
 #define SIGNAL_GROUP_EXIT	0x00000008 /* group exit in progress */
 
-
-/*
- * Priority of a process goes from 0..MAX_PRIO-1, valid RT
- * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
- * tasks are in the range MAX_RT_PRIO..MAX_PRIO-1. Priority
- * values are inverted: lower p->prio value means higher priority.
- *
- * The MAX_USER_RT_PRIO value allows the actual maximum
- * RT priority to be separate from the value exported to
- * user-space.  This allows kernel threads to set their
- * priority to a value higher than any user task. Note:
- * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
- */
-
-#define MAX_USER_RT_PRIO	100
-#define MAX_RT_PRIO		MAX_USER_RT_PRIO
-
-#define MAX_PRIO		(MAX_RT_PRIO + 40)
-#define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
-
-#define rt_prio(prio)		unlikely((prio) < MAX_RT_PRIO)
-#define rt_task(p)		rt_prio((p)->prio)
-#define is_rt_policy(p)		((p) == SCHED_FIFO || (p) == SCHED_RR)
-#define has_rt_policy(p)	unlikely(is_rt_policy((p)->policy))
-
 /*
  * Some day this will be a full-fledged user tracking system..
  */
@@ -646,8 +621,7 @@ static inline int sched_info_on(void)
 #endif
 }
 
-enum cpu_idle_type
-{
+enum cpu_idle_type {
 	CPU_IDLE,
 	CPU_NOT_IDLE,
 	CPU_NEWLY_IDLE,
@@ -843,30 +817,45 @@ struct load_weight {
 	unsigned long weight, inv_weight;
 };
 
-/* CFS stats for a schedulable entity (task, task-group etc) */
+/*
+ * CFS stats for a schedulable entity (task, task-group etc)
+ *
+ * Current field usage histogram:
+ *
+ *     4 se->block_start
+ *     4 se->run_node
+ *     4 se->sleep_start
+ *     4 se->sleep_start_fair
+ *     6 se->load.weight
+ *     7 se->delta_fair
+ *    15 se->wait_runtime
+ */
 struct sched_entity {
-	struct load_weight load;	/* for nice- load-balancing purposes */
-	int on_rq;
-	struct rb_node run_node;
-	unsigned long delta_exec;
-	s64 delta_fair;
-
-	u64 wait_start_fair;
-	u64 wait_start;
-	u64 exec_start;
-	u64 sleep_start, sleep_start_fair;
-	u64 block_start;
-	u64 sleep_max;
-	u64 block_max;
-	u64 exec_max;
-	u64 wait_max;
-	u64 last_ran;
-
-	s64 wait_runtime;
-	u64 sum_exec_runtime;
-	s64 fair_key;
-	s64 sum_wait_runtime, sum_sleep_runtime;
-	unsigned long wait_runtime_overruns, wait_runtime_underruns;
+	s64			wait_runtime;
+	s64			delta_fair;
+	struct load_weight	load;		/* for load-balancing */
+	struct rb_node		run_node;
+	int			on_rq;
+	unsigned long		delta_exec;
+
+	u64			wait_start_fair;
+	u64			wait_start;
+	u64			exec_start;
+	u64			sleep_start;
+	u64			sleep_start_fair;
+	u64			block_start;
+	u64			sleep_max;
+	u64			block_max;
+	u64			exec_max;
+	u64			wait_max;
+	u64			last_ran;
+
+	u64			sum_exec_runtime;
+	s64			fair_key;
+	s64			sum_wait_runtime;
+	s64			sum_sleep_runtime;
+	unsigned long		wait_runtime_overruns;
+	unsigned long		wait_runtime_underruns;
 };
 
 struct task_struct {
@@ -1126,6 +1115,37 @@ struct task_struct {
 #endif
 };
 
+/*
+ * Priority of a process goes from 0..MAX_PRIO-1, valid RT
+ * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
+ * tasks are in the range MAX_RT_PRIO..MAX_PRIO-1. Priority
+ * values are inverted: lower p->prio value means higher priority.
+ *
+ * The MAX_USER_RT_PRIO value allows the actual maximum
+ * RT priority to be separate from the value exported to
+ * user-space.  This allows kernel threads to set their
+ * priority to a value higher than any user task. Note:
+ * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
+ */
+
+#define MAX_USER_RT_PRIO	100
+#define MAX_RT_PRIO		MAX_USER_RT_PRIO
+
+#define MAX_PRIO		(MAX_RT_PRIO + 40)
+#define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
+
+static inline int rt_prio(int prio)
+{
+	if (unlikely(prio < MAX_RT_PRIO))
+		return 1;
+	return 0;
+}
+
+static inline int rt_task(struct task_struct *p)
+{
+	return rt_prio(p->prio);
+}
+
 static inline pid_t process_group(struct task_struct *tsk)
 {
 	return tsk->signal->pgrp;
Index: linux/kernel/exit.c
===================================================================
--- linux.orig/kernel/exit.c
+++ linux/kernel/exit.c
@@ -290,7 +290,7 @@ static void reparent_to_kthreadd(void)
 	/* Set the exit signal to SIGCHLD so we signal init on exit */
 	current->exit_signal = SIGCHLD;
 
-	if (!has_rt_policy(current) && (task_nice(current) < 0))
+	if (task_nice(current) < 0)
 		set_user_nice(current, 0);
 	/* cpus_allowed? */
 	/* rt_priority? */
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -106,6 +106,18 @@ unsigned long long __attribute__((weak))
 #define MIN_TIMESLICE		max(5 * HZ / 1000, 1)
 #define DEF_TIMESLICE		(100 * HZ / 1000)
 
+static inline int rt_policy(int policy)
+{
+	if (unlikely(policy == SCHED_FIFO) || unlikely(policy == SCHED_RR))
+		return 1;
+	return 0;
+}
+
+static inline int task_has_rt_policy(struct task_struct *p)
+{
+	return rt_policy(p->policy);
+}
+
 /*
  * This is the priority-queue data structure of the RT scheduling class:
  */
@@ -752,7 +764,7 @@ static void set_load_weight(struct task_
 	task_rq(p)->cfs.wait_runtime -= p->se.wait_runtime;
 	p->se.wait_runtime = 0;
 
-	if (has_rt_policy(p)) {
+	if (task_has_rt_policy(p)) {
 		p->se.load.weight = prio_to_weight[0] * 2;
 		p->se.load.inv_weight = prio_to_wmult[0] >> 1;
 		return;
@@ -805,7 +817,7 @@ static inline int normal_prio(struct tas
 {
 	int prio;
 
-	if (has_rt_policy(p))
+	if (task_has_rt_policy(p))
 		prio = MAX_RT_PRIO-1 - p->rt_priority;
 	else
 		prio = __normal_prio(p);
@@ -1476,17 +1488,24 @@ int fastcall wake_up_state(struct task_s
  */
 static void __sched_fork(struct task_struct *p)
 {
-	p->se.wait_start_fair = p->se.wait_start = p->se.exec_start = 0;
-	p->se.sum_exec_runtime = 0;
-	p->se.delta_exec = 0;
-	p->se.delta_fair = 0;
-
-	p->se.wait_runtime = 0;
-
-	p->se.sum_wait_runtime = p->se.sum_sleep_runtime = 0;
-	p->se.sleep_start = p->se.sleep_start_fair = p->se.block_start = 0;
-	p->se.sleep_max = p->se.block_max = p->se.exec_max = p->se.wait_max = 0;
-	p->se.wait_runtime_overruns = p->se.wait_runtime_underruns = 0;
+	p->se.wait_start_fair		= 0;
+	p->se.wait_start		= 0;
+	p->se.exec_start		= 0;
+	p->se.sum_exec_runtime		= 0;
+	p->se.delta_exec		= 0;
+	p->se.delta_fair		= 0;
+	p->se.wait_runtime		= 0;
+	p->se.sum_wait_runtime		= 0;
+	p->se.sum_sleep_runtime		= 0;
+	p->se.sleep_start		= 0;
+	p->se.sleep_start_fair		= 0;
+	p->se.block_start		= 0;
+	p->se.sleep_max			= 0;
+	p->se.block_max			= 0;
+	p->se.exec_max			= 0;
+	p->se.wait_max			= 0;
+	p->se.wait_runtime_overruns	= 0;
+	p->se.wait_runtime_underruns	= 0;
 
 	INIT_LIST_HEAD(&p->run_list);
 	p->se.on_rq = 0;
@@ -1799,7 +1818,7 @@ static void update_cpu_load(struct rq *t
 	int i, scale;
 
 	this_rq->nr_load_updates++;
-	if (sysctl_sched_features & 64)
+	if (unlikely(!(sysctl_sched_features & SCHED_FEAT_PRECISE_CPU_LOAD)))
 		goto do_avg;
 
 	/* Update delta_fair/delta_exec fields first */
@@ -3801,7 +3820,7 @@ void set_user_nice(struct task_struct *p
 	 * it wont have any effect on scheduling until the task is
 	 * SCHED_FIFO/SCHED_RR:
 	 */
-	if (has_rt_policy(p)) {
+	if (task_has_rt_policy(p)) {
 		p->static_prio = NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
@@ -3999,14 +4018,14 @@ recheck:
 	    (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
 	    (!p->mm && param->sched_priority > MAX_RT_PRIO-1))
 		return -EINVAL;
-	if (is_rt_policy(policy) != (param->sched_priority != 0))
+	if (rt_policy(policy) != (param->sched_priority != 0))
 		return -EINVAL;
 
 	/*
 	 * Allow unprivileged RT tasks to decrease priority:
 	 */
 	if (!capable(CAP_SYS_NICE)) {
-		if (is_rt_policy(policy)) {
+		if (rt_policy(policy)) {
 			unsigned long rlim_rtprio;
 			unsigned long flags;
 
@@ -6186,6 +6205,7 @@ int in_sched_functions(unsigned long add
 
 void __init sched_init(void)
 {
+	u64 now = sched_clock();
 	int highest_cpu = 0;
 	int i, j;
 
@@ -6206,8 +6226,8 @@ void __init sched_init(void)
 		rq->nr_running = 0;
 		rq->cfs.tasks_timeline = RB_ROOT;
 		rq->clock = rq->cfs.fair_clock = 1;
-		rq->ls.load_update_last = sched_clock();
-		rq->ls.load_update_start = sched_clock();
+		rq->ls.load_update_last = now;
+		rq->ls.load_update_start = now;
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
 			rq->cpu_load[j] = 0;
Index: linux/kernel/sched_debug.c
===================================================================
--- linux.orig/kernel/sched_debug.c
+++ linux/kernel/sched_debug.c
@@ -157,7 +157,7 @@ static int sched_debug_show(struct seq_f
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Sched Debug Version: v0.03, cfs-v18, %s %.*s\n",
+	SEQ_printf(m, "Sched Debug Version: v0.03, cfs-v19, %s %.*s\n",
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -61,8 +61,24 @@ unsigned int sysctl_sched_stat_granulari
  */
 unsigned int sysctl_sched_runtime_limit __read_mostly;
 
+/*
+ * Debugging: various feature bits
+ */
+enum {
+	SCHED_FEAT_IGNORE_PREEMPTED	= 1,
+	SCHED_FEAT_DISTRIBUTE		= 2,
+	SCHED_FEAT_FAIR_SLEEPERS	= 4,
+	SCHED_FEAT_SLEEPER_AVG		= 32,
+	SCHED_FEAT_PRECISE_CPU_LOAD	= 64,
+	SCHED_FEAT_START_DEBIT		= 128,
+	SCHED_FEAT_SKIP_INITIAL		= 256,
+};
+
 unsigned int sysctl_sched_features __read_mostly =
-			0 | 2 | 4 | 8 | 0 | 0 | 0 | 0;
+		SCHED_FEAT_DISTRIBUTE		|
+		SCHED_FEAT_FAIR_SLEEPERS	|
+		SCHED_FEAT_SLEEPER_AVG		|
+		SCHED_FEAT_PRECISE_CPU_LOAD;
 
 extern struct sched_class fair_sched_class;
 
@@ -145,7 +161,7 @@ static inline void
 __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	if (cfs_rq->rb_leftmost == &se->run_node)
-		cfs_rq->rb_leftmost = NULL;
+		cfs_rq->rb_leftmost = rb_next(&se->run_node);
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
 	update_load_sub(&cfs_rq->load, se->load.weight);
 	cfs_rq->nr_running--;
@@ -258,7 +274,7 @@ __update_curr(struct cfs_rq *cfs_rq, str
 	 * Task already marked for preemption, do not burden
 	 * it with the cost of not having left the CPU yet:
 	 */
-	if (unlikely(sysctl_sched_features & 1))
+	if (unlikely(sysctl_sched_features & SCHED_FEAT_IGNORE_PREEMPTED))
 		if (unlikely(test_tsk_thread_flag(curtask, TIF_NEED_RESCHED)))
 			return;
 
@@ -305,7 +321,7 @@ update_stats_wait_start(struct cfs_rq *c
 	se->wait_start = now;
 }
 
-static inline s64 weight_s64(s64 calc, unsigned long weight, int shift)
+static s64 weight_s64(s64 calc, unsigned long weight, int shift)
 {
 	if (calc < 0) {
 		calc = - calc * weight;
@@ -317,7 +333,7 @@ static inline s64 weight_s64(s64 calc, u
 /*
  * Task is being enqueued - update stats:
  */
-static inline void
+static void
 update_stats_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 now)
 {
 	s64 key;
@@ -438,7 +454,7 @@ static void distribute_fair_add(struct c
 	struct sched_entity *curr = cfs_rq_curr(cfs_rq);
 	s64 delta_fair = 0;
 
-	if (!(sysctl_sched_features & 2))
+	if (!(sysctl_sched_features & SCHED_FEAT_DISTRIBUTE))
 		return;
 
 	if (cfs_rq->nr_running) {
@@ -469,7 +485,7 @@ __enqueue_sleeper(struct cfs_rq *cfs_rq,
 	 * Fix up delta_fair with the effect of us running
 	 * during the whole sleep period:
 	 */
-	if (!(sysctl_sched_features & 32))
+	if (sysctl_sched_features & SCHED_FEAT_SLEEPER_AVG)
 		delta_fair = div64_s(delta_fair * load, load + se->load.weight);
 
 	delta_fair = weight_s64(delta_fair, se->load.weight, NICE_0_SHIFT);
@@ -495,7 +511,7 @@ enqueue_sleeper(struct cfs_rq *cfs_rq, s
 	s64 delta_fair;
 
 	if ((entity_is_task(se) && tsk->policy == SCHED_BATCH) ||
-						 !(sysctl_sched_features & 4))
+			 !(sysctl_sched_features & SCHED_FEAT_FAIR_SLEEPERS))
 		return;
 
 	delta_fair = cfs_rq->fair_clock - se->sleep_start_fair;
@@ -574,7 +590,7 @@ static void dequeue_entity(struct cfs_rq
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static inline void
+static void
 __check_preempt_curr_fair(struct cfs_rq *cfs_rq, struct sched_entity *se,
 			  struct sched_entity *curr, unsigned long granularity)
 {
@@ -612,23 +628,6 @@ put_prev_entity(struct cfs_rq *cfs_rq, s
 	int updated = 0;
 
 	/*
-	 * If the task is still waiting for the CPU (it just got
-	 * preempted), update its position within the tree and
-	 * start the wait period:
-	 */
-	if ((sysctl_sched_features & 16) && entity_is_task(prev))  {
-		struct task_struct *prevtask = task_of(prev);
-
-		if (prev->on_rq &&
-			test_tsk_thread_flag(prevtask, TIF_NEED_RESCHED)) {
-
-			dequeue_entity(cfs_rq, prev, 0, now);
-			enqueue_entity(cfs_rq, prev, 0, now);
-			updated = 1;
-		}
-	}
-
-	/*
 	 * If still on the runqueue then deactivate_task()
 	 * was not called and update_curr() has to be done:
 	 */
@@ -741,10 +740,8 @@ static void check_preempt_curr_fair(stru
 	unsigned long gran;
 
 	if (unlikely(rt_prio(p->prio))) {
-		if (sysctl_sched_features & 8) {
-			if (rt_prio(p->prio))
-				update_curr(cfs_rq, rq_clock(rq));
-		}
+		if (rt_prio(p->prio))
+			update_curr(cfs_rq, rq_clock(rq));
 		resched_task(curr);
 		return;
 	}
@@ -850,14 +847,14 @@ static void task_new_fair(struct rq *rq,
 	 * The first wait is dominated by the child-runs-first logic,
 	 * so do not credit it with that waiting time yet:
 	 */
-	if (sysctl_sched_features & 256)
+	if (sysctl_sched_features & SCHED_FEAT_SKIP_INITIAL)
 		p->se.wait_start_fair = 0;
 
 	/*
 	 * The statistical average of wait_runtime is about
 	 * -granularity/2, so initialize the task with that:
 	 */
-	if (sysctl_sched_features & 128)
+	if (sysctl_sched_features & SCHED_FEAT_START_DEBIT)
 		p->se.wait_runtime = -(s64)(sysctl_sched_granularity / 2);
 
 	__enqueue_entity(cfs_rq, se);
Index: linux/kernel/sched_rt.c
===================================================================
--- linux.orig/kernel/sched_rt.c
+++ linux/kernel/sched_rt.c
@@ -12,7 +12,7 @@ static inline void update_curr_rt(struct
 	struct task_struct *curr = rq->curr;
 	u64 delta_exec;
 
-	if (!has_rt_policy(curr))
+	if (!task_has_rt_policy(curr))
 		return;
 
 	delta_exec = now - curr->se.exec_start;
@@ -179,13 +179,14 @@ static void task_tick_rt(struct rq *rq, 
 	if (p->policy != SCHED_RR)
 		return;
 
-	if (!(--p->time_slice)) {
-		p->time_slice = static_prio_timeslice(p->static_prio);
-		set_tsk_need_resched(p);
+	if (--p->time_slice)
+		return;
 
-		/* put it at the end of the queue: */
-		requeue_task_rt(rq, p);
-	}
+	p->time_slice = static_prio_timeslice(p->static_prio);
+	set_tsk_need_resched(p);
+
+	/* put it at the end of the queue: */
+	requeue_task_rt(rq, p);
 }
 
 /*
