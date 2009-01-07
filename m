Return-Path: <linux-kernel-owner+w=401wt.eu-S1762338AbZAGWTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762338AbZAGWTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762143AbZAGWS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:18:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:57577 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762274AbZAGWSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:18:55 -0500
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
In-Reply-To: <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>
References: <87r63ljzox.fsf@basil.nowhere.org>
	 <20090103191706.GA2002@parisc-linux.org> <1231242031.11687.97.camel@twins>
	 <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com>
	 <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>
	 <49636799.1010109@novell.com>  <20090106214229.GD6741@linux.vnet.ibm.com>
	 <1231278275.11687.111.camel@twins>
	 <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain>
	 <1231279660.11687.121.camel@twins>
	 <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain>
	 <1231281801.11687.125.camel@twins>  <1231283778.11687.136.camel@twins>
	 <1231329783.11687.287.camel@twins>
	 <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
	 <1231347442.11687.344.camel@twins>
	 <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
	 <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
	 <1231365115.11687.361.camel@twins>
	 <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Jan 2009 23:18:36 +0100
Message-Id: <1231366716.11687.377.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 13:58 -0800, Linus Torvalds wrote:
> 
> On Wed, 7 Jan 2009, Peter Zijlstra wrote:
> > 
> > Do we really have to re-do all that code every loop?
> 
> No, you're right, we can just look up the cpu once. Which makes Andrew's 
> argument that "probe_kernel_address()" isn't in any hot path even more 
> true.
> 
> > Also, it would still need to do the funny:
> > 
> >  l_owner = ACCESS_ONCE(lock->owner)
> >  if (l_owner && l_owner != thread)
> >    break;
> 
> Why? That would fall out of the 
> 
> 	if (lock->owner != thread)
> 		break;
> 
> part. We don't actually care that it only happens once: this all has 
> _known_ races, and the "cpu_relax()" is a barrier.
> 
> And notice how the _caller_ handles the "owner == NULL" case by not even 
> calling this, and looping over just the state in the lock itself. That was 
> in the earlier emails. So this approach is actually pretty different from 
> the case that depended on the whole spinlock thing.

Ah, so now you do loop on !owner, previuosly you insisted we'd go to
sleep on !owner. Yes, with !owner spinning that is indeed not needed.

> +#ifdef CONFIG_SMP
> +	/* Optimistic spinning.. */
> +	for (;;) {
> +		struct thread_struct *owner;
> +		int oldval = atomic_read(&lock->count);
> +
> +		if (oldval <= MUTEX_SLEEPERS)
> +			break;
> +		if (oldval == 1) {
> +			oldval = atomic_cmpxchg(&lock->count, oldval, 0);
> +			if (oldval == 1) {
> +				lock->owner = task_thread_info(task);
> +				return 0;
> +			}
> +		} else {
> +			/* See who owns it, and spin on him if anybody */
> +			owner = lock->owner;
> +			if (owner)
> +				spin_on_owner(lock, owner);
> +		}
> +		cpu_relax();
> +	}
> +#endif

Hmm, still wouldn't the spin_on_owner() loopyness and the above need
that need_resched() check you mentioned to that it can fall into the
slow path and go to sleep?

