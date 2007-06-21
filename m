Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbXFUGK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbXFUGK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 02:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbXFUGKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 02:10:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33745 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXFUGKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 02:10:19 -0400
Subject: Re: [Intel IOMMU 06/10] Avoid memory allocation failures
	in	dma	map api calls
From: Peter Zijlstra <peterz@infradead.org>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
In-Reply-To: <20070620230337.GA6771@linux-os.sc.intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
	 <20070619213808.798646000@askeshav-devel.jf.intel.com>
	 <1182326799.21117.19.camel@twins> <46792586.20706@linux.intel.com>
	 <20070620173038.GA25516@linux-os.sc.intel.com>
	 <1182362703.21117.79.camel@twins> <46797CB1.8070008@linux.intel.com>
	 <1182370132.21117.84.camel@twins>
	 <20070620230337.GA6771@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Thu, 21 Jun 2007 08:10:12 +0200
Message-Id: <1182406212.21117.94.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 16:03 -0700, Keshavamurthy, Anil S wrote:
> On Wed, Jun 20, 2007 at 10:08:51PM +0200, Peter Zijlstra wrote:
> > On Wed, 2007-06-20 at 12:14 -0700, Arjan van de Ven wrote:
> > > Peter Zijlstra wrote:
> > > > So a reclaim context (kswapd and direct reclaim) set PF_MEMALLOC to
> > > > ensure they themselves will not block on a memory allocation. And it is
> > > > understood that these code paths have a bounded memory footprint.
> > > 
> > > 
> > > that's a too simplistic view though; what happens is that kswapd will 
> > > queue the IO, but the irq context will then take the IO from the queue 
> > > and do the DMA mapping... which needs the memory.....
> 
> As Arjan is saying, that a reclaim context sets PF_MEMALLOC flag
> and submits the IO, but the controller driver decides to queue the IO,
> and later in the interrupt context it de-queues and calls the
> IOMMU driver for mapping the DMA physical address and in this DMA 
> map api call we may need the memory to satisfy the DMA map api call.
> Hence PF_MEMALLOC set by the reclaim context should work from 
> interrupt context too, if it is not then that needs to be fixed.

PF_MEMALLOC cannot work from interrupt context, nor should it. But there
are other options.

What I'm saying is that if you do use the reserves, you should ensure
the use is bounded. I'm not seeing anything like that.

This is a generic API, who is to ensure some other non-swap device will
not deplete memory and deadlock the reclaim process?


Also, please do explain why mempools are not usable? those will have
exactly the same semantics as you are now getting (if PF_MEMALLOC would
work from interrupt context).


Also, explain to me how an IOMMU is different from bounce buffers? They
both do the same thing, no? They both need memory in order to complete
DMA.

Is it just a broken API you're working against? If so, isn't the Linux
way to fix these things, that is why we have the source code after all.


