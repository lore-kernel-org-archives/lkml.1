Return-Path: <linux-kernel-owner+w=401wt.eu-S1760924AbZCSU3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760924AbZCSU3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757971AbZCSU3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:29:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:22117 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbZCSU3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:29:02 -0400
Message-ID: <49C2AB09.9040300@monstr.eu>
Date: Thu, 19 Mar 2009 21:28:57 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: [PATCH 08/57] microblaze_v7: Interrupt handling, timer support,
 selfmod code
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu> <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu> <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu> <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu> <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu> <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu> <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu> <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu> <alpine.LFD.2.00.0903191639530.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903191639530.29264@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
> 
>> +static u32 concurrent_irq;
>> +
>> +void do_IRQ(struct pt_regs *regs)
>> +{
>> +	unsigned int irq;
>> +	struct pt_regs *old_regs = set_irq_regs(regs);
>> +
>> +	irq_enter();
>> +	irq = get_irq(regs);
>> +next_irq:
>> +	BUG_ON(irq == -1U);
>> +	__do_IRQ(irq);
> 
> You use irq chips now and you set the type handlers (edge/level), but
> you still call __do_IRQ() the all in one fits nothing handler, which
> is going to be deprecated and removed.

I know about.
> 
> Please call 
>        generic_handle_irq(irq);
> 
> which will call the correct flow handlers.

I would like to use it but don't work with edge interrupt.
__do_IRQ handle it in right way.

I used this implementation but I did some change edge/level handling and I can't
use it.
http://developer.petalogix.com/git/gitweb.cgi?p=linux-2.6-microblaze.git;a=blob_plain;f=arch/microblaze/kernel/irq.c;hb=3645d887ad6443a262bbeddf384038321172db2b

Any hints what could be wrong?





First of all I have one question to you about MB timer.c.
It is about this function - microblaze_read.

static cycle_t mb_tick_cnt; /* store counter ticks */

static cycle_t microblaze_read(void)
{
	u64 temp = (u64)mb_tick_cnt + (u64)((u32)cpuinfo.freq_div_hz
					- (u32)in_be32(TIMER_BASE + TCR0));
	return temp;
}


MB has 32bit periodic down counter and I need to use u64 value that's why
I do these operation above. cpuinfo.freq_div_hz store freq/HZ value - number of
ticks for 1/HZ. I subtract current timer value + mb_tick_cnt which store number
of count. The problem I have is that gettimeofday LTP test failed on it ->
announce that time is going backward.
Simple returning only mb_tick_cnt pass this test but of course I am losing
information about time till 1/HZ.
Do I have to add any specific amount of time which take counting of it?


And the second question is about shift and rating values.
I wrote one message in past http://lkml.org/lkml/2009/1/11/291
Here is the important of part of that message.

...

And the second part is about shift and rating values. Rating is
describe(linux/clocksource.h) and seems to me that should be
corresponded with CONFIG_HZ value,right?
And I found any explanation of shift value -> max value for equation
(2-5) * freq << shift / NSEC_PER_SEC should be for my case still 32bit
number, where (2-5s) are because of NTP

The second thing which seems to me weird in comparing with others log I
have seen is .resolution value. Full (proc/timer_lists is below) My
.resolution: 10000000 nsecs which
is 1/HZ in nsec. (On others log I saw 1nsec values). My the lowest
resolution is 1/freq = 8nsec (for 125MHz). Is that OK or not.
...



> 
>> +static int microblaze_timer_set_next_event(unsigned long delta,
>> +					 struct clock_event_device *dev)
>> +{
>> +	printk(KERN_INFO "next event, delta %x, %d\n", (u32)delta, (u32)delta);
> 
>   This should be pr_debug() or do you want to flood the syslog in
>   every timer interrupt ?

This not flood the syslog. I don't know why (maybe because of missing ONESHOT)
but this code is never called in periodic mode. But you are right if this
function is called a lot it is necessary to use pr_debug -> but this is not my
case in this implementation.

> 
>> +	microblaze_timer_start(delta);
>> +	return 0;
>> +}
>> +
>> +static void microblaze_timer_set_mode(enum clock_event_mode mode,
>> +				    struct clock_event_device *evt)
>> +{
>> +	microblaze_timer_stop();
>> +
>> +	switch (mode) {
>> +	case CLOCK_EVT_MODE_PERIODIC:
>> +		printk(KERN_INFO "%s: periodic\n", __func__);
> 
>   pr_debug as well. That's not very informative

It is only information that timer work in periodic mode.

Part of kernel log which is there - nothing more.

microblaze_timer_set_mode: shutdown
microblaze_timer_set_mode: periodic


> 
>> +static irqreturn_t timer_interrupt(int irq, void *dev_id)
>> +{
>> +	struct clock_event_device *evt = &clockevent_microblaze_timer;
>> +#ifdef CONFIG_HEART_BEAT
>> +	heartbeat();
>> +#endif
>> +	timer_ack();
>> +
>> +	mb_tick_cnt += cpuinfo.freq_div_hz;
> 
> Hmm. How does that work with oneshot timers ?

Oneshot is not supported yet - only periodic mode. I had to add it mb_tick_cnt
counting because
I don't know reason but without it ( kernel and timer in periodic mode )not
update system time.


> 
>> +	evt->event_handler(evt);
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static struct irqaction timer_irqaction = {
>> +	.handler = timer_interrupt,
>> +	.flags = IRQF_DISABLED,
> 
>     IRQF_DISABLED  | IRQF_TIMER,

OK. I'll add it.
> 
> 
>> +	xtime.tv_sec = mktime(2007, 1, 1, 0, 0, 0);
>> +	xtime.tv_nsec = 0;
>> +	set_normalized_timespec(&wall_to_monotonic,
>> +				-xtime.tv_sec, -xtime.tv_nsec);
> 
>   Yuck. What's that ? wall_to_monotonic is maintained by the generic
>   code.

I take this part of code from arch/blackfin/kernel/time-ts.c:217-219.
arch/x86/xen/time.c use it too. And arch/arm/kernel/time.c use similar
implemetation.


Thanks,
Michal

> 
> Thanks,
> 
> 	tglx
> 
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
