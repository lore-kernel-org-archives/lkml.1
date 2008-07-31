Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYGaTch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYGaTch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757459AbYGaTcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:32:18 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:58516 "EHLO
	QMTA04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757138AbYGaTcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:32:17 -0400
X-Authority-Analysis: v=1.0 c=1 a=UhecZ-3zIvEA:10 a=xYbe6-XYs7AA:10
 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=ehLUfy7ukpMSJyyn9ZAA:9
 a=LJUiMbrEyZyJAtQ6uU8A:7 a=L2_5tbnHSSKHS0Y0M52WL85pC3UA:4 a=jEp0ucaQiEUA:10
 a=nbrB6oW77rQA:10
Date: Thu, 31 Jul 2008 14:32:21 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracehook: fix exit_signal=0 case
Message-ID: <20080731193221.GA17617@hallyn.com>
References: <20080731090409.8D32A154263@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731090409.8D32A154263@magilla.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Roland McGrath (roland@redhat.com):
> My commit 2b2a1ff64afbadac842bbc58c5166962cf4f7664 introduced a regression
> (sorry about that) for the odd case of exit_signal=0 (e.g. clone_flags=0).
> This is not a normal use, but it's used by a case in the glibc test suite.
> 
> Dying with exit_signal=0 sends no signal, but it's supposed to wake up a
> parent's blocked wait*() calls (unlike the delayed_group_leader case).
> This fixes tracehook_notify_death() and its caller to distinguish a
> "signal 0" wakeup from the delayed_group_leader case (with no wakeup).
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>

Tested-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge

> ---
>  include/linux/tracehook.h |   21 +++++++++++++--------
>  kernel/exit.c             |    6 +++---
>  2 files changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
> index b187558..1253283 100644
> --- a/include/linux/tracehook.h
> +++ b/include/linux/tracehook.h
> @@ -493,16 +493,21 @@ static inline int tracehook_notify_jctl(int notify, int why)
>   * @death_cookie:	value to pass to tracehook_report_death()
>   * @group_dead:		nonzero if this was the last thread in the group to die
>   *
> - * Return the signal number to send our parent with do_notify_parent(), or
> - * zero to send no signal and leave a zombie, or -1 to self-reap right now.
> + * A return value >= 0 means call do_notify_parent() with that signal
> + * number.  Negative return value can be %DEATH_REAP to self-reap right
> + * now, or %DEATH_DELAYED_GROUP_LEADER to a zombie without notifying our
> + * parent.  Note that a return value of 0 means a do_notify_parent() call
> + * that sends no signal, but still wakes up a parent blocked in wait*().
>   *
>   * Called with write_lock_irq(&tasklist_lock) held.
>   */
> +#define DEATH_REAP			-1
> +#define DEATH_DELAYED_GROUP_LEADER	-2
>  static inline int tracehook_notify_death(struct task_struct *task,
>  					 void **death_cookie, int group_dead)
>  {
>  	if (task->exit_signal == -1)
> -		return task->ptrace ? SIGCHLD : -1;
> +		return task->ptrace ? SIGCHLD : DEATH_REAP;
>  
>  	/*
>  	 * If something other than our normal parent is ptracing us, then
> @@ -512,21 +517,21 @@ static inline int tracehook_notify_death(struct task_struct *task,
>  	if (thread_group_empty(task) && !ptrace_reparented(task))
>  		return task->exit_signal;
>  
> -	return task->ptrace ? SIGCHLD : 0;
> +	return task->ptrace ? SIGCHLD : DEATH_DELAYED_GROUP_LEADER;
>  }
>  
>  /**
>   * tracehook_report_death - task is dead and ready to be reaped
>   * @task:		@current task now exiting
> - * @signal:		signal number sent to parent, or 0 or -1
> + * @signal:		return value from tracheook_notify_death()
>   * @death_cookie:	value passed back from tracehook_notify_death()
>   * @group_dead:		nonzero if this was the last thread in the group to die
>   *
>   * Thread has just become a zombie or is about to self-reap.  If positive,
>   * @signal is the signal number just sent to the parent (usually %SIGCHLD).
> - * If @signal is -1, this thread will self-reap.  If @signal is 0, this is
> - * a delayed_group_leader() zombie.  The @death_cookie was passed back by
> - * tracehook_notify_death().
> + * If @signal is %DEATH_REAP, this thread will self-reap.  If @signal is
> + * %DEATH_DELAYED_GROUP_LEADER, this is a delayed_group_leader() zombie.
> + * The @death_cookie was passed back by tracehook_notify_death().
>   *
>   * If normal reaping is not inhibited, @task->exit_state might be changing
>   * in parallel.
> diff --git a/kernel/exit.c b/kernel/exit.c
> index eb4d647..38ec406 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -911,10 +911,10 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
>  		tsk->exit_signal = SIGCHLD;
>  
>  	signal = tracehook_notify_death(tsk, &cookie, group_dead);
> -	if (signal > 0)
> +	if (signal >= 0)
>  		signal = do_notify_parent(tsk, signal);
>  
> -	tsk->exit_state = signal < 0 ? EXIT_DEAD : EXIT_ZOMBIE;
> +	tsk->exit_state = signal == DEATH_REAP ? EXIT_DEAD : EXIT_ZOMBIE;
>  
>  	/* mt-exec, de_thread() is waiting for us */
>  	if (thread_group_leader(tsk) &&
> @@ -927,7 +927,7 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
>  	tracehook_report_death(tsk, signal, cookie, group_dead);
>  
>  	/* If the process is dead, release it - nobody will wait for it */
> -	if (signal < 0)
> +	if (signal == DEATH_REAP)
>  		release_task(tsk);
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
