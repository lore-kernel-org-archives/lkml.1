Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbYBLPjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbYBLPjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYBLPjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:39:33 -0500
Received: from mga07.intel.com ([143.182.124.22]:58051 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751258AbYBLPjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:39:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,341,1199692800"; 
   d="scan'208";a="378099320"
Date: Tue, 12 Feb 2008 07:37:00 -0800
From: mark gross <mgross@linux.intel.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH]intel-iommu batched iotlb flushes
Message-ID: <20080212153700.GB27490@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20080211224105.GB24412@linux.intel.com> <20080212085256.GF5750@rhun.haifa.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212085256.GF5750@rhun.haifa.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 10:52:56AM +0200, Muli Ben-Yehuda wrote:
> On Mon, Feb 11, 2008 at 02:41:05PM -0800, mark gross wrote:
> 
> > The intel-iommu hardware requires a polling operation to flush IOTLB
> > PTE's after an unmap operation.  Through some TSC instrumentation of
> > a netperf UDP stream with small packets test case it was seen that
> > the flush operations where sucking up to 16% of the CPU time doing
> > iommu_flush_iotlb's
> > 
> > The following patch batches the IOTLB flushes removing most of the
> > overhead in flushing the IOTLB's.  It works by building a list of to
> > be released IOVA's that is iterated over when a timer goes off or
> > when a high water mark is reached.
> > 
> > The wrinkle this has is that the memory protection and page fault
> > warnings from errant DMA operations is somewhat reduced, hence a kernel
> > parameter is added to revert back to the "strict" page flush / unmap
> > behavior. 
> > 
> > The hole is the following scenarios: 
> > do many map_signal operations, do some unmap_signals, reuse a recently
> > unmapped page, <errant DMA hardware sneaks through and steps on reused
> > memory>
> > 
> > Or: you have rouge hardware using DMA's to look at pages: do many
> > map_signal's, do many unmap_singles, reuse some unmapped pages : 
> > <rouge hardware looks at reused page>
> > 
> > Note : these holes are very hard to get too, as the IOTLB is small
> > and only the PTE's still in the IOTLB can be accessed through this
> > mechanism.
> > 
> > Its recommended that strict is used when developing drivers that do
> > DMA operations to catch bugs early.  For production code where
> > performance is desired running with the batched IOTLB flushing is a
> > good way to go.
> 
> While I don't disagree with this patch in principle (Calgary does the
> same thing due to expensive IOTLB flushes) the right way to fix it
> IMHO is to fix the drivers to batch mapping and unmapping operations
> or map up-front and unmap when done. The streaming DMA-API was
> designed to conserve IOMMU mappings for machines where IOMMU mappings
> are a scarce resource, and is a poor fit for a modern IOMMU such as
> VT-d with a 64-bit IO address space (or even an IOMMU with a 32-bit
> address space such as Calgary) where there are plenty of IOMMU
> mappings available.

Yes, have a DMA pool of DMA addresses to use and re-use in the stack
instead of setting up and tearing down the PTE's is something we need to
look at closely for network and other high DMA traffic stacks. 

--mgross


