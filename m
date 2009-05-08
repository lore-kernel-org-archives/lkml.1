Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbZEHRYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbZEHRYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 13:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbZEHRX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 13:23:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47785 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596AbZEHRX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 13:23:56 -0400
Date: Fri, 8 May 2009 13:23:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 4/4] ring-buffer: change WARN_ON from checking preempt_count
 to preemptible
In-Reply-To: <20090508095604.1f5ad960.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0905081307300.6116@gandalf.stny.rr.com>
References: <20090508043250.372421144@goodmis.org> <20090508043331.726786617@goodmis.org> <20090507215427.4256cc3c.akpm@linux-foundation.org> <alpine.DEB.2.00.0905080653110.28378@gandalf.stny.rr.com> <20090508095604.1f5ad960.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 8 May 2009, Andrew Morton wrote:

> On Fri, 8 May 2009 06:53:48 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > 
> > > > diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> > > > index 3ae5ccf..3611706 100644
> > > > --- a/kernel/trace/ring_buffer.c
> > > > +++ b/kernel/trace/ring_buffer.c
> > > > @@ -1688,7 +1688,7 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
> > > >  	 * committed yet. Thus we can assume that preemption
> > > >  	 * is still disabled.
> > > >  	 */
> > > > -	RB_WARN_ON(buffer, !preempt_count());
> > > > +	RB_WARN_ON(buffer, preemptible());
> > > >  
> > > >  	cpu = smp_processor_id();
> > > >  	cpu_buffer = buffer->buffers[cpu];
> > > 
> > > smp_processor_id() will warn too.
> > > 
> > 
> > The difference is that RB_WARN_ON also disables the ring buffer.
> > 
> 
> Yes, but the kernel will produce two large warning spews for the
> same thing.

Hmm, I should go back to my original patch. Which was:

	RB_WARN_ON_PREEMPT(buffer, !preempt_count());

and have at the top of the file:

#ifdef CONFIG_PREEMPT
# RB_WARN_ON_PREEMPT(buffer, cond)  RB_WARN_ON(buffer, cond)
#else
# RB_WARN_ON_PREEMPT(buffer, cond)  do { } while (0)
#endif

The difference here is not that preemption must be off, but that this must 
be called from after a ring_buffer_lock_reserve() but not after a 
ring_buffer_unlock_commit().

We have two methods to discard a change, one is to discard it instead of 
commiting it. This will try to totally remove the change without leaving 
holes. The ring buffer is reentrant, and if an interrupt were to happen 
in between reserve and commit, it could store data after this commit. In 
which case we have no choice but to leave a hole. But if that did not 
happen, then we use cmpxchg to reset the tail of the buffer back to the 
original and not have to worry about NMIs and interrupts.

The other version of discarding can be done after a commit. But it only 
changes the type of the data and a hole exits. If we did this for all 
discards, the ring buffer would be wasted with discarded material and the 
filtering would be useless.

The original code only had the discard with a hole, and that was done 
after the commit. After converting it over, to the new method, several 
places still had the discard after the commit, and that broke the ring 
buffer.

There's no easy way to catch this, and do it fast. Since preemption is 
always disabled between reserve and commit, I was able to find places that 
broke this (and even new places that were added) by simply checking if 
preemption is disabled. Note, preemptible() is actually wrong because it 
also checks if interrupts are disabled, and if interrupts are disabled but 
preemption is not, we miss the case as well.

In any case, if this happens then the ring buffer will be corrupted, and 
it is best to disable it. Having two big warnings will help have these 
errors stick out more :-)

Actually, the way I've noticed it (when it happened on my laptop) was when 
I ran the trace and got no output. Then I decided to do a dmesg to see 
why. If I just saw garbage (or even worse, a crash) then I would not have 
looked right away at the dmesg. A crash would have prevented me from 
looking at dmesg if it locked up my laptop.

-- Steve

