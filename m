Return-Path: <linux-kernel-owner+w=401wt.eu-S965310AbXBQXmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965310AbXBQXmh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 18:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965318AbXBQXmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 18:42:37 -0500
Received: from mail.screens.ru ([213.234.233.54]:41755 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965310AbXBQXmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 18:42:36 -0500
Date: Sun, 18 Feb 2007 02:42:01 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Message-ID: <20070217234201.GA591@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <200702171224.46626.rjw@sisk.pl> <20070217213406.GA541@tv-sign.ru> <200702172324.44892.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702172324.44892.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17, Rafael J. Wysocki wrote:
>
> On Saturday, 17 February 2007 22:34, Oleg Nesterov wrote:
> > 
> > 	static inline int is_user_space(struct task_struct *p)
> > 	{
> > 		return p->mm && !(p->flags & PF_BORROWED_MM);
> > 	}
> > 
> > This doesn't look right. First, an exiting task has ->mm == NULL after
> > do_exit()->exit_mm(). Probably not a problem. However, PF_BORROWED_MM
> > check is racy without task_lock(), so we can have a false positive as
> > well. Is it ok? We can freeze aio_wq prematurely.
> 
> Right now aio_wq is not freezeable (PF_NOFREEZE).

Right now yes, but we are going to change this?

> > 				cancel_freezing(p);
> > 				continue;
> > 
> > Is it right? Shouldn't we increment "todo" counter?
> 
> No.  It would be wrong to do that, because TASK_TRACED tasks with frozen
> parents cannot be frozen any further.

TASK_TRACED task could be woken by SIGKILL. cancel_freezing() clears TIF_FREEZE.
The task may start do_exit() when try_to_freeze_tasks() returns "success".
Probably not a problem.

> > 				if (!p->vfork_done)
> > 					freeze_process(p);
> > 
> > 
> > Racy. do_fork(CLONE_VFORK) first does copy_process() which puts 'p' on
> > the task list and unlocks tasklist_lock. This means that 'p' is visible
> > to try_to_freeze_tasks(), and p->vfork_done == NULL. try_to_freeze_tasks()
> > sets TIF_FREEZE.
> > 
> > Now, do_fork() continues, sets ->vfork_done, p goes to user space, notices
> > the fake signal and goes to refrigerator while its parent is blocked on
> > "struct completion vfork". Freezing failed.
> 
> You are right, but this has never happened, AFAICS.
> 
> > So, shouldn't we do
> > 
> > 	if (p->vfork_done)
> > 		cancel_freezing(p);
> > 
> > instead?
> 
> I don't think so.  If p hasn't got TIF_FREEZE set yet or it has already been
> frozen, cancel_freezing(p) is a noop.

Yes, I misread cancel_freezing(), it doesn't wake up the task if it is frozen.

> Alternatively, we can move the check into refrigerator(), like this:
> 
> --- linux-2.6.20-git13.orig/kernel/power/process.c
> +++ linux-2.6.20-git13/kernel/power/process.c
> @@ -39,6 +39,11 @@ void refrigerator(void)
>  	/* Hmm, should we be allowed to suspend when there are realtime
>  	   processes around? */
>  	long save;
> +
> +	/* Freeze the task unless there is a vfork completion pending */
> +	if (current->vfork_done)
> +		return;
> +

This means that "current" returns to user space (get_signal_to_deliver
will clear TIF_SIGPENDING) and runs. While try_to_freeze_tasks() thinks
it is frozen.

Oleg.

