Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbXLIX6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbXLIX6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 18:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbXLIX6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 18:58:45 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35395 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbXLIX6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 18:58:42 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] will_become_orphaned_pgrp: we have threads
References: <20071208183800.GA9940@tv-sign.ru>
	<m11w9wpx03.fsf@ebiederm.dsl.xmission.com>
	<20071209142116.GB131@tv-sign.ru>
	<m14perooqx.fsf@ebiederm.dsl.xmission.com>
	<20071209164311.GA416@tv-sign.ru>
Date: Sun, 09 Dec 2007 16:56:17 -0700
In-Reply-To: <20071209164311.GA416@tv-sign.ru> (Oleg Nesterov's message of
	"Sun, 9 Dec 2007 19:43:11 +0300")
Message-ID: <m1zlwj2zj2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 12/09, Eric W. Biederman wrote:
>>
>> Equally messed up is a our status in /proc at that point.  Which
>> says our sleeping process is a zombie.
>
> Yes, this is annoying.
>
>> I'm thinking we need to do at least some of the thread group leadership
>> transfer in do_exit, instead of de_thread.  Then p->group_leader->exit_state
>> would be sufficient to see if the entire thread group was alive,
>> as the group_leader would be whoever was left alive.  The original
>> group_leader might still need to be kept around for it's pid...
>>
>> I think that would solve most of the problems you have with a dead
>> thread group leader and sending SIG_STOP as well.
>
> Yes I was thinking about that too, but I am not brave enough to even
> try to to think to the end ;)
>
> As a minimal change, I tried to add "task_struct *leader_proxy" to
> signal_struct, which points to the next live thread, and changed by
> exit_notify(). eligible_child() checks it instead of ->exit_signal.
> But this is so messy...
>
> And in fact, if we are talking about group stop, it is a group operation,
> why do_wait() uses per-thread ->exit_code but not ->group_exit_code ?
Good question, we would need a fallback for the case it isn't a group
operation like in exit but that might clean something up.

> But yes, [PATCH 3/3] adds a visible difference, and I don't know if
> this difference is good or bad.
>
> 	$ sleep 1000
>
> 	[1]+  Stopped                 sleep 1000
> 	$ strace -p `pidof sleep`
> 	Process 432 attached - interrupt to quit
>
> Now strace "hangs" in do_wait() because ->exit_code was eaten by the
> shell. We need SIGCONT.
>
> With the "[PATCH 3/3]" strace proceeds happily.
>
> Oleg.

Well I got to playing with the idea of actually moving group_leader
and it turns out that while it is a pain it isn't actually that bad.
The worst part is not really changing the pid of the leader to the pid
of the entire thread group.  As there are a few cases where we are
current referencing the task_pid where we really want task_tgid.

Oleg below is my proof of concept patch, which really needs to be
broken up into a whole patch series, so the changes are small
enough we can do a thorough audit on them.  Anyway take a look
and see what you think.

This patch does fix your weird test case without any actual
change to the do_wait logic itself.

The key idea is that by not making PIDTYPE_PID a hash chain we
can point two different struct pids at the same process allowing
two different pids to return the same process from pid_task(pid,
PIDTYPE_PID);

Which means most things continue to just work by working on
PIDTYPE_PID, although as mentioned previously there are a few
things particulary do_notify_parent_cldstop and do_wait that
need to be changed to return the tgid instead of the pid.

Oh and in eligible child the PIDTYPE_PID test is now sneaky
essentially doing a task lookup and seeing if the result
is our target pid, instead of comparing pids.

The funny part is grep pid /proc/<tgid>/status no longer
always equals the tgid after the pid exits.  Still that seems
better then making the entire thread group look like a zombie
just because the wrong thread exited.

Subject: [PATCH] All thread group leaders to exit

---
 fs/exec.c                 |   81 ++---------------------
 fs/fcntl.c                |   20 ++++--
 fs/proc/base.c            |    6 +-
 include/linux/init_task.h |   25 ++++----
 include/linux/pid.h       |   14 ++---
 include/linux/sched.h     |   43 ++++++------
 kernel/exit.c             |  157 +++++++++++++++++++++++++++-----------------
 kernel/fork.c             |    2 +-
 kernel/itimer.c           |    2 +-
 kernel/pid.c              |   60 +++++++++++------
 kernel/signal.c           |   23 ++-----
 11 files changed, 204 insertions(+), 229 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 14a690d..1f69326 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -786,22 +786,6 @@ static int de_thread(struct task_struct *tsk)
 	 * Account for the thread group leader hanging around:
 	 */
 	count = 1;
