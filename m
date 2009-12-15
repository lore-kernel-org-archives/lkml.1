Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbZLOJYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbZLOJYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759463AbZLOJYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:24:22 -0500
Received: from sh.osrg.net ([192.16.179.4]:39336 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759383AbZLOJYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:24:05 -0500
Date: Tue, 15 Dec 2009 18:23:08 +0900
To: yinghai@kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: bisected crash due to "x86: Move swiotlb initialization before
 dma32_free_bootmem"
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B2752A9.10903@kernel.org>
References: <ada8wd4brwk.fsf@roland-alpha.cisco.com>
	<20091215175439V.fujita.tomonori@lab.ntt.co.jp>
	<4B2752A9.10903@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091215182243R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 15 Dec 2009 18:23:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 01:11:05 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> FUJITA Tomonori wrote:
> > On Mon, 14 Dec 2009 23:47:07 -0800
> > Roland Dreier <rdreier@cisco.com> wrote:
> > 
> >> I have a big box (64 threads, 256GB memory) that is crashing early in
> >> boot as below.  I bisected it down to f4780ca0 ("x86: Move swiotlb
> >> initialization before dma32_free_bootmem"); reverting just this commit
> >> from the latest git (3ea6b3d0 is what I tested) fixes things.
> > 
> > Ah, really sorry about that.
> > 
> > 
> >> I haven't tried to debug this yet, but I guess on such a huge box there
> >> is not enough memory below 4GB for swiotlb if we don't free the 
> > 
> > Yeah, Yinghai also hit this (his box has more memory than yours).
> > 
> > 
> >> stuff allocated earlier?  I don't know why that would be, since the
> >> bootmem is grabbing 512MB and I have pretty close to 4GB below 4GB.
> >> Anyway, I'm going to go to bed soon, but if you need more information or
> >> have anything you want me to try, I will do it tomorrow morning.
> > 
> > http://www.kernel.org/pub/linux/kernel/people/tomo/misc/0001-x86-two-stage-swiotlb-initialization.patch
> > 
> > It makes the swiotlb initialization into two stages. I don't like it
> > much since I like to avoid complicating the initialization.
> > 
> > dma32_reserve_bootmem() allocates 128MB for broken GART IOMMU but I
> > think 64MB should be enough since broken GART IOMMU allocates
> > 64MB. The following simple patch might work too because swiotlb uses
> > 64MB.
> > 
> > With coming huge memory boxes, we might need to work on ZONE_DMA32
> > shortage issue anyway (sparse-vmemmap, anything else)?
> 
> maybe just revert f4780ca0... for now

As I wrote, I think that the following patch works.

http://www.kernel.org/pub/linux/kernel/people/tomo/misc/0001-x86-two-stage-swiotlb-initialization.patch

There are a few people who hit this. How many people use a box with
over 256GB memory?

And you can work around this with "dma32_size" kernel boot option.


> actually dma32_free_bootmem will also make sure it will give some buffer to pci_swiotlb_init...

But unlike broken GART BIOS, swiotlb doesn't set the goal. swiotlb had
been fine without dma32_reserve_bootmem(). We use more DMA32_ZONE than
we did though.
