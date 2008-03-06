Return-Path: <linux-kernel-owner+w=401wt.eu-S933504AbYCFPFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504AbYCFPFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764862AbYCFPEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:04:54 -0500
Received: from r00tworld.com ([212.85.137.21]:54777 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758463AbYCFPEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:04:52 -0500
From: pageexec@freemail.hu
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>
Date: Thu, 06 Mar 2008 15:59:29 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] x86 - Enhance DEBUG_RODATA support - alternatives
Reply-to: pageexec@freemail.hu
CC: Srinivasa DS <srinivasa@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       srikar@linux.vnet.ibm.com, SystemTAP <systemtap@sources.redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>
Message-ID: <47D014E1.30964.22A9390F@pageexec.freemail.hu>
In-reply-to: <20080306140105.GC28438@elte.hu>
References: <200803061811.27555.srinivasa@in.ibm.com>, <20080306134849.GA4088@Krystal>, <20080306140105.GC28438@elte.hu>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Thu, 06 Mar 2008 15:57:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Mar 2008 at 15:01, Ingo Molnar wrote:

> +/**
> + * text_poke - Update instructions on a live kernel
> + * @addr: address to modify
> + * @opcode: source of the copy
> + * @len: length to copy
> + *
> + * Only atomic text poke/set should be allowed when not doing early patching.
> + * It means the size must be writable atomically and the address must be aligned
> + * in a way that permits an atomic write. It also makes sure we fit on a single
> + * page.
> + */
> +void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
> +{
> +	unsigned long flags;
> +	char *vaddr;
> +	int nr_pages = 2;
> +
> +	BUG_ON(len > sizeof(long));
> +	BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
> +		- ((long)addr & ~(sizeof(long) - 1)));
> +	{
> +		struct page *pages[2] = { virt_to_page(addr),
> +			virt_to_page(addr + PAGE_SIZE) };
> +		if (!pages[1])
> +			nr_pages = 1;
> +		vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
> +		WARN_ON(!vaddr);
> +		local_irq_save(flags);
> +		memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
> +		local_irq_restore(flags);

you probably want a BUG_ON instead (or some graceful recovery) else
the NULL deref will trigger with IRQs off...

> +		vunmap(vaddr);
> +	}
>  	sync_core();
>  	/* Could also do a CLFLUSH here to speed up CPU recovery; but
>  	   that causes hangs on some VIA CPUs. */
> +	return addr;
>  }