-	if (!thread_group_leader(tsk)) {
-		count = 2;
-		/*
-		 * The SIGALRM timer survives the exec, but needs to point
-		 * at us as the new group leader now.  We have a race with
-		 * a timer firing now getting the old leader, so we need to
-		 * synchronize with any firing (by calling del_timer_sync)
-		 * before we can safely let the old group leader die.
-		 */
-		sig->tsk = tsk;
-		spin_unlock_irq(lock);
-		if (hrtimer_cancel(&sig->real_timer))
-			hrtimer_restart(&sig->real_timer);
-		spin_lock_irq(lock);
-	}
-
 	sig->notify_count = count;
 	while (atomic_read(&sig->count) > count) {
 		__set_current_state(TASK_UNINTERRUPTIBLE);
@@ -811,68 +795,15 @@ static int de_thread(struct task_struct *tsk)
 	}
 	spin_unlock_irq(lock);
 
-	/*
-	 * At this point all other threads have exited, all we have to
-	 * do is to wait for the thread group leader to become inactive,
-	 * and to assume its PID:
-	 */
-	if (!thread_group_leader(tsk)) {
-		leader = tsk->group_leader;
-
-		sig->notify_count = -1;
-		for (;;) {
-			write_lock_irq(&tasklist_lock);
-			if (likely(leader->exit_state))
-				break;
-			__set_current_state(TASK_UNINTERRUPTIBLE);
-			write_unlock_irq(&tasklist_lock);
-			schedule();
+	/* If it isn't already force gettid() == getpid() */
+	if (sig->tgid != tsk->tid) {
+		write_lock_irq(&tasklist_lock);
+		if (sig->tgid != tsk->tid) {
+			detach_pid(tsk, PIDTYPE_PID);
+			attach_pid(tsk, PIDTYPE_PID, sig->tgid);
 		}
-
-		/*
-		 * The only record we have of the real-time age of a
-		 * process, regardless of execs it's done, is start_time.
-		 * All the past CPU time is accumulated in signal_struct
-		 * from sister threads now dead.  But in this non-leader
-		 * exec, nothing survives from the original leader thread,
-		 * whose birth marks the true age of this process now.
-		 * When we take on its identity by switching to its PID, we
-		 * also take its birthdate (always earlier than our own).
-		 */
-		tsk->start_time = leader->start_time;
-
-		BUG_ON(!same_thread_group(leader, tsk));
-		BUG_ON(has_group_leader_pid(tsk));
-		/*
-		 * An exec() starts a new thread group with the
-		 * TGID of the previous thread group. Rehash the
-		 * two threads with a switched PID, and release
-		 * the former thread group leader:
-		 */
-
-		/* Become a process group leader with the old leader's pid.
-		 * The old leader becomes a thread of the this thread group.
-		 * Note: The old leader also uses this pid until release_task
-		 *       is called.  Odd but simple and correct.
-		 */
-		detach_pid(tsk, PIDTYPE_PID);
-		tsk->pid = leader->pid;
-		attach_pid(tsk, PIDTYPE_PID,  task_pid(leader));
-		transfer_pid(leader, tsk, PIDTYPE_PGID);
-		transfer_pid(leader, tsk, PIDTYPE_SID);
-		list_replace_rcu(&leader->tasks, &tsk->tasks);
-
-		tsk->group_leader = tsk;
-		leader->group_leader = tsk;
-
-		tsk->exit_signal = SIGCHLD;
-
-		BUG_ON(leader->exit_state != EXIT_ZOMBIE);
-		leader->exit_state = EXIT_DEAD;
-
 		write_unlock_irq(&tasklist_lock);
 	}
-
 	sig->group_exit_task = NULL;
 	sig->notify_count = 0;
 
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 8685263..bc0a125 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -516,9 +516,13 @@ void send_sigio(struct fown_struct *fown, int fd, int band)
 		goto out_unlock_fown;
 	
 	read_lock(&tasklist_lock);
-	do_each_pid_task(pid, type, p) {
-		send_sigio_to_task(p, fown, fd, band);
-	} while_each_pid_task(pid, type, p);
+	if (type == PIDTYPE_PID)
+		send_sigio_to_task(pid_task(pid, type), fown, fd, band);
+	else {
+		do_each_pid_task(pid, type, p) {
+			send_sigio_to_task(p, fown, fd, band);
+		} while_each_pid_task(pid, type, p);
+	}
 	read_unlock(&tasklist_lock);
  out_unlock_fown:
 	read_unlock(&fown->lock);
@@ -547,9 +551,13 @@ int send_sigurg(struct fown_struct *fown)
 	ret = 1;
 	
 	read_lock(&tasklist_lock);
-	do_each_pid_task(pid, type, p) {
-		send_sigurg_to_task(p, fown);
-	} while_each_pid_task(pid, type, p);
+	if (type == PIDTYPE_PID)
+		send_sigurg_to_task(pid_task(pid, type), fown);
+	else {
+		do_each_pid_task(pid, type, p) {
+			send_sigurg_to_task(p, fown);
+		} while_each_pid_task(pid, type, p);
+	}
 	read_unlock(&tasklist_lock);
  out_unlock_fown:
 	read_unlock(&fown->lock);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index d59708e..f7bd620 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2438,15 +2438,15 @@ retry:
 		 * pid of a thread_group_leader.  Testing for task
 		 * being a thread_group_leader is the obvious thing
 		 * todo but there is a window when it fails, due to
-		 * the pid transfer logic in de_thread.
+		 * the pid transfer logic at group leader death.
 		 *
 		 * So we perform the straight forward test of seeing
-		 * if the pid we have found is the pid of a thread
+		 * if the pid we have found is the pid of the thread
 		 * group leader, and don't worry if the task we have
 		 * found doesn't happen to be a thread group leader.
 		 * As we don't care in the case of readdir.
 		 */
-		if (!iter.task || !has_group_leader_pid(iter.task)) {
+		if (!iter.task || pid != task_tgid(iter.task)) {
 			iter.tgid += 1;
 			goto retry;
 		}
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 96be7d6..ddcd7c1 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -67,6 +67,9 @@
 	.posix_timers	 = LIST_HEAD_INIT(sig.posix_timers),		\
 	.cpu_timers	= INIT_CPU_TIMERS(sig.cpu_timers),		\
 	.rlim		= INIT_RLIMITS,					\
+	.tgid		= &init_struct_pid,				\
+	.pids[PIDTYPE_PGID]	= &init_struct_pid,			\
+	.pids[PIDTYPE_SID]	= &init_struct_pid,			\
 }
 
 extern struct nsproxy init_nsproxy;
@@ -91,10 +94,10 @@ extern struct group_info init_groups;
 
 #define INIT_STRUCT_PID {						\
 	.count 		= ATOMIC_INIT(1),				\
+	.tsk		= &init_task,					\
 	.tasks		= {						\
-		{ .first = &init_task.pids[PIDTYPE_PID].node },		\
-		{ .first = &init_task.pids[PIDTYPE_PGID].node },	\
-		{ .first = &init_task.pids[PIDTYPE_SID].node },		\
+		{ .first = &init_task.pids[PIDTYPE_PGID] },		\
+		{ .first = &init_task.pids[PIDTYPE_SID] },		\
 	},								\
 	.rcu		= RCU_HEAD_INIT,				\
 	.level		= 0,						\
@@ -105,13 +108,10 @@ extern struct group_info init_groups;
 	}, }								\
 }
 
