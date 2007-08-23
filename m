Return-Path: <linux-kernel-owner+w=401wt.eu-S1764227AbXHWPGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764227AbXHWPGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 11:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762117AbXHWPGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 11:06:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56616 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762345AbXHWPGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 11:06:04 -0400
Subject: Re: [patch 4/6] SLUB: Avoid touching page struct when freeing to
	per cpu slab
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070823064734.558994491@sgi.com>
References: <20070823064653.081843729@sgi.com>
	 <20070823064734.558994491@sgi.com>
Content-Type: text/plain
Date: Thu, 23 Aug 2007 17:05:58 +0200
Message-Id: <1187881558.6114.400.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-22 at 23:46 -0700, Christoph Lameter wrote:
> plain text document attachment
> (0008-SLUB-Avoid-touching-page-struct-when-freeing-to-per.patch)
> Set c->node to -1 if we allocate from a debug slab instead for SlabDebug
> which requires access the page struct cacheline.

this relies on node_match() which will only ever return !1 when
CONFIG_NUMA

> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> ---
>  mm/slub.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.23-rc3-mm1/mm/slub.c
> ===================================================================
> --- linux-2.6.23-rc3-mm1.orig/mm/slub.c	2007-08-22 17:20:28.000000000 -0700
> +++ linux-2.6.23-rc3-mm1/mm/slub.c	2007-08-22 17:20:33.000000000 -0700
> @@ -1517,6 +1517,7 @@ debug:
>  
>  	c->page->inuse++;
>  	c->page->freelist = object[c->offset];
> +	c->node = -1;
>  	slab_unlock(c->page);
>  	return object;
>  }
> @@ -1540,8 +1541,7 @@ static void __always_inline *slab_alloc(
>  
>  	local_irq_save(flags);
>  	c = get_cpu_slab(s, smp_processor_id());
> -	if (unlikely(!c->page || !c->freelist ||
> -					!node_match(c, node)))
> +	if (unlikely(!c->freelist || !node_match(c, node)))
>  
>  		object = __slab_alloc(s, gfpflags, node, addr, c);
>  
> @@ -1650,7 +1650,7 @@ static void __always_inline slab_free(st
>  	local_irq_save(flags);
>  	debug_check_no_locks_freed(object, s->objsize);
>  	c = get_cpu_slab(s, smp_processor_id());
> -	if (likely(page == c->page && !SlabDebug(page))) {
> +	if (likely(page == c->page && c->node >= 0)) {
>  		object[c->offset] = c->freelist;
>  		c->freelist = object;
>  	} else
> 

