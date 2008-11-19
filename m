Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbYKSG7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbYKSG7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 01:59:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYKSG67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 01:58:59 -0500
Received: from sh.osrg.net ([192.16.179.4]:51066 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbYKSG67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 01:58:59 -0500
Date: Wed, 19 Nov 2008 15:58:12 +0900
To: leon.woestenberg@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       tj@kernel.org
Subject: Re: pci_map_sg() does not coalesce adjacent physical memory? x86
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <c384c5ea0811182222l7f0e3131tc1cc20ffba5175c@mail.gmail.com>
References: <20081117191532.c1c849f5.akpm@linux-foundation.org>
	<20081119142016E.fujita.tomonori@lab.ntt.co.jp>
	<c384c5ea0811182222l7f0e3131tc1cc20ffba5175c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081119155847U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008 07:22:31 +0100
"Leon Woestenberg" <leon.woestenberg@gmail.com> wrote:

> Hello,
> 
> On Wed, Nov 19, 2008 at 6:19 AM, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
> > On Mon, 17 Nov 2008 19:15:32 -0800
> >> > pci_map_sg() does not coalesce the scattergather list for me on x86.
> >> [ Marked as Bogus Report ]
> >>
> >> > Is this expected? Documentation mentions that coalescing is typically
> >> > done by pci_map_sg().
> >
> > Hm, what document did you read? We might need to fix it.
> >
> http://lxr.linux.no/linux+v2.6.27.6/Documentation/DMA-API.txt
> 
>  316        pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sg,
>  317                int nents, int direction)
>  318
>  319Maps a scatter gather list from the block layer.
>  320
>  321Returns: the number of physical segments mapped (this may be shorter
>  322than <nents> passed in if the block layer determines that some
>  323elements of the scatter/gather list are physically adjacent and thus
>  324may be mapped with a single entry).

Hmm, the description looks confusing. The block layer coalesces
physically adjacent entries before pci_map_sg(). pci_map_sg() could
coalesces physically or virtually adjacent entries.


> Also it is mentioned elsewhere, such a Linux Device Driver 3rd
> Edition, page 451.
> 
> > pci_map_sg() is not a typical place to coalesce the entries of the sg
> > list are physically adjacent. The block layer is the typical place.
> >
> Hmmm, why not?
> 
> In my case I am using the following flow:
> 
> virtual user buffer -> scatterlist -> pci_map_sg -> device specific
> scatterlist table

If you follow what the block does now, you build coalesced
scatterlists from virtual user buffers.


> Of course, I could write my own (tm) and map my pages into PCI using
> pci_map_single, but I thought I was being the good kid by using what
> was there.

I don't think it's not a good place. What pci_map_single should do is
mapping a virtual address to a dma-capable address.

IOMMU dma operations maps a virtual address to an I/O address and
non-IOMMU dma operations do nothing. As you said below, some IOMMU
operations do coalescing but it's virtual mapping (probably their code
can handle physical coalescing too though but the block layer does
physical coalescing before that though). And the virtual mapping is
optional. Not all the IOMMU operations do. As I said, x86 IOMMUs
(VT-d, AMD, and Calgary) except for GART does not do coalescing. Any
non-IOMMU dma operations don't do something complicated.

If you add physical coalescing code into pci_map_sg, block-layer
drivers go though physical coalescing code twice, the block layer and
pci_map_sg meaninglessly. It's not the right approach.


> > The dma operations are free to coalesce the entries that physically
> > and virtually adjacent but there are not many that does.
> >
> > For example, by default, on x86, only AMD GART (x86_64) dma operation
> > coalesces such entries.
> >
> 
> > What's kinda of your driver? If it's a SCSI (or block) driver, you
> > don't need this trick.
> >
> Not a block driver.
> 
> A data acquisition driver through PCI Express.

Hmm, what location will your driver live under drivers/?


> > I don't think that inventing a homegrown function to coalesce sg
> > entries in a driver is a good idea. If you really need this, it's
> > would be better to have a generic function to coalesce sg entries and
> > modify the block layer to use it (and your driver can use it too).
> >
> +1 for this idea, *iff* it does not belong in pci_map_sg.
> 
> However, I think it *does* belong in pci_map_sg, because pci_map_sg
> can perform virtual coalescing exploiting IOMMU's if I am not
> mistaken.

As I wrote above, it's not the right approach.
