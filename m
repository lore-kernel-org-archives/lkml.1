Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbZKHJ6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbZKHJ6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 04:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZKHJ6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 04:58:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36952 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbZKHJ6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 04:58:12 -0500
Date: Sun, 8 Nov 2009 10:57:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Tejun Heo <tj@kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org, dwmw2@infradead.org,
       joerg.roedel@amd.com, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 07/10] bootmem: add free_bootmem_late
Message-ID: <20091108095719.GC2845@elte.hu>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1256712464-21472-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <20091028074832.GC19402@elte.hu>
 <4AE7FA12.2070905@kernel.org>
 <84144f020910280438j65bcacacq731f6076cbd8d99@mail.gmail.com>
 <4AE83541.3030306@kernel.org>
 <84144f020910290419k45a0c47fp500f5b5c390b80e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020910290419k45a0c47fp500f5b5c390b80e2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Wed, Oct 28, 2009 at 2:12 PM, Tejun Heo <tj@kernel.org> wrote:
> >> We're doing it before scheduler init now but I haven't put any effort
> >> into moving it earlier than that yet. I don't see any fundamental
> >> reason we can't do that but the practical problem is that we're going
> >> to affect architecture specific boot code which is really hard to
> >> test.
> >
> > Thanks for the explanation. ?It would be really great if we can pull
> > that off someday. ?This should be doable architecture-by-architecture,
> > right? ?You can, for example, first convert x86 and then make bootmem
> > allocator thin wrapper around the slab allocator. ?After all archs
> > have been converted, the wrappers can be dropped.
> 
> I am not sure how you we could do that.
> 
> The main challenge in initializing slab earlier is the various 
> implicit dependencies between different parts of the kernel boot code. 
> If we initialize slab earlier, we also need to initialize page 
> allocator earlier which requires page table setup, mem_init(), and so 
> on. Unfortunately architectures don't do boot-time setup in "standard" 
> places which means that for some architectures mem_init() might need 
> traps but for other architectures we can't just enable traps earlier 
> unless we do something else before that as well.
> 
> So I think we need to untagle the mess in init/main.c some more first 
> before we try to initialize slab earlier.

Page tables is the main dependency. x86 boots with a limited set of page 
tables, the real ones are set up later.

We'd need to see what bootmem allocations are done before page table 
init in practice. I think i did such tests a few years ago and i think 
it's rather limited (if it happens at all).

If that's mapped out we can just convert x86 to an 'emulated' bootmem 
allocator: buddy and slab is set up right when pagetables are set up, 
and bootmem can just use kmalloc.

If that works and is without nasty surprises then we can repeat the same 
for other architectures as well. (x86-only code could switch away from 
bootmem at that point as well)

( It's not without mm/page_alloc.c challenges: we'd need new helpers to 
  be able to bootstrap the buddy straight out of arch code, without any 
  bootmem data structures. )

The elimination of bootmem would be an awesome simplification of our 
memory bootstrap design, and universal kmalloc would be very nice for 
platform code as well.

	Ingo
