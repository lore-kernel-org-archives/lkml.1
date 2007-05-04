Return-Path: <linux-kernel-owner+w=401wt.eu-S1767532AbXEDAy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767532AbXEDAy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 20:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767562AbXEDAy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 20:54:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43823 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767532AbXEDAy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 20:54:27 -0400
Date: Thu, 3 May 2007 17:54:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub on PowerPC
In-Reply-To: <1178238344.6353.79.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0705031744560.15240@schroedinger.engr.sgi.com>
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
 <1178238344.6353.79.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Benjamin Herrenschmidt wrote:

> > The SLUB allocator relies on struct page fields first_page and slab,
> > overwritten by ptl when SPLIT_PTLOCK: so the SLUB allocator cannot then
> > be used for the lowest level of pagetable pages.  This was obstructing
> > SLUB on PowerPC, which uses kmem_caches for its pagetables.  So convert
> > its pte level to use quicklist pages (whereas pmd, pud and 64k-page pgd
> > want partpages, so continue to use kmem_caches for pmd, pud and pgd).
> > But to keep up appearances for pgtable_free, we still need PTE_CACHE_NUM.
> 
> Interesting... I'll have a look asap.

I would also recommend looking at removing the constructors for the 
remaining slabs. A constructor requires that SLUB never touch the object 
(same situation as is resulting from enabling debugging). So it must 
increase the object size in order to put the free pointer after the 
object. In case of a order of 2 cache this has a particularly bad effect 
of doubling object size. If the objects can be overwritten on free (no 
constructor) then we can use the first word of the object as a freepointer 
on kfree. Meaning we can use a hot cacheline so no cache miss. On 
alloc we have already touched the first cacheline which also avoids a 
cacheline fetch there. This is the optimal way of operation for SLUB.

Hmmm.... We could add an option to allow the use of a constructor while
keeping the free pointer at the beginning of the object? Then we would 
have to zap the first word on alloc. Would work like quicklists.

Add SLAB_FREEPOINTER_MAY_OVERLAP?

