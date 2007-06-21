Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbXFUURE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbXFUURE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbXFUUQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:16:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48756 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752508AbXFUUQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:16:53 -0400
Date: Thu, 21 Jun 2007 13:14:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <20070621200941.GB22303@elte.hu>
Message-ID: <alpine.LFD.0.98.0706211311350.3593@woody.linux-foundation.org>
References: <20070620093612.GA1626@ff.dom.local>
 <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
 <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
 <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com>
 <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
 <20070621202917.a2bfbfc7.dada1@cosmosbay.com>
 <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
 <alpine.LFD.0.98.0706211230130.3593@woody.linux-foundation.org>
 <20070621200941.GB22303@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > If somebody can actually come up with a sequence where we have 
> > spinlock starvation, and it's not about an example of bad locking, and 
> > nobody really can come up with any other way to fix it, we may 
> > eventually have to add the notion of "fair spinlocks".
> 
> there was one bad case i can remember: the spinlock debugging code had a 
> trylock open-coded loop and on certain Opterons CPUs were starving each 
> other.

But this is a perfect example of exactly what I'm talking about:

 THAT CODE IS HORRIBLY BUGGY!

It's not the spinlocks that are broken, it's that damn code.

>          for (;;) {
>                  for (i = 0; i < loops; i++) {
>                          if (__raw_write_trylock(&lock->raw_lock))
>                                  return;
>                          __delay(1);
>                  }

What a piece of crap. 

Anybody who ever waits for a lock by busy-looping over it is BUGGY, 
dammit!

The only correct way to wait for a lock is:

  (a) try it *once* with an atomic r-m-w 
  (b) loop over just _reading_ it (and something that implies a memory 
      barrier, _not_ "__delay()". Use "cpu_relax()" or "smp_rmb()")
  (c) rinse and repeat.

and code like the above should just be shot on sight.

So don't blame the spinlocks or the hardware for crap code.

		Linus
