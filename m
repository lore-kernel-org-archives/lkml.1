Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbYLLB7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbYLLB7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 20:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756623AbYLLB7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 20:59:09 -0500
Received: from gw.goop.org ([64.81.55.164]:48219 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756466AbYLLB7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 20:59:08 -0500
Message-ID: <4941C568.4070207@goop.org>
Date: Thu, 11 Dec 2008 17:59:04 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH RFC] vm_unmap_aliases: allow callers to inhibit TLB flush
References: <49416494.6040009@goop.org> <200707241052.13825.nickpiggin@yahoo.com.au>
In-Reply-To: <200707241052.13825.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Hi,
>
> On Friday 12 December 2008 06:05, Jeremy Fitzhardinge wrote:
>   
>> Hi Nick,
>>
>> In Xen when we're killing the lazy vmalloc aliases, we're only concerned
>> about the pagetable references to the mapped pages, not the TLB entries.
>>     
>
> Hm? Why is that? Why wouldn't it matter if some page table page gets
> written to via a stale TLB?
>   

No.  Well, yes, it would, but Xen itself will do whatever tlb flushes 
are necessary to keep it safe (it must, since it doesn't trust guest 
kernels).  It's fairly clever about working out which cpus need flushing 
and if other flushes have already done the job.

>> For the most part eliminating the TLB flushes would be a performance
>> optimisation, but there's at least one case where we need to shoot down
>> aliases in an interrupt-disabled section, so the TLB shootdown IPIs
>> would potentially deadlock.
>>     
>
> So... 2.6.28 is deadlocky for you?
>   

No.  The deadlock is in the new dom0 code I'm working on.  I haven't 
posted it yet (well, it hasn't been merged).

In this case, I'm swizzling the physical pages underlying a piece of 
guest pseudo-physical memory so that it is physically contiguous and/or 
under the device limit, so I can set up DMA buffers, swiotlb memory, 
etc.  This requires removing the mappings to the old pages and replacing 
them with new mappings, but I need to make sure the old pages have no 
other aliases before I can release them back to Xen.  (This can all 
happen in dma_alloc_coherent in a device driver with interrupts 
disabled, so the IPI causes deadlock warnings.)

The TLB is irrelevant because Xen will make sure any stale entries are 
flushed appropriately before giving those pages out to any other domain.

>> I'm wondering what your thoughts are about this approach?
>>     
>
> Doesn't work, because that's allowing virtual addresses to be reused
> before they have TLBs flushed.
>   

Right, I see.  It's a question of flush on unmap or flush on map.

> You could have a xen specific function which goes through the lazy maps
> and unmaps their page tables, but leaves them in the virtual address
> allocator (so a subsequent lazy flush will still do the TLB flush before
> allowing the addresses to be reused).
>   

Yes, that would work.

    J
