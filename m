Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbYGaL1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbYGaL1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 07:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYGaL1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 07:27:37 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47614 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbYGaL1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 07:27:36 -0400
Date: Thu, 31 Jul 2008 12:27:34 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Munson <ebmunson@us.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       libhugetlbfs-devel@lists.sourceforge.net
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
Message-ID: <20080731112734.GE1704@csn.ul.ie>
References: <cover.1216928613.git.ebmunson@us.ibm.com> <200807311604.14349.nickpiggin@yahoo.com.au> <20080730231428.a7bdcfa7.akpm@linux-foundation.org> <200807311626.15709.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200807311626.15709.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (31/07/08 16:26), Nick Piggin didst pronounce:
> On Thursday 31 July 2008 16:14, Andrew Morton wrote:
> > On Thu, 31 Jul 2008 16:04:14 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
> wrote:
> > > > Do we expect that this change will be replicated in other
> > > > memory-intensive apps?  (I do).
> > >
> > > Such as what? It would be nice to see some numbers with some HPC or java
> > > or DBMS workload using this. Not that I dispute it will help some cases,
> > > but 10% (or 20% for ppc) I guess is getting toward the best case, short
> > > of a specifically written TLB thrasher.
> >
> > I didn't realise the STREAM is using vast amounts of automatic memory.
> > I'd assumed that it was using sane amounts of stack, but the stack TLB
> > slots were getting zapped by all the heap-memory activity.  Oh well.
> 
> An easy mistake to make because that's probabably how STREAM would normally
> work. I think what Mel had done is to modify the stream kernel so as to
> have it operate on arrays of stack memory.
> 

Yes, I mentioned in the mail that STREAM was patched to use stack for
its data. It was as much to show the patches were working as advertised
even though it is an extreme case obviously.

I had seen stack-hugepage-backing as something that would improve performance
in addition to something else as opposed to having to stand entirely on its
own. For example, I would expect many memory-intensive applications to gain
by just having malloc and stack backed more than backing either in isolation.

> > I guess that effect is still there, but smaller.
> 
> I imagine it should be, unless you're using a CPU with seperate TLBs for
> small and huge pages, and your large data set is mapped with huge pages,
> in which case you might now introduce *new* TLB contention between the
> stack and the dataset :)

Yes, this can happen particularly on older CPUs. For example, on my
crash-test laptop the Pentium III there reports

TLB and cache info:
01: Instruction TLB: 4KB pages, 4-way set assoc, 32 entries
02: Instruction TLB: 4MB pages, 4-way set assoc, 2 entries

so a workload that sparsely addressed memory (i.e. >= 4MB strides on each
reference) might suffer more TLB misses with large pages than with small.
It's hardly new that there are is uncertainity around when and if hugepages
are of benefit and where.

> Also, interestingly I have actually seen some CPUs whos memory operations
> get significantly slower when operating on large pages than small (in the
> case when there is full TLB coverage for both sizes). This would make
> sense if the CPU only implements a fast L1 TLB for small pages.
> 

It's also possible there is a micro-TLB involved that only support small
pages. It's been the case for a while that what wins on one machine type
may lose on another.

> So for the vast majority of workloads, where stacks are relatively small
> (or slowly changing), and relatively hot, I suspect this could easily have
> no benefit at best and slowdowns at worst.
> 

I wouldn't expect an application with small stacks to request its stack
to be backed by hugepages either. Ideally, it would be enabled because a
large enough number of DTLB misses were found to be in the stack
although catching this sort of data is tricky. 

> But I'm not saying that as a reason not to merge it -- this is no
> different from any other hugepage allocations and as usual they have to be
> used selectively where they help.... I just wonder exactly where huge
> stacks will help.
> 

Benchmark wise, SPECcpu and SPEComp have stack-dependent benchmarks.
Computations that partition problems with recursion I would expect to benefit
as well as some JVMs that heavily use the stack (see how many docs suggest
setting ulimit -s unlimited). Bit out there, but stack-based languages would
stand to gain by this. The potential gap is for threaded apps as there will
be stacks that are not the "main" stack.  Backing those with hugepages depends
on how they are allocated (malloc, it's easy, MAP_ANONYMOUS not so much).

> > I agree that few real-world apps are likely to see gains of this
> > order.  More benchmarks, please :)
> 
> Would be nice, if just out of morbid curiosity :)
> 

Benchmarks will happen, they just take time, you know the way. The STREAM one
in the meantime is a "this works" and has an effect. I'm hoping Andrew Hastings
will have figures at hand and I cc'd him elsewhere in the thread for comment.

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
