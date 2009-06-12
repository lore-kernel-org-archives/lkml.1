Return-Path: <linux-kernel-owner+w=401wt.eu-S1763463AbZFLJfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763463AbZFLJfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbZFLJfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:35:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:58021 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbZFLJfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:35:09 -0400
Subject: Re: [PATCH] powerpc: don't pass GFP_WAIT to kmalloc() from
 *_maybe_bootmem()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, mingo@elte.hu
In-Reply-To: <Pine.LNX.4.64.0906121215090.30411@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906121215090.30411@melkki.cs.Helsinki.FI>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 19:34:58 +1000
Message-Id: <1244799298.7172.108.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 12:22 +0300, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> As slab is initialized much earlier now, we must not pass GFP_WAIT to kmalloc()
> from *_maybe_bootmem() functions; otherwise slab allocators will enable
> interrupts.
> 
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
> Ben, while we're discussing the slab side of things, can we go ahead and 
> merge this one? It should fix plenty of cases for powerpc.

We can, but it's a plaster... I won't fix it all, and again, what tells
you that things calling alloc_maybe_bootmem() don't do that specifically
-because- they can be called also much later ? (In this case, it's
__init so I'm not going to object, but I still think it's unnecessary if
we fix it properly).

Cheers,
Ben.

>  arch/powerpc/lib/alloc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/lib/alloc.c b/arch/powerpc/lib/alloc.c
> index f53e09c..56b35e3 100644
> --- a/arch/powerpc/lib/alloc.c
> +++ b/arch/powerpc/lib/alloc.c
> @@ -9,7 +9,7 @@
>  void * __init_refok alloc_maybe_bootmem(size_t size, gfp_t mask)
>  {
>  	if (mem_init_done)
> -		return kmalloc(size, mask);
> +		return kmalloc(size, mask & ~__GFP_WAIT);
>  	else
>  		return alloc_bootmem(size);
>  }
> @@ -19,7 +19,7 @@ void * __init_refok zalloc_maybe_bootmem(size_t size, gfp_t mask)
>  	void *p;
>  
>  	if (mem_init_done)
> -		p = kzalloc(size, mask);
> +		p = kzalloc(size, mask & ~__GFP_WAIT);
>  	else {
>  		p = alloc_bootmem(size);
>  		if (p)

