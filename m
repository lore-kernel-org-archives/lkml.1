Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbYFCDYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbYFCDYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 23:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbYFCDYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 23:24:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbYFCDYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 23:24:07 -0400
Date: Tue, 3 Jun 2008 05:24:04 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
Message-ID: <20080603032403.GA17089@wotan.suse.de>
References: <4840C29B.6030507@redhat.com> <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org> <4840CE51.9060109@redhat.com> <alpine.LFD.1.10.0805302109370.3141@woody.linux-foundation.org> <alpine.LFD.1.10.0805302116440.3141@woody.linux-foundation.org> <4840D63F.2090407@redhat.com> <alpine.LFD.1.10.0805311438080.3141@woody.linux-foundation.org> <20080602185433.GB4081@elte.hu> <alpine.LFD.1.10.0806021246060.3141@woody.linux-foundation.org> <20080602230316.GA24159@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080602230316.GA24159@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 01:03:17AM +0200, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > > That bit can be used as a lock and if all access to the state of 
> > > that atomic variable uses it, arbitrary higher-order atomic state 
> > > transitions can be derived from it. The cost would be a bit more 
> > > instructions in the fastpath, but there would still only be a single 
> > > atomic op (the acquire op), as the unlock would be a natural barrier 
> > > (on x86 at least).
> > 
> > No, "unlocks as a natural barrier" only works for exclusive kernel 
> > locks (spin_unlock and write_unlock). There we can just do a write to 
> > unlock. But for anything that wants to handle contention differently 
> > than just spinning, the unlock path needs to be able to do an atomic 
> > "unlock and test if I need to do something else", because it may need 
> > to wake things up.
> 
> yeah, indeed. Compared to all the other costs that have to be dealt with 
> here, having a second atomic op isnt all that much of an issue either, 
> especially on latest hw. An atomic op will probably never be as cheap as 
> a non-atomic op, but ~20 cycles is still plenty fast for most practical 
> purposes.

I think optimised our unlock_page in a way that it can do a
non-atomic unlock in the fastpath (no waiters) using 2 bits. In
practice it was still atomic but only because other page flags
operations could operate on ->flags at the same time.

I still have to get around to submitting the damn thing upstream,
but maybe if I bring it up here, I get the idea more reviewed :)

Anyway, the algorithm goes like this:

lock_page()
{
  if (test_and_set_bit_lock(PG_locked))
    lock_page_slow();
}

lock_page_slow()
{
  /* slowpath */
again:
  prepare_to_wait();
  set_bit(PG_waiters);
  if (test_and_set_bit_lock(PG_locked)) {
    schedule();
    goto again;
  }
}

wake_page_waiters()
{
  /* slowpath */
  clear_bit(PG_waiters);
  smp_mb__after_clear_bit(); /* order clear_bit store with wake_up_page load */
  wake_up_page(PG_locked);
}

unlock_page()
{
  clear_bit_unlock(PG_locked);
  if (unlikely(test_bit(PG_waiters)))
    wake_page_waiters();
}

We don't require any load/store barrier in the unlock_page fastpath
because the bits are in the same word, so cache coherency gives us a
sequential ordering anyway.

Now you notice the lock page slowpath can set bits without holding the
lock, at first glance you'd think the clear_bit to unlock has to be
atomic too then. But actually if we're careful, we can put them in seperate
parts of the word and use the sub-word operations on x86 to avoid the atomic
requirement. I'm not aware of any architecture in which operations to the
same word could be out of order.

Not only does this avoid all barriers (except acquire/release) in the
fastpaths, but it also avoids the unconditional load of the random
hash page waitqueue cacheline on unlock.

Anything applicable to your problem at hand?

