Return-Path: <linux-kernel-owner+w=401wt.eu-S933674AbYBVNfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674AbYBVNfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 08:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbYBVNfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 08:35:21 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:41708 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758233AbYBVNfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 08:35:19 -0500
Date: Fri, 22 Feb 2008 08:35:14 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: gregory.haskins@gmail.com
cc: Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu,
       a.p.zijlstra@chello.nl, tglx@linutronix.de,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       bill.huey@gmail.com, kevin@hilman.org, cminyard@mvista.com,
       dsingleton@mvista.com, dwalker@mvista.com, npiggin@suse.de,
       dsaxena@plexity.net, ak@suse.de, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com
Subject: Re: [PATCH [RT] 05/14] rearrange rt_spin_lock sleep
In-Reply-To: <47BECE30.8030100@gmail.com>
Message-ID: <Pine.LNX.4.58.0802220832330.15391@gandalf.stny.rr.com>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
 <20080221152651.4804.4702.stgit@novell1.haskins.net> <47BECE30.8030100@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 22 Feb 2008, Gregory Haskins wrote:

> Gregory Haskins wrote:
> > @@ -732,14 +741,15 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
> >
> >  		debug_rt_mutex_print_deadlock(&waiter);
> >
> > -		schedule_rt_mutex(lock);
> > +		update_current(TASK_UNINTERRUPTIBLE, &saved_state);
>
> I have a question for everyone out there about this particular part of
> the code. Patch 6/14 adds an optimization that is predicated on the
> order in which we modify the state==TASK_UNINTERRUPTIBLE vs reading the
> waiter.task below.
>
> My assumption is that the xchg() (inside update_current()) acts as an
> effective wmb().  If xchg() does not have this property, then this code
> is broken and patch 6/14 should also add a:
>
>
> +               smp_wmb();

I believe that the wmb would be needed. I doubt that xchg on all archs
would force any ordering of reads and writes. It only needs to guarantee the
atomic nature of the data exchange. I don't see any reason that it would
imply any type of memory barrier.

-- Steve


>
>
> > +		if (waiter.task)
> > +			schedule_rt_mutex(lock);
> > +		else
> > +			update_current(TASK_RUNNING_MUTEX, &saved_state);
> >
> >  		spin_lock_irqsave(&lock->wait_lock, flags);
> >  		current->flags |= saved_flags;
> >  		current->lock_depth = saved_lock_depth;
> > -		state = xchg(&current->state, TASK_UNINTERRUPTIBLE);
> > -		if (unlikely(state == TASK_RUNNING))
> > -			saved_state = TASK_RUNNING;
>
>
> Does anyone know the answer to this?
>
> Regards,
> -Greg
>
