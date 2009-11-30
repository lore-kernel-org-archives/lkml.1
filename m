Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbZK3JV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbZK3JV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZK3JV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:21:58 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56074 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbZK3JV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:21:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B138EA0.90007@jp.fujitsu.com>
Date: Mon, 30 Nov 2009 18:21:36 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>
Subject: [PATCH 2/2] cputime: introduce thread_group_times()
References: <4AFB9029.9000208@jp.fujitsu.com> <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com> <1258038038.4039.467.camel@laptop> <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com> <4B01A8DB.6090002@bluehost.com> <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com> <1258464288.7816.305.camel@laptop> <20091119181744.GA3743@dhcp-lab-161.englab.brq.redhat.com> <4B05F835.10401@jp.fujitsu.com> <20091123100925.GB25978@dhcp-lab-161.englab.brq.redhat.com> <20091123101612.GC25978@dhcp-lab-161.englab.brq.redhat.com>
In-Reply-To: <20091123101612.GC25978@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a real fix for problem of utime/stime values decreasing
described in the thread:
   http://lkml.org/lkml/2009/11/3/522

Now cputime is accounted in the following way:

 - {u,s}time in task_struct are increased every time when the thread
   is interrupted by a tick (timer interrupt).

 - When a thread exits, its {u,s}time are added to signal->{u,s}time,
   after adjusted by task_times().

 - When all threads in a thread_group exits, accumulated {u,s}time
   (and also c{u,s}time) in signal struct are added to c{u,s}time
   in signal struct of the group's parent.

So {u,s}time in task struct are "raw" tick count, while {u,s}time
and c{u,s}time in signal struct are "adjusted" values.

And accounted values are used by:

 - task_times(), to get cputime of a thread:
   This function returns adjusted values that originates from raw
   {u,s}time and scaled by sum_exec_runtime that accounted by CFS.

 - thread_group_cputime(), to get cputime of a thread group:
   This function returns sum of all {u,s}time of living threads in
   the group, plus {u,s}time in the signal struct that is sum of
   adjusted cputimes of all exited threads belonged to the group.

The problem is the return value of thread_group_cputime(), because
it is mixed sum of "raw" value and "adjusted" value:

  group's {u,s}time = foreach(thread){{u,s}time} + exited({u,s}time)

This misbehavior can break {u,s}time monotonicity.
Assume that if there is a thread that have raw values greater than
adjusted values (e.g. interrupted by 1000Hz ticks 50 times but only
runs 45ms) and if it exits, cputime will decrease (e.g. -5ms).

To fix this, we could do:

  group's {u,s}time = foreach(t){task_times(t)} + exited({u,s}time)

But task_times() contains hard divisions, so applying it for every
thread should be avoided.

This patch fixes the above problem in the following way:

 - Modify thread's exit (= __exit_signal()) not to use task_times().
   It means {u,s}time in signal struct accumulates raw values instead
   of adjusted values.  As the result it makes thread_group_cputime()
   to return pure sum of "raw" values.

 - Introduce a new function thread_group_times(*task, *utime, *stime)
   that converts "raw" values of thread_group_cputime() to "adjusted"
   values, in same calculation procedure as task_times().

 - Modify group's exit (= wait_task_zombie()) to use this introduced
   thread_group_times().  It make c{u,s}time in signal struct to
   have adjusted values like before this patch.

 - Replace some thread_group_cputime() by thread_group_times().
   This replacements are only applied where conveys the "adjusted"
   cputime to users, and where already uses task_times() near by it.
   (i.e. sys_times(), getrusage(), and /proc/<PID>/stat.)

