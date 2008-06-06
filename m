Return-Path: <linux-kernel-owner+w=401wt.eu-S1762322AbYFFB2C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762322AbYFFB2C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 21:28:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbYFFB1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 21:27:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbYFFB1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 21:27:51 -0400
Date: Fri, 6 Jun 2008 03:27:49 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
Message-ID: <20080606012749.GA12187@wotan.suse.de>
References: <alpine.LFD.1.10.0805301846530.3141@woody.linux-foundation.org> <4840C29B.6030507@redhat.com> <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org> <4840CE51.9060109@redhat.com> <alpine.LFD.1.10.0805302109370.3141@woody.linux-foundation.org> <alpine.LFD.1.10.0805302116440.3141@woody.linux-foundation.org> <4840D63F.2090407@redhat.com> <alpine.LFD.1.10.0805311438080.3141@woody.linux-foundation.org> <20080602185433.GB4081@elte.hu> <alpine.LFD.1.10.0806021246060.3141@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806021246060.3141@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 01:22:57PM -0700, Linus Torvalds wrote:
> 
> [ I added Nick and DavidH to the Cc, since they have at least historically 
>   shown interest in locking algorithms ]
> 
> On Mon, 2 Jun 2008, Ingo Molnar wrote:
> > 
> > i suspect _any_ abstract locking functionality around a data structure 
> > can be implemented via atomic control over just a single user-space bit.
> 
> Well, theory is theory, and practice is different.
> 
> That's *especially* true when it comes to locking, which is just so 
> tightly coupled to the exact details of which atomics are fast on a 
> particular architecture.
> 
> Also, different people will want to see different performance profiles. 
> 
> For example, it makes a *huge* difference whether you are strictly fair or 
> not. I can almost guarantee that a 100% fair implementation may be really 
> "nice" from a theoretical standpoint, but suck really badly in practice, 
> because if you want best performance, then you want the lock to have a 
> very strong CPU affinity - and the faster you can do your lock ops, the 
> more of a unfairness and CPU affinity they get!
> 
> And rwlocks in particular are actually much more interesting in this 
> respect, because they not only have that CPU affinity fairness, but also 
> the reader-vs-writer fairness. You optimize for one load, and it may give 
> you almost perfect performance, but at the cost of sucking at another 
> load.
> 
> For example, some loads are almost entirely read-read locks, with only 
> very occasional write locks for some uncommon config change thing. Do you 
> want to optimize for that? Maybe. And yes, you can make those uncontended 
> read-read locks go really quickly, but then (especially if you continue to 
> let reads through even when writers want to contend), that can slow down 
> writers a *lot*, to the point of starvation.
> 
> Different CPU's will also show different patterns. 
> 
> Anyway, I was busy most of the weekend, but I've now coded up a partial 
> actual example implementation. Its' probably buggy. Uli is very correct in 
> saying that it's easy to screw up futex'es, but even in the absense of 
> futexes, it's just easy to screw up any threaded logic.
> 
> But if anybody wants to look at a rough draft that at least limps along 
> _partially_, there's
> 
> 	http://git.kernel.org/?p=linux/kernel/git/torvalds/rwlock.git;a=summary
> 
> for you.
> 
> And I'll freely admit that 
>  (a) the above thing is pretty hacked up. No guarantees as to correctness 
>      or anything else.
>  (b) I looked _mainly_ at the "all readers" case, and considered that the 
>      primary goal. Which explains why it does really well on that 
>      particular load.
>  (c) However, I refuse to starve writers. In fact, my thing will always 
>      prefer a writer to any new readers, on the assumption that the sanest 
>      rwlock situation is the "tons of readers, occasional writer".
>  (d) it does ok for me on the write-write contention case too, but the 
>      random mixed "all threads do 5% writelocks" test-case seems to suck.
> 
> As an exmaple: the current glibc code I have seems to be uniformly and 
> boringly middle-of-the-road. It really doesn't seem to be horrible at all. 
> That said, the above thing _is_ 2-3x faster for me on that read-read case 
> (from single thread up to 20 threads - but just tested on one particular 
> machine), so if that is what you want to aim for, it's certainly easy to 
> beat.
> 
> But for the write case, while I can easily beat it for a low-thread count 
> with little contention, my example thing above benchmarks about equal for 
> bigger thread counts (caveat: again - I've only tested on one machine, 
> which is a single-socket dual-core thing. Caveat emptor).
> 
> And the pthreads implementation actually beats my hacked-up one at least 
> for the 5% random writelocks case. It's not beating it by a huge amount, 
> but it's not in the noise level either (maybe 15%). And I bet the pthreads 
> implementation is a hell of a lot better tested ;)

Had a bit of a look though this, seems pretty OK to me. Obviously with
rwlocks it *is*  impossible to do non-atomic unlocks, so I can't see
a way to significantly improve your code there.

What you *could* maybe do, to slightly speed up the reader fastpath, at
the expense of the writer fastpath, is to also have the active writer add
4 to the count too, so your unlock can start with a lock xadd -4, count
in order to get the write-intent on the cacheline straight up.

Though that's a pretty tiny "optmisation", and not going to be an amazing
win, even when it does save a state transition on the cacheline...

I'd be more interested to know why this code can't be evolved into a full
rwlock implementation? This is a rather standard (though neat) looking rwlock
-- so my question is what can the patented 64-bit futex locks do that this
can't, or what can they do faster?
