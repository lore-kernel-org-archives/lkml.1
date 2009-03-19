Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbZCSPtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbZCSPtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 11:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZCSPtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 11:49:31 -0400
Received: from www.tglx.de ([62.245.132.106]:33618 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbZCSPta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 11:49:30 -0400
Date: Thu, 19 Mar 2009 16:49:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Simek <monstr@monstr.eu>
cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: [PATCH 08/57] microblaze_v7: Interrupt handling, timer support,
 selfmod code
In-Reply-To: <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
Message-ID: <alpine.LFD.2.00.0903191639530.29264@localhost.localdomain>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu> <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu> <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu> <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu> <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu> <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

On Wed, 18 Mar 2009, monstr@monstr.eu wrote:

> +static u32 concurrent_irq;
> +
> +void do_IRQ(struct pt_regs *regs)
> +{
> +	unsigned int irq;
> +	struct pt_regs *old_regs = set_irq_regs(regs);
> +
> +	irq_enter();
> +	irq = get_irq(regs);
> +next_irq:
> +	BUG_ON(irq == -1U);
> +	__do_IRQ(irq);

You use irq chips now and you set the type handlers (edge/level), but
you still call __do_IRQ() the all in one fits nothing handler, which
is going to be deprecated and removed.

Please call 
       generic_handle_irq(irq);

which will call the correct flow handlers.

> +static int microblaze_timer_set_next_event(unsigned long delta,
> +					 struct clock_event_device *dev)
> +{
> +	printk(KERN_INFO "next event, delta %x, %d\n", (u32)delta, (u32)delta);

  This should be pr_debug() or do you want to flood the syslog in
  every timer interrupt ?

> +	microblaze_timer_start(delta);
> +	return 0;
> +}
> +
> +static void microblaze_timer_set_mode(enum clock_event_mode mode,
> +				    struct clock_event_device *evt)
> +{
> +	microblaze_timer_stop();
> +
> +	switch (mode) {
> +	case CLOCK_EVT_MODE_PERIODIC:
> +		printk(KERN_INFO "%s: periodic\n", __func__);

  pr_debug as well. That's not very informative

> +static irqreturn_t timer_interrupt(int irq, void *dev_id)
> +{
> +	struct clock_event_device *evt = &clockevent_microblaze_timer;
> +#ifdef CONFIG_HEART_BEAT
> +	heartbeat();
> +#endif
> +	timer_ack();
> +
> +	mb_tick_cnt += cpuinfo.freq_div_hz;

Hmm. How does that work with oneshot timers ?

> +	evt->event_handler(evt);
> +	return IRQ_HANDLED;
> +}
> +
> +static struct irqaction timer_irqaction = {
> +	.handler = timer_interrupt,
> +	.flags = IRQF_DISABLED,

    IRQF_DISABLED  | IRQF_TIMER,


> +	xtime.tv_sec = mktime(2007, 1, 1, 0, 0, 0);
> +	xtime.tv_nsec = 0;
> +	set_normalized_timespec(&wall_to_monotonic,
> +				-xtime.tv_sec, -xtime.tv_nsec);

  Yuck. What's that ? wall_to_monotonic is maintained by the generic
  code.

Thanks,

	tglx


