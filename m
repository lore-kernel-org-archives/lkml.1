Return-Path: <linux-kernel-owner+w=401wt.eu-S1759135AbYHUWYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135AbYHUWYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 18:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758829AbYHUWYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 18:24:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758961AbYHUWYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 18:24:41 -0400
Date: Thu, 21 Aug 2008 15:22:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] Writer-biased low-latency rwlock v8
In-Reply-To: <alpine.LFD.1.10.0808211402370.3487@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808211500530.3487@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808161014300.3324@nehalem.linux-foundation.org> <20080816211954.GB7358@Krystal> <alpine.LFD.1.10.0808161422290.3324@nehalem.linux-foundation.org> <20080817075335.GA25019@Krystal> <alpine.LFD.1.10.0808170909420.3324@nehalem.linux-foundation.org>
 <20080817191034.GA5258@Krystal> <20080818232500.GF6732@linux.vnet.ibm.com> <20080819060417.GB24085@Krystal> <20080819073345.GA30285@Krystal> <alpine.LFD.1.10.0808190946560.3324@nehalem.linux-foundation.org> <20080821205045.GA24909@Krystal>
 <alpine.LFD.1.10.0808211356360.3487@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808211402370.3487@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Aug 2008, Linus Torvalds wrote:
> 
>  rdlock:
> 	movl $4,%eax
> 	lock ; xaddl %eax,(%rdi)
> 	testl $3,%eax
> 	jne __rdlock_slowpath
> 	ret


Ok, so change that "testl" to "andl" to shave two bytes, and then make the 
whole lock structure look something like this:

	struct rwlock {
		u32 fastpath;
		u32 pending_readers;
		u32 pending_writers;
	};

and then the slowpath would look something like this:

	void __rdlock_slowpath(struct rwlock *lock)
	{
		/* Move the read count to the pending path and undo our xadd */
		atomic_add(1, &lock->pending_readers);
		atomic_sub(4, &lock->fastpath);

		for (;;) {
			unsigned fastpath;
			while (lock->pending_writers)
				cpu_relax();
			while ((fastpath = lock->fastpath) & 1)
				cpu_relax();
			/* This will also undo the contention bit */
			if (atomic_cmpxchg(&lock->fastpath, fastpath, (fastpath & ~2)+4)) == fastpath);
				break;
		}
		atomic_sub(1, &lock->pending_readers);
	}

and yes, there are more atomic accesses in there than would be necessary, 
in that if you can cram the whole thing into a single 64-bit word you can 
do both the initial pending fixup and the final cmpxchg/pending_readers 
thing as a single locked 64-bit op, but hey, the above is fairly simple.

You could also just use a spinlock to protect all the other data, of 
course.

There are fairness issues here too - do you really want to wait for 
pending writes every time, or just the first time through the loop? It 
depends on just how much you want to prefer writers.

The slow-paths for writers is similar, and has similar issues for the 
fairness issue. For example, instead of a simple "pending_writers" count, 
maybe you want to use a ticket lock there, to make writers be fair among 
themselves? Of course, the hope would be that there would never be that 
kind of contention by pure writers, so that sounds like overdesign, but 
the thing I'm trying to point out here is that this is all a separate 
decision from the actual fast-path, and having fair writers doesn't 
necessarily mean that the fastpath has to even know/care.

The placement of the counts is also something that can be optimized. For 
example, on teh assumption that readers are much more common than writers, 
I put the "pending_readers" next to the "fastpath" lock, exactly so that 
you -can- do the update of both with a single 64-bit locked access, even 
if the fastpath just used a 32-bit one. But then you should at least add a 
"__attribute__((aligned(8)))" to the structure definition.

And maybe you want to share the slowpath between all the irq-off etc 
versions, in which case you need to make the "irq enable while waiting" 
thing be conditional. 

And if the write path wants to wait for pending readers, and you want to 
make _that_ fair too, then you want to have that punch through if the 
writer is in an interrupt, to avoid deadlocks. And again, you might want 
to make the reader thing be some kind of ticket-based system, so that 
writers can wait for the readers that came in _before_ that writer, but 
not to later ones.

But again - none of that has anything to do with the fast-path. The 
fast-path remains exactly the same for all these issues.

And finally: NONE of the code is at all tested. It's all just written in 
my MUA. Caveat emptor.

			Linus
