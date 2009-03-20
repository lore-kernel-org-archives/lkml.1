Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbZCTKh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbZCTKh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZCTKhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:37:50 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:52871 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbZCTKht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:37:49 -0400
Message-ID: <49C371F5.5010100@monstr.eu>
Date: Fri, 20 Mar 2009 11:37:41 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, john.williams@petalogix.com,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 08/57] microblaze_v7: Interrupt handling, timer support,
 selfmod code
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu> <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu> <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu> <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu> <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu> <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu> <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu> <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu> <alpine.LFD.2.00.0903191639530.29264@localhost.localdomain> <49C2AB09.9040300@monstr.eu> <alpine.LFD.2.00.0903192219500.29264@localhost.localdomain> <49C36149.9000703@monstr.eu> <alpine.LFD.2.00.0903201052340.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903201052340.29264@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
> On Fri, 20 Mar 2009, Michal Simek wrote:
> 
>> Thomas,
>>
>> just one other question.
>> For me will be useful to use second timer which is inside timer IP core.
>> There are two timers with one interrupt line. And I can of course resolve which
>> counter cause it. That's no problem.
>>
>> My question is about timer_irqaction where is dev_id. What should be there?
>> Point to clocksource structure or clockevent?
>>
>> static struct irqaction timer_irqaction = {
>> 	.handler = timer_interrupt,
>> 	.flags = IRQF_DISABLED | IRQF_TIMER,
>> 	.name = "timer",
>> 	.dev_id = &clocksource_microblaze,
>> };
> 
> The clockevent of course. It's the one which emits the interrupts.
> 
> Just for clarification. The clocksource is basically a counter to read
> out the current time. Such a counter usually does not deliver
> interrupts. It wraps at some point, but that is handled by the generic
> time keeping code. If you setup the 32 bit counter to count up and let
> it run free then the counter will wrap from 0xffffffff to 0. Nothing
> you have to worry about. You just provide a function to read it.

That's is crucial information which I haven't found.

> 
> The clockevent is the device which delivers either periodic or oneshot
> interrupts. Sa you dont have to worry about the shared interrupt line
> in that case.

I have working implementation. I just need to clear some thing relate with HW -
some checking mechanism that two timer must be there + some selfmod test. I'll
send it soon and do some LTP test too but I believe that I clean that code. I
take a look at irq code too.

Below is timer_list log.

I can paste current my code but people don't like it attachment and in-line
code.I'll do regular one patch with git and send it.

Why is my .resolution: 10000000 nsecs? It seems to me weird.

I'll wait for John's answer for fixing shift and rating values too.

Thanks a lot,
Michal

> 
> Thanks,
> 
> 	tglx

# cat /proc/timer_list
Timer List Version: v0.4
HRTIMER_MAX_CLOCK_BASES: 2
now at 193684779856 nsecs

cpu: 0
 clock 0:
  .base:       902774d0
  .index:      0
  .resolution: 10000000 nsecs
  .get_time:   ktime_get_real
active timers:
 clock 1:
  .base:       902774f4
  .index:      1
  .resolution: 10000000 nsecs
  .get_time:   ktime_get
active timers:
 #0: <9e2d3a48>, hrtimer_wakeup, S:01, <9e2d3a48>, inetd/54
 # expires at 194110626631-194111626591 nsecs [in 425846775 to 426846735 nsecs]
 #1: <9e0e5a48>, hrtimer_wakeup, S:01, <9e0e5a48>, thttpd/50
 # expires at 249711205338-249811205338 nsecs [in 56026425482 to 56126425482 nsecs]


Tick Device: mode:     0
Per CPU device: 0
Clock Event Device: microblaze_clockevent
 max_delta_ns:   2147483647
 min_delta_ns:   1000
 mult:           536870912
 shift:          32
 mode:           2
 next_event:     2147483646999999999 nsecs
 set_next_event: microblaze_timer_set_next_event
 set_mode:       microblaze_timer_set_mode
 event_handler:  tick_handle_periodic

# cat /proc/timer_list
Timer List Version: v0.4
HRTIMER_MAX_CLOCK_BASES: 2
now at 198714389017 nsecs

cpu: 0
 clock 0:
  .base:       902774d0
  .index:      0
  .resolution: 10000000 nsecs
  .get_time:   ktime_get_real
active timers:
 clock 1:
  .base:       902774f4
  .index:      1
  .resolution: 10000000 nsecs
  .get_time:   ktime_get
active timers:
 #0: <9e2d3a48>, hrtimer_wakeup, S:01, <9e2d3a48>, inetd/54
 # expires at 199160628442-199161628402 nsecs [in 446239425 to 447239385 nsecs]
 #1: <9e0e5a48>, hrtimer_wakeup, S:01, <9e0e5a48>, thttpd/50
 # expires at 249711205338-249811205338 nsecs [in 50996816321 to 51096816321 nsecs]


Tick Device: mode:     0
Per CPU device: 0
Clock Event Device: microblaze_clockevent
 max_delta_ns:   2147483647
 min_delta_ns:   1000
 mult:           536870912
 shift:          32
 mode:           2
 next_event:     2147483646999999999 nsecs
 set_next_event: microblaze_timer_set_next_event
 set_mode:       microblaze_timer_set_mode
 event_handler:  tick_handle_periodic

#






