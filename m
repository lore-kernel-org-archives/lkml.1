Return-Path: <linux-kernel-owner+w=401wt.eu-S1760335AbYGBFpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335AbYGBFpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 01:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYGBFow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 01:44:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:51140 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbYGBFov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 01:44:51 -0400
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jeremy Kerr <jk@ozlabs.org>
In-Reply-To: <486B0298.5030508@linux.intel.com>
References: <1214916335.20711.141.camel@pasglop>
	 <486B0298.5030508@linux.intel.com>
Content-Type: text/plain
Date: Wed, 02 Jul 2008 15:44:07 +1000
Message-Id: <1214977447.21182.33.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> how much of this would be obsoleted if we had irqthreads ?

I'm not sure irqthreads is what I want...

First, can they call handle_mm_fault ? (ie, I'm not sure precisely what
kind of context those operate into).

But even if that's ok, it doesn't quite satisfy my primary needs unless
we can fire off an irqthread per interrupt -occurence- rather than
having an irqthread per source.

There is two aspects to the problem. The less important is that I need
to be able to service other interrupts from that source
after firing off the "job".

For example, the GFX chip or the SPU in my case takes a page fault when
accessing the user mm context it's attached to, I fire off a thread to
handle it (which I attach/detach from the mm, catch signals, etc...),
but that doesn't stop execution. Transfers to/from main memory on the
SPU (and to some extend on graphic chips) are asynchronous and thus the
SPU can still run and emit other interrupts representing different
conditions (though not other page faults).

The second aspect which is more important in the SPU case is that they
context switch. While an SPU context causes a page fault, and I fire off
that thread to service it, I want to be able to context switch some
other context on the SPU which will itself emit interrupts etc... on
that same source.

I could get away by simply allocating a kernel thread per SPU context,
and that's what we're going to do in our proof-of-concept
implementation, but I was hoping to avoid it with the thread pools in
the long run, thus saving a few resources left and right and loading the
main scheduler lists less with huge amount of mostly idle threads.

Now regarding the other usage scenario mentioned here (XPC and the NFS
server) that already have thread pools, how much of these would be also
replaced by irqthreads ? I don't think much off hand but I can't say for
sure until I have a look ... Again, that may be me just not
understanding what irqthreads are but it looks to me that they are one
thread per IRQ source or so, not the ability for a single IRQ source to
fire off multiple threads. Maybe if irqthreads could fork() that would
be an option... 

In any case, Dave messages imply we have at least two existing in tree
thread pool implementations for two users and possibly spufs being a 3rd
one (I'm keeping graphics at bay for now as I see that being a more long
term scenario). Probably worth looking at some consolidation.

Anyway, time for me to go look at the XPC and NFS code and see if there
is anything worth putting in common in there. Might take me a little
while, there is nothing urgent (which is why I was thinking about a KS
chat but the list is fine too), we are doing a proof-of-concept
implementation using per-context threads in the meantime anyway.

Cheers,
Ben.


