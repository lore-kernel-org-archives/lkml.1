Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbYGXKoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbYGXKoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYGXKo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:44:27 -0400
Received: from sh.osrg.net ([192.16.179.4]:53762 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbYGXKo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:44:26 -0400
Date: Thu, 24 Jul 2008 19:34:35 +0900
To: prarit@redhat.com
Cc: joro@8bytes.org, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, ed.pollard@ibm.com, epollard@redhat.com
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <488854DB.60307@redhat.com>
References: <4887C2F7.6040506@redhat.com>
	<20080724074655.GM31439@8bytes.org>
	<488854DB.60307@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080724193457S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008 06:09:31 -0400
Prarit Bhargava <prarit@redhat.com> wrote:

> 
> 
> Joerg Roedel wrote:
> > On Wed, Jul 23, 2008 at 07:47:03PM -0400, Prarit Bhargava wrote:
> >   
> >>>> Interesting. Have you experienced any problems because of that
> >>>> misbehavior in the GART code? AMD IOMMU currently also violates this
> >>>> requirement. I will send a patch to fix that there too.
> >>>>    
> >>>>         
> >>>  
> >>>       
> >> Joerg,  yes I can see misbehavior caused by this code.  O/w I wouldn't 
> >> be spending my time fixing it :) :)
> >>
> >> See below ....
> >>
> >>     
> >>> IIRC, only PARISC and POWER IOMMUs follow the above rule. So I also
> >>> wondered what problem he hit.
> >>>  
> >>>       
> >> I wonder if IBM's Calgary IOMMU needs this fix? ... I've added Ed 
> >> Pollard to find out.
> >>
> >> On big memory footprint (16G or above) systems it is possible that the 
> >> e820 map reserves most of the lower 4G of memory for system use*.  So 
> >> it's possible that the 4G region is almost completely reserved at boot 
> >> time and so the kernel starts using the IOMMU for DMA (see 
> >> dma_alloc_coherent()).  The addresses returned are not properly aligned, 
> >> and this causes serious problems for some drivers that require a 
> >> physical aligned address for the device.
> >>     
> >
> > Do you have a list of driver which require this? 
> 
> No, I don't have a list. :(
> 
> But it seems that the skge driver suffers from this because this code 
> exists in the driver:

seems? You hit the bug with this driver, right?


>         skge->mem = pci_alloc_consistent(hw->pdev, skge->mem_size, 
> &skge->dma);
>         if (!skge->mem)
>                 return -ENOMEM;
> 
>         BUG_ON(skge->dma & 7);
> 
>         if ((u64)skge->dma >> 32 != ((u64) skge->dma + skge->mem_size) 
>  >> 32) {
>                 printk(KERN_ERR PFX "pci_alloc_consistent region crosses 
> 4G boundary\n");
>                 err = -EINVAL;
>                 goto free_pci_mem;
>         }
> 
> 
> If pci_alloc_consistent did the "right" thing, we should *never* see 
> that warning message.

Well, I think that this is not releated with the pci_alloc_consistent
alignment problem that you talk about.

I think that the driver tries to avoid 4GB boundary crossing
problem. You can find some work to avoid this, for example:

http://www.ussg.iu.edu/hypermail/linux/kernel/0712.0/2206.html

pci_device_add() has the following code to avoid this:

pci_set_dma_seg_boundary(dev, 0xffffffff);

I suspect that the problem you talk about, alloc_consistent doesn't
return the reqeuested size aligned memory, breaks anything.


> In theory, any 32-bit device attempting to request larger than PAGE_SIZE 
> DMA memory on a system where no memory is available below 4G should show 
> this problem.
> 
> > I would like to
> > reproduce this issue. Does it also happen when you start the kernel with
> > iommu=force (GART should then be used for all DMA remapping) too?
> >   
> 
> Yes, this happens if you specify iommu=force on the command line.
> 
> P.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
