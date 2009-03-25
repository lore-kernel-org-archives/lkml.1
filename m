Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbZCYDzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbZCYDzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 23:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZCYDz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 23:55:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:56355 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbZCYDz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 23:55:28 -0400
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ian.campbell@citrix.com,
       jeremy@goop.org
Message-Id: <DE550DFB-AD1F-49A2-8100-4B3234427163@kernel.crashing.org>
From: Becky Bruce <beckyb@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090325115616I.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH 3/5] swiotlb: swiotlb_bus_to_virt/phys prototype changes
Date: Tue, 24 Mar 2009 22:54:12 -0500
References: <1237930126-6741-2-git-send-email-beckyb@kernel.crashing.org> <1237930126-6741-3-git-send-email-beckyb@kernel.crashing.org> <1237930126-6741-4-git-send-email-beckyb@kernel.crashing.org> <20090325115616I.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 24, 2009, at 9:58 PM, FUJITA Tomonori wrote:

> On Tue, 24 Mar 2009 16:28:44 -0500
> Becky Bruce <beckyb@kernel.crashing.org> wrote:
>
>> Make these functions take the hwdev as an argument because on some
>> platforms it contains a per-device offset that is used to convert
>> from bus addresses to/from other types of addresses.
>>
>> Also, make these weak so architectures can override the default
>> behavior (for example, by adding an offset in the hwdev).
>>
>> Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
>> ---
>> arch/x86/kernel/pci-swiotlb.c |    2 +-
>> include/linux/swiotlb.h       |    4 +++-
>> lib/swiotlb.c                 |   31 +++++++++++++++++++------------
>> 3 files changed, 23 insertions(+), 14 deletions(-)
>
>> @@ -847,10 +847,14 @@ swiotlb_unmap_sg_attrs(struct device *hwdev,  
>> struct scatterlist *sgl,
>>
>> 	for_each_sg(sgl, sg, nelems, i) {
>> 		if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
>> -			unmap_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
>> -				     sg->dma_length, dir);
>> +			unmap_single(
>> +				hwdev,
>> +				swiotlb_bus_to_virt(hwdev, sg->dma_address),
>> +				sg->dma_length, dir);
>> 		else if (dir == DMA_FROM_DEVICE)
>> -			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg- 
>> >dma_length);
>> +			dma_mark_clean(
>> +				swiotlb_bus_to_virt(hwdev, sg->dma_address),
>> +				sg->dma_length);
>> 	}
>
> The coding style looks a bit odd to me. How about something like this?

>
>
> for_each_sg(sgl, sg, nelems, i) {
> 	void *virt = swiotlb_bus_to_virt(hwdev, sg->dma_address),
> 	if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
> 		unmap_single(hwdev, virt, sg->dma_length, dir);
> 	else if (dir == DMA_FROM_DEVICE)
> 		dma_mark_clean(virt, sg->dma_length);

Heh, I was trying to avoid > 80 character lines there, and it ended up  
looking a bit gross.  I originally had *exactly* what you suggest in  
my tree, but changed it, so I'm more than happy to change this back.

>
>
>
>> }
>> EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
>> @@ -881,10 +885,13 @@ swiotlb_sync_sg(struct device *hwdev, struct  
>> scatterlist *sgl,
>>
>> 	for_each_sg(sgl, sg, nelems, i) {
>> 		if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
>> -			sync_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
>> +			sync_single(hwdev,
>> +				    swiotlb_bus_to_virt(hwdev, sg->dma_address),
>> 				    sg->dma_length, dir, target);
>> 		else if (dir == DMA_FROM_DEVICE)
>> -			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg- 
>> >dma_length);
>> +			dma_mark_clean(
>> +				swiotlb_bus_to_virt(hwdev, sg->dma_address),
>> +				sg->dma_length);
>> 	}
>
> Ditto.
>
>
> The rest looks fine to me.

Thanks for the review!

Cheers,
-Becky

