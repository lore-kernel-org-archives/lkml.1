Return-Path: <linux-kernel-owner+w=401wt.eu-S936304AbZDITTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936304AbZDITTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 15:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765427AbZDITTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 15:19:23 -0400
Received: from gw.goop.org ([64.81.55.164]:57183 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbZDITTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 15:19:22 -0400
Message-ID: <49DE4A37.3080702@goop.org>
Date: Thu, 09 Apr 2009 12:19:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: galak@kernel.crashing.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, ian.campbell@citrix.com, beckyb@kernel.crashing.org
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of address_needs_mapping
References: <49DD3041.8020808@goop.org>	<20090409083752I.fujita.tomonori@lab.ntt.co.jp>	<49DD3C9C.7060101@goop.org> <20090410033357S.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090410033357S.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
>> Well, Becky's patches also added the hwdev argument to them, so 
>> presumably the powerpc implementation needs that (different 
>> devices/buses have differing views of physical memory, I guess).
>>     
>
> Until I see the ppc specific swiotlb patchset, I'm not sure but I
> think that we can remove phys_to_bus in swiotlb.
>   

Kumar's comment was: "For our SoC chips we don't need any mapping 
between phys & bus.  However something like PCI does have a mapping (a 
simple offset)."

Kumar, could a single system have different phys<->bus mappings on a 
single system, or could it differ from device to device (or bus to bus)?

> Even if we need phys_to_bus, we can remove the rest of __weak tricks
> for only dom0. And we can make phys_to_bus arch-specific. Then we
> don't need any __weak tricks in swiotlb (and x86's swiotlb). dom0
> support adds many hacks to swiotlb.
>   

Well, we'd still need a way to do hook the swiotlb_alloc(_boot) 
allocation.  At the moment its effectively arch-specific because x86 
only uses swiotlb_alloc_boot(), and ia64 only uses swiotlb_alloc().  One 
option would be to simply make that function arch-defined, which would 
remove the need for any kind of override mechanism in lib/swiotlb; that 
would match the handling of phys_to_bus.  And its more appealing if we 
manage to drop swiotlb_alloc_boot, so there's only a single function for 
the arches to worry about.

> Yeah, ISA DMA comment is misleading. swiotlb can't handle it. And it
> doesn't need to handle it because the block layer can thanks to
> the bouncing (the network layer does the similar, I think).
>
> As you said, we could remove the latter though I'm not sure.
>   

It would take a bit of rearranging the x86 swiotlb/iommu init sequence, 
but I don't think it would be too complex.  I'll look into it.

    J
