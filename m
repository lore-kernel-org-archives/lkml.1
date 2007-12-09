Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbXLIK3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbXLIK3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 05:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbXLIK3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 05:29:44 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46117 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbXLIK3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 05:29:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ITIMER_REAL: convert to use struct pid
References: <20071207170336.GA13835@tv-sign.ru>
Date: Sun, 09 Dec 2007 03:27:36 -0700
In-Reply-To: <20071207170336.GA13835@tv-sign.ru> (Oleg Nesterov's message of
	"Fri, 7 Dec 2007 20:03:36 +0300")
Message-ID: <m1lk84nox3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> signal_struct->tsk points to the ->group_leader and thus we have the nasty code
> in de_thread() which has to change it and restart ->real_timer if the leader is
> changed.
>
> Use "struct pid *leader_pid" instead. This also allows us to kill now unneeded
> send_group_sig_info().

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Looks sane to me.

> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
>
>  include/linux/sched.h |    3 +--
>  kernel/fork.c         |    2 +-
>  kernel/itimer.c       |    2 +-
>  fs/exec.c             |   22 ++--------------------
>  kernel/signal.c       |   14 --------------
>  5 files changed, 5 insertions(+), 38 deletions(-)
>
> --- PT/include/linux/sched.h~3_itimer_tsk_pid 2007-12-02 14:53:29.000000000
> +0300
> +++ PT/include/linux/sched.h	2007-12-07 19:24:44.000000000 +0300
> @@ -444,7 +444,7 @@ struct signal_struct {
>  
>  	/* ITIMER_REAL timer for the process */
>  	struct hrtimer real_timer;
> -	struct task_struct *tsk;
> +	struct pid *leader_pid;
>  	ktime_t it_real_incr;
>  
>  	/* ITIMER_PROF and ITIMER_VIRTUAL timers for the process */
> @@ -1630,7 +1630,6 @@ extern void block_all_signals(int (*noti
>  extern void unblock_all_signals(void);
>  extern void release_task(struct task_struct * p);
>  extern int send_sig_info(int, struct siginfo *, struct task_struct *);
> -extern int send_group_sig_info(int, struct siginfo *, struct task_struct *);
>  extern int force_sigsegv(int, struct task_struct *);
>  extern int force_sig_info(int, struct siginfo *, struct task_struct *);
>  extern int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp);
> --- PT/kernel/fork.c~3_itimer_tsk_pid	2007-12-07 19:03:34.000000000 +0300
> +++ PT/kernel/fork.c	2007-12-07 19:08:57.000000000 +0300
> @@ -882,7 +882,6 @@ static int copy_signal(unsigned long clo
>  	hrtimer_init(&sig->real_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>  	sig->it_real_incr.tv64 = 0;
>  	sig->real_timer.function = it_real_fn;
> -	sig->tsk = tsk;
>  
>  	sig->it_virt_expires = cputime_zero;
>  	sig->it_virt_incr = cputime_zero;
> @@ -1300,6 +1299,7 @@ static struct task_struct *copy_process(
>  			if (clone_flags & CLONE_NEWPID)
>  				p->nsproxy->pid_ns->child_reaper = p;
>  
> +			p->signal->leader_pid = pid;
>  			p->signal->tty = current->signal->tty;
>  			set_task_pgrp(p, task_pgrp_nr(current));
>  			set_task_session(p, task_session_nr(current));
> --- PT/kernel/itimer.c~3_itimer_tsk_pid	2007-10-25 16:22:12.000000000 +0400
> +++ PT/kernel/itimer.c	2007-12-07 19:15:27.000000000 +0300
> @@ -132,7 +132,7 @@ enum hrtimer_restart it_real_fn(struct h
>  	struct signal_struct *sig =
>  		container_of(timer, struct signal_struct, real_timer);
>  
> -	send_group_sig_info(SIGALRM, SEND_SIG_PRIV, sig->tsk);
> +	kill_pid_info(SIGALRM, SEND_SIG_PRIV, sig->leader_pid);
>  
>  	return HRTIMER_NORESTART;
>  }
> --- PT/fs/exec.c~3_itimer_tsk_pid	2007-12-02 16:07:22.000000000 +0300
> +++ PT/fs/exec.c	2007-12-07 19:18:48.000000000 +0300
> @@ -781,26 +781,8 @@ static int de_thread(struct task_struct 
>  	zap_other_threads(tsk);
>  	read_unlock(&tasklist_lock);
>  
> -	/*
> -	 * Account for the thread group leader hanging around:
> -	 */
> -	count = 1;
> -	if (!thread_group_leader(tsk)) {
> -		count = 2;
> -		/*
> -		 * The SIGALRM timer survives the exec, but needs to point
> -		 * at us as the new group leader now.  We have a race with
> -		 * a timer firing now getting the old leader, so we need to
> -		 * synchronize with any firing (by calling del_timer_sync)
> -		 * before we can safely let the old group leader die.
> -		 */
> -		sig->tsk = tsk;
> -		spin_unlock_irq(lock);
> -		if (hrtimer_cancel(&sig->real_timer))
> -			hrtimer_restart(&sig->real_timer);
> -		spin_lock_irq(lock);
> -	}
> -
> +	/* Account for the thread group leader hanging around: */
> +	count = thread_group_leader(tsk) ? 1 : 2;
>  	sig->notify_count = count;
>  	while (atomic_read(&sig->count) > count) {
>  		__set_current_state(TASK_UNINTERRUPTIBLE);
> --- PT/kernel/signal.c~3_itimer_tsk_pid	2007-12-07 17:20:27.000000000 +0300
> +++ PT/kernel/signal.c	2007-12-07 19:23:40.000000000 +0300
> @@ -1204,20 +1204,6 @@ send_sig(int sig, struct task_struct *p,
>  	return send_sig_info(sig, __si_special(priv), p);
>  }
>  
> -/*
> - * This is the entry point for "process-wide" signals.
> - * They will go to an appropriate thread in the thread group.
> - */
> -int
> -send_group_sig_info(int sig, struct siginfo *info, struct task_struct *p)
> -{
> -	int ret;
> -	read_lock(&tasklist_lock);
> -	ret = group_send_sig_info(sig, info, p);
> -	read_unlock(&tasklist_lock);
> -	return ret;
> -}
> -
>  void
>  force_sig(int sig, struct task_struct *p)
>  {
