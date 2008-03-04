Return-Path: <linux-kernel-owner+w=401wt.eu-S1764391AbYCDWD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764391AbYCDWD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 17:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbYCDWDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 17:03:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54290 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665AbYCDWDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 17:03:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] freezer vs stopped or traced
Date: Tue, 4 Mar 2008 23:02:43 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
References: <20080304042205.4DA9F2700FB@magilla.localdomain>
In-Reply-To: <20080304042205.4DA9F2700FB@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803042302.44828.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please send CCs of freezer patches to me and Pavel.

On Tuesday, 4 of March 2008, Roland McGrath wrote:
> 
> This changes the "freezer" code used by suspend/hibernate in its treatment
> of tasks in TASK_STOPPED (job control stop) and TASK_TRACED (ptrace) states.
> 
> As I understand it, the intent of the "freezer" is to hold all tasks
> from doing anything significant.  For this purpose, TASK_STOPPED and
> TASK_TRACED are "frozen enough".  It's possible the tasks might resume
> from ptrace calls (if the tracer were unfrozen) or from signals
> (including ones that could come via timer interrupts, etc).  But this
> doesn't matter as long as they quickly block again while "freezing" is
> in effect.  Some minor adjustments to the signal.c code make sure that
> try_to_freeze() very shortly follows all wakeups from both kinds of
> stop.  This lets the freezer code safely leave stopped tasks unmolested.
> 
> Changing this fixes the longstanding bug of seeing after resuming from
> suspend/hibernate your shell report "[1] Stopped" and the like for all
> your jobs stopped by ^Z et al, as if you had freshly fg'd and ^Z'd them.
> It also removes from the freezer the arcane special case treatment for
> ptrace'd tasks, which relied on intimate knowledge of ptrace internals.

I think the change goes in the right direction.

How thoroughly has it been tested?

> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  kernel/power/process.c |   29 ++++++++++++-----------------
>  kernel/signal.c        |   16 ++++++++++++++--
>  2 files changed, 26 insertions(+), 19 deletions(-)
> 
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index 7c2118f..f1d0b34 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -75,22 +75,15 @@ void refrigerator(void)
>  	__set_current_state(save);
>  }
>  
> -static void fake_signal_wake_up(struct task_struct *p, int resume)
> +static void fake_signal_wake_up(struct task_struct *p)
>  {
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&p->sighand->siglock, flags);
> -	signal_wake_up(p, resume);
> +	signal_wake_up(p, 0);
>  	spin_unlock_irqrestore(&p->sighand->siglock, flags);
>  }
>  
> -static void send_fake_signal(struct task_struct *p)
> -{
> -	if (task_is_stopped(p))
> -		force_sig_specific(SIGSTOP, p);
> -	fake_signal_wake_up(p, task_is_stopped(p));
> -}
> -
>  static int has_mm(struct task_struct *p)
>  {
>  	return (p->mm && !(p->flags & PF_BORROWED_MM));
> @@ -121,7 +114,7 @@ static int freeze_task(struct task_struct *p, int with_mm_only)
>  	if (freezing(p)) {
>  		if (has_mm(p)) {
>  			if (!signal_pending(p))
> -				fake_signal_wake_up(p, 0);
> +				fake_signal_wake_up(p);
>  		} else {
>  			if (with_mm_only)
>  				ret = 0;
> @@ -135,7 +128,7 @@ static int freeze_task(struct task_struct *p, int with_mm_only)
>  		} else {
>  			if (has_mm(p)) {
>  				set_freeze_flag(p);
> -				send_fake_signal(p);
> +				fake_signal_wake_up(p);
>  			} else {
>  				if (with_mm_only) {
>  					ret = 0;
> @@ -182,15 +175,17 @@ static int try_to_freeze_tasks(int freeze_user_space)
>  			if (frozen(p) || !freezeable(p))
>  				continue;
>  
> -			if (task_is_traced(p) && frozen(p->parent)) {
> -				cancel_freezing(p);
> -				continue;
> -			}
> -
>  			if (!freeze_task(p, freeze_user_space))
>  				continue;
>  
> -			if (!freezer_should_skip(p))
> +			/*
> +			 * Now that we've done set_freeze_flag, don't
> +			 * perturb a task in TASK_STOPPED or TASK_TRACED.
> +			 * It is "frozen enough".  If the task does wake
> +			 * up, it will immediately call try_to_freeze.
> +			 */
> +			if (!task_is_stopped_or_traced(p) &&
> +			    !freezer_should_skip(p))

Why don't you modify freezer_should_skip() to include the
!task_is_stopped_or_traced() test and put a comment in there?

>  				todo++;
>  		} while_each_thread(g, p);
>  		read_unlock(&tasklist_lock);
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 84917fe..6af1210 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1623,7 +1623,6 @@ static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
>  	/* Let the debugger run.  */
>  	__set_current_state(TASK_TRACED);
>  	spin_unlock_irq(&current->sighand->siglock);
> -	try_to_freeze();
>  	read_lock(&tasklist_lock);
>  	if (!unlikely(killed) && may_ptrace_stop()) {
>  		do_notify_parent_cldstop(current, CLD_TRAPPED);
> @@ -1641,6 +1640,13 @@ static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
>  	}
>  
>  	/*
> +	 * While in TASK_TRACED, we were considered "frozen enough".
> +	 * Now that we woke up, it's crucial if we're supposed to be
> +	 * frozen that we freeze now before running anything substantial.
> +	 */
> +	try_to_freeze();
> +
> +	/*
>  	 * We are back.  Now reacquire the siglock before touching
>  	 * last_siginfo, so that we are sure to have synchronized with
>  	 * any signal-sending on another CPU that wants to examine it.
> @@ -1757,9 +1763,15 @@ int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
>  	sigset_t *mask = &current->blocked;
>  	int signr = 0;
>  
> +relock:
> +	/*
> +	 * We'll jump back here after any time we were stopped in TASK_STOPPED.
> +	 * While in TASK_STOPPED, we were considered "frozen enough".
> +	 * Now that we woke up, it's crucial if we're supposed to be
> +	 * frozen that we freeze now before running anything substantial.
> +	 */
>  	try_to_freeze();
>  
> -relock:
>  	spin_lock_irq(&current->sighand->siglock);
>  	for (;;) {
>  		struct k_sigaction *ka;
> --

Thanks,
Rafael
