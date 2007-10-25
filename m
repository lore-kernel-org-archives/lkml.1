Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbXJYIxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbXJYIxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbXJYIxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:53:17 -0400
Received: from sa14.bezeqint.net ([192.115.104.29]:43800 "EHLO
	sa14.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbXJYIxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:53:15 -0400
Message-ID: <47205972.7020102@panasas.com>
Date: Thu, 25 Oct 2007 10:53:06 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: Jens Axboe <jens.axboe@oracle.com>, kamalesh@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, apw@shadowen.org, tomof@acm.org
Subject: Re: [BUG] 2.6.23-git18 Kernel oops in sg helpers
References: <471E110C.20404@linux.vnet.ibm.com> <20071024074200K.fujita.tomonori@lab.ntt.co.jp> <20071024083233.GG14671@kernel.dk> <471F076E.4080609@panasas.com>
In-Reply-To: <471F076E.4080609@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct. 24, 2007, 10:50 +0200, Benny Halevy <bhalevy@panasas.com> wrote:
> On Oct. 24, 2007, 10:32 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
>> On Wed, Oct 24 2007, FUJITA Tomonori wrote:
>>> On Tue, 23 Oct 2007 20:49:40 +0530
>>> Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>>>
>>>> Hi,
>>>>
>>>> Kernel oops is triggered while running fsx-linux test, followed by cpu softlock
>>>> over the AMD box
>>>>
>>>> Unable to handle kernel NULL pointer dereference at 0000000000000018 RIP: 
>>>>  [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
>>>> PGD 10185b067 PUD 10075b067 PMD 0 
>>> Does this work?
>>>
>>>
>>> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
>>> index c56e9ee..ae7e016 100644
>>> --- a/arch/x86/kernel/pci-gart_64.c
>>> +++ b/arch/x86/kernel/pci-gart_64.c
>>> @@ -338,7 +338,6 @@ static int __dma_map_cont(struct scatterlist *start, int nelems,
>>>  		
>>>  		BUG_ON(s != start && s->offset);
>>>  		if (s == start) {
>>> -			*sout = *s; 
>>>  			sout->dma_address = iommu_bus_base;
>>>  			sout->dma_address += iommu_page*PAGE_SIZE + s->offset;
>>>  			sout->dma_length = s->length;
>>> @@ -365,7 +364,7 @@ static inline int dma_map_cont(struct scatterlist *start, int nelems,
>>>  {
>>>  	if (!need) {
>>>  		BUG_ON(nelems != 1);
>>> -		*sout = *start;
>>> +		sout->dma_address = start->dma_address;
> 
> I don't see this could fix anything since "s" above and "start" here are still
> dereferenced.  Also, this makes sout->dma_address inconsistent with sout->page_link
> and with the end marker.

OK, it took me a day to figure out why the fix is working :)
The end of list marker was copied into sout and later, in line 432
sg_next(sgmap) returned NULL since sgmap became the last entry in the list
(which is strangely correct in the dma mapped vector).

431:	if (out < nents) {
432:		sgmap = sg_next(sgmap);
433:		sgmap->dma_length = 0;
434:	}

Alas, the dma mapping convention apparently requires dma_length == 0
as a terminator if the "compressed" list for dma mapping is shorter than
the sg list.

Although this change does not keep each sg->dma_address in sync with each
sg->page_link, previously there was nothing to keep sg->length in sync with
sg->dma_length so I actually think that keeping the dma mapping and the
page mappings orthogonal and independent may be even better since the
original sg list can still be reused safely even after dma mapping.

> 
> Benny
> 
>>>  		sout->dma_length = start->length;
>>>  		return 0;
>>>  	}
>>> -- 
>>> 1.5.2.4
>> Care to write up a proper changelog?
>>
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

