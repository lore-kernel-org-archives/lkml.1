Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbZESU5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbZESU5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 16:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZESU5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 16:57:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:59754 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbZESU5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 16:57:40 -0400
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-Id: <19E48A70-3332-423C-ACAD-390F940EE81C@kernel.crashing.org>
From: Becky Bruce <beckyb@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090519142656T.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH V2 2/3] powerpc: Add support for swiotlb on 32-bit
Date: Tue, 19 May 2009 15:57:31 -0500
References: <1242340949-16369-1-git-send-email-beckyb@kernel.crashing.org> <1242340949-16369-2-git-send-email-beckyb@kernel.crashing.org> <20090519142656T.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 19, 2009, at 12:27 AM, FUJITA Tomonori wrote:

> CC'ed linux-kernel
>
> On Thu, 14 May 2009 17:42:28 -0500
> Becky Bruce <beckyb@kernel.crashing.org> wrote:

>
>
>> This patch includes the basic infrastructure to use swiotlb
>> bounce buffering on 32-bit powerpc.  It is not yet enabled on
>> any platforms.  Probably the most interesting bit is the
>> addition of addr_needs_map to dma_ops - we need this as
>> a dma_op because the decision of whether or not an addr
>> can be mapped by a device is device-specific.
>>
>> Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>

<snip>

>> +/*
>> + * Determine if an address needs bounce buffering via swiotlb.
>> + * Going forward I expect the swiotlb code to generalize on using
>> + * a dma_ops->addr_needs_map, and this function will move from  
>> here to the
>> + * generic swiotlb code.
>> + */
>> +int
>> +swiotlb_arch_address_needs_mapping(struct device *hwdev,  
>> dma_addr_t addr,
>> +				   size_t size)
>> +{
>> +	struct dma_mapping_ops *dma_ops = get_dma_ops(hwdev);
>> +
>> +	BUG_ON(!dma_ops);
>> +	return dma_ops->addr_needs_map(hwdev, addr, size);
>> +}
>> +
>> +/*
>> + * Determine if an address is reachable by a pci device, or if we  
>> must bounce.
>> + */
>> +static int
>> +swiotlb_pci_addr_needs_map(struct device *hwdev, dma_addr_t addr,  
>> size_t size)
>> +{
>> +	u64 mask = dma_get_mask(hwdev);
>> +	dma_addr_t max;
>> +	struct pci_controller *hose;
>> +	struct pci_dev *pdev = to_pci_dev(hwdev);
>> +
>> +	hose = pci_bus_to_host(pdev->bus);
>> +	max = hose->dma_window_base_cur + hose->dma_window_size;
>> +
>> +	/* check that we're within mapped pci window space */
>> +	if ((addr + size > max) | (addr < hose->dma_window_base_cur))
>> +		return 1;
>> +
>> +	return !is_buffer_dma_capable(mask, addr, size);
>> +}
>> +
>> +static int
>> +swiotlb_addr_needs_map(struct device *hwdev, dma_addr_t addr,  
>> size_t size)
>> +{
>> +	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
>> +}
>
> I think that swiotlb_pci_addr_needs_map and swiotlb_addr_needs_map
> don't need swiotlb_arch_range_needs_mapping() since
>
> - swiotlb_arch_range_needs_mapping() is always used with
> swiotlb_arch_address_needs_mapping().

Yes.  I don't need range_needs_mapping() on ppc, so I let it default  
to the lib/swiotlb.c implementation, which just returns 0.  All the  
determination of whether an address needs mapping comes from  
swiotlb_arch_address_needs_mapping().

>
>
> - swiotlb_arch_address_needs_mapping() uses is_buffer_dma_capable()
> and powerpc doesn't overwrite swiotlb_arch_address_needs_mapping()

I *do* overwrite it.  But I still use is_buffer_dma_capable().  I just  
add some other checks to it in the pci case, because I need to know  
what the controller has mapped as it changes the point at which I must  
begin to bounce buffer.

>
>
>
> Do I miss something?

I don't think so.  But let me know if I've misunderstood you.

>
>
> Anyway, we need to fix swiotlb checking code to if an area is
> DMA-capable or not.
>
> swiotlb_arch_address_needs_mapping() calls is_buffer_dma_capable() in
> dma-mapping.h but it should not. It should live in an arch-specific
> place such as arch's dma-mapping.h or something since
> is_buffer_dma_capable() is arch-specific. I didn't know that
> is_buffer_dma_capable() is arch-specific when I added it to the
> generic place.

Errrr, is_buffer_dma_capable is generic right now, unless I'm missing  
something.  It's in include/linux/dma-mapping.h, unless I'm getting  
bitten by a slightly stale tree.

>
>
> If we have something like in arch/{x86|ia64|powerpc}/dma-mapping.h:
>
> static inline int is_buffer_dma_capable(struct device *dev,  
> dma_addr_t addr, size_t size)
>
> then we don't need two checking functions, address_needs_mapping and
> range_needs_mapping.

It's never been clear to me *why* we had both in the first place - if  
you can explain this, I'd be grateful :)

It actually looks like we want to remove the dma_op that I created for  
addr_needs_map because of the perf hit.... it gets called a ton of  
times, many times on addresses that don't actually require bounce  
buffering (and thus, are more sensitive to the minor performance  
hit).  We are looking instead at adding a per-device variable that is  
used to determine if we need to bounce (in addition to  
is_buffer_dma_capable) that would live inside archdata - see the other  
posts on this thread for details (we're still hashing out exactly how  
we want to do this).

Cheers,
Becky

