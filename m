Return-Path: <linux-kernel-owner+w=401wt.eu-S1752994AbYKQQQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbYKQQQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 11:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYKQQQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 11:16:15 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:50340 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYKQQQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:16:14 -0500
X-IronPort-AV: E=Sophos;i="4.33,618,1220241600"; 
   d="scan'208";a="28387142"
Subject: Re: [PATCH 18 of 38] x86: unify pci iommu setup and allow swiotlb
	to	compile for 32 bit
From: Ian Campbell <Ian.Campbell@citrix.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeremy@goop.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, x86@kernel.org
In-Reply-To: <20081117124857Z.fujita.tomonori@lab.ntt.co.jp>
References: <patchbomb.1226603398@abulafia.goop.org>
	 <e918eb1b71515e7c2f99.1226603416@abulafia.goop.org>
	 <20081117124857Z.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Mon, 17 Nov 2008 16:16:06 +0000
Message-Id: <1226938566.18916.80.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Nov 2008 16:16:13.0393 (UTC) FILETIME=[CF86FC10:01C948CF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-17 at 12:48 +0900, FUJITA Tomonori wrote:
> On Thu, 13 Nov 2008 11:10:16 -0800
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > swiotlb on 32 bit will be used by Xen domain 0 support.
> 
> If you want swiotlb on 32 bit, you need more modifications, I think.

Possibly. It currently "Works For Me(tm)", but I should check it over.

> For example, the following code assumes that the mask needs to be
> 64 bits.

The use of unsigned long for the mask is throughout the API and not
simply limited to swiotlb.c. All the callers of dma_set_seg_boundary
(PCI and SCSI subsys it seems) do not use a value >4G anywhere I can
see. Presumably if something was we would see "warning: overflow in
implicit constant conversion" somewhere along the line. If no value is
set then the default is 0xffffffff which is safe on 32 bit.

I suspect that even with PAE addresses above 4G aren't seen very often
due to pre-existing subsystem specific bounce buffers or other existing
limitations (like network buffers being in lowmem).

Perhaps dma_addr_t should be used though?

Ian.

> 
> static void *
> map_single(struct device *hwdev, char *buffer, size_t size, int dir)
> {
> 	unsigned long flags;
> 	char *dma_addr;
> 	unsigned int nslots, stride, index, wrap;
> 	int i;
> 	unsigned long start_dma_addr;
> 	unsigned long mask;
> 	unsigned long offset_slots;
> 	unsigned long max_slots;
> 
> 	mask = dma_get_seg_boundary(hwdev);
> 	start_dma_addr = virt_to_bus(io_tlb_start) & mask;
> 
> 	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
> 	max_slots = mask + 1
> 		    ? ALIGN(mask + 1, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT
> 		    : 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);
> 

