Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbYFBUZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbYFBUZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 16:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbYFBUYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 16:24:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756228AbYFBUYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 16:24:09 -0400
Date: Mon, 2 Jun 2008 13:22:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       David Howells <dhowells@redhat.com>
cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
In-Reply-To: <20080602185433.GB4081@elte.hu>
Message-ID: <alpine.LFD.1.10.0806021246060.3141@woody.linux-foundation.org>
References: <200805310127.m4V1RLR4013808@devserv.devel.redhat.com> <alpine.LFD.1.10.0805301846530.3141@woody.linux-foundation.org> <4840C29B.6030507@redhat.com> <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org> <4840CE51.9060109@redhat.com>
 <alpine.LFD.1.10.0805302109370.3141@woody.linux-foundation.org> <alpine.LFD.1.10.0805302116440.3141@woody.linux-foundation.org> <4840D63F.2090407@redhat.com> <alpine.LFD.1.10.0805311438080.3141@woody.linux-foundation.org> <20080602185433.GB4081@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ I added Nick and DavidH to the Cc, since they have at least historically 
  shown interest in locking algorithms ]

On Mon, 2 Jun 2008, Ingo Molnar wrote:
> 
> i suspect _any_ abstract locking functionality around a data structure 
> can be implemented via atomic control over just a single user-space bit.

Well, theory is theory, and practice is different.

That's *especially* true when it comes to locking, which is just so 
tightly coupled to the exact details of which atomics are fast on a 
particular architecture.

Also, different people will want to see different performance profiles. 

For example, it makes a *huge* difference whether you are strictly fair or 
not. I can almost guarantee that a 100% fair implementation may be really 
"nice" from a theoretical standpoint, but suck really badly in practice, 
because if you want best performance, then you want the lock to have a 
very strong CPU affinity - and the faster you can do your lock ops, the 
more of a unfairness and CPU affinity they get!

And rwlocks in particular are actually much more interesting in this 
respect, because they not only have that CPU affinity fairness, but also 
the reader-vs-writer fairness. You optimize for one load, and it may give 
you almost perfect performance, but at the cost of sucking at another 
load.

For example, some loads are almost entirely read-read locks, with only 
very occasional write locks for some uncommon config change thing. Do you 
want to optimize for that? Maybe. And yes, you can make those uncontended 
read-read locks go really quickly, but then (especially if you continue to 
let reads through even when writers want to contend), that can slow down 
writers a *lot*, to the point of starvation.

Different CPU's will also show different patterns. 

Anyway, I was busy most of the weekend, but I've now coded up a partial 
actual example implementation. Its' probably buggy. Uli is very correct in 
saying that it's easy to screw up futex'es, but even in the absense of 
futexes, it's just easy to screw up any threaded logic.

But if anybody wants to look at a rough draft that at least limps along 
_partially_, there's

	http://git.kernel.org/?p=linux/kernel/git/torvalds/rwlock.git;a=summary

for you.

And I'll freely admit that 
 (a) the above thing is pretty hacked up. No guarantees as to correctness 
     or anything else.
 (b) I looked _mainly_ at the "all readers" case, and considered that the 
     primary goal. Which explains why it does really well on that 
     particular load.
 (c) However, I refuse to starve writers. In fact, my thing will always 
     prefer a writer to any new readers, on the assumption that the sanest 
     rwlock situation is the "tons of readers, occasional writer".
 (d) it does ok for me on the write-write contention case too, but the 
     random mixed "all threads do 5% writelocks" test-case seems to suck.

As an exmaple: the current glibc code I have seems to be uniformly and 
boringly middle-of-the-road. It really doesn't seem to be horrible at all. 
That said, the above thing _is_ 2-3x faster for me on that read-read case 
(from single thread up to 20 threads - but just tested on one particular 
machine), so if that is what you want to aim for, it's certainly easy to 
beat.

But for the write case, while I can easily beat it for a low-thread count 
with little contention, my example thing above benchmarks about equal for 
bigger thread counts (caveat: again - I've only tested on one machine, 
which is a single-socket dual-core thing. Caveat emptor).

And the pthreads implementation actually beats my hacked-up one at least 
for the 5% random writelocks case. It's not beating it by a huge amount, 
but it's not in the noise level either (maybe 15%). And I bet the pthreads 
implementation is a hell of a lot better tested ;)

> That bit can be used as a lock and if all access to the state of that 
> atomic variable uses it, arbitrary higher-order atomic state transitions 
> can be derived from it. The cost would be a bit more instructions in the 
> fastpath, but there would still only be a single atomic op (the acquire 
> op), as the unlock would be a natural barrier (on x86 at least).

No, "unlocks as a natural barrier" only works for exclusive kernel locks 
(spin_unlock and write_unlock). There we can just do a write to unlock. 
But for anything that wants to handle contention differently than just 
spinning, the unlock path needs to be able to do an atomic "unlock and 
test if I need to do something else", because it may need to wake things 
up.

Feel free to try out my code, and laugh at it. Getting locking right is 
definitely not simple, and I would be really surprised if I got everything 
right. It's meant as a "hey, here's real code people can at least play 
with" for anybody who is interested in this kind of thing. 

		Linus
