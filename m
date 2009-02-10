Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbZBJPgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbZBJPgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 10:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZBJPfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 10:35:52 -0500
Received: from viefep13-int.chello.at ([62.179.121.33]:43341 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbZBJPfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 10:35:52 -0500
X-SourceIP: 213.46.9.244
Subject: Re: x86-tip.today: flood of WARNING: at include/linux/sched.h:2238
 run_posix_cpu_timers+0xea/0x79f()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090206140134.GC3415@elte.hu>
References: <1233910614.23431.18.camel@marge.simson.net>
	 <20090206140134.GC3415@elte.hu>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 16:37:31 +0100
Message-Id: <1234280251.23438.73.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 15:01 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > Greetings,
> > 
> > Futzing with kerneltop this morning, I fired up amarok to give it
> > something light to monitor while I hunt missing events.  Something bad
> > happened, and when I finally (SysRq-E took minutes) got control of box
> > back, dmesg was full of a steady stream of the below.
> > 
> > That warning can be kinda unfriendly.
> > 
> > 
> > [ 9964.600004] ------------[ cut here ]------------
> > [ 9964.600006] WARNING: at include/linux/sched.h:2238 run_posix_cpu_timers+0xea/0x79f()
> 
> ah, that's Peter's stuff:
> 
>  4cd4c1b: timers: split process wide cpu clocks/timers
>  32bd671: signal: re-add dead task accumulation stats.
> 
> The discussion with Oleg resulted in the conclusion i 
> think that the warning is spurious and should be removed.
> 
> I've commited the minimal fix below to tip:master. There's
> more fixes needed too but this should solve the warning
> flood at least.

I think this is the 'minimal' paranoia version.

---
Subject: timer: cleanup the clock/timer separation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Feb 10 15:46:29 CET 2009

To decrease the chance of a missed enable, always enable the timer when we
sample it, we'll always disable it when we find that there are no active timers
in the jiffy tick.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h     |    1 +
 kernel/posix-cpu-timers.c |   42 ++++++++++++++----------------------------
 2 files changed, 15 insertions(+), 28 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -2237,6 +2237,7 @@ void thread_group_cputimer(struct task_s
 	unsigned long flags;
 
 	spin_lock_irqsave(&cputimer->lock, flags);
+	cputimer->running = 1;
 	*times = cputimer->cputime;
 	spin_unlock_irqrestore(&cputimer->lock, flags);
 }
Index: linux-2.6/kernel/posix-cpu-timers.c
===================================================================
--- linux-2.6.orig/kernel/posix-cpu-timers.c
+++ linux-2.6/kernel/posix-cpu-timers.c
@@ -488,7 +488,7 @@ void posix_cpu_timers_exit_group(struct 
 {
 	struct task_cputime cputime;
 
-	thread_group_cputime(tsk, &cputime);
+	thread_group_cputimer(tsk, &cputime);
 	cleanup_timers(tsk->signal->cpu_timers,
 		       cputime.utime, cputime.stime, cputime.sum_exec_runtime);
 }
@@ -507,29 +507,6 @@ static void clear_dead_task(struct k_iti
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
@@ -549,9 +526,6 @@ static void arm_timer(struct k_itimer *t
 	BUG_ON(!irqs_disabled());
 	spin_lock(&p->sighand->siglock);
 
-	if (!CPUCLOCK_PERTHREAD(timer->it_clock))
-		start_process_timers(p);
-
 	listpos = head;
 	if (CPUCLOCK_WHICH(timer->it_clock) == CPUCLOCK_SCHED) {
 		list_for_each_entry(next, head, entry) {
@@ -1021,6 +995,19 @@ static void check_thread_timers(struct t
 	}
 }
 
+static void stop_process_timers(struct task_struct *tsk)
+{
+	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
+	unsigned long flags;
+
+	if (!cputimer->running)
+		return;
+
+	spin_lock_irqsave(&cputimer->lock);
+	cputimer->running = 0;
+	spin_unlock_irqrestore(&cputimer->lock);
+}
+
 /*
  * Check for any per-thread CPU timers that have fired and move them
  * off the tsk->*_timers list onto the firing list.  Per-thread timers
@@ -1427,7 +1414,6 @@ void set_process_cpu_timer(struct task_s
 	struct list_head *head;
 
 	BUG_ON(clock_idx == CPUCLOCK_SCHED);
-	start_process_timers(tsk);
 	cpu_timer_sample_group(clock_idx, tsk, &now);
 
 	if (oldval) {


