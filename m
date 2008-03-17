Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbYCQIyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbYCQIyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 04:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYCQIy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 04:54:29 -0400
Received: from n57.bullet.mail.sp1.yahoo.com ([98.136.44.49]:39136 "HELO
	n57.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752756AbYCQIy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 04:54:28 -0400
X-Yahoo-Newman-Id: 813959.42474.bm@omp421.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eWYHng4rd60NxIASmRkzpZQkToDOQ9kTwPkeWA0pk4J73b8y3ZLdKAngvNvsZiOrsESzIoY/D11A+rX+tWbS2HNpEuHYLvhi43CfZqg/vh8pJZL/0hopZ9VI3jrVg41sfI3VzlAuZaCiSp2tEy4ha1e/2qbDhlr2sl/oKkowSMM=  ;
X-YMail-OSG: AHfz92gVM1mLt9tOUzykNJdLUoX6.bLk4S6MJuH2hDy.wVX20mzSl963Q8ZaA9byy1rqsIsItw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
Date: Mon, 17 Mar 2008 19:54:00 +1100
User-Agent: KMail/1.9.5
Cc: Ray Lee <ray-lk@madrabbit.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, "LKML," <linux-kernel@vger.kernel.org>
References: <200803111749.29143.nickpiggin@yahoo.com.au> <200803171819.38892.nickpiggin@yahoo.com.au> <20080317082638.GB18229@1wt.eu>
In-Reply-To: <20080317082638.GB18229@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803171954.01315.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008 19:26, Willy Tarreau wrote:
> On Mon, Mar 17, 2008 at 06:19:38PM +1100, Nick Piggin wrote:

> > Your ssh session should be allowed to run anyway. I don't see the
> > difference. If the runqueue length is 100 and the time-slice is (say)
> > 10ms, then if your ssh only needs average of 5ms of CPU time per second,
> > then it should be run next when it becomes runnable. If it wants 20ms of
> > CPU time per second, then it has to wait for 2 seconds anyway to be run
> > next, regardless of whether the timeslice was 10ms or 20ms.
>
> It's not about what *ssh* uses but about what *others* use. Except by
> renicing SSH or marking it real-time, it has no way to say "give the
> CPU to me right now, I have something very short to do". So it will
> have to wait for the 100 other tasks to eat their 10ms, waiting 1 second
> to consume 5ms of CPU (and I was speaking about 800 and not 100).

Um, if ssh is not using as much CPU time as the other processes running,
(if it has "something very short to do") then yes it should get the CPU
*right now*, regardless of what the timeslice size is. If it *is* using
as much CPU time as everyone else, then it will have to wait to get time,
just like everybody else; and in that case, lowering the timeslice will
not help matters at all because consider if ssh has to compute for 20ms
before returning control to the user, then with a 10ms timeslice it just
has to wait for 2 slices. So in that case you actually do want a longer
and more efficient timeslice so everybody (including ssh) can get their
job done faster.


> > > Large time-slices are needed only in HPC environments IMHO, where only
> > > one task runs.
> >
> > That's silly. By definition if there is only one task running, you don't
> > care what the timeslice is.
>
> I mean there's only one important task. There is always a bit of pollution
> around it, and interrupting the tasks less often slightly reduces the
> context-switch overhead.

I think it is important for many situations, not only just HPC at all.
Just because tpc-c runs are set up so the number of server threads
exactly matches the number of cpus, doesn't mean that real world servers
don't run into lots of different overload conditions. And yes, cache
efficiency does matter for those too, not just HPC.


> > We actually did conduct some benchmarks, and a 10ms timeslice can start
> > hurting even things like kbuild quite a bit.
> >
> > But anyway, I don't care what the time slice is so much (although it
> > should be higher -- if the scheduler can't get good interactive behaviour
> > with a 20-30ms timeslice in most cases then it's no good IMO). I care
> > mostly that the timeslice does not decrease when load increases.
>
> On the opposite, I think it's a fundamental requirement if you need to
> maintain a reasonable interactivity, and a fair progress between all
> tasks. I think it's obvious to understand that the only way to maintain
> a constant latency with a growing number of tasks is to reduce the time
> each task may spend on the CPU. Contrary to other domains such as network,
> you don't know how much time a task will spend on the CPU if you grant an
> access to it, and there is no way to know because only the work that this
> task will perform will determine if it should run shorter or longer. Fair
> scheduling in other areas such as network is "easier" because you know the
> size of your packets so you know how much time they will take on the wire.
>
> Here with tasks, the best you can do is estimating based on history. But
> it will be very rare when you'll be able to correctly guess and guarantee
> that the latency is correct.
>
> Maybe the timeslices should shrink only past a certain load though (I don't
> know how it's done today).

You are just asserting that shorter timeslices are more interactive.
As far as I know (aside from implementation details of a given scheduler),
that assertion only holds in general for a small number of things like
for example video playing or 3d graphics that adaptively scale back their
output as they get starved for CPU (it might be better to drop every 2nd
frame than to drop 10 frames every 20). I doubt there are many server side
apps like that. What you really need on your server is to give ssh more 
priority than your 800 spam threads. You can do that *properly* with nice
or with this group fairness stuff. Lowering timeslices is basically
shooting in the dark.

