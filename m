Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbYKILxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbYKILxG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 06:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYKILwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 06:52:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60511 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbYKILwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 06:52:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0811071922010.26139@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0811071922010.26139@gandalf.stny.rr.com> <alpine.DEB.1.10.0811071229570.28548@gandalf.stny.rr.com> <20081107053349.861709786@polymtl.ca> <20081107052336.652868737@polymtl.ca> <25257.1226055312@redhat.com> <20081107170902.GD22134@Krystal> <9473.1226101838@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: dhowells@redhat.com, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Nicolas Pitre <nico@cam.org>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Date: Sun, 09 Nov 2008 11:51:36 +0000
Message-ID: <1219.1226231496@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> wrote:

> > Note that that does not guarantee that the two reads will be done in the
> > order you want.  The compiler barrier _only_ affects the compiler.  It
> > does not stop the CPU from doing the reads in any order it wants.  You
> > need something stronger than smp_rmb() if you need the reads to be so
> > ordered.
> 
> For reading hardware devices that can indeed be correct. But for normal 
> memory access on a uniprocessor, if the CPU were to reorder the reads that 
> would effect the actual algorithm then that CPU is broken.
> 
>  read a
>     <---  interrupt  - should see read a here before read b is done.
>  read b

Life isn't that simple.  Go and read the section labelled "The things cpus get
up to" in Documentation/memory-barriers.txt.

The two reads we're talking about are independent of each other.  Independent
reads and writes can be reordered and merged at will by the CPU, subject to
restrictions imposed by barriers, cacheability attributes, MMIO attributes and
suchlike.

You can get read b happening before read a, but in such a case both
instructions will be in the CPU's execution pipeline.  When an interrupt
occurs, the CPU will presumably finish clearing what's in its pipeline before
going and servicing the interrupt handler.

If a CPU is strictly ordered with respect to reads, do you actually need read
barriers?

The fact that a pair of reads might be part of an algorithm that is critically
dependent on the ordering of those reads isn't something the CPU cares about.
It doesn't know there's an algorithm there.

> Now the fact that one of the reads is a hardware clock, then this 
> statement might not be too strong. But the fact that it is a clock, and 
> not some memory mapped device register, I still think smp_rmb is 
> sufficient.

To quote again from memory-barriers.txt, section "CPU memory barriers":

	Mandatory barriers should not be used to control SMP effects, since
	mandatory barriers unnecessarily impose overhead on UP systems. They
	may, however, be used to control MMIO effects on accesses through
	relaxed memory I/O windows.  These are required even on non-SMP
	systems as they affect the order in which memory operations appear to
	a device by prohibiting both the compiler and the CPU from reordering
	them.

Section "Accessing devices":

 (2) If the accessor functions are used to refer to an I/O memory window with
     relaxed memory access properties, then _mandatory_ memory barriers are
     required to enforce ordering.

David
