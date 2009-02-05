Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbZBEWVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbZBEWVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZBEWUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:20:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35997 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZBEWUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:20:52 -0500
Subject: Re: [PATCH 2/2] timers: split process wide cpu clocks/timers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       yanmin_zhang@linux.intel.com, seto.hidetoshi@jp.fujitsu.com,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <20090205213059.GA5050@redhat.com>
References: <20090205112414.104100700@chello.nl>
	 <20090205113139.119115519@chello.nl>  <20090205213059.GA5050@redhat.com>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 23:20:36 +0100
Message-Id: <1233872436.4620.42.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-05 at 22:30 +0100, Oleg Nesterov wrote:
> On 02/05, Peter Zijlstra wrote:
> >
> > Change the process wide cpu timers/clocks so that we:
> >
> >  1) don't mess up the kernel with too many threads,
> >  2) don't have a per-cpu allocation for each process,
> >  3) have no impact when not used.
> >
> > In order to accomplish this we're going to split it into two parts:
> >
> >  - clocks; which can take all the time they want since they run
> >            from user context -- ie. sys_clock_gettime(CLOCK_PROCESS_CPUTIME_ID)
> >
> >  - timers; which need constant time sampling but since they're
> >            explicity used, the user can pay the overhead.
> >
> > The clock readout will go back to a full sum of the thread group, while the
> > timers will run of a global 'clock' that only runs when needed, so only
> > programs that make use of the facility pay the price.
> 
> Ah, personally I think this is a very nice idea!

Thanks.

> A couple of minor questions, before I try to read this patch more...
> 
> >  static inline
> > -void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
> > +void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
> 
> I know, it is silly to complain about the naming, but can't resist.
> 
> Now we have both thread_group_cputime() and thread_group_cputimer().
> But it is not possible to distinguish them while reading the code.

Good point, s/thread_group_cputime/thread_group_sum_time/g ?

> For example, looks like posix_cpu_timers_exit_group() needs
> thread_group_cputimer, not thread_group_cputime, no? But then we can
> hit the WARN_ON(!cputimer->running). Afaics.

Yes, I think you're right. Although does it really matter what we do
here, can anybody still access the remaining time after we clean up the
whole thread group?

> Hmm... Can't fastpath_timer_check()->thread_group_cputimer() have the
> false warning too? Suppose we had the timer, then posix_cpu_timer_del()
> removes this timer, but task_cputime_zero(&sig->cputime_expires) still
> not true.

Another good spotting, this appears to be the only site not under
siglock or tasklist_lock. Yes in that case there can be a false
positive.

I'd better remove that warning.

