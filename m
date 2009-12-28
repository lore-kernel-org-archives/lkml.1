Return-Path: <linux-kernel-owner+w=401wt.eu-S1751355AbZL1Ifv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbZL1Ifv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZL1Ifu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:35:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50581 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbZL1Ifu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:35:50 -0500
Date: Mon, 28 Dec 2009 09:35:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/2] sparsemem: put mem map for one node together.
Message-ID: <20091228083525.GJ28652@elte.hu>
References: <4B2B4C19.6010402@kernel.org>
 <4B2B4FF9.3090806@kernel.org>
 <4B2DEC5C.8000108@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2DEC5C.8000108@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> add vmemmap_alloc_block_buf for mem map only.
> 
> it will fallback old wayif can not get that big.
> 
> it will help system with more memory that use early_res instead of bootmem
> that can not handle too many entries
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/mm/init_64.c |    2 
>  include/linux/mm.h    |    7 +++
>  mm/sparse-vmemmap.c   |   70 +++++++++++++++++++++++++++++++
>  mm/sparse.c           |  111 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 187 insertions(+), 3 deletions(-)


> +++ linux-2.6/mm/sparse-vmemmap.c
> @@ -43,6 +43,8 @@ static void * __init_refok __earlyonly_b
>  	return __alloc_bootmem_node_high(NODE_DATA(node), size, align, goal);
>  }
>  
> +static void *buf;
> +static void *buf_end;

there's so many buf's in the kernel - this naming isnt very intuitive. Also, 
they should perhaps be __initdata-ish?

>  void * __meminit vmemmap_alloc_block(unsigned long size, int node)
>  {
> @@ -64,6 +66,24 @@ void * __meminit vmemmap_alloc_block(uns
>  				__pa(MAX_DMA_ADDRESS));
>  }
>  
> +/* need to make sure size is all the same during early stage */
> +void * __meminit vmemmap_alloc_block_buf(unsigned long size, int node)
> +{
> +	void *ptr;
> +
> +	if (!buf)
> +		return vmemmap_alloc_block(size, node);
> +
> +	/* take the from buf */
> +	ptr = (void *)ALIGN((unsigned long)buf, size);

Hm, two type cast in the same line.

these kinds of x86-64-isms:

> +++ linux-2.6/mm/sparse.c
>
> +#ifndef CONFIG_X86_64
> +#ifdef CONFIG_X86_64
> +#ifdef CONFIG_X86_64
> +#else
> +#endif
> +#ifdef CONFIG_X86_64
> +#endif

are not particularly welcome constructs in core MM files. Appropriately 
structured Kconfig helper bools, selected by arch's, are cleaner.

These patches need more work.

	Ingo
