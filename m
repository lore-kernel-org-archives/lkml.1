Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbXFZFf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbXFZFf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 01:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbXFZFfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 01:35:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40530 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271AbXFZFfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 01:35:17 -0400
Date: Mon, 25 Jun 2007 22:34:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de,
       muli@il.ibm.com, suresh.b.siddha@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 06/10] Avoid memory allocation failures in dma map
 api calls
Message-Id: <20070625223456.b78f1784.akpm@linux-foundation.org>
In-Reply-To: <1182326799.21117.19.camel@twins>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
	<20070619213808.798646000@askeshav-devel.jf.intel.com>
	<1182326799.21117.19.camel@twins>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007 10:06:39 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2007-06-19 at 14:37 -0700, Keshavamurthy, Anil S wrote:
> > plain text document attachment (intel_iommu_pf_memalloc.patch)
> > Intel IOMMU driver needs memory during DMA map calls to setup its internal
> > page tables and for other data structures. As we all know that these DMA 
> > map calls are mostly called in the interrupt context or with the spinlock 
> > held by the upper level drivers(network/storage drivers), so in order to 
> > avoid any memory allocation failure due to low memory issues,
> > this patch makes memory allocation by temporarily setting PF_MEMALLOC
> > flags for the current task before making memory allocation calls.
> > 
> > We evaluated mempools as a backup when kmem_cache_alloc() fails
> > and found that mempools are really not useful here because
> >  1) We don;t know for sure how much to reserve in advance
> 
> So you just unleashed an unbounded allocation context on PF_MEMALLOC?
> seems like a really really bad idea.
> 
> >  2) And mempools are not useful for GFP_ATOMIC case (as we call 
> >     memory alloc functions with GFP_ATOMIC)
> 
> Mempools work as intended with GFP_ATOMIC, it gets filled up to the
> specified number of elements using GFP_KERNEL (at creation time). This
> gives GFP_ATOMIC allocations nr_elements extra items once it would start
> failing.

Yup.  Changelog is buggy.

> > With PF_MEMALLOC flag set in the current->flags, the VM subsystem avoids
> > any watermark checks before allocating memory thus guarantee'ing the 
> > memory till the last free page.
> 
> PF_MEMALLOC as is, is meant to salvage the VM from the typical VM
> deadlock. Using it as you do now is not something a driver should ever
> do, and I'm afraid I will have to strongly oppose this patch.
> 
> You really really want to calculate an upper bound on your memory
> consumption and reserve this.
> 
> So, I'm afraid I'll have to..
> 
> NACK!

err, PF_MEMALLOC doesn't actually do anything if in_interrupt(), so your
reason-for-nacking isn't legitimate.  And neither is Anil's patch ;)

So I'm thinking that if this patch passed all his testing, a patch which
didn't play these PF_MEMALLOC games would pass the same tests.