-#define INIT_PID_LINK(type) 					\
-{								\
-	.node = {						\
-		.next = NULL,					\
-		.pprev = &init_struct_pid.tasks[type].first,	\
-	},							\
-	.pid = &init_struct_pid,				\
+#define INIT_PID_HLIST_NODE(type) 			\
+{							\
+	.next = NULL,					\
+	.pprev = &init_struct_pid.tasks[type].first,	\
 }
 
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
@@ -179,9 +179,8 @@ extern struct group_info init_groups;
 	.fs_excl	= ATOMIC_INIT(0),				\
 	.pi_lock	= __SPIN_LOCK_UNLOCKED(tsk.pi_lock),		\
 	.pids = {							\
-		[PIDTYPE_PID]  = INIT_PID_LINK(PIDTYPE_PID),		\
-		[PIDTYPE_PGID] = INIT_PID_LINK(PIDTYPE_PGID),		\
-		[PIDTYPE_SID]  = INIT_PID_LINK(PIDTYPE_SID),		\
+		[PIDTYPE_PGID] = INIT_PID_HLIST_NODE(PIDTYPE_PGID),	\
+		[PIDTYPE_SID]  = INIT_PID_HLIST_NODE(PIDTYPE_SID),	\
 	},								\
 	.dirties = INIT_PROP_LOCAL_SINGLE(dirties),			\
 	INIT_TRACE_IRQFLAGS						\
diff --git a/include/linux/pid.h b/include/linux/pid.h
index 061abb6..828355e 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -5,9 +5,10 @@
 
 enum pid_type
 {
-	PIDTYPE_PID,
 	PIDTYPE_PGID,
 	PIDTYPE_SID,
+	PIDTYPE_PID,
+#define PIDTYPE_ARRAY_MAX PIDTYPE_PID
 	PIDTYPE_MAX
 };
 
@@ -58,7 +59,8 @@ struct pid
 {
 	atomic_t count;
 	/* lists of tasks that use this pid */
-	struct hlist_head tasks[PIDTYPE_MAX];
+	struct task_struct *tsk;
+	struct hlist_head tasks[PIDTYPE_ARRAY_MAX];
 	struct rcu_head rcu;
 	int level;
 	struct upid numbers[1];
@@ -66,12 +68,6 @@ struct pid
 
 extern struct pid init_struct_pid;
 
-struct pid_link
-{
-	struct hlist_node node;
-	struct pid *pid;
-};
-
 static inline struct pid *get_pid(struct pid *pid)
 {
 	if (pid)
@@ -158,7 +154,7 @@ static inline pid_t pid_vnr(struct pid *pid)
 		struct hlist_node *pos___;				\
 		if (pid != NULL)					\
 			hlist_for_each_entry_rcu((task), pos___,	\
-				&pid->tasks[type], pids[type].node) {
+				&pid->tasks[type], pids[type]) {
 
 #define while_each_pid_task(pid, type, task)				\
 			}						\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1b1e25b..496dfda 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -453,7 +453,6 @@ struct signal_struct {
 
 	/* ITIMER_REAL timer for the process */
 	struct hrtimer real_timer;
-	struct task_struct *tsk;
 	ktime_t it_real_incr;
 
 	/* ITIMER_PROF and ITIMER_VIRTUAL timers for the process */
@@ -461,6 +460,8 @@ struct signal_struct {
 	cputime_t it_prof_incr, it_virt_incr;
 
 	/* job control IDs */
+	struct pid *tgid;
+	struct pid *pids[PIDTYPE_ARRAY_MAX];
 
 	/*
 	 * pgrp and session fields are deprecated.
@@ -1034,8 +1035,9 @@ struct task_struct {
 	struct list_head sibling;	/* linkage in my parent's children list */
 	struct task_struct *group_leader;	/* threadgroup leader */
 
+	struct pid *tid;
 	/* PID/PID hash table linkage. */
-	struct pid_link pids[PIDTYPE_MAX];
+	struct hlist_node pids[PIDTYPE_ARRAY_MAX];
 	struct list_head thread_group;
 
 	struct completion *vfork_done;		/* for vfork() */
@@ -1261,22 +1263,34 @@ static inline void set_task_pgrp(struct task_struct *tsk, pid_t pgrp)
 
 static inline struct pid *task_pid(struct task_struct *task)
 {
-	return task->pids[PIDTYPE_PID].pid;
+	return task->tid;
 }
 
 static inline struct pid *task_tgid(struct task_struct *task)
 {
-	return task->group_leader->pids[PIDTYPE_PID].pid;
+	struct signal_struct *sig = rcu_dereference(task->signal);
+	struct pid *pid = NULL;
+	if (sig)
+		pid = sig->tgid;
+	return pid;
 }
 
 static inline struct pid *task_pgrp(struct task_struct *task)
 {
-	return task->group_leader->pids[PIDTYPE_PGID].pid;
+	struct signal_struct *sig = rcu_dereference(task->signal);
+	struct pid *pid = NULL;
+	if (sig)
+		pid = sig->pids[PIDTYPE_PGID];
+	return pid;
 }
 
 static inline struct pid *task_session(struct task_struct *task)
 {
-	return task->group_leader->pids[PIDTYPE_SID].pid;
+	struct signal_struct *sig = rcu_dereference(task->signal);
+	struct pid *pid = NULL;
+	if (sig)
+		pid = sig->pids[PIDTYPE_SID];
+	return pid;
 }
 
 struct pid_namespace;
@@ -1371,7 +1385,7 @@ static inline pid_t task_ppid_nr_ns(struct task_struct *tsk,
  */
 static inline int pid_alive(struct task_struct *p)
 {
-	return p->pids[PIDTYPE_PID].pid != NULL;
+	return p->signal != NULL;
 }
 
 /**
@@ -1652,7 +1666,6 @@ extern void block_all_signals(int (*notifier)(void *priv), void *priv,
 extern void unblock_all_signals(void);
 extern void release_task(struct task_struct * p);
 extern int send_sig_info(int, struct siginfo *, struct task_struct *);
-extern int send_group_sig_info(int, struct siginfo *, struct task_struct *);
 extern int force_sigsegv(int, struct task_struct *);
 extern int force_sig_info(int, struct siginfo *, struct task_struct *);
 extern int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp);
@@ -1772,17 +1785,6 @@ extern void wait_task_inactive(struct task_struct * p);
 /* de_thread depends on thread_group_leader not being a pid based check */
 #define thread_group_leader(p)	(p == p->group_leader)
 
-/* Do to the insanities of de_thread it is possible for a process
- * to have the pid of the thread group leader without actually being
- * the thread group leader.  For iteration through the pids in proc
- * all we care about is that we have a task with the appropriate
- * pid, we don't actually care if we have the right task.
- */
-static inline int has_group_leader_pid(struct task_struct *p)
-{
-	return p->pid == p->tgid;
-}
-
 static inline
 int same_thread_group(struct task_struct *p1, struct task_struct *p2)
 {
@@ -1800,9 +1802,6 @@ static inline int thread_group_empty(struct task_struct *p)
 	return list_empty(&p->thread_group);
 }
 
-#define delay_group_leader(p) \
-		(thread_group_leader(p) && !thread_group_empty(p))
-
 /*
  * Protects ->fs, ->files, ->mm, ->group_info, ->comm, keyring
  * subscriptions and synchronises with wait4().  Also used in procfs.  Also
diff --git a/kernel/exit.c b/kernel/exit.c
index 1ab19f0..94552e0 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -57,7 +57,6 @@ static void exit_mm(struct task_struct * tsk);
 static void __unhash_process(struct task_struct *p)
 {
 	nr_threads--;
-	detach_pid(p, PIDTYPE_PID);
 	if (thread_group_leader(p)) {
 		detach_pid(p, PIDTYPE_PGID);
 		detach_pid(p, PIDTYPE_SID);
@@ -65,6 +64,7 @@ static void __unhash_process(struct task_struct *p)
 		list_del_rcu(&p->tasks);
 		__get_cpu_var(process_counts)--;
 	}
+	detach_pid(p, PIDTYPE_PID);
 	list_del_rcu(&p->thread_group);
 	remove_parent(p);
 }
@@ -144,44 +144,15 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
 
 void release_task(struct task_struct * p)
 {
-	struct task_struct *leader;
-	int zap_leader;
-repeat:
 	atomic_dec(&p->user->processes);
 	proc_flush_task(p);
 	write_lock_irq(&tasklist_lock);
 	ptrace_unlink(p);
 	BUG_ON(!list_empty(&p->ptrace_list) || !list_empty(&p->ptrace_children));
 	__exit_signal(p);
-
-	/*
-	 * If we are the last non-leader member of the thread
-	 * group, and the leader is zombie, then notify the
-	 * group leader's parent process. (if it wants notification.)
-	 */
-	zap_leader = 0;
-	leader = p->group_leader;
-	if (leader != p && thread_group_empty(leader) && leader->exit_state == EXIT_ZOMBIE) {
-		BUG_ON(leader->exit_signal == -1);
-		do_notify_parent(leader, leader->exit_signal);
-		/*
-		 * If we were the last child thread and the leader has
-		 * exited already, and the leader's parent ignores SIGCHLD,
-		 * then we are the one who should release the leader.
-		 *
-		 * do_notify_parent() will have marked it self-reaping in
-		 * that case.
-		 */
-		zap_leader = (leader->exit_signal == -1);
-	}
-
 	write_unlock_irq(&tasklist_lock);
 	release_thread(p);
 	call_rcu(&p->rcu, delayed_put_task_struct);
-
-	p = leader;
-	if (unlikely(zap_leader))
-		goto repeat;
 }
 
 /*
@@ -633,8 +604,7 @@ reparent_thread(struct task_struct *p, struct task_struct *father, int traced)
 	/* If we'd notified the old parent about this child's death,
 	 * also notify the new parent.
 	 */
-	if (!traced && p->exit_state == EXIT_ZOMBIE &&
-	    p->exit_signal != -1 && thread_group_empty(p))
+	if (!traced && p->exit_state == EXIT_ZOMBIE && p->exit_signal != -1)
 		do_notify_parent(p, p->exit_signal);
 
 	/*
@@ -702,8 +672,7 @@ static void forget_original_parent(struct task_struct *father)
 		} else {
 			/* reparent ptraced task to its real parent */
 			__ptrace_unlink (p);
-			if (p->exit_state == EXIT_ZOMBIE && p->exit_signal != -1 &&
-			    thread_group_empty(p))
+			if (p->exit_state == EXIT_ZOMBIE && p->exit_signal != -1)
 				do_notify_parent(p, p->exit_signal);
 		}
 
@@ -773,6 +742,11 @@ static void exit_notify(struct task_struct *tsk)
 	exit_task_namespaces(tsk);
 
 	write_lock_irq(&tasklist_lock);
+	/* If we haven't yet made gettid() == getpid() do so now */
+	if (thread_group_leader(tsk) && (tsk->tid != tsk->signal->tgid)) {
+		detach_pid(tsk, PIDTYPE_PID);
+		attach_pid(tsk, PIDTYPE_PID, tsk->signal->tgid);
+	}
 	/*
 	 * Check to see if any process groups have become orphaned
 	 * as a result of our exiting, and if they have any stopped
@@ -818,7 +792,7 @@ static void exit_notify(struct task_struct *tsk)
 	 * send it a SIGCHLD instead of honoring exit_signal.  exit_signal
 	 * only has special meaning to our real parent.
 	 */
-	if (tsk->exit_signal != -1 && thread_group_empty(tsk)) {
+	if (tsk->exit_signal != -1) {
 		int signal = tsk->parent == tsk->real_parent ? tsk->exit_signal : SIGCHLD;
 		do_notify_parent(tsk, signal);
 	} else if (tsk->ptrace) {
@@ -946,6 +920,48 @@ fastcall NORET_TYPE void do_exit(long code)
 	}
 
 	tsk->flags |= PF_EXITING;
+	/* Transfer thread group leadership */
+	if (thread_group_leader(tsk) && !thread_group_empty(tsk)) {
+		struct task_struct *new_leader, *t;
+		write_lock_irq(&tasklist_lock);
+		for (t = next_thread(tsk); t != tsk; t = next_thread(t)) {
+			if (!(t->flags & PF_EXITING))
+				break;
+		}
+		if (t != tsk) {
+			new_leader = t;
+		
+			new_leader->start_time = tsk->start_time;
+			task_pid(tsk)->tsk = new_leader;
+			transfer_pid(tsk, new_leader, PIDTYPE_PGID);
+			transfer_pid(tsk, new_leader, PIDTYPE_SID);
+			list_replace_rcu(&tsk->tasks, &new_leader->tasks);
+
+			/* Update group_leader on all of the threads... */
+			new_leader->group_leader = new_leader;
+			tsk->group_leader = new_leader;
+			for (t = next_thread(tsk); t != tsk; t= next_thread(t)) {
+				t->group_leader = new_leader;
+			}
+
+			new_leader->exit_signal = tsk->exit_signal;
+			tsk->exit_signal = -1;
+
+			write_unlock_irq(&tasklist_lock);
+		} else {
+			write_unlock_irq(&tasklist_lock);
+			/* Wait for the other threads to exit before continuing */
+			for (;;) {
+				read_lock(&tasklist_lock);
+				if (thread_group_empty(tsk))
+					break;
+				__set_current_state(TASK_UNINTERRUPTIBLE);
+				read_unlock(&tasklist_lock);
+				schedule();
+			}
+			read_unlock(&tasklist_lock);
+		}
+	}
 	/*
 	 * tsk->flags are checked in the futex code to protect against
 	 * an exiting task cleaning up the robust pi futexes.
@@ -1106,20 +1122,18 @@ asmlinkage void sys_exit_group(int error_code)
 	do_group_exit((error_code & 0xff) << 8);
 }
 
-static int eligible_child(pid_t pid, int options, struct task_struct *p)
+static int eligible_child(enum pid_type type, struct pid *pid, int options, struct task_struct *p)
 {
 	int err;
-	struct pid_namespace *ns;
 
-	ns = current->nsproxy->pid_ns;
-	if (pid > 0) {
-		if (task_pid_nr_ns(p, ns) != pid)
+	if (type == PIDTYPE_PID) {
+		/* Match all pids pointing at task p */
+		if (pid_task(pid, PIDTYPE_PID) != p)
 			return 0;
-	} else if (!pid) {
-		if (task_pgrp_nr_ns(p, ns) != task_pgrp_vnr(current))
-			return 0;
-	} else if (pid != -1) {
-		if (task_pgrp_nr_ns(p, ns) != -pid)
+	} else if (type < PIDTYPE_MAX) {
+		struct signal_struct *sig;
+		sig = rcu_dereference(p->signal);
+		if (sig && (sig->pids[type] != pid))
 			return 0;
 	}
 
@@ -1346,7 +1360,8 @@ static int wait_task_stopped(struct task_struct *p,
 {
 	int retval, exit_code, why;
 	uid_t uid = 0; /* unneeded, required by compiler */
-	pid_t pid;
+	struct pid *pid;
+	pid_t upid;
 
 	exit_code = 0;
 	spin_lock_irq(&p->sighand->siglock);
@@ -1382,12 +1397,16 @@ unlock_sig:
 	 * possibly take page faults for user memory.
 	 */
 	get_task_struct(p);
-	pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
+	if (p->ptrace && same_thread_group(current, p->parent))
+		pid = task_pid(p);
+	else
+		pid = task_tgid(p);
+	upid = pid_nr_ns(pid, current->nsproxy->pid_ns);
 	why = (p->ptrace & PT_PTRACED) ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
 
 	if (unlikely(noreap))
-		return wait_noreap_copyout(p, pid, uid,
+		return wait_noreap_copyout(p, upid, uid,
 					   why, exit_code,
 					   infop, ru);
 
@@ -1403,11 +1422,11 @@ unlock_sig:
 	if (!retval && infop)
 		retval = put_user(exit_code, &infop->si_status);
 	if (!retval && infop)
-		retval = put_user(pid, &infop->si_pid);
+		retval = put_user(upid, &infop->si_pid);
 	if (!retval && infop)
 		retval = put_user(uid, &infop->si_uid);
 	if (!retval)
-		retval = pid;
+		retval = upid;
 	put_task_struct(p);
 
 	BUG_ON(!retval);
@@ -1425,7 +1444,8 @@ static int wait_task_continued(struct task_struct *p, int noreap,
 			       int __user *stat_addr, struct rusage __user *ru)
 {
 	int retval;
-	pid_t pid;
+	struct pid *pid;
+	pid_t upid;
 	uid_t uid;
 
 	if (!(p->signal->flags & SIGNAL_STOP_CONTINUED))
@@ -1440,8 +1460,11 @@ static int wait_task_continued(struct task_struct *p, int noreap,
 	if (!noreap)
 		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
 	spin_unlock_irq(&p->sighand->siglock);
-
-	pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
+	if (p->ptrace && same_thread_group(current, p->parent))
+		pid = task_pid(p);
+	else
+		pid = task_tgid(p);
+	upid = pid_nr_ns(pid, current->nsproxy->pid_ns);
 	uid = p->uid;
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
@@ -1452,9 +1475,9 @@ static int wait_task_continued(struct task_struct *p, int noreap,
 		if (!retval && stat_addr)
 			retval = put_user(0xffff, stat_addr);
 		if (!retval)
-			retval = pid;
+			retval = upid;
 	} else {
-		retval = wait_noreap_copyout(p, pid, uid,
+		retval = wait_noreap_copyout(p, upid, uid,
 					     CLD_CONTINUED, SIGCONT,
 					     infop, ru);
 		BUG_ON(retval == 0);
@@ -1463,13 +1486,25 @@ static int wait_task_continued(struct task_struct *p, int noreap,
 	return retval;
 }
 
-static long do_wait(pid_t pid, int options, struct siginfo __user *infop,
+static long do_wait(pid_t upid, int options, struct siginfo __user *infop,
 		    int __user *stat_addr, struct rusage __user *ru)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	struct task_struct *tsk;
 	int flag, retval;
-
+	struct pid *pid = NULL;
+	enum pid_type type = PIDTYPE_MAX;
+
+	if (upid > 0) {
+		type = PIDTYPE_PID;
+		pid = find_get_pid(upid);
+	} else if (upid == 0) {
+		type = PIDTYPE_PGID;
+		pid = get_pid(task_pgrp(current));
+	} else if (upid < -1) {
+		type = PIDTYPE_PGID;
+		pid = find_get_pid(-upid);
+	}
 	add_wait_queue(&current->signal->wait_chldexit,&wait);
 repeat:
 	/*
@@ -1484,7 +1519,7 @@ repeat:
 		struct task_struct *p;
 
 		list_for_each_entry(p, &tsk->children, sibling) {
-			int ret = eligible_child(pid, options, p);
+			int ret = eligible_child(type, pid, options, p);
 			if (!ret)
 				continue;
 
@@ -1503,8 +1538,7 @@ repeat:
 				retval = wait_task_stopped(p,
 						(options & WNOWAIT), infop,
 						stat_addr, ru);
-			} else if (p->exit_state == EXIT_ZOMBIE &&
-					!delay_group_leader(p)) {
+			} else if (p->exit_state == EXIT_ZOMBIE) {
 				/*
 				 * We don't reap group leaders with subthreads.
 				 */
@@ -1531,7 +1565,7 @@ repeat:
 		if (!flag) {
 			list_for_each_entry(p, &tsk->ptrace_children,
 								ptrace_list) {
-				flag = eligible_child(pid, options, p);
+				flag = eligible_child(type, pid, options, p);
 				if (!flag)
 					continue;
 				if (likely(flag > 0))
@@ -1560,6 +1594,7 @@ repeat:
 end:
 	current->state = TASK_RUNNING;
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);
+	put_pid(pid);
 	if (infop) {
 		if (retval > 0)
 			retval = 0;
diff --git a/kernel/fork.c b/kernel/fork.c
index 7abb592..e986be9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -883,7 +883,6 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	hrtimer_init(&sig->real_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	sig->it_real_incr.tv64 = 0;
 	sig->real_timer.function = it_real_fn;
-	sig->tsk = tsk;
 
 	sig->it_virt_expires = cputime_zero;
 	sig->it_virt_incr = cputime_zero;
@@ -1308,6 +1307,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 			if (clone_flags & CLONE_NEWPID)
 				p->nsproxy->pid_ns->child_reaper = p;
 
+			p->signal->tgid = pid;
 			p->signal->tty = current->signal->tty;
 			set_task_pgrp(p, task_pgrp_nr(current));
 			set_task_session(p, task_session_nr(current));
diff --git a/kernel/itimer.c b/kernel/itimer.c
index 2fab344..f40b589 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -132,7 +132,7 @@ enum hrtimer_restart it_real_fn(struct hrtimer *timer)
 	struct signal_struct *sig =
 		container_of(timer, struct signal_struct, real_timer);
 
-	send_group_sig_info(SIGALRM, SEND_SIG_PRIV, sig->tsk);
+	kill_pid_info(SIGALRM, SEND_SIG_PRIV, sig->tgid);
 
 	return HRTIMER_NORESTART;
 }
diff --git a/kernel/pid.c b/kernel/pid.c
index 21f027c..b45b53d 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -319,28 +319,39 @@ EXPORT_SYMBOL_GPL(find_pid);
 int fastcall attach_pid(struct task_struct *task, enum pid_type type,
 		struct pid *pid)
 {
-	struct pid_link *link;
-
-	link = &task->pids[type];
-	link->pid = pid;
-	hlist_add_head_rcu(&link->node, &pid->tasks[type]);
+	if (type == PIDTYPE_PID) {
+		task->tid = pid;
+		pid->tsk = task;
+	}
+	else {
+		task->signal->pids[type] = pid;
+		hlist_add_head_rcu(&task->pids[type], &pid->tasks[type]);
+	}
 
 	return 0;
 }
 
 void fastcall detach_pid(struct task_struct *task, enum pid_type type)
 {
-	struct pid_link *link;
-	struct pid *pid;
+	struct pid **ppid, *pid;
 	int tmp;
 
-	link = &task->pids[type];
-	pid = link->pid;
-
-	hlist_del_rcu(&link->node);
-	link->pid = NULL;
+	if (type == PIDTYPE_PID) {
+		ppid = &task->tid;
+		pid = *ppid;
+		if (pid->tsk == task)
+			pid->tsk = NULL;
+	}
+	else {
+		hlist_del_rcu(&task->pids[type]);
+		ppid = &task->signal->pids[type];
+	}
+	pid = *ppid;
+	*ppid = NULL;
 
-	for (tmp = PIDTYPE_MAX; --tmp >= 0; )
+	if (pid->tsk)
+		return;
+	for (tmp = PIDTYPE_MAX -1; --tmp >= 0; )
 		if (!hlist_empty(&pid->tasks[tmp]))
 			return;
 
@@ -351,19 +362,22 @@ void fastcall detach_pid(struct task_struct *task, enum pid_type type)
 void fastcall transfer_pid(struct task_struct *old, struct task_struct *new,
 			   enum pid_type type)
 {
-	new->pids[type].pid = old->pids[type].pid;
-	hlist_replace_rcu(&old->pids[type].node, &new->pids[type].node);
-	old->pids[type].pid = NULL;
+	hlist_replace_rcu(&old->pids[type], &new->pids[type]);
 }
 
 struct task_struct * fastcall pid_task(struct pid *pid, enum pid_type type)
 {
 	struct task_struct *result = NULL;
 	if (pid) {
-		struct hlist_node *first;
-		first = rcu_dereference(pid->tasks[type].first);
-		if (first)
-			result = hlist_entry(first, struct task_struct, pids[(type)].node);
+		if (type == PIDTYPE_PID)
+			result = rcu_dereference(pid->tsk);
+		else {
+			struct hlist_node *first;
+			first = rcu_dereference(pid->tasks[type].first);
+			if (first)
+				result = hlist_entry(first, struct task_struct,
+						     pids[(type)]);
+		}
 	}
 	return result;
 }
@@ -402,7 +416,11 @@ struct pid *get_task_pid(struct task_struct *task, enum pid_type type)
 {
 	struct pid *pid;
 	rcu_read_lock();
-	pid = get_pid(task->pids[type].pid);
+	if (type == PIDTYPE_PID)
+		pid = task->tid;
+	else
+		pid = task->signal->pids[type];
+	get_pid(pid);
 	rcu_read_unlock();
 	return pid;
 }
diff --git a/kernel/signal.c b/kernel/signal.c
index 06e663d..af8c49f 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1195,20 +1195,6 @@ send_sig(int sig, struct task_struct *p, int priv)
 	return send_sig_info(sig, __si_special(priv), p);
 }
 
-/*
- * This is the entry point for "process-wide" signals.
- * They will go to an appropriate thread in the thread group.
- */
-int
-send_group_sig_info(int sig, struct siginfo *info, struct task_struct *p)
-{
-	int ret;
-	read_lock(&tasklist_lock);
-	ret = group_send_sig_info(sig, info, p);
-	read_unlock(&tasklist_lock);
-	return ret;
-}
-
 void
 force_sig(int sig, struct task_struct *p)
 {
@@ -1501,12 +1487,15 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 	unsigned long flags;
 	struct task_struct *parent;
 	struct sighand_struct *sighand;
+	struct pid *pid;
 
-	if (tsk->ptrace & PT_PTRACED)
+	if (tsk->ptrace & PT_PTRACED) {
 		parent = tsk->parent;
-	else {
+		pid = task_pid(tsk);
+	} else {
 		tsk = tsk->group_leader;
 		parent = tsk->real_parent;
+		pid = task_tgid(tsk);
 	}
 
 	info.si_signo = SIGCHLD;
@@ -1515,7 +1504,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 	 * see comment in do_notify_parent() abot the following 3 lines
 	 */
 	rcu_read_lock();
-	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
+	info.si_pid = pid_nr_ns(pid, parent->nsproxy->pid_ns);
 	rcu_read_unlock();
 
 	info.si_uid = tsk->uid;
-- 
1.5.3.rc6.17.g1911

