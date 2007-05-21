Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbXEUXvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbXEUXvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbXEUXvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:51:38 -0400
Received: from omta05ps.mx.bigpond.com ([144.140.83.195]:62045 "EHLO
	omta05ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090AbXEUXvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:51:37 -0400
Message-ID: <46523081.6050007@bigpond.net.au>
Date: Tue, 22 May 2007 09:51:29 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
References: <20070513153853.GA19846@elte.hu> <464A6698.3080400@bigpond.net.au>	 <20070516063625.GA9058@elte.hu> <464CE8FD.4070205@bigpond.net.au>	 <20070518071325.GB28702@elte.hu> <464DA61A.4040406@bigpond.net.au> <b647ffbd0705210825y25331066x8b2a4d50cdb7c266@mail.gmail.com>
In-Reply-To: <b647ffbd0705210825y25331066x8b2a4d50cdb7c266@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta07ps.mx.bigpond.com from [60.231.45.148] using ID pwil3058@bigpond.net.au at Mon, 21 May 2007 23:51:35 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> On 18/05/07, Peter Williams <pwil3058@bigpond.net.au> wrote:
> [...]
>> One thing that might work is to jitter the load balancing interval a
>> bit.  The reason I say this is that one of the characteristics of top
>> and gkrellm is that they run at a more or less constant interval (and,
>> in this case, X would also be following this pattern as it's doing
>> screen updates for top and gkrellm) and this means that it's possible
>> for the load balancing interval to synchronize with their intervals
>> which in turn causes the observed problem.
> 
> Hum.. I guess, a 0/4 scenario wouldn't fit well in this explanation..

No, and I haven't seen one.

> all 4 spinners "tend" to be on CPU0 (and as I understand each gets
> ~25% approx.?), so there must be plenty of moments for
> *idle_balance()* to be called on CPU1 - as gkrellm, top and X consume
> together just a few % of CPU. Hence, we should not be that dependent
> on the load balancing interval here..

The split that I see is 3/1 and neither CPU seems to be favoured with 
respect to getting the majority.  However, top, gkrellm and X seem to be 
always on the CPU with the single spinner.  The CPU% reported by top is 
approx. 33%, 33%, 33% and 100% for the spinners.

If I renice the spinners to -10 (so that there load weights dominate the 
run queue load calculations) the problem goes away and the spinner to 
CPU allocation is 2/2 and top reports them all getting approx. 50% each.

It's also worth noting that I've had tests where the allocation started 
out 2/2 and the system changed it to 3/1 where it stabilized.  So it's 
not just a case of bad luck with the initial CPU allocation when the 
tasks start and the load balancing failing to fix it (which was one of 
my earlier theories).

> 
> (unlikely consiparacy theory)

It's not a conspiracy.  It's just dumb luck. :-)

> - idle_balance() and load_balance() (the
> later is dependent on the load balancing interval which can be in
> sync. with top/gkerllm activities as you suggest) move always either
> top or gkerllm between themselves.. esp. if X is reniced (so it gets
> additional "weight") and happens to be active (on CPU1) when
> load_balance() (kicked from scheduler_tick()) runs..
> 
> p.s. it's mainly theoretical specualtions.. I recently started looking
> at the load-balancing code (unfortunatelly, don't have an SMP machine
> which I can upgrade to the recent kernel) and so far for me it's
> mainly about getting sure I see things sanely.

I'm playing with some jitter experiments at the moment.  The amount of 
jitter needs to be small (a few tenths of a second) as the 
synchronization (if it's happening) is happening at the seconds level as 
the intervals for top and gkrellm will be in the 1 to 5 second range (I 
guess -- I haven't checked) and the load balancing is every 60 seconds.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
