Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbXLJSgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbXLJSgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 13:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbXLJSgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 13:36:41 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:45985 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbXLJSgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 13:36:40 -0500
Date: Mon, 10 Dec 2007 21:37:22 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] will_become_orphaned_pgrp: we have threads
Message-ID: <20071210183722.GA592@tv-sign.ru>
References: <20071208183800.GA9940@tv-sign.ru> <m11w9wpx03.fsf@ebiederm.dsl.xmission.com> <20071209142116.GB131@tv-sign.ru> <m14perooqx.fsf@ebiederm.dsl.xmission.com> <20071209164311.GA416@tv-sign.ru> <m1zlwj2zj2.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zlwj2zj2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09, Eric W. Biederman wrote:
>
> Oleg below is my proof of concept patch, which really needs to be
> broken up into a whole patch series, so the changes are small
> enough we can do a thorough audit on them.  Anyway take a look
> and see what you think.

Amazing ;)

This patch certainly needs a time for understanding, so far I have
read only the small subset, a couple of random questions.

> --- a/include/linux/pid.h
> +++ b/include/linux/pid.h
> @@ -5,9 +5,10 @@
>
>  enum pid_type
>  {
> -	PIDTYPE_PID,
>  	PIDTYPE_PGID,
>  	PIDTYPE_SID,
> +	PIDTYPE_PID,
> +#define PIDTYPE_ARRAY_MAX PIDTYPE_PID
>  	PIDTYPE_MAX
>  };
>
> @@ -58,7 +59,8 @@ struct pid
>  {
>  	atomic_t count;
>  	/* lists of tasks that use this pid */
> -	struct hlist_head tasks[PIDTYPE_MAX];
> +	struct task_struct *tsk;
> +	struct hlist_head tasks[PIDTYPE_ARRAY_MAX];
>  	struct rcu_head rcu;
>  	int level;
>  	struct upid numbers[1];
>
> [...snip...]
>
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -453,7 +453,6 @@ struct signal_struct {
>
>  	/* ITIMER_REAL timer for the process */
>  	struct hrtimer real_timer;
> -	struct task_struct *tsk;
>  	ktime_t it_real_incr;
>
>  	/* ITIMER_PROF and ITIMER_VIRTUAL timers for the process */
> @@ -461,6 +460,8 @@ struct signal_struct {
>  	cputime_t it_prof_incr, it_virt_incr;
>
>  	/* job control IDs */
> +	struct pid *tgid;
> +	struct pid *pids[PIDTYPE_ARRAY_MAX];
>
>  	/*
>  	 * pgrp and session fields are deprecated.
> @@ -1034,8 +1035,9 @@ struct task_struct {
>  	struct list_head sibling;	/* linkage in my parent's children list */
>  	struct task_struct *group_leader;	/* threadgroup leader */
>
> +	struct pid *tid;
>  	/* PID/PID hash table linkage. */
> -	struct pid_link pids[PIDTYPE_MAX];
> +	struct hlist_node pids[PIDTYPE_ARRAY_MAX];

OK. It certainly makes sense to move PIDTYPE_PGID/SID pids from task_struct
to signal struct.

But can't we go a bit further? With this patch pid->tasks[].first still "points"
to leader's task_struct. Suppose we replace pid->tasks[] with pid->signals[],
so that pid->signals[].first points to signal_struct. Then we can find the task
(group_leader) via signal->tgid.

This means we can remove task_struct->pids, and kill transfer_pid().

>  static inline struct pid *task_tgid(struct task_struct *task)
>  {
> -	return task->group_leader->pids[PIDTYPE_PID].pid;
> +	struct signal_struct *sig = rcu_dereference(task->signal);
> +	struct pid *pid = NULL;
> +	if (sig)
> +		pid = sig->tgid;
> +	return pid;
>  }

Hmm. This is fixable, but note that task->signal is not RCU protected,
only ->sighand.

>  static inline int pid_alive(struct task_struct *p)
>  {
> -	return p->pids[PIDTYPE_PID].pid != NULL;
> +	return p->signal != NULL;
>  }

(this change btw is imho good regardless, because pid_alive() currently
 means "the task is not unhashed yet" anyway).

>  static void __unhash_process(struct task_struct *p)
>  {
>  	nr_threads--;
> -	detach_pid(p, PIDTYPE_PID);
>  	if (thread_group_leader(p)) {
>  		detach_pid(p, PIDTYPE_PGID);
>  		detach_pid(p, PIDTYPE_SID);
> @@ -65,6 +64,7 @@ static void __unhash_process(struct task_struct *p)
>  		list_del_rcu(&p->tasks);
>  		__get_cpu_var(process_counts)--;
>  	}
> +	detach_pid(p, PIDTYPE_PID);

Not sure why this change is needed... To prevent the premature
detach_pid()->free_pid() ? But this doesn't looks possible, if
the task is leader, p->tid->tsk == p, and detach_pid() does

	if (pid->tsk)	// still used, don't free.
		return;

> @@ -946,6 +920,48 @@ fastcall NORET_TYPE void do_exit(long code)
>  	}
>
>  	tsk->flags |= PF_EXITING;
> +	/* Transfer thread group leadership */
> +	if (thread_group_leader(tsk) && !thread_group_empty(tsk)) {

Ah, this is racy without tasklist_lock. Suppose that the current
->group_leader exits right now and elects us as a new leader.

> +		struct task_struct *new_leader, *t;
> +		write_lock_irq(&tasklist_lock);
> +		for (t = next_thread(tsk); t != tsk; t = next_thread(t)) {
> +			if (!(t->flags & PF_EXITING))
> +				break;
> +		}
> +		if (t != tsk) {
> +			new_leader = t;
> +
> +			new_leader->start_time = tsk->start_time;
> +			task_pid(tsk)->tsk = new_leader;

So this pid won't be freed when current does detach_pid(PIDTYPE_PID), from
now current->tid->tsk != current, so detach_pid() doesn't clear pid->tsk.

But when it will be freed then?

> +			transfer_pid(tsk, new_leader, PIDTYPE_PGID);
> +			transfer_pid(tsk, new_leader, PIDTYPE_SID);
> +			list_replace_rcu(&tsk->tasks, &new_leader->tasks);
> +
> +			/* Update group_leader on all of the threads... */
> +			new_leader->group_leader = new_leader;
> +			tsk->group_leader = new_leader;

This is one of the most questionable changes. Now current can't "trust" its
->group_leader without tasklist.

As a random example, let's look at sys_setpgid(). When we take tasklist_lock
group_leader can point to the already freed/reused memory.

> +		} else {
> +			write_unlock_irq(&tasklist_lock);
> +			/* Wait for the other threads to exit before continuing */
> +			for (;;) {
> +				read_lock(&tasklist_lock);
> +				if (thread_group_empty(tsk))
> +					break;
> +				__set_current_state(TASK_UNINTERRUPTIBLE);
> +				read_unlock(&tasklist_lock);
> +				schedule();
> +			}

I don't get this... Who will wake us?

Hmm, deadlock with coredump? The coredumping thread may be waiting for us,
but we didn't do exit_mm() yet.

> @@ -1440,8 +1460,11 @@ static int wait_task_continued(struct task_struct *p, int noreap,
>  	if (!noreap)
>  		p->signal->flags &= ~SIGNAL_STOP_CONTINUED;
>  	spin_unlock_irq(&p->sighand->siglock);
> -
> -	pid = task_pid_nr_ns(p, current->nsproxy->pid_ns);
> +	if (p->ptrace && same_thread_group(current, p->parent))
> +		pid = task_pid(p);
> +	else
> +		pid = task_tgid(p);

Why do we need "&& same_thread_group()" above? Ptracer needs per-thread
pid in any case.

> @@ -1501,12 +1487,15 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
>  	unsigned long flags;
>  	struct task_struct *parent;
>  	struct sighand_struct *sighand;
> +	struct pid *pid;
>
> -	if (tsk->ptrace & PT_PTRACED)
> +	if (tsk->ptrace & PT_PTRACED) {
>  		parent = tsk->parent;
> -	else {
> +		pid = task_pid(tsk);
> +	} else {
>  		tsk = tsk->group_leader;
>  		parent = tsk->real_parent;
> +		pid = task_tgid(tsk);

Hmm, yes... With this patch task_pid(p->leader) != task_tgid(p).

Will continue tomorrow.

Oleg.

