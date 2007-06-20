Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbXFTXII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbXFTXII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 19:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbXFTXH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 19:07:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:51010 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbXFTXHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 19:07:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,444,1175497200"; 
   d="scan'208";a="256959671"
Date: Wed, 20 Jun 2007 16:03:37 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 06/10] Avoid memory allocation failures in	dma	map api calls
Message-ID: <20070620230337.GA6771@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070619213808.798646000@askeshav-devel.jf.intel.com> <1182326799.21117.19.camel@twins> <46792586.20706@linux.intel.com> <20070620173038.GA25516@linux-os.sc.intel.com> <1182362703.21117.79.camel@twins> <46797CB1.8070008@linux.intel.com> <1182370132.21117.84.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182370132.21117.84.camel@twins>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 10:08:51PM +0200, Peter Zijlstra wrote:
> On Wed, 2007-06-20 at 12:14 -0700, Arjan van de Ven wrote:
> > Peter Zijlstra wrote:
> > > So a reclaim context (kswapd and direct reclaim) set PF_MEMALLOC to
> > > ensure they themselves will not block on a memory allocation. And it is
> > > understood that these code paths have a bounded memory footprint.
> > 
> > 
> > that's a too simplistic view though; what happens is that kswapd will 
> > queue the IO, but the irq context will then take the IO from the queue 
> > and do the DMA mapping... which needs the memory.....

As Arjan is saying, that a reclaim context sets PF_MEMALLOC flag
and submits the IO, but the controller driver decides to queue the IO,
and later in the interrupt context it de-queues and calls the
IOMMU driver for mapping the DMA physical address and in this DMA 
map api call we may need the memory to satisfy the DMA map api call.
Hence PF_MEMALLOC set by the reclaim context should work from 
interrupt context too, if it is not then that needs to be fixed.

> 
> Right, but who stops some unrelated interrupt handler from completely
> depleting memory?
The DMA map API's exposed by IOMMU are called by the 
storage/network controller driver and it is in this IOMMU
driver we are talking about allocating memory. So we have no 
clue how much I/O the controller above us is capable of submitting. 
And all we do is the mapping of DMA phyical address and 
provide the caller with the virtual DMA address and it
is in this process we may need some memory.

> 
> What I'm saying is that there should be some coupling between the
> reclaim context and the irq context doing work on its behalf.
Nope this info is not available when upper level drivers
calls the standard DMA map api's.

> 
> For instance, you know how many pages are in the queue, and which queue.
> So you could preallocate enough memory to handle that many pages from
> irq context and couple that reserve to the queue object. Then irq
> context can use that memory to do the work.

As I have said earlier, we are not the storage or network controller
driver and we have no idea how much the IO the controller is capable of.


Again this patch is the best effort for not to fail the DMA map api,
if it fails due to lack of memory, we have no choice but to return
failure to upper level driver. But today, upper level drivers are
not capable of handling failures from DMA map api's hence this best
effort for not to fail the DMA map api call.

thanks,
-Anil


