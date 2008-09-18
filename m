Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbYIRWQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbYIRWQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 18:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbYIRWQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 18:16:23 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:59430 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235AbYIRWQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 18:16:23 -0400
Date: Fri, 19 Sep 2008 07:15:59 +0900
To: andi@firstfloor.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fix GART to respect device's dma_mask about
 virtual mappings
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080918182029.GO25711@one.firstfloor.org>
References: <20080917002404.GG25711@one.firstfloor.org>
	<20080918035726F.fujita.tomonori@lab.ntt.co.jp>
	<20080918182029.GO25711@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080919071534C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 20:20:29 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > The falling back mechanism was moved to pci-nommu from the common code
> > since it doesn't work for other IOMMUs that always need virtual
> 
> There's no fallback for _map_sg/_map_single. All the fallback to GFP
> only works for coherent allocations, but not for streaming mappings.

Yeah, so the falling back mechanism was moved to pci-nommu's
alloc_coherent.


> To make this "fully robust" for masks < 32bit you would need to implement 
> a new swiotlb that uses GFP_DMA allocations as fallback (or use the DMA 
> allocator's swiotlb which can actually handle this)

Do you mean if GART's alloc_coherent can't find a virtual address that
a device can access to, it should try GFP_DMA allocations as fallback?

GART could but why GART should do? If full IOMMUs' alloc_coherent
can't find a virtual address that a device can access to, it's
failure. No fallback is for them. Why can't GART use the same logic?
Yeah, GART is not a full IOMMU, so it can have a fallback for this
case. But why can't GART work in the same way other IOMMUs?


> So you're right now basically checking for something that you cannot
> fix. And also you try to check for (but not handle) something that even 
> 32bit x86 doesn't handle. So if some driver relied on you checking
> for it on 64bit it wouldn't work on 32bit x86 which would be a bad 
> thing.

What does '32bit x86 doesn't handle' mean? pci-nommu's alloc_coherent
can handle < 32bit bit mask in the fallback path.

Or you are talking about '_map_sg/_map_single'? If so, as we
discussed, < 32bit bit mask can be handled in else where. The patch
just tries to return an address that such tricks are not necessary
with.
