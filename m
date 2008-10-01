Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbYJAPgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbYJAPgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 11:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYJAPgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 11:36:38 -0400
Received: from relais.videotron.ca ([24.201.245.36]:58434 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYJAPgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 11:36:37 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 01 Oct 2008 11:36:31 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: David Howells <dhowells@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-am33-list@redhat.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] MN10300: Move asm-arm/cnt32_to_63.h to include/linux/
In-reply-to: <29968.1222871650@redhat.com>
Message-id: <alpine.LFD.2.00.0810011110440.3635@xanadu.home>
References: <alpine.LFD.2.00.0809282123100.3635@xanadu.home>
 <20080924164826.14867.63020.stgit@warthog.procyon.org.uk>
 <1222426580.16700.258.camel@lappy.programming.kicks-ass.net>
 <alpine.LFD.2.00.0809260802310.3635@xanadu.home>
 <1222431635.16700.278.camel@lappy.programming.kicks-ass.net>
 <29968.1222871650@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008, David Howells wrote:

> Nicolas Pitre <nico@cam.org> wrote:
> 
> > Disabling preemption is unneeded.
> 
> I think you may be wrong on that.  MEI came up with the following point:
> 
> 	I think either disable preemption or disable interrupt is really
> 	necessary for cnt32_to_63 macro, because there seems to be assumption
> 	that the series of the code (1)-(4) must be executed within a half
> 	period of the 32-bit counter.

This is still wrong.  There is no need for any kind of locking what so 
ever, period.  That's the _point_ of the whole algorithm.  The only 
constraint is that the code has to be executed at least once per half 
period of the 32 bit counter, which is typically once every couple 
minutes or so.

> 	-------------------------------------------------
> 	#define cnt32_to_63(cnt_lo) 
> 	({ 
> 	       static volatile u32 __m_cnt_hi = 0; 
> 	       cnt32_to_63_t __x; 
> 	(1)    __x.hi = __m_cnt_hi; 
> 	(2)    __x.lo = (cnt_lo); 
> 	(3)    if (unlikely((s32)(__x.hi ^ __x.lo) < 0))
> 	(4)            __m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); 
> 	       __x.val; 
> 	})
> 	-------------------------------------------------
> 
> 	If a task is preempted while executing the series of the code and
> 	scheduled again after the half period of the 32-bit counter, the task
> 	may destroy __m_cnt_hi.

Oh, that's a possibility.  In that case __m_cnt_hi will be reverted to a 
previous state just like if cnt32_to_63() has not been called yet since 
the new half period.  And a subsequent call will fix that again.

> Their suggested remedy is:
> 
> 	So I think it's better to disable interrupt the cnt32_to_63 and to
> 	ensure that the series of the code are executed within a short period.
> 
> I think this is excessive...  If we're sat there with interrupts disabled for
> more than a half period (65s) then we've got other troubles.  I think
> disabling preemption for the duration ought to be enough.  What do you think?

I think this is excessive too.  If you're preempted away for that long 
you still have a problem.  And if that's a real concern because you run 
RT and have tasks frequently blocked for that long then don't use this 
interface for critical counters for which absolute correctness is 
essential, which is not the case for sched_clock() anyway.  A 
sched_clock() implementation is meant to be as lightweight as possible 
even if it lacks in absolute precision, and the worst that could happen 
if you actually manage to cause a glitch in the returned value from 
sched_clock() is possibly the scheduling of the wrong task in a non RT 
scheduler, and we determined that a RT scheduler is needed to cause this 
glitch already.

> Now, I'm happy to put these in sched_clock() rather then cnt32_to_63() for my
> purposes (see attached patch).

If you still feel paranoid about this then I can't stop you from adding 
extra locking in your own code.  On machines I've created cnt32_to_63() 
for, the critical half period delay can be like 9 minutes and worrying 
about races that could last that long is really about ignoring a much 
worse problem.


Nicolas
