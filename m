Return-Path: <linux-kernel-owner+w=401wt.eu-S1762056AbYBLIxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056AbYBLIxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761861AbYBLIxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:53:05 -0500
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:17744 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761855AbYBLIxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:53:04 -0500
Date: Tue, 12 Feb 2008 10:52:56 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: mark gross <mgross@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH]intel-iommu batched iotlb flushes
Message-ID: <20080212085256.GF5750@rhun.haifa.ibm.com>
References: <20080211224105.GB24412@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211224105.GB24412@linux.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 02:41:05PM -0800, mark gross wrote:

> The intel-iommu hardware requires a polling operation to flush IOTLB
> PTE's after an unmap operation.  Through some TSC instrumentation of
> a netperf UDP stream with small packets test case it was seen that
> the flush operations where sucking up to 16% of the CPU time doing
> iommu_flush_iotlb's
> 
> The following patch batches the IOTLB flushes removing most of the
> overhead in flushing the IOTLB's.  It works by building a list of to
> be released IOVA's that is iterated over when a timer goes off or
> when a high water mark is reached.
> 
> The wrinkle this has is that the memory protection and page fault
> warnings from errant DMA operations is somewhat reduced, hence a kernel
> parameter is added to revert back to the "strict" page flush / unmap
> behavior. 
> 
> The hole is the following scenarios: 
> do many map_signal operations, do some unmap_signals, reuse a recently
> unmapped page, <errant DMA hardware sneaks through and steps on reused
> memory>
> 
> Or: you have rouge hardware using DMA's to look at pages: do many
> map_signal's, do many unmap_singles, reuse some unmapped pages : 
> <rouge hardware looks at reused page>
> 
> Note : these holes are very hard to get too, as the IOTLB is small
> and only the PTE's still in the IOTLB can be accessed through this
> mechanism.
> 
> Its recommended that strict is used when developing drivers that do
> DMA operations to catch bugs early.  For production code where
> performance is desired running with the batched IOTLB flushing is a
> good way to go.

While I don't disagree with this patch in principle (Calgary does the
same thing due to expensive IOTLB flushes) the right way to fix it
IMHO is to fix the drivers to batch mapping and unmapping operations
or map up-front and unmap when done. The streaming DMA-API was
designed to conserve IOMMU mappings for machines where IOMMU mappings
are a scarce resource, and is a poor fit for a modern IOMMU such as
VT-d with a 64-bit IO address space (or even an IOMMU with a 32-bit
address space such as Calgary) where there are plenty of IOMMU
mappings available.

Cheers,
Muli
