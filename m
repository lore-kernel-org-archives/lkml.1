Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbYKSCU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbYKSCU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 21:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYKSCUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 21:20:14 -0500
Received: from sh.osrg.net ([192.16.179.4]:59527 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbYKSCUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 21:20:13 -0500
Date: Wed, 19 Nov 2008 11:19:40 +0900
To: Ian.Campbell@citrix.com
Cc: fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       x86@kernel.org
Subject: Re: [PATCH 18 of 38] x86: unify pci iommu setup and allow swiotlb
	to	compile for 32 bit
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1226938566.18916.80.camel@zakaz.uk.xensource.com>
References: <e918eb1b71515e7c2f99.1226603416@abulafia.goop.org>
	<20081117124857Z.fujita.tomonori@lab.ntt.co.jp>
	<1226938566.18916.80.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081119112015I.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 16:16:06 +0000
Ian Campbell <Ian.Campbell@citrix.com> wrote:

> > For example, the following code assumes that the mask needs to be
> > 64 bits.
> 
> The use of unsigned long for the mask is throughout the API and not
> simply limited to swiotlb.c. All the callers of dma_set_seg_boundary
> (PCI and SCSI subsys it seems) do not use a value >4G anywhere I can
> see.

32bit is large enough for dma segment boundary mask, I think.

The problem that I talked about in the previous mail:

> 	max_slots = mask + 1
> 		    ? ALIGN(mask + 1, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT
> 		    : 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);

Since the popular value of the mask is 0xffffffff. So the above code
(mask + 1 ?) works wrongly if the size of mask is 32bit (well,
accidentally the result of max_slots is identical though).


> Presumably if something was we would see "warning: overflow in
> implicit constant conversion" somewhere along the line. If no value is
> set then the default is 0xffffffff which is safe on 32 bit.
> 
> I suspect that even with PAE addresses above 4G aren't seen very often
> due to pre-existing subsystem specific bounce buffers or other existing
> limitations (like network buffers being in lowmem).

I guess that you talk about the dma_mask (and coherent_dma_mask) in
struct device. The dma segment boundary mask represents the different
dma limitation of a device.


> Perhaps dma_addr_t should be used though?

I think that 'unsigned long' is better for the dma segment boundary
mask since it represents the hardware limitation. The size of the
value are not related with kernel configurations at all.
