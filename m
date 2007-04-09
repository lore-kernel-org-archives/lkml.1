Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbXDIWSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbXDIWSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 18:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbXDIWSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 18:18:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:2430 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbXDIWST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 18:18:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,388,1170662400"; 
   d="scan'208"; a="210625301:sNHT19943189"
Date: Mon, 9 Apr 2007 15:17:05 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, mingo@elte.hu,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [patch] sched: align rq to cacheline boundary
Message-ID: <20070409221705.GD3948@linux-os.sc.intel.com>
References: <20070409180853.GC3948@linux-os.sc.intel.com> <20070409134057.2d249f0c.akpm@linux-foundation.org> <20070409215309.GC5275@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409215309.GC5275@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 02:53:09PM -0700, Ravikiran G Thirumalai wrote:
> On Mon, Apr 09, 2007 at 01:40:57PM -0700, Andrew Morton wrote:
> > On Mon, 9 Apr 2007 11:08:53 -0700
> > "Siddha, Suresh B" <suresh.b.siddha@intel.com> wrote:
> > > -static DEFINE_PER_CPU(struct rq, runqueues);
> > > +static DEFINE_PER_CPU(struct rq, runqueues) ____cacheline_aligned_in_smp;
> > 
> > Remember that this can consume up to (linesize-4 * NR_CPUS) bytes, which is
> > rather a lot.

Atleast on x86_64, this depends on cpu_possible_map and not NR_CPUS.

> > 
> > Remember also that the linesize on VSMP is 4k.
> > 
> > And that putting a gap in the per-cpu memory like this will reduce its
> > overall cache-friendliness.
> > 
> 
> The internode line size yes.  But Suresh is using ____cacheline_aligned_in_smp,
> which uses SMP_CACHE_BYTES (L1_CACHE_BYTES).  So this does not align the 
> per-cpu variable to 4k.  However, if the motivation for this patch was 
> significant performance difference, then, the above padding needs to be on 
> the internode cacheline size using ____cacheline_internodealigned_in_smp.

I see a 0.5% perf improvement on database workload(which is a good
improvement for this workload). This patch is minimizing number of cache
lines that it touches during a remote task wakeup.

Kiran, can you educate me when I am supposed to use
____cacheline_aligned_in_smp
Vs
__cacheline_aligned_in_smp ?

> As for the (linesize-4 * NR_CPUS) wastage, maybe we can place the cacheline 
> aligned per-cpu data in another section, just like we do with 
> .data.cacheline_aligned section, but keep this new section between
> __percpu_start and __percpu_end?

Yes. But that will still waste some memory in the new section, if the data
elements are not multiples of 4k.

thanks,
suresh
