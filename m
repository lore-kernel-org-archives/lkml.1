Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbZEUS2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbZEUS2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 14:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbZEUS2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 14:28:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:40645 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbZEUS2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 14:28:05 -0400
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Ian Campbell <Ian.Campbell@citrix.com>
Message-Id: <E6DAA792-9923-4B76-9759-6955AABE3EAB@kernel.crashing.org>
From: Becky Bruce <beckyb@kernel.crashing.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <4A1592CF.8000208@goop.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH V2 2/3] powerpc: Add support for swiotlb on 32-bit
Date: Thu, 21 May 2009 13:27:36 -0500
References: <1242340949-16369-1-git-send-email-beckyb@kernel.crashing.org> <1242340949-16369-2-git-send-email-beckyb@kernel.crashing.org> <20090519142656T.fujita.tomonori@lab.ntt.co.jp> <19E48A70-3332-423C-ACAD-390F940EE81C@kernel.crashing.org> <4A1592CF.8000208@goop.org>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 21, 2009, at 12:43 PM, Jeremy Fitzhardinge wrote:

> Becky Bruce wrote:
>>>
>>>
>>> If we have something like in arch/{x86|ia64|powerpc}/dma-mapping.h:
>>>
>>> static inline int is_buffer_dma_capable(struct device *dev,  
>>> dma_addr_t addr, size_t size)
>>>
>>> then we don't need two checking functions, address_needs_mapping and
>>> range_needs_mapping.
>>
>> It's never been clear to me *why* we had both in the first place -  
>> if you can explain this, I'd be grateful :)
>
> I was about to ask the same thing.  It seems that  
> range_needs_mapping should be able to do both jobs.
>
> I think range_needs_mapping came from the Xen swiotlb changes, and  
> address_needs_mapping came from your powerpc changes.   Many of the  
> changes were exact overlaps; I think this was one of the few  
> instances where there was a difference.

I think address_needs_mapping was already there and I added the  
ability for an arch to provide its own version.  Ian added  
range_needs_mapping in commit b81ea27b2329bf44b.   At the time, it  
took a virtual address as its argument, so we couldn't use it for  
highmem.  That's since been changed to phys_addr_t, so I think we  
should be able to merge the two.

>
> We need a range check in Xen (rather than iterating over individual  
> pages) because we want to check that the underlying pages are  
> machine contiguous, but I think that's also sufficient to do  
> whatever checks you need to do.

Yes.

>
> The other difference is that is_buffer_dma_capable operates on a  
> dma_addr_t, which presumes that you can generate a dma address and  
> then test for its validity.  For Xen, it doesn't make much sense to  
> talk about the dma_addr_t for memory which isn't actually dma- 
> capable; we need the test to be in terms of phys_addr_t.  Given that  
> the two functions are always called from the same place, that  
> doesn't seem to pose a problem.
>
> So I think the unified function would be something like:
>
>   int range_needs_mapping(struct device *hwdev, phys_addr_t addr,
>   size_t size);
>
> which would be defined somewhere under asm/*.h.  Would that work for  
> powerpc?

I can work with that, but it's going to be a bit inefficient, as I  
actually need the dma_addr_t, not the phys_addr_t, so I'll have to  
convert.  In every case, this is a conversion I've already done and  
that I need in the calling code as well.  Can we pass in both the  
phys_addr_t and the dma_addr_t?  We have both in every case but one,  
which is in swiotlb_map_page where we call address_needs_mapping()  
without calling range_needs_mapping.  It's not actually clear to me  
that we need that check, though.  Can someone explain what case that  
was designed to catch?

Cheers,
Becky

