Return-Path: <linux-kernel-owner+w=401wt.eu-S1751721Ab0ABUyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab0ABUyL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 15:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370Ab0ABUyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 15:54:10 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47643 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0ABUyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 15:54:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vwmecRGCKc+wghZcWAz/Qh3+bJC70rzVREOqXEy1bl4ZuygDLo6Cdvcey1GO34Lv6G
         GDxCsfOjMDGrAwN/Rvni60DdIb9uGHxY6ffKOhbCeonG5kkl5uTpyNXiWAio552+Ms5h
         aSkFha2v+e5x24xTF0f5MvHvOxk8fgF1F7cOo=
Date: Sat, 2 Jan 2010 21:54:04 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: reiserfs broken in 2.6.32 was Re: [GIT PULL] reiserfs fixes
Message-ID: <20100102205402.GG5076@nowhere>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com> <87bphc7heo.fsf@basil.nowhere.org> <20100102163644.GA5076@nowhere> <20100102174311.GA30016@basil.fritz.box> <20100102190213.GC5076@nowhere> <20100102192337.GB30016@basil.fritz.box> <20100102201138.GF5076@nowhere> <20100102203305.GC30016@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100102203305.GC30016@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 02, 2010 at 09:33:05PM +0100, Andi Kleen wrote:
> On Sat, Jan 02, 2010 at 09:11:39PM +0100, Frederic Weisbecker wrote:
> > I've never lost any datas since I began this work. And
> > I run it every day. If I had experienced lock inversions,
> > and sometimes soft lockups, I did not experienced serious
> > damages. It's a journalized filesystem that can fixup the things
> > pretty well.
> 
> So are you confident that 2.6.33 will not have regular soft-lockups
> for reiserfs users?



Yep.


 
> > 
> > Also we are talking about potential lock inversions, in potential
> > rare path, that could potentially raise soft lockups. That makes
> > a lot of potentials, for things that are going to be fixed and
> > for which I've never seen serious damages.
> 
> A soft lockup is a problem. Perhaps not totally serious,
> but a user who experiences them regularly would rightly consider
> such a release very broken.


If there will be softlockups, these will be rare.

The same risk apply to every new features in Linux (which
includes improvements in existing features).



> > We could make a new reiserfs version by duplicating the code
> > base. But nobody will test it. That would require to patch
> > mkreiserfs, waiting for distros to ship it, waiting for
> > users to ship the distros. Assuming at this time there
> > will be remaining users to set up new reiserfs partitions.
> 
> I suspect your estimates on how widely reiserfs is used 
> are quite off. However as usual a large part of the user
> base simply only uses what their distribution ships.


Sure, but few (none?) distributions continue to propose
reiserfs as a default.

I'm not telling there are no users anymore, I'm just telling
there won't be new users anymore.


> > We could also have a reiserfs-no-bkl config option that
> > would pick the duplicated code base. Again I fear few people
> > will test it.
> 
> That sounds reasonable, at least have a workaround if there
> are too many problems.


No, I'll be the only guy that is going to test it. This will
basically paralyze the progresses and once we'll merge it back
as the reiserfs 3 mainline, we'll have to face the same issues.

The only thing that makes this work progressing is the report done
by testers. Reviews on such a huge and complicated code base is
useful but is also strong in proving its own limits.


> > Sometimes I do. Sometimes it's just wasteful. We don't want to relax
> > the lock just because of a kmalloc(__GFP_NOFS).
> 
> If that's the problem you can always split the allocation:
> first try it with __GFP_NOWAIT without lock dropped, then
> if that fails do again with full __GFP_NOFS and lock drop.
> 
> However it's hard to believe that a few instructions
> more or less would make much difference; I would normally
> expect any larger changes coming from changes IO 
> patterns or cache line bouncing.


The problem is not there. Each sites where we are going to
sleep have to be treated as an isolated case. Should or shouldn't
we relax here? Depending on the case, it's sometimes wasteful to
relax even if we are going to block, sometimes it's useful to relax
even if it doesn't appear to be needed.

Only reviews proven by benchmarks can help. Which is what I did.
But blindly apply the "sleep if we are going to block on io or
something" is not always right.


> > > Better some mildew than a seriously-broken-for-enough people's 
> > > release (although I have my doubts that's the right metapher
> > > for the BKL anyways)
> > >
> > > Having stable releases is an important part for
> > > getting enough testers (we already have too little). And 
> > > if we start breaking their $HOMEs they might become 
> > > even less.
> > 
> > 
> > This is very unlikely to break their $HOME.
> 
> Well break access to their $HOME


Never experienced that.

