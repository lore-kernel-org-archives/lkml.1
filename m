Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbYJFPHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbYJFPHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 11:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbYJFPHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 11:07:01 -0400
Received: from relais.videotron.ca ([24.201.245.36]:34902 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbYJFPHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 11:07:00 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 06 Oct 2008 11:06:53 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: David Howells <dhowells@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-am33-list@redhat.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] MN10300: Move asm-arm/cnt32_to_63.h to include/linux/
In-reply-to: <19168.1223289862@redhat.com>
Message-id: <alpine.LFD.2.00.0810060959320.3045@xanadu.home>
References: <alpine.LFD.2.00.0810031512420.3045@xanadu.home>
 <alpine.LFD.2.00.0810011110440.3635@xanadu.home>
 <alpine.LFD.2.00.0809282123100.3635@xanadu.home>
 <20080924164826.14867.63020.stgit@warthog.procyon.org.uk>
 <1222426580.16700.258.camel@lappy.programming.kicks-ass.net>
 <alpine.LFD.2.00.0809260802310.3635@xanadu.home>
 <1222431635.16700.278.camel@lappy.programming.kicks-ass.net>
 <29968.1222871650@redhat.com> <1703.1222986215@redhat.com>
 <19168.1223289862@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2008, David Howells wrote:

> Nicolas Pitre <nico@cam.org> wrote:
> 
> > If so then you're using this interface in an inappropriate way.
> > 
> > The _absolute_ minimum frequency with which this should be fully 
> > executed is once per half period of the base counter.  I hope that in 
> > practice it happens far more often than that.
> 
> I think you're misunderstanding my contention.
> 
> If preemption is enabled, cnt32_to_63() can be called with greater than
> minimum frequency and yet reversions can still happen.
> 
> The problem is that a process that's half way through executing cnt32_to_63()
> can be preempted for a period of time sufficient that when it is rescheduled
> and writes __m_cnt_hi, it corrupts it with an out of date value.

I think you're misunderstanding my objection.

if a process that's half way through executing cnt32_to_63()
is preempted for a period of time in the same ball park as the 
half period of the base counter then my point is that you have 
a much bigger problem.

For __m_cnt_hi to be written with an out-of-date value, you'd need 
this sequence of events:

(1)	__x.hi = __m_cnt_hi;
(2)	__x.lo = (cnt_lo);
(3)	if (unlikely((s32)(__x.hi ^ __x.lo) < 0))
(4)		__m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31);

cnt_lo		cnt_hi		instance A	instance B
---------------------------------------------------------------------
0x7fffffff	0x00000000	...
0x80000000	0x00000000	...
[the code isn't called for a _long_ time during which __m_cnt_hi
 is not in synch with the low part]
0xff000000	0x00000000	(1) __x.hi = 0
0xff000001	0x00000000	(2) __x.lo = 0xff000001
0xff000002	0x00000000	(3) condition is true
0xff000003	0x00000000	*** preemption ***
0xff000004	0x00000000			...
[a little while later]
0xffff0000	0x00000000			(1) __x.hi = 0
0xffff0001	0x00000000			(2) __x.lo = 0xffff0001
0xffff0002	0x00000000			(3) condition is true
0xffff0003	0x00000000			(4) update __m_cnt_hi
0xffff0004	0x80000000			...
[a little while later]
0xffffffff	0x80000000			...
0x00000000	0x80000000			...
0x00000001	0x80000000			(1) __x.hi = 0x80000000
0x00000002	0x80000000			(2) __x.lo = 0x00000002
0x00000003	0x80000000			(3) condition is true
0x00000004	0x80000000			(4) update __m_cnt_hi
0x00000005	0x00000001			...
0x00000006	0x00000001			*** preemption ***
0x00000007	0x00000001	(4) update update __m_cnt_hi
0x00000008	0x80000000	...

At this point, it is true that __m_cnt_hi is not up to date while it was 
a moment before.  But that has no consequence because it was reverted 
to the same state before the update at 0x00000004, meaning that the 
update will be redone as soon as the code is executed again.

Sure this could be defeated if 1) the execution in instance B didn't 
come soon enough to notice the initial lack of synchronization before 
the second half period passed, or 2) the duration of the preemption of 
instance A was long enough so not to leave enough time for __m_cnt_hi to 
be corrected back with the current half-period.  But those are extreme 
cases this algorithm is _not_ made for because in practice they should 
_not_ happen.

If the complete code sequence is always executed _at_ _least_ once per 
half-period then you're OK.  That's the theoretical requirement.  In 
practice you should expect it to be called many many times per 
half-period to keep __m_cnt_hi warm.  In my case this is a couple 
hundred times per half period so I'm not worried.

So, if you have a system where 1) this code might not get called for a 
long time _and_ 2) if called it can be preempted away for a long time, 
then you certainly risk having __m_cnt_hi miss a transition.  But in 
that case fixing those issue is way more important than worrying about a 
glitch in the __m_cnt_hi value.


Nicolas
