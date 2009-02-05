Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbZBELdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbZBELdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 06:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbZBELdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 06:33:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48868 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687AbZBELdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 06:33:23 -0500
Message-Id: <20090205113139.028904243@chello.nl>
References: <20090205112414.104100700@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 05 Feb 2009 12:24:15 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, tglx@linutronix.de, oleg@redhat.com
Cc: linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
       seto.hidetoshi@jp.fujitsu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2] signal: re-add dead task accumulation stats.
Content-Disposition: inline; filename=sig-cummulative-times.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're going to split the process wide cpu accounting into two parts:

 - clocks; which can take all the time they want since they run
           from user context.

 - timers; which need constant time tracing but can affort the overhead
           because they're default off -- and rare.

The clock readout will go back to a full sum of the thread group, for this
we need to re-add the exit stats that were removed in the initial itimer
rework (f06febc9: timers: fix itimer/many thread hang).

Furthermore, since that full sum can be rather slow for large thread groups
and we have the complete dead task stats, revert the do_notify_parent time
computation.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |   10 +++++++++-
 kernel/exit.c         |    3 +++
 kernel/fork.c         |    3 ++-
 3 files changed, 14 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -567,7 +567,7 @@ struct signal_struct {
 	 * Live threads maintain their own counters and add to these
 	 * in __exit_signal, except for the group leader.
 	 */
-	cputime_t cutime, cstime;
+	cputime_t utime, stime, cutime, cstime;
 	cputime_t gtime;
 	cputime_t cgtime;
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
@@ -576,6 +576,14 @@ struct signal_struct {
 	struct task_io_accounting ioac;
 
 	/*
+	 * Cumulative ns of schedule CPU time fo dead threads in the
+	 * group, not including a zombie group leader, (This only differs
+	 * from jiffies_to_ns(utime + stime) if sched_clock uses something
+	 * other than jiffies.)
+	 */
+	unsigned long long sum_sched_runtime;
+
+	/*
 	 * We don't bother to synchronize most readers of this at all,
 	 * because there is no reader checking a limit that actually needs
 	 * to get both rlim_cur and rlim_max atomically, and either one
Index: linux-2.6/kernel/exit.c
===================================================================
--- linux-2.6.orig/kernel/exit.c
+++ linux-2.6/kernel/exit.c
@@ -118,6 +118,8 @@ static void __exit_signal(struct task_st
 		 * We won't ever get here for the group leader, since it
 		 * will have been the last reference on the signal_struct.
 		 */
+		sig->utime = cputime_add(sig->utime, task_utime(tsk));
+		sig->stime = cputime_add(sig->stime, task_stime(tsk));
 		sig->gtime = cputime_add(sig->gtime, task_gtime(tsk));
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
@@ -126,6 +128,7 @@ static void __exit_signal(struct task_st
 		sig->inblock += task_io_get_inblock(tsk);
 		sig->oublock += task_io_get_oublock(tsk);
 		task_io_accounting_add(&sig->ioac, &tsk->ioac);
+		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 		sig = NULL; /* Marker for below. */
 	}
 
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -856,13 +856,14 @@ static int copy_signal(unsigned long clo
 	sig->tty_old_pgrp = NULL;
 	sig->tty = NULL;
 
-	sig->cutime = sig->cstime = cputime_zero;
+	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
 	sig->gtime = cputime_zero;
 	sig->cgtime = cputime_zero;
 	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
 	task_io_accounting_init(&sig->ioac);
+	sig->sum_sched_runtime = 0;
 	taskstats_tgid_init(sig);
 
 	task_lock(current->group_leader);
Index: linux-2.6/kernel/signal.c
===================================================================
--- linux-2.6.orig/kernel/signal.c
+++ linux-2.6/kernel/signal.c
@@ -1367,7 +1367,6 @@ int do_notify_parent(struct task_struct 
 	struct siginfo info;
 	unsigned long flags;
 	struct sighand_struct *psig;
-	struct task_cputime cputime;
 	int ret = sig;
 
 	BUG_ON(sig == -1);
@@ -1397,9 +1396,10 @@ int do_notify_parent(struct task_struct 
 	info.si_uid = __task_cred(tsk)->uid;
 	rcu_read_unlock();
 
-	thread_group_cputime(tsk, &cputime);
-	info.si_utime = cputime_to_jiffies(cputime.utime);
-	info.si_stime = cputime_to_jiffies(cputime.stime);
+	info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
+				tsk->signal->utime));
+	info.si_stime = cputime_to_clock_t(cputime_add(tsk->stime,
+				tsk->signal->stime));
 
 	info.si_status = tsk->exit_code & 0x7f;
 	if (tsk->exit_code & 0x80)

-- 