This patch have a positive side effect:

 - Before this patch, if a group contains many short-life threads
   (e.g. runs 0.9ms and not interrupted by ticks), the group's
   cputime could be invisible since thread's cputime was accumulated
   after adjusted: imagine adjustment function as adj(ticks, runtime),
     {adj(0, 0.9) + adj(0, 0.9) + ....} = {0 + 0 + ....} = 0.
   After this patch it will not happen because the adjustment is
   applied after accumulated.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 fs/proc/array.c       |    5 +---
 include/linux/sched.h |    3 +-
 kernel/exit.c         |   23 +++++++++++----------
 kernel/fork.c         |    2 +
 kernel/sched.c        |   52 +++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sys.c          |   18 +++++++---------
 6 files changed, 75 insertions(+), 28 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index ca61a88..2571da4 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -506,7 +506,6 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 
 		/* add up live thread stats at the group level */
 		if (whole) {
-			struct task_cputime cputime;
 			struct task_struct *t = task;
 			do {
 				min_flt += t->min_flt;
@@ -517,9 +516,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			thread_group_cputime(task, &cputime);
-			utime = cputime.utime;
-			stime = cputime.stime;
+			thread_group_times(task, &utime, &stime);
 			gtime = cputime_add(gtime, sig->gtime);
 		}
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index dff85e5..c5c68ed 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1332,7 +1332,7 @@ struct task_struct {
 	cputime_t utime, stime, utimescaled, stimescaled;
 	cputime_t gtime;
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
-	cputime_t prev_utime, prev_stime;
+	cputime_t prev_utime, prev_stime, prev_tgutime, prev_tgstime;
 #endif
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
@@ -1723,6 +1723,7 @@ static inline void put_task_struct(struct task_struct *t)
 }
 
 extern void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st);
+extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st);
 
 /*
  * Per process flags
diff --git a/kernel/exit.c b/kernel/exit.c
index 2eaf68b..b221ad6 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -91,8 +91,6 @@ static void __exit_signal(struct task_struct *tsk)
 	if (atomic_dec_and_test(&sig->count))
 		posix_cpu_timers_exit_group(tsk);
 	else {
-		cputime_t utime, stime;
-
 		/*
 		 * If there is any task waiting for the group exit
 		 * then notify it:
@@ -112,9 +110,8 @@ static void __exit_signal(struct task_struct *tsk)
 		 * We won't ever get here for the group leader, since it
 		 * will have been the last reference on the signal_struct.
 		 */
-		task_times(tsk, &utime, &stime);
-		sig->utime = cputime_add(sig->utime, utime);
-		sig->stime = cputime_add(sig->stime, stime);
+		sig->utime = cputime_add(sig->utime, tsk->utime);
+		sig->stime = cputime_add(sig->stime, tsk->stime);
 		sig->gtime = cputime_add(sig->gtime, tsk->gtime);
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
@@ -1208,6 +1205,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		struct signal_struct *psig;
 		struct signal_struct *sig;
 		unsigned long maxrss;
+		cputime_t tgutime, tgstime;
 
 		/*
 		 * The resource counters for the group leader are in its
@@ -1223,20 +1221,23 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		 * need to protect the access to parent->signal fields,
 		 * as other threads in the parent group can be right
 		 * here reaping other children at the same time.
+		 *
+		 * We use thread_group_times() to get times for the thread
+		 * group, which consolidates times for all threads in the
+		 * group including the group leader.
 		 */
+		thread_group_times(p, &tgutime, &tgstime);
 		spin_lock_irq(&p->real_parent->sighand->siglock);
 		psig = p->real_parent->signal;
 		sig = p->signal;
 		psig->cutime =
 			cputime_add(psig->cutime,
-			cputime_add(p->utime,
-			cputime_add(sig->utime,
-				    sig->cutime)));
+			cputime_add(tgutime,
+				    sig->cutime));
 		psig->cstime =
 			cputime_add(psig->cstime,
-			cputime_add(p->stime,
-			cputime_add(sig->stime,
-				    sig->cstime)));
+			cputime_add(tgstime,
+				    sig->cstime));
 		psig->cgtime =
 			cputime_add(psig->cgtime,
 			cputime_add(p->gtime,
diff --git a/kernel/fork.c b/kernel/fork.c
index ad7cb6d..1753cac 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1069,6 +1069,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	p->prev_utime = cputime_zero;
 	p->prev_stime = cputime_zero;
+	p->prev_tgutime = cputime_zero;
+	p->prev_tgstime = cputime_zero;
 #endif
 
 	p->default_timer_slack_ns = current->timer_slack_ns;
diff --git a/kernel/sched.c b/kernel/sched.c
index b3d4e2b..dabdeae 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5189,6 +5189,12 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	if (st)
 		*st = p->stime;
 }
+
+static inline void __thread_group_times(struct task_struct *p,
+					struct task_cputime *cputime)
+{
+	thread_group_cputime(p, cputime);
+}
 #else
 
 #ifndef nsecs_to_cputime
@@ -5197,7 +5203,7 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 
 void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
-	cputime_t rtime, utime = p->utime, total = utime + p->stime;
+	cputime_t rtime, utime = p->utime, total = cputime_add(utime, p->stime);
 
 	/*
 	 * Use CFS's precise accounting:
@@ -5217,16 +5223,58 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	 * Compare with previous values, to keep monotonicity:
 	 */
 	p->prev_utime = max(p->prev_utime, utime);
-	p->prev_stime = max(p->prev_stime, rtime - p->prev_utime);
+	p->prev_stime = max(p->prev_stime, cputime_sub(rtime, p->prev_utime));
 
 	if (ut)
 		*ut = p->prev_utime;
 	if (st)
 		*st = p->prev_stime;
 }
