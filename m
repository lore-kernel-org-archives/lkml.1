Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbYJCIkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbYJCIkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 04:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYJCIj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 04:39:59 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:59685 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbYJCIj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 04:39:58 -0400
Date: Fri, 3 Oct 2008 11:38:20 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joro@8bytes.org,
       amit.shah@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org, mingo@redhat.com,
       Ben-Ami Yassour1 <benami@il.ibm.com>
Subject: Re: [PATCH 9/9] x86/iommu: use dma_ops_list in get_dma_ops
Message-ID: <20081003083820.GH6909@il.ibm.com>
References: <20080928191333.GC26563@8bytes.org> <20080929093044.GB6931@il.ibm.com> <20080929093652.GQ27426@8bytes.org> <20080929221640X.fujita.tomonori@lab.ntt.co.jp> <20080929133311.GK27928@amd.com> <20080930194401.GC20341@il.ibm.com> <20081001071956.GA27826@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001071956.GA27826@amd.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 09:19:56AM +0200, Joerg Roedel wrote:

> > It might be possible to have a per-device slow or fast path, where
> > the fast path is for devices which have no DMA limitations
> > (high-end devices generally don't) and the slow path is for
> > devices which do.
> 
> This solves the problem with the DMA masks. But what happens to
> requests that cross guest page boundarys?

I'm not sure I follow. If a buffer is contiguous in the guest space,
it will remain contiguous (i.e., be mapped contiguously) in the IOMMU
I/O address space, even if each I/O PTE ends up mapping a different
physical frame.

> > > With mapping/unmapping through hypercalls we add the
> > > world-switch overhead to the copy-overhead. We can't avoid this
> > > when we have no hardware support at all. But already with older
> > > IOMMUs like Calgary and GART we can at least avoid the
> > > world-switch. And since, for example, every 64 bit capable AMD
> > > processor has a GART we can make use of it.
> > 
> > It should be possible to reduce the number and overhead of
> > hypercalls to the point where their cost is immaterial. I think
> > that's fundamentally a better approach.
> 
> Ok, we can queue map_sg allocations together an queue them into one
> hypercall. But I remember a paper from you where you wrote that most
> allocations are mapping only one area.

I'm afraid that bit of the paper was poorly done (mea culpa). As far
as I can recall, the majority of dma_alloc_coherent + scatter-gather
list *element* mappings only map a single frame, but we didn't look at
the time at the average length of a scatter gather list and the
frequency of sg list mappings vs. single page mappings. If the length
and frequency are high enough, and you map entire sg lists in a single
hcall or a single batch of hcalls, it might have a nice boost.

> Are there other ways to optimize this? I must say that reducing the
> number of hypercalls was important while thinking about my idea. If
> there are better ways I am all ears to hear from them.

There were a number of ideas mentioned in our paper (for example,
switching drivers from the streaming DMA API to the persistent DMA
API, which will be a big help to the scheme you propose), and Willman,
Rixner and Cox also had some input to the problem[1]. Unfortunately no
implementations exist yet AFAIK.

[1] "Protection Strategies for Direct Access to Virtualized I/O
Devices", by Paul Willmann, Scott Rixner and Alan L. Cox, USENIX '08.

Cheers,
Muli
-- 
The First Workshop on I/O Virtualization (WIOV '08)
Dec 2008, San Diego, CA, http://www.usenix.org/wiov08/
                       <->
SYSTOR 2009---The Israeli Experimental Systems Conference
http://www.haifa.il.ibm.com/conferences/systor2009/
