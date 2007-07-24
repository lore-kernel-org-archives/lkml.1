Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbYLLCSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbYLLCSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 21:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbYLLCRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 21:17:49 -0500
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:39386 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756945AbYLLCRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 21:17:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1+DvMecyQkm0LWgm+AfKCN7os0Bi9gfSqJYHFJZLYzUTp+5aDi9caTNBVAKK1vH5QksN6bPB9yBwb+kJNtXs+oaeGgApUT/6+exnmMpxIByt9bdxqnWWebcz4E7D4cA9h1MSH915WMMMCXQIaYI1UDpgAiNN9f/hj+KMTzaPd34=  ;
X-YMail-OSG: pArl.UEVM1lnXEe8gzXjtv7j0YNnRmmNilKeS6HhYoW0T9yGUqfcWZWolfZG6qNMTHgDjItkrxY6x4rRhuqjdm68elxgVhvSRjL1kEB6CE36LDuOV5FlSLBTRu8hiJ0xKe_cPsFm5Ipdbo9Pdav37q2x2_kXUwCZ6vJ1eTsE
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC] vm_unmap_aliases: allow callers to inhibit TLB flush
Date: Tue, 24 Jul 2007 11:40:12 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <49416494.6040009@goop.org> <200707241052.13825.nickpiggin@yahoo.com.au> <4941C568.4070207@goop.org>
In-Reply-To: <4941C568.4070207@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241140.12945.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 December 2008 12:59, Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > Hi,
> >
> > On Friday 12 December 2008 06:05, Jeremy Fitzhardinge wrote:
> >> Hi Nick,
> >>
> >> In Xen when we're killing the lazy vmalloc aliases, we're only concerned
> >> about the pagetable references to the mapped pages, not the TLB entries.
> >
> > Hm? Why is that? Why wouldn't it matter if some page table page gets
> > written to via a stale TLB?
>
> No.  Well, yes, it would, but Xen itself will do whatever tlb flushes
> are necessary to keep it safe (it must, since it doesn't trust guest
> kernels).  It's fairly clever about working out which cpus need flushing
> and if other flushes have already done the job.

OK. Yeah, then the problem is simply that the guest may reuse that virtual
memory for another vmap.


> >> For the most part eliminating the TLB flushes would be a performance
> >> optimisation, but there's at least one case where we need to shoot down
> >> aliases in an interrupt-disabled section, so the TLB shootdown IPIs
> >> would potentially deadlock.
> >
> > So... 2.6.28 is deadlocky for you?
>
> No.  The deadlock is in the new dom0 code I'm working on.  I haven't
> posted it yet (well, it hasn't been merged).

OK, good.


> In this case, I'm swizzling the physical pages underlying a piece of
> guest pseudo-physical memory so that it is physically contiguous and/or
> under the device limit, so I can set up DMA buffers, swiotlb memory,
> etc.  This requires removing the mappings to the old pages and replacing
> them with new mappings, but I need to make sure the old pages have no
> other aliases before I can release them back to Xen.  (This can all
> happen in dma_alloc_coherent in a device driver with interrupts
> disabled, so the IPI causes deadlock warnings.)
>
> The TLB is irrelevant because Xen will make sure any stale entries are
> flushed appropriately before giving those pages out to any other domain.

OK.


> >> I'm wondering what your thoughts are about this approach?
> >
> > Doesn't work, because that's allowing virtual addresses to be reused
> > before they have TLBs flushed.
>
> Right, I see.  It's a question of flush on unmap or flush on map.

Yes. And flushing on unmap is easier of course, because we know exactly
what we've just unmapped.


> > You could have a xen specific function which goes through the lazy maps
> > and unmaps their page tables, but leaves them in the virtual address
> > allocator (so a subsequent lazy flush will still do the TLB flush before
> > allowing the addresses to be reused).
>
> Yes, that would work.

That would be my preferred approach.
