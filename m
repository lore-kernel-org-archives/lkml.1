Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbXGIJMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbXGIJMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbXGIJMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:12:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:54573 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbXGIJMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:12:35 -0400
Subject: Re: [RFC/PATCH] Use mmu_gather for fork() instead of flush_tlb_mm()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-mm@kvack.org, Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <4691E64F.5070506@yahoo.com.au>
References: <1183952874.3388.349.camel@localhost.localdomain>
	 <1183962981.5961.3.camel@localhost.localdomain>
	 <1183963544.5961.6.camel@localhost.localdomain>
	 <4691E64F.5070506@yahoo.com.au>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 19:12:29 +1000
Message-Id: <1183972349.5961.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-09 at 17:39 +1000, Nick Piggin wrote:

> Would it be better off to start off with a new API for this? The
> mmu gather I think is traditionally entirely for dealing with
> page removal...

It would be weird because the new API would mostly duplicate this one,
and we would end up with duplicated hooks..

I think it's fine to have one mmu_gather construct to gather changes to
PTEs, it doesn't have to contain freed pages, though it can. Appart from
that simple nr test, it's entirely the same code and the existing
implementation for all archs should just work (well, should, I haven't
actually looked in details yet :-)

Maybe we can use a separate call than tlb_remove_tlb_entry() tho,
something like tlb_invalidate_entry(), which by default would do the
same but that archs can override if they want to distinguish page
freeing and simple invalidations at that level.

That means adding a suitable default __tlb_invalidate_entry() to all
archs but that shouldn't be too hard with a bit of help from the various
maintainers.

But I think the rest of the mmu_gather interface should stay the same.

I would like to add a few more things to it next, mostly:

 - tlb_gather_lockdrop() (or find a better name) called just before we
drop the page table / PTE lock. That would allow me to bring back ppc64
to use the normal mmu_gather API instead of hijacking the lazy mmu stuff
as it's doing now by flushing my batches before the lock is dropped.

 - start moving over pretty much everything that walks page tables to it

So that in the end, we basically go down to:

 - flush_tlb_page() for single page invalidates (protection faults for
example)

 - mmu_gather batches for everything else userland

 - possibly stick to something else for kernel mappings, to be
discussed. I'm find with doing batches there too :-)

The current situation is just too messy imho, and generalizing batches
will be useful to platforms like hash table ppc's or funky TLBs.

Ben.



