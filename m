Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYKIObw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYKIObw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 09:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYKIObl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 09:31:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46113 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbYKIObk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 09:31:40 -0500
Date: Sun, 9 Nov 2008 09:31:37 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: David Howells <dhowells@redhat.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Nicolas Pitre <nico@cam.org>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
In-Reply-To: <1219.1226231496@redhat.com>
Message-ID: <alpine.DEB.1.10.0811090919370.29560@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0811071922010.26139@gandalf.stny.rr.com> <alpine.DEB.1.10.0811071229570.28548@gandalf.stny.rr.com> <20081107053349.861709786@polymtl.ca> <20081107052336.652868737@polymtl.ca> <25257.1226055312@redhat.com> <20081107170902.GD22134@Krystal>
 <9473.1226101838@redhat.com> <1219.1226231496@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 9 Nov 2008, David Howells wrote:

> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > Note that that does not guarantee that the two reads will be done in the
> > > order you want.  The compiler barrier _only_ affects the compiler.  It
> > > does not stop the CPU from doing the reads in any order it wants.  You
> > > need something stronger than smp_rmb() if you need the reads to be so
> > > ordered.
> > 
> > For reading hardware devices that can indeed be correct. But for normal 
> > memory access on a uniprocessor, if the CPU were to reorder the reads that 
> > would effect the actual algorithm then that CPU is broken.

Please read what I said above again.

"For reading hardware devices that can indeed be correct."

There I agree that accessing devices will require a rmb.

"But for normal memory access on a uniprocessor, if the CPU were to 
reorder the reads that would effect the actual algorithm then that CPU is 
broken."

Here I'm talking about accessing normal RAM. If the CPU decides to read b 
before reading a then that will break the code.

> > 
> >  read a
> >     <---  interrupt  - should see read a here before read b is done.
> >  read b
> 
> Life isn't that simple.  Go and read the section labelled "The things cpus get
> up to" in Documentation/memory-barriers.txt.

I've read it. Several times ;-)

> 
> The two reads we're talking about are independent of each other.  Independent
> reads and writes can be reordered and merged at will by the CPU, subject to
> restrictions imposed by barriers, cacheability attributes, MMIO attributes and
> suchlike.
> 
> You can get read b happening before read a, but in such a case both
> instructions will be in the CPU's execution pipeline.  When an interrupt
> occurs, the CPU will presumably finish clearing what's in its pipeline before
> going and servicing the interrupt handler.

This above sounds like you just answered my question, and a smp_rmb is
enough.  If an interrupt occurs, then the read a and read b will be 
completed. Really does not matter in which order, as long as the interrupt 
itself does not see the read b before the read a.


> 
> If a CPU is strictly ordered with respect to reads, do you actually need read
> barriers?
> 
> The fact that a pair of reads might be part of an algorithm that is critically
> dependent on the ordering of those reads isn't something the CPU cares about.
> It doesn't know there's an algorithm there.
> 
> > Now the fact that one of the reads is a hardware clock, then this 
> > statement might not be too strong. But the fact that it is a clock, and 
> > not some memory mapped device register, I still think smp_rmb is 
> > sufficient.
> 
> To quote again from memory-barriers.txt, section "CPU memory barriers":
> 
> 	Mandatory barriers should not be used to control SMP effects, since
> 	mandatory barriers unnecessarily impose overhead on UP systems. They
> 	may, however, be used to control MMIO effects on accesses through
> 	relaxed memory I/O windows.  These are required even on non-SMP
> 	systems as they affect the order in which memory operations appear to
> 	a device by prohibiting both the compiler and the CPU from reordering
> 	them.
> 
> Section "Accessing devices":
> 
>  (2) If the accessor functions are used to refer to an I/O memory window with
>      relaxed memory access properties, then _mandatory_ memory barriers are
>      required to enforce ordering.

My confidence on reading a clock is not as strong that a smp_rmb is 
enough. And it may not be. I'll have to think about this a bit more. 
Again, the question arrises with:

  read a (memory)
       <---- interrupt
  read b (clock)

Will the b be seen before the interrupt occurred, and before the a is 
read?  That is what will break the algorithm on UP. If we can not 
guarantee this statement, then a rmb is needed.

-- Steve

