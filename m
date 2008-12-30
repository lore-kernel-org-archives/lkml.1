Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbYL3JMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbYL3JMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 04:12:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYL3JLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 04:11:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53922 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbYL3JLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 04:11:30 -0500
Date: Tue, 30 Dec 2008 10:11:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH] tracing/kmemtrace: normalize the raw tracer event to
	the unified tracing API
Message-ID: <20081230091106.GA25535@elte.hu>
References: <4959443f.09a1660a.44f3.2686@mx.google.com> <20081229220937.GC5829@nowhere> <1230623364.6091.9.camel@penberg-laptop> <20081230081600.GD2455@elte.hu> <1230627712.6091.54.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230627712.6091.54.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Ingo,
> 
> On Tue, 2008-12-30 at 09:16 +0100, Ingo Molnar wrote:
> > 1)
> > 
> > i think the call_site based tracking should be a built-in capability - the 
> > branch tracer needs that too for example. That would also make it very 
> > simple on the usage place: you wouldnt have to worry about sections in 
> > slub.c/etc.
> > 
> > 2)
> > 
> > i think a possibly useful intermediate object would be the slab cache 
> > itself, which could be the basis for some highlevel stats too. It would 
> > probably overlap /proc/slabinfo statistics but it's a natural part of this 
> > abstraction i think.
> 
> Makes sense but keep in mind that this is really just an extension to
> SLUB statistics and is only good for detecting allocation hotspots, not
> for analyzing memory footprint.
> 
> On Tue, 2008-12-30 at 09:16 +0100, Ingo Molnar wrote:
> > 3)
> > 
> > the most lowlevel (and hence most allocation-footprint sensitive) object 
> > to track would be the memory object itself. I think the best approach 
> > would be to do a static, limited size hash that could track up to N memory 
> > objects.
> > 
> > The advantage of such an approach is that it does not impact allocation 
> > patterns at all (besides the one-time allocation cost of the hash itself 
> > during tracer startup).
> > 
> > The disadvantage is when an overflow happens: the sizing heuristics would 
> > get the size correct most of the time anyway, so it's not a practical 
> > issue. There would be some sort of sizing control similar to 
> > /debug/tracing/buffer_size_kb, and a special trace entry that signals an 
> > 'overflow' of the hash table. (in that case we wont track certain objects 
> > - but it would be clear from the trace output what happens and the hash 
> > size can be adjusted.)
> > 
> > Another advantage would be that it would trivially not interact with any 
> > allocator - because the hash itself would never 'allocate' in any dynamic 
> > way. Either there are free entries available (in which case we use it), or 
> > not - in which case we emit an hash-overflow trace entry.
> > 
> > And this too would be driven from ftrace mainly - the SLAB code would only 
> > offer the alloc+free callbacks with the object IDs. [ and this means that 
> > we could detect memory leaks by looking at the hash table and print out 
> > the age of entries :-) ]
> > 
> > How does this sound to you?
> 
> That will probably be okay for things like analyzing memory footprint 
> immediately after boot. However, as soon as the amount of active memory 
> objects increases (think dentry and inode cache), the numbers might get 
> skewed. One option would be to let the user exclude some of the caches 
> from tracing.

well, it gets skewed only in terms of total footprint: the same way as if 
you had total_ram-hash_size amount of RAM. Since there are so many RAM 
sizes possible, this can be considered as if the test was done on a 
slighly smaller machine - but otherwise it's an invariant. It wont impact 
the micro-layout of the slab objects themselves (does not change their 
size), and it shouldnt impact most workloads which behave very gradually 
to small changes in total memory size.

	Ingo
