Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889Ab0ABTXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab0ABTXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 14:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612Ab0ABTXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 14:23:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59506 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab0ABTXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 14:23:39 -0500
Date: Sat, 2 Jan 2010 20:23:37 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: reiserfs broken in 2.6.32 was Re: [GIT PULL] reiserfs fixes
Message-ID: <20100102192337.GB30016@basil.fritz.box>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com> <87bphc7heo.fsf@basil.nowhere.org> <20100102163644.GA5076@nowhere> <20100102174311.GA30016@basil.fritz.box> <20100102190213.GC5076@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100102190213.GC5076@nowhere>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 02, 2010 at 08:02:15PM +0100, Frederic Weisbecker wrote:
> On Sat, Jan 02, 2010 at 06:43:12PM +0100, Andi Kleen wrote:
> > > I only have reiserfs partitions in my laptop and my testbox,
> > > nothing else. And that because I'm now maintaining it de facto.
> > 
> > AFAIK it's widely used in SUSE installations. It was the default
> > for a long time.
> > 
> > And right now as in 2.6.32 it's in a state of
> > "may randomly explode/deadlock". And no clear path out of it. Not good.
> > 
> > I am very concerned about destabilizing a widely used file system
> > like this. This has the potential to really hurt users.
> 
> 
> I understand your worries. And I've been very cautious with that,
> waiting for three cycles before requesting an upstream merge. I did
> it because the isolated tree model did not scale anymore.
> 
> Now that it's upstream, I get more testing and I expect that, in
> the end of this cycle, I get most of these issues reported and
> fixed.

Will you? 

How many users systems could it break by then?

> 
> Serious users who run serious datas won't ship 2.6.33, they will ship
> a further stable version 2.6.33.x (if they haven't converted their
> filesystems already).
> And at this time, things should be 99% fixed.

That seems very risky.  For some rarely used obscure subsystems
that might work but a widely used file system that keeps people's $HOME? 
I don't think seriously destabilizing that for a potentially longer
time is a good idea. There's the potential to break
a lot of porcelain.

Probably you could do a ext3/ext4 like thing by starting
with a "reiserfs3.5" copy and do the work there and then
merge back once things work and have been reasonably verified
by code review.


> That's the theory. Fitting into this strict scheme brings performance
> regressions. The bkl is a spinlock, it disables preemption, it is
> relaxed on sleep, and doesn't have locking dependencies. Moreover
> it's not a lock but a simulation of a NO_PREEMPT UP flow, with all
> the fixup guardians that come with (fixup if we schedule, as
> scheduling brings races).
> 
> From the conversion is borned a mutex. Even though we have
> adaptive spinning, we don't catch up spinlock performances
> as it's not a pure optimized looping fast path, and it may
> actually just sleep.

Fix the adaptive spinlock then?

> 
> The bkl is relaxed only when we sleep. Now simulating that with
> a mutex that gets explicitly relaxed is not the same thing as
> we need to relax the lock each time we _might_ sleep. It means
> we relax more and that brings performance regressions.

At least in the cases where the decision is in reiserfs code
directly you could predict it by using need_resched(), couldn't you?

That might not be 100% accurate, but good enough.


> That said, if the general opinion is in favour of unmerging
> the bkl removal changes in reiserfs. Then please do.

For me it seems too aggressive at this point.

If it was just a case of fixing a few known bugs, but
if you're not even sure how many problems are left ...

Perhaps do the reiserfs35 variant?


> Just to express my point of view, as my primary goal is not
> to fix reiserfs but the kernel: If you are afraid of such
> changes, your kernel will just become mildewed by the time.

Better some mildew than a seriously-broken-for-enough people's 
release (although I have my doubts that's the right metapher
for the BKL anyways)

Having stable releases is an important part for
getting enough testers (we already have too little). And 
if we start breaking their $HOMEs they might become 
even less.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
