Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbZFSPVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbZFSPVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 11:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbZFSPU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 11:20:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56289 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbZFSPU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 11:20:57 -0400
Date: Fri, 19 Jun 2009 17:20:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mingo@redhat.com,
       hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090619152029.GA7204@elte.hu>
References: <20090615180527.GB4201@Krystal> <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain> <20090615183649.GA16999@elte.hu> <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain> <20090615194344.GA12554@elte.hu> <20090615200619.GA10632@Krystal> <20090615204715.GA24554@elte.hu> <20090615210225.GA12919@Krystal> <20090615211209.GA27100@elte.hu> <alpine.LFD.2.01.0906151617030.6276@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906151617030.6276@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 15 Jun 2009, Ingo Molnar wrote:
> > 
> > See the numbers in the other mail: about 33 million pagefaults 
> > happen in a typical kernel build - that's ~400K/sec - and that 
> > is not a particularly really pagefault-heavy workload.
> 
> Did you do any function-level profiles?
> 
> Last I looked at it, the real cost of page faults were all in the 
> memory copies and page clearing, and while it would be nice to 
> speed up the kernel entry and exit, the few tens of cycles we 
> might be able to get from there really aren't all that important.

Yeah.

Here's the function level profiles of a typical kernel build on a 
Nehalem box:

 $ perf report --sort symbol

 #
 # (14317328 samples)
 #
 # Overhead  Symbol
 # ........  ......
 #
    44.05%  0x000000001a0b80
     5.09%  0x0000000001d298
     3.56%  0x0000000005742c
     2.48%  0x0000000014026d
     2.31%  0x00000000007b1a
     2.06%  0x00000000115ac9
     1.83%  [.] _int_malloc
     1.71%  0x00000000064680
     1.50%  [.] memset
     1.37%  0x00000000125d88
     1.28%  0x000000000b7642
     1.17%  [k] clear_page_c
     0.87%  [k] page_fault
     0.78%  [.] is_defined_config
     0.71%  [.] _int_free
     0.68%  [.] __GI_strlen
     0.66%  0x000000000699e8
     0.54%  [.] __GI_memcpy

Most is dominated by user-space symbols. (no proper ELF+debuginfo on 
this box so they are unnamed.) It also sows that page clearing and 
pagefault handling dominates the kernel overhead - but is dwarved by 
other overhead. Any page-fault-entry costs are a drop in the bucket.

In fact with call-chain graphs we can get a precise picture, as we 
can do a non-linear 'slice' set operation over the samples and 
filter out the ones that have the 'page_fault' pattern in one of 
their parent functions:

 $ perf report --sort symbol --parent page_fault

 #
 # (14317328 samples)
 #
 # Overhead  Symbol
 # ........  ......
 #
     1.12%  [k] clear_page_c
     0.87%  [k] page_fault
     0.43%  [k] get_page_from_freelist
     0.25%  [k] _spin_lock
     0.24%  [k] do_page_fault
     0.23%  [k] perf_swcounter_ctx_event
     0.16%  [k] perf_swcounter_event
     0.15%  [k] handle_mm_fault
     0.15%  [k] __alloc_pages_nodemask
     0.14%  [k] __rmqueue
     0.12%  [k] find_get_page
     0.11%  [k] copy_page_c
     0.11%  [k] find_vma
     0.10%  [k] _spin_lock_irqsave
     0.10%  [k] __wake_up_bit
     0.09%  [k] _spin_unlock_irqrestore
     0.09%  [k] do_anonymous_page
     0.09%  [k] __inc_zone_state

This "sub-profile" shows the true summary overhead that 'page_fault' 
and all its child functions have. Note that for example clear_page_c 
decreased from 1.17% to 1.12%:

     1.12%  [k] clear_page_c
     1.17%  [k] clear_page_c

because there's 0.05% of other callers to clear_page_c() that do not 
involve page_fault. Those are filtered out via --parent 
filtering/matching.

	Ingo
