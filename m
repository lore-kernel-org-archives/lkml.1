Return-Path: <linux-kernel-owner+w=401wt.eu-S1760420AbZKZMe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760420AbZKZMe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 07:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760382AbZKZMe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 07:34:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:57868 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759694AbZKZMeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 07:34:25 -0500
Date: Thu, 26 Nov 2009 12:33:48 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, spencer@bluehost.com, hpa@zytor.com,
       mingo@redhat.com, seto.hidetoshi@jp.fujitsu.com, peterz@infradead.org,
       xiyou.wangcong@gmail.com, balbir@in.ibm.com, tglx@linutronix.de,
       oleg@redhat.com, sgruszka@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, spencer@bluehost.com,
       linux-kernel@vger.kernel.org, seto.hidetoshi@jp.fujitsu.com,
       peterz@infradead.org, xiyou.wangcong@gmail.com, balbir@in.ibm.com,
       oleg@redhat.com, tglx@linutronix.de, sgruszka@redhat.com, mingo@elte.hu
In-Reply-To: <4B0E16D1.70902@jp.fujitsu.com>
References: <4B0E16D1.70902@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove task_{u,s,g}time()
Message-ID: <tip-d5b7c78e975302a1bab28263266c39ecb71acad4@git.kernel.org>
Git-Commit-ID: d5b7c78e975302a1bab28263266c39ecb71acad4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d5b7c78e975302a1bab28263266c39ecb71acad4
Gitweb:     http://git.kernel.org/tip/d5b7c78e975302a1bab28263266c39ecb71acad4
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Thu, 26 Nov 2009 14:49:05 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 12:59:20 +0100

sched: Remove task_{u,s,g}time()

Now all task_{u,s}time() pairs are replaced by task_times().
And task_gtime() is too simple to be an inline function.

Cleanup them all.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Spencer Candland <spencer@bluehost.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>
LKML-Reference: <4B0E16D1.70902@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/proc/array.c       |    4 ++--
 include/linux/sched.h |    3 ---
 kernel/exit.c         |    2 +-
 kernel/sched.c        |   33 ++-------------------------------
 4 files changed, 5 insertions(+), 37 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 330deda..ca61a88 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -511,7 +511,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 			do {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
-				gtime = cputime_add(gtime, task_gtime(t));
+				gtime = cputime_add(gtime, t->gtime);
 				t = next_thread(t);
 			} while (t != task);
 
@@ -536,7 +536,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
 		task_times(task, &utime, &stime);
-		gtime = task_gtime(task);
+		gtime = task->gtime;
 	}
 
 	/* scale priority and nice values from timeslices to -20..20 */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index fe6ae15..0395b0f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1720,9 +1720,6 @@ static inline void put_task_struct(struct task_struct *t)
 		__put_task_struct(t);
 }
 
-extern cputime_t task_utime(struct task_struct *p);
-extern cputime_t task_stime(struct task_struct *p);
-extern cputime_t task_gtime(struct task_struct *p);
 extern void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st);
 
 /*
diff --git a/kernel/exit.c b/kernel/exit.c
index 29068ab..2eaf68b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -115,7 +115,7 @@ static void __exit_signal(struct task_struct *tsk)
 		task_times(tsk, &utime, &stime);
 		sig->utime = cputime_add(sig->utime, utime);
 		sig->stime = cputime_add(sig->stime, stime);
-		sig->gtime = cputime_add(sig->gtime, task_gtime(tsk));
+		sig->gtime = cputime_add(sig->gtime, tsk->gtime);
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
 		sig->nvcsw += tsk->nvcsw;
diff --git a/kernel/sched.c b/kernel/sched.c
index 475a6f2..82251c2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5182,22 +5182,12 @@ void account_idle_ticks(unsigned long ticks)
  * Use precise platform statistics if available:
  */
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
-cputime_t task_utime(struct task_struct *p)
-{
-	return p->utime;
-}
-
-cputime_t task_stime(struct task_struct *p)
-{
-	return p->stime;
-}
-
 void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
 	if (ut)
-		*ut = task_utime(p);
+		*ut = p->utime;
 	if (st)
-		*st = task_stime(p);
+		*st = p->stime;
 }
 #else
 
@@ -5235,27 +5225,8 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	if (st)
 		*st = p->prev_stime;
 }
-
-cputime_t task_utime(struct task_struct *p)
-{
-	cputime_t utime;
-	task_times(p, &utime, NULL);
-	return utime;
-}
-
-cputime_t task_stime(struct task_struct *p)
-{
-	cputime_t stime;
-	task_times(p, NULL, &stime);
-	return stime;
-}
 #endif
 
-inline cputime_t task_gtime(struct task_struct *p)
-{
-	return p->gtime;
-}
-
 /*
  * This function gets called by the timer code, with HZ frequency.
  * We call it with interrupts disabled.
