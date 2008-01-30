Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbYA3E4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbYA3E4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 23:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYA3E4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 23:56:42 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:56960 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbYA3E4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 23:56:41 -0500
Date: Tue, 29 Jan 2008 20:56:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       mingo@elte.hu, xemul@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix tasklist + find_pid() with CONFIG_PREEMPT_RCU
Message-ID: <20080130045633.GG12073@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080129164019.GA2060@tv-sign.ru> <20080129150836.7fd994a2.akpm@linux-foundation.org> <m1r6g0gir1.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r6g0gir1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 07:16:50PM -0700, Eric W. Biederman wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Tue, 29 Jan 2008 19:40:19 +0300
> > Oleg Nesterov <oleg@tv-sign.ru> wrote:
> >
> >> With CONFIG_PREEMPT_RCU read_lock(tasklist_lock) doesn't imply
> > rcu_read_lock(),
> >> but find_pid_ns()->hlist_for_each_entry_rcu() should be safe under tasklist.
> >> 
> >> Usually it is, detach_pid() is always called under write_lock(tasklist_lock),
> >> but copy_process() calls free_pid() lockless.
> >> 
> >> "#ifdef CONFIG_PREEMPT_RCU" is added mostly as documentation, perhaps it is
> >> too ugly and should be removed.
> >> 
> >> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> >> 
> >> --- MM/kernel/fork.c~PR_RCU	2008-01-27 17:09:47.000000000 +0300
> >> +++ MM/kernel/fork.c	2008-01-29 19:23:44.000000000 +0300
> >> @@ -1335,8 +1335,19 @@ static struct task_struct *copy_process(
> >>  	return p;
> >>  
> >>  bad_fork_free_pid:
> >> -	if (pid != &init_struct_pid)
> >> +	if (pid != &init_struct_pid) {
> >> +#ifdef CONFIG_PREEMPT_RCU
> >> +		/*
> >> +		 * read_lock(tasklist_lock) doesn't imply rcu_read_lock(),
> >> +		 * make sure find_pid() is safe under read_lock(tasklist).
> >> +		 */
> >> +		write_lock_irq(&tasklist_lock);
> >> +#endif
> >>  		free_pid(pid);
> >> +#ifdef CONFIG_PREEMPT_RCU
> >> +		write_unlock_irq(&tasklist_lock);
> >> +#endif
> >> +	}
> >>  bad_fork_cleanup_namespaces:
> >>  	exit_task_namespaces(p);
> >>  bad_fork_cleanup_keys:
> >
> > My attempt to understand this change timed out.
> >
> > kernel/pid.c is full of global but undocumented functions.  What are the
> > locking requirements for free_pid()?  free_pid_ns()?  If it's just
> > caller-must-hold-rcu_read_lock() then why not use rcu_read_lock() here?
> >
> > If the locking is "caller must hold write_lock_irq(tasklist_lock) then the
> > sole relevant comment in there (in free_pid()) is wrong.
> >
> > Guys, more maintainable code please?
> 
> Well I took a quick look.
> 
> Yeah this looks complex.
> Mutation of the hash table is protected by pidmap_lock.
> But attachments of tasks to hash entries is protected task_lock.
> 
> And it looks like it has been that way since commit 92476d7fc0326a409ab1d3864a04093a6be9aca7
> 
> I thought free_pid did not have any requirements that a lock be held when
> it was called, taking all of the needed locks.
> 
> Now how read_lock doesn't imply rcu_read_lock is another question.

Although read_lock() does accidentally imply rcu_read_lock() for
Classic RCU, it no longer does so for preemptible RCU.

But I thought that we had found these -- must have missed some...

							Thanx, Paul

> Anyway I have to run.  I will see about looking at this in a bit.
> 
> Eric
