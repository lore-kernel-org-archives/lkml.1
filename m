Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbZFKL1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbZFKL1D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbZFKL0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:26:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47046 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbZFKL0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:26:53 -0400
Date: Thu, 11 Jun 2009 13:26:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -tip] perf_counter/x86: Correct some event and umask
	values for Intel processors
Message-ID: <20090611112631.GA10331@elte.hu>
References: <20090609131553.GA12489@ywang-moblin2.bj.intel.com> <20090609141621.GA32703@elte.hu> <20090610053623.GC30923@ywang-moblin2.bj.intel.com> <20090610104242.GB27724@elte.hu> <20090611082710.GA29784@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611082710.GA29784@ywang-moblin2.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yong Wang <yong.y.wang@linux.intel.com> wrote:

> > > Btw, one thing I don't quite understand is why you aliased 
> > > dtlb-write-ops to l1d-write-ops when setting event and umask 
> > > values. Are they the same event?
> > 
> > No, they are indeed different events - that's a bug in the table, 
> > good spotting. Mind sending a (tested) patch for it?
> > 
> 
> I'm a little confused. By dtlb-write-ops, do you want to count the 
> number of times that DTLB is accessed due to store operations or 
> the number of times that DTLB entries are written to, i.e. 
> updated?

ah - i think what makes most sense is the (micro-)instruction 
direction: i.e. TLB entry accessed due to store operations.

Also, are TLB entries updated typically after they get established? 
Things like the dirty or accessed bit in the PTE are written out to 
caches immediately, so that bit probably does not linger in the PTE.

> Btw, do you know whether virtual cache is employed or not on 
> atom/core2/nehalem so that tlb won't be accessed when accessing l1 
> caches?

Hm, last i checked the L2 was all physically indexed. The short 
experiment with (partial?) virtual indexing in P4 was a ... 
spectacular failure IMO.

This doesnt mean the counters wont under-count. The TLB hotpath is 
probably one of the most important critical paths in a CPU, so it's 
fair for a CPU not to count those accesses in the PMU, to squeeze 
out a few more gates. (I havent validated the TLB counters on 
core2/nehalem to that level yet so i dont know for sure how this is 
laid out in practice.)

	Ingo
