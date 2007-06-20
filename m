Return-Path: <linux-kernel-owner+w=401wt.eu-S1762911AbXFTUJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762911AbXFTUJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757947AbXFTUJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:09:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40616 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889AbXFTUJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:09:12 -0400
Subject: Re: [Intel IOMMU 06/10] Avoid memory allocation failures
	in	dma	map api calls
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
In-Reply-To: <46797CB1.8070008@linux.intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
	 <20070619213808.798646000@askeshav-devel.jf.intel.com>
	 <1182326799.21117.19.camel@twins> <46792586.20706@linux.intel.com>
	 <20070620173038.GA25516@linux-os.sc.intel.com>
	 <1182362703.21117.79.camel@twins>  <46797CB1.8070008@linux.intel.com>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 22:08:51 +0200
Message-Id: <1182370132.21117.84.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 12:14 -0700, Arjan van de Ven wrote:
> Peter Zijlstra wrote:
> > So a reclaim context (kswapd and direct reclaim) set PF_MEMALLOC to
> > ensure they themselves will not block on a memory allocation. And it is
> > understood that these code paths have a bounded memory footprint.
> 
> 
> that's a too simplistic view though; what happens is that kswapd will 
> queue the IO, but the irq context will then take the IO from the queue 
> and do the DMA mapping... which needs the memory.....

Right, but who stops some unrelated interrupt handler from completely
depleting memory?

What I'm saying is that there should be some coupling between the
reclaim context and the irq context doing work on its behalf.

For instance, you know how many pages are in the queue, and which queue.
So you could preallocate enough memory to handle that many pages from
irq context and couple that reserve to the queue object. Then irq
context can use that memory to do the work.



