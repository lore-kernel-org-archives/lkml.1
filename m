Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbXEBFLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbXEBFLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbXEBFLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:11:10 -0400
Received: from 1wt.eu ([62.212.114.60]:2468 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbXEBFLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:11:07 -0400
Date: Wed, 2 May 2007 07:10:49 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ting Yang <tingy@cs.umass.edu>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070502051049.GA943@1wt.eu>
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4637FE0A.7090405@cs.umass.edu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ting,

On Tue, May 01, 2007 at 10:57:14PM -0400, Ting Yang wrote:
> 
> Hi, Ingo
> 
>  My name is Ting Yang, a graduate student from UMASS. I am currently 
> studying the linux scheduler and virtual memory manager to solve some 
> page swapping problems. I am very excited with the new scheduler CFS. 
> After I read through your code, I think that you might be interested in 
> reading this paper:
> 
>  "A Proportional Share REsource Allocation Algorithm for Real-Time, 
> Time-Shared Systems", by Ion Stoica. You can find the paper here: 
> http://citeseer.ist.psu.edu/37752.html
> 
>  Authors of this paper proposed a scheduler: Earlist Eligible Virtual 
> Deadline First (EEVDF). EEVDF uses exactly the same method as CFS to 
> track the execution of each running task. The only difference between 
> EEVDF and CFS is that EEVDF tries to _deadline_ fair while CFS is 
> _start-time_ fair. Scheduling based on deadline gives better reponse 
> time bound and seems to more fair.
> 
>  In the following part of this email, I will try to explain the 
> similarities and differences between EEVDF and CFS. Hopefully, this 
> might provide you with some useful information w.r.t your current work 
> on CFS.

(...)
Thanks very much for this very clear explanation. Now I realize that
some of the principles I've had in mind for a long time already exist
and are documented ! That's what I called sorting by job completion
time in the past, which might not have been clear for everyone. Now
you have put words on all those concepts, it's more clear ;-)

> The decouple of weight w_i and timeslice l_i is important. Generally 
> speaking, weight determines throughput and timeslice determines the 
> responsiveness of a task.

I 100% agree. That's the problem we have with nice today. Some people
want to use nice to assign more CPU to tasks (as has always been for
years) and others want to use nice to get better interactivity (meaning
nice as when you're in a queue and leaving the old woman go before you).

IMHO, the two concepts are opposed. Either you're a CPU hog OR you get
quick responsiveness.

> In normal situation, high priority tasks 
> usually need more cpu capacity within short period of time (bursty, such 
> as keyboard, mouse move, X updates, daemons, etc), and need to be 
> processed as quick as possible (responsiveness and interactiveness). 
> Follow the analysis above, we know that for higher priority tasks we 
> should give _higher weight_ to ensure its CPU throughput, and at the 
> same time give _smaller timeslice_ to ensure better responsiveness.  
> This is a bit counter-intuitive against the current linux 
> implementation: smaller nice value leads to higher weight and larger 
> timeslice.

We have an additional problem in Linux, and not the least : it already
exists and is deployed everywhere, so we cannot break existing setups.
More specifically, we don't want to play with nice values of processes
such as X.

That's why I think that monitoring the amount of the time-slice (l_i)
consumed by the task is important. I proposed to conserve the unused
part of l_i as a credit (and conversely the credit can be negative if
the time-slice has been over-used). This credit would serve two purposes :

  - reassign the unused part of l_i on next time-slices to get the
    most fair share of CPU between tasks

  - use it as an interactivity key to sort the tasks. Basically, if
    we note u_i the unused CPU cycles, you can sort based on
    (d_i - u_i) instead of just d_i, and the less hungry tasks will
    reach the CPU faster than others.

(...)

>  Based on my understanding, adopting something like EEVDF in CFS should 
> not be very difficult given their similarities, although I do not have 
> any idea on how this impacts the load balancing for SMP. Does this worth 
> a try?

I think that if you have time to spend on this, everyone would like to
see the difference. All the works on the scheduler are more or less
experimental and several people are exchanging ideas right now, so it
should be the right moment. You seem to understand very well both
approaches and it's likely that it will not take you too much time :-)


> Sorry for such a long email :-)

It was worth it, thanks !

Willy

