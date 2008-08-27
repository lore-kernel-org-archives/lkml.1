Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbYH0CYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbYH0CYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 22:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYH0CYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 22:24:07 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55223 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbYH0CYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 22:24:04 -0400
Date: Tue, 26 Aug 2008 21:24:03 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Robert Rex <robert.rex@exasol.com>,
       Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] pid_ns: (BUG 11391) change ->child_reaper when
	init->group_leader exits
Message-ID: <20080827022403.GA2320@us.ibm.com>
References: <20080824154912.GA3780@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080824154912.GA3780@tv-sign.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@tv-sign.ru):
> We don't change pid_ns->child_reaper when the main thread of the
> subnamespace init exits. As Robert Rex <robert.rex@exasol.com>
> pointed out this is wrong.

I think there was another way that could go wrong as well - if the main
thread exited but sighand had another user, then the child_reaper would
not be changed, zap_pid_ns_processes() would not be called, and children
would continue to run and at death try to signal the dead main thread.

> Yes, the re-parenting itself works correctly, but if the reparented
> task exits it needs ->parent->nsproxy->pid_ns in do_notify_parent(),
> and if the main thread is zombie its ->nsproxy was already cleared
> by exit_task_namespaces().
> 
> Introduce the new function, find_new_reaper(), which finds the new
> ->parent for the re-parenting and changes ->child_reaper if needed.
> Kill the now unneeded exit_child_reaper().
> 
> Also move the changing of ->child_reaper from zap_pid_ns_processes()
> to find_new_reaper(), this consolidates the games with ->child_reaper
> and makes it stable under tasklist_lock.
> 
> Reported-by: Robert Rex <robert.rex@exasol.com>
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Sat on this for a bit - the only thing about this that worried me was
that zap_pid_ns_processes() is moved much further down in do_exit().
After looking I see no reason why that would be a problem, though.

Acked-by: Serge Hallyn <serue@us.ibm.com>

Thanks, Oleg.

> 
>  kernel/pid_namespace.c |    6 ---
>  kernel/exit.c          |   78 +++++++++++++++++++++----------------------------
>  2 files changed, 34 insertions(+), 50 deletions(-)
> 
> --- 2.6.27-rc4/kernel/pid_namespace.c~2_SWITCH_REAPER	2008-08-24 17:22:59.000000000 +0400
> +++ 2.6.27-rc4/kernel/pid_namespace.c	2008-08-24 18:22:44.000000000 +0400
> @@ -179,12 +179,6 @@ void zap_pid_ns_processes(struct pid_nam
>  		rc = sys_wait4(-1, NULL, __WALL, NULL);
>  	} while (rc != -ECHILD);
> 
> -	/*
> -	 * We can not clear ->child_reaper or leave it alone.
> -	 * There may by stealth EXIT_DEAD tasks on ->children,
> -	 * forget_original_parent() must move them somewhere.
> -	 */
> -	pid_ns->child_reaper = init_pid_ns.child_reaper;
>  	acct_exit_ns(pid_ns);
>  	return;
>  }
> --- 2.6.27-rc4/kernel/exit.c~2_SWITCH_REAPER	2008-08-24 16:46:51.000000000 +0400
> +++ 2.6.27-rc4/kernel/exit.c	2008-08-24 18:22:37.000000000 +0400
> @@ -831,26 +831,50 @@ static void reparent_thread(struct task_
>   * the child reaper process (ie "init") in our pid
>   * space.
>   */
> +static struct task_struct *find_new_reaper(struct task_struct *father)
> +{
> +	struct pid_namespace *pid_ns = task_active_pid_ns(father);
> +	struct task_struct *thread;
> +
> +	thread = father;
> +	while_each_thread(father, thread) {
> +		if (thread->flags & PF_EXITING)
> +			continue;
> +		if (unlikely(pid_ns->child_reaper == father))
> +			pid_ns->child_reaper = thread;
> +		return thread;
> +	}
> +
> +	if (unlikely(pid_ns->child_reaper == father)) {
> +		write_unlock_irq(&tasklist_lock);
> +		if (unlikely(pid_ns == &init_pid_ns))
> +			panic("Attempted to kill init!");
> +
> +		zap_pid_ns_processes(pid_ns);
> +		write_lock_irq(&tasklist_lock);
> +		/*
> +		 * We can not clear ->child_reaper or leave it alone.
> +		 * There may by stealth EXIT_DEAD tasks on ->children,
> +		 * forget_original_parent() must move them somewhere.
> +		 */
> +		pid_ns->child_reaper = init_pid_ns.child_reaper;
> +	}
> +
> +	return pid_ns->child_reaper;
> +}
> +
>  static void forget_original_parent(struct task_struct *father)
>  {
> -	struct task_struct *p, *n, *reaper = father;
> +	struct task_struct *p, *n, *reaper;
>  	LIST_HEAD(ptrace_dead);
> 
>  	write_lock_irq(&tasklist_lock);
> -
> +	reaper = find_new_reaper(father);
>  	/*
>  	 * First clean up ptrace if we were using it.
>  	 */
>  	ptrace_exit(father, &ptrace_dead);
> 
> -	do {
> -		reaper = next_thread(reaper);
> -		if (reaper == father) {
> -			reaper = task_child_reaper(father);
> -			break;
> -		}
> -	} while (reaper->flags & PF_EXITING);
> -
>  	list_for_each_entry_safe(p, n, &father->children, sibling) {
>  		p->real_parent = reaper;
>  		if (p->parent == father) {
> @@ -959,39 +983,6 @@ static void check_stack_usage(void)
>  static inline void check_stack_usage(void) {}
>  #endif
> 
> -static inline void exit_child_reaper(struct task_struct *tsk)
> -{
> -	if (likely(tsk->group_leader != task_child_reaper(tsk)))
> -		return;
> -
> -	if (tsk->nsproxy->pid_ns == &init_pid_ns)
> -		panic("Attempted to kill init!");
> -
> -	/*
> -	 * @tsk is the last thread in the 'cgroup-init' and is exiting.
> -	 * Terminate all remaining processes in the namespace and reap them
> -	 * before exiting @tsk.
> -	 *
> -	 * Note that @tsk (last thread of cgroup-init) may not necessarily
> -	 * be the child-reaper (i.e main thread of cgroup-init) of the
> -	 * namespace i.e the child_reaper may have already exited.
> -	 *
> -	 * Even after a child_reaper exits, we let it inherit orphaned children,
> -	 * because, pid_ns->child_reaper remains valid as long as there is
> -	 * at least one living sub-thread in the cgroup init.
> -
> -	 * This living sub-thread of the cgroup-init will be notified when
> -	 * a child inherited by the 'child-reaper' exits (do_notify_parent()
> -	 * uses __group_send_sig_info()). Further, when reaping child processes,
> -	 * do_wait() iterates over children of all living sub threads.
> -
> -	 * i.e even though 'child_reaper' thread is listed as the parent of the
> -	 * orphaned children, any living sub-thread in the cgroup-init can
> -	 * perform the role of the child_reaper.
> -	 */
> -	zap_pid_ns_processes(tsk->nsproxy->pid_ns);
> -}
> -
>  NORET_TYPE void do_exit(long code)
>  {
>  	struct task_struct *tsk = current;
> @@ -1051,7 +1042,6 @@ NORET_TYPE void do_exit(long code)
>  	}
>  	group_dead = atomic_dec_and_test(&tsk->signal->live);
>  	if (group_dead) {
> -		exit_child_reaper(tsk);
>  		hrtimer_cancel(&tsk->signal->real_timer);
>  		exit_itimers(tsk->signal);
>  	}
