Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbXFUS32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbXFUS32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbXFUS3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:29:20 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:33085 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbXFUS3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:29:19 -0400
Date: Thu, 21 Jun 2007 20:29:17 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-Id: <20070621202917.a2bfbfc7.dada1@cosmosbay.com>
In-Reply-To: <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
References: <20070620093612.GA1626@ff.dom.local>
	<alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
	<20070621073031.GA683@elte.hu>
	<alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
	<20070621160817.GA22897@elte.hu>
	<467AAB04.2070409@redhat.com>
	<alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007 10:31:53 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 21 Jun 2007, Chuck Ebbert wrote:
> > 
> > A while ago I showed that spinlocks were a lot more fair when doing
> > unlock with the xchg instruction on x86. Probably the arbitration is all
> > screwed up because we use a mov instruction, which while atomic is not
> > locked.
> 
> No, the cache line arbitration doesn't know anything about "locked" vs 
> "unlocked" instructions (it could, but there really is no point).
> 
> The real issue is that locked instructions on x86 are serializing, which 
> makes them extremely slow (compared to just a write), and then by being 
> slow they effectively just make the window for another core bigger.
> 

This reminds me Nick's proposal of 'queued spinlocks' 3 months ago

Maybe this should be re-considered ? (unlock is still a non atomic op, 
so we dont pay the serializing cost twice)

http://lwn.net/Articles/227506/

extract : 

Implement queued spinlocks for i386. This shouldn't increase the size of
the spinlock structure, while still able to handle 2^16 CPUs.

The queued spinlock has 2 fields, a head and a tail, which are indexes
into a FIFO of waiting CPUs. To take a spinlock, a CPU performs an
"atomic_inc_return" on the head index, and keeps the returned value as
a ticket. The CPU then spins until the tail index is equal to that
ticket.

To unlock a spinlock, the tail index is incremented (this can be non
atomic, because only the lock owner will modify tail).

Implementation inefficiencies aside, this change should have little
effect on performance for uncontended locks, but will have quite a
large cost for highly contended locks [O(N) cacheline transfers vs
O(1) per lock aquisition, where N is the number of CPUs contending].
The benefit is is that contended locks will not cause any starvation.

Just an idea. Big NUMA hardware seems to have fairness logic that
prevents starvation for the regular spinlock logic. But it might be
interesting for -rt kernel or systems with starvation issues. 
