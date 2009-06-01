Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbZFANIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbZFANIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 09:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbZFANI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 09:08:27 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:50092 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbZFANI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 09:08:26 -0400
Message-ID: <4A23D2C7.6070400@petalogix.com>
Date: Mon, 01 Jun 2009 15:08:23 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       lethal@linux-sh.org, chris@zankel.net,
       John Williams <john.williams@petalogix.com>
Subject: Re: [PATCH] asm-generic: add dma-mapping-linear.h
References: <200905282104.55818.arnd@arndb.de> <20090601130319A.fujita.tomonori@lab.ntt.co.jp> <200906011111.28521.arnd@arndb.de>
In-Reply-To: <200906011111.28521.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 01 June 2009, FUJITA Tomonori wrote:
>   
>> On Thu, 28 May 2009 21:04:55 +0100
>>     
>>> I've added this version to
>>> git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic#next
>>>
>>> I also have patches to convert the existing architectures to use
>>> it, but I plan to submit those to the arch maintainers once asm-generic
>>> series has been merged.
>>>       
>> IMO, this need to be merged with some users. We don't want to merge
>> something that nobody wants to use.
>>     
>
> I've deliberately kept my asm-generic tree free from architecture specific
> code for now, in order to make the merging process much easier.
>
> I do have branches in there that convert x86 and microblaze to use
> all the files that they can share with the generic implementation
> and the plan is to do more of those over time, but to avoid dealing
> with all arch maintainers at the same time.
>
> Would it be ok for you if I only do this on microblaze for now (which
> does not have a dma-mapping.h yet) and leave the conversion of
> more architectures for later?
>   
Microblaze have it but it is not cleared(checked) and not in mainline -
I want to look at it when mmu is in mainline.
As I wrote before  you can use Microblaze as tested arch.

Michal

> Otherwise, I'd probably just skip dma-mapping.h in its entirety
> because there is a different is a simpler alternative for new architectures
> (setting CONFIG_NO_DMA).
>
>   
>>> +static inline dma_addr_t
>>> +dma_map_single(struct device *dev, void *ptr, size_t size,
>>> +	       enum dma_data_direction direction)
>>> +{
>>> +	dma_addr_t dma_addr = virt_to_bus(ptr);
>>> +	BUG_ON(!valid_dma_direction(direction));
>>> +
>>> +	if (!dma_coherent_dev(dev))
>>> +		dma_cache_sync(dev, ptr, size, direction);
>>>       
>> Where can I find dma_coherent_dev?
>>
>> I don't fancy this since this is architecture-specific stuff (not
>> generic things).
>>     
>
> I made this up in order to deal with the different requirements of
> the architectures I converted. In SH, it's truly device specific
> (pci may be coherent, others are never), on cris it returns false
> and on most others always true.
>
> Architectures like x86 and frv could use this hook to do th
> global flush_write_buffers() but still return zero so that
> dma_sync_sg_for_device does not have to iterate all SG
> elements doing nothing for them.
>
> Maybe it should be named __dma_coherent_dev() to make clear
> that it is a helper internal to dma_mapping.h and not supposed to
> be used by device drivers.
>
>   
>>> +static inline void
>>> +dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
>>> +			enum dma_data_direction direction)
>>> +{
>>> +	debug_dma_sync_single_for_cpu(dev, dma_handle, size, direction);
>>> +}
>>> +
>>> +static inline void
>>> +dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
>>> +			      unsigned long offset, size_t size,
>>> +			      enum dma_data_direction direction)
>>> +{
>>> +	debug_dma_sync_single_range_for_cpu(dev, dma_handle,
>>> +					    offset, size, direction);
>>> +}
>>>       
>> This looks wrong. You put dma_coherent_dev hook in sync_*_for_device
>> but why you don't need it sync_*_for_cpu. It's architecture
>> specific. Some need both, some need either, and some need nothing.
>>     
>
> It took me a while to find out what the architectures do in case of
> dma_sync_single_for_*. The noncoherent implementations all flush
> and invalidate the dcache in _for_device, which seems reasonable.
>
> In arch/sh and arch/xtensa, we also flush and invalidate the
> dcache in *_for_cpu.
> This does not seem to make sense to me, because there should
> not be any valid cache lines for that region at that time. My plan 
> was to submit patches to sh and xtensa to no longer flush the
> dcache in _for_cpu with that argument before submitting the patch
> to use the common code. Maybe Paul or Chris can comment on
> whether there is any reason for the dma flush here, if there is
> one, we probably should also flush in dma_unmap_*.
>
> AFAICT, the _for_cpu hooks are only required for swiotlb
> or for an obscure HW implementation of an IOMMU.
>
>   
>>> +static inline int
>>> +dma_supported(struct device *dev, u64 mask)
>>> +{
>>> +	/*
>>> +	 * we fall back to GFP_DMA when the mask isn't all 1s,
>>> +	 * so we can't guarantee allocations that must be
>>> +	 * within a tighter range than GFP_DMA.
>>> +	 */
>>> +	if (mask < 0x00ffffff)
>>> +		return 0;
>>>       
>> I think that this is pretty architecture specific.
>>     
>
> Yes, I wondered about this one. I suspect that the same code got
> copied blindly from x86 into all the other architectures. The
> same code exists in arm, cris, frv and mn10300, while avr32, sh
> and xtensa seem to assume that nobody passes a smaller than
> 24-bit mask in there and always return 1. They clearly could not
> handle that situation either, so the version I chose is the
> conservative approach.
>
> Do you have a better suggestion?
>
> 	Arnd <><
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

