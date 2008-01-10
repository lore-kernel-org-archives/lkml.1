Return-Path: <linux-kernel-owner+w=401wt.eu-S1757047AbYAJTrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbYAJTrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759306AbYAJTq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:46:59 -0500
Received: from relay2.sgi.com ([192.48.171.30]:50483 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758691AbYAJTq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:46:57 -0500
Date: Thu, 10 Jan 2008 11:46:56 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Matt Mackall <mpm@selenic.com>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hugh@veritas.com>,
       Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
In-Reply-To: <alpine.LFD.1.00.0801101124140.3148@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0801101143180.20926@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.00.0801101124140.3148@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008, Linus Torvalds wrote:

> It's not even clear that a buddy allocator even for the high-order pages 
> is at all the right choice. Almost nobody actually wants >64kB blocks, and 
> the ones that *do* want bigger allocations tend to want *much* bigger 
> ones, so it's quite possible that it could be worth it to have something 
> like a three-level allocator:

Excellent! I am definitely on board with this.

>  - huge pages (superpages for those crazy db people)
> 
>    Just a simple linked list of these things is fine, we'd never care 
>    about coalescing large pages together anyway.
> 
>  - "large pages" (on the order of ~64kB) - with *perhaps* a buddy bitmap 
>    setup to try to coalesce back into huge-pages, but more likely just 
>    admitting that you'd need something like migration to ever get back a 
>    hugepage that got split into large-pages.
> 
>    So maybe a simple bitmap allocator per huge-page for large pages. Say 
>    you have a 4MB huge-page, and just a 64-bit free-bitmap per huge-page 
>    when you split it into large pages.
> 
>  - slab/slub/slob for anything else, and "get_free_page()" ends up being 
>    just a shorthand for saying "naturally aligned kmalloc of size 
>    "PAGE_SIZE<<order"
> 
> and maybe it would all work out ok. 

Hmmm... a 3 level allocator? Basically we would have BASE_PAGE 
STANDARD_PAGE and HUGE_PAGE? We could simply extend the page allocator to 
have 3 pcp lists for these sizes and go from there?

Thinking about the arches this would mean

	BASE_PAGE	STANDARD_PAGE	HUGE_PAGE
x86_64	4k		64k		2M
i386	4k		16k		4M
ia64	16k		256k		1G

?

