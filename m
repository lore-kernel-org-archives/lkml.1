Return-Path: <linux-kernel-owner+w=401wt.eu-S1765356AbXEVMDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765356AbXEVMDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 08:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757023AbXEVMDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 08:03:24 -0400
Received: from omta01sl.mx.bigpond.com ([144.140.92.153]:45778 "EHLO
	omta01sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749AbXEVMDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 08:03:23 -0400
Message-ID: <4652DC03.60801@bigpond.net.au>
Date: Tue, 22 May 2007 22:03:15 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
References: <20070513153853.GA19846@elte.hu> <464A6698.3080400@bigpond.net.au>	 <20070516063625.GA9058@elte.hu> <464CE8FD.4070205@bigpond.net.au>	 <20070518071325.GB28702@elte.hu> <464DA61A.4040406@bigpond.net.au> <b647ffbd0705210825y25331066x8b2a4d50cdb7c266@mail.gmail.com> <46523081.6050007@bigpond.net.au> <465275EF.8060905@bigpond.net.au>
In-Reply-To: <465275EF.8060905@bigpond.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta01sl.mx.bigpond.com from [60.231.45.148] using ID pwil3058@bigpond.net.au at Tue, 22 May 2007 12:03:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Williams wrote:
> Peter Williams wrote:
>> Dmitry Adamushko wrote:
>>> On 18/05/07, Peter Williams <pwil3058@bigpond.net.au> wrote:
>>> [...]
>>>> One thing that might work is to jitter the load balancing interval a
>>>> bit.  The reason I say this is that one of the characteristics of top
>>>> and gkrellm is that they run at a more or less constant interval (and,
>>>> in this case, X would also be following this pattern as it's doing
>>>> screen updates for top and gkrellm) and this means that it's possible
>>>> for the load balancing interval to synchronize with their intervals
>>>> which in turn causes the observed problem.
>>>
>>> Hum.. I guess, a 0/4 scenario wouldn't fit well in this explanation..
>>
>> No, and I haven't seen one.
>>
>>> all 4 spinners "tend" to be on CPU0 (and as I understand each gets
>>> ~25% approx.?), so there must be plenty of moments for
>>> *idle_balance()* to be called on CPU1 - as gkrellm, top and X consume
>>> together just a few % of CPU. Hence, we should not be that dependent
>>> on the load balancing interval here..
>>
>> The split that I see is 3/1 and neither CPU seems to be favoured with 
>> respect to getting the majority.  However, top, gkrellm and X seem to 
>> be always on the CPU with the single spinner.  The CPU% reported by 
>> top is approx. 33%, 33%, 33% and 100% for the spinners.
>>
>> If I renice the spinners to -10 (so that there load weights dominate 
>> the run queue load calculations) the problem goes away and the spinner 
>> to CPU allocation is 2/2 and top reports them all getting approx. 50% 
>> each.
> 
> For no good reason other than curiosity, I tried a variation of this 
> experiment where I reniced the spinners to 10 instead of -10 and, to my 
> surprise, they were allocated 2/2 to the CPUs on average.  I say on 
> average because the allocations were a little more volatile and 
> occasionally 0/4 splits would occur but these would last for less than 
> one top cycle before the 2/2 was re-established.  The quickness of these 
> recoveries would indicate that it was most likely the idle balance 
> mechanism that restored the balance.
> 
> This may point the finger at the tick based load balance mechanism being 
> too conservative

The relevant code, find_busiest_group() and find_busiest_queue(), has a 
lot of code that is ifdefed by CONFIG_SCHED_MC and CONFIG_SCHED_SMT and, 
as these macros were defined in the kernels I was testing with, I built 
a kernel with these macros undefined and reran my tests.  The 
problems/anomalies were not present in 10 consecutive tests on this new 
kernel.  Even better on the few occasions that a 3/1 split did occur it 
was quickly corrected to 2/2 and top was reporting approx 49% of CPU for 
all spinners throughout each of the ten tests.

So all that is required now is an analysis of the code inside the ifdefs 
to see why it is causing a problem.

> in when it decides whether tasks need to be moved.  In 
> the case where the spinners are at nice == 0, the idle balance mechanism 
> never comes into play as the 0/4 split is never seen so only the tick 
> based mechanism is in force in this case and this is where the anomalies 
> are seen.
> 
> This tick rebalance mechanism only situation is also true for the nice 
> == -10 case but in this case the high load weights of the spinners 
> overcomes the tick based load balancing mechanism's conservatism e.g. 
> the difference in queue loads for a 1/3 split in this case is the 
> equivalent to the difference that would be generated by an imbalance of 
> about 18 nice == 0 spinners i.e. too big to be ignored.
> 
> The evidence seems to indicate that IF a rebalance operation gets 
> initiated then the right amount of load will get moved.
> 
> This new evidence weakens (but does not totally destroy) my 
> synchronization (a.k.a. conspiracy) theory.

My synchronization theory is now dead.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
