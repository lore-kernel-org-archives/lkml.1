Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbYEaW02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbYEaW02 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 18:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYEaW0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 18:26:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753790AbYEaW0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 18:26:19 -0400
Date: Sat, 31 May 2008 15:25:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
In-Reply-To: <4840D63F.2090407@redhat.com>
Message-ID: <alpine.LFD.1.10.0805311438080.3141@woody.linux-foundation.org>
References: <200805310127.m4V1RLR4013808@devserv.devel.redhat.com> <alpine.LFD.1.10.0805301846530.3141@woody.linux-foundation.org> <4840C29B.6030507@redhat.com> <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org> <4840CE51.9060109@redhat.com>
 <alpine.LFD.1.10.0805302109370.3141@woody.linux-foundation.org> <alpine.LFD.1.10.0805302116440.3141@woody.linux-foundation.org> <4840D63F.2090407@redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 May 2008, Ulrich Drepper wrote:
> 
> Once again not without limitations which are too low.  The main problem
> is that there is far more information needed on the reader side.  There
> are two counters and a number of bits for state information.  Which
> means the counters can be at most 14 bits in size.

Ok, so I obviously think you're simply wrong, and I've told you so both in 
private after seeing the 64-bit code you propose (and which you want to 
patent), and publicly.

So let's have code talk. I'm going to give real code for the only case 
that really matters, namely the uncontended case.

Do you agree that once you get contention, and you actually have to do a 
FUTEX system call to sort it out, the number of atomic instructions do not 
really matter? Because the system call is going to dominate. Agreed?

So I'm not going to write out the slow contention case, because you have 
already agreed that you can do a 32-bit rwlock _slowly_ with the existing 
32-bit FUTEX support.

IOW, I'm faking it, but I'm making a point. Namely that you can 
efficiently do read-write lock using *only* 32-bit ops, and without any 
real kind of limitations on the number of readers and writers.

