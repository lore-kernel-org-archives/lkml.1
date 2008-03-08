Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYCHRVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYCHRVW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 12:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbYCHRVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 12:21:10 -0500
Received: from colo.lackof.org ([198.49.126.79]:39847 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487AbYCHRVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 12:21:09 -0500
Date: Sat, 8 Mar 2008 10:20:56 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: mark gross <mgross@linux.intel.com>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
       lkml <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH] Use an array instead of a list for deffered
	intel-iommu iotlb flushing  Re: [PATCH]iommu-iotlb-flushing
Message-ID: <20080308172056.GA25083@colo.lackof.org>
References: <20080221000623.GA5510@linux.intel.com> <20080223000517.232704f3.akpm@linux-foundation.org> <20080229231841.GA6639@linux.intel.com> <20080301071043.GB9373@colo.lackof.org> <20080303183411.GA13582@linux.intel.com> <20080305182315.GA15765@colo.lackof.org> <20080305230157.GA24220@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305230157.GA24220@linux.intel.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 03:01:57PM -0800, mark gross wrote:
...
> > *nod* - I know. That why I use pktgen to measure the dma map/unmap overhead.
> > Note that with solid state storage (should be more visible in the next year
> > or so), the transaction rate is going to look alot more like a NIC than
> > the traditional HBA storage controller. So map/unmap performance will
> > matter for those configurations too.
> 
> Sweet! now I have an excuse to get one of those spiffy SD-Disks!  

*chuckle* Glad I could be of assistance :P

...
> > Ok - I wasn't sure which step was the "syncronize step".
> > 
> > BTW, I hope you (and others from Intel - go willy! ;) can give feedback
> > to the Intel/AMD chipset designers to ditch this design ASAP.
> > It clearly sucks.
> > 
> 
> The HW implementation IS evolving.  Especially as the MCH and more of
> the chipsets are moved into the CPU package.  It will get better over
> time, but the protection will never be "free".

Agreed. But IO TLB shoot-down/invalidate could be alot cheaper. Intel knows
how to do it for CPU MMU (I hope they do at least given IA64 experience).
IO MMU should be no different (well, not too much different). IOMMU is
like the CPU MMU except it's shared by many IO devices instead of
"one per CPU".

> > If you can reduce the overhead to < 1% for pktgen, TPC-C won't
> > notice it and I doubt specweb will either.
> 
> Sadly only a fraction of the overhead is due to the IOTLB flushes.
> I can't wave away the IOVA management overhead with batched
> flushes of the IOTLB.

Right. IOVA management is CPU intensive.  But stalling on IO TLB flush
syncronize is a major part, an easy target and should be reduced.
Taking advantage of "warm cache" and other "normal" coding methods
will help minimize the CPU overhead.

....
> I've been using oprofile, and some TSC counters I have in an out-of tree
> patch for instrumenting the code and dumping the cycles per
> code-path-of-interest.  Its been pretty effective, but it affects the
> throughput of the run.

I removed stats from the parisc IOMMU code exactly for that reason.
It was useful for evaluating details of specific algorithms (comparative)
but not for runtime benchmarking. I suggest removing that code.

> > > FWIW : throughput isn't effected so much as the CPU overhead.
> > > iommu=strict: 16K UDP UNIDIRECTIONAL SEND TEST 826Mbps at 25% cpu 
> > > with this patch: 16K UDP UNIDIRECTIONAL SEND TEST 826Mbps at 18% cpu 
> > > IOMMU=OFF: 16K UDP UNIDIRECTIONAL SEND TEST 826Mbps at 11% cpu 
> > 
> > Understood. That's why netperf (see netperf.org) measures "service demand".
> > Taking CPU away from user space generally results in lower benchmark/app perf.
> >
> 
> The following patch is an update to use an array instead of a list of
> IOVA's in the implementation of defered iotlb flushes.  It takes
> inspiration from sba_iommu.c
> 
> I like this implementation better as it encapsulates the batch process
> within intel-iommu.c, and no longer touches iova.h (which is shared)
> 
> Performance data:  Netperf 32byte UDP streaming
> 2.6.25-rc3-mm1:
> IOMMU-strict : 58Mps @ 62% cpu
> NO-IOMMU : 71Mbs @ 41% cpu
> List-based IOMMU-default-batched-IOTLB flush: 66Mbps @ 57% cpu
> 
> with this patch:
> IOMMU-strict : 73Mps @ 75% cpu
> NO-IOMMU : 74Mbs @ 42% cpu
> Array-based IOMMU-default-batched-IOTLB flush: 72Mbps @ 62% cpu

Nice! :)
66/57 == 1.15
72/62 == 1.16
~10% higher throughput with essentially no change in service demand.

But I'm wondering why IOMMU-strict gets better throughput. Something
else is going on here. I suspect better CPU cache utilization and
perhaps lowering the high water mark to 32 would be a test to prove that.

BTW, can you clarify what the units are?
I see "Mps", "Mbs", and "Mbps". Ideally we'd be using
a single unit of measure to compare. "Mpps" would be my preferred one
(Million packets per second) for small, fixed sized packets.

Ditch the "debug" code (stats pr0n) and I'll bet this will go up
a few more percentage points and reduce the service demand.

cheers,
grant
