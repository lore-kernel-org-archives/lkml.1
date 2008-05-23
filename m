Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbYEWUrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbYEWUrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 16:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759022AbYEWUrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 16:47:07 -0400
Received: from xenotime.net ([66.160.160.81]:47139 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758421AbYEWUrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 16:47:06 -0400
Date: Fri, 23 May 2008 13:47:02 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, pj@sgi.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [PATCH] [genirq] Expose default irq affinity mask
Message-Id: <20080523134702.e5fb9145.rdunlap@xenotime.net>
In-Reply-To: <1211571995-17488-1-git-send-email-maxk@qualcomm.com>
References: <1211571995-17488-1-git-send-email-maxk@qualcomm.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 12:46:35 -0700 Max Krasnyansky wrote:

> Current IRQ affinity interface does not provide a way to set affinity
> for the IRQs that will be allocated/activated in the future.
> This patch creates /proc/irq/default_smp_affinity that lets users set
> default affinity mask for the newly allocated IRQs. Changing default
> does not affect affinity masks for the currently active IRQs, they
> have to be changed explicitly.

Documentation, perhaps an update to Documentation/filesystems/proc.txt ?

> Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
> ---
>  arch/alpha/kernel/irq.c |    5 +--
>  include/linux/irq.h     |   14 ++++-------
>  kernel/irq/manage.c     |   28 +++++++++++++++++++++-
>  kernel/irq/proc.c       |   57 ++++++++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 89 insertions(+), 15 deletions(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 438a014..90f9ccc 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -16,6 +16,8 @@
>  
>  #ifdef CONFIG_SMP
>  
> +cpumask_t irq_default_affinity = CPU_MASK_ALL;
> +
>  /**
>   *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
>   *	@irq: interrupt number to wait for
> @@ -94,6 +96,27 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
>  	return 0;
>  }
>  
> +#ifndef CONFIG_AUTO_IRQ_AFFINITY
> +/**
> + * Generic version of the affinity autoselector.
> + */

Please don't use /** as the beginning of a comment block unless that
comment block is in kernel-doc format (this one is not).

> +int irq_select_affinity(unsigned int irq)
> +{
> +	cpumask_t mask;
> +
> +	if (!irq_can_set_affinity(irq))
> +		return 0;
> +
> +	cpus_and(mask, cpu_online_map, irq_default_affinity);
> +
> +	irq_desc[irq].affinity = mask;
> +	irq_desc[irq].chip->set_affinity(irq, mask);
> +
> +	set_balance_irq_affinity(irq, mask);
> +	return 0;
> +}
> +#endif


---
~Randy
