Return-Path: <linux-kernel-owner+w=401wt.eu-S1763735AbZAHXLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763735AbZAHXLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 18:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759139AbZAHXLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 18:11:23 -0500
Received: from relay2.sgi.com ([192.48.179.30]:57989 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751354AbZAHXLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 18:11:23 -0500
Message-ID: <49668818.1060900@sgi.com>
Date: Thu, 08 Jan 2009 15:11:20 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: rusty@rustcorp.com.au, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] cpumask fallout: Initialize irq_default_affinity
 earlier (v2).
References: <496683D0.6000509@caviumnetworks.com> <1231455345-29453-2-git-send-email-ddaney@caviumnetworks.com>
In-Reply-To: <1231455345-29453-2-git-send-email-ddaney@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's essentially the same as I tested on x86_64 so you can add my

	Acked-by: Mike Travis <travis@sgi.com>

Thanks!
Mike

David Daney wrote:
> Move the initialization of irq_default_affinity to early_irq_init as
> core_initcall is too late.
> 
> irq_default_affinity can be used in init_IRQ and potentially timer and
> SMP init as well.  All of these happen before core_initcall.  Moving
> the initialization to early_irq_init ensures that it is initialized
> before it is used.
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> ---
>  kernel/irq/handle.c |   12 ++++++++++++
>  kernel/irq/manage.c |    8 --------
>  2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index c20db0b..a9fbb01 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -39,6 +39,14 @@ void handle_bad_irq(unsigned int irq, struct irq_desc *desc)
>  	ack_bad_irq(irq);
>  }
>  
> +static inline void __init init_irq_default_affinity(void)
> +{
> +#if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
> +	alloc_bootmem_cpumask_var(&irq_default_affinity);
> +	cpumask_setall(irq_default_affinity);
> +#endif
> +}
> +
>  /*
>   * Linux has a controller-independent interrupt architecture.
>   * Every controller has a 'controller-template', that is used
> @@ -134,6 +142,8 @@ int __init early_irq_init(void)
>  	int legacy_count;
>  	int i;
>  
> +	init_irq_default_affinity();
> +
>  	desc = irq_desc_legacy;
>  	legacy_count = ARRAY_SIZE(irq_desc_legacy);
>  
> @@ -219,6 +229,8 @@ int __init early_irq_init(void)
>  	int count;
>  	int i;
>  
> +	init_irq_default_affinity();
> +
>  	desc = irq_desc;
>  	count = ARRAY_SIZE(irq_desc);
>  
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 618a64f..291f036 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -18,14 +18,6 @@
>  #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
>  cpumask_var_t irq_default_affinity;
>  
> -static int init_irq_default_affinity(void)
> -{
> -	alloc_cpumask_var(&irq_default_affinity, GFP_KERNEL);
> -	cpumask_setall(irq_default_affinity);
> -	return 0;
> -}
> -core_initcall(init_irq_default_affinity);
> -
>  /**
>   *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
>   *	@irq: interrupt number to wait for

