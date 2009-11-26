Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbZKZFtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbZKZFtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 00:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbZKZFtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 00:49:21 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34879 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbZKZFtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 00:49:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B0E16D1.70902@jp.fujitsu.com>
Date: Thu, 26 Nov 2009 14:49:05 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: [PATCH -tip 2/3] remove task_{u,s,g}time()
References: <4B061E9A.8040100@jp.fujitsu.com> <20091123102806.GD25978@dhcp-lab-161.englab.brq.redhat.com> <4B0B714C.9080607@jp.fujitsu.com> <4B0B8683.6020104@jp.fujitsu.com>
In-Reply-To: <4B0B8683.6020104@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now all task_{u,s}time() pairs are replaced by task_times().
And task_gtime() is too simple to be an inline function.

Cleanup them all.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
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
index a19e429..480de5b 100644
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
index 4d5e1a2..a7093c1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5146,22 +5146,12 @@ void account_idle_ticks(unsigned long ticks)
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
 
@@ -5199,27 +5189,8 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
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
-- 
1.6.5.3

