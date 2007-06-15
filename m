Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbXFOLbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbXFOLbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 07:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbXFOLbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 07:31:31 -0400
Received: from mail.screens.ru ([213.234.233.54]:52361 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbXFOLba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 07:31:30 -0400
Date: Fri, 15 Jun 2007 15:31:27 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel internal errnos
Message-ID: <20070615113127.GB84@tv-sign.ru>
References: <87hcplvdkl.wl%takeuchi_satoru@jp.fujitsu.com> <200706141426.45522.rjw@sisk.pl> <20070614125843.GA78@tv-sign.ru> <200706150135.15364.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706150135.15364.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15, Rafael J. Wysocki wrote:
>
> +static void freeze_task(struct task_struct *p)
> +{
>  	if (!freezing(p)) {
>  		rmb();
>  		if (!frozen(p)) {
>  			set_freeze_flag(p);
> -			if (p->state == TASK_STOPPED)
> -				force_sig_specific(SIGSTOP, p);
> -			spin_lock_irqsave(&p->sighand->siglock, flags);
> -			signal_wake_up(p, p->state == TASK_STOPPED);
> -			spin_unlock_irqrestore(&p->sighand->siglock, flags);
> +			task_lock(p);
> +			/* We don't want to send signals to kernel threads */
> +			if (p->mm && !(p->flags & PF_BORROWED_MM)) {
> +				task_unlock(p);
> +				send_fake_signal(p);
> +			} else {
> +				task_unlock(p);
> +				wake_up_state(p, TASK_INTERRUPTIBLE);
> +			}

I don't think this is enough. Note that recalc_sigpending() checks freezing().
So a kernel thread still can get TIF_SIGPENDING if it does recalc_sigpending().

> --- linux-2.6.22-rc4-mm2.orig/include/linux/wait.h	2007-06-15 01:05:33.000000000 +0200
> +++ linux-2.6.22-rc4-mm2/include/linux/wait.h	2007-06-15 01:05:41.000000000 +0200
> @@ -240,7 +240,7 @@ do {									\
>  		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
>  		if (condition)						\
>  			break;						\
> -		if (!signal_pending(current)) {				\
> +		if (!signal_pending(current) && !freezing(current)) {	\
>  			schedule();					\
>  			continue;					\
>  		}							\

Personally, I think we should not modify wait_event_interruptible() and friends.
If a kernel thread wants to be frozen, it should take care about freezing()
itself.


OK, I guess I was too paranoid and you were right, it is better to ignore this
minor problem for now.

Oleg.

