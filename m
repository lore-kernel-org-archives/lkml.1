Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZEUU13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZEUU13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 16:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbZEUU1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 16:27:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:47254 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbZEUU1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 16:27:21 -0400
Message-ID: <4A15B8F2.9000804@kernel.org>
Date: Thu, 21 May 2009 13:26:26 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparseirq: Enable early irq_desc allocation.
References: <20090521165647.GA320@linux-sh.org>
In-Reply-To: <20090521165647.GA320@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Mundt wrote:
> Presently non-legacy IRQs have their irq_desc allocated with
> kzalloc_node(). This assumes that all callers of irq_to_desc_cpu_alloc()
> will be sufficiently late in the boot process that kmalloc is available.
> 
> While porting sparseirq support to sh this blew up immediately, as at the
> time that we register the CPU's interrupt vector map only bootmem is
> available.
> 
> This adds in a simple after_bootmem check to see where the allocation
> needs to come from, which is likewise provided by all of the platforms
> that support sparse irq today. :-)
> 
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
> ---
> 
>  kernel/irq/handle.c |   17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index d82142b..5fb3a5c 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -19,7 +19,7 @@
>  #include <linux/hash.h>
>  #include <trace/irq.h>
>  #include <linux/bootmem.h>
> -
> +#include <linux/mm.h>
>  #include "internals.h"
>  
>  /*
> @@ -81,13 +81,17 @@ static struct irq_desc irq_desc_init = {
>  	.lock       = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
>  };
>  
> -void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
> +void __ref init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
>  {
>  	int node;
>  	void *ptr;
>  
>  	node = cpu_to_node(cpu);
> -	ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs), GFP_ATOMIC, node);
> +	if (after_bootmem)
> +		ptr = kzalloc_node(nr * sizeof(*desc->kstat_irqs), GFP_ATOMIC, node);
> +	else
> +		ptr = alloc_bootmem_node(NODE_DATA(node),
> +				nr * sizeof(*desc->kstat_irqs));
>  
>  	/*
>  	 * don't overwite if can not get new one
> @@ -187,7 +191,7 @@ struct irq_desc *irq_to_desc(unsigned int irq)
>  	return NULL;
>  }
>  
> -struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
> +struct irq_desc * __ref irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
>  {
>  	struct irq_desc *desc;
>  	unsigned long flags;
> @@ -211,7 +215,10 @@ struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu)
>  		goto out_unlock;
>  
>  	node = cpu_to_node(cpu);
> -	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
> +	if (after_bootmem)
> +		desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
> +	else
> +		desc = alloc_bootmem_node(NODE_DATA(node), sizeof(*desc));
>  	printk(KERN_DEBUG "  alloc irq_desc for %d on cpu %d node %d\n",
>  		 irq, cpu, node);
>  	if (!desc) {

can you check tip?
we change _cpu to node already.

also only sh have after_bootmem now.
arch/sh/mm/init.c:int after_bootmem = 0;
arch/sh/mm/init.c:      after_bootmem = 1;
arch/sh/mm/ioremap_64.c:        extern int after_bootmem;
arch/sh/mm/ioremap_64.c:        if (after_bootmem) {
include/linux/mm.h:extern int after_bootmem;

for x86 we have bootmem_state ...
arch/x86/include/asm/page_types.h:enum bootmem_state {
arch/x86/include/asm/page_types.h:extern enum bootmem_state bootmem_state;
arch/x86/kernel/setup.c:        bootmem_state = DURING_BOOTMEM;
arch/x86/mm/init.c:enum bootmem_state bootmem_state = BEFORE_BOOTMEM;
arch/x86/mm/init.c:     if (bootmem_state == BEFORE_BOOTMEM)
arch/x86/mm/init.c:     if (bootmem_state == BEFORE_BOOTMEM)
arch/x86/mm/init.c:     if (bootmem_state == BEFORE_BOOTMEM && !start) {
arch/x86/mm/init.c:     if (bootmem_state == BEFORE_BOOTMEM &&
arch/x86/mm/init.c:     if (bootmem_state == BEFORE_BOOTMEM)

Andrew,
do we need to move bootmem_state back to linux/mm.h?

YH




YH
