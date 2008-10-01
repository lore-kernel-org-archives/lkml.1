Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbYJAHUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbYJAHUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYJAHUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:20:21 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:62082 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYJAHUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:20:20 -0400
X-BigFish: VPS-34(zz1418M1432R98dR1805M936fOzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K81TPI-03-BBX-01
Date: Wed, 1 Oct 2008 09:19:56 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joro@8bytes.org,
       amit.shah@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org, mingo@redhat.com
Subject: Re: [PATCH 9/9] x86/iommu: use dma_ops_list in get_dma_ops
Message-ID: <20081001071956.GA27826@amd.com>
References: <20080928191333.GC26563@8bytes.org> <20080929093044.GB6931@il.ibm.com> <20080929093652.GQ27426@8bytes.org> <20080929221640X.fujita.tomonori@lab.ntt.co.jp> <20080929133311.GK27928@amd.com> <20080930194401.GC20341@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080930194401.GC20341@il.ibm.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 01 Oct 2008 07:19:56.0913 (UTC) FILETIME=[1B6F8610:01C92396]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 10:44:01PM +0300, Muli Ben-Yehuda wrote:
> On Mon, Sep 29, 2008 at 03:33:11PM +0200, Joerg Roedel wrote:
> 
> > > Nobody cares about the performance of dma_alloc_coherent. Only the
> > > performance of map_single/map_sg matters.
> > >
> > > I'm not sure how expensive the hypercalls are, but they are more
> > > expensive than bounce buffering coping lots of data for every
> > > I/Os?
> > 
> > I don't think that we can avoid bounce buffering into the guests at
> > all (with and without my idea of a paravirtualized IOMMU) when we
> > want to handle dma_masks and requests that cross guest physical
> > pages properly.
> 
> It might be possible to have a per-device slow or fast path, where the
> fast path is for devices which have no DMA limitations (high-end
> devices generally don't) and the slow path is for devices which do.

This solves the problem with the DMA masks. But what happens to requests
that cross guest page boundarys?

> > With mapping/unmapping through hypercalls we add the world-switch
> > overhead to the copy-overhead. We can't avoid this when we have no
> > hardware support at all. But already with older IOMMUs like Calgary
> > and GART we can at least avoid the world-switch. And since, for
> > example, every 64 bit capable AMD processor has a GART we can make
> > use of it.
> 
> It should be possible to reduce the number and overhead of hypercalls
> to the point where their cost is immaterial. I think that's
> fundamentally a better approach.

Ok, we can queue map_sg allocations together an queue them into one
hypercall. But I remember a paper from you where you wrote that most
allocations are mapping only one area. Are there other ways to optimize
this? I must say that reducing the number of hypercalls was important
while thinking about my idea. If there are better ways I am all ears to
hear from them.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

