Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYGaLwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYGaLwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 07:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYGaLwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 07:52:11 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:26108 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750835AbYGaLwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 07:52:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=yKqCOAvX+6uSgkCFZArT4tXCsH5JTm+WAfrwPJ8A4DbZXOOlCNlIlYNAwUoiU+ie/kFraIHgFVkFAK3OFJ/WvOhO/PdLlRnROHHJ2MKDOWhlIxI01XmfyO4Qk7amVQetIljgutuVRvXRZvpMuGAe7jyzzmd4EW79UPEhOgfdk7A=  ;
X-YMail-OSG: hs2oop0VM1kNqSQsJSTKJMDzKk.e27d0ZIGO6doEu7i_JBpN0BrE7ZkhsIkhPSeF2L_3DP9DWuF1SirN84XaVteE3ICUPCTsHDnJV4DEgE7Ud7Z_lhHgV0CleiZ.zddZ9DE-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
Date: Thu, 31 Jul 2008 21:51:56 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Munson <ebmunson@us.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       libhugetlbfs-devel@lists.sourceforge.net
References: <cover.1216928613.git.ebmunson@us.ibm.com> <200807311626.15709.nickpiggin@yahoo.com.au> <20080731112734.GE1704@csn.ul.ie>
In-Reply-To: <20080731112734.GE1704@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807312151.56847.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2008 21:27, Mel Gorman wrote:
> On (31/07/08 16:26), Nick Piggin didst pronounce:

> > I imagine it should be, unless you're using a CPU with seperate TLBs for
> > small and huge pages, and your large data set is mapped with huge pages,
> > in which case you might now introduce *new* TLB contention between the
> > stack and the dataset :)
>
> Yes, this can happen particularly on older CPUs. For example, on my
> crash-test laptop the Pentium III there reports
>
> TLB and cache info:
> 01: Instruction TLB: 4KB pages, 4-way set assoc, 32 entries
> 02: Instruction TLB: 4MB pages, 4-way set assoc, 2 entries

Oh? Newer CPUs tend to have unified TLBs?


> > Also, interestingly I have actually seen some CPUs whos memory operations
> > get significantly slower when operating on large pages than small (in the
> > case when there is full TLB coverage for both sizes). This would make
> > sense if the CPU only implements a fast L1 TLB for small pages.
>
> It's also possible there is a micro-TLB involved that only support small
> pages.

That is the case on a couple of contemporary CPUs I've tested with
(although granted they are engineering samples, but I don't expect
that to be the cause)


> > So for the vast majority of workloads, where stacks are relatively small
> > (or slowly changing), and relatively hot, I suspect this could easily
> > have no benefit at best and slowdowns at worst.
>
> I wouldn't expect an application with small stacks to request its stack
> to be backed by hugepages either. Ideally, it would be enabled because a
> large enough number of DTLB misses were found to be in the stack
> although catching this sort of data is tricky.

Sure, as I said, I have nothing against this functionality just because
it has the possibility to cause a regression. I was just pointing out
there are a few possibilities there, so it will take a particular type
of app to take advantage of it. Ie. it is not something you would ever
just enable "just in case the stack starts thrashing the TLB".


> > But I'm not saying that as a reason not to merge it -- this is no
> > different from any other hugepage allocations and as usual they have to
> > be used selectively where they help.... I just wonder exactly where huge
> > stacks will help.
>
> Benchmark wise, SPECcpu and SPEComp have stack-dependent benchmarks.
> Computations that partition problems with recursion I would expect to
> benefit as well as some JVMs that heavily use the stack (see how many docs
> suggest setting ulimit -s unlimited). Bit out there, but stack-based
> languages would stand to gain by this. The potential gap is for threaded
> apps as there will be stacks that are not the "main" stack.  Backing those
> with hugepages depends on how they are allocated (malloc, it's easy,
> MAP_ANONYMOUS not so much).

Oh good, then there should be lots of possibilities to demonstrate it.

Thanks,
Nick
