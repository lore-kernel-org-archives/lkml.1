Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbYDPBDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbYDPBDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 21:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYDPBDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 21:03:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41214 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbYDPBDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 21:03:24 -0400
Date: Wed, 16 Apr 2008 03:02:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch] mm: sparsemem memory_present() memory corruption fix
Message-ID: <20080416010252.GA27499@elte.hu>
References: <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com> <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi> <20080415204025.GA29784@elte.hu> <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org> <20080416000356.GA24737@elte.hu> <20080416001816.GA26295@elte.hu> <86802c440804151732j519a541t9d8e4f6b49a53313@mail.gmail.com> <20080416004430.GA26928@elte.hu> <86802c440804151756w45b80052sef5c57a448d00ff1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440804151756w45b80052sef5c57a448d00ff1@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Tue, Apr 15, 2008 at 5:44 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> >  > >  +       unsigned long max_arch_pfn = 1ULL << (MAX_PHYSMEM_BITS-PAGE_SHIFT);
> >  > >
> >  > >  and also check my analysis whether it is correct and whether it
> >  > >  matches the reported bug patterns. But otherwise the fix looks like
> >  > >  a safe fix for v2.6.25-final to me - it only filters out values
> >  > >  from sparsemem input that are nonsensical in the sparsemem
> >  > >  framework anyway.
> >  >
> >
> > > can you check why find_max_pfn() e820_32.c need to call
> >  > memory_present? wonder if it can be removed.
> >
> >  this is the only call to memory_present() we do in 32-bit arch setup, so
> >  it's required.
> >
> >  (the function find_max_pfn() is woefully misnamed, but that's a cleanup
> >  - i just fixed this in x86.git.)
> 
> 64 bit is calling that via paging_init
> ==>sparse_memory_present_with_active_regions(MAX_NUMNODES).
> 
> and
> void __init sparse_memory_present_with_active_regions(int nid)

yeah - 64-bit is different here and it's not affected by the problem 
because there SECTION_SIZE_BITS is 27 (==128 MB chunks), 
MAX_PHYSADDR_BITS is 40 (== 1 TB) - giving 8192 section map entries. 
Once larger than 1 TB 64-bit x86 systems are created MAX_PHYSADDR_BITS 
needs to be increased.

The only downside of the current setup on 64-bit is that it wastes 128K 
of RAM on the majority of systems. We could perhaps try a shift of 28, 
which halves the footprint to 64K of RAM, and which still is good enough 
to allow the PCI aperture to remain a hole on most systems. It would 
also compress the data-cache footprint of the sparse memory maps. 
(without having to use sparsemem-extreme indirection)

	Ingo
