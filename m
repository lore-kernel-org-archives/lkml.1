Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYIJP34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYIJP34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 11:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYIJP3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 11:29:48 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:31014 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbYIJP3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 11:29:48 -0400
X-BigFish: VPS-23(zz1432R98dR1805M936fQ873fnzz10d3izz2f39iz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K6ZKCT-04-HM4-01
Date: Wed, 10 Sep 2008 17:29:18 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] x86: avoid unnecessary low zone allocation in AMD IOMMU's alloc_coherent
Message-ID: <20080910152918.GD24392@amd.com>
References: <20080910232446O.fujita.tomonori@lab.ntt.co.jp> <20080910233819T.fujita.tomonori@lab.ntt.co.jp> <20080910145249.GB24392@amd.com> <20080911000936R.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080911000936R.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Sep 2008 15:29:18.0315 (UTC) FILETIME=[FD852BB0:01C91359]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 12:09:43AM +0900, FUJITA Tomonori wrote:
> On Wed, 10 Sep 2008 16:52:49 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Wed, Sep 10, 2008 at 11:39:00PM +0900, FUJITA Tomonori wrote:
> >  
> > > btw, in tip/x86/iommu, GART's alloc_coherent always does virtual
> > > mappings to allocate a size-aligned memory (as DMA-mapping.txt
> > > defines).
> > > 
> > > Because someone strongly insisted, I modified GART's alloc_coherent to
> > > do so but as I said again and again, it's completely meaningless (only
> > > POWER IOMMU does it and drivers don't depend on such requirement).
> > > 
> > > I guess that it would be better to do virtual mappings only when
> > > necessary as the current mainline does since GART I/O space is
> > > precious in some systems. But I don't care much. What's your opinion
> > > (as a AMD developer)?
> > 
> > Very true. My original rewrite did the mapping only when necessary too.
> > What were the reasons to do the mapping always?
> 
> As I said above, it's for allocating a size-aligned memory. Look at
> the description of pci_alloc_consistent in DMA-mapping.txt:
> 
> The cpu return address and the DMA bus master address are both
> guaranteed to be aligned to the smallest PAGE_SIZE order which
> is greater than or equal to the requested size.  This invariant
> exists (for example) to guarantee that if you allocate a chunk
> which is smaller than or equal to 64 kilobytes, the extent of the
> buffer you receive will not cross a 64K boundary.
> 
> You can't do this with __get_free_pages easily (you need some hacks to
> do this). You can do this via iommu_area_alloc() for free.

What hacks do you need with __get_free_pages? The memory it returns is
_always_ aligned at its size.

> 
> Well, actually you agreed with adding such requirement (though I said
> again and again that it's totally meaningless...):

The other possible way is removing this requirement from the
documentation. But if the spec has this requirement the code _has_ to
fullfill it, even if its meaningless for most drivers.

> http://lkml.org/lkml/2008/7/24/162

This message stated nothing about _always_ map GART alloc_coherent
allocations using the aperture.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

