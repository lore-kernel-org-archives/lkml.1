Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbXFUQIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbXFUQIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbXFUQIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:08:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56469 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbXFUQIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:08:47 -0400
Date: Thu, 21 Jun 2007 18:08:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070621160817.GA22897@elte.hu>
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 21 Jun 2007, Ingo Molnar wrote:
> > 
> > what worries me a bit though is that my patch that made spinlocks 
> > equally agressive to that loop didnt solve the hangs!
> 
> Your parch kept doing "spin_trylock()", didn't it?

yeah - it changed spin_lock()'s assembly to do a "LOCK BTRL", which is a 
trylock which tries to dirty the cacheline. There was a "REP NOP" after 
it and a loop back to the "LOCK BTRL".

> That's a read-modify-write thing, and keeps bouncing the cacheline 
> back and forth, and together with the fact that even *after* you get 
> the spinlock the "wait_for_inactive()" would actually end up looping 
> back, releasing it, and re-getting it.
> 
> So the problem was that "wait_for_inactive()" kept the lock (because 
> it actually *got* it), and looped over getting it, and because it was 
> an exclusive cacheline ownership, that implies that somebody else is 
> not getting it, and is kept from ever getting it.

ok, it's not completely clear where exactly the other core was spinning, 
but i took it from Miklos' observations that the other core was hanging 
in the _very same_ task_rq_lock() - which is a true spinlock as well 
that acquires it. So on one core the spin_lock() was starving, on 
another one it was always succeeding.

> So trying to use "trylock" doesn't help. It still has all the same bad 
> sides - it still gets the lock (getting the lock wasn't the problem: 
> _holding_ the lock was the problem), and it still kept the cache line 
> for the lock on one core.

so the problem was not the trylock based spin_lock() itself (no matter 
how it's structured in the assembly), the problem was actually modifying 
the lock and re-modifying it again and again in a very tight 
high-frequency loop, and hence not giving it to the other core?

> The only way to avoid lock contention is to avoid any exclusive use at 
> all.

yeah - i'm not at all arguing in favor of the BTRL patch i did: i always 
liked the 'nicer' inner loop of spinlocks, which could btw also easily 
use MONITOR/MWAIT. (my patch is also quite close to what we did in 
spinlocks many years ago, so it's more of a step backwards than real 
progress.)

So it seems the problem was that if a core kept _truly_ modifying a 
cacheline via atomics in a high enough frequency, it could artificially 
starve the other core. (which would keep waiting for the cacheline to be 
released one day, and which kept the first core from ever making any 
progress) To me that looks like a real problem on the hardware side - 
shouldnt cacheline ownership be arbitrated a bit better than that?

Up to the point where some external event (perhaps a periodic SMM 
related to thermal management) broke the deadlock/livelock scenario?

	Ingo
