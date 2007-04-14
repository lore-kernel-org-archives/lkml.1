Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbXDNTeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbXDNTeZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 15:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXDNTeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 15:34:25 -0400
Received: from mail.screens.ru ([213.234.233.54]:45353 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbXDNTeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 15:34:24 -0400
Date: Sat, 14 Apr 2007 23:34:06 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] kthread: Enhance kthread_stop to abort interruptible sleeps
Message-ID: <20070414193406.GA631@tv-sign.ru>
References: <20070413130236.GA173@tv-sign.ru> <m1zm5bmywm.fsf@ebiederm.dsl.xmission.com> <20070414183538.GB504@tv-sign.ru> <m1slb2lqv9.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1slb2lqv9.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > On 04/13, Eric W. Biederman wrote:
> >>
> >> +static inline int __kthread_should_stop(struct task_struct *tsk)
> >> +{
> >> +	return test_tsk_thread_flag(tsk, TIF_KTHREAD_STOP);
> >> +}
> >
> > Am I blind? Where does copy_process/dup_task_struct clears unwanted
> > flags in thread_info->flags ?
> 
> Good question.  It is only a real problem if someone forks a kernel
> thread after we ask it to die but, it does appear to be an issue.
> With this usage and the same usage by the process freezer.
> 
> We do have these lines in copy_process...
> 
> 	clear_tsk_thread_flag(p, TIF_SIGPENDING);
> 	init_sigpending(&p->pending);
> 
> I don't know what we want to do about TIF_KTHREAD_STOP and TIF_FREEZE.

Perhaps we need _TIF_CLEAR_ON_FORK_MASK. Probably doesn't matter right
now, but still it is not imho safe in general.

> Right now we will go allow our merry way until we hit:
> 
> 	recalc_sigpending();
> 	if (signal_pending(current)) {
> 		spin_unlock(&current->sighand->siglock);
> 		write_unlock_irq(&tasklist_lock);
> 		retval = -ERESTARTNOINTR;
> 		goto bad_fork_cleanup_namespaces;
> 	}
> 
> And copy_process will fail.  Since that is an expected failure point
> that actually seems like reasonable behavior in this case if you
> are being frozen or are being told to die you can't fork.
> 
> It does ensure that these additional kernel flags won't make it
> onto new instances of struct task_struct.  Which is the important
> thing from a correctness standpoint.

Note that we set TIF_FREEZE and TIF_KTHREAD_STOP outside of ->siglock,
so both flags can leak onto the child. Again, not a problem right now.
TIF_KTHREAD_STOP doesn't matter unless process was created vi kthread_create(),
but in that case it can't inherit TIF_KTHREAD_STOP.

Oleg.

