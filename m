Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbYCUR6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbYCUR6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbYCUR6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:58:12 -0400
Received: from smtp-out.google.com ([216.239.45.13]:58596 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbYCUR6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:58:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer;
	b=lFp2wErKX99W4nGKl4v7K6ut03mJJI9kUT2bWKP9gM+Kkpv47Ze7hfo3aplICMNAF
	lqemIpZkU0yGrXDF52poA==
Subject: Re: posix-cpu-timers revamp
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080321071846.1B22B26F9A7@magilla.localdomain>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
	 <20080206165045.89b809cc.akpm@linux-foundation.org>
	 <1202345893.8525.33.camel@peace.smo.corp.google.com>
	 <alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net>
	 <20080207162203.3e3cf5ab@Varda>
	 <alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
	 <alpine.LRH.1.00.0802071054160.29320@mini.warudkars.net>
	 <20080207165455.04ec490b@Varda>
	 <alpine.LRH.1.00.0802071100230.29369@mini.warudkars.net>
	 <alpine.LRH.1.00.0802071153130.15220@mini.warudkars.net>
	 <1204314904.4850.23.camel@peace.smo.corp.google.com>
	 <20080304070016.903E127010A@magilla.localdomain>
	 <1204660376.9768.1.camel@bobble.smo.corp.google.com>
	 <20080305040826.D0E6127010A@magilla.localdomain>
	 <1204830243.20004.31.camel@bobble.smo.corp.google.com>
	 <20080311075020.A93DB26F991@magilla.localdomain>
	 <1205269507.23124.57.camel@bobble.smo.corp.google.com>
	 <20080311213507.5BCDF26F991@magilla.localdomain>
	 <1205455050.19551.16.camel@bobble.smo.corp.google.com>
	 <20080321071846.1B22B26F9A7@magilla.localdomain>
Content-Type: multipart/mixed; boundary="=-Fyex1RD9NZoeSAL9IOwy"
Organization: Google, Inc.
Date: Fri, 21 Mar 2008 10:57:20 -0700
Message-Id: <1206122240.14638.31.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Fyex1RD9NZoeSAL9IOwy
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2008-03-21 at 00:18 -0700, Roland McGrath wrote:
> > Please take a look and let me know what you think.  In the meantime I'll
> > be working on a similar patch to 2.6-head that has optimizations for
> > uniprocessor and two-CPU operation, to avoid the overhead of the percpu
> > functions when they are unneeded.
> My mention of a 2-CPU special case was just an off-hand idea.  I don't
> really have any idea if that would be optimal given the tradeoff of
> increaing signal_struct size.  The performance needs be analyzed.

I would really like to just ignore the 2-cpu scenario and just have two
versions, the UP version and the n-way SMP version.  It would make life,
and maintenance, simpler.

> > 	disappeared entirely and the arm_timer() routine merely fills
> > 	p->signal->it_*_expires from timer->it.cpu.expires.*.  The
> > 	cpu_clock_sample_group_locked() loses its summing loops, using the
> > 	the shared structure instead.  Finally, set_process_cpu_timer() sets
> > 	tsk->signal->it_*_expires directly rather than calling the deleted
> > 	rebalance routine.
> I think I misled you about the use of the it_*_expires fields, sorry.
> The task_struct.it_*_expires fields are used solely as a cache of the
> head of cpu_timers[].  Despite the poor choice of the same name, the
> signal_struct.it_*_expires fields serve a different purpose.  For an
> analogous cache of the soonest timer to expire, you need to add new
> fields.  The signal_struct.it_{prof,virt}_{expires,incr} fields hold
> the setitimer settings for ITIMER_{PROF,VTALRM}.  You can't change
> those in arm_timer.  For a quick cache you need a new field that is
> the sooner of it_foo_expires or the head cpu_timers[foo] expiry time.

Okay, I'll go back over this and make sure I got it right.  It's
interesting, though, that my current patch (written without this
particular bit of knowledge) actually performs no differently from the
existing mechanism.

>From my handy four-core AMD64 test system running 2.6.18.5, the old
kernel gets:

./nohangc-3 1300 200000
Interval timer off.
Threads:                1300
Max prime:              200000
Elapsed:                95.421s
Execution:              User 356.001s, System 0.029s, Total 356.030s
Context switches:       vol 1319, invol 7402

./hangc-3 1300 200000
Interval timer set to 0.010 sec.
Threads:                1300
Max prime:              200000
Elapsed:                131.457s
Execution:              User 435.037s, System 59.495s, Total 494.532s
Context switches:       vol 1464, invol 10123
Ticks:                  22612, tics/sec 45.724, secs/tic 0.022

(More than 1300 threads hangs the old kernel with this test.)

With my patch it gets:

./nohangc-3 1300 200000
Interval timer off.
Threads:                1300
Max prime:              200000
Elapsed:                94.097s
Execution:              User 366.000s, System 0.052s, Total 366.052s
Context switches:       vol 1336, invol 28928

./hangc-3 1300 200000
Interval timer set to 0.010 sec.
Threads:                1300
Max prime:              200000
Elapsed:                93.583s
Execution:              User 366.117s, System 0.047s, Total 366.164s
Context switches:       vol 1323, invol 28875
Ticks:                  12131, tics/sec 33.130, secs/tic 0.030

Also see below.

> The shared_utime_sum et al names are somewhat oblique to anyone who
> hasn't just been hacking on exactly this thing like you and I have.
> Things like thread_group_*time make more sense.

In the latest cut I've named them "process_*" but "thread_group" makes
more sense.

> There are now several places where you call both shared_utime_sum and
> shared_stime_sum.  It looks simple because they're nicely encapsulated.
> But now you have two loops through all CPUs, and three loops in
> check_process_timers.

Good point, although so far it's been undetectable in my performance
testing.  (I can't say that it will stay that way down the road a bit,
when we have systems with large numbers of cores.)

> I think what we want instead is this:
> 
> 	struct task_cputime
> 	{
> 		cputime_t utime;
> 		cputime_t stime;
> 		unsigned long long schedtime;
> 	};
> 
> Use one in task_struct to replace the utime, stime, and sum_sched_runtime
> fields, and another to replace it_*_expires.  Use a single inline function
> thread_group_cputime() that fills a sum struct task_cputime using a single
> loop.  For the places only one or two of the sums is actually used, the
> compiler should optimize away the extra summing from the loop.

Excellent idea!  This method hadn't occurred to me since I was looking
at it from the viewpoint of the existing structure and keeping the
fields separated, but this makes more sense.

> Don't use __cacheline_aligned on this struct type itself, because most of
> the uses don't need that.  When using alloc_percpu, you can rely on it to
> take care of those needs--that's what it's for.  If you implement a
> variant that uses a flat array, you can use a wrapper struct with
> __cacheline_aligned for that.

Yeah, I had caught that one.

FYI, I've attached the latest version of the 2.6.18 patch; you might
want to take a look as it has changed a bit.  I generated some numbers
as well (from a new README):

	Testing was performed using a heavily-modified version of the test
	that originally showed the problem.  The test sets ITIMER_PROF (if
	not run with "nohang" in the name of the executable) and catches
	the SIGPROF signal (in any event), then starts some number of threads,
	each of which computes the prime numbers up to a given maximum (this
	function was lifted from the "cpu" benchmark of sysbench version
	0.4.8).  It takes as parameters the number of threads to create and
	the maximum value for the prime number calculation.  It starts the
	threads, calls pthread_barrier_wait() to wait for them to complete and
	rendezvous, then joins the threads.  It uses gettimeofday() to get
	the time and getrusage() to get resource usage before and after the
	threads run and reports the number of threads, the difference in
	elapsed time, user and system CPU time and in the number of voluntary
	and involuntary context switches, and the total number of SIGPROF
	signals received (this will be zero if the test is run as "nohang").

	On a four-core AMD64 system (two dual-core AMD64s), for 1300 threads
	(more than that hung the kernel) and a max prime of 120,000, the old
	kernel averaged roughly 70s elapsed, with about 240s user cpu and 35s
	system cpu, with the profile timer ticking about every 0.02s.  The new
	kernel averaged roughly 45s elapsed, with about 181s user cpu and .04
	system CPU and with the profile timer ticking about every .01s.
	
	On a sixteen-core system (four quad-core AMD64s), for 1300 threads as
	above but with a max prime of 300,000, the old kernel averaged roughly
	65s elapsed, with about 600s user cpu and 91s system cpu, with the
	profile timer ticking about every .02s.  The new kernel averaged
	roughly 70s elapsed, with about 239s user cpu and 35s system cpu,
	and with the profile timer ticking about every .02s.

	On the same sixteen-core system, 100,000 threads with a max prime of
	100,000 run in roughly 975s elapsed, with about 5,538s user cpu and
	751s system cpu, with the profile timer ticking about every .025s.

	In summary, the performance of the kernel with the fix is comparable to
	the performance without it, with the advantage that many threads will
	no longer hang the system.

The patch is attached.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

--=-Fyex1RD9NZoeSAL9IOwy
Content-Disposition: attachment; filename=itimer-hang-2.patch
Content-Type: text/x-patch; name=itimer-hang-2.patch; charset=us-ascii
Content-Transfer-Encoding: 7bit

diff -rup /home/fmayhar/Static/linux-2.6.18.5/include/linux/sched.h linux-2.6.18.5/include/linux/sched.h
--- /home/fmayhar/Static/linux-2.6.18.5/include/linux/sched.h	2006-12-01 16:13:05.000000000 -0800
+++ linux-2.6.18.5/include/linux/sched.h	2008-03-20 11:51:24.000000000 -0700
@@ -370,6 +370,18 @@ struct pacct_struct {
 };
 
 /*
+ * This structure contains the versions of utime, stime and sched_time
+ * that are shared across all threads within a process.  It's only used for
+ * interval timers and is allocated via alloc_percpu() in the signal
+ * structure when such a timer is set up.  It is freed at process exit.
+ */
+struct process_times_percpu_struct {
+	cputime_t utime;
+	cputime_t stime;
+	unsigned long long sched_time;
+};
+
+/*
  * NOTE! "signal_struct" does not have it's own
  * locking, because a shared signal_struct always
  * implies a shared sighand_struct, so locking
@@ -414,6 +426,9 @@ struct signal_struct {
 	cputime_t it_prof_expires, it_virt_expires;
 	cputime_t it_prof_incr, it_virt_incr;
 
+	/* Scheduling timer for the process */
+	unsigned long long it_sched_expires;
+
 	/* job control IDs */
 	pid_t pgrp;
 	pid_t tty_old_pgrp;
@@ -441,6 +456,9 @@ struct signal_struct {
 	 */
 	unsigned long long sched_time;
 
+	/* Process-wide times for POSIX interval timing.  Per CPU. */
+	struct process_times_percpu_struct *process_times_percpu;
+
 	/*
 	 * We don't bother to synchronize most readers of this at all,
 	 * because there is no reader checking a limit that actually needs
@@ -1472,6 +1490,112 @@ static inline int lock_need_resched(spin
 	return 0;
 }
 
+/*
+ * Allocate the process_times_percpu_struct appropriately and fill in the current
+ * values of the fields.  Called from do_setitimer() when setting an interval
+ * timer (ITIMER_PROF or ITIMER_VIRTUAL).  Assumes interrupts are enabled when
+ * it's called.  Note that there is no corresponding deallocation done from
+ * do_setitimer(); the structure is freed at process exit.
+ */
+static inline int process_times_percpu_alloc(struct task_struct *tsk)
+{
+	struct signal_struct *sig = tsk->signal;
+	struct process_times_percpu_struct *process_times_percpu;
+	struct task_struct *t;
+	cputime_t utime, stime;
+	unsigned long long sched_time;
+
+	/*
+	 * If we don't already have a process_times_percpu_struct, allocate
+	 * one and fill it in with the accumulated times.
+	 */
+	if (sig->process_times_percpu)
+		return(0);
+	process_times_percpu = alloc_percpu(struct process_times_percpu_struct);
+	if (process_times_percpu == NULL)
+		return -ENOMEM;
+	read_lock(&tasklist_lock);
+	spin_lock_irq(&tsk->sighand->siglock);
+	if (sig->process_times_percpu) {
+		spin_unlock_irq(&tsk->sighand->siglock);
+		read_unlock(&tasklist_lock);
+		free_percpu(process_times_percpu);
+		return(0);
+	}
+	sig->process_times_percpu = process_times_percpu;
+	utime = sig->utime;
+	stime = sig->stime;
+	sched_time = sig->sched_time;
+	t = tsk;
+	do {
+		utime = cputime_add(utime, t->utime);
+		stime = cputime_add(stime, t->stime);
+		sched_time += t->sched_time;
+	} while_each_thread(tsk, t);
+	process_times_percpu = per_cpu_ptr(sig->process_times_percpu, get_cpu());
+	process_times_percpu->utime = utime;
+	process_times_percpu->stime = stime;
+	process_times_percpu->sched_time = sched_time;
+	put_cpu_no_resched();
+	spin_unlock_irq(&tsk->sighand->siglock);
+	read_unlock(&tasklist_lock);
+	return(0);
+}
+
+/*
+ * Sum the utime field across all running CPUs.
+ */
+static inline cputime_t process_utime_sum(struct signal_struct *sig)
+{
+	int i;
+	struct process_times_percpu_struct *process_times_percpu;
+	cputime_t utime = cputime_zero;
+
+	if (sig->process_times_percpu) {
+		for_each_online_cpu(i) {
+			process_times_percpu = per_cpu_ptr(sig->process_times_percpu, i);
+			utime = cputime_add(utime, process_times_percpu->utime);
+		}
+	}
+	return(utime);
+}
+
+/*
+ * Sum the stime field across all running CPUs.
+ */
+static inline cputime_t process_stime_sum(struct signal_struct *sig)
+{
+	int i;
+	struct process_times_percpu_struct *process_times_percpu;
+	cputime_t stime = cputime_zero;
+
+	if (sig->process_times_percpu) {
+		for_each_online_cpu(i) {
+			process_times_percpu = per_cpu_ptr(sig->process_times_percpu, i);
+			stime = cputime_add(stime, process_times_percpu->stime);
+		}
+	}
+	return(stime);
+}
+
+/*
+ * Sum the sched_time field across all running CPUs.
+ */
+static inline unsigned long long process_schedtime_sum(struct signal_struct *sig)
+{
+	int i;
+	struct process_times_percpu_struct *process_times_percpu;
+	unsigned long long sched_time = 0;
+
+	if (sig->process_times_percpu) {
+		for_each_online_cpu(i) {
+			process_times_percpu = per_cpu_ptr(sig->process_times_percpu, i);
+			sched_time += process_times_percpu->sched_time;
+		}
+	}
+	return(sched_time);
+}
+
 /* Reevaluate whether the task has signals pending delivery.
    This is required every time the blocked sigset_t changes.
    callers must hold sighand->siglock.  */
diff -rup /home/fmayhar/Static/linux-2.6.18.5/kernel/compat.c linux-2.6.18.5/kernel/compat.c
--- /home/fmayhar/Static/linux-2.6.18.5/kernel/compat.c	2006-12-01 16:13:05.000000000 -0800
+++ linux-2.6.18.5/kernel/compat.c	2008-03-20 11:50:09.000000000 -0700
@@ -161,18 +161,28 @@ asmlinkage long compat_sys_times(struct 
 	if (tbuf) {
 		struct compat_tms tmp;
 		struct task_struct *tsk = current;
-		struct task_struct *t;
 		cputime_t utime, stime, cutime, cstime;
 
 		read_lock(&tasklist_lock);
-		utime = tsk->signal->utime;
-		stime = tsk->signal->stime;
-		t = tsk;
-		do {
-			utime = cputime_add(utime, t->utime);
-			stime = cputime_add(stime, t->stime);
-			t = next_thread(t);
-		} while (t != tsk);
+		/*
+		 * If a POSIX interval timer is running use the process-wide
+		 * fields, else fall back to brute force.
+		 */
+		if (tsk->signal->process_times_percpu) {
+			utime = process_utime_sum(tsk->signal);
+			stime = process_stime_sum(tsk->signal);
+		}
+		else {
+			struct task_struct *t;
+
+			utime = tsk->signal->utime;
+			stime = tsk->signal->stime;
+			t = tsk;
+			do {
+				utime = cputime_add(utime, t->utime);
+				stime = cputime_add(stime, t->stime);
+			} while_each_thread(tsk, t);
+		}
 
 		/*
 		 * While we have tasklist_lock read-locked, no dying thread
diff -rup /home/fmayhar/Static/linux-2.6.18.5/kernel/fork.c linux-2.6.18.5/kernel/fork.c
--- /home/fmayhar/Static/linux-2.6.18.5/kernel/fork.c	2006-12-01 16:13:05.000000000 -0800
+++ linux-2.6.18.5/kernel/fork.c	2008-03-20 11:50:09.000000000 -0700
@@ -855,10 +855,13 @@ static inline int copy_signal(unsigned l
 	sig->it_virt_incr = cputime_zero;
 	sig->it_prof_expires = cputime_zero;
 	sig->it_prof_incr = cputime_zero;
+ 	sig->it_sched_expires = 0;
 
 	sig->leader = 0;	/* session leadership doesn't inherit */
 	sig->tty_old_pgrp = 0;
 
+	sig->process_times_percpu = NULL;
+
 	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
 	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
@@ -889,6 +892,8 @@ void __cleanup_signal(struct signal_stru
 {
 	exit_thread_group_keys(sig);
 	taskstats_tgid_free(sig);
+	if (sig->process_times_percpu)
+		free_percpu(sig->process_times_percpu);
 	kmem_cache_free(signal_cachep, sig);
 }
 
diff -rup /home/fmayhar/Static/linux-2.6.18.5/kernel/itimer.c linux-2.6.18.5/kernel/itimer.c
--- /home/fmayhar/Static/linux-2.6.18.5/kernel/itimer.c	2006-12-01 16:13:05.000000000 -0800
+++ linux-2.6.18.5/kernel/itimer.c	2008-03-20 11:50:08.000000000 -0700
@@ -61,12 +61,7 @@ int do_getitimer(int which, struct itime
 		cval = tsk->signal->it_virt_expires;
 		cinterval = tsk->signal->it_virt_incr;
 		if (!cputime_eq(cval, cputime_zero)) {
-			struct task_struct *t = tsk;
-			cputime_t utime = tsk->signal->utime;
-			do {
-				utime = cputime_add(utime, t->utime);
-				t = next_thread(t);
-			} while (t != tsk);
+			cputime_t utime = process_utime_sum(tsk->signal);
 			if (cputime_le(cval, utime)) { /* about to fire */
 				cval = jiffies_to_cputime(1);
 			} else {
@@ -84,15 +79,8 @@ int do_getitimer(int which, struct itime
 		cval = tsk->signal->it_prof_expires;
 		cinterval = tsk->signal->it_prof_incr;
 		if (!cputime_eq(cval, cputime_zero)) {
-			struct task_struct *t = tsk;
-			cputime_t ptime = cputime_add(tsk->signal->utime,
-						      tsk->signal->stime);
-			do {
-				ptime = cputime_add(ptime,
-						    cputime_add(t->utime,
-								t->stime));
-				t = next_thread(t);
-			} while (t != tsk);
+			cputime_t ptime = cputime_add(process_utime_sum(tsk->signal),
+						      process_stime_sum(tsk->signal));
 			if (cputime_le(cval, ptime)) { /* about to fire */
 				cval = jiffies_to_cputime(1);
 			} else {
@@ -241,6 +229,18 @@ again:
 	case ITIMER_VIRTUAL:
 		nval = timeval_to_cputime(&value->it_value);
 		ninterval = timeval_to_cputime(&value->it_interval);
+		/*
+		 * If he's setting the timer for the first time, we need to
+		 * allocate the shared area.  It's freed when the process
+		 * exits.
+		 */
+		if (!cputime_eq(nval, cputime_zero) &&
+		    tsk->signal->process_times_percpu == NULL) {
+			int err;
+
+			if ((err = process_times_percpu_alloc(tsk)) < 0)
+				return(err);
+		}
 		read_lock(&tasklist_lock);
 		spin_lock_irq(&tsk->sighand->siglock);
 		cval = tsk->signal->it_virt_expires;
@@ -265,6 +265,18 @@ again:
 	case ITIMER_PROF:
 		nval = timeval_to_cputime(&value->it_value);
 		ninterval = timeval_to_cputime(&value->it_interval);
+		/*
+		 * If he's setting the timer for the first time, we need to
+		 * allocate the shared area.  It's freed when the process
+		 * exits.
+		 */
+		if (!cputime_eq(nval, cputime_zero) &&
+		    tsk->signal->process_times_percpu == NULL) {
+			int err;
+
+			if ((err = process_times_percpu_alloc(tsk)) < 0)
+				return(err);
+		}
 		read_lock(&tasklist_lock);
 		spin_lock_irq(&tsk->sighand->siglock);
 		cval = tsk->signal->it_prof_expires;
diff -rup /home/fmayhar/Static/linux-2.6.18.5/kernel/posix-cpu-timers.c linux-2.6.18.5/kernel/posix-cpu-timers.c
--- /home/fmayhar/Static/linux-2.6.18.5/kernel/posix-cpu-timers.c	2006-12-01 16:13:05.000000000 -0800
+++ linux-2.6.18.5/kernel/posix-cpu-timers.c	2008-03-19 16:58:03.000000000 -0700
@@ -164,6 +164,15 @@ static inline unsigned long long sched_n
 	return (p == current) ? current_sched_time(p) : p->sched_time;
 }
 
+static inline cputime_t prof_shared_ticks(struct task_struct *p)
+{
+	return cputime_add(process_utime_sum(p->signal), process_stime_sum(p->signal));
+}
+static inline cputime_t virt_shared_ticks(struct task_struct *p)
+{
+	return process_utime_sum(p->signal);
+}
+
 int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *tp)
 {
 	int error = check_clock(which_clock);
@@ -227,31 +236,17 @@ static int cpu_clock_sample_group_locked
 					 struct task_struct *p,
 					 union cpu_time_count *cpu)
 {
-	struct task_struct *t = p;
  	switch (clock_idx) {
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
-		cpu->cpu = cputime_add(p->signal->utime, p->signal->stime);
-		do {
-			cpu->cpu = cputime_add(cpu->cpu, prof_ticks(t));
-			t = next_thread(t);
-		} while (t != p);
+		cpu->cpu = cputime_add(process_utime_sum(p->signal), process_stime_sum(p->signal));
 		break;
 	case CPUCLOCK_VIRT:
-		cpu->cpu = p->signal->utime;
-		do {
-			cpu->cpu = cputime_add(cpu->cpu, virt_ticks(t));
-			t = next_thread(t);
-		} while (t != p);
+		cpu->cpu = process_utime_sum(p->signal);
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = p->signal->sched_time;
-		/* Add in each other live thread.  */
-		while ((t = next_thread(t)) != p) {
-			cpu->sched += t->sched_time;
-		}
-		cpu->sched += sched_ns(p);
+		cpu->sched = process_schedtime_sum(p->signal);
 		break;
 	}
 	return 0;
@@ -468,79 +463,9 @@ void posix_cpu_timers_exit(struct task_s
 void posix_cpu_timers_exit_group(struct task_struct *tsk)
 {
 	cleanup_timers(tsk->signal->cpu_timers,
-		       cputime_add(tsk->utime, tsk->signal->utime),
-		       cputime_add(tsk->stime, tsk->signal->stime),
-		       tsk->sched_time + tsk->signal->sched_time);
-}
-
-
-/*
- * Set the expiry times of all the threads in the process so one of them
- * will go off before the process cumulative expiry total is reached.
- */
-static void process_timer_rebalance(struct task_struct *p,
-				    unsigned int clock_idx,
-				    union cpu_time_count expires,
-				    union cpu_time_count val)
-{
-	cputime_t ticks, left;
-	unsigned long long ns, nsleft;
- 	struct task_struct *t = p;
-	unsigned int nthreads = atomic_read(&p->signal->live);
-
-	if (!nthreads)
-		return;
-
-	switch (clock_idx) {
-	default:
-		BUG();
-		break;
-	case CPUCLOCK_PROF:
-		left = cputime_div_non_zero(cputime_sub(expires.cpu, val.cpu),
-				       nthreads);
-		do {
-			if (likely(!(t->flags & PF_EXITING))) {
-				ticks = cputime_add(prof_ticks(t), left);
-				if (cputime_eq(t->it_prof_expires,
-					       cputime_zero) ||
-				    cputime_gt(t->it_prof_expires, ticks)) {
-					t->it_prof_expires = ticks;
-				}
-			}
-			t = next_thread(t);
-		} while (t != p);
-		break;
-	case CPUCLOCK_VIRT:
-		left = cputime_div_non_zero(cputime_sub(expires.cpu, val.cpu),
-				       nthreads);
-		do {
-			if (likely(!(t->flags & PF_EXITING))) {
-				ticks = cputime_add(virt_ticks(t), left);
-				if (cputime_eq(t->it_virt_expires,
-					       cputime_zero) ||
-				    cputime_gt(t->it_virt_expires, ticks)) {
-					t->it_virt_expires = ticks;
-				}
-			}
-			t = next_thread(t);
-		} while (t != p);
-		break;
-	case CPUCLOCK_SCHED:
-		nsleft = expires.sched - val.sched;
-		do_div(nsleft, nthreads);
-		nsleft = max_t(unsigned long long, nsleft, 1);
-		do {
-			if (likely(!(t->flags & PF_EXITING))) {
-				ns = t->sched_time + nsleft;
-				if (t->it_sched_expires == 0 ||
-				    t->it_sched_expires > ns) {
-					t->it_sched_expires = ns;
-				}
-			}
-			t = next_thread(t);
-		} while (t != p);
-		break;
-	}
+		       process_utime_sum(tsk->signal),
+		       process_stime_sum(tsk->signal),
+		       process_schedtime_sum(tsk->signal));
 }
 
 static void clear_dead_task(struct k_itimer *timer, union cpu_time_count now)
@@ -637,7 +562,8 @@ static void arm_timer(struct k_itimer *t
 				    cputime_lt(p->signal->it_virt_expires,
 					       timer->it.cpu.expires.cpu))
 					break;
-				goto rebalance;
+				p->signal->it_virt_expires = timer->it.cpu.expires.cpu;
+				break;
 			case CPUCLOCK_PROF:
 				if (!cputime_eq(p->signal->it_prof_expires,
 						cputime_zero) &&
@@ -648,13 +574,10 @@ static void arm_timer(struct k_itimer *t
 				if (i != RLIM_INFINITY &&
 				    i <= cputime_to_secs(timer->it.cpu.expires.cpu))
 					break;
-				goto rebalance;
+				p->signal->it_prof_expires = timer->it.cpu.expires.cpu;
+				break;
 			case CPUCLOCK_SCHED:
-			rebalance:
-				process_timer_rebalance(
-					timer->it.cpu.task,
-					CPUCLOCK_WHICH(timer->it_clock),
-					timer->it.cpu.expires, now);
+				p->signal->it_sched_expires = timer->it.cpu.expires.sched;
 				break;
 			}
 		}
@@ -1018,9 +941,8 @@ static void check_process_timers(struct 
 {
 	int maxfire;
 	struct signal_struct *const sig = tsk->signal;
-	cputime_t utime, stime, ptime, virt_expires, prof_expires;
+	cputime_t utime, ptime, virt_expires, prof_expires;
 	unsigned long long sched_time, sched_expires;
-	struct task_struct *t;
 	struct list_head *timers = sig->cpu_timers;
 
 	/*
@@ -1037,17 +959,9 @@ static void check_process_timers(struct 
 	/*
 	 * Collect the current process totals.
 	 */
-	utime = sig->utime;
-	stime = sig->stime;
-	sched_time = sig->sched_time;
-	t = tsk;
-	do {
-		utime = cputime_add(utime, t->utime);
-		stime = cputime_add(stime, t->stime);
-		sched_time += t->sched_time;
-		t = next_thread(t);
-	} while (t != tsk);
-	ptime = cputime_add(utime, stime);
+	utime = process_utime_sum(sig);
+	ptime = cputime_add(utime, process_stime_sum(sig));
+	sched_time = process_schedtime_sum(sig);
 
 	maxfire = 20;
 	prof_expires = cputime_zero;
@@ -1156,60 +1070,18 @@ static void check_process_timers(struct 
 		}
 	}
 
-	if (!cputime_eq(prof_expires, cputime_zero) ||
-	    !cputime_eq(virt_expires, cputime_zero) ||
-	    sched_expires != 0) {
-		/*
-		 * Rebalance the threads' expiry times for the remaining
-		 * process CPU timers.
-		 */
-
-		cputime_t prof_left, virt_left, ticks;
-		unsigned long long sched_left, sched;
-		const unsigned int nthreads = atomic_read(&sig->live);
-
-		if (!nthreads)
-			return;
-
-		prof_left = cputime_sub(prof_expires, utime);
-		prof_left = cputime_sub(prof_left, stime);
-		prof_left = cputime_div_non_zero(prof_left, nthreads);
-		virt_left = cputime_sub(virt_expires, utime);
-		virt_left = cputime_div_non_zero(virt_left, nthreads);
-		if (sched_expires) {
-			sched_left = sched_expires - sched_time;
-			do_div(sched_left, nthreads);
-			sched_left = max_t(unsigned long long, sched_left, 1);
-		} else {
-			sched_left = 0;
-		}
-		t = tsk;
-		do {
-			if (unlikely(t->flags & PF_EXITING))
-				continue;
-
-			ticks = cputime_add(cputime_add(t->utime, t->stime),
-					    prof_left);
-			if (!cputime_eq(prof_expires, cputime_zero) &&
-			    (cputime_eq(t->it_prof_expires, cputime_zero) ||
-			     cputime_gt(t->it_prof_expires, ticks))) {
-				t->it_prof_expires = ticks;
-			}
-
-			ticks = cputime_add(t->utime, virt_left);
-			if (!cputime_eq(virt_expires, cputime_zero) &&
-			    (cputime_eq(t->it_virt_expires, cputime_zero) ||
-			     cputime_gt(t->it_virt_expires, ticks))) {
-				t->it_virt_expires = ticks;
-			}
-
-			sched = t->sched_time + sched_left;
-			if (sched_expires && (t->it_sched_expires == 0 ||
-					      t->it_sched_expires > sched)) {
-				t->it_sched_expires = sched;
-			}
-		} while ((t = next_thread(t)) != tsk);
-	}
+	if (!cputime_eq(prof_expires, cputime_zero) &&
+	    (cputime_eq(sig->it_prof_expires, cputime_zero) ||
+	     cputime_gt(sig->it_prof_expires, prof_expires)))
+		sig->it_prof_expires = prof_expires;
+	if (!cputime_eq(virt_expires, cputime_zero) &&
+	    (cputime_eq(sig->it_virt_expires, cputime_zero) ||
+	     cputime_gt(sig->it_virt_expires, virt_expires)))
+		sig->it_virt_expires = virt_expires;
+	if (sched_expires != 0 &&
+	    (sig->it_sched_expires == 0 ||
+	     sig->it_sched_expires > sched_expires))
+		sig->it_sched_expires = sched_expires;
 }
 
 /*
@@ -1289,17 +1161,27 @@ void run_posix_cpu_timers(struct task_st
 
 	BUG_ON(!irqs_disabled());
 
-#define UNEXPIRED(clock) \
-		(cputime_eq(tsk->it_##clock##_expires, cputime_zero) || \
-		 cputime_lt(clock##_ticks(tsk), tsk->it_##clock##_expires))
+	if (!tsk->signal)
+		return;
 
-	if (UNEXPIRED(prof) && UNEXPIRED(virt) &&
+	/*
+	 * If neither the running thread nor the process-wide timer has
+	 * expired, do nothing.
+	 */
+	if ((cputime_eq(tsk->it_prof_expires, cputime_zero) ||
+	     cputime_lt(prof_ticks(tsk), tsk->it_prof_expires)) &&
+	    (cputime_eq(tsk->it_virt_expires, cputime_zero) ||
+	     cputime_lt(virt_ticks(tsk), tsk->it_virt_expires)) &&
 	    (tsk->it_sched_expires == 0 ||
-	     tsk->sched_time < tsk->it_sched_expires))
+	     tsk->sched_time < tsk->it_sched_expires) &&
+	    (cputime_eq(tsk->signal->it_prof_expires, cputime_zero) ||
+	     cputime_lt(prof_shared_ticks(tsk), tsk->signal->it_prof_expires)) &&
+	    (cputime_eq(tsk->signal->it_virt_expires, cputime_zero) ||
+	     cputime_lt(virt_shared_ticks(tsk), tsk->signal->it_virt_expires)) &&
+	    (tsk->signal->it_sched_expires == 0 ||
+	     process_schedtime_sum(tsk->signal) < tsk->signal->it_sched_expires))
 		return;
 
-#undef	UNEXPIRED
-
 	/*
 	 * Double-check with locks held.
 	 */
@@ -1398,13 +1280,14 @@ void set_process_cpu_timer(struct task_s
 	    cputime_ge(list_entry(head->next,
 				  struct cpu_timer_list, entry)->expires.cpu,
 		       *newval)) {
-		/*
-		 * Rejigger each thread's expiry time so that one will
-		 * notice before we hit the process-cumulative expiry time.
-		 */
-		union cpu_time_count expires = { .sched = 0 };
-		expires.cpu = *newval;
-		process_timer_rebalance(tsk, clock_idx, expires, now);
+		switch (clock_idx) {
+		case CPUCLOCK_PROF:
+			tsk->signal->it_prof_expires = *newval;
+			break;
+		case CPUCLOCK_VIRT:
+			tsk->signal->it_virt_expires = *newval;
+			break;
+		}
 	}
 }
 
diff -rup /home/fmayhar/Static/linux-2.6.18.5/kernel/sched.c linux-2.6.18.5/kernel/sched.c
--- /home/fmayhar/Static/linux-2.6.18.5/kernel/sched.c	2006-12-01 16:13:05.000000000 -0800
+++ linux-2.6.18.5/kernel/sched.c	2008-03-20 11:51:38.000000000 -0700
@@ -2901,7 +2901,20 @@ EXPORT_PER_CPU_SYMBOL(kstat);
 static inline void
 update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long long now)
 {
-	p->sched_time += now - max(p->timestamp, rq->timestamp_last_tick);
+	unsigned long long tmp;
+
+	tmp = now - max(p->timestamp, rq->timestamp_last_tick);
+	p->sched_time += tmp;
+	/* Add our time to the shared field. */
+	if (p->signal && p->signal->process_times_percpu) {
+		int cpu;
+		struct process_times_percpu_struct *process_times_percpu;
+
+		cpu = get_cpu();
+		process_times_percpu = per_cpu_ptr(p->signal->process_times_percpu, cpu);
+		process_times_percpu->sched_time += tmp;
+		put_cpu_no_resched();
+	}
 }
 
 /*
@@ -2955,6 +2968,17 @@ void account_user_time(struct task_struc
 
 	p->utime = cputime_add(p->utime, cputime);
 
+	/* Add our time to the shared field. */
+	if (p->signal && p->signal->process_times_percpu) {
+		int cpu;
+		struct process_times_percpu_struct *process_times_percpu;
+
+		cpu = get_cpu();
+		process_times_percpu = per_cpu_ptr(p->signal->process_times_percpu, cpu);
+		process_times_percpu->utime =
+			cputime_add(process_times_percpu->utime, cputime);
+		put_cpu_no_resched();
+	}
 	/* Add user time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
 	if (TASK_NICE(p) > 0)
@@ -2978,6 +3002,17 @@ void account_system_time(struct task_str
 
 	p->stime = cputime_add(p->stime, cputime);
 
+	/* Add our time to the shared field. */
+	if (p->signal && p->signal->process_times_percpu) {
+		int cpu;
+		struct process_times_percpu_struct *process_times_percpu;
+
+		cpu = get_cpu();
+		process_times_percpu = per_cpu_ptr(p->signal->process_times_percpu, cpu);
+		process_times_percpu->stime =
+			cputime_add(process_times_percpu->stime, cputime);
+		put_cpu_no_resched();
+	}
 	/* Add system time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
 	if (hardirq_count() - hardirq_offset)
diff -rup /home/fmayhar/Static/linux-2.6.18.5/kernel/sys.c linux-2.6.18.5/kernel/sys.c
--- /home/fmayhar/Static/linux-2.6.18.5/kernel/sys.c	2006-12-01 16:13:05.000000000 -0800
+++ linux-2.6.18.5/kernel/sys.c	2008-03-20 11:46:42.000000000 -0700
@@ -1207,19 +1207,28 @@ asmlinkage long sys_times(struct tms __u
 	if (tbuf) {
 		struct tms tmp;
 		struct task_struct *tsk = current;
-		struct task_struct *t;
 		cputime_t utime, stime, cutime, cstime;
 
 		spin_lock_irq(&tsk->sighand->siglock);
-		utime = tsk->signal->utime;
-		stime = tsk->signal->stime;
-		t = tsk;
-		do {
-			utime = cputime_add(utime, t->utime);
-			stime = cputime_add(stime, t->stime);
-			t = next_thread(t);
-		} while (t != tsk);
+		/*
+		 * If a POSIX interval timer is running use the process-wide
+		 * fields, else fall back to brute force.
+		 */
+		if (tsk->signal->process_times_percpu) {
+			utime = process_utime_sum(tsk->signal);
+			stime = process_stime_sum(tsk->signal);
+		}
+		else {
+			struct task_struct *t;
 
+			utime = tsk->signal->utime;
+			stime = tsk->signal->stime;
+			t = tsk;
+			do {
+				utime = cputime_add(utime, t->utime);
+				stime = cputime_add(stime, t->stime);
+			} while_each_thread(tsk, t);
+		}
 		cutime = tsk->signal->cutime;
 		cstime = tsk->signal->cstime;
 		spin_unlock_irq(&tsk->sighand->siglock);
@@ -1924,8 +1933,7 @@ static void k_getrusage(struct task_stru
 				r->ru_nivcsw += t->nivcsw;
 				r->ru_minflt += t->min_flt;
 				r->ru_majflt += t->maj_flt;
-				t = next_thread(t);
-			} while (t != p);
+			} while_each_thread(p, t);
 			break;
 
 		default:

--=-Fyex1RD9NZoeSAL9IOwy--

