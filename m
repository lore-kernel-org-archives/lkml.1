Return-Path: <linux-kernel-owner+w=401wt.eu-S1760020AbYBYBsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020AbYBYBsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 20:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758116AbYBYBr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 20:47:56 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:29653 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbYBYBrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 20:47:55 -0500
Date: Sun, 24 Feb 2008 17:47:27 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] Genirq and CPU isolation
Message-Id: <20080224174727.1a3f4dd7.randy.dunlap@oracle.com>
In-Reply-To: <47BFBAE6.3040606@qualcomm.com>
References: <47BFBAE6.3040606@qualcomm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 22:19:18 -0800 Max Krasnyansky wrote:

Hi Max,

> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 438a014..e74db94 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -488,6 +491,26 @@ void free_irq(unsigned int irq, void *dev_id)
>  }
>  EXPORT_SYMBOL(free_irq);
>  
> +#ifndef CONFIG_AUTO_IRQ_AFFINITY
> +/**
> + * Generic version of the affinity autoselector.
> + * Called under desc->lock from setup_irq().
> + * btw Should we rename this to select_irq_affinity() ?
> + */

Please don't begin comment blocks with "/**" unless they are in
kernel-doc format.  (See Documentation/kernel-doc-nano-HOWTO.txt
for details of it.)

> +int select_smp_affinity(unsigned int irq)
> +{
> +	cpumask_t usable_cpus;
> +
> +	if (!irq_can_set_affinity(irq))
> +		return 0;
> +
> +	cpus_andnot(usable_cpus, cpu_online_map, cpu_isolated_map);
> +	irq_desc[irq].affinity = usable_cpus;
> +	irq_desc[irq].chip->set_affinity(irq, usable_cpus);
> +	return 0;
> +}
> +#endif
> +
>  /**
>   *	request_irq - allocate an interrupt line
>   *	@irq: Interrupt line to allocate

This one is in kernel-doc format.

---
~Randy
