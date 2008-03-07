Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbYCGX2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbYCGX2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 18:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbYCGX2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 18:28:00 -0500
Received: from smtp-out.google.com ([216.239.45.13]:51947 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYCGX16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 18:27:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer;
	b=eRFDZaHFPF8QLShUlwRYH8X+FvIFBNOAOW8n7WpEcZtRujNMOCqwu7teaT2HGGmjW
	fP7LnCISmsZZIvNCt8Pdg==
Subject: Re: [Bugme-new] [Bug 9906] New: Weird hang with NPTL and SIGPROF.
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: parag.warudkar@gmail.com,
       Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jakub Jelinek <jakub@redhat.com>
In-Reply-To: <20080305040826.D0E6127010A@magilla.localdomain>
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
Content-Type: multipart/mixed; boundary="=-W14Ai3f16FryyNJrWQiK"
Organization: Google, Inc.
Date: Fri, 07 Mar 2008 15:26:03 -0800
Message-Id: <1204932363.8797.9.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-W14Ai3f16FryyNJrWQiK
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Based on Roland's comments and from reading the source, I have a
possible fix.  I'm posting the attached patch _not_ for submission but
_only_ for comment.  For one thing it's based on 2.6.18.5 and for
another it hasn't had much testing yet.  I wanted to get it out here for
comment, though, in case anyone can see where I might have gone wrong.
Comments, criticism and (especially!) testing enthusiastically
requested.

>From my notes, this patch:

	Replaces the utime, stime and sched_time fields in signal_struct with
	shared_utime, shared_stime and shared_schedtime, respectively.  It
	also adds it_sched_expires to the signal struct.

	Each place that loops through all threads in a thread group to sum
	task->utime and/or task->stime now loads the value from
	task->signal->shared_[us]time.  This includes compat_sys_times(),
	do_task_stat(), do_getitimer(), sys_times() and k_getrusage().

	Certain routines that used task->signal->[us]time now use the shared
	fields instead, which may change their semantics slightly.  These
	include fill_prstatus() (in fs/binfmt_elf.c), do_task_stat() (in
	fs/proc/array.c), wait_task_zombie() and do_notify_parent().

	The shared fields are updated at each tick, in update_cpu_clock()
	(shared_schedtime), account_user_time() (shared_utime) and
	account_system_time() (shared_stime).  Each of these functions updates
	the task-private field followed by the shared version in the signal
	structure if one is present.  Note that if different threads of the
	same process are being run by different CPUs at the tick, there may
	be serious cache contention here.

	Finally, kernel/posix-cpu-timers.c has changed quite dramatically.
	First, run_posix_cpu_timers() decides whether a timer has expired by
	consulting the it_*_expires and shared_* fields in the signal struct.
	The check_process_timers() routine bases its computations on the new
	shared fields, removing two loops through the threads.  "Rebalancing"
	is no longer required, the process_timer_rebalance() routine as
	disappeared entirely and the arm_timer() routine merely fills
	p->signal->it_*_expires from timer->it.cpu.expires.*.  The
	cpu_clock_sample_group_locked() loses its summing loops, consulting
	the shared fields instead.  Finally, set_process_cpu_timer() sets
	tsk->signal->it_*_expires directly rather than calling the deleted
	rebalance routine.

	There are still a few open questions.  In particular, it's possible
	that cache contention on the tick update of the shared fields could
	mean that the current scheme is not entirely sufficient.  Further,
	the semantics of the status-returning routines fill_prstatus(),
	do_task_stat(), wait_task_zombie() and do_notify_parent() may no longer
	follow standards.  For that matter, ITIMER_PROF handling may be broken
	entirely, although a brief test seems to show that it's working fine.

Stats:
 fs/binfmt_elf.c           |   18 +--
 fs/proc/array.c           |    6 -
 include/linux/sched.h     |   10 +-
 kernel/exit.c             |   13 --
 kernel/fork.c             |   25 +----
 kernel/itimer.c           |   18 ---
 kernel/posix-cpu-timers.c |  224 ++++++++++------------------------------------
 kernel/sched.c            |   16 +++
 kernel/signal.c           |    6 -
 kernel/sys.c              |   17 ---
 10 files changed, 105 insertions(+), 248 deletions(-)
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

--=-W14Ai3f16FryyNJrWQiK
Content-Disposition: attachment; filename=posix-timers.patch
Content-Type: text/x-patch; name=posix-timers.patch; charset=us-ascii
Content-Transfer-Encoding: 7bit

diff -rup /home/fmayhar/Static/linux-2.6.18.5/fs/binfmt_elf.c linux-2.6.18.5/fs/binfmt_elf.c
--- /home/fmayhar/Static/linux-2.6.18.5/fs/binfmt_elf.c	2006-12-01 16:13:05.000000000 -0800
+++ linux-2.6.18.5/fs/binfmt_elf.c	2008-03-06 15:05:34.000000000 -0800
@@ -1302,17 +1302,17 @@ static void fill_prstatus(struct elf_prs
 	if (thread_group_leader(p)) {
 		/*
 		 * This is the record for the group leader.  Add in the
-		 * cumulative times of previous dead threads.  This total
-		 * won't include the time of each live thread whose state
-		 * is included in the core dump.  The final total reported
-		 * to our parent process when it calls wait4 will include
-		 * those sums as well as the little bit more time it takes
-		 * this and each other thread to finish dying after the
-		 * core dump synchronization phase.
+		 * cumulative times of all threads.  This total includes
+		 * the time of each live thread whose state is included in
+		 * the core dump.  The final total reported to our parent
+		 * process when it calls wait4 will include those sums as
+		 * well as the little bit more time it takes this and each
+		 * other thread to finish dying after the core dump
+		 * synchronization phase.
 		 */
-		cputime_to_timeval(cputime_add(p->utime, p->signal->utime),
+		cputime_to_timeval(p->signal->shared_utime,
 				   &prstatus->pr_utime);
-		cputime_to_timeval(cputime_add(p->stime, p->signal->stime),
+		cputime_to_timeval(p->signal->shared_stime,
 				   &prstatus->pr_stime);
 	} else {
 		cputime_to_timeval(p->utime, &prstatus->pr_utime);
diff -rup /home/fmayhar/Static/linux-2.6.18.5/fs/proc/array.c linux-2.6.18.5/fs/proc/array.c
--- /home/fmayhar/Static/linux-2.6.18.5/fs/proc/array.c	2006-12-01 16:13:05.000000000 -0800
+++ linux-2.6.18.5/fs/proc/array.c	2008-03-06 17:43:19.000000000 -0800
@@ -359,8 +359,6 @@ static int do_task_stat(struct task_stru
 			do {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
-				utime = cputime_add(utime, t->utime);
-				stime = cputime_add(stime, t->stime);
 				t = next_thread(t);
 			} while (t != task);
 		}
@@ -382,8 +380,8 @@ static int do_task_stat(struct task_stru
 		if (whole) {
 			min_flt += task->signal->min_flt;
 			maj_flt += task->signal->maj_flt;
-			utime = cputime_add(utime, task->signal->utime);
-			stime = cputime_add(stime, task->signal->stime);
+			utime = task->signal->shared_utime;
+			stime = task->signal->shared_stime;
 		}
 	}
 	ppid = pid_alive(task) ? task->group_leader->real_parent->tgid : 0;
diff -rup /home/fmayhar/Static/linux-2.6.18.5/include/linux/sched.h linux-2.6.18.5/include/linux/sched.h
--- /home/fmayhar/Static/linux-2.6.18.5/include/linux/sched.h	2006-12-01 16:13:05.000000000 -0800
+++ linux-2.6.18.5/include/linux/sched.h	2008-03-07 13:45:35.000000000 -0800
@@ -413,6 +413,7 @@ struct signal_struct {
 	/* ITIMER_PROF and ITIMER_VIRTUAL timers for the process */
 	cputime_t it_prof_expires, it_virt_expires;
 	cputime_t it_prof_incr, it_virt_incr;
+	unsigned long long it_sched_expires;
 
 	/* job control IDs */
 	pid_t pgrp;
@@ -429,17 +430,22 @@ struct signal_struct {
 	 * Live threads maintain their own counters and add to these
 	 * in __exit_signal, except for the group leader.
 	 */
-	cputime_t utime, stime, cutime, cstime;
+	cputime_t cutime, cstime;
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 
 	/*
+	 * Cumulative CPU time for all threads in the group including the
+	 * group leader.
+	 */
+	cputime_t shared_utime, shared_stime;
+	/*
 	 * Cumulative ns of scheduled CPU time for dead threads in the
 	 * group, not including a zombie group leader.  (This only differs
 	 * from jiffies_to_ns(utime + stime) if sched_clock uses something
 	 * other than jiffies.)
 	 */
-	unsigned long long sched_time;
+	unsigned long long shared_schedtime;
 
 	/*
 	 * We don't bother to synchronize most readers of this at all,
diff -rup /home/fmayhar/Static/linux-2.6.18.5/kernel/exit.c linux-2.6.18.5/kernel/exit.c
--- /home/fmayhar/Static/linux-2.6.18.5/kernel/exit.c	2006-12-01 16:13:05.000000000 -0800
+++ linux-2.6.18.5/kernel/exit.c	2008-03-06 15:48:37.000000000 -0800
@@ -103,13 +103,10 @@ static void __exit_signal(struct task_st
 		 * We won't ever get here for the group leader, since it
 		 * will have been the last reference on the signal_struct.
 		 */
-		sig->utime = cputime_add(sig->utime, tsk->utime);
-		sig->stime = cputime_add(sig->stime, tsk->stime);
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
 		sig->nvcsw += tsk->nvcsw;
 		sig->nivcsw += tsk->nivcsw;
-		sig->sched_time += tsk->sched_time;
 		sig = NULL; /* Marker for below. */
 	}
 
@@ -1165,14 +1162,12 @@ static int wait_task_zombie(struct task_
 		sig = p->signal;
 		psig->cutime =
 			cputime_add(psig->cutime,
-			cputime_add(p->utime,
-			cputime_add(sig->utime,
-				    sig->cutime)));
+			cputime_add(sig->shared_utime,
+				    sig->cutime));
 		psig->cstime =
 			cputime_add(psig->cstime,
-			cputime_add(p->stime,
-			cputime_add(sig->stime,
-				    sig->cstime)));
+			cputime_add(sig->shared_stime,
+				    sig->cstime));
 		psig->cmin_flt +=
 			p->min_flt + sig->min_flt + sig->cmin_flt;
 		psig->cmaj_flt +=
diff -rup /home/fmayhar/Static/linux-2.6.18.5/kernel/fork.c linux-2.6.18.5/kernel/fork.c
--- /home/fmayhar/Static/linux-2.6.18.5/kernel/fork.c	2006-12-01 16:13:05.000000000 -0800
+++ linux-2.6.18.5/kernel/fork.c	2008-03-07 14:23:22.000000000 -0800
@@ -855,14 +855,18 @@ static inline int copy_signal(unsigned l
 	sig->it_virt_incr = cputime_zero;
 	sig->it_prof_expires = cputime_zero;
 	sig->it_prof_incr = cputime_zero;
+ 	sig->it_sched_expires = 0;
 
 	sig->leader = 0;	/* session leadership doesn't inherit */
 	sig->tty_old_pgrp = 0;
 
-	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
+	sig->shared_utime = cputime_zero;
+	sig->shared_stime = cputime_zero;
+	sig->shared_schedtime = 0;
+
+	sig->cutime = sig->cstime = cputime_zero;
 	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
-	sig->sched_time = 0;
 	INIT_LIST_HEAD(&sig->cpu_timers[0]);
 	INIT_LIST_HEAD(&sig->cpu_timers[1]);
 	INIT_LIST_HEAD(&sig->cpu_timers[2]);
@@ -877,7 +881,7 @@ static inline int copy_signal(unsigned l
 		 * New sole thread in the process gets an expiry time
 		 * of the whole CPU time limit.
 		 */
-		tsk->it_prof_expires =
+		tsk->signal->it_prof_expires =
 			secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
 	}
 	acct_init_pacct(&sig->pacct);
@@ -1204,21 +1208,6 @@ static struct task_struct *copy_process(
 	if (clone_flags & CLONE_THREAD) {
 		p->group_leader = current->group_leader;
 		list_add_tail_rcu(&p->thread_group, &p->group_leader->thread_group);
-
-		if (!cputime_eq(current->signal->it_virt_expires,
-				cputime_zero) ||
-		    !cputime_eq(current->signal->it_prof_expires,
-				cputime_zero) ||
-		    current->signal->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY ||
-		    !list_empty(&current->signal->cpu_timers[0]) ||
-		    !list_empty(&current->signal->cpu_timers[1]) ||
-		    !list_empty(&current->signal->cpu_timers[2])) {
-			/*
-			 * Have child wake up on its first tick to check
-			 * for process CPU timers.
-			 */
-			p->it_prof_expires = jiffies_to_cputime(1);
-		}
 	}
 
 	/*
diff -rup /home/fmayhar/Static/linux-2.6.18.5/kernel/itimer.c linux-2.6.18.5/kernel/itimer.c
--- /home/fmayhar/Static/linux-2.6.18.5/kernel/itimer.c	2006-12-01 16:13:05.000000000 -0800
+++ linux-2.6.18.5/kernel/itimer.c	2008-03-06 15:49:17.000000000 -0800
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
+			cputime_t utime = tsk->signal->shared_utime;
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
+			cputime_t ptime = cputime_add(tsk->signal->shared_utime,
+						      tsk->signal->shared_stime);
 			if (cputime_le(cval, ptime)) { /* about to fire */
 				cval = jiffies_to_cputime(1);
 			} else {
diff -rup /home/fmayhar/Static/linux-2.6.18.5/kernel/posix-cpu-timers.c linux-2.6.18.5/kernel/posix-cpu-timers.c
--- /home/fmayhar/Static/linux-2.6.18.5/kernel/posix-cpu-timers.c	2006-12-01 16:13:05.000000000 -0800
+++ linux-2.6.18.5/kernel/posix-cpu-timers.c	2008-03-07 12:57:23.000000000 -0800
@@ -164,6 +164,15 @@ static inline unsigned long long sched_n
 	return (p == current) ? current_sched_time(p) : p->sched_time;
 }
 
+static inline cputime_t prof_shared_ticks(struct task_struct *p)
+{
+	return cputime_add(p->signal->shared_utime, p->signal->shared_stime);
+}
+static inline cputime_t virt_shared_ticks(struct task_struct *p)
+{
+	return p->signal->shared_utime;
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
+		cpu->cpu = cputime_add(p->signal->shared_utime, p->signal->shared_stime);
 		break;
 	case CPUCLOCK_VIRT:
-		cpu->cpu = p->signal->utime;
-		do {
-			cpu->cpu = cputime_add(cpu->cpu, virt_ticks(t));
-			t = next_thread(t);
-		} while (t != p);
+		cpu->cpu = p->signal->shared_utime;
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = p->signal->sched_time;
-		/* Add in each other live thread.  */
-		while ((t = next_thread(t)) != p) {
-			cpu->sched += t->sched_time;
-		}
-		cpu->sched += sched_ns(p);
+		cpu->sched = p->signal->shared_schedtime;
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
+		       tsk->signal->shared_utime,
+		       tsk->signal->shared_stime,
+		       tsk->signal->shared_schedtime);
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
@@ -1020,7 +943,6 @@ static void check_process_timers(struct 
 	struct signal_struct *const sig = tsk->signal;
 	cputime_t utime, stime, ptime, virt_expires, prof_expires;
 	unsigned long long sched_time, sched_expires;
-	struct task_struct *t;
 	struct list_head *timers = sig->cpu_timers;
 
 	/*
@@ -1037,16 +959,10 @@ static void check_process_timers(struct 
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
+	utime = sig->shared_utime;
+	stime = sig->shared_stime;
+	sched_time = sig->shared_schedtime;
+
 	ptime = cputime_add(utime, stime);
 
 	maxfire = 20;
@@ -1156,60 +1072,18 @@ static void check_process_timers(struct 
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
@@ -1289,13 +1163,16 @@ void run_posix_cpu_timers(struct task_st
 
 	BUG_ON(!irqs_disabled());
 
+	if (!tsk->signal)
+		return;
+
 #define UNEXPIRED(clock) \
-		(cputime_eq(tsk->it_##clock##_expires, cputime_zero) || \
-		 cputime_lt(clock##_ticks(tsk), tsk->it_##clock##_expires))
+		(cputime_eq(tsk->signal->it_##clock##_expires, cputime_zero) || \
+		 cputime_lt(clock##_shared_ticks(tsk), tsk->signal->it_##clock##_expires))
 
 	if (UNEXPIRED(prof) && UNEXPIRED(virt) &&
-	    (tsk->it_sched_expires == 0 ||
-	     tsk->sched_time < tsk->it_sched_expires))
+	    (tsk->signal->it_sched_expires == 0 ||
+	     tsk->signal->shared_schedtime < tsk->signal->it_sched_expires))
 		return;
 
 #undef	UNEXPIRED
@@ -1398,13 +1275,14 @@ void set_process_cpu_timer(struct task_s
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
+++ linux-2.6.18.5/kernel/sched.c	2008-03-07 09:36:43.000000000 -0800
@@ -2901,7 +2901,13 @@ EXPORT_PER_CPU_SYMBOL(kstat);
 static inline void
 update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long long now)
 {
-	p->sched_time += now - max(p->timestamp, rq->timestamp_last_tick);
+	unsigned long long tmp;
+
+	tmp = now - max(p->timestamp, rq->timestamp_last_tick);
+	p->sched_time += tmp;
+	/* Add our time to the shared field. */
+	if (p->signal)
+		p->signal->shared_schedtime += tmp;
 }
 
 /*
@@ -2955,6 +2961,10 @@ void account_user_time(struct task_struc
 
 	p->utime = cputime_add(p->utime, cputime);
 
+	/* Add our time to the shared field. */
+	if (p->signal)
+		p->signal->shared_utime = cputime_add(p->signal->shared_utime, cputime);
+
 	/* Add user time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
 	if (TASK_NICE(p) > 0)
@@ -2978,6 +2988,10 @@ void account_system_time(struct task_str
 
 	p->stime = cputime_add(p->stime, cputime);
 
+	/* Add our time to the shared field. */
+	if (p->signal)
+		p->signal->shared_stime = cputime_add(p->signal->shared_stime, cputime);
+
 	/* Add system time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
 	if (hardirq_count() - hardirq_offset)
diff -rup /home/fmayhar/Static/linux-2.6.18.5/kernel/signal.c linux-2.6.18.5/kernel/signal.c
--- /home/fmayhar/Static/linux-2.6.18.5/kernel/signal.c	2006-12-01 16:13:05.000000000 -0800
+++ linux-2.6.18.5/kernel/signal.c	2008-03-06 15:50:31.000000000 -0800
@@ -1447,10 +1447,8 @@ void do_notify_parent(struct task_struct
 	info.si_uid = tsk->uid;
 
 	/* FIXME: find out whether or not this is supposed to be c*time. */
-	info.si_utime = cputime_to_jiffies(cputime_add(tsk->utime,
-						       tsk->signal->utime));
-	info.si_stime = cputime_to_jiffies(cputime_add(tsk->stime,
-						       tsk->signal->stime));
+	info.si_utime = cputime_to_jiffies(tsk->signal->shared_utime);
+	info.si_stime = cputime_to_jiffies(tsk->signal->shared_stime);
 
 	info.si_status = tsk->exit_code & 0x7f;
 	if (tsk->exit_code & 0x80)
diff -rup /home/fmayhar/Static/linux-2.6.18.5/kernel/sys.c linux-2.6.18.5/kernel/sys.c
--- /home/fmayhar/Static/linux-2.6.18.5/kernel/sys.c	2006-12-01 16:13:05.000000000 -0800
+++ linux-2.6.18.5/kernel/sys.c	2008-03-06 15:51:37.000000000 -0800
@@ -1207,18 +1207,11 @@ asmlinkage long sys_times(struct tms __u
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
+		utime = tsk->signal->shared_utime;
+		stime = tsk->signal->shared_stime;
 
 		cutime = tsk->signal->cutime;
 		cstime = tsk->signal->cstime;
@@ -1910,16 +1903,14 @@ static void k_getrusage(struct task_stru
 				break;
 
 		case RUSAGE_SELF:
-			utime = cputime_add(utime, p->signal->utime);
-			stime = cputime_add(stime, p->signal->stime);
+			utime = cputime_add(utime, p->signal->shared_utime);
+			stime = cputime_add(stime, p->signal->shared_stime);
 			r->ru_nvcsw += p->signal->nvcsw;
 			r->ru_nivcsw += p->signal->nivcsw;
 			r->ru_minflt += p->signal->min_flt;
 			r->ru_majflt += p->signal->maj_flt;
 			t = p;
 			do {
-				utime = cputime_add(utime, t->utime);
-				stime = cputime_add(stime, t->stime);
 				r->ru_nvcsw += t->nvcsw;
 				r->ru_nivcsw += t->nivcsw;
 				r->ru_minflt += t->min_flt;

--=-W14Ai3f16FryyNJrWQiK--

