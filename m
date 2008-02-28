Return-Path: <linux-kernel-owner+w=401wt.eu-S1758332AbYB1KUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbYB1KUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 05:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbYB1KUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 05:20:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59111 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbYB1KUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 05:20:10 -0500
Subject: Re: [RFC/PATCH 3/4] genirq: system set irq affinities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <47C5FBF9.5010106@qualcomm.com>
References: <20080227222103.673194000@chello.nl>
	 <20080227222542.659932000@chello.nl>  <47C5FBF9.5010106@qualcomm.com>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 11:19:46 +0100
Message-Id: <1204193986.6243.28.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-27 at 16:10 -0800, Max Krasnyanskiy wrote:
> Besides the notifier stuff it's identical to my genirq patch that I sent to 
> Thomas and you for the review ~5 days ago.
> There are a couple of things you missed.

Or left out because I didn't take time to actually look at the code to
much. It took me ~4 hours to whip this up (then a few more to debug and
test it).

You missed the call to set_balance_irq_affinity() and went poking in the
balancer itself. 

> Current call site for select_smp_affinity() inside request_irq() is incorrect. 
> It ends up moving irq each time requires_irq() is called, and it is called 
> multiple times for the shared irqs. My patch moves it into setup_irq() under 
> if(!shared) check.

I'll leave that to tglx and mingo and claim lack of clue.

> Also the following part is unsafe
> 
> > +#ifdef CONFIG_CPUSETS
> > +static int system_irq_notifier(struct notifier_block *nb,
> > +		unsigned long action, void *cpus)
> > +{
> > +	cpumask_t *new_system_map = (cpumask_t *)cpus;
> > +	int i;
> > +
> > +	for (i = 0; i < NR_IRQS; i++) {
> > +		struct irq_desc *desc = &irq_desc[i];
> > +
> > +		if (desc->chip == &no_irq_chip || !irq_can_set_affinity(i))
> > +			continue;
> > +
> > +		if (cpus_match_system(desc->affinity)) {
> > +			cpumask_t online_system;
> > +
> > +			cpus_and(online_system, new_system_map, cpu_online_map);
> > +
> > +			set_balance_irq_affinity(i, online_system);
> > +
> > +			desc->affinity = online_system;
> > +			desc->chip->set_affinity(i, online_system);
> Two lines above should be
> 	irq_set_affinity(i, online_system);
> 
> If you look at how irq_set_affinity() is implemented, you'll see this
> 
> #ifdef CONFIG_GENERIC_PENDING_IRQ
>          set_pending_irq(irq, cpumask);
> #else
>          desc->affinity = cpumask;
>          desc->chip->set_affinity(irq, cpumask);
> #endif
> 
> set_pending_irq() is the safe way to move pending irqs.

Seems not unsafe, just not handling pending irqs.




