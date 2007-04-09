Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbXDIVvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbXDIVvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXDIVvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:51:41 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:57950 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbXDIVu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:50:59 -0400
Date: Mon, 9 Apr 2007 14:53:09 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, mingo@elte.hu,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [patch] sched: align rq to cacheline boundary
Message-ID: <20070409215309.GC5275@localhost.localdomain>
References: <20070409180853.GC3948@linux-os.sc.intel.com> <20070409134057.2d249f0c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409134057.2d249f0c.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 01:40:57PM -0700, Andrew Morton wrote:
> On Mon, 9 Apr 2007 11:08:53 -0700
> "Siddha, Suresh B" <suresh.b.siddha@intel.com> wrote:
> 
> > Align the per cpu runqueue to the cacheline boundary. This will minimize the
> > number of cachelines touched during remote wakeup.
> > 
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > ---
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index b9a6837..eca33c5 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -278,7 +278,7 @@ struct rq {
> >  	struct lock_class_key rq_lock_key;
> >  };
> >  
> > -static DEFINE_PER_CPU(struct rq, runqueues);
> > +static DEFINE_PER_CPU(struct rq, runqueues) ____cacheline_aligned_in_smp;
> 
> Remember that this can consume up to (linesize-4 * NR_CPUS) bytes, which is
> rather a lot.
> 
> Remember also that the linesize on VSMP is 4k.
> 
> And that putting a gap in the per-cpu memory like this will reduce its
> overall cache-friendliness.
> 

The internode line size yes.  But Suresh is using ____cacheline_aligned_in_smp,
which uses SMP_CACHE_BYTES (L1_CACHE_BYTES).  So this does not align the 
per-cpu variable to 4k.  However, if the motivation for this patch was 
significant performance difference, then, the above padding needs to be on 
the internode cacheline size using ____cacheline_internodealigned_in_smp.
____cacheline_internodealigned_in_smp aligns a data structure to the
internode line size, which is 4k for vSMPowered systems and L1 line size 
for all other architectures.

As for the (linesize-4 * NR_CPUS) wastage, maybe we can place the cacheline 
aligned per-cpu data in another section, just like we do with 
.data.cacheline_aligned section, but keep this new section between
__percpu_start and __percpu_end?

