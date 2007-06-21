Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbXFURdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbXFURdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbXFURdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:33:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56557 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758230AbXFURdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:33:39 -0400
Date: Thu, 21 Jun 2007 10:31:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Jarek Poplawski <jarkao2@o2.pl>,
       Miklos Szeredi <miklos@szeredi.hu>, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <467AAB04.2070409@redhat.com>
Message-ID: <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
References: <20070620093612.GA1626@ff.dom.local>
 <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
 <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
 <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Chuck Ebbert wrote:
> 
> A while ago I showed that spinlocks were a lot more fair when doing
> unlock with the xchg instruction on x86. Probably the arbitration is all
> screwed up because we use a mov instruction, which while atomic is not
> locked.

No, the cache line arbitration doesn't know anything about "locked" vs 
"unlocked" instructions (it could, but there really is no point).

The real issue is that locked instructions on x86 are serializing, which 
makes them extremely slow (compared to just a write), and then by being 
slow they effectively just make the window for another core bigger.

IOW, it doesn't "fix" anything, it just hides the bug with timing.

You can hide the problem other ways by just increasing the delay between 
the unlock and the lock (and adding one or more serializing instruction in 
between is generally the best way of doing that, simply because otherwise 
micro- architecture may just be re-ordering things on you, so that your 
"delay" isn't actually in between any more!).

But adding delays doesn't really fix anything, of course. It makes things 
"fairer" by making *both* sides suck more, but especially if both sides 
are actually the same exact thing, I could well imagine that they'd both 
just suck equally, and get into some pattern where they are now both 
slower, but still see exactly the same problem!

Of course, as long as interrupts are on, or things like DMA happen etc, 
it's really *really* hard to be totally unlucky, and after a while you're 
likely to break out of the steplock on your own, just because the CPU's 
get interrupted by something else.

It's in fact entirely possible that the long freezes have always been 
there, but the NOHZ option meant that we had much longer stretches of time 
without things like timer interrupts to jumble up the timing! So maybe the 
freezes existed before, but with timer interrupts happening hundreds of 
times a second, they weren't noticeable to humans.

(Btw, that's just _one_ theory. Don't take it _too_ seriously, but it 
could be one of the reasons why this showed up as a "new" problem, even 
though I don't think the "wait_for_inactive()" thing has changed lately.)

		Linus
