Return-Path: <linux-kernel-owner+w=401wt.eu-S1760543AbXENUVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760543AbXENUVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757214AbXENUVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:21:18 -0400
Received: from dodo.cs.umass.edu ([128.119.242.12]:46061 "EHLO
	dodo.cs.umass.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbXENUVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:21:17 -0400
Message-ID: <4648C49D.3070909@cs.umass.edu>
Date: Mon, 14 May 2007 16:20:45 -0400
From: Ting Yang <tingy@cs.umass.edu>
Reply-To: tingy@cs.umass.edu
Organization: ALI Lab, CS Dept, UMASS
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       efault@gmx.de, linux-kernel@vger.kernel.org
Subject: Re: fair clock use in CFS
References: <20070514083358.GA29775@in.ibm.com> <20070514102929.GL31925@holomorphy.com> <20070514103120.GA23766@elte.hu> <20070514110500.GV19966@holomorphy.com> <20070514112259.GC28348@in.ibm.com> <20070514112016.GW19966@holomorphy.com>
In-Reply-To: <20070514112016.GW19966@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


William Lee Irwin III wrote:
> On Mon, May 14, 2007 at 04:52:59PM +0530, Srivatsa Vaddagiri wrote:
>   
>> Doesn't EEVDF have the same issue? From the paper:
>> 	V(t) = 1/(w1 + w2 + ...wn)
>>     
>
> Who knows what I was smoking, then. I misremembered the scale factor
> as being on the other side of comparisons with the queue's clock. I'm
> suspicious of EEVDF's timekeeping now as well.
>
>   
Both CFS and EEVDF uses the queue virtual time (VT) to measure the total 
amount of work done so far, VT maps to different real time scale as the 
workload in the system varies. It provides a measure for task to check 
if it goes ahead or falls behind.

Suppose, each task p maintain its own  virtual time, which  is advance 
reverse proportional to its weight
    VT_p(t + 1)  = VT_p(t) + 1/w_p
(in fact, CFS uses this to calculate p->delta_mine, EEVDF uses this to 
decide the deadline for a given slice of work by adding l_p/w_p to 
virtual start time.)
At the time when VT_p(t) = VT(t), i.e. at time t, the virtual time of a 
task equals the virtual time of the queue, this task has received its 
entitled share in interval [0, t]. If VT_p(t) < VT(p), it falls behind 
than it should, otherwise it goes ahead than it should.

Both CFS and EEVDF uses this measure implicitly to decide when a task 
should be executed. The difference is that CFS allows the amount of 
carried out by a task of weight w_i to be continuously executed until it 
goes ahead what it should by a certain amount (tuned and scaled 
accordingly). While EEVDF has to give out a slice (since it is deadline 
driven), and forces a potential long work to be done in smaller slices 
and interleaved with other tasks. Combined with eligibility check, EEVDF 
provides better "fairness" (only in the sense that work spread out more 
evenly in relative short window, since nobody can continuously do more 
than l_i amount of work) with the overhead of _more_ context switches.

It is really difficult for me to say which one is better.  In 
particular, the current CFS implementation favors  higher weight tasks. 
The granularity used by higher weight task is scaled up, which allows it 
to go ahead more (as it is possibly more important and should make it 
finish as early as possible.), while lower weight task has no such 
ability. This makes a lot sense to me.


Ting
