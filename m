Return-Path: <linux-kernel-owner+w=401wt.eu-S1760641AbZBYUrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641AbZBYUrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 15:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755620AbZBYUrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 15:47:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33571 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988AbZBYUrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 15:47:46 -0500
Date: Wed, 25 Feb 2009 21:44:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] forget_original_parent: split out the un-ptrace
	part
Message-ID: <20090225204454.GA11842@redhat.com>
References: <20090211211216.GA16847@redhat.com> <20090220022746.8852CFC2F7@magilla.sf.frob.com> <20090223164632.GA16294@redhat.com> <20090225003408.1DA81FC380@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225003408.1DA81FC380@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24, Roland McGrath wrote:
>
> > > --- a/kernel/ptrace.c
> > > +++ b/kernel/ptrace.c
> > > @@ -534,7 +534,7 @@ repeat:
> > >  		 * Set the ptrace bit in the process ptrace flags.
> > >  		 * Then link us on our parent's ptraced list.
> > >  		 */
> > > -		if (!ret) {
> > > +		if (!ret && !(current->real_parent->flags & PF_EXITING)) {
> > >  			current->ptrace |= PT_PTRACED;
> >
> > Yes sure.
> >
> > But this means exit_ptrace() must always take tasklist, otherwise we
> > don't have the necessary barriers.
>
> Really?
>
> 	exit_signals(tsk);  /* sets PF_EXITING */
> 	/*
> 	 * tsk->flags are checked in the futex code to protect against
> 	 * an exiting task cleaning up the robust pi futexes.
> 	 */
> 	smp_mb();
>
> This is an exactly analogous use, isn't it?  So exit_ptrace() just has to
> follow this same existing barrier.  Right?

Yes, we do have the barrier between "flags |= PF_EXITING" and
"if (list_empty(ptraced))" in exit_ptrace(), but it is not enough.

Because the exiting ->real_parent can both set PF_EXITING and return
from exit_ptrace() (without taking tasklist because it sees ->ptraced
is empty) right after the child checks ->real_parent->flags & PF_EXITING.

I am still thinking what can we do here (and btw my apologies for delay,
some stupid reasons distract me).

> > But from the _pure theoretical_ pov, it is not correct to assume that
> > list_empty(&tracer->ptraced) == T means that current can not be used
> > somehow as tracee->parent. Another subthread can release a dead tracee.
>
> I don't follow how that's relevant.  If list_empty(), then it was empty or
> is becoming empty.  It can't then become nonempty again (because the thread
> doing the check is the only one that adds to that list).  That's all we're
> assuming.
>
> > For example, list_empty(&tracer->ptraced) == T doesn't mean that the
> > STOREs to this task_struct are finished, list_del_init(->ptrace_entry)
> > can still be in progress.
>
> Sure, but so what?  The check is to verify that some new list_del* (and
> related cleanup work, of course) doesn't need to be *started*.

Well. I am starting to regret I mentioned this "problem" ;) Because even
if I am right (it is very possible I am not), this all is _absolutely_
theoretical. Let me try again to explain what I meant.

First of all, in theory write_lock_irq() does not imply rcu_read_lock().

Now let's suppose that the exiting task T does exit_ptrace(), sees the
empty ->ptraced list, and then can do release_task()->call_rcu(put_task_struct)
without taking the tasklist_lock on this path.

Let's also suppose that we race with another sub-thread which reaps
a zombie tracee and does __ptrace_unlink()->list_del_init(ptrace_entry).
__list_del does 1) next->prev = prev and 2) prev->next = next.

Let's suppose 2 is completed, but 1 is not.

T checks list_empty(->ptraced) and sees head->next == head. It proceeds
and calls call_rcu(put_task_struct).

Since (in theory!) we do not have rcu_read_lock(), it is possible that
task_struct is already freed when 1 write to the memory.


But actually I meant that this is not really safe "in general". Let's
suppose we change __ptrace_unlink() so that it does, say,
BUG_ON(child->parent->exit_state != 0) before untracing. Yes, sure,
this is ugly, but correct. Or BUG_ON(!child->parent->signal), or
whatever else.

But this is only correct because T takes tasklist before it actually
starts to "destroy" itself.


In short, my point is: even if exit_ptrace() sees list_empty(->ptraced),
it is possible that the just-untraced tracee "looks" at us and expects
that the former tracer is "alive" enough.

Oleg.

