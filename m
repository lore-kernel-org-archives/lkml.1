Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbZCSVsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbZCSVsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 17:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757863AbZCSVrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 17:47:53 -0400
Received: from www.tglx.de ([62.245.132.106]:50079 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757190AbZCSVrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:47:52 -0400
Date: Thu, 19 Mar 2009 22:47:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Simek <monstr@monstr.eu>
cc: LKML <linux-kernel@vger.kernel.org>, john.williams@petalogix.com,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 08/57] microblaze_v7: Interrupt handling, timer support,
 selfmod code
In-Reply-To: <49C2AB09.9040300@monstr.eu>
Message-ID: <alpine.LFD.2.00.0903192219500.29264@localhost.localdomain>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu> <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu> <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu> <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu> <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu> <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu> <alpine.LFD.2.00.0903191639530.29264@localhost.localdomain> <49C2AB09.9040300@monstr.eu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

On Thu, 19 Mar 2009, Michal Simek wrote:
> >> +	__do_IRQ(irq);
> > 
> > You use irq chips now and you set the type handlers (edge/level), but
> > you still call __do_IRQ() the all in one fits nothing handler, which
> > is going to be deprecated and removed.
> 
> I know about.
> > 
> > Please call 
> >        generic_handle_irq(irq);
> > 
> > which will call the correct flow handlers.
> 
> I would like to use it but don't work with edge interrupt.
> __do_IRQ handle it in right way.
> 
> I used this implementation but I did some change edge/level handling and I can't
> use it.
> http://developer.petalogix.com/git/gitweb.cgi?p=linux-2.6-microblaze.git;a=blob_plain;f=arch/microblaze/kernel/irq.c;hb=3645d887ad6443a262bbeddf384038321172db2b
> 
> Any hints what could be wrong?
 
Look at the different handling schemes of __do_IRQ and handle_edge_irq
vs. the chip functions:

__do_IRQ() does:
{
	   chip->ack();
	   
	   handle_IRQ_event();

	   chip->end();
}

handle_edge_irq() does:
{
	if ((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
                    !desc->action)) {
                desc->status |= (IRQ_PENDING | IRQ_MASKED);
                mask_ack_irq(desc, irq);
		goto out_unlock;
	}

	chip->ack();
	handle_IRQ_event();

}

I guess the problem is in your chip->xxx functions.

> First of all I have one question to you about MB timer.c.
> It is about this function - microblaze_read.
> 
> static cycle_t mb_tick_cnt; /* store counter ticks */
> 
> static cycle_t microblaze_read(void)
> {
> 	u64 temp = (u64)mb_tick_cnt + (u64)((u32)cpuinfo.freq_div_hz
> 					- (u32)in_be32(TIMER_BASE + TCR0));
> 	return temp;
> }
> 
> 
> MB has 32bit periodic down counter and I need to use u64 value that's why
> I do these operation above. cpuinfo.freq_div_hz store freq/HZ value - number of
> ticks for 1/HZ. I subtract current timer value + mb_tick_cnt which store number
> of count. The problem I have is that gettimeofday LTP test failed on it ->
> announce that time is going backward.
> Simple returning only mb_tick_cnt pass this test but of course I am losing
> information about time till 1/HZ.
> Do I have to add any specific amount of time which take counting of it?

You do not neeed 64 bit values. The return value is masked with the
clocksource->mask anyway. So when your clocksource has less than 64
bits it's covered.

So if your timer counts down from 0xFFFFFFFF to 0 and wraps around you
just need to return (cycle_t) ~(timer->count);

But I think I know where your real problem is. You use the same timer
for both timekeeping and the periodic tick. That's why you can not
support one shot mode. I bet the machine has two timers.

So the best way to handle this is:

   Use timer A in free running mode - up or down counting does not
   matter - for the timekeeping. That way you have an ever increasing
   monotonic time.

   Use timer B either for periodic mode or for one shot and all your
   problems are gone. In periodic mode use autoreload and in one shot
   mode just follow the instructions of the generic code via the
   timer_set_next_event() function.

