Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbZBJWp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbZBJWp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbZBJWpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:45:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756001AbZBJWpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:45:08 -0500
Date: Tue, 10 Feb 2009 14:44:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: hch@infradead.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch] mm: vmap fix overflow
Message-Id: <20090210144420.2e7bb9a9.akpm@linux-foundation.org>
In-Reply-To: <20090210055119.GE28301@wotan.suse.de>
References: <20090210055119.GE28301@wotan.suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009 06:51:19 +0100
Nick Piggin <npiggin@suse.de> wrote:

> This patch is appropriate for 2.6.28 too.
> 
> --
> 
> The new vmap allocator can wrap the address and get confused in the case of
> large allocations or VMALLOC_END near the end of address space.
> 
> Problem reported by Christoph Hellwig on a 32-bit XFS workload.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
>  mm/vmalloc.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> Index: linux-2.6/mm/vmalloc.c
> ===================================================================
> --- linux-2.6.orig/mm/vmalloc.c
> +++ linux-2.6/mm/vmalloc.c
> @@ -334,6 +334,9 @@ retry:
>  	addr = ALIGN(vstart, align);
>  
>  	spin_lock(&vmap_area_lock);
> +	if (addr + size < addr)
> +		goto overflow;
> +
>  	/* XXX: could have a last_hole cache */
>  	n = vmap_area_root.rb_node;
>  	if (n) {
> @@ -365,6 +368,8 @@ retry:
>  
>  		while (addr + size > first->va_start && addr + size <= vend) {
>  			addr = ALIGN(first->va_end + PAGE_SIZE, align);
> +			if (addr + size < addr)
> +				goto overflow;
>  
>  			n = rb_next(&first->rb_node);
>  			if (n)
> @@ -375,6 +380,7 @@ retry:
>  	}
>  found:
>  	if (addr + size > vend) {
> +overflow:
>  		spin_unlock(&vmap_area_lock);
>  		if (!purged) {
>  			purge_vmap_area_lazy();

well...


If a caller tries to allocate 0x1000 bytes at address 0xfffff000, this
code will think that it overflowed.  But it didn't.

Presumably nobody ever tries to do that, but it seems a bit sloppy?
