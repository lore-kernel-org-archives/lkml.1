Return-Path: <linux-kernel-owner+w=401wt.eu-S932999AbZIDHrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999AbZIDHrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932596AbZIDHrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:47:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48138 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932966AbZIDHrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:47:19 -0400
Date: Fri, 4 Sep 2009 09:46:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH V3] x86: NX protection for kernel data
Message-ID: <20090904074626.GC20598@elte.hu>
References: <817ecb6f0909031813n335279a3pb974b9efa8989095@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <817ecb6f0909031813n335279a3pb974b9efa8989095@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Siarhei Liakh <sliakh.lkml@gmail.com> wrote:

> This patch expands functionality of CONFIG_DEBUG_RODATA to set main
> (static) kernel data area as NX.
> The following steps are taken to achieve this:
> 1. Linker script is adjusted so .text always starts and ends on a page boundary
> 2. Linker script is adjusted so .rodata and .data always start and
> end on a page boundary
> 3. void mark_nxdata_nx(void) added to arch/x86/mm/init.c with actual
> functionality: NX is set for all pages from _etext through _end.
> 4. mark_nxdata_nx() called from free_initmem() (after init has been released)
> 5. free_init_pages() sets released memory NX in arch/x86/mm/init.c
> 
> The patch have been developed for Linux 2.6.31-rc7 x86 by Siarhei Liakh
> <sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.
> 
> V1:  initial patch for 2.6.30
> V2:  patch for 2.6.31-rc7
> V3:  moved all code into arch/x86, adjusted credits

ok, i like it.

One small cleanliness detail before we can apply it to the x86 tree:

> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -440,11 +441,31 @@ void free_init_pages(char *what, unsigned long
> begin, unsigned long end)
>  #endif
>  }
> 
> +#ifndef CONFIG_DEBUG_RODATA
> +static inline void mark_nxdata_nx(void) { }
> +#else
> +void mark_nxdata_nx(void)
> +{
> +	/*
> +	 * When this called, init has already been executed and released,
> +	 * so everything past _etext sould be NX.
> +	 */
> +	unsigned long start = PFN_ALIGN(_etext);
> +	unsigned long size = PFN_ALIGN(_end) - start;
> +
> +	printk(KERN_INFO "NX-protecting the kernel data: %lx, %lu pages\n",
> +		start, size >> PAGE_SHIFT);
> +	set_pages_nx(virt_to_page(start), size >> PAGE_SHIFT);
> +}
> +#endif

This #ifdef looks ugly, it starts with an #ifndef which is inverted 
logic and mark_nxdata_nx() is a global symbol, needlessly. It should 
be written as something like:

static void mark_nxdata_nx(void)
{
#ifdef CONFIG_DEBUG_RODATA
...
#endif
}

Thanks,

	Ingo
