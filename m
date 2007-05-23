Return-Path: <linux-kernel-owner+w=401wt.eu-S1763277AbXEWAKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763277AbXEWAKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758714AbXEWAKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:10:21 -0400
Received: from omta01sl.mx.bigpond.com ([144.140.92.153]:35302 "EHLO
	omta01sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758717AbXEWAKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:10:19 -0400
Message-ID: <46538667.9040101@bigpond.net.au>
Date: Wed, 23 May 2007 10:10:15 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
References: <20070513153853.GA19846@elte.hu> <464A6698.3080400@bigpond.net.au>	 <20070516063625.GA9058@elte.hu> <464CE8FD.4070205@bigpond.net.au>	 <20070518071325.GB28702@elte.hu> <464DA61A.4040406@bigpond.net.au>	 <b647ffbd0705210825y25331066x8b2a4d50cdb7c266@mail.gmail.com>	 <46523081.6050007@bigpond.net.au> <b647ffbd0705220452n711a8d1dtdf4cad07a01c8b64@mail.gmail.com>
In-Reply-To: <b647ffbd0705220452n711a8d1dtdf4cad07a01c8b64@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta06sl.mx.bigpond.com from [60.231.45.148] using ID pwil3058@bigpond.net.au at Wed, 23 May 2007 00:10:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> On 22/05/07, Peter Williams <pwil3058@bigpond.net.au> wrote:
>> > [...]
>> > Hum.. I guess, a 0/4 scenario wouldn't fit well in this explanation..
>>
>> No, and I haven't seen one.
> 
> Well, I just took one of your calculated probabilities as something
> you have really observed - (*) below.
> 
> "The probabilities for the 3 split possibilities for random allocation are:
> 
>       2/2 (the desired outcome) is 3/8 likely,
>       1/3 is 4/8 likely, and
>       0/4 is 1/8 likely.            <-------------------------- (*)
> "

These are the theoretical probabilities for the outcomes based on the 
random allocation of 4 tasks to 2 CPUs.  There are, in fact, 16 
different ways that 4 tasks can be assigned to 2 CPUs.  6 of these 
result in a 2/2 split, 8 in a 1/3 split and 2 in a 0/4 split.

> 
>> The split that I see is 3/1 and neither CPU seems to be favoured with
>> respect to getting the majority.  However, top, gkrellm and X seem to be
>> always on the CPU with the single spinner.  The CPU% reported by top is
>> approx. 33%, 33%, 33% and 100% for the spinners.
> 
> Yes. That said, idle_balance() is out of work in this case.

Which is why I reported the problem.

> 
>> If I renice the spinners to -10 (so that there load weights dominate the
>> run queue load calculations) the problem goes away and the spinner to
>> CPU allocation is 2/2 and top reports them all getting approx. 50% each.
> 
> I wonder what would happen if X gets reniced to -10 instead (and
> spinners are at 0).. I guess, something I described in my previous
> mail (and dubbed "unlikely cospiracy" :) could happen, i.e. 0/4 and
> then idle_balance() comes into play..

Probably the same as I observed but it's easier to renice the spinners.

I see the 0/4 split for brief moments if I renice the spinners to 10 
instead of -10 but the idle balancer quickly restores it to 2/2.

> 
> ok, I see. You have probably achieved a similar effect with the
> spinners being reniced to 10 (but here both "X" and "top" gain
> additional "weight" wrt the load balancing).
> 
>> I'm playing with some jitter experiments at the moment.  The amount of
>> jitter needs to be small (a few tenths of a second) as the
>> synchronization (if it's happening) is happening at the seconds level as
>> the intervals for top and gkrellm will be in the 1 to 5 second range (I
>> guess -- I haven't checked) and the load balancing is every 60 seconds.
> 
> Hum.. the "every 60 seconds" part puzzles me quite a bit. Looking at
> the run_rebalance_domain(), I'd say that it's normally overwritten by
> the following code
> 
>               if (time_after(next_balance, sd->last_balance + interval))
>                        next_balance = sd->last_balance + interval;
> 
> the "interval" seems to be *normally* shorter than "60*HZ" (according
> to the default params in topology.h).. moreover, in case of the CFS
> 
>                if (interval > HZ*NR_CPUS/10)
>                        interval = HZ*NR_CPUS/10;
> 
> so it can't be > 0.2 HZ in your case (== once in 200 ms at max with
> HZ=1000).. am I missing something? TIA

No, I did.

But it's all academic as my synchronization theory is now dead -- see 
separate e-mail.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
