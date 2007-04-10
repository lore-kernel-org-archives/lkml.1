Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbXDJGhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbXDJGhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 02:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXDJGhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 02:37:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60096 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbXDJGhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 02:37:14 -0400
Date: Tue, 10 Apr 2007 08:36:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [patch] sched: align rq to cacheline boundary
Message-ID: <20070410063656.GB23274@elte.hu>
References: <20070409180853.GC3948@linux-os.sc.intel.com> <20070409134057.2d249f0c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409134057.2d249f0c.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > -static DEFINE_PER_CPU(struct rq, runqueues);
> > +static DEFINE_PER_CPU(struct rq, runqueues) ____cacheline_aligned_in_smp;
> 
> Remember that this can consume up to (linesize-4 * NR_CPUS) bytes, 
> which is rather a lot.

yes - but one (special) issue here is that there are other 'hot' but 
truly per-CPU structures nearby:

 ffffffff8067e800 D per_cpu__current_kprobe
 ffffffff8067e820 D per_cpu__kprobe_ctlblk
 ffffffff8067e960 D per_cpu__mmu_gathers
 ffffffff8067f960 d per_cpu__runqueues
 ffffffff80680c60 d per_cpu__cpu_domains
 ffffffff80680df0 d per_cpu__sched_group_cpus

cpu_domains is being dirtied too (sd->nr_balance_failed, 
sd->last_balanc, etc.) and mmu_gathers too. So while both mmu_gathers 
and cpu_domains are mostly purely per-CPU, runqueue fields can bounce 
around alot and drag those nearby fields with them (and then get dragged 
back due to those nearby fields being used per-CPU again.)

the runqueue is really supposed to be cacheline-isolated at _both_ ends 
- at its beginning and at its end as well.

> And that putting a gap in the per-cpu memory like this will reduce its 
> overall cache-friendliness.

yes - although the per-cpu runqueue overhead is nearly 5K anyway.

> Remember also that the linesize on VSMP is 4k.

that sucks ...

maybe, to mitigate some of the costs, do a special PER_CPU_CACHE_ALIGNED 
area that collects per-cpu fields that also have significant cross-CPU 
use and need cacheline isolation? Such cacheline-aligned variables, if 
collected separately, would pack up more tightly and would cause only 
half of the wasted space.

	Ingo
