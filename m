Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbYIJRPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbYIJRPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 13:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbYIJRPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 13:15:44 -0400
Received: from sh.osrg.net ([192.16.179.4]:43991 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbYIJRPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 13:15:44 -0400
Date: Thu, 11 Sep 2008 02:15:22 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] x86: avoid unnecessary low zone allocation in AMD
 IOMMU's alloc_coherent
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080910170504.GA32286@amd.com>
References: <20080910152918.GD24392@amd.com>
	<20080911012932D.fujita.tomonori@lab.ntt.co.jp>
	<20080910170504.GA32286@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080911021457K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008 19:05:04 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Thu, Sep 11, 2008 at 01:29:54AM +0900, FUJITA Tomonori wrote:
> > On Wed, 10 Sep 2008 17:29:18 +0200
> > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > On Thu, Sep 11, 2008 at 12:09:43AM +0900, FUJITA Tomonori wrote:
> > > > On Wed, 10 Sep 2008 16:52:49 +0200
> > > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > > 
> > > > > On Wed, Sep 10, 2008 at 11:39:00PM +0900, FUJITA Tomonori wrote:
> > > > >  
> > > > > > btw, in tip/x86/iommu, GART's alloc_coherent always does virtual
> > > > > > mappings to allocate a size-aligned memory (as DMA-mapping.txt
> > > > > > defines).
> > > > > > 
> > > > > > Because someone strongly insisted, I modified GART's alloc_coherent to
> > > > > > do so but as I said again and again, it's completely meaningless (only
> > > > > > POWER IOMMU does it and drivers don't depend on such requirement).
> > > > > > 
> > > > > > I guess that it would be better to do virtual mappings only when
> > > > > > necessary as the current mainline does since GART I/O space is
> > > > > > precious in some systems. But I don't care much. What's your opinion
> > > > > > (as a AMD developer)?
> > > > > 
> > > > > Very true. My original rewrite did the mapping only when necessary too.
> > > > > What were the reasons to do the mapping always?
> > > > 
> > > > As I said above, it's for allocating a size-aligned memory. Look at
> > > > the description of pci_alloc_consistent in DMA-mapping.txt:
> > > > 
> > > > The cpu return address and the DMA bus master address are both
> > > > guaranteed to be aligned to the smallest PAGE_SIZE order which
> > > > is greater than or equal to the requested size.  This invariant
> > > > exists (for example) to guarantee that if you allocate a chunk
> > > > which is smaller than or equal to 64 kilobytes, the extent of the
> > > > buffer you receive will not cross a 64K boundary.
> > > > 
> > > > You can't do this with __get_free_pages easily (you need some hacks to
> > > > do this). You can do this via iommu_area_alloc() for free.
> > > 
> > > What hacks do you need with __get_free_pages? The memory it returns is
> > > _always_ aligned at its size.
> > 
> > Is it guaranteed (documented somewhere) ?
> 
> I don't know if there is a formal definition for it. It is documented in
> some books about the Linux kernel (I read this in some book the first
> time). This alignment results from the buddy algorithm the page alloctor
> uses. You can definitly rely on that.

I meant, if it's not documented as a guaranteed feature (not just the
characteristic of the current code), it could change any time.
