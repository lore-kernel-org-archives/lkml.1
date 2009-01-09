Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbZAISKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbZAISKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbZAISKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:10:44 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:8660 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbZAISKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:10:41 -0500
X-IronPort-AV: E=Sophos;i="4.37,240,1231131600"; 
   d="scan'208";a="35158347"
Subject: Re: swiotlb: remove duplicated #include
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Becky Bruce <beckyb@kernel.crashing.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jj@chaosbits.net,
       weiyi.huang@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <A1D2B092-1D51-4131-B5F2-D6B45767435F@kernel.crashing.org>
References: <20090104112541.GA25434@elte.hu>
	 <20090104210420X.fujita.tomonori@lab.ntt.co.jp>
	 <20090104121914.GA30255@elte.hu>
	 <20090104214109A.fujita.tomonori@lab.ntt.co.jp>
	 <20090104130113.GA24506@elte.hu>  <49613CC4.1000000@goop.org>
	 <1231519043.27350.73.camel@zakaz.uk.xensource.com>
	 <A1D2B092-1D51-4131-B5F2-D6B45767435F@kernel.crashing.org>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Fri, 09 Jan 2009 18:10:30 +0000
Message-Id: <1231524630.27350.79.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jan 2009 18:10:40.0028 (UTC) FILETIME=[944115C0:01C97285]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 11:36 -0600, Becky Bruce wrote:
> On Jan 9, 2009, at 10:37 AM, Ian Campbell wrote:
> 
> > On Mon, 2009-01-05 at 09:48 +1100, Jeremy Fitzhardinge wrote:
> >> Ingo Molnar wrote:
> >>> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> >>>
> >>>
> >>>>> In a few days, but wanted to hear back from either Jeremy or Becky
> >>>>> first about how well they actually work in their usecases.
> >>>>>
> >>>> Well, you don't need to wait, I think.
> >>>>
> >>>> All Jeremy and Becky need is adding highmem support to swiotlb.  
> >>>> How we
> >>>> support it doesn't matter. We can choose better one.
> >>>>
> >>>> We all (including Jeremy) agreed that Becky's physical address  
> >>>> scheme is
> >>>> better (simpler) than Jeremy's struct page and offset scheme.  
> >>>> Surely,
> >>>> Becky's scheme works for Xen and him (Jeremy said that he tested it
> >>>> lightly).
> >>>>
> >>>
> >>> Jeremy said, when he submitted this series, shortly before  
> >>> Christmas:
> >>>
> >>>>> Here's a work in progress series [...]
> >>>>>
> >>>>> Quick testing showed no problems, but I haven't had the chance  
> >>>>> to do
> >>>>> anything extensive.
> >>>
> >>> Jeremy, did you have a chance to do more testing with the current
> >>> tip/master bits on Xen, so that we can push it to Linus?
> >>>
> >>
> >> I'm going to be on vacation until the 12th, so I won't have a  
> >> chance to
> >> do anything until then (perhaps Ian will have a chance to poke at  
> >> them
> >> before then).  I'm expecting Becky's patches to work as-is, or if  
> >> not,
> >> be easily fixed with a couple of small bugfix patches.  So I say go
> >> ahead if they work for everyone else.
> >
> > Only just got out from under my pile of vacation backlog...
> >
> > They don't quite work with Xen (at least the version in Jeremy's patch
> > queue doesn't) but I agree that it should be possible to make it work
> > and that there's no point in holding back just for Xen.
> 
> I'm also back (temporarily), and they're not quite going to work for  
> powerpc, either, but it shouldn't be anything major to fix, and since  
> it didn't work on powerpc before, that shouldn't hold anything up.   
> I'm working on getting things working for me again now.   
> Unfortunately, it now looks like I'm going to have to be out of the  
> office next week, but I expect to get something out as soon as I'm  
> back, if I don't get a chance to fix it today.

I've got it working for Xen now, the only generic patch of consequence
is below. The others are to the Xen specific bits which haven't been
posted yet.

Patch is against Jeremy's Xen patch queue which is based on a pre-Xmas
tip tree so fairly out of date, I hope it is somewhat useful though.

Ian.

swiotlb: do not use sg_virt()

Scatterlists containing HighMem pages do not have a useful virtual
address. Use the physical address instead.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
diff -r 6c14c6035bf5 lib/swiotlb.c
--- a/lib/swiotlb.c	Fri Jan 09 17:57:19 2009 +0000
+++ b/lib/swiotlb.c	Fri Jan 09 17:58:04 2009 +0000
@@ -40,8 +40,6 @@
 
 #define OFFSET(val,align) ((unsigned long)	\
 	                   ( (val) & ( (align) - 1)))
-
-#define SG_ENT_BUS_ADDRESS(hwdev, sg)	swiotlb_virt_to_bus(hwdev, sg_virt(sg))
 
 #define SLABS_PER_PAGE (1 << (PAGE_SHIFT - IO_TLB_SHIFT))
 
@@ -815,10 +813,10 @@
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		void *addr = sg_virt(sg);
-		dma_addr_t dev_addr = swiotlb_virt_to_bus(hwdev, addr);
+		phys_addr_t paddr = sg_phys(sg);
+		dma_addr_t dev_addr = swiotlb_phys_to_bus(hwdev, paddr);
 
-		if (range_needs_mapping(sg_phys(sg), sg->length) ||
+		if (range_needs_mapping(paddr, sg->length) ||
 		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
 			void *map = map_single(hwdev, sg_phys(sg),
 					       sg->length, dir);
@@ -862,11 +860,11 @@
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != SG_ENT_BUS_ADDRESS(hwdev, sg))
+		if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
 			unmap_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				     sg->dma_length, dir);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(sg_virt(sg), sg->dma_length);
+			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
 	}
 }
 EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
@@ -895,11 +893,11 @@
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != SG_ENT_BUS_ADDRESS(hwdev, sg))
+		if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
 			sync_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(sg_virt(sg), sg->dma_length);
+			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
 	}
 }
 


