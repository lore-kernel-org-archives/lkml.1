Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYGXOSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYGXOSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 10:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYGXOSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 10:18:38 -0400
Received: from sh.osrg.net ([192.16.179.4]:37794 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbYGXOSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 10:18:37 -0400
Date: Thu, 24 Jul 2008 22:32:26 +0900
To: joro@8bytes.org
Cc: fujita.tomonori@lab.ntt.co.jp, prarit@redhat.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, ed.pollard@ibm.com, epollard@redhat.com
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080724123755.GP31439@8bytes.org>
References: <488854DB.60307@redhat.com>
	<20080724193457S.fujita.tomonori@lab.ntt.co.jp>
	<20080724123755.GP31439@8bytes.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080724223309C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2008 14:37:55 +0200
Joerg Roedel <joro@8bytes.org> wrote:

> On Thu, Jul 24, 2008 at 07:34:35PM +0900, FUJITA Tomonori wrote:
> > On Thu, 24 Jul 2008 06:09:31 -0400
> > Prarit Bhargava <prarit@redhat.com> wrote:
> > >         skge->mem = pci_alloc_consistent(hw->pdev, skge->mem_size, 
> > > &skge->dma);
> > >         if (!skge->mem)
> > >                 return -ENOMEM;
> > > 
> > >         BUG_ON(skge->dma & 7);
> > > 
> > >         if ((u64)skge->dma >> 32 != ((u64) skge->dma + skge->mem_size) 
> > >  >> 32) {
> > >                 printk(KERN_ERR PFX "pci_alloc_consistent region crosses 
> > > 4G boundary\n");
> > >                 err = -EINVAL;
> > >                 goto free_pci_mem;
> > >         }
> > > 
> > > 
> > > If pci_alloc_consistent did the "right" thing, we should *never* see 
> > > that warning message.
> > 
> > Well, I think that this is not releated with the pci_alloc_consistent
> > alignment problem that you talk about.
> > 
> > I think that the driver tries to avoid 4GB boundary crossing
> > problem. You can find some work to avoid this, for example:
> > 
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0712.0/2206.html
> > 
> > pci_device_add() has the following code to avoid this:
> > 
> > pci_set_dma_seg_boundary(dev, 0xffffffff);
> > 
> > I suspect that the problem you talk about, alloc_consistent doesn't
> > return the reqeuested size aligned memory, breaks anything.
> 
> But I think Prarit is right with this change. If the interface defines
> this behavior the IOMMU drivers have to implement it. I am just
> wondering that the problem never showed up before. The GART driver is a
> few years old now.

Yeah, I'm not against fixing IOMMUs to make alloc_consistent return
the reqeuested size aligned memory. My point is that it's not likely
to fix anything. Even with the patch, we hit the above problem because
as I explained, the root cause of the problem is the boundary issue;
we need to fix pci-dma.c

