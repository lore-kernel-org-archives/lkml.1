Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbXLHUaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbXLHUaZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbXLHUaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:30:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43515 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbXLHUaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:30:11 -0500
Date: Sat, 8 Dec 2007 21:29:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
	[2.6.24-rc4-git5: Reported regressions from 2.6.23]
Message-ID: <20071208202930.GA17934@elte.hu>
References: <200712080340.49546.rjw@sisk.pl> <20071208093039.GA28054@elte.hu> <20071208163749.GI19691@waste.org> <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org> <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org> <20071208100950.a3547868.akpm@linux-foundation.org> <alpine.LFD.0.9999.0712081034470.12046@woody.linux-foundation.org> <20071208195211.GA3727@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071208195211.GA3727@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> the SLUB concept is proudly outlined in init/Kconfig:
> 
>   config SLUB
>         bool "SLUB (Unqueued Allocator)"
>         help
>            SLUB is a slab allocator that minimizes cache line usage
>            instead of managing queues of cached objects (SLAB approach).
>            Per cpu caching is realized using slabs of objects instead
>            of queues of objects. SLUB can use memory efficiently
>            and has enhanced diagnostics.
> 
> but that's not true anymore - the two concepts are pretty much 
> equivalent, after all the "performance tuning" that went on in SLUB. 
> (read: 'frantically try to catch up with SLAB in benchmarks')

just to hammer this point home - and while Christoph Lameter isnt online 
currently to defend SLUB, this issue did come up and i guess there must 
be other MM hackers that are advocates of SLUB. (otherwise this code 
couldnt be upstream)

I find SLUB a fantastically confusing concept, and that starts at the 
name. "Unqueued" it says. Lets take a look at the actual code:

mm/slub.c:

  static void __always_inline *slab_alloc(struct kmem_cache *s,
                  gfp_t gfpflags, int node, void *addr)
  {
  ...
          local_irq_save(flags);
          c = get_cpu_slab(s, smp_processor_id());
  ...
          else {
                  object = c->freelist;
                  c->freelist = object[c->offset];
          }
          local_irq_restore(flags);

so it has a "free list", which is clearly per cpu. Hang on! Isnt that 
actually a per CPU queue? Which SLUB has not, we are told? The "U" in 
SLUB. How on earth can an allocator in 2007 claim to have no queuing
(which is in essence caching)? Am i on crack with this? Did i miss
something really obvious?

	Ingo
