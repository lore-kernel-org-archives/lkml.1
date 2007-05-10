Return-Path: <linux-kernel-owner+w=401wt.eu-S1761252AbXEJUfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761252AbXEJUfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758085AbXEJUf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:35:26 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34737 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758076AbXEJUf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:35:26 -0400
Date: Thu, 10 May 2007 13:35:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
In-Reply-To: <20070510203102.GO19966@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0705101333420.11826@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com>
 <20070510203102.GO19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, William Lee Irwin III wrote:

> So now quicklist semantics vs. TLB flushing are the motive behind the
> odd flush_tlb_mm() affair. The real trick with it is that flushing
> must never occur until the TLB flush. Any change to the core quicklist
> code that retires pages back to the page allocator earlier (e.g. based
> on some limit) will break things badly.

Right.

> On Thu, May 10, 2007 at 09:03:39PM +0100, Hugh Dickins wrote:
> >> -struct kmem_cache *pgd_cache;
> >>  struct kmem_cache *pmd_cache;
> >>  
> >>  void __init pgtable_cache_init(void)
> >> @@ -776,12 +775,6 @@ void __init pgtable_cache_init(void)
> >>  			pgd_size = PAGE_SIZE;
> >>  		}
> >>  	}
> >> -	pgd_cache = kmem_cache_create("pgd",
> >> -				pgd_size,
> >> -				pgd_size,
> >> -				SLAB_PANIC,
> >> -				pgd_ctor,
> >> -				(!SHARED_KERNEL_PMD) ? pgd_dtor : NULL);
> >>  }
> 
> This is wrong; pgd's are smaller than PAGE_SIZE on PAE. Burning lowmem
> like this is very, very bad for such systems. pmd_cache is rather
> trivial to convert to quicklists, since all it does is zero pages. I
> still don't approve of even the !SHARED_KERNEL_PMD case using PAGE_SIZE
> -sized pgd's. Xen should really be fixed to avoid requiring guests to
> have recursive pagetables or whatever it's doing.

But the Xen guys need the full sized pgd?

> 
> >> @@ -205,8 +206,6 @@ void pmd_ctor(void *pmd, struct kmem_cac
> >>   * against pageattr.c; it is the unique case in which a valid change
> >>   * of kernel pagetables can't be lazily synchronized by vmalloc faults.
> >>   * vmalloc faults work because attached pagetables are never freed.
> >> - * The locking scheme was chosen on the basis of manfred's
> >> - * recommendations and having no core impact whatsoever.
> >>   * -- wli
> >>   */
> >>  DEFINE_SPINLOCK(pgd_lock);
> 
> This comment deletion is bogus, as the locking scheme has not changed.

The interaction with SLAB has changed with the conversion to quicklists. 
AFAIK Manfred's suggestions were due to the use of the slab allocator to manage 
pgds.

