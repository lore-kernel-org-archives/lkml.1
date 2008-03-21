Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbYCUJir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbYCUJir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 05:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYCUJig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 05:38:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39354 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955AbYCUJif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 05:38:35 -0400
Date: Fri, 21 Mar 2008 10:38:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86 Fix text_poke for vmalloced pages
Message-ID: <20080321093821.GG20420@elte.hu>
References: <20080320003908.GA4988@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320003908.GA4988@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> The shadow vmap for DEBUG_RODATA kernel text modification uses 
> virt_to_page to get the pages from the pointer address.
> 
> However, I think vmalloc_to_page would be required in case the page is 
> used for modules.
> 
> Since only the core kernel text is marked read-only, use 
> core_kernel_text() to make sure we only shadow map the core kernel 
> text, not modules.
> 
> This is an incremental change to make the DEBUG_RODATA and text_poke 
> play together nicely. A future step will be to make the module text 
> read-only too, which will require changes to load module, module free 
> and text_poke. The idea is to fix the current x86 git tree quickly.

> +	if (core_kernel_text((unsigned long)addr)) {
>  		struct page *pages[2] = { virt_to_page(addr),
>  			virt_to_page(addr + PAGE_SIZE) };
>  		if (!pages[1])
> @@ -522,6 +522,13 @@ void *__kprobes text_poke(void *addr, co
>  		memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
>  		local_irq_restore(flags);
>  		vunmap(vaddr);
> +	} else {
> +		/*
> +		 * modules are in vmalloc'ed memory, always writable.
> +		 */
> +		local_irq_save(flags);
> +		memcpy(addr, opcode, len);
> +		local_irq_restore(flags);

hm, this looks ugly, and the whole text_poke() function looks ugly. For 
example why the extra code block + indentation here:

+void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
+{
+       unsigned long flags;
+       char *vaddr;
+       int nr_pages = 2;
+
+       BUG_ON(len > sizeof(long));
+       BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
+               - ((long)addr & ~(sizeof(long) - 1)));
+       {
+               struct page *pages[2] = { virt_to_page(addr),
+                       virt_to_page(addr + PAGE_SIZE) };

also, more fundamentally - why not introduce a proper, generic "look up 
kernel text struct page *" method, instead of open-coding various 
assumptions about which kernel text is readonly and which isnt?

	Ingo
