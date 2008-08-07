Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbYHGRnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbYHGRnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYHGRnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:43:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbYHGRnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:43:16 -0400
Message-ID: <489B33D4.1080107@redhat.com>
Date: Thu, 07 Aug 2008 13:41:40 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joro@8bytes.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
References: <200807281523.35469.jbarnes@virtuousgeek.org> <20080806223550K.tomof@acm.org> <4899B611.4070408@redhat.com> <200808071003.47326.jbarnes@virtuousgeek.org>
In-Reply-To: <200808071003.47326.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jesse Barnes wrote:
> On Wednesday, August 6, 2008 7:32 am Prarit Bhargava wrote:
>   
>>> You can't kmalloc pci_dev or setup some trivial values. You need to
>>> use a proper value. The pci code does for us.
>>>       
>> Oops -- I meant struct device, not struct pci_dev.
>>
>> Anwyay, Jesse -- is this true?  I can no longer do something like:
>>
>>
>> static struct device junk_dev = {
>>         .bus_id = "junk device",
>>         .coherent_dma_mask = 0xffffffff,
>>         .dma_mask = &junk_dev.coherent_dma_mask,
>> };
>>
>> And then use that as the device target for dma_alloc_coherent?  AFAIK,
>> that has always worked for me.
>>     
>
> It gets dangerous since platforms are in control of some pci_dev and dev 
> fields, and if they don't get initialized you can get into trouble.
>   

True, but dma_alloc_coherent also allows for a NULL dev pointer, and 
uses a dummy struct dev (fallback_device).  So it should be callable 
without any dev struct pointer.

In that case, I hit the BUG() check warning in iommu_is_span_boundary() 
because boundary_size was calculated as (unsigned long) 0xffffffff + 1 = 0.

That's why we must cast to "unsigned long long".

ie) it is possible to hit this BUG() right now.

>   
>>> Calgary IOMMU has the same code. New AMD IOMMU has the same code too.
>>>       
>> Then they don't handle the above problem and are broken when
>> dma_get_seg_boundary() returns 0xffffffff and will require patches.
>>
>> /me hasn't tried out Calgary of AMD IOMMU.
>>     
>
> Would be good to find someone to do some testing on one of those platforms...
>   

I've pinged someone at AMD to see if I can get my hands on a system (or 
if to see if there is a system available locally).

As for Calgary, I'm looking into it ATM.  I think I can get my hands on one.

If I find the problem on those platforms I'll ping the maintainers and 
post separate patches.  ATM I'm much more concerned about GART.

>   
>>>> Maybe I'm missing something -- what implies  size has to be a power of
>>>> two?
>>>>         
>>> Yes, see iommu_area_alloc().
>>>       
>> /me looks and still doesn't see where the size passed into
>> gart_map_simple() must be a power of two.  ... and if that was the case,
>> shouldn't we be failing all the time?  I mean, I've seen values passed
>> into pci_alloc_consistent like 0x3820 -- clearly not a multiple of 2.
>>
>> iommu_area_alloc() deals with pages, not actual sizes as
>> gart_map_simple() does.
>>     

Tomonori-san, I think I understand where your confusion may lie.  The 
size argument in the iommu-helper.c code is NOT the same size in 
dma_alloc_coherent() and gart_map_simple().  In iommu-helper.c the size 
is the # of pages, and the in the exported function calls it is an 
actual size.  Is that what is confusing you?

>> If anything, I would make this simple fix:
>>
>> dma_addr_t map = dma_map_area(dev, paddr, size, dir, size - 1);
>>
>> should be
>>
>> dma_addr_t map = dma_map_area(dev, paddr, size, dir, size);
>>
>> because after my patch we round up the mask argument to get the correct
>> alignment to # of pages anyway.
>>     
>
> Feel like respinning with a full changelog against my for-linus branch?  Maybe 
> you can convince Tomonori-san this time. :)
>
>   

I no longer think the above suggested change is necessary.  AFAICT, the 
code is doing exactly the right thing.  "size-1" is correct.

P.

> Jesse
>   
