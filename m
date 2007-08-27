Return-Path: <linux-kernel-owner+w=401wt.eu-S1762943AbXH0Uj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762943AbXH0Uj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758835AbXH0UjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:39:17 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:46121 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758854AbXH0UjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:39:16 -0400
Date: Mon, 27 Aug 2007 16:39:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070827203913.GA7416@Krystal>
References: <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com> <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com> <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211612580.6062@schroedinger.engr.sgi.com> <1188197539.6114.426.camel@twins> <Pine.LNX.4.64.0708271237580.5056@schroedinger.engr.sgi.com> <20070827202203.GB5653@Krystal> <Pine.LNX.4.64.0708271324001.5884@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708271324001.5884@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:32:49 up 28 days, 20:51,  5 users,  load average: 0.56, 0.25, 0.26
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Mon, 27 Aug 2007, Mathieu Desnoyers wrote:
> 
> > * Christoph Lameter (clameter@sgi.com) wrote:
> > > On Mon, 27 Aug 2007, Peter Zijlstra wrote:
> > > 
> > > > So, if the fast path can be done with a preempt off, it might be doable
> > > > to suffer the slow path with a per cpu lock like that.
> > > 
> > > Sadly the cmpxchg_local requires local per cpu data access. Isnt there 
> > > some way to make this less expensive on RT? Acessing cpu local memory is 
> > > really good for performance on NUMA since the data is optimally placed and 
> > > one can avoid/reduce locking if the process stays tied to the processor.
> > > 
> > 
> > On the slow path, in slab_new, we already have to reenable interrupts
> > because we can sleep. If we make sure that whenever we return to an irq
> > disable code path we take the current per-cpu data structure again, can
> > we make the preempt-disable/irq-disabled code paths O(1) ?
> 
> Not sure exactly what you are getting at?
> This would mean running __alloc_pages tied to one processor even though 
> waiting is possible?
> 

Not exactly. What I propose is:

- Running slab_alloc and slab_free fast paths in preempt_disable
  context, using cmpxchg_local.
- Running slab_alloc and slab_free slow paths with irqs disabled.
- Running __alloc_pages in preemptible context, not tied to any CPU.

In this scheme, calling __alloc_pages from slab_alloc would reenable
interrupts and potentially migrate us to a different CPU. We would
therefore have to get once again our per-cpu data structure once we get
back into irq disabled code, because we may be running on a different
CPU. This is actually what the __slab_alloc slow path does:


new_slab:
        new = get_partial(s, gfpflags, node);
        if (new) {
                c->page = new;
                goto load_freelist;
        }

        new = new_slab(s, gfpflags, node);

          ----> within new_slab, we can reenable interrupts for the
                __slab_alloc call.

        if (new) {
                c = get_cpu_slab(s, smp_processor_id());
                if (c->page) {
                        /*
                         * Someone else populated the cpu_slab while we
                         * enabled interrupts, or we have gotten scheduled
                         * on another cpu. The page may not be on the
                         * requested node even if __GFP_THISNODE was
                         * specified. So we need to recheck.
                         */
                        if (node_match(c, node)) {
                                /*
                                 * Current cpuslab is acceptable and we
                                 * want the current one since its cache hot
                                 */
                                discard_slab(s, new);
                                slab_lock(c->page);
                                goto load_freelist;
                        }
                        /* New slab does not fit our expectations */
                        flush_slab(s, c);
                }
                slab_lock(new);
                SetSlabFrozen(new);
                c->page = new;
                goto load_freelist;

So the idea would be to split the code in O(1)
preempt_disable/irq_disable sections and to enable interrupt and check
for current per-cpu data structure when re-entering in irq disabled
code.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
