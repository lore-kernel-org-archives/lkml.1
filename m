Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbYBYPqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbYBYPqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 10:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbYBYPqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 10:46:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35840 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbYBYPqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 10:46:10 -0500
Date: Mon, 25 Feb 2008 16:45:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [git pull] scheduler fixes
Message-ID: <20080225154557.GA24546@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

Two cross-subsystem changes:

 arch/um/kernel/process.c:  scheduler related prototype cleanup
           fs/proc/base.c:  latencytop fixes

Thanks,

	Ingo

------------------>
Balbir Singh (1):
      sched: remove duplicate code from sched_fair.c

Harvey Harrison (2):
      sched: fix signedness warnings in sched.c
      sched: add declaration of sched_tail to sched.h

Hiroshi Shimamoto (3):
      latencytop: fix kernel panic while reading latency proc file
      latencytop: fix memory leak on latency proc file
      latencytop: change /proc task_struct access method

Ingo Molnar (2):
      sched: make early bootup sched_clock() use safer
      sched: clean up __pick_last_entity() a bit

 arch/um/kernel/process.c |    2 --
 fs/proc/base.c           |   27 +++++++++++----------------
 include/linux/sched.h    |    1 +
 kernel/sched.c           |   16 +++++++++++-----
 kernel/sched_fair.c      |   13 ++++---------
 5 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index fc50d2f..e8cb9ff 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -128,8 +128,6 @@ void *get_current(void)
 	return current;
 }
 
-extern void schedule_tail(struct task_struct *prev);
-
 /*
  * This is called magically, by its address being stuffed in a jmp_buf
  * and being longjmp-d to.
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 96ee899..91a1bd6 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -314,9 +314,12 @@ static int proc_pid_schedstat(struct task_struct *task, char *buffer)
 static int lstats_show_proc(struct seq_file *m, void *v)
 {
 	int i;
-	struct task_struct *task = m->private;
-	seq_puts(m, "Latency Top version : v0.1\n");
+	struct inode *inode = m->private;
+	struct task_struct *task = get_proc_task(inode);
 
+	if (!task)
+		return -ESRCH;
+	seq_puts(m, "Latency Top version : v0.1\n");
 	for (i = 0; i < 32; i++) {
 		if (task->latency_record[i].backtrace[0]) {
 			int q;
@@ -341,32 +344,24 @@ static int lstats_show_proc(struct seq_file *m, void *v)
 		}
 
 	}
+	put_task_struct(task);
 	return 0;
 }
 
 static int lstats_open(struct inode *inode, struct file *file)
 {
-	int ret;
-	struct seq_file *m;
-	struct task_struct *task = get_proc_task(inode);
-
-	ret = single_open(file, lstats_show_proc, NULL);
-	if (!ret) {
-		m = file->private_data;
-		m->private = task;
-	}
-	return ret;
+	return single_open(file, lstats_show_proc, inode);
 }
 
 static ssize_t lstats_write(struct file *file, const char __user *buf,
 			    size_t count, loff_t *offs)
 {
-	struct seq_file *m;
-	struct task_struct *task;
+	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
 
-	m = file->private_data;
-	task = m->private;
+	if (!task)
+		return -ESRCH;
 	clear_all_latency_tracing(task);
+	put_task_struct(task);
 
 	return count;
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e217d18..9c17e82 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -242,6 +242,7 @@ struct task_struct;
 
 extern void sched_init(void);
 extern void sched_init_smp(void);
+extern asmlinkage void schedule_tail(struct task_struct *prev);
 extern void init_idle(struct task_struct *idle, int cpu);
 extern void init_idle_bootup_task(struct task_struct *idle);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index b387a8d..f06950c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -668,6 +668,8 @@ const_debug unsigned int sysctl_sched_nr_migrate = 32;
  */
 unsigned int sysctl_sched_rt_period = 1000000;
 
+static __read_mostly int scheduler_running;
+
 /*
  * part of the period that we allow rt tasks to run in us.
  * default: 0.95s
@@ -689,14 +691,16 @@ unsigned long long cpu_clock(int cpu)
 	unsigned long flags;
 	struct rq *rq;
 
-	local_irq_save(flags);
-	rq = cpu_rq(cpu);
 	/*
 	 * Only call sched_clock() if the scheduler has already been
 	 * initialized (some code might call cpu_clock() very early):
 	 */
-	if (rq->idle)
-		update_rq_clock(rq);
+	if (unlikely(!scheduler_running))
+		return 0;
+
+	local_irq_save(flags);
+	rq = cpu_rq(cpu);
+	update_rq_clock(rq);
 	now = rq->clock;
 	local_irq_restore(flags);
 
@@ -3885,7 +3889,7 @@ pick_next_task(struct rq *rq, struct task_struct *prev)
 asmlinkage void __sched schedule(void)
 {
 	struct task_struct *prev, *next;
-	long *switch_count;
+	unsigned long *switch_count;
 	struct rq *rq;
 	int cpu;
 
@@ -7284,6 +7288,8 @@ void __init sched_init(void)
 	 * During early bootup we pretend to be a normal task:
 	 */
 	current->sched_class = &fair_sched_class;
+
+	scheduler_running = 1;
 }
 
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 6c091d6..c8e6492 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -202,17 +202,12 @@ static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
 
 static inline struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
 {
-	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
-	struct sched_entity *se = NULL;
-	struct rb_node *parent;
+	struct rb_node *last = rb_last(&cfs_rq->tasks_timeline);
 
-	while (*link) {
-		parent = *link;
-		se = rb_entry(parent, struct sched_entity, run_node);
-		link = &parent->rb_right;
-	}
+	if (!last)
+		return NULL;
 
-	return se;
+	return rb_entry(last, struct sched_entity, run_node);
 }
 
 /**************************************************************
