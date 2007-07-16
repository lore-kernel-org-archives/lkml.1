Return-Path: <linux-kernel-owner+w=401wt.eu-S1758508AbXGPKSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbXGPKSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 06:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757741AbXGPKSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 06:18:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386AbXGPKS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 06:18:29 -0400
Date: Mon, 16 Jul 2007 12:18:28 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch 2/2] x86_64: FIFO ticket spinlocks
Message-ID: <20070716101828.GE21464@wotan.suse.de>
References: <20070716045932.GA19914@wotan.suse.de> <20070716050134.GB19914@wotan.suse.de> <20070716092646.GA18423@elte.hu> <20070716094503.GC21464@wotan.suse.de> <20070716094940.GA23080@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716094940.GA23080@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 11:49:40AM +0200, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > On Mon, Jul 16, 2007 at 11:26:46AM +0200, Ingo Molnar wrote:
> > > 
> > > * Nick Piggin <npiggin@suse.de> wrote:
> > > 
> > > > [...] trylock is more significantly slower, but they are relatively 
> > > > rare.
> > > 
> > > trylock is the main thing that the spinlock debugging code uses, and 
> > > SPINLOCK_DEBUG is frequently enabled by distro kernels. OTOH, the cost 
> > > looks like to be +5 instructions, right? Still ...
> > 
> > Which trylocks do you mean? The lockbreak spinlocks use trylock, but 
> > those are not used with the ticket version.
> 
> the trylocks in lib/spinlock-debug.c:
> 
>  static void __spin_lock_debug(spinlock_t *lock)
>  {
>  ...
>                          if (__raw_spin_trylock(&lock->raw_lock))
>                                  return;
>  ...
>  void _raw_spin_lock(spinlock_t *lock)
>  {
>          debug_spin_lock_before(lock);
>          if (unlikely(!__raw_spin_trylock(&lock->raw_lock)))
>                  __spin_lock_debug(lock);
>          debug_spin_lock_after(lock);
>  }
> 
> am i missing something?

No, I missed that. Yeah, that would get a bit slower, but I'm not sure
if it would be a problem on a kernel where you have spinlock debuggin
on anyway.

If it becomes a problem, we could perhaps do a version for ticket locks
that first takes a ticket, and then is for up to a second before
printing the stuck lock message. That would make the performance hit go away.

