Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbYIRSQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbYIRSQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 14:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbYIRSQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 14:16:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56482 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbYIRSQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 14:16:04 -0400
Date: Thu, 18 Sep 2008 20:20:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, mingo@elte.hu, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fix GART to respect device's dma_mask about virtual mappings
Message-ID: <20080918182029.GO25711@one.firstfloor.org>
References: <20080916175824.GF25711@one.firstfloor.org> <20080917085335F.fujita.tomonori@lab.ntt.co.jp> <20080917002404.GG25711@one.firstfloor.org> <20080918035726F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080918035726F.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The falling back mechanism was moved to pci-nommu from the common code
> since it doesn't work for other IOMMUs that always need virtual

There's no fallback for _map_sg/_map_single. All the fallback to GFP
only works for coherent allocations, but not for streaming mappings.

To make this "fully robust" for masks < 32bit you would need to implement 
a new swiotlb that uses GFP_DMA allocations as fallback (or use the DMA 
allocator's swiotlb which can actually handle this)

So you're right now basically checking for something that you cannot
fix. And also you try to check for (but not handle) something that even 
32bit x86 doesn't handle. So if some driver relied on you checking
for it on 64bit it wouldn't work on 32bit x86 which would be a bad 
thing.

> mappings. Calgary needs this dma_mask trick too but I guess that it's
> unlikely that the IBM servers with Calgary have weird hardware.

On a full IOMMU like calgary it's easier to do because you don't
 need to deal with GFP_DMA at least. But as you say it's unlikely
to be worth the effort on these systems.

Also the earlier problem that it wouldn't work on 32bit x86 and other
systems would make it also not too useful. Having drivers that only
work on Calgary wouldn't be a good thing.

-Andi

-- 
ak@linux.intel.com