> And the second question is about shift and rating values.
> I wrote one message in past http://lkml.org/lkml/2009/1/11/291
> Here is the important of part of that message.
> 
> ...
> 
> And the second part is about shift and rating values. Rating is
> describe(linux/clocksource.h) and seems to me that should be
> corresponded with CONFIG_HZ value,right?
> And I found any explanation of shift value -> max value for equation
> (2-5) * freq << shift / NSEC_PER_SEC should be for my case still 32bit
> number, where (2-5s) are because of NTP

@John, can you explain the shift vlaue please ?
 
> The second thing which seems to me weird in comparing with others log I
> have seen is .resolution value. Full (proc/timer_lists is below) My
> .resolution: 10000000 nsecs which
> is 1/HZ in nsec. (On others log I saw 1nsec values). My the lowest
> resolution is 1/freq = 8nsec (for 125MHz). Is that OK or not.
> ...

The 1ns is theoretical and indicates that the kernel has high resolution
timer support. Your resolution is just HZ.

> > 
> >> +static int microblaze_timer_set_next_event(unsigned long delta,
> >> +					 struct clock_event_device *dev)
> >> +{
> >> +	printk(KERN_INFO "next event, delta %x, %d\n", (u32)delta, (u32)delta);
> > 
> >   This should be pr_debug() or do you want to flood the syslog in
> >   every timer interrupt ?
> 
> This not flood the syslog. I don't know why (maybe because of missing ONESHOT)
> but this code is never called in periodic mode. But you are right if this
> function is called a lot it is necessary to use pr_debug -> but this is not my
> case in this implementation.

Well. Either you have one shot mode, then better make it work and
useable or just remove the one shot support until you figure out how
to do it.

> > 
> >> +	microblaze_timer_start(delta);
> >> +	return 0;
> >> +}
> >> +
> >> +static void microblaze_timer_set_mode(enum clock_event_mode mode,
> >> +				    struct clock_event_device *evt)
> >> +{
> >> +	microblaze_timer_stop();
> >> +
> >> +	switch (mode) {
> >> +	case CLOCK_EVT_MODE_PERIODIC:
> >> +		printk(KERN_INFO "%s: periodic\n", __func__);
> > 
> >   pr_debug as well. That's not very informative
> 
> It is only information that timer work in periodic mode.
> 
> Part of kernel log which is there - nothing more.
> 
> microblaze_timer_set_mode: shutdown
> microblaze_timer_set_mode: periodic

Nothing a normal user is interested in I guess, but ok. 
 
> >> +static irqreturn_t timer_interrupt(int irq, void *dev_id)
> >> +{
> >> +	struct clock_event_device *evt = &clockevent_microblaze_timer;
> >> +#ifdef CONFIG_HEART_BEAT
> >> +	heartbeat();
> >> +#endif
> >> +	timer_ack();
> >> +
> >> +	mb_tick_cnt += cpuinfo.freq_div_hz;
> > 
> > Hmm. How does that work with oneshot timers ?
> 
> Oneshot is not supported yet - only periodic mode. I had to add it mb_tick_cnt
> counting because
> I don't know reason but without it ( kernel and timer in periodic mode )not
> update system time.

I don't know how that timer works. Do you have a pointer to hardware
docs + chapter reference ?
 
> >> +	xtime.tv_sec = mktime(2007, 1, 1, 0, 0, 0);
> >> +	xtime.tv_nsec = 0;
> >> +	set_normalized_timespec(&wall_to_monotonic,
> >> +				-xtime.tv_sec, -xtime.tv_nsec);
> > 
> >   Yuck. What's that ? wall_to_monotonic is maintained by the generic
> >   code.
> 
> I take this part of code from arch/blackfin/kernel/time-ts.c:217-219.
> arch/x86/xen/time.c use it too. And arch/arm/kernel/time.c use similar
> implemetation.

Right. All of them are similar nonsense. If we want a 1/1/2007 base
date if there is no RTC which tells us the real date/time then we
should do this in the generic code and not implement 10 variations all
over the place.

     tglx
