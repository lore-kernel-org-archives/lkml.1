Return-Path: <linux-kernel-owner+w=401wt.eu-S1757797AbZDIAJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbZDIAJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 20:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756732AbZDIAJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 20:09:31 -0400
Received: from gw.goop.org ([64.81.55.164]:52046 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032AbZDIAJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 20:09:30 -0400
Message-ID: <49DD3C9C.7060101@goop.org>
Date: Wed, 08 Apr 2009 17:09:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: galak@kernel.crashing.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, ian.campbell@citrix.com, beckyb@kernel.crashing.org
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of address_needs_mapping
References: <49DD270A.6060506@goop.org>	<20090409080143C.fujita.tomonori@lab.ntt.co.jp>	<49DD3041.8020808@goop.org> <20090409083752I.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090409083752I.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Wed, 08 Apr 2009 16:16:17 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> FUJITA Tomonori wrote:
>>     
>>>> Becky's patches of last week also added __weak annotations to 
>>>> swiotlb_bus_to_virt, virt_to_bus and bus_to_phys; added the hwdev 
>>>> parameter to swiotlb_bus_to_phys; and added a weak 
>>>> swiotlb_arch_address_needs_mapping.  I assume that was needed because 
>>>> powerpc needs non-trivial implementations for those functions.
>>>>     
>>>>         
>>> Hmm, what she added are wrappers of virt_to_bus and bus_to_virt. We
>>> can remove these and directly use virt_to_bus and bus_to_virt.
>>>   
>>>       
>> In general those interfaces are deprecated.  Are we un-deprecating 
>> them?  Or do you mean adding virt<->bus to dma_ops?
>>     
>
> Hmm, these interfaces are wrong for drivers surely because they can't
> handle dma mapping properly. However, they are exactly what swiotlb
> needs (swiotlb doesn't need to care about dma mapping).

It needs to care about the mapping from phys to bus.  On x86 they're 
identical, but on powerpc there can be at least an offset between them.

>  Until 2.6.28,
> swiotlb has used them. They are with IA64, X86_64 and PPC_32, I think.
>   

Well, Becky's patches also added the hwdev argument to them, so 
presumably the powerpc implementation needs that (different 
devices/buses have differing views of physical memory, I guess).

> I'm not sure what you mean. And I don't think ppc wants swiotlb_alloc.
>   

No, its something we need for Xen.  I was thinking that swiotlb could 
allocate its memory with dma_alloc_coherent(NULL, size, ...).  That 
would allocate via x86_fallback_device, which would not have the right 
behaviour (it would set GFP_DMA, for a start), and would end up hitting 
the uninitialized dma_ops.  So the idea doesn't really work; it would 
need swiotlb to define another placeholder  device who's alloc_coherent 
operation could be overridden, and it all gets pretty ugly.

As an aside, I'm also wondering why there's a distinction between 
swiotlb_alloc() and swiotlb_alloc_boot().  The latter allocates from 
bootmem, but I don't see what's wrong with allocating from slab a little 
bit later, once it has been initialized.  The comment mentions something 
about allocating ISA DMA memory, but the code doesn't make any attempt 
to allocate the buffer below 16MB (its generally much larger than 16MB 
anyway).

    J
