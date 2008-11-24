Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbYKXQFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbYKXQFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbYKXQC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:02:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53356 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbYKXQC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:02:57 -0500
Date: Mon, 24 Nov 2008 17:02:53 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] getrusage: fill ru_maxrss value
Message-ID: <20081124170253.741d2e6e@psychotron.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the patch previously posted by Frank Mayhar:
http://kerneltrap.org/mailarchive/linux-kernel/2007/9/20/264772

Slightly changed to not panic and to set the value properly.
This patch enables "time" application to show maxresident value correctly.

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
---
 include/linux/sched.h |    3 +++
 kernel/exit.c         |   21 +++++++++++++++++++++
 kernel/fork.c         |    2 ++
 kernel/sys.c          |    8 ++++++++
 4 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 644ffbd..b88c538 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -560,6 +560,7 @@ struct signal_struct {
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 	unsigned long inblock, oublock, cinblock, coublock;
 	struct task_io_accounting ioac;
+	unsigned long cmaxrss;
 
 	/*
 	 * We don't bother to synchronize most readers of this at all,
@@ -1177,6 +1178,8 @@ struct task_struct {
 	struct timespec real_start_time;	/* boot based time */
 /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
 	unsigned long min_flt, maj_flt;
+/* maxrss gets the hiwater_rss in do_exit() */
+	unsigned long maxrss;
 
 	struct task_cputime cputime_expires;
 	struct list_head cpu_timers[3];
diff --git a/kernel/exit.c b/kernel/exit.c
index 2d8be7e..e0f5fd5 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -120,6 +120,8 @@ static void __exit_signal(struct task_struct *tsk)
 		sig->inblock += task_io_get_inblock(tsk);
 		sig->oublock += task_io_get_oublock(tsk);
 		task_io_accounting_add(&sig->ioac, &tsk->ioac);
+		if (tsk->maxrss > sig->cmaxrss)
+			sig->cmaxrss = tsk->maxrss;
 		sig = NULL; /* Marker for below. */
 	}
 
@@ -1051,6 +1053,14 @@ NORET_TYPE void do_exit(long code)
 	if (tsk->mm) {
 		update_hiwater_rss(tsk->mm);
 		update_hiwater_vm(tsk->mm);
+		BUG_ON(tsk->maxrss != 0);
+		/*
+		 * Store the hiwater_rss in a task field, since when we need
+		 * it in __exit_signal() the mm structure is gone; we can't
+		 * stuff it in the signal structure since then we would be
+		 * racing with wait_task_zombie().
+		 */
+		tsk->maxrss = tsk->mm->hiwater_rss;
 	}
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
@@ -1354,6 +1364,17 @@ static int wait_task_zombie(struct task_struct *p, int options,
 			sig->oublock + sig->coublock;
 		task_io_accounting_add(&psig->ioac, &p->ioac);
 		task_io_accounting_add(&psig->ioac, &sig->ioac);
+		/*
+		 * Save the maximum RSS of this task and all its terminated,
+		 * waited-for children.  Don't accumulate the RSS since, one,
+		 * other operating systems (FreeBSD, AIX) do it this way and,
+		 * two, the cumulative RSS of a long-lived process with lots
+		 * of sequential child process would be meaningless.
+		 */
+		if (sig->cmaxrss > psig->cmaxrss)
+			psig->cmaxrss = sig->cmaxrss;
+		if (p->maxrss > psig->cmaxrss)
+			psig->cmaxrss = p->maxrss;
 		spin_unlock_irq(&p->parent->sighand->siglock);
 	}
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 2a372a0..a853be4 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -622,6 +622,7 @@ static int copy_mm(unsigned long clone_flags, struct task_struct * tsk)
 
 	tsk->min_flt = tsk->maj_flt = 0;
 	tsk->nvcsw = tsk->nivcsw = 0;
+	tsk->maxrss = 0;
 
 	tsk->mm = NULL;
 	tsk->active_mm = NULL;
@@ -847,6 +848,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
 	task_io_accounting_init(&sig->ioac);
+	sig->cmaxrss = 0;
 	taskstats_tgid_init(sig);
 
 	task_lock(current->group_leader);
diff --git a/kernel/sys.c b/kernel/sys.c
index 31deba8..4f3855b 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1569,6 +1569,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 			r->ru_majflt = p->signal->cmaj_flt;
 			r->ru_inblock = p->signal->cinblock;
 			r->ru_oublock = p->signal->coublock;
+			r->ru_maxrss = p->signal->cmaxrss;
 
 			if (who == RUSAGE_CHILDREN)
 				break;
@@ -1588,6 +1589,13 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 				accumulate_thread_rusage(t, r);
 				t = next_thread(t);
 			} while (t != p);
+			if (p->mm) {
+				update_hiwater_rss(p->mm);
+				if (r->ru_maxrss < p->mm->hiwater_rss)
+					r->ru_maxrss = p->mm->hiwater_rss;
+			} else {
+				r->ru_maxrss = p->maxrss;
+			}
 			break;
 
 		default:
-- 
1.5.6.5

