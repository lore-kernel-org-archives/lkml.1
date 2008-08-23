Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbYHWFJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbYHWFJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 01:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYHWFJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 01:09:20 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:44495 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118AbYHWFJT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 01:09:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjwFADMyr0hMRKxB/2dsb2JhbACBZbMAgWiDKw
Date: Sat, 23 Aug 2008 01:09:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] Writer-biased low-latency rwlock v8
Message-ID: <20080823050916.GA1172@Krystal>
References: <20080817075335.GA25019@Krystal> <alpine.LFD.1.10.0808170909420.3324@nehalem.linux-foundation.org> <20080817191034.GA5258@Krystal> <20080818232500.GF6732@linux.vnet.ibm.com> <20080819060417.GB24085@Krystal> <20080819073345.GA30285@Krystal> <alpine.LFD.1.10.0808190946560.3324@nehalem.linux-foundation.org> <20080821205045.GA24909@Krystal> <alpine.LFD.1.10.0808211356360.3487@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808211402370.3487@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.LFD.1.10.0808211402370.3487@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:30:14 up 79 days,  9:10,  5 users,  load average: 0.47, 0.28,
	0.27
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Thu, 21 Aug 2008, Linus Torvalds wrote:
> > 
> > That leaves 30 bits for readers. If you still think you need to "limit the 
> > number of readers", then you aren't getting it.
> 
[...]
> and I'm pretty damn sure that that should be totally sufficient for a 
> spinning rwlock. The non-spinning one is more complex just because the 
> unlock paths need to guarantee that something gets woken up, that just 
> isn't an issue when you do spinlocks.
> 
> Now, in the slow-path:
>  - on the rwlock slowpath side, set bit#1 to make sure that readers get 
>    caught in the slowpath
>  - then do a *separate* count of how many pending readers and writers 
>    (ie the ones that got caught into the slowpath) you have (one word 
>    each is probably fine), and then the slowpaths can just do the right 
>    thing depending on whether there are pending readers/writers.
> 
> See? The main lock needs not worry about number of writers AT ALL, because 
> it's totally irrelevant. So don't worry about running out of bits. You 
> won't. Just put those counts somewhere else! The only thing that matters 
> for the main lock word is whether there are active readers (30 bits), and 
> whether there is an active writer (there can only ever be one: 1 bit), and 
> whether new readers should be trapped (1 bit).
> 
> If you worry about overflows, you're doing something wrong.
> 
> 			Linus

Hi Linus,

After having had a look 15 times more at your rwlock code, and again at
your answer, in loops, I come to the conclusion that I made a terrible
job at explaining the core idea beneath my rwlock design. So let's try
to make it more obvious. I am going to keep this explanation short.

First, the goal : to kill latency induced by rwlocks.

Now, let me explain why I need at least not one, but _four different_
contention bits. Simply because there are four types of contention, one
for each execution context which may take the read lock. (irq, softirq,
non-preemptable, preemptable)

So let's suppose I share the rwlock between non-preemptable writers,
non-preemptable readers and interrupt context readers. The idea is this:
If I want to take the write lock, I'll have to protect against both
non-preemptable and interrupt readers (and also against other writers).

A way to do that without inducing high interrupt latency with current
rwlocks would be for the writer to take _two_ locks, not just one. The
first excludes preemptable readers and the second excludes irqs. So we
have :

For the writer :

preempt_disable();
write_lock(&preempt_rwlock);

local_irq_disable();
write_lock(&irq_rwlock);

/* Write access */

write_unlock(&irq_rwlock);
local_irq_enable();

write_unlock(&preempt_rwlock);
preempt_enable();

And the readers :

Interrupt :
read_lock(&irq_rwlock);
...
read_unlock(&irq_rwlock);

non-preemptable :
read_lock(&preempt_rwlock);
...
read_unlock(&preempt_rwlock);


If you still wonder why I need to take two locks, thus elevating the
context priority by exluding one context at a time, we can go to this
example showing why current rwlock use in the kernel produces such high
latencies. The current use is :

For the writer, we exclude all the readers in one go :

local_irq_disable();
write_lock(&big_lock_against_all_readers);

/* Write access */

write_unlock(&big_lock_against_all_readers);
local_irq_enable();

write_unlock(&preempt_rwlock);
preempt_enable();

And for the readers :

Interrupt :
read_lock(&big_lock_against_all_readers);
...
read_unlock(&big_lock_against_all_readers);

non-preemptable :
read_lock(&big_lock_against_all_readers);
...
read_unlock(&big_lock_against_all_readers);


And where is the problem ? In the following execution sequence :
- non-preemptable reader takes the read lock
- writer disables irqs
- writer takes the write lock, contended by the reader
  - hrm, the reader can take a while to complete, may be iterating on
    the tasklist, interrupted by irqs and softirqs...

This contention is pretty bad because interrupts are disabled while we
busy-loop. And yes, the new implementation you proposed *does* suffer
from the same problem. Now if you go in the multiple locks scenario I
explained above, you'll notice that you don't have this problem. Then
comes the question : how can we efficiently take many locks, one per
reader execution context we want to exclude.

This is where we need to have at _least_ one contention bit _per
context_. Because at a given moment, non-preemptable readers can be
contended, but not irq readers. But we also have to know when a
particular reader execution context is locked out so that the writer
knows it has exclusive access and can therefore either disable
interrupts and exclude interrupt readers or finally access the critical
section. Therefore, we need to keep one reader count _per context_,
which makes that 4 reader counts (irq, softirq, non-preemptable,
preemptable). And that's where we start being short on bits.

But my current maximums for number of readers is not a problem,
especially because I detect overflow beforehand using cmpxchg and
busy-loop in the rare event these counters would be full. And I am not
limited to NR_CPUS _at all_ anymore, as shows these constants :

#define PTHREAD_RMAX    16384
#define NPTHREAD_RMAX   2048
#define SOFTIRQ_RMAX    512
#define HARDIRQ_RMAX    256

So, before discussing optimization or implementation details further,
I'd like to know if I made myself clear enough about the design goal. If
not, then again I must be doing a terrible job at explaining it and
please let me know. I made a big patch cleanup after v8, so you might
want to wait for us to come to an understanding before going through a
next patch release.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