+
+static void __thread_group_times(struct task_struct *p,
+				 struct task_cputime *cputime)
+{
+	cputime_t rtime, utime, total;
+
+	thread_group_cputime(p, cputime);
+
+	total = cputime_add(cputime->utime, cputime->stime);
+	rtime = nsecs_to_cputime(cputime->sum_exec_runtime);
+
+	if (total) {
+		u64 temp;
+
+		temp = (u64)(rtime * cputime->utime);
+		do_div(temp, total);
+		utime = (cputime_t)temp;
+	} else
+		utime = rtime;
+
+	p->prev_tgutime = max(p->prev_tgutime, utime);
+	p->prev_tgstime = max(p->prev_tgstime,
+			      cputime_sub(rtime, p->prev_tgutime));
+
+	cputime->utime = p->prev_tgutime;
+	cputime->stime = p->prev_tgstime;
+}
 #endif
 
 /*
+ * Must be called with siglock held.
+ */
+void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+{
+	struct task_cputime cputime;
+
+	__thread_group_times(p, &cputime);
+
+	if (ut)
+		*ut = cputime.utime;
+	if (st)
+		*st = cputime.stime;
+}
+
+/*
  * This function gets called by the timer code, with HZ frequency.
  * We call it with interrupts disabled.
  *
diff --git a/kernel/sys.c b/kernel/sys.c
index d988abe..9968c5f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -911,16 +911,15 @@ change_okay:
 
 void do_sys_times(struct tms *tms)
 {
-	struct task_cputime cputime;
-	cputime_t cutime, cstime;
+	cputime_t tgutime, tgstime, cutime, cstime;
 
 	spin_lock_irq(&current->sighand->siglock);
-	thread_group_cputime(current, &cputime);
+	thread_group_times(current, &tgutime, &tgstime);
 	cutime = current->signal->cutime;
 	cstime = current->signal->cstime;
 	spin_unlock_irq(&current->sighand->siglock);
-	tms->tms_utime = cputime_to_clock_t(cputime.utime);
-	tms->tms_stime = cputime_to_clock_t(cputime.stime);
+	tms->tms_utime = cputime_to_clock_t(tgutime);
+	tms->tms_stime = cputime_to_clock_t(tgstime);
 	tms->tms_cutime = cputime_to_clock_t(cutime);
 	tms->tms_cstime = cputime_to_clock_t(cstime);
 }
@@ -1338,8 +1337,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 {
 	struct task_struct *t;
 	unsigned long flags;
-	cputime_t utime, stime;
-	struct task_cputime cputime;
+	cputime_t tgutime, tgstime, utime, stime;
 	unsigned long maxrss = 0;
 
 	memset((char *) r, 0, sizeof *r);
@@ -1372,9 +1370,9 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 				break;
 
 		case RUSAGE_SELF:
-			thread_group_cputime(p, &cputime);
-			utime = cputime_add(utime, cputime.utime);
-			stime = cputime_add(stime, cputime.stime);
+			thread_group_times(p, &tgutime, &tgstime);
+			utime = cputime_add(utime, tgutime);
+			stime = cputime_add(stime, tgstime);
 			r->ru_nvcsw += p->signal->nvcsw;
 			r->ru_nivcsw += p->signal->nivcsw;
 			r->ru_minflt += p->signal->min_flt;
-- 
1.6.5.3


