Return-Path: <linux-kernel-owner+w=401wt.eu-S1763705AbYFFDiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763705AbYFFDiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 23:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbYFFDh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 23:37:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754618AbYFFDhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 23:37:55 -0400
Date: Thu, 5 Jun 2008 20:37:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
In-Reply-To: <20080606012749.GA12187@wotan.suse.de>
Message-ID: <alpine.LFD.1.10.0806052018440.3473@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805301846530.3141@woody.linux-foundation.org> <4840C29B.6030507@redhat.com> <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org> <4840CE51.9060109@redhat.com> <alpine.LFD.1.10.0805302109370.3141@woody.linux-foundation.org>
 <alpine.LFD.1.10.0805302116440.3141@woody.linux-foundation.org> <4840D63F.2090407@redhat.com> <alpine.LFD.1.10.0805311438080.3141@woody.linux-foundation.org> <20080602185433.GB4081@elte.hu> <alpine.LFD.1.10.0806021246060.3141@woody.linux-foundation.org>
 <20080606012749.GA12187@wotan.suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 6 Jun 2008, Nick Piggin wrote:
> 
> What you *could* maybe do, to slightly speed up the reader fastpath, at
> the expense of the writer fastpath, is to also have the active writer add
> 4 to the count too, so your unlock can start with a lock xadd -4, count
> in order to get the write-intent on the cacheline straight up.

Yes, nice idea. It avoids the possible unnecessary S->M transition, but 
the downside is that it effectively slows down the write unlock by making 
it do two atomic ops even for the fastpath. So if I were to _only_ care 
about the reader path, I think it would be a great idea, but as it is, the 
current non-contended write case is actually pretty close to optimal, and 
doing the unconditional xaddl on the unlock path would slow that one down.

> I'd be more interested to know why this code can't be evolved into a full
> rwlock implementation? This is a rather standard (though neat) looking rwlock
> -- so my question is what can the patented 64-bit futex locks do that this
> can't, or what can they do faster?

Quite frankly - and this was my argument the whole time - I do not believe 
that a "full" 64-bit implementation can do _anything_ more than this 
32-bit one can do.  That's the reason I wrote the code. I'm pretty sure 
that you can do perfectly well with just 32 bit atomic futex ops (my 
rwlocks obviously do use 64-bit cmpxchg's in user space, but not in the 
fast-path, and it should work fine on x86-32 too using cmpxchg8b).

In fact, in the second version of my locks, I didn't do futex operations 
on the actual lock itself at *all*, and just do futex ops on separate 
"event" fields. That actually should have avoided a bug I think I had (but 
couldn't really trigger in practice) in the first version, and made 
everything look pretty straightforward.

I haven't really worked on them since I write the thing, but I did 
consider things like timeouts etc. Timeouts are "hard" to handle because 
they mean that you cannot use any kind of trivially incrementing "ticket 
locks" with sequence numbers (because we may have to just avoid a sequence 
if it times out), so the sequence number approach that we now use for 
kernel spinlocks was not an option. I didn't actually *write* the timeout 
versions, of course, but given the structure of the locks they really 
should be very straightforward.

[ Half-way subtle thing: a writer that times out needs to be very careful 
  that it doesn't lose a wakeup event, but futexes actually make that part 
  pretty easy - since FUTEX_WAIT returns whether you got woken up or not, 
  you can just decide to wake up the next write-waiter if you cannot get 
  the lock immediately and have to exit due to a timeout. ]

But I really haven't tested my rwlocks very exhaustively, and I did not 
verify that they actualyl scale with lots of CPU's, for example.  I 
literally only have dual-core CPU's in use at home, right now, nothing 
fancier. Somebody with dual-socket quads would be a lot better off, and 
the more the merrier, of course.

But correctness is even more important, and that can at least be somewhat 
"thought" about.

		Linus