> > +void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
> > +{
> > +	struct sighand_struct *sighand;
> > +	struct signal_struct *sig;
> > +	struct task_struct *t;
> > +
> > +	*times = INIT_CPUTIME;
> > +
> > +	rcu_read_lock();
> > +	sighand = rcu_dereference(tsk->sighand);
> > +	if (!sighand)
> > +		goto out;
> > +
> > +	sig = tsk->signal;
> 
> I am afraid to be wrong, but it looks like we always call this function
> when we know we must have a valid ->sighand/siglock. Perhaps we do not
> need any check?

I think you're right, but paranoia won out.

> IOW, unless I missed something we should not just return if there is no
> ->sighand or ->signal, this just hides the problem while we should fix
> the caller.

Might be a patch for .30-rc1 and then fix up everything that falls over.
Agreed.

> > + * Enable the process wide cpu timer accounting.
> > + *
> > + * serialized using ->sighand->siglock
> > + */
> > +static void start_process_timers(struct task_struct *tsk)
> > +{
> > +	tsk->signal->cputimer.running = 1;
> > +	barrier();
> > +}
> > +
> > +/*
> > + * Release the process wide timer accounting -- timer stops ticking when
> > + * nobody cares about it.
> > + *
> > + * serialized using ->sighand->siglock
> > + */
> > +static void stop_process_timers(struct task_struct *tsk)
> > +{
> > +	tsk->signal->cputimer.running = 0;
> > +	barrier();
> > +}
> 
> Could you explain these barriers?

I was thinking that since account_group_*time() can run concurrently,
its best to issue the write asap, smp barriers seemed overkill since its
not a correctness issue.

> And, I am a bit lost... set_process_cpu_timer() does cpu_timer_sample_group(),
> but posix_cpu_timer_set() does cpu_clock_sample_group() in !CPUCLOCK_PERTHREAD
> case, could you confirm this is correct?

Ah, you're saying I missed an start_process_timers() instance?

Ok, so how about this -- it does not yet address the
posix_cpu_timers_exit_group() issue, but should clarify the rest a bit,
agreed?

---
Subject: timer: cleanup the clock/timer separation

Rename thread_group_cputime() to thread_group_sum_time() to increase the
visual difference to thread_group_cputimer().

Furthermore, to decrease the chance of a missed enable, always enable
the timer when we sample it, we'll always disable it when we find that
there are no active timers in the jiffy tick.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/binfmt_elf.c           |    2 +-
 fs/binfmt_elf_fdpic.c     |    2 +-
 fs/proc/array.c           |    2 +-
 include/linux/sched.h     |    4 ++--
 kernel/exit.c             |    4 ++--
 kernel/posix-cpu-timers.c |   35 ++++-------------------------------
 kernel/sys.c              |    4 ++--
 7 files changed, 13 insertions(+), 40 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index e3ff2b9..b5e32b1 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1359,7 +1359,7 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 		 * This is the record for the group leader.  It shows the
 		 * group-wide total, not its individual thread total.
 		 */
-		thread_group_cputime(p, &cputime);
+		thread_group_sum_time(p, &cputime);
 		cputime_to_timeval(cputime.utime, &prstatus->pr_utime);
 		cputime_to_timeval(cputime.stime, &prstatus->pr_stime);
 	} else {
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index f3e72c5..71717cf 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1389,7 +1389,7 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 		 * This is the record for the group leader.  It shows the
 		 * group-wide total, not its individual thread total.
 		 */
-		thread_group_cputime(p, &cputime);
+		thread_group_sum_time(p, &cputime);
 		cputime_to_timeval(cputime.utime, &prstatus->pr_utime);
 		cputime_to_timeval(cputime.stime, &prstatus->pr_stime);
 	} else {
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 7e4877d..16c8196 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -411,7 +411,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			thread_group_cputime(task, &cputime);
+			thread_group_sum_time(task, &cputime);
 			utime = cputime.utime;
 			stime = cputime.stime;
 			gtime = cputime_add(gtime, sig->gtime);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2d19bc8..328402a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2227,7 +2227,7 @@ static inline int spin_needbreak(spinlock_t *lock)
 /*
  * Thread group CPU time accounting.
  */
-void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times);
+void thread_group_sum_time(struct task_struct *tsk, struct task_cputime *times);
 
 static inline
 void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
@@ -2235,7 +2235,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 	unsigned long flags;
 
-	WARN_ON(!cputimer->running);
+	cputimer->running = 1;
 
 	spin_lock_irqsave(&cputimer->lock, flags);
 	*times = cputimer->cputime;
diff --git a/kernel/exit.c b/kernel/exit.c
index f52c24e..85d2a19 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1316,11 +1316,11 @@ static int wait_task_zombie(struct task_struct *p, int options,
 		 * as other threads in the parent group can be right
 		 * here reaping other children at the same time.
 		 *
-		 * We use thread_group_cputime() to get times for the thread
+		 * We use thread_group_sum_time() to get times for the thread
 		 * group, which consolidates times for all threads in the
 		 * group including the group leader.
 		 */
-		thread_group_cputime(p, &cputime);
+		thread_group_sum_time(p, &cputime);
 		spin_lock_irq(&p->parent->sighand->siglock);
 		psig = p->parent->signal;
 		sig = p->signal;
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index db107c9..90a32e4 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -230,7 +230,7 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 	return 0;
 }
 
