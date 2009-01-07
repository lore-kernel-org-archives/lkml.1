Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbZAGGd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbZAGGd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 01:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZAGGdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 01:33:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:55190 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbZAGGdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 01:33:13 -0500
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
In-Reply-To: <49642829.20006@cn.fujitsu.com>
References: <87r63ljzox.fsf@basil.nowhere.org>
	 <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>
	 <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins>
	 <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com>
	 <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>
	 <49636799.1010109@novell.com>  <20090106214229.GD6741@linux.vnet.ibm.com>
	 <1231278275.11687.111.camel@twins>
	 <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain>
	 <1231279660.11687.121.camel@twins>
	 <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain>
	 <1231281801.11687.125.camel@twins>  <49642829.20006@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Jan 2009 07:32:50 +0100
Message-Id: <1231309970.11687.163.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 11:57 +0800, Lai Jiangshan wrote:
> Peter Zijlstra wrote:
> > +void mutex_spin_or_schedule(struct mutex_waiter *waiter, long state, unsigned long *flags)
> > +{
> > +	struct mutex *lock = waiter->lock;
> > +	struct task_struct *task = waiter->task;
> > +	struct task_struct *owner = lock->owner;
> > +	struct rq *rq;
> > +
> > +	if (!owner)
> > +		goto do_schedule;
> > +
> > +	rq = task_rq(owner);
> > +
> > +	if (rq->curr != owner) {
> > +do_schedule:
> > +		__set_task_state(task, state);
> > +		spin_unlock_mutex(&lock->wait_lock, *flags);
> > +		schedule();
> > +	} else {
> > +		spin_unlock_mutex(&lock->wait_lock, *flags);
> > +		for (;;) {
> > +			/* Stop spinning when there's a pending signal. */
> > +			if (signal_pending_state(state, task))
> > +				break;
> > +
> > +			/* Owner changed, bail to revalidate state */
> > +			if (lock->owner != owner)
> > +				break;
> > +
> > +			/* Owner stopped running, bail to revalidate state */
> > +			if (rq->curr != owner)
> > +				break;
> > +
> 
> 2 questions from my immature thought:
> 
> 1) Do we need keep gcc from optimizing when we access lock->owner
>    and rq->curr in the loop?

cpu_relax() is a compiler barrier iirc.

> 2) "if (rq->curr != owner)" need become smarter.
>    schedule()
>    {
> 	select_next
> 	rq->curr = next;
> 	contex_swith
>    }
> we also spin when owner is select_next-ing in schedule().
> but select_next is not fast enough.

I'm not sure what you're saying here..
