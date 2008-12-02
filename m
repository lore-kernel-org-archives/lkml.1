Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbYLBMSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbYLBMSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 07:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbYLBMSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 07:18:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51568 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbYLBMSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 07:18:37 -0500
Date: Tue, 2 Dec 2008 13:18:02 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] getrusage: fill ru_maxrss value
Message-ID: <20081202131802.5252b96d@psychotron.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the patch previously posted by Frank Mayhar:
http://kerneltrap.org/mailarchive/linux-kernel/2007/9/20/264772

Changed to do not panic and to set the value properly. Also made some
modifications as Oleg suggested. maxrss value is set to pages as "time"
application converts it co KBs.

This patch enables "time" application to show maxresident value
correctly.

Note that even without this patch applied there is a race between two
parallel update_hiwater_rss() callers.

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
---
 include/linux/sched.h |    1 +
 kernel/exit.c         |    4 ++++
 kernel/fork.c         |    1 +
 kernel/sys.c          |   17 +++++++++++++++++
 4 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 644ffbd..818c37d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -560,6 +560,7 @@ struct signal_struct {
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 	unsigned long inblock, oublock, cinblock, coublock;
 	struct task_io_accounting ioac;
+	unsigned long maxrss, cmaxrss;
 
 	/*
 	 * We don't bother to synchronize most readers of this at all,
diff --git a/kernel/exit.c b/kernel/exit.c
index 2d8be7e..f09d4e7 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1051,6 +1051,8 @@ NORET_TYPE void do_exit(long code)
 	if (tsk->mm) {
 		update_hiwater_rss(tsk->mm);
 		update_hiwater_vm(tsk->mm);
+
+		tsk->signal->maxrss = tsk->mm->hiwater_rss;
 	}
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
@@ -1354,6 +1356,8 @@ static int wait_task_zombie(struct task_struct *p, int options,
 			sig->oublock + sig->coublock;
 		task_io_accounting_add(&psig->ioac, &p->ioac);
 		task_io_accounting_add(&psig->ioac, &sig->ioac);
+		if (psig->cmaxrss < sig->maxrss)
+			psig->cmaxrss = sig->maxrss;
 		spin_unlock_irq(&p->parent->sighand->siglock);
 	}
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 2a372a0..bb881aa 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -847,6 +847,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
 	task_io_accounting_init(&sig->ioac);
+	sig->maxrss = sig->cmaxrss = 0;
 	taskstats_tgid_init(sig);
 
 	task_lock(current->group_leader);
diff --git a/kernel/sys.c b/kernel/sys.c
index 31deba8..f604b05 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1546,6 +1546,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 	unsigned long flags;
 	cputime_t utime, stime;
 	struct task_cputime cputime;
+	unsigned long maxrss = 0;
 
 	memset((char *) r, 0, sizeof *r);
 	utime = stime = cputime_zero;
@@ -1555,6 +1556,17 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 		goto out;
 	}
 
+	if (who == RUSAGE_SELF || who == RUSAGE_BOTH) {
+		struct mm_struct *mm;
+
+		mm = get_task_mm(p);
+		if (mm) {
+			update_hiwater_rss(mm);
+			maxrss = mm->hiwater_rss;
+			mmput(mm);
+		}
+	}
+
 	if (!lock_task_sighand(p, &flags))
 		return;
 
@@ -1569,6 +1581,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 			r->ru_majflt = p->signal->cmaj_flt;
 			r->ru_inblock = p->signal->cinblock;
 			r->ru_oublock = p->signal->coublock;
+			r->ru_maxrss = p->signal->cmaxrss;
 
 			if (who == RUSAGE_CHILDREN)
 				break;
@@ -1588,6 +1601,10 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 				accumulate_thread_rusage(t, r);
 				t = next_thread(t);
 			} while (t != p);
+			if (r->ru_maxrss < maxrss)
+				r->ru_maxrss = maxrss;
+			if (r->ru_maxrss < p->signal->maxrss)
+				r->ru_maxrss = p->signal->maxrss;
 			break;
 
 		default:
-- 
1.5.6.5