-void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
+void thread_group_sum_time(struct task_struct *tsk, struct task_cputime *times)
 {
 	struct sighand_struct *sighand;
 	struct signal_struct *sig;
@@ -271,7 +271,7 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 {
 	struct task_cputime cputime;
 
-	thread_group_cputime(p, &cputime);
+	thread_group_sum_time(p, &cputime);
 	switch (CPUCLOCK_WHICH(which_clock)) {
 	default:
 		return -EINVAL;
@@ -488,7 +488,7 @@ void posix_cpu_timers_exit_group(struct task_struct *tsk)
 {
 	struct task_cputime cputime;
 
-	thread_group_cputime(tsk, &cputime);
+	thread_group_sum_time(tsk, &cputime);
 	cleanup_timers(tsk->signal->cpu_timers,
 		       cputime.utime, cputime.stime, cputime.sum_exec_runtime);
 }
@@ -507,29 +507,6 @@ static void clear_dead_task(struct k_itimer *timer, union cpu_time_count now)
 }
 
 /*
- * Enable the process wide cpu timer accounting.
- *
- * serialized using ->sighand->siglock
- */
-static void start_process_timers(struct task_struct *tsk)
-{
-	tsk->signal->cputimer.running = 1;
-	barrier();
-}
-
-/*
- * Release the process wide timer accounting -- timer stops ticking when
- * nobody cares about it.
- *
- * serialized using ->sighand->siglock
- */
-static void stop_process_timers(struct task_struct *tsk)
-{
-	tsk->signal->cputimer.running = 0;
-	barrier();
-}
-
-/*
  * Insert the timer on the appropriate list before any timers that
  * expire later.  This must be called with the tasklist_lock held
  * for reading, and interrupts disabled.
@@ -549,9 +526,6 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
 	BUG_ON(!irqs_disabled());
 	spin_lock(&p->sighand->siglock);
 
-	if (!CPUCLOCK_PERTHREAD(timer->it_clock))
-		start_process_timers(p);
-
 	listpos = head;
 	if (CPUCLOCK_WHICH(timer->it_clock) == CPUCLOCK_SCHED) {
 		list_for_each_entry(next, head, entry) {
@@ -1045,7 +1019,7 @@ static void check_process_timers(struct task_struct *tsk,
 	    list_empty(&timers[CPUCLOCK_VIRT]) &&
 	    cputime_eq(sig->it_virt_expires, cputime_zero) &&
 	    list_empty(&timers[CPUCLOCK_SCHED])) {
-		stop_process_timers(tsk);
+		tsk->signal->cputimer.running = 0;
 		return;
 	}
 
@@ -1427,7 +1401,6 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 	struct list_head *head;
 
 	BUG_ON(clock_idx == CPUCLOCK_SCHED);
-	start_process_timers(tsk);
 	cpu_timer_sample_group(clock_idx, tsk, &now);
 
 	if (oldval) {
diff --git a/kernel/sys.c b/kernel/sys.c
index 87ca037..6fe340c 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -910,7 +910,7 @@ void do_sys_times(struct tms *tms)
 	struct task_cputime cputime;
 	cputime_t cutime, cstime;
 
-	thread_group_cputime(current, &cputime);
+	thread_group_sum_time(current, &cputime);
 	spin_lock_irq(&current->sighand->siglock);
 	cutime = current->signal->cutime;
 	cstime = current->signal->cstime;
@@ -1657,7 +1657,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 				break;
 
 		case RUSAGE_SELF:
-			thread_group_cputime(p, &cputime);
+			thread_group_sum_time(p, &cputime);
 			utime = cputime_add(utime, cputime.utime);
 			stime = cputime_add(stime, cputime.stime);
 			r->ru_nvcsw += p->signal->nvcsw;


