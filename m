Return-Path: <linux-kernel-owner+w=401wt.eu-S932280AbXDNSgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbXDNSgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 14:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932255AbXDNSgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 14:36:06 -0400
Received: from mail.screens.ru ([213.234.233.54]:53919 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231AbXDNSgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 14:36:04 -0400
Date: Sat, 14 Apr 2007 22:35:38 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] kthread: Enhance kthread_stop to abort interruptible sleeps
Message-ID: <20070414183538.GB504@tv-sign.ru>
References: <20070413130236.GA173@tv-sign.ru> <m1zm5bmywm.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zm5bmywm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13, Eric W. Biederman wrote:
>
> +static inline int __kthread_should_stop(struct task_struct *tsk)
> +{
> +	return test_tsk_thread_flag(tsk, TIF_KTHREAD_STOP);
> +}

Am I blind? Where does copy_process/dup_task_struct clears unwanted
flags in thread_info->flags ?

> +int kthread_stop(struct task_struct *tsk)
>  {
>  	int ret;
>  
> -	mutex_lock(&kthread_stop_lock);
> -
> -	/* It could exit after stop_info.k set, but before wake_up_process. */
> -	get_task_struct(k);
> +	/* Ensure the task struct persists until I read the exit code. */
> +	get_task_struct(tsk);
>  
> -	/* Must init completion *before* thread sees kthread_stop_info.k */
> -	init_completion(&kthread_stop_info.done);
> -	smp_wmb();
> +	set_tsk_thread_flag(tsk, TIF_KTHREAD_STOP);
> +	spin_lock_irq(&tsk->sighand->siglock);
> +	signal_wake_up(tsk, 1);
> +	spin_unlock_irq(&tsk->sighand->siglock);

Off-topic again, the comment above signal_wake_up() is very confusing...
I think the only reason for ->siglock is to prevent the case when
TIF_SIGPENDING may be cleared by recalc_sigpending(). Or something else?

This changes the current API, kthread_stop() doesn't wake up UNINTERRUPTIBLE
tasks any longer. I'd say this is good, but may break things ... For example,
kthred_stop(kthread_create(...)) can't work now.

> -	/* Now set kthread_should_stop() to true, and wake it up. */
> -	kthread_stop_info.k = k;
> -	wake_up_process(k);
> -	put_task_struct(k);
> +	wait_for_completion(tsk->vfork_done);
> +	ret = tsk->exit_code;

This is really good. Now the kernel thread can exit() at any point without
fear to break kthread_stop().

> @@ -218,7 +219,7 @@ static inline int has_pending_signals(sigset_t *signal, sigset_t *blocked)
>  fastcall void recalc_sigpending_tsk(struct task_struct *t)
>  {
>  	if (t->signal->group_stop_count > 0 ||
> -	    (freezing(t)) ||
> +	    (freezing(t)) || __kthread_should_stop(t) ||
>  	    PENDING(&t->pending, &t->blocked) ||
>  	    PENDING(&t->signal->shared_pending, &t->blocked))
>  		set_tsk_thread_flag(t, TIF_SIGPENDING);

Aha, now I understand your point about interruptible sleeps (the previous
message). What is the reason for this change?

Oleg.

