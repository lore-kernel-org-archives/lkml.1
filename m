Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYKSNtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYKSNtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 08:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYKSNtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 08:49:06 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:17845 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbYKSNtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 08:49:05 -0500
X-IronPort-AV: E=Sophos;i="4.33,631,1220241600"; 
   d="scan'208";a="28687120"
Subject: Re: [PATCH 18 of 38] x86: unify pci iommu setup and allow swiotlb
	to	compile for 32 bit
From: Ian Campbell <Ian.Campbell@citrix.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeremy@goop.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, x86@kernel.org
In-Reply-To: <20081119112015I.fujita.tomonori@lab.ntt.co.jp>
References: <e918eb1b71515e7c2f99.1226603416@abulafia.goop.org>
	 <20081117124857Z.fujita.tomonori@lab.ntt.co.jp>
	 <1226938566.18916.80.camel@zakaz.uk.xensource.com>
	 <20081119112015I.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Wed, 19 Nov 2008 13:48:42 +0000
Message-Id: <1227102524.8717.37.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Nov 2008 13:48:54.0355 (UTC) FILETIME=[8FE05230:01C94A4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-19 at 11:19 +0900, FUJITA Tomonori wrote:
> On Mon, 17 Nov 2008 16:16:06 +0000
> Ian Campbell <Ian.Campbell@citrix.com> wrote:
> 
> > > For example, the following code assumes that the mask needs to be
> > > 64 bits.
> > 
> > The use of unsigned long for the mask is throughout the API and not
> > simply limited to swiotlb.c. All the callers of dma_set_seg_boundary
> > (PCI and SCSI subsys it seems) do not use a value >4G anywhere I can
> > see.
> 
> 32bit is large enough for dma segment boundary mask, I think.
> 
> The problem that I talked about in the previous mail:
> 
> > 	max_slots = mask + 1
> > 		    ? ALIGN(mask + 1, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT
> > 		    : 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);
> 
> Since the popular value of the mask is 0xffffffff. So the above code
> (mask + 1 ?) works wrongly if the size of mask is 32bit (well,
> accidentally the result of max_slots is identical though).

Ah, I hadn't spotted this, you are right it probably works but just by
chance. Thanks for pointing it out.

> > Presumably if something was we would see "warning: overflow in
> > implicit constant conversion" somewhere along the line. If no value is
> > set then the default is 0xffffffff which is safe on 32 bit.
> > 
> > I suspect that even with PAE addresses above 4G aren't seen very often
> > due to pre-existing subsystem specific bounce buffers or other existing
> > limitations (like network buffers being in lowmem).
> 
> I guess that you talk about the dma_mask (and coherent_dma_mask) in
> struct device. The dma segment boundary mask represents the different
> dma limitation of a device.

I was talking about the segment_boundary_mask in struct
device_dma_parameters which is the source of the "mask" value in the
code you quoted.

> > Perhaps dma_addr_t should be used though?
> 
> I think that 'unsigned long' is better for the dma segment boundary
> mask since it represents the hardware limitation. The size of the
> value are not related with kernel configurations at all.

Right, it's just that on occasion we have to cope with slightly larger
values while manipulating things.

Ian.

