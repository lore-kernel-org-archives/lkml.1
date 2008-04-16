Return-Path: <linux-kernel-owner+w=401wt.eu-S1762337AbYDPQRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762337AbYDPQRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbYDPQRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:17:10 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36182 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbYDPQRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:17:09 -0400
Date: Wed, 16 Apr 2008 10:16:52 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080416161652.GK9191@parisc-linux.org>
References: <4803AD91.5020001@firstfloor.org> <20080415174109.GD9191@parisc-linux.org> <alpine.LFD.1.00.0804151101590.2879@woody.linux-foundation.org> <200804161807.25582.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804161807.25582.ioe-lkml@rameria.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 06:07:24PM +0200, Ingo Oeser wrote:
> Hmm, why not introduce a provide_slots(), 
> wait_for_slot() and free_slot() API?
> 
> provide_slots() :=  initialize a resource with N available slots
> wait_for_slot() :=  wait for a slot in countable resource to be free
> free_slot() :=  make a slot available
> 
> That would:
> - fit the use case nicely
> - could be optimized for countable resources
>   with upper limits
> - allow to measure slot utilization
> - ...
> - is not called semaphore :-)

The kcounter API I'm working on has something in common with this.  But
it adds the more important feature:

 - Is debuggable

I've also researched the current users of semaphores and completions and
the API has to be extended a few different ways to take account of some
reasonable usage patterns.

The basic idea is that you get back a cookie from the kcounter_claim()
which you have to hand to the kcounter_release() function so it
knows which one you released.  It's similar to mutex debugging except
that mutexes can use the thread_info pointer as an implicit cookie.
Completions and semaphores have usage patterns where the resource is
released from interrupt context.

I'm not finished yet, but this is the current API:

extern void kcounter_init(struct kcounter *kc, unsigned int count);

extern long __must_check kcounter_claim(struct kcounter *kc);
extern long __must_check kcounter_claim_interruptible(struct kcounter *kc);
extern long __must_check kcounter_claim_timeout(struct kcounter *kc,
                                                long jiffies);
extern long __must_check kcounter_claim_interruptible_timeout(
                                struct kcounter *kc, long jiffies);
extern long __must_check kcounter_try_claim(struct kcounter *kc);
extern int __must_check kcounter_has_resources(struct kcounter *kc);
extern void kcounter_release(struct kcounter *kc, long resource);

#ifdef CONFIG_DEBUG_KCOUNTER
extern void kcounter_add_resource(struct kcounter *kc);
extern int __must_check kcounter_remove_resource(struct kcounter *kc);
#else
#define kcounter_add_resource(kc)       kcounter_release(kc, 0)
#define kcounter_remove_resource(kc)    kcounter_claim(kc)
#endif
extern void kcounter_add_all_resources(struct kcounter *kc);

The kcounter_add_resource()/kcounter_remove_resource() API is for where
we're actually adding new slots rather than releasing an already-acquired
slot.  Without debugging they're the same thing, but conceptually,
they're a different thing.

> And isn't this the same problem (called scheduling) as:
> - keeping N cpus busy
> - keeping N (disk) spindles busy
> - keeping N nic transmit queues busy
> - ...

It's not nearly as complex.  Each of those uses domain-specific knowledge
to optimise the solution.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
