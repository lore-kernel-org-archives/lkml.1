Return-Path: <linux-kernel-owner+w=401wt.eu-S932603AbZHDK0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603AbZHDK0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932478AbZHDK0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:26:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50278 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548AbZHDK0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:26:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] oom: make oom_score to per-process value
Cc: kosaki.motohiro@jp.fujitsu.com, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20090804191031.6A3D.A69D9226@jp.fujitsu.com>
References: <20090804191031.6A3D.A69D9226@jp.fujitsu.com>
Message-Id: <20090804192557.6A43.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  4 Aug 2009 19:26:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] oom: make oom_score to per-process value

oom-killer kill a process, not task. Then oom_score should be
calculated as per-process too. it makes consistency more and
makes speed up select_bad_process().


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>,
Cc: Andrew Morton <akpm@linux-foundation.org>,
---
 Documentation/filesystems/proc.txt |    4 ++--
 fs/proc/base.c                     |    2 +-
 mm/oom_kill.c                      |   36 +++++++++++++++++++++++++++++-------
 3 files changed, 32 insertions(+), 10 deletions(-)

Index: b/mm/oom_kill.c
===================================================================
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -58,6 +58,19 @@ void set_oom_adj(struct task_struct *tsk
 }
 
 
+static int has_intersects_mems_allowed(struct task_struct *tsk)
+{
+	struct task_struct *t;
+
+	t = tsk;
+	do {
+		if (cpuset_mems_allowed_intersects(current, t))
+			return 1;
+		t = next_thread(t);
+	} while (t != tsk);
+
+	return 0;
+}
 
 /**
  * badness - calculate a numeric value for how bad this task has been
@@ -77,18 +90,26 @@ void set_oom_adj(struct task_struct *tsk
  *    algorithm has been meticulously tuned to meet the principle
  *    of least surprise ... (be careful when you change it)
  */
-
 unsigned long badness(struct task_struct *p, unsigned long uptime)
 {
 	unsigned long points, cpu_time, run_time;
 	struct mm_struct *mm;
 	struct task_struct *child;
 	int oom_adj;
+	struct task_cputime task_time;
+	unsigned long flags;
+	unsigned long utime;
+	unsigned long stime;
 
 	oom_adj = get_oom_adj(p);
 	if (oom_adj == OOM_DISABLE)
 		return 0;
 
+	if (!lock_task_sighand(p, &flags))
+		return 0;
+	thread_group_cputime(p, &task_time);
+	unlock_task_sighand(p, &flags);
+
 	task_lock(p);
 	mm = p->mm;
 	if (!mm) {
@@ -132,8 +153,9 @@ unsigned long badness(struct task_struct
          * of seconds. There is no particular reason for this other than
          * that it turned out to work very well in practice.
 	 */
-	cpu_time = (cputime_to_jiffies(p->utime) + cputime_to_jiffies(p->stime))
-		>> (SHIFT_HZ + 3);
+	utime = cputime_to_jiffies(task_time.utime);
+	stime = cputime_to_jiffies(task_time.stime);
+	cpu_time = (utime + stime) >> (SHIFT_HZ + 3);
 
 	if (uptime >= p->start_time.tv_sec)
 		run_time = (uptime - p->start_time.tv_sec) >> 10;
@@ -174,7 +196,7 @@ unsigned long badness(struct task_struct
 	 * because p may have allocated or otherwise mapped memory on
 	 * this node before. However it will be less likely.
 	 */
-	if (!cpuset_mems_allowed_intersects(current, p))
+	if (!has_intersects_mems_allowed(p))
 		points /= 8;
 
 	/*
@@ -230,13 +252,13 @@ static inline enum oom_constraint constr
 static struct task_struct *select_bad_process(unsigned long *ppoints,
 						struct mem_cgroup *mem)
 {
-	struct task_struct *g, *p;
+	struct task_struct *p;
 	struct task_struct *chosen = NULL;
 	struct timespec uptime;
 	*ppoints = 0;
 
 	do_posix_clock_monotonic_gettime(&uptime);
-	do_each_thread(g, p) {
+	for_each_process(p) {
 		unsigned long points;
 
 		/*
@@ -286,7 +308,7 @@ static struct task_struct *select_bad_pr
 			chosen = p;
 			*ppoints = points;
 		}
-	} while_each_thread(g, p);
+	}
 
 	return chosen;
 }
Index: b/fs/proc/base.c
===================================================================
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -450,7 +450,7 @@ static int proc_oom_score(struct task_st
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	read_lock(&tasklist_lock);
-	points = badness(task, uptime.tv_sec);
+	points = badness(task->group_leader, uptime.tv_sec);
 	read_unlock(&tasklist_lock);
 	return sprintf(buffer, "%lu\n", points);
 }
Index: b/Documentation/filesystems/proc.txt
===================================================================
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1195,13 +1195,13 @@ The following heuristics are then applie
  * if the task was reniced, its score doubles
  * superuser or direct hardware access tasks (CAP_SYS_ADMIN, CAP_SYS_RESOURCE
  	or CAP_SYS_RAWIO) have their score divided by 4
- * if oom condition happened in one cpuset and checked task does not belong
+ * if oom condition happened in one cpuset and checked process does not belong
  	to it, its score is divided by 8
  * the resulting score is multiplied by two to the power of oom_adj, i.e.
 	points <<= oom_adj when it is positive and
 	points >>= -(oom_adj) otherwise
 
-The task with the highest badness score is then selected and its children
+The process with the highest badness score is then selected and its children
 are killed, process itself will be killed in an OOM situation when it does
 not have children or some of them disabled oom like described above.
 


