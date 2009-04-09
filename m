Return-Path: <linux-kernel-owner+w=401wt.eu-S934322AbZDIQOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934322AbZDIQOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 12:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757404AbZDIQOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 12:14:10 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:57678 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbZDIQOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 12:14:09 -0400
Date: Thu, 9 Apr 2009 18:14:04 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mutex: have non-spinning mutexes on s390 by default
Message-ID: <20090409181404.71ac2988@osiris.boeblingen.de.ibm.com>
In-Reply-To: <1239292496.7647.607.camel@twins>
References: <20090409174758.74abec87@osiris.boeblingen.de.ibm.com>
	<1239292496.7647.607.camel@twins>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Apr 2009 17:54:56 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> > Index: linux-2.6/kernel/sched_features.h
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched_features.h
> > +++ linux-2.6/kernel/sched_features.h
> > @@ -14,4 +14,8 @@ SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
> >  SCHED_FEAT(ASYM_EFF_LOAD, 1)
> >  SCHED_FEAT(WAKEUP_OVERLAP, 0)
> >  SCHED_FEAT(LAST_BUDDY, 1)
> > +#ifdef CONFIG_HAVE_DEFAULT_NO_SPIN_MUTEXES
> > +SCHED_FEAT(OWNER_SPIN, 0)
> > +#else
> >  SCHED_FEAT(OWNER_SPIN, 1)
> > +#endif
> 
> Hmm, I'd rather have you'd make the whole block in __mutex_lock_common
> go away on that CONFIG thingy.

Sure, I can do that.

> Would be nice though to get something working on s390, does it have a
> monitor wait like ins where it can properly sleep so that another
> virtual host can run?
> 
> If so, we could possibly do a monitor wait on the lock owner field
> instead of spinning.

What we now have: the cpu_relax() implementation on s390 will yield the
current (virtual) cpu and give it back to the hypervisor. If the
hypervisor has nothing else to schedule or for fairness reasons decides
that this cpu has to run again it will be scheduled again.
One roundtrip (exit/reenter) is quite expensive (~1200 cycles).

We also have a directed yield where you can tell the hypervisor "don't
schedule me again until cpu x was has been scheduled".

And we have an IPI (signal processer with order code sense running)
which examines if the target cpu is actually physically backed. That's
in the order of ~80 cycles. At least that's what I just measured with
two hypervisors running below my Linux kernel.

So the idea for the spinning loop would be to additionaly test if the
targer cpu is physically backed. If it is we could happily spin and
sense again, more or less like the current code does.
Now the question is what do we do if it isn't backed? Yield the current
cpu in favour of the target cpu or just make the current process sleep
and schedule a different one?
For that I'd like to have performance numbers before we go in any
direction.. It might take some time to get the numbers since it's not
easy to get a slot for performance measurements.
