Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbXFLAa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbXFLAa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 20:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbXFLAaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 20:30:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46242 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512AbXFLAaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 20:30:17 -0400
Date: Mon, 11 Jun 2007 17:30:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool
 handling
Message-Id: <20070611173001.e0355af3.akpm@linux-foundation.org>
In-Reply-To: <20070611235208.GC25022@linux-os.sc.intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
	<200706090056.49279.ak@suse.de>
	<Pine.LNX.4.64.0706081558090.4373@schroedinger.engr.sgi.com>
	<200706091147.24705.ak@suse.de>
	<20070611204442.GA4074@linux-os.sc.intel.com>
	<20070611141449.bfbc4769.akpm@linux-foundation.org>
	<20070611235208.GC25022@linux-os.sc.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007 16:52:08 -0700 "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:

> On Mon, Jun 11, 2007 at 02:14:49PM -0700, Andrew Morton wrote:
> > On Mon, 11 Jun 2007 13:44:42 -0700
> > "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:
> > 
> > > In the first implementation of ours, we had used mempools api's to 
> > > allocate memory and we were told that mempools with GFP_ATOMIC is
> > > useless and hence in the second implementation we came up with
> > > resource pools ( which is preallocate pools) and again as I understand
> > > the argument is why create another when we have slab allocation which
> > > is similar to this resource pools.
> > 
> > Odd.  mempool with GFP_ATOMIC is basically equivalent to your
> > resource-pools, isn't it?: we'll try the slab allocator and if that failed,
> > fall back to the reserves.
> 
> slab allocators don;t reserve the memory, in other words this memory 
> can be consumed by VM under memory pressure which we don;t want in
> IOMMU case.
> 
> Nope,they both are exactly opposite. 
> mempool with GFP_ATOMIC, first tries to get memory from OS and
> if that fails, it looks for the object in the pool and returns.
> 
> Where as resource pool is exactly opposite of mempool, where each 
> time it looks for an object in the pool and if it exist then we 
> return that object else we try to get the memory for OS while 
> scheduling the work to grow the pool objects. In fact, the  work
> is schedule to grow the pool when the low threshold point is hit.

I realise all that.  But I'd have thought that the mempool approach is
actually better: use the page allocator and only deplete your reserve pool
when the page allocator fails.

The refill-the-pool-in-the-background feature sounds pretty worthless to
me.  On a uniprocessor machine (for example), the kernel thread may not get
scheduled for tens of milliseconds (easily), which is far, far more than is
needed for that reserve pool to become fully consumed.

