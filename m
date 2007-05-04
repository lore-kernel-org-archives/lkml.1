Return-Path: <linux-kernel-owner+w=401wt.eu-S1767513AbXEDA0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767513AbXEDA0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 20:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767529AbXEDA0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 20:26:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:39053 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767513AbXEDA0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 20:26:03 -0400
Subject: Re: 2.6.22 -mm merge plans: slub on PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0705032143420.7589@blonde.wat.veritas.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
	 <20070501125559.9ab42896.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0705011403470.26819@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0705021330001.16517@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0705021017270.32635@schroedinger.engr.sgi.com>
	 <20070503011515.0d89082b.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0705030936120.5165@blonde.wat.veritas.com>
	 <20070503015729.7496edff.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0705031011020.9826@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0705032143420.7589@blonde.wat.veritas.com>
Content-Type: text/plain
Date: Fri, 04 May 2007 10:25:44 +1000
Message-Id: <1178238344.6353.79.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 22:04 +0100, Hugh Dickins wrote:
> On Thu, 3 May 2007, Hugh Dickins wrote:
> > 
> > Seems we're all wrong in thinking Christoph's Kconfiggery worked
> > as intended: maybe it just works some of the time.  I'm not going
> > to hazard a guess as to how to fix it up, will resume looking at
> > the powerpc's quicklist potential later.
> 
> Here's the patch I've been testing on G5, with 4k and with 64k pages,
> with SLAB and with SLUB.  But, though it doesn't crash, the pgd
> kmem_cache in the 4k-page SLUB case is revealing SLUB's propensity
> for using highorder allocations where SLAB would stick to order 0:
> under load, exec's mm_init gets page allocation failure on order 4
> - SLUB's calculate_order may need some retuning.  (I'd expect it to
> be going for order 3 actually, I'm not sure how order 4 comes about.)
> 
> I don't know how offensive Ben and Paulus may find this patch:
> the kmem_cache use was nicely done and this messes it up a little.
> 
> 
> The SLUB allocator relies on struct page fields first_page and slab,
> overwritten by ptl when SPLIT_PTLOCK: so the SLUB allocator cannot then
> be used for the lowest level of pagetable pages.  This was obstructing
> SLUB on PowerPC, which uses kmem_caches for its pagetables.  So convert
> its pte level to use quicklist pages (whereas pmd, pud and 64k-page pgd
> want partpages, so continue to use kmem_caches for pmd, pud and pgd).
> But to keep up appearances for pgtable_free, we still need PTE_CACHE_NUM.

Interesting... I'll have a look asap.

Ben.


