Return-Path: <linux-kernel-owner+w=401wt.eu-S1760547AbZCTKiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760547AbZCTKiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760055AbZCTKiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:38:07 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49495 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbZCTKiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:38:06 -0400
To: peterz@infradead.org
CC: miklos@szeredi.hu, mingo@elte.hu, roland@redhat.com, efault@gmx.de,
       rjw@sisk.pl, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
In-reply-to: <1237543392.24626.49.camel@twins> (message from Peter Zijlstra on
	Fri, 20 Mar 2009 11:03:12 +0100)
Subject: Re: [patch] don't preempt not TASK_RUNNING tasks
References: <E1LkbGe-00039U-Hc@pomaz-ex.szeredi.hu> <1237543392.24626.49.camel@twins>
Message-Id: <E1Lkc6U-0003II-W1@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 20 Mar 2009 11:37:30 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Peter Zijlstra wrote:
> On Fri, 2009-03-20 at 10:43 +0100, Miklos Szeredi wrote:
> > Ingo,
> > 
> > I tested this one, and I think it makes sense in any case as an
> > optimization.  It should also be good for -stable kernels.
> > 
> > Does it look OK?
> 
> The idea is good, but there is a risk of preemption latencies here. Some
> code paths aren't real quick between setting ->state != TASK_RUNNING and
> calling schedule.
> 
> [ Both quick: as in O(1) and few instructions ]
> 
> So if we're going to do this, we'd need to audit all such code paths --
> and there be lots.

Oh, yes.

In a random sample the most common pattern is something like this:

	spin_lock(&some_lock);
	/* do something */
	set_task_state(TASK_SOMESLEEP);
	/* do something more */
	spin_unlock(&some_lock);
	schedule();
	...

Which should only positively be impacted by the change.  But I can
imagine rare cases where it's more complex.

> The first line of attack for this problem is making wait_task_inactive()
> sucks less, which shouldn't be too hard, that unconditional 1 jiffy
> sleep is simply retarded.

I completely agree.  However, I'd like to have a non-invasive solution
that can go into current and stable kernels so UML users don't need to
suffer any more.

Thanks,
Miklos

> 
> > Index: linux.git/kernel/sched.c
> > ===================================================================
> > --- linux.git.orig/kernel/sched.c	2009-03-20 09:40:47.000000000 +0100
> > +++ linux.git/kernel/sched.c	2009-03-20 10:28:56.000000000 +0100
> > @@ -4632,6 +4632,10 @@ asmlinkage void __sched preempt_schedule
> >  	if (likely(ti->preempt_count || irqs_disabled()))
> >  		return;
> >  
> > +	/* No point in preempting we are just about to go to sleep. */
> > +	if (current->state != TASK_RUNNING)
> > +		return;
> > +
> >  	do {
> >  		add_preempt_count(PREEMPT_ACTIVE);
> >  		schedule();
> 
