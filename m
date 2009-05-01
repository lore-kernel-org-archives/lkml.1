Return-Path: <linux-kernel-owner+w=401wt.eu-S1760538AbZEANmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760538AbZEANmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758160AbZEANm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:42:26 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:50448 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056AbZEANmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:42:25 -0400
Date: Fri, 1 May 2009 14:40:38 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: mel@csn.ul.ie, andi@firstfloor.org, davem@davemloft.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH mmotm] mm: alloc_large_system_hash check order
In-Reply-To: <20090429142825.6dcf233d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0905011354560.19012@blonde.anvils>
References: <Pine.LNX.4.64.0904292151350.30874@blonde.anvils>
 <20090429142825.6dcf233d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009, Andrew Morton wrote:
> 
> yes, the code is a bit odd:
> 
> :	do {
> : 		size = bucketsize << log2qty;
> : 		if (flags & HASH_EARLY)
> : 			table = alloc_bootmem_nopanic(size);
> : 		else if (hashdist)
> : 			table = __vmalloc(size, GFP_ATOMIC, PAGE_KERNEL);
> : 		else {
> : 			unsigned long order = get_order(size);
> : 			table = (void*) __get_free_pages(GFP_ATOMIC, order);
> : 			/*
> : 			 * If bucketsize is not a power-of-two, we may free
> : 			 * some pages at the end of hash table.
> : 			 */
> : 			if (table) {
> : 				unsigned long alloc_end = (unsigned long)table +
> : 						(PAGE_SIZE << order);
> : 				unsigned long used = (unsigned long)table +
> : 						PAGE_ALIGN(size);
> : 				split_page(virt_to_page(table), order);
> : 				while (used < alloc_end) {
> : 					free_page(used);
> : 					used += PAGE_SIZE;
> : 				}
> : 			}
> : 		}
> : 	} while (!table && size > PAGE_SIZE && --log2qty);
> 
> In the case where it does the __vmalloc(), the order-11 allocation will
> succeed.  But in the other cases, the allocation attempt will need to
> be shrunk and we end up with a smaller hash table.  Is that sensible?

It is a little odd, but the __vmalloc() route is used by default on
64-bit with CONFIG_NUMA, and this route otherwise.  (The hashdist
Doc isn't up-to-date on that, I'll send a patch.)

> 
> If we want to regularise all three cases, doing
> 
> 	size = min(size, MAX_ORDER);

If I take you literally, the resulting hash tables are going to
be rather small ;) but I know what you mean.

> 
> before starting the loop would be suitable, although the huge
> __get_free_pages() might still fail.

Oh, I don't feel a great urge to regularize these cases in such
a way.  I particularly don't feel like limiting 64-bit NUMA to
MAX_ORDER-1 size, if netdev have been happy with more until now.
Could consider a __vmalloc fallback when order is too large,
but let's not do so unless someone actually needs that.

> (But it will then warn, won't it?
>  And nobody is reporting that).

Well, it was hard to report it while mmotm's WARN_ON_ONCE was itself
oopsing.  With that fixed, I've reported it on x86_64 with 4GB
(without CONFIG_NUMA).

> 
> I was a bit iffy about adding the warning in the first place, let it go
> through due to its potential to lead us to code which isn't doing what
> it thinks it's doing, or is being generally peculiar.

DaveM has confirmed that the code is doing what they want it to do.
So I think mmotm wants this patch (for alloc_large_system_hash to
keep away from that warning), plus Mel's improvement on top of it.

Hugh
