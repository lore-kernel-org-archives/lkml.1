Return-Path: <linux-kernel-owner+w=401wt.eu-S1761977AbZAHTLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761977AbZAHTLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbZAHTLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:11:04 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:18214 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbZAHTLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:11:02 -0500
Message-ID: <49664F9B.8070703@caviumnetworks.com>
Date: Thu, 08 Jan 2009 11:10:19 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PULL] cpumask tree
References: <200901011149.18401.rusty@rustcorp.com.au>
In-Reply-To: <200901011149.18401.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jan 2009 19:10:19.0538 (UTC) FILETIME=[BF653720:01C971C4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> commit d036e67b40f52bdd95392390108defbac7e53837
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Thu Jan 1 10:12:26 2009 +1030
> 
>     cpumask: convert kernel/irq
>     
>     Impact: Reduce stack usage, use new cpumask API.  ALPHA mod!
>     
>     Main change is that irq_default_affinity becomes a cpumask_var_t, so
>     treat it as a pointer (this effects alpha).
>     
>     Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 

Which contains:

> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 61c4a9b..cd0cd8d 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -16,8 +16,15 @@
>  #include "internals.h"
>  
>  #ifdef CONFIG_SMP
> +cpumask_var_t irq_default_affinity;
>  
> -cpumask_t irq_default_affinity = CPU_MASK_ALL;
> +static int init_irq_default_affinity(void)
> +{
> +       alloc_cpumask_var(&irq_default_affinity, GFP_KERNEL);
> +       cpumask_setall(irq_default_affinity);
> +       return 0;
> +}
> +core_initcall(init_irq_default_affinity);

I think core_initcall is too late to be initializing 
irq_default_affinity.  This happens way after init_IRQ() is called and 
for my target (mips/cavium_octeon) after the timer and SMP related irqs 
are setup.

I had been setting irq_default_affinity in init_IRQ(), and I could 
probably do it later with no real problem, but this seems wrong to me. 
Data that is potentially used in interrupt configuration and processing 
should be initialized before it is used.

David Daney