So here goes the explanation and the pseudo-code.

 - have two levels of locking: the contended case, and the uncontended case

 - these are two *separate* locks.  I'm going to describe the only case
   that mattes for performance, namely the non-contention one.  We just
   make sure that the non-contention lock "gates" things to the slow case.

 - in other words, here's a pretty optimal fast-case that we write in
   assembly language, and all it does is to handle the non-contention 
   case, with any waiting happening on *another* lock entirely.

 - on that first-level lock, the setup is as follows:
	- the low bit (bit#0) is "writer holds"
	- the next bit (bit#1) is "contended", and all it does is that it 
	  guarantees that when set, everybody will go to the slow-path.
	- bits 2-31 are "reader count"

 - the second-level lock is another 32-bit lock that is *adjacent* in
   memory, and they are 64-bit aligned, so that you can do an atomic 
   initialization and more importantly a 64-bit "it is now no longer
   contended" assignment in one atomic op.  That's going to be relevant
   only for the slow-path, and all it means is that we can basically do
   an atomic "sync" of the two locks even on 32-bit x86 with a single
   "cmpxchg8b" (no other "full" 64-bit operations necessary).

And before I actually give the fast-path code, let me describe the 
requirements for the slow-path code:

 - it needs to work with 32-bit futexes. This code obviously does exist, 
   because you already have something like that in glibc. Performance is 
   not important, the only thing that matters is really "queueing 
   behaviour", ie this code needs to wake things up in the right order.

 - it needs to be able to *notice* when things are no longer contended. 
   IOW, it doesn't need to have a fast-path case per se, but the unlock 
   sequences do need to notice when they are the last unlocker, and when 
   that happens, they need to be able to do that magic "lock cmpxchg8b" 
   that tests-and-clears the contention bit in the primary lock at the 
   same time as it does the secondary lock.

That second constraint is actually fairly obvious when you think about it: 
it's effectively the thing that makes us re-enter the non-contention case 
after the contention has been handled.

Ok, that's the setup. Now, let's look at the fast-path cases.

First, write_lock():

	/*
	 * write_lock() can only succeed as a fast-path if the reader
	 * count is zero and there are no pending or holding writers.
	 * Ergo, the low 32 bits have to be 0, and should be 1 (for
	 * "writer exists, no other pending writer" if it succeeds.
	 *
	 * Note that we don't need to update the high bits if we
	 * succeed (because the writer count is the _pending_ writer
	 * count, not the holding one)
	 */
	eax = 0
	edx = 1
	lock cmpxchgl %edx,(rwlock)
	testl %eax,%eax
	jne slowpath
	ret
  slowpath:
	lock orl $2,(rwlock)
	call slow_write_lock
	ret

And here's read_lock:

	/*
	 * read_lock() can only succeed if we increment the reader
	 * count _and_ there were no pending or holding writers.
	 * So we do a 32-bit xaddl with 4 (incrementing the readers  
	 * by one), and were successful if the old value didn't
	 * have any writer bits set
	 */
	eax = 4         /* Low two bits are writers - don't touch */
	xaddl %eax,(rwlock)
	testl $3,%eax   /* Did we have any holding or pending writers? */
	jne slowpath
	ret
  slowpath:
	lock orl $2,(rwlock)
	lock subl $4,(rwlock)
	call slow_read_lock
	ret

See? Fastpaths are fast - a single atomic op and a conditional. 

Now, the unlock paths - they also need to be fast for the non-contention case:

The write_unlock is just

	/*
	 * If there was no contention, then the low word must
	 * still have the value "1" - this one writer, and
	 * no other pending writers or any readers that tried   
	 * to get the lock.
	 */
	eax = 1
	edx = 0
	cmpxchgl %edx,(rwlock)
	cmpl $1,%eax
	jne slowpath    /* contention - need to wake up a reader or a writer */
	ret
  slowpath:
	lock orl $2,(rwlock)
	lock andl $~1,(rwlock)
	call slow_write_unlock
	ret

and the read_unlock is

	eax = -4
	xaddl %eax,(rwlock)
	testl $3,%eax   	/* Do we have contention? */
	jne slowpath
	ret
  slowpath:
	lock orl $2,(rwlock)
	call slow_read_unlock
	ret

Ok, so notice a couple of things here. The above is not only designed to 
handle the uncontended case with just a single locked op on the lock, but 
it also makes sure that each path basically enters the slow-path with all 
of its fast-path actions *done*, and with any unlocks done. So by the time 
the slow-path is entered, we know that

 (a) bit#1 ("contention") is guaranteed to be set, and it will be _our_ 
     job to clear it once everybody has unlocked
 (b) nobody else will ever succeed on the fast-path and they'll all come 
     to us (including any future unlockers that may need to wake things 
     up)
 (c) anybody who got a fastpath lock will do their unlock action before 
     they then get trapped into the slow path.

Now, (c) above, in particular, means that the slow path should start out 
making sure that all fast-path locks have been released. That's easy 
enough to do: the first thing each slow-path member needs to do is to wait 
until the 32-bit fastpath variable gets the value "2". It *will* happen 
eventually, and once it does, we are guaranteed that no fast-path code 
will ever get the lock again (even if the fast-path read_lock() may 
increment the higher bits and then decrement them again when it notices 
the contention - so it can still change from "2", but nobody will actually 
*acquire* the lock (and obviously, if it has hit "2", that also means 
that all _previous_ lockers will have released their locks, whether they 
were read- or write-lockers).

So each slow-path thing needs to start out that way, but once it has done 
that, it basically knows that the fast-path code is immaterial from a lock 
acquire standpoint.

So now you do your existing slow-path code on the second lock. And at each 
unlock (or failed trylock, for that matter), remember to see if you can do 
an atomic "release both fast-path _and_ slow-path locks" with cmpxchg8b 
(with the fastpath lock word being a 2->0 transition - what the slowpath 
rule for "all done" is will obviously depend on the algorithm in 
question).

See? I'm not guaranteeing that the above is "optimal" in the sense that I 
suspect that there are probably clever ways to make the slow path faster 
(including, I suspect, even for all 32-bit code), but I *am* claiming that 
this is _obviously_ optimal for the non-contention case, and that the 
actual contention case is almost certainly not going to care about a 
couple of extra atomic ops.

Agreed? The above isn't actually all that complicated. And it would mean 
that the exact same algorithm works on both 32-bit an 64-bit CPU's, and on 
both old and new kernels (because you only really need 32-bit futexes).

			Linus
