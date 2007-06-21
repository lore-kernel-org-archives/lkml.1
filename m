Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbXFUQex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbXFUQex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbXFUQeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:34:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56772 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757834AbXFUQeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:34:17 -0400
Date: Thu, 21 Jun 2007 09:32:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <20070621160817.GA22897@elte.hu>
Message-ID: <alpine.LFD.0.98.0706210923000.3593@woody.linux-foundation.org>
References: <20070620093612.GA1626@ff.dom.local>
 <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
 <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
 <20070621160817.GA22897@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Ingo Molnar wrote:
> 
> so the problem was not the trylock based spin_lock() itself (no matter 
> how it's structured in the assembly), the problem was actually modifying 
> the lock and re-modifying it again and again in a very tight 
> high-frequency loop, and hence not giving it to the other core?

That's what I think, yes.

And it matches the behaviour we've seen before (remember the whole thread 
about whether Opteron or Core 2 hardware is "more fair" between cores?)

It all simply boils down to the fact that releasing and almost immediately 
re-taking a lock is "invisible" to outside cores, because it will happen 
entirely within the L1 cache of one core if the cacheline is already in 
"owned" state.

Another core that spins wildly trying to get it ends up using a much 
slower "beat" (the cache coherency clock), and with just a bit of bad luck 
the L1 cache would simply never get probed, and the line never stolen, at 
the point where the lock happens to be released.

The fact that writes (as in the store that releases the lock) 
automatically get delayed by any x86 core by the store buffer, and the 
fact that atomic read-modify-write cycles do *not* get delayed, just means 
that if the "spinlock release" was "fairly close" to the "reacquire" in a 
software sense, the hardware will actually make them *even*closer*.

So you could make the spinlock release be a read-modify-write cycle, and 
it would make the spinlock much slower, but it would also make it much 
more likely that the other core will *see* the release.

For the same reasons, if you add a "smp_mb()" in between the release and 
the re-acquire, the other core is much more likely to see it: it means 
that the release won't be delayed, and thus it just won't be as "close" to 
the re-acquire.

So you can *hide* this problem in many ways, but it's still just hiding 
it.

The proper fix is to not do that kind of "release and re-acquire" 
behaviour in a loop.

			Linus
