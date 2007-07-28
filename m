Return-Path: <linux-kernel-owner+w=401wt.eu-S938538AbXG1Abg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938538AbXG1Abg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 20:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764630AbXG1AbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 20:31:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761185AbXG1AbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 20:31:24 -0400
Message-ID: <46AA8E57.8010105@redhat.com>
Date: Fri, 27 Jul 2007 20:31:19 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: tim.c.chen@linux.intel.com
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: Volanomark slows by 80% under CFS
References: <1185573687.19777.44.camel@localhost.localdomain>
In-Reply-To: <1185573687.19777.44.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Chen wrote:
> Ingo,
> 
> Volanomark slows by 80% with CFS scheduler on 2.6.23-rc1.  
> Benchmark was run on a 2 socket Core2 machine.
> 
> The change in scheduler treatment of sched_yield 
> could play a part in changing Volanomark behavior.
> In CFS, sched_yield is implemented
> by dequeueing and requeueing a process .  The time a process 
> has spent running probably reduced the the cpu time due it 
> by only a bit. The process could get re-queued pretty close
> to head of the queue, and may get scheduled again pretty
> quickly if there is still a lot of cpu time due.  
> 
> It may make sense to queue the
> yielding process a bit further behind in the queue. 
> I made a slight change by zeroing out wait_runtime 
> (i.e. have the process gives
> up cpu time due for it to run) for experimentation. 
> Let's put aside gripes that Volanomark should have used a 
> better mechanism to coordinate threads instead sched_yield for 
> a second.   Volanomark runs better
> and is only 40% (instead of 80%) down from old scheduler 
> without CFS.  
> 
> Of course we should not tune for Volanomark and this is
> reference data. 
> What are your view on how CFS's sched_yield should behave?
> 
> Regards,
> Tim

The primary purpose of sched_yield is for SCHED_FIFO realtime processes.  Where 
nothing else will run, ever, unless the running thread blocks or yields the CPU. 
  Under CFS, the yielding process will still be leftmost in the rbtree, 
otherwise it would have already been scheduled out.

Zeroing out wait_runtime on sched_yield strikes me as completely appropriate. 
If the process wanted to sleep a finite duration, it should actually call a 
sleep function, but sched_yield is essentially saying "I don't have anything 
else to do right now", so it's hardly fair to claim you've been waiting for your 
chance when you just gave it up.

As for the remaining 40% degradation, if Volanomark is using it for 
synchronization, the scheduler is probably cycling through threads until it gets 
to the one that actually wants to do work.  The O(1) scheduler will do this very 
  quickly, whereas CFS has a bit more overhead.  Interactivity boosting may have 
also helped the old scheduler find the right thread faster.

I think Volanomark is being pretty stupid, and deserves to run slowly, but there 
are legitimate reasons to want to call sched_yield in a non-SCHED_FIFO process. 
  If I'm performing multiple different calculations on the same set of data in 
multiple threads, and accessing the shared data in a linear fashion, I'd like to 
be able to have one thread give the other some CPU time so they can stay at the 
same point in the stream and improve cache hit rates, but this is only an 
optimization if I can do it without wasting CPU or gradually nicing myself into 
oblivion.  Having sched_yield zero out wait_runtime seems like an appropriate 
way to make this use case work to the extent possible.  Any user attempting such 
an optimization should have the good sense to do real work between sched_yield 
calls, to avoid calling the scheduler in a tight loop.

	-- Chris
