Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbZJZQ1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbZJZQ1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZJZQ1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:27:04 -0400
Received: from sous-sol.org ([216.99.217.87]:39793 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753126AbZJZQ1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:27:03 -0400
Date: Mon, 26 Oct 2009 09:26:37 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Chris Wright <chrisw@sous-sol.org>, David Woodhouse <dwmw2@infradead.org>,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] allow fallback to swiotlb on hw iommu init
	failures
Message-ID: <20091026162637.GA27699@sequoia.sous-sol.org>
References: <20091023012158.177308035@sequoia.sous-sol.org> <87hbtmy6jc.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hbtmy6jc.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> Chris Wright <chrisw@sous-sol.org> writes:
> 
> > This short series gives us the ability to allocate the swiotlb and then
> > conditionally free it if we discover it isn't needed.  This allows us to
> > put swiotlb to use when the hw iommu fails to initialize properly.
> >
> > This needs some changes to the bootmem allocator to give the ability to
> > free reserved bootmem directly to the page allocator after bootmem is
> > torn down.
> 
> You forgot to state what motivated you to that change?

I thought I did ;-)  Here's another more verbose attempt:

The HW IOMMU, for example Intel VT-d, may fail initialization (typically
due to BIOS bugs).  In that case the existing fallback is nommu, which is
clearly insufficient for many boxen which need some bounce buffering if
there is no HW IOMMU.  The problem is that at the point of this failure
the decision to allocate and initialize the swiotlb has long since past.

There are 4 ways to handle this:

1) Give up and panic the box.  This is not a user friendly option since
the box will boot and function fine (minus any isolation gained from the
HW IOMMU) if there is either not much phys mem or an swiotlb.

2) Do the discovery that causes the initialization failure earlier so
that HW IOMMU detection fails.  Compilcated by the HW IOMMU's use of the
run time env that includes a real allocator and PCI enumeration, etc.

3) Allow the swiotlb to be allocated later in pci_iommu_init() instead
of early in pci_iommu_alloc(), IOW don't use bootmem for the swiotlb.
This is possible, although it will hit 2 limitations.  The first is any
possible fragmentation that limits the availability of a 64M region
by the time this runs.  The second is that x86 has MAX_ORDER of 11,
so at most we can allocate a 4M region from the page allocator which is
inusufficient for swiotlb.

4) Allow the swiotlb to be allocated in pci_iommu_alloc(), but not
initialized until pci_iommu_init().  This allows using bootmem allocator
to reserve a nice large contiguous chunk of memory, but requires some
way to give that memory back in the case that a HW IOMMU is properly
both detected and initialized (else it'd be a 64M memory leak for
effectively all HW IOMMU enabled boxen).

This series implements the fourth option.

thanks,
-chris
