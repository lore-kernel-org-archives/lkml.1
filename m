Return-Path: <linux-kernel-owner+w=401wt.eu-S1760017AbYEOIDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017AbYEOIDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 04:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759551AbYEOICj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 04:02:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41437 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759047AbYEOICe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 04:02:34 -0400
Date: Thu, 15 May 2008 10:02:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
Message-ID: <20080515080211.GA14821@elte.hu>
References: <20080514174955.GA515@elte.hu> <87fxsk7n7e.fsf@basil.nowhere.org> <20080514220034.51eae9e0@core> <482B5614.3060203@firstfloor.org> <20080514221957.6edb2d60@core> <alpine.LFD.1.10.0805141435540.3019@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805141435540.3019@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 14 May 2008, Alan Cox wrote:
> > 
> > That in itself is a problem Ingo's stuff won't help with: We have 
> > lots of "magic" accidental, undocumented and pot luck BKL locking 
> > semantics between subsystems that are not even visible.
> 
> The good news is that I suspect they are going away. It probably is 
> mainly tty and /proc by now, and /proc is pretty close to done.
> 
> It's hard to have too many inter-module dependencies when most of the 
> core modules no longer even take the kernel lock any more.

yeah. And Alan has a good point: there _is_ lots of magic stuff 
happening below the BKL. One of them are the BKL <-> other lock 
dependencies. My stuff helps with mapping that part of the magic: it 
turns the BKL into an ordinary mutex and thus integrates it into 
lockdep's existing dependency validation machinery.

In other words: this stuff makes BKL validation _stronger_, not weaker, 
and hence it ultimately helps its mapping and elimination. It turns the 
"magic" into something more concrete.

It might not help with other magic directly - but it helps indirectly, 
because now the "magic" has shrunk, so there's more attention and more 
resources available to fix it in the places where the magic hurts. (And 
suggestions are welcome for more debug helpers to make more magic more 
visible.)

Whenever someone narrows the BKL's scope, that will always have to be 
done carefully - and that's true of any other lock. This patchset 
(except perhaps the boot bits) does not narrow the BKL's scope.

It will still be no doubt a tough job (reducing/changing locking of 
_any_ locked path is a tough job), but it will now fit into our existing 
practices much better and we'll get various reminders from lockdep and 
the other debug helpers when we forgot about some detail.

Before this there was almost zero feedback from the kernel when 
something around the BKL broke: pretty much the only remainder we had 
from incorrect BKL elimination were subtle breakages.

And my personal experience might matter as well: before this i never 
dared to touch BKL code. I once removed _all_ BKL locking from all the 
kernel _by accident_ [i typoed a single line in lib/smp_lock.c] and ran 
it on my main desktop for about a day and never noticed a thing - until 
a few weird TTY messages popped up in the syslog...

But with this scheme, i felt _much_ more secure about touching BKL code, 
and kicking the BKL from the scheduler was pure joy i have to say. (even 
though it will of course remain in the upstream scheduler until we are 
reasonably sure about the stability of this whole kill-the-BKL approach)

I'm sure other subsystem maintainers will have a similar experience.

	Ingo
