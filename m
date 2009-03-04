Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbZCDHkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbZCDHkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 02:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZCDHj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 02:39:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbZCDHj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 02:39:57 -0500
Date: Tue, 3 Mar 2009 23:39:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Pitre <nico@cam.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [RFC] atomic highmem kmap page pinning
Message-Id: <20090303233908.32e05aa4.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0903040014140.5511@xanadu.home>
References: <alpine.LFD.2.00.0903040014140.5511@xanadu.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Mar 2009 00:58:13 -0500 (EST) Nicolas Pitre <nico@cam.org> wrote:

> I've implemented highmem for ARM.  Yes, some ARM machines do have lots 
> of memory...
> 
> The problem is that most ARM machines have a non IO coherent cache, 
> meaning that the dma_map_* set of functions must clean and/or invalidate 
> the affected memory manually.  And because the majority of those 
> machines have a VIVT cache, the cache maintenance operations must be 
> performed using virtual addresses.
> 
> In dma_map_page(), an highmem pages could still be mapped and cached 
> even after kunmap() was called on it.  As long as highmem pages are 
> mapped, page_address(page) is non null and we can use that to 
> synchronize the cache.
> 
> It is unlikely but still possible for kmap() to race and recycle the 
> obtained virtual address above, and use it for another page though.  In 
> that case, the new mapping could end up with dirty cache lines for 
> another page, and the unsuspecting cache invalidation loop in 
> dma_map_page() won't notice resulting in data loss.  Hence the need for 
> some kind of kmap page pinning which can be used in any context, 
> including IRQ context.
> 
> This is a RFC patch implementing the necessary part in the core code, as 
> suggested by RMK. Please comment.

Seems harmless enough to me.

> +void *kmap_high_get(struct page *page)
> +{
> +	unsigned long vaddr, flags;
> +
> +	spin_lock_irqsave(&kmap_lock, flags);
> +	vaddr = (unsigned long)page_address(page);
> +	if (vaddr) {
> +		BUG_ON(pkmap_count[PKMAP_NR(vaddr)] < 1);
> +		pkmap_count[PKMAP_NR(vaddr)]++;
> +	}
> +	spin_unlock_irqrestore(&kmap_lock, flags);
> +	return (void*) vaddr;
> +}

We could remove a pile of ugly casts if we changed PKMAP_NR() to take a
void*.  Not that this is relevant.


