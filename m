Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbXJXIvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbXJXIvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 04:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXJXIvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 04:51:07 -0400
Received: from sa15.bezeqint.net ([192.115.104.30]:48505 "EHLO
	sa15.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbXJXIvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 04:51:05 -0400
Message-ID: <471F076E.4080609@panasas.com>
Date: Wed, 24 Oct 2007 10:50:54 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: kamalesh@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       apw@shadowen.org, tomof@acm.org
Subject: Re: [BUG] 2.6.23-git18 Kernel oops in sg helpers
References: <471E110C.20404@linux.vnet.ibm.com> <20071024074200K.fujita.tomonori@lab.ntt.co.jp> <20071024083233.GG14671@kernel.dk>
In-Reply-To: <20071024083233.GG14671@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct. 24, 2007, 10:32 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Oct 24 2007, FUJITA Tomonori wrote:
>> On Tue, 23 Oct 2007 20:49:40 +0530
>> Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>>
>>> Hi,
>>>
>>> Kernel oops is triggered while running fsx-linux test, followed by cpu softlock
>>> over the AMD box
>>>
>>> Unable to handle kernel NULL pointer dereference at 0000000000000018 RIP: 
>>>  [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
>>> PGD 10185b067 PUD 10075b067 PMD 0 
>> Does this work?
>>
>>
>> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
>> index c56e9ee..ae7e016 100644
>> --- a/arch/x86/kernel/pci-gart_64.c
>> +++ b/arch/x86/kernel/pci-gart_64.c
>> @@ -338,7 +338,6 @@ static int __dma_map_cont(struct scatterlist *start, int nelems,
>>  		
>>  		BUG_ON(s != start && s->offset);
>>  		if (s == start) {
>> -			*sout = *s; 
>>  			sout->dma_address = iommu_bus_base;
>>  			sout->dma_address += iommu_page*PAGE_SIZE + s->offset;
>>  			sout->dma_length = s->length;
>> @@ -365,7 +364,7 @@ static inline int dma_map_cont(struct scatterlist *start, int nelems,
>>  {
>>  	if (!need) {
>>  		BUG_ON(nelems != 1);
>> -		*sout = *start;
>> +		sout->dma_address = start->dma_address;

I don't see this could fix anything since "s" above and "start" here are still
dereferenced.  Also, this makes sout->dma_address inconsistent with sout->page_link
and with the end marker.

Benny

>>  		sout->dma_length = start->length;
>>  		return 0;
>>  	}
>> -- 
>> 1.5.2.4
> 
> Care to write up a proper changelog?
> 

