Return-Path: <linux-kernel-owner+w=401wt.eu-S939722AbXHJTA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939722AbXHJTA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 15:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbXHJTAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 15:00:19 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:60471 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756531AbXHJTAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 15:00:17 -0400
Date: Fri, 10 Aug 2007 15:00:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <ak@suse.de>
Cc: jbeulich@novell.com, "S. P. Prasanna" <prasanna@in.ibm.com>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: Re: new text patching for review
Message-ID: <20070810190012.GA24556@Krystal>
References: <200707191105.44056.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200707191105.44056.ak@suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:57:21 up 11 days, 19:16,  5 users,  load average: 1.72, 1.23, 0.99
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (ak@suse.de) wrote:
> 
> Hallo,
> 
> I had some second thoughts about the text patching of DEBUG_RODATA kernels
> using change_page_attr(). Change_page_attr is intrusive and slow and using
> a separate mapping is a little more gentle. I came up with this patch.
> For your review and testing pleasure.
> 
> The main quirk is that it doesn't fully follow the cross-modifying code
> recommendations; but i'm not sure that's really needed.
> 
> Also I admit nop_out is quite inefficient, but that's a very slow path
> and it was easier to do it this way than handle all the corner cases
> explicitely.
> 
> Comments,
> 
> -Andi
> 
> x86: Fix alternatives and kprobes to remap write-protected kernel text
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> +/*
> + * RED-PEN Intel recommends stopping the other CPUs for such
> + * "cross-modifying code".
> + */
> +void __kprobes text_poke(void *oaddr, u8 opcode)
> +{
> +        u8 *addr = oaddr;
> +	if (!pte_write(*lookup_address((unsigned long)addr))) {
> +		struct page *p = virt_to_page(addr);
> +		addr = vmap(&p, 1, VM_MAP, PAGE_KERNEL);
> +		if (!addr)
> +			return;
> +		addr += ((unsigned long)oaddr) % PAGE_SIZE;
> +	}
> +	*addr = opcode;
> +	/* Not strictly needed, but can speed CPU recovery up */
> +	if (cpu_has_clflush)
> +		asm("clflush (%0) " :: "r" (addr) : "memory");
> +	if (addr != oaddr)
> +		vunmap(addr);
> +}

Hi Andi,

I was trying to make this work, but I find out that it seems incredibly
slow when I call it multiple times. Trying to understand why, I come
with a few questions:

- Is this supposed to work with large pages ?
- Is this supposed to work module text ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
