Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbYB1AKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbYB1AKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757731AbYB1AKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:10:36 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22078 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728AbYB1AKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:10:35 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5239"; a="954403"
Message-ID: <47C5FBF9.5010106@qualcomm.com>
Date: Wed, 27 Feb 2008 16:10:33 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 3/4] genirq: system set irq affinities
References: <20080227222103.673194000@chello.nl> <20080227222542.659932000@chello.nl>
In-Reply-To: <20080227222542.659932000@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides the notifier stuff it's identical to my genirq patch that I sent to 
Thomas and you for the review ~5 days ago.
There are a couple of things you missed.
Current call site for select_smp_affinity() inside request_irq() is incorrect. 
It ends up moving irq each time requires_irq() is called, and it is called 
multiple times for the shared irqs. My patch moves it into setup_irq() under 
if(!shared) check.

Also the following part is unsafe

> +#ifdef CONFIG_CPUSETS
> +static int system_irq_notifier(struct notifier_block *nb,
> +		unsigned long action, void *cpus)
> +{
> +	cpumask_t *new_system_map = (cpumask_t *)cpus;
> +	int i;
> +
> +	for (i = 0; i < NR_IRQS; i++) {
> +		struct irq_desc *desc = &irq_desc[i];
> +
> +		if (desc->chip == &no_irq_chip || !irq_can_set_affinity(i))
> +			continue;
> +
> +		if (cpus_match_system(desc->affinity)) {
> +			cpumask_t online_system;
> +
> +			cpus_and(online_system, new_system_map, cpu_online_map);
> +
> +			set_balance_irq_affinity(i, online_system);
> +
> +			desc->affinity = online_system;
> +			desc->chip->set_affinity(i, online_system);
Two lines above should be
	irq_set_affinity(i, online_system);

If you look at how irq_set_affinity() is implemented, you'll see this

#ifdef CONFIG_GENERIC_PENDING_IRQ
         set_pending_irq(irq, cpumask);
#else
         desc->affinity = cpumask;
         desc->chip->set_affinity(irq, cpumask);
#endif

set_pending_irq() is the safe way to move pending irqs.

btw It should be ok to call chip->set_affinity() directly from 
select_smp_affinity() because in my patch is is guarantied to be called only 
for the first handler registration.

Max
