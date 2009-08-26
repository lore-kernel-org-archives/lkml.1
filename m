Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbZHZJef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbZHZJef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 05:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756446AbZHZJee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 05:34:34 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45739 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350AbZHZJed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 05:34:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [mmotm][PATCH 1/4] oom: move oom_adj value from task_struct to signal_struct
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20090826182634.3968.A69D9226@jp.fujitsu.com>
References: <20090826182634.3968.A69D9226@jp.fujitsu.com>
Message-Id: <20090826183257.396B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 26 Aug 2009 18:34:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, OOM logic callflow is here.

    __out_of_memory()
        select_bad_process()            for each task
            badness()                   calculate badness of one task
                oom_kill_process()      search child
                    oom_kill_task()     kill target task and mm shared tasks with it

example, process-A have two thread, thread-A and thread-B and it
have very fat memory and each thread have following oom_adj and oom_score.

     thread-A: oom_adj = OOM_DISABLE, oom_score = 0
     thread-B: oom_adj = 0,           oom_score = very-high

Then, select_bad_process() select thread-B, but oom_kill_task() refuse
kill the task because thread-A have OOM_DISABLE.
Thus __out_of_memory() call select_bad_process() again. but select_bad_process()
select the same task. It mean kernel fall in livelock.

The fact is, select_bad_process() must select killable task. otherwise
OOM logic go into livelock.

And root cause is, oom_adj shouldn't be per-thread value. it should be
per-process value because OOM-killer kill a process, not thread. Thus
This patch moves oomkilladj (now more appropriately named oom_adj) from
struct task_struct to struct signal_struct. it naturally prevent
select_bad_process() choose wrong task.

Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/proc/base.c        |   24 ++++++++++++++++++++----
 include/linux/sched.h |    3 ++-
 kernel/fork.c         |    2 ++
 mm/oom_kill.c         |   34 +++++++++++++++-------------------
 4 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 5856219..fbf8788 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1000,11 +1000,17 @@ static ssize_t oom_adjust_read(struct file *file, char __user *buf,
 	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
 	char buffer[PROC_NUMBUF];
 	size_t len;
-	int oom_adjust;
+	int oom_adjust = OOM_DISABLE;
+	unsigned long flags;
 
 	if (!task)
 		return -ESRCH;
-	oom_adjust = task->oomkilladj;
+
+	if (lock_task_sighand(task, &flags)) {
+		oom_adjust = task->signal->oom_adj;
+		unlock_task_sighand(task, &flags);
+	}
+
 	put_task_struct(task);
 
 	len = snprintf(buffer, sizeof(buffer), "%i\n", oom_adjust);
@@ -1018,6 +1024,7 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF], *end;
 	int oom_adjust;
+	unsigned long flags;
 
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
@@ -1033,11 +1040,20 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
-	if (oom_adjust < task->oomkilladj && !capable(CAP_SYS_RESOURCE)) {
+	if (!lock_task_sighand(task, &flags)) {
+		put_task_struct(task);
+		return -ESRCH;
+	}
+
+	if (oom_adjust < task->signal->oom_adj && !capable(CAP_SYS_RESOURCE)) {
+		unlock_task_sighand(task, &flags);
 		put_task_struct(task);
 		return -EACCES;
 	}
-	task->oomkilladj = oom_adjust;
+
+	task->signal->oom_adj = oom_adjust;
+
+	unlock_task_sighand(task, &flags);
 	put_task_struct(task);
 	if (end - buffer == 0)
 		return -EIO;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c40fb84..3a2ef73 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -678,6 +678,8 @@ struct signal_struct {
 	unsigned audit_tty;
 	struct tty_audit_buf *tty_audit_buf;
 #endif
+
+	int oom_adj;	/* OOM kill score adjustment (bit shift) */
 };
 
 /* Context switch must be unlocked if interrupts are to be enabled */
@@ -1246,7 +1248,6 @@ struct task_struct {
 	 * a short time
 	 */
 	unsigned char fpu_counter;
-	s8 oomkilladj; /* OOM kill score adjustment (bit shift). */
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	unsigned int btrace_seq;
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index c755101..58cd45a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -904,6 +904,8 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 
 	tty_audit_fork(sig);
 
+	sig->oom_adj = current->signal->oom_adj;
+
 	return 0;
 }
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index a7b2460..55dcadd 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -58,6 +58,10 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 	unsigned long points, cpu_time, run_time;
 	struct mm_struct *mm;
 	struct task_struct *child;
+	int oom_adj = p->signal->oom_adj;
+
+	if (oom_adj == OOM_DISABLE)
+		return 0;
 
 	task_lock(p);
 	mm = p->mm;
@@ -148,15 +152,15 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 		points /= 8;
 
 	/*
-	 * Adjust the score by oomkilladj.
+	 * Adjust the score by oom_adj.
 	 */
-	if (p->oomkilladj) {
-		if (p->oomkilladj > 0) {
+	if (oom_adj) {
+		if (oom_adj > 0) {
 			if (!points)
 				points = 1;
-			points <<= p->oomkilladj;
+			points <<= oom_adj;
 		} else
-			points >>= -(p->oomkilladj);
+			points >>= -(oom_adj);
 	}
 
 #ifdef DEBUG
@@ -251,7 +255,7 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 			*ppoints = ULONG_MAX;
 		}
 
-		if (p->oomkilladj == OOM_DISABLE)
+		if (p->signal->oom_adj == OOM_DISABLE)
 			continue;
 
 		points = badness(p, uptime.tv_sec);
@@ -304,7 +308,7 @@ static void dump_tasks(const struct mem_cgroup *mem)
 		}
 		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
 		       p->pid, __task_cred(p)->uid, p->tgid, mm->total_vm,
-		       get_mm_rss(mm), (int)task_cpu(p), p->oomkilladj,
+		       get_mm_rss(mm), (int)task_cpu(p), p->signal->oom_adj,
 		       p->comm);
 		task_unlock(p);
 	} while_each_thread(g, p);
@@ -359,18 +363,9 @@ static int oom_kill_task(struct task_struct *p)
 	 * change to NULL at any time since we do not hold task_lock(p).
 	 * However, this is of no concern to us.
 	 */
-
-	if (mm == NULL)
+	if (!mm || p->signal->oom_adj == OOM_DISABLE)
 		return 1;
 
-	/*
-	 * Don't kill the process if any threads are set to OOM_DISABLE
-	 */
-	do_each_thread(g, q) {
-		if (q->mm == mm && q->oomkilladj == OOM_DISABLE)
-			return 1;
-	} while_each_thread(g, q);
-
 	__oom_kill_task(p, 1);
 
 	/*
@@ -394,8 +389,9 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 
 	if (printk_ratelimit()) {
 		printk(KERN_WARNING "%s invoked oom-killer: "
-			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
-			current->comm, gfp_mask, order, current->oomkilladj);
+			"gfp_mask=0x%x, order=%d, oom_adj=%d\n",
+			current->comm, gfp_mask, order,
+			current->signal->oom_adj);
 		task_lock(current);
 		cpuset_print_task_mems_allowed(current);
 		task_unlock(current);
-- 
1.6.2.5



