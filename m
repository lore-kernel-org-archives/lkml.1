Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbXB0XXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbXB0XXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbXB0XXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:23:34 -0500
Received: from mail18.syd.optusnet.com.au ([211.29.132.199]:59456 "EHLO
	mail18.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752581AbXB0XXF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:23:05 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 2)
Date: Wed, 28 Feb 2007 10:07:15 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070227083349.GB30376@elte.hu> <1172566453.7009.28.camel@Homer.simpson.net>
In-Reply-To: <1172566453.7009.28.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702281007.16316.kernel@kolivas.org>
X-Length: 7577
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies for the resend, lkml address got mangled...

On Tuesday 27 February 2007 19:54, Mike Galbraith wrote:
> On Tue, 2007-02-27 at 09:33 +0100, Ingo Molnar wrote:
> > * Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> > > Thomas Gleixner napisa³(a):
> > > > Adrian,
> > > >
> > > > On Mon, 2007-02-26 at 23:05 +0100, Adrian Bunk wrote:
> > > >> Subject    : kernel BUG at kernel/time/tick-sched.c:168 
> > > >> (CONFIG_NO_HZ) References : http://lkml.org/lkml/2007/2/16/346
> > > >> Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> > > I can confirm that the bug is fixed (over 20 hours of testing should
> > > be enough).
> >
> > thanks alot! I think this thing was a long-term performance/latency
> > regression in HT scheduling as well.

Ingo I'm going to have to partially disagree with you on this. 

This has only become a problem because of what happens with dynticks now when 
rq->curr == rq->idle. Prior to this, that particular SMT code only leads to 
relative delays in scheduling for lower priority tasks. Whether or not that 
task is ksoftirqd should not matter because it is not like they are starved 
indefinitely, it is only that nice 19 tasks are relatively delayed, which by 
definition is implied with the usage of nice as a scheduler hint wouldn't you 
say? I know it has been discussed many times before as to whether 'nice' 
means less cpu and/or more latency, but in our current implementation, nice 
means both less cpu and more latency. So to me, the kernels without dynticks 
do not have a regression. This seems to only be a problem in the setting of 
the new dynticks code IMHO. That's not to say it isn't a bug! Nor am I saying 
that dynticks is a problem! Please don't misinterpret that.

The second issue is that this is a problem because of the fuzzy definition of 
what idle is for a runqueue in the setting of this SMT code. Normally, 
rq->curr==rq->idle means the runqueue is idle, but not with this code since 
there are still rq->nr_running on that runqueue. What dynticks in this 
implementation is doing is trying to idle a hyperthread sibling on a cpu 
whose logical partner is busy. I did not find that added any power saving on 
my earlier dynticks implementation, and found it easier to keep that sibling 
ticking at the same rate as its partner. Of course you may have found 
something different, and I definitely agree with what you are likely to say 
in response to this- we shouldn't have to special case logical siblings as 
having a different definition of idle than any other smp case. Ultimately, 
that leaves us with your simple patch as a reasonable solution for the 
dynticks case even though it does change the behaviour dramatically for a 
more loaded cpu. I don't see this code as presenting a problem without or 
prior to the dynticks implementation. You being the scheduler maintainer 
means you get to choose what is the best way to tackle this problem. 

> Agreed.
>
> I was recently looking at that spot because I found that niced tasks
> were taking latency hits, and disabled it, which helped a bunch.

Ok... as I said above to Ingo, nice means more latency too, and there is no 
doubt that if we disable nice as a working feature then the niced tasks will 
have less latency. Of course, this ends up meaning that un-niced tasks no 
longer receive their better cpu performance..  You're basically saying that 
you prefer nice not to work in the setting of HT.

> I also 
> can't understand why it would be OK to interleave a normal task with an
> RT task sometimes, but not others.. that's meaningless to the RT task.

Clearly there would be a reason that code is there... The whole problem with 
HT is that as soon as you load up a sibling, you slow down the logical 
sibling, hence why this code is there in the first place. Since I know you're 
one to test things for yourself, I will put it to you this way:

Boot into UP. Time how long it takes to do a million of these in a real time 
task:
 asm volatile("" : : : "memory");

Then start up a SCHED_NORMAL task fully cpu bound such as "yes > /dev/null" 
and time that again. Obviously the former being a realtime task will take the 
same amount of time and the SCHED_NORMAL task will be starved until the 
realtime task finishes.

Now try the same experiment with hyperthreading enabled and an ordinary SMP 
kernel. You'll find the realtime task runs at only ~60% performance. That's a 
serious performance hit for realtime tasks considering you're running a 
SCHED_NORMAL task. The SMT code that you seem to dislike fixes this problem. 
The reason for interleaving is that there are a few cycles to be gained by 
using the second core for a separate SCHED_NORMAL task, and you don't want to 
disable access to the second core entirely for the duration the realtime task 
is running. Since there is no simple relationship between SCHED_NORMAL 
timeslices and realtime timeslices, we have to use some form of interleaving 
based on the expected extra cycles and HZ is the obvious choice.

> IMHO, SMT scheduling should be a buyer beware thing.  Maximizing your
> core utilization comes at a price, but so does disabling it, so I think
> letting the user decide what he wants is the right thing to do.

To me this is like arguing that we should not implement 'nice' within the cpu 
scheduler at all and only allow nice to work on the few architectures that 
support hardware priorities in the cpu (like power5). Now there is no doubt 
that if we do away with nice entirely everywhere in the scheduler we'll gain 
some throughput. However, nice is a basic unix/linux function and if hardware 
comes along that breaks it working we should be working to make sure that it 
keeps working in software. That is why smt nice and smp nice was implemented. 
Of course it is our duty to ensure we do that at minimal overhead at all 
times. That's a different argument to what you are debating here. The 
throughput should not be adversely affected by this SMT priority code because 
although the nice 19 task gets less throughput, the higher priority task gets 
more as a result, which is essentially what nice is meant to do.

-- 
-ck
