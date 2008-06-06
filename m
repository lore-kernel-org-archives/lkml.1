Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYFFLxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYFFLxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 07:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbYFFLxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 07:53:09 -0400
Received: from mail.suse.de ([195.135.220.2]:46664 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbYFFLxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 07:53:08 -0400
Date: Fri, 6 Jun 2008 13:53:05 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
Message-ID: <20080606115305.GA20345@wotan.suse.de>
References: <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org> <4840CE51.9060109@redhat.com> <alpine.LFD.1.10.0805302109370.3141@woody.linux-foundation.org> <alpine.LFD.1.10.0805302116440.3141@woody.linux-foundation.org> <4840D63F.2090407@redhat.com> <alpine.LFD.1.10.0805311438080.3141@woody.linux-foundation.org> <20080602185433.GB4081@elte.hu> <alpine.LFD.1.10.0806021246060.3141@woody.linux-foundation.org> <20080606012749.GA12187@wotan.suse.de> <alpine.LFD.1.10.0806052018440.3473@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806052018440.3473@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 08:37:19PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 6 Jun 2008, Nick Piggin wrote:
> > 
> > What you *could* maybe do, to slightly speed up the reader fastpath, at
> > the expense of the writer fastpath, is to also have the active writer add
> > 4 to the count too, so your unlock can start with a lock xadd -4, count
> > in order to get the write-intent on the cacheline straight up.
> 
> Yes, nice idea. It avoids the possible unnecessary S->M transition, but 
> the downside is that it effectively slows down the write unlock by making 
> it do two atomic ops even for the fastpath. So if I were to _only_ care 
> about the reader path, I think it would be a great idea, but as it is, the 
> current non-contended write case is actually pretty close to optimal, and 
> doing the unconditional xaddl on the unlock path would slow that one down.

Yeah, it is a case of a large slowdown for write for a small speedup
for read (pity the API doesn't have explicit read and write unlocks
-- were they too lazy to type the last bit, or did they expect people
to lose track of whether they had a read or write lock? :P)

Anyway, it's obviously a tradeoff you'd just have to carefully
benchmark in real situations.

 
> > I'd be more interested to know why this code can't be evolved into a full
> > rwlock implementation? This is a rather standard (though neat) looking rwlock
> > -- so my question is what can the patented 64-bit futex locks do that this
> > can't, or what can they do faster?
> 
> Quite frankly - and this was my argument the whole time - I do not believe 

> consider things like timeouts etc. Timeouts are "hard" to handle because 
> they mean that you cannot use any kind of trivially incrementing "ticket 
> locks" with sequence numbers (because we may have to just avoid a sequence 
> if it times out), so the sequence number approach that we now use for 
> kernel spinlocks was not an option. I didn't actually *write* the timeout 
> versions, of course, but given the structure of the locks they really 
> should be very straightforward.
> 
> [ Half-way subtle thing: a writer that times out needs to be very careful 
>   that it doesn't lose a wakeup event, but futexes actually make that part 
>   pretty easy - since FUTEX_WAIT returns whether you got woken up or not, 
>   you can just decide to wake up the next write-waiter if you cannot get 
>   the lock immediately and have to exit due to a timeout. ]
> 
> But I really haven't tested my rwlocks very exhaustively, and I did not 
> verify that they actualyl scale with lots of CPU's, for example.  I 
> literally only have dual-core CPU's in use at home, right now, nothing 
> fancier. Somebody with dual-socket quads would be a lot better off, and 
> the more the merrier, of course.

Well... a single lock is only going to be so scalable. I don't see how
it could be done really significantly better? Maybe a small factor of
improvement if you were to concentrate on the contended case (but you
wouldn't want to do that anyway)



