Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbYL3JCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbYL3JCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 04:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYL3JB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 04:01:56 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57947 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbYL3JBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 04:01:55 -0500
Subject: Re: [PATCH] tracing/kmemtrace: normalize the raw tracer event to
	the unified tracing API
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
In-Reply-To: <20081230081600.GD2455@elte.hu>
References: <4959443f.09a1660a.44f3.2686@mx.google.com>
	 <20081229220937.GC5829@nowhere> <1230623364.6091.9.camel@penberg-laptop>
	 <20081230081600.GD2455@elte.hu>
Date: Tue, 30 Dec 2008 11:01:52 +0200
Message-Id: <1230627712.6091.54.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tue, 2008-12-30 at 09:16 +0100, Ingo Molnar wrote:
> 1)
> 
> i think the call_site based tracking should be a built-in capability - the 
> branch tracer needs that too for example. That would also make it very 
> simple on the usage place: you wouldnt have to worry about sections in 
> slub.c/etc.
> 
> 2)
> 
> i think a possibly useful intermediate object would be the slab cache 
> itself, which could be the basis for some highlevel stats too. It would 
> probably overlap /proc/slabinfo statistics but it's a natural part of this 
> abstraction i think.

Makes sense but keep in mind that this is really just an extension to
SLUB statistics and is only good for detecting allocation hotspots, not
for analyzing memory footprint.

On Tue, 2008-12-30 at 09:16 +0100, Ingo Molnar wrote:
> 3)
> 
> the most lowlevel (and hence most allocation-footprint sensitive) object 
> to track would be the memory object itself. I think the best approach 
> would be to do a static, limited size hash that could track up to N memory 
> objects.
> 
> The advantage of such an approach is that it does not impact allocation 
> patterns at all (besides the one-time allocation cost of the hash itself 
> during tracer startup).
> 
> The disadvantage is when an overflow happens: the sizing heuristics would 
> get the size correct most of the time anyway, so it's not a practical 
> issue. There would be some sort of sizing control similar to 
> /debug/tracing/buffer_size_kb, and a special trace entry that signals an 
> 'overflow' of the hash table. (in that case we wont track certain objects 
> - but it would be clear from the trace output what happens and the hash 
> size can be adjusted.)
> 
> Another advantage would be that it would trivially not interact with any 
> allocator - because the hash itself would never 'allocate' in any dynamic 
> way. Either there are free entries available (in which case we use it), or 
> not - in which case we emit an hash-overflow trace entry.
> 
> And this too would be driven from ftrace mainly - the SLAB code would only 
> offer the alloc+free callbacks with the object IDs. [ and this means that 
> we could detect memory leaks by looking at the hash table and print out 
> the age of entries :-) ]
> 
> How does this sound to you?

That will probably be okay for things like analyzing memory footprint
immediately after boot. However, as soon as the amount of active memory
objects increases (think dentry and inode cache), the numbers might get
skewed. One option would be to let the user exclude some of the caches
from tracing.

		Pekka

