Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbYGXKLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbYGXKLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYGXKLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:11:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbYGXKLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:11:24 -0400
Message-ID: <488854DB.60307@redhat.com>
Date: Thu, 24 Jul 2008 06:09:31 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, ed.pollard@ibm.com, epollard@redhat.com
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
References: <20080723111928.15828.42561.sendpatchset@prarit.bos.redhat.com> <20080723221033.GD13662@8bytes.org> <20080724081528F.fujita.tomonori@lab.ntt.co.jp> <4887C2F7.6040506@redhat.com> <20080724074655.GM31439@8bytes.org>
In-Reply-To: <20080724074655.GM31439@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Joerg Roedel wrote:
> On Wed, Jul 23, 2008 at 07:47:03PM -0400, Prarit Bhargava wrote:
>   
>>>> Interesting. Have you experienced any problems because of that
>>>> misbehavior in the GART code? AMD IOMMU currently also violates this
>>>> requirement. I will send a patch to fix that there too.
>>>>    
>>>>         
>>>  
>>>       
>> Joerg,  yes I can see misbehavior caused by this code.  O/w I wouldn't 
>> be spending my time fixing it :) :)
>>
>> See below ....
>>
>>     
>>> IIRC, only PARISC and POWER IOMMUs follow the above rule. So I also
>>> wondered what problem he hit.
>>>  
>>>       
>> I wonder if IBM's Calgary IOMMU needs this fix? ... I've added Ed 
>> Pollard to find out.
>>
>> On big memory footprint (16G or above) systems it is possible that the 
>> e820 map reserves most of the lower 4G of memory for system use*.  So 
>> it's possible that the 4G region is almost completely reserved at boot 
>> time and so the kernel starts using the IOMMU for DMA (see 
>> dma_alloc_coherent()).  The addresses returned are not properly aligned, 
>> and this causes serious problems for some drivers that require a 
>> physical aligned address for the device.
>>     
>
> Do you have a list of driver which require this? 

No, I don't have a list. :(

But it seems that the skge driver suffers from this because this code 
exists in the driver:

        skge->mem = pci_alloc_consistent(hw->pdev, skge->mem_size, 
&skge->dma);
        if (!skge->mem)
                return -ENOMEM;

        BUG_ON(skge->dma & 7);

        if ((u64)skge->dma >> 32 != ((u64) skge->dma + skge->mem_size) 
 >> 32) {
                printk(KERN_ERR PFX "pci_alloc_consistent region crosses 
4G boundary\n");
                err = -EINVAL;
                goto free_pci_mem;
        }


If pci_alloc_consistent did the "right" thing, we should *never* see 
that warning message.

In theory, any 32-bit device attempting to request larger than PAGE_SIZE 
DMA memory on a system where no memory is available below 4G should show 
this problem.

> I would like to
> reproduce this issue. Does it also happen when you start the kernel with
> iommu=force (GART should then be used for all DMA remapping) too?
>   

Yes, this happens if you specify iommu=force on the command line.

P.
