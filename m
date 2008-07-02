Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbYGBOLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbYGBOLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 10:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbYGBOLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 10:11:44 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56273 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304AbYGBOLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:11:42 -0400
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: benh@kernel.crashing.org
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jeremy Kerr <jk@ozlabs.org>
In-Reply-To: <1214977447.21182.33.camel@pasglop>
References: <1214916335.20711.141.camel@pasglop>
	 <486B0298.5030508@linux.intel.com>  <1214977447.21182.33.camel@pasglop>
Content-Type: text/plain
Date: Wed, 02 Jul 2008 09:11:36 -0500
Message-Id: <1215007896.3330.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-02 at 15:44 +1000, Benjamin Herrenschmidt wrote:
> > how much of this would be obsoleted if we had irqthreads ?
> 
> I'm not sure irqthreads is what I want...
> 
> First, can they call handle_mm_fault ? (ie, I'm not sure precisely what
> kind of context those operate into).
> 
> But even if that's ok, it doesn't quite satisfy my primary needs unless
> we can fire off an irqthread per interrupt -occurence- rather than
> having an irqthread per source.
> 
> There is two aspects to the problem. The less important is that I need
> to be able to service other interrupts from that source
> after firing off the "job".
> 
> For example, the GFX chip or the SPU in my case takes a page fault when
> accessing the user mm context it's attached to, I fire off a thread to
> handle it (which I attach/detach from the mm, catch signals, etc...),
> but that doesn't stop execution. Transfers to/from main memory on the
> SPU (and to some extend on graphic chips) are asynchronous and thus the
> SPU can still run and emit other interrupts representing different
> conditions (though not other page faults).
> 
> The second aspect which is more important in the SPU case is that they
> context switch. While an SPU context causes a page fault, and I fire off
> that thread to service it, I want to be able to context switch some
> other context on the SPU which will itself emit interrupts etc... on
> that same source.
> 
> I could get away by simply allocating a kernel thread per SPU context,
> and that's what we're going to do in our proof-of-concept
> implementation, but I was hoping to avoid it with the thread pools in
> the long run, thus saving a few resources left and right and loading the
> main scheduler lists less with huge amount of mostly idle threads.
> 
> Now regarding the other usage scenario mentioned here (XPC and the NFS
> server) that already have thread pools, how much of these would be also
> replaced by irqthreads ? I don't think much off hand but I can't say for
> sure until I have a look ... Again, that may be me just not
> understanding what irqthreads are but it looks to me that they are one
> thread per IRQ source or so, not the ability for a single IRQ source to
> fire off multiple threads. Maybe if irqthreads could fork() that would
> be an option... 
> 
> In any case, Dave messages imply we have at least two existing in tree
> thread pool implementations for two users and possibly spufs being a 3rd
> one (I'm keeping graphics at bay for now as I see that being a more long
> term scenario). Probably worth looking at some consolidation.
> 
> Anyway, time for me to go look at the XPC and NFS code and see if there
> is anything worth putting in common in there. Might take me a little
> while, there is nothing urgent (which is why I was thinking about a KS
> chat but the list is fine too), we are doing a proof-of-concept
> implementation using per-context threads in the meantime anyway.

If you really need the full scheduling capabilities of threads, then it
sounds like a threadpool is all you need (and we should just provide a
unified interface).

Initially you were implying you'd prefer some type of non blockable
workqueue (i.e. a workqueue that shifts to the next work item when and
earlier item blocks).   I can see this construct being useful because it
would have easier to use semantics and be more lightweight than a full
thread spawn.  It strikes me we could use some of the syslets work to do
this ... all the queue needs is an "next activation head", which will be
the next job in the queue in the absence of blocking.  When a job
blocks, syslets informs the workqueue and it moves on to the work on the
"next activation head".  If a prior job unblocks, syslets informs the
queue and it moves the "next activation head" to the unblocked job.
What this is doing is implementing a really simple scheduler within a
single workqueue, which I'm unsure is actually a good idea since
schedulers are complex and tricky things, but it is probably worthy of
discussion.

James


