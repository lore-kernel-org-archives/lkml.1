Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbXGHKlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbXGHKlP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 06:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXGHKlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 06:41:01 -0400
Received: from ns2.suse.de ([195.135.220.15]:40014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600AbXGHKlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 06:41:00 -0400
Date: Sun, 8 Jul 2007 12:40:50 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: queued spinlock code and results
Message-ID: <20070708104050.GC11305@wotan.suse.de>
References: <20070708043228.GB22397@wotan.suse.de> <p733azz16vh.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p733azz16vh.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 01:18:10PM +0200, Andi Kleen wrote:
> Nick Piggin <npiggin@suse.de> writes:
> 
> > I made some tests of the queued spinlock code using userspace test code on
> > 64-bit processors. I believe the xadd based code no longer has any theoretical
> > memory ordering problems.
> 
> Linus, the background of this is that on 8 socket Opteron systems
> the current spinlocks can become very unfair to the point of severe 
> starvation. These boxes are becomming more common.
> 
> > The threaded results also attempt to have an unfairness count, which is the
> > max number of times in a row that a lock is acquired,  when all other threads
> > are also executing in the loop -- the reason xadd for example is not always
> > 0 there is because the other threads may not have reached the lock before
> > the current thread was able to get it several times (eg. if an interrupt
> > comes in, this could happen).
> 
> Interesting. I was also thinking about switching the lock types
> at boot time. Since all the lock calls are out of line this would
> be reasonably easy.
> 
> I would say the main drawback of switchable and queued locks 
> would be also that they require a larger spinlock_t thus increasing
> cache usage

Technically the queued locks require twice the size (but I think
the implementation can handle 256 CPUs with 16 bits, while dec based
can only handle 128 with 8 bits -- not a big deal I know, but we'll
probably get there soon).

However currently spinlocks are much bigger than they could be anyway
(4 bytes, could be 1). Although often the alignment of data structures
will make the gain not so big.

But that said, I don't like to justify slightly suboptimal code by
saying that existing code is even less optimal :)

One other upshot of the queued spinlocks is that they don't need
the break_lock field, or any of the associated logic with that
(because it is trivial to test whether a lock is held and also how
many others are spinning on it). So that gives us for free an
avenue into more advanced congestion or spin backoff algorithms.

