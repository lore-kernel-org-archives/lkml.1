Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZKZFtC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZKZFtC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 00:49:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbZKZFtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 00:49:01 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34848 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbZKZFtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 00:49:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B0E16AE.906@jp.fujitsu.com>
Date: Thu, 26 Nov 2009 14:48:30 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: [PATCH -tip 1/3] introduce task_times() to replace task_{u,s}time()
 pair
References: <4B061E9A.8040100@jp.fujitsu.com> <20091123102806.GD25978@dhcp-lab-161.englab.brq.redhat.com> <4B0B714C.9080607@jp.fujitsu.com> <4B0B8683.6020104@jp.fujitsu.com>
In-Reply-To: <4B0B8683.6020104@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions task_{u,s}time() are called in pair in almost all
cases.  However task_stime() is implemented to call task_utime()
from its inside, so such paired calls run task_utime() twice.

It means we do heavy divisions (div_u64 + do_div) twice to get
utime and stime which can be obtained at same time by one set
of divisions.

This patch introduces a function task_times(*tsk, *utime, *stime)
to retrieve utime and stime at once in better, optimized way.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 fs/proc/array.c       |    3 +-
 include/linux/sched.h |    1 +
 kernel/exit.c         |    7 ++++-
 kernel/sched.c        |   55 +++++++++++++++++++++++++++++++-----------------
 kernel/sys.c          |    3 +-
 5 files changed, 43 insertions(+), 26 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index e209f64..330deda 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -535,8 +535,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	if (!whole) {
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
-		utime = task_utime(task);
-		stime = task_stime(task);
+		task_times(task, &utime, &stime);
 		gtime = task_gtime(task);
 	}
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 78ba664..fe6ae15 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1723,6 +1723,7 @@ static inline void put_task_struct(struct task_struct *t)
 extern cputime_t task_utime(struct task_struct *p);
 extern cputime_t task_stime(struct task_struct *p);
 extern cputime_t task_gtime(struct task_struct *p);
+extern void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st);
 
 /*
  * Per process flags
diff --git a/kernel/exit.c b/kernel/exit.c
index e61891f..a19e429 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -91,6 +91,8 @@ static void __exit_signal(struct task_struct *tsk)
 	if (atomic_dec_and_test(&sig->count))
 		posix_cpu_timers_exit_group(tsk);
 	else {
+		cputime_t utime, stime;
+
 		/*
 		 * If there is any task waiting for the group exit
 		 * then notify it:
@@ -110,8 +112,9 @@ static void __exit_signal(struct task_struct *tsk)
 		 * We won't ever get here for the group leader, since it
 		 * will have been the last reference on the signal_struct.
 		 */
-		sig->utime = cputime_add(sig->utime, task_utime(tsk));
-		sig->stime = cputime_add(sig->stime, task_stime(tsk));
+		task_times(tsk, &utime, &stime);
+		sig->utime = cputime_add(sig->utime, utime);
+		sig->stime = cputime_add(sig->stime, stime);
 		sig->gtime = cputime_add(sig->gtime, task_gtime(tsk));
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
diff --git a/kernel/sched.c b/kernel/sched.c
index a57c6ae..4d5e1a2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5155,6 +5155,14 @@ cputime_t task_stime(struct task_struct *p)
 {
 	return p->stime;
 }
+
+void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
+{
+	if (ut)
+		*ut = task_utime(p);
+	if (st)
+		*st = task_stime(p);
+}
 #else
 
 #ifndef nsecs_to_cputime
@@ -5162,41 +5170,48 @@ cputime_t task_stime(struct task_struct *p)
 	msecs_to_cputime(div_u64((__nsecs), NSEC_PER_MSEC))
 #endif
 
-cputime_t task_utime(struct task_struct *p)
+void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
-	cputime_t utime = p->utime, total = utime + p->stime;
-	u64 temp;
+	cputime_t rtime, utime = p->utime, total = utime + p->stime;
 
 	/*
 	 * Use CFS's precise accounting:
 	 */
-	temp = (u64)nsecs_to_cputime(p->se.sum_exec_runtime);
+	rtime = nsecs_to_cputime(p->se.sum_exec_runtime);
 
 	if (total) {
-		temp *= utime;
+		u64 temp;
+
+		temp = (u64)(rtime * utime);
 		do_div(temp, total);
-	}
-	utime = (cputime_t)temp;
+		utime = (cputime_t)temp;
+	} else
+		utime = rtime;
 
+	/*
+	 * Compare with previous values, to keep monotonicity:
+	 */
 	p->prev_utime = max(p->prev_utime, utime);
-	return p->prev_utime;
+	p->prev_stime = max(p->prev_stime, rtime - p->prev_utime);
+
+	if (ut)
+		*ut = p->prev_utime;
+	if (st)
+		*st = p->prev_stime;
+}
+
+cputime_t task_utime(struct task_struct *p)
+{
+	cputime_t utime;
+	task_times(p, &utime, NULL);
+	return utime;
 }
 
 cputime_t task_stime(struct task_struct *p)
 {
 	cputime_t stime;
-
-	/*
-	 * Use CFS's precise accounting. (we subtract utime from
-	 * the total, to make sure the total observed by userspace
-	 * grows monotonically - apps rely on that):
-	 */
-	stime = nsecs_to_cputime(p->se.sum_exec_runtime) - task_utime(p);
-
-	if (stime >= 0)
-		p->prev_stime = max(p->prev_stime, stime);
-
-	return p->prev_stime;
+	task_times(p, NULL, &stime);
+	return stime;
 }
 #endif
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 255475d..b6caf1e 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1344,8 +1344,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 	utime = stime = cputime_zero;
 
 	if (who == RUSAGE_THREAD) {
-		utime = task_utime(current);
-		stime = task_stime(current);
+		task_times(current, &utime, &stime);
 		accumulate_thread_rusage(p, r);
 		maxrss = p->signal->maxrss;
 		goto out;
-- 
1.6.5.3

