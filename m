Return-Path: <linux-kernel-owner+w=401wt.eu-S1761804AbZCYMoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761804AbZCYMoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbZCYMop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:44:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44231 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759473AbZCYMoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:44:44 -0400
Date: Wed, 25 Mar 2009 13:44:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Becky Bruce <beckyb@kernel.crashing.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, ian.campbell@citrix.com, jeremy@goop.org
Subject: Re: [PATCH 3/5] swiotlb: swiotlb_bus_to_virt/phys prototype changes
Message-ID: <20090325124419.GC30755@elte.hu>
References: <1237930126-6741-2-git-send-email-beckyb@kernel.crashing.org> <1237930126-6741-3-git-send-email-beckyb@kernel.crashing.org> <1237930126-6741-4-git-send-email-beckyb@kernel.crashing.org> <20090325115616I.fujita.tomonori@lab.ntt.co.jp> <DE550DFB-AD1F-49A2-8100-4B3234427163@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE550DFB-AD1F-49A2-8100-4B3234427163@kernel.crashing.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Becky Bruce <beckyb@kernel.crashing.org> wrote:

>
> On Mar 24, 2009, at 9:58 PM, FUJITA Tomonori wrote:
>
>> On Tue, 24 Mar 2009 16:28:44 -0500
>> Becky Bruce <beckyb@kernel.crashing.org> wrote:
>>
>>> Make these functions take the hwdev as an argument because on some
>>> platforms it contains a per-device offset that is used to convert
>>> from bus addresses to/from other types of addresses.
>>>
>>> Also, make these weak so architectures can override the default
>>> behavior (for example, by adding an offset in the hwdev).
>>>
>>> Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
>>> ---
>>> arch/x86/kernel/pci-swiotlb.c |    2 +-
>>> include/linux/swiotlb.h       |    4 +++-
>>> lib/swiotlb.c                 |   31 +++++++++++++++++++------------
>>> 3 files changed, 23 insertions(+), 14 deletions(-)
>>
>>> @@ -847,10 +847,14 @@ swiotlb_unmap_sg_attrs(struct device *hwdev,  
>>> struct scatterlist *sgl,
>>>
>>> 	for_each_sg(sgl, sg, nelems, i) {
>>> 		if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
>>> -			unmap_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
>>> -				     sg->dma_length, dir);
>>> +			unmap_single(
>>> +				hwdev,
>>> +				swiotlb_bus_to_virt(hwdev, sg->dma_address),
>>> +				sg->dma_length, dir);
>>> 		else if (dir == DMA_FROM_DEVICE)
>>> -			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg- 
>>> >dma_length);
>>> +			dma_mark_clean(
>>> +				swiotlb_bus_to_virt(hwdev, sg->dma_address),
>>> +				sg->dma_length);
>>> 	}
>>
>> The coding style looks a bit odd to me. How about something like this?
>
>>
>>
>> for_each_sg(sgl, sg, nelems, i) {
>> 	void *virt = swiotlb_bus_to_virt(hwdev, sg->dma_address),
>> 	if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
>> 		unmap_single(hwdev, virt, sg->dma_length, dir);
>> 	else if (dir == DMA_FROM_DEVICE)
>> 		dma_mark_clean(virt, sg->dma_length);

that looks odd too.

> Heh, I was trying to avoid > 80 character lines there, and it 
> ended up looking a bit gross.  I originally had *exactly* what you 
> suggest in my tree, but changed it, so I'm more than happy to 
> change this back.

The proper solution is to split out the loop body into a helper 
function, __swiotlb_unmap_sg_attrs() or so. Something like:

__swiotlb_unmap_sg_attrs()
{
	if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
		unmap_single(hwdev,
			swiotlb_bus_to_virt(hwdev, sg->dma_address),
			sg->dma_length, dir);
		return;
	}

	if (dir != DMA_FROM_DEVICE)
		return;

	dma_mark_clean(swiotlb_bus_to_virt(hwdev, sg->dma_address),
		       sg->dma_length);
}

	Ingo
