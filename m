Return-Path: <linux-kernel-owner+w=401wt.eu-S932362AbZKMWuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbZKMWuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932316AbZKMWuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:50:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49264 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295AbZKMWuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:50:17 -0500
Date: Fri, 13 Nov 2009 23:50:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Russell King <rmk@arm.linux.org.uk>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: d451564 breakage
Message-ID: <20091113225015.GC29657@elte.hu>
References: <20091113151119.GA27752@flint.arm.linux.org.uk>
 <20091113115429.94e0885b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113115429.94e0885b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 13 Nov 2009 15:11:19 +0000
> Russell King <rmk@arm.linux.org.uk> wrote:
> 
> > Change:
> > 
> > highmem: Fix debug_kmap_atomic() to also handle KM_IRQ_PTE, KM_NMI, and KM_NMI_PTE
> > 
> > Appears to break ARM:
> > 
> > mm/highmem.c: In function ___debug_kmap_atomic___:
> > mm/highmem.c:436: error: ___KM_NMI___ undeclared (first use in this function)
> > mm/highmem.c:436: error: (Each undeclared identifier is reported only once
> > mm/highmem.c:436: error: for each function it appears in.)
> > mm/highmem.c:436: error: ___KM_NMI_PTE___ undeclared (first use in this function)
> > mm/highmem.c:443: error: ___KM_IRQ_PTE___ undeclared (first use in this function)
> > make[2]: *** [mm/highmem.o] Error 1
> > make[1]: *** [mm] Error 2
> > 
> > I'd prefer not to have to add these definitions just so that highmem
> > debugging can work for two reasons:
> > 
> > 1. either we allocate mappings for these which will never be used, which
> >    unnecessarily wastes precious virtual memory space.
> > 
> > 2. we define them to be some other KM_* value and hope that they never
> >    get used.  If they do get used, we'll never know by way of compiler
> >    error but could result in silent data corruption.
> > 
> > The only sane alternative I can see would be to define these as KM_TYPE_NR
> > and either ensure that kmap_atomic() always fails for out-of-bounds kmap
> > types (more preferable to catch problems but has a performance impact) or
> > we have the kmap debugging detect this as well.
> > 
> > Any preferences?
> 
> Could we do something nasty with ifdefs?
> 
> In arch header:
> #define KM_NMI KM_NMI
> 
> 
> In generic code:
> #ifdef KM_NMI
> 	<stuff which references KM_NMI>
> #endif
> 
> or similar?

Yeah, that would be the simplest - and all of this will go away with 
Peter's stacked kmaps.

	Ingo
