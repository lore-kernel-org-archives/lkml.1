Return-Path: <linux-kernel-owner+w=401wt.eu-S965053AbXIGG7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965053AbXIGG7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 02:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932732AbXIGG7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 02:59:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49774 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721AbXIGG7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 02:59:37 -0400
Date: Fri, 7 Sep 2007 08:59:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu
Subject: Re: [patch 05/10] Text Edit Lock - Alternative code for i386 and x86_64
Message-ID: <20070907065936.GH31880@one.firstfloor.org>
References: <20070906200124.595238505@polymtl.ca> <20070906200212.080849869@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070906200212.080849869@polymtl.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 04:01:29PM -0400, Mathieu Desnoyers wrote:
> +	sync_core();
> +	/* Not strictly needed, but can speed CPU recovery up. */

That turned out to break on some VIA CPUs. Should be removed.

> +	if (cpu_has_clflush)
> +		for (faddr = addr; faddr < addr + len;
> +				faddr += boot_cpu_data.x86_clflush_size)
> +			asm("clflush (%0) " :: "r" (faddr) : "memory");
> +}
> +
> +void * text_poke_early(void *addr, const void *opcode,
> +					size_t len)
> +{
> +	memcpy(addr, opcode, len);

It would be best to copy __inline_memcpy from x86-64 to i386
and use that here. That avoids the dependency on a patched
memcpy and is slightly safer.

> +
> +	if (len > sizeof(long)) {
> +		printk(KERN_ERR "text_poke of len %zu too big (max %lu)\n",
> +			len, sizeof(long));
> +		BUG_ON(1);

In general BUG_ON only should be enough because these values can
be recovered from the registers. 

> +	}
> +	unaligned = (((long)addr + len - 1) & ~(sizeof(long) - 1))
> +		- ((long)addr & ~(sizeof(long) - 1));
> +	if (unlikely(unaligned)) {
> +		printk(KERN_ERR "text_poke of at addr %p of len %zu is "
> +				"unaligned (%d)\n",
> +			addr, len, unaligned);
> +		BUG_ON(1);
> +	}

The common code should be in a common function. In fact they're so 
similar that the caller could just pass a buffer for the text_set
case, couldn't it?


> +#define kernel_wp_save(cr0)					\

Is there a real reason this has to be an macro? It could 
be just a normal function. In fact a shared on in alternative.c.
That would also avoid adding more include dependencies.

> +	do {							\
> +		typecheck(unsigned long, cr0);			\

typecheck is probably overkill

> +		preempt_disable();				\

Should disable interrupts too just to be safer? 

-Andi
