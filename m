Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246AbXDWUE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbXDWUE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 16:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbXDWUEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 16:04:25 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707AbXDWUEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 16:04:16 -0400
Date: Mon, 23 Apr 2007 12:52:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
In-Reply-To: <20070423191143.GA16849@elte.hu>
Message-ID: <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org>
References: <20070420140457.GA14017@elte.hu> <200704220155.20856.kernel@kolivas.org>
 <20070421160008.GA28783@elte.hu> <200704220959.34978.kernel@kolivas.org>
 <87647oblx5.fsf@pps.jussieu.fr> <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org>
 <20070423013429.GB25162@wotan.suse.de> <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org>
 <20070423191143.GA16849@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Apr 2007, Ingo Molnar wrote:
> 
> The "give scheduler money" transaction can be both an "implicit 
> transaction" (for example when writing to UNIX domain sockets or 
> blocking on a pipe, etc.), or it could be an "explicit transaction": 
> sched_yield_to(). This latter i've already implemented for CFS, but it's 
> much less useful than the really significant implicit ones, the ones 
> which will help X.

Yes. It would be wonderful to get it working automatically, so please say 
something about the implementation..

The "perfect" situation would be that when somebody goes to sleep, any 
extra points it had could be given to whoever it woke up last. Note that 
for something like X, it means that the points are 100% ephemeral: it gets 
points when a client sends it a request, but it would *lose* the points 
again when it sends the reply!

So it would only accumulate "scheduling points" while multiuple clients 
are actively waiting for it, which actually sounds like exactly the right 
thing. However, I don't really see how to do it well, especially since the 
kernel cannot actually match up the client that gave some scheduling 
points to the reply that X sends back.

There are subtle semantics with these kinds of things: especially if the 
scheduling points are only awarded when a process goes to sleep, if X is 
busy and continues to use the CPU (for another client), it wouldn't give 
any scheduling points back to clients and they really do accumulate with 
the server. Which again sounds like it would be exactly the right thing 
(both in the sense that the server that runs more gets more points, but 
also in the sense that we *only* give points at actual scheduling events).

But how do you actually *give/track* points? A simple "last woken up by 
this process" thing that triggers when it goes to sleep? It might work, 
but on the other hand, especially with more complex things (and networking 
tends to be pretty complex) the actual wakeup may be done by a software 
irq. Do we just say "it ran within the context of X, so we assume X was 
the one that caused it?" It probably would work, but we've generally tried 
very hard to avoid accessing "current" from interrupt context, including 
bh's..

			Linus
