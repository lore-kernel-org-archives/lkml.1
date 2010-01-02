Return-Path: <linux-kernel-owner+w=401wt.eu-S1751834Ab0ABULn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab0ABULn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 15:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764Ab0ABULm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 15:11:42 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:22036 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab0ABULl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 15:11:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A4m94bd5l5Uje2rbeWtM1l5HEvMwfBB/YbLQVZ4PQz+u5bcIELphobKdakf9ye5cM3
         LCJpq448XT81v8skDLK9oXMP6OnltP70QuC7Sz8mT9X4iGoS0Ou5/+kdLUUIlAlb/zix
         q3NuAvRyMPfswUrP180ukz/ywfGpj7xlY/b4o=
Date: Sat, 2 Jan 2010 21:11:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: reiserfs broken in 2.6.32 was Re: [GIT PULL] reiserfs fixes
Message-ID: <20100102201138.GF5076@nowhere>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com> <87bphc7heo.fsf@basil.nowhere.org> <20100102163644.GA5076@nowhere> <20100102174311.GA30016@basil.fritz.box> <20100102190213.GC5076@nowhere> <20100102192337.GB30016@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100102192337.GB30016@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 02, 2010 at 08:23:37PM +0100, Andi Kleen wrote:
> On Sat, Jan 02, 2010 at 08:02:15PM +0100, Frederic Weisbecker wrote:
> > On Sat, Jan 02, 2010 at 06:43:12PM +0100, Andi Kleen wrote:
> > > > I only have reiserfs partitions in my laptop and my testbox,
> > > > nothing else. And that because I'm now maintaining it de facto.
> > > 
> > > AFAIK it's widely used in SUSE installations. It was the default
> > > for a long time.
> > > 
> > > And right now as in 2.6.32 it's in a state of
> > > "may randomly explode/deadlock". And no clear path out of it. Not good.
> > > 
> > > I am very concerned about destabilizing a widely used file system
> > > like this. This has the potential to really hurt users.
> > 
> > 
> > I understand your worries. And I've been very cautious with that,
> > waiting for three cycles before requesting an upstream merge. I did
> > it because the isolated tree model did not scale anymore.
> > 
> > Now that it's upstream, I get more testing and I expect that, in
> > the end of this cycle, I get most of these issues reported and
> > fixed.
> 
> Will you? 
> 
> How many users systems could it break by then?


I've never lost any datas since I began this work. And
I run it every day. If I had experienced lock inversions,
and sometimes soft lockups, I did not experienced serious
damages. It's a journalized filesystem that can fixup the things
pretty well.

Also we are talking about potential lock inversions, in potential
rare path, that could potentially raise soft lockups. That makes
a lot of potentials, for things that are going to be fixed and
for which I've never seen serious damages.

 
> > 
> > Serious users who run serious datas won't ship 2.6.33, they will ship
> > a further stable version 2.6.33.x (if they haven't converted their
> > filesystems already).
> > And at this time, things should be 99% fixed.
> 
> That seems very risky.  For some rarely used obscure subsystems
> that might work but a widely used file system that keeps people's $HOME? 
> I don't think seriously destabilizing that for a potentially longer
> time is a good idea. There's the potential to break
> a lot of porcelain.
> 
> Probably you could do a ext3/ext4 like thing by starting
> with a "reiserfs3.5" copy and do the work there and then
> merge back once things work and have been reasonably verified
> by code review.



I fear nobody else than me will review it that deeply, which
limits the scalability of this plan.

We could make a new reiserfs version by duplicating the code
base. But nobody will test it. That would require to patch
mkreiserfs, waiting for distros to ship it, waiting for
users to ship the distros. Assuming at this time there
will be remaining users to set up new reiserfs partitions.

We could also have a reiserfs-no-bkl config option that
would pick the duplicated code base. Again I fear few people
will test it.


> 
> > That's the theory. Fitting into this strict scheme brings performance
> > regressions. The bkl is a spinlock, it disables preemption, it is
> > relaxed on sleep, and doesn't have locking dependencies. Moreover
> > it's not a lock but a simulation of a NO_PREEMPT UP flow, with all
> > the fixup guardians that come with (fixup if we schedule, as
> > scheduling brings races).
> > 
> > From the conversion is borned a mutex. Even though we have
> > adaptive spinning, we don't catch up spinlock performances
> > as it's not a pure optimized looping fast path, and it may
> > actually just sleep.
> 
> Fix the adaptive spinlock then?



Believe me, I've reviewed the mutex code several dozens of time.
I just fail to find weaknesses inside, especially in the adaptive
spinning code.

We just can not make it as fast as a spinlock fast path, as it needs
to do regular checks to ensure it can continue to spin.


> > 
> > The bkl is relaxed only when we sleep. Now simulating that with
> > a mutex that gets explicitly relaxed is not the same thing as
> > we need to relax the lock each time we _might_ sleep. It means
> > we relax more and that brings performance regressions.
> 
> At least in the cases where the decision is in reiserfs code
> directly you could predict it by using need_resched(), couldn't you?
>
> 
> That might not be 100% accurate, but good enough.



Sometimes I do. Sometimes it's just wasteful. We don't want to relax
the lock just because of a kmalloc(__GFP_NOFS).

Sometimes relaxing the lock even when we are going to schedule is not
something we want for performances.

 
> 
> > That said, if the general opinion is in favour of unmerging
> > the bkl removal changes in reiserfs. Then please do.
> 
> For me it seems too aggressive at this point.
> 
> If it was just a case of fixing a few known bugs, but
> if you're not even sure how many problems are left ...
> 
> Perhaps do the reiserfs35 variant?


As explained above, I think this just reschedule the problem
for later. This model won't have any testers and won't evolve.



> 
> > Just to express my point of view, as my primary goal is not
> > to fix reiserfs but the kernel: If you are afraid of such
> > changes, your kernel will just become mildewed by the time.
> 
> Better some mildew than a seriously-broken-for-enough people's 
> release (although I have my doubts that's the right metapher
> for the BKL anyways)
>
> Having stable releases is an important part for
> getting enough testers (we already have too little). And 
> if we start breaking their $HOMEs they might become 
> even less.


This is very unlikely to break their $HOME.

