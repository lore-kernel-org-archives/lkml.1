Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbXIDLVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbXIDLVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 07:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbXIDLVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 07:21:13 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4145 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbXIDLVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 07:21:12 -0400
Date: Tue, 4 Sep 2007 13:21:40 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE/RFC] Really Simple Really Fair Scheduler
In-Reply-To: <20070904062957.GA25634@elte.hu>
Message-ID: <Pine.LNX.4.64.0709041244080.1817@scrub.home>
References: <20070902120154.GA23769@elte.hu> <Pine.LNX.4.64.0709032030320.1817@scrub.home>
 <20070903185403.GA23479@elte.hu> <Pine.LNX.4.64.0709032106070.1817@scrub.home>
 <20070903192050.GA29049@elte.hu> <Pine.LNX.4.64.0709032140140.1817@scrub.home>
 <20070903200405.GA2943@elte.hu> <Pine.LNX.4.64.0709040130360.1817@scrub.home>
 <20070904062957.GA25634@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 4 Sep 2007, Ingo Molnar wrote:

> and what about the mirror image problem?

Sorry, I'm not familiar with that in a scheduler context.

> Your math assumes that tasks 
> use up their full timeslices, somewhere starting at (12):
> 
> | (12)    time_norm_app = sum_{t}^{T}(time_norm_{t} * weight_{t}) /
> |                                            sum_{t}^{T}(weight_{t})
> |
> | This produces only a approximate normalized time, but if all 
> | time_norm_{t} are equal (i.e. all tasks got their share), the result 
> | is the same, thus the error is only temporary.
> 
> >From here on the reasoning and the math is flawed i believe: it assumes 
> that tasks use up their timeslices - which is rarely the case.

I'm not sure what you're refering to. The remaining math basically only 
deals with the average calculation and if we're still at your simplified 
model, then it's largely irrevelant, because the approximation error only 
comes into effect with different weights. This means for the common case, 
you can assume my code produces a perfect average.

> In practical terms: your code causes unfairness to tasks that sleep when 
> they have used up only a fraction of their slice, when they are in a 
> fairness-deficit. For example consider a task that just waited alot to 
> get on the CPU, and when it finally got there (gathering a fairness 
> deficit of say 9 milliseconds), a hundred microseconds later it sleeps.
> 
> The problem is that when it wakes up and gets back on the runqueue your 
> code "forgets" that the task is in "need of fairness" by 9 milliseconds: 
> the task continues as if its previous starvation didnt happen at all. 

Please put this into more context, e.g. demonstrate how this problem 
doesn't exist in CFS. My code should largely mirror CFS behaviour with the 
exception that the bonus maybe isn't as big and this:

        if (sysctl_sched_features & SCHED_FEAT_SLEEPER_AVG)
                delta_fair = div64_likely32((u64)delta_fair * load,
                                                load + se->load.weight);


> This effect can cause _far more noise_ and even systematic starvation 
> than any numeric rounding effects could cause. (This could perhaps 
> explain the unfairness Mike reported, and this could perhaps explain the 
> noisy hackbench results i'm seeing with your patch - although i'm not 
> certain about this, i havent looked into those usecases in detail.)

The problem Mike reported looks more like a bug, I'm puzzled why the 
verify code didn't trigger as the whole thing was pretty much out of sync, 
so in the next version I'll add a few more checks, but I'm not finished 
with the hackbench results yet.

> CFS's current math addresses this problem via the use of the fair-clock 
> metric and via ->wait_runtime: that gives us a good idea what happened 
> to the system while the task slept. With your model, that information is 
> not maintained at all, and is not regainable. At the moment i dont see 
> how we could achieve good sleeper behavior with your model, you've 
> over-simplified the scheduler metrics and we've lost essential 
> information.

Please describe this sleeper behaviour, what kind of sleeper do you have 
in mind exactly? If we take for example interactive tasks, these should be 
constantly behind other running tasks and thus have an advantage at 
getting the cpu, i.e. if a task doesn't use up its time slice its runtime 
value won't advance as much as of other tasks which do use their slice.

bye, Roman
