Return-Path: <linux-kernel-owner+w=401wt.eu-S936015AbXHOT4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936015AbXHOT4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 15:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbXHOT4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 15:56:08 -0400
Received: from igw1.br.ibm.com ([32.104.18.24]:52054 "EHLO igw1.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbXHOT4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 15:56:07 -0400
Subject: Re: SLUB doesn't work with kdump kernel on Cell
From: Lucio Correia <ljhc@br.ibm.com>
Reply-To: ljhc@br.ibm.com
To: Christoph Lameter <clameter@sgi.com>
Cc: Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arndb@arndb.de>
In-Reply-To: <Pine.LNX.4.64.0708141910230.1409@schroedinger.engr.sgi.com>
References: <1186604151.3608.46.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0708081321400.14478@schroedinger.engr.sgi.com>
	 <1187106239.3298.2.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0708141241450.30435@schroedinger.engr.sgi.com>
	 <dc1166600708141757q26c005d7o4c9c4d69e9d28460@mail.gmail.com>
	 <Pine.LNX.4.64.0708141910230.1409@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: IBM
Date: Wed, 15 Aug 2007 16:57:12 -0300
Message-Id: <1187207832.3002.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 19:11 -0700, Christoph Lameter wrote:
> Can you try this patch?

Thanks, Christoph

It worked fine, both for normal kernel and for dump kernel on Cell. Is
this patch intended to go mainline?

> 
> From 74863f472810cb58dc56dde050616581d38f7673 Mon Sep 17 00:00:00 2001
> From: Christoph Lameter <christoph@qirst.com>
> Date: Tue, 14 Aug 2007 19:09:00 -0700
> Subject: [PATCH] SLUB: Do not fail on broken memory configurations
> 
> Print a big fat warning and do what is necessary to continue if a node
> is marked as up but allocations from the node do not succeed.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> ---
>  mm/slub.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 1488e71..fc82751 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1877,9 +1877,16 @@ static struct kmem_cache_node * __init early_kmem_cache_node_alloc(gfp_t gfpflag
>  
>  	BUG_ON(kmalloc_caches->size < sizeof(struct kmem_cache_node));
>  
> -	page = new_slab(kmalloc_caches, gfpflags | GFP_THISNODE, node);
> -
> +	page = new_slab(kmalloc_caches, gfpflags, node);
>  	BUG_ON(!page);
> +
> +	if (page_to_nid(page) != node) {
> +		printk(KERN_ERR "SLUB: Unable to allocate memory from "
> +				"node %d\n", node);
> +		printk(KERN_ERR "SLUB: Allocating a useless per node structure"
> +				" in order to be able to continue\n");
> +	}
> +
>  	n = page->freelist;
>  	BUG_ON(!n);
>  	page->freelist = get_freepointer(kmalloc_caches, n);


-- 
Lucio Correia
Software Engineer
IBM LTC Brazil

