Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbYBLDcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbYBLDcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 22:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbYBLDcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 22:32:41 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47856 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751615AbYBLDcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 22:32:39 -0500
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
In-Reply-To: <20080212132306.6062910e.sfr@canb.auug.org.au>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	 <1202780209.3122.96.camel@localhost.localdomain>
	 <20080212132306.6062910e.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 21:32:33 -0600
Message-Id: <1202787153.3122.113.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 13:23 +1100, Stephen Rothwell wrote:
> Hi James,
> 
> On Mon, 11 Feb 2008 19:36:49 -0600 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >
> > On Tue, 2008-02-12 at 12:02 +1100, Stephen Rothwell wrote:
> > > 
> > > Andrew was looking for someone to run a linux-next tree that just
> > > contained the subsystem git and quilt trees for 2.6.x+1 and I (in a
> > > moment of madness) volunteered.  So, this is to announce the creating of
> > > such a tree (it doesn't exist yet) which will require some (hopefully)
> > > small amount of work on the part of subsystem maintainers.
> > 
> > Actually, it sort of does.  If you look here:
> 
> Yes, Andrew pointed me there and I should have mentioned it, sorry.
> 
> > http://www.kernel.org/pub/linux/kernel/people/jejb/merge-tree/
> > 
> > You'll find a merge candidate tree that builds nightly from everyone's
> > git and quilt trees.  I'm using it to track merge conflicts (so I only
> > build the patch, I don't check it compiles).
> > 
> > You're welcome to the scripts that do this:
> > 
> > http://www.kernel.org/pub/linux/kernel/people/jejb/build.pl
> > 
> > And the config file that runs it:
> > 
> > http://www.kernel.org/pub/linux/kernel/people/jejb/merge-tree-build
> > 
> > I don't plan to do much more than keep it building to check conflicts,
> > so you're welcome to take it over.
> 
> Thanks, they are very useful.
> 
> > > I hope to recreate this tree every day automatically.  In order to do
> > > this, any tree that has a conflict will be dropped from that days tree.
> > > The maintainer will be notified.  I hope to provide some clue as to what
> > > the conflict is with, but probably not initially.
> > 
> > Actually the experiment with the -mc tree shows that most of the
> > conflicts are trivial in nature (usually docbook stuff or
> > feature-removal.txt stuff), so you can do a trivial triage by hand.  You
> > can't automatically drop them (well, not unless you want to end up
> > dropping half the trees).
> 
> Well I did a trial run with the 40 git trees in the latest -mm and got
> only 6 conflicts (which actually were not trivial, unfortunately).  Of
> course, a lot of them have already been pulled into Linus' tree by now.

Hmm, OK  of the 46 I pull in, it's only xfs causing difficulties at the
moment.  Pre 2.6.24 being declared, we had about 10 fixups, all of which
were trivial except for one or two I got the subsystems to fix.

> > The other problem is that we actually maintain deliberate conflicts with
> > a last person to merge fixes it type attitude.  Again, it's usually in
> 
> I was hoping to be able to automatically find the other tree involved in
> a conflict and point both maintainers at the problem.  Also, there is
> always the possibility of reordering the trees ;-)

It's frequently just not possible.  There are a lot of global API
changes that sweep across subsystems.  For instance, I had a trivial
fixup script for scsi and net because of a netlink API change.

> > minor areas, and the fixups are fairly trivial, but it illustrates why
> > conflicts can't be a reason to drop a tree, you have to maintain some
> > sort of automatic fixup (at least I had to with the -mc tree).  The
> 
> OK, maybe if the conflict is trivial, we can do fixups.

Right .. it's really not possible to work without an infrastructure that
does this.

> > reason we do this is that it would give the maintainers a nasty web of
> > included trees (which is almost impossible for the quilt trees anyway)
> > if we tried to resolve the conflicts and destroy our ability to rebase.
> 
> I am hoping (one of Andrew's bugbears) that over time we will end up with
> several branches from git using trees (the vast majority) most of which
> are completely contained within their own subsystem and don't depend on
> anything but Linus' tree.  The conflicting and dependent branches will be
> merged later in the sequence.  Thus we will end up with a large amount of
> the tree becoming stable as the merge window approaches.  (Yes, sometimes
> I am an optimist :-))

We can't really do this.  We don't work in a utopian my area only
environment.  Almost every release cycle involves dealing with patches
that cross subsystem boundaries.  Often we try to minimise the problems
by taking patches from different subsystems via our trees to keep the
dependencies straight, but it does lead to conflicts.  Most of them are
ones we're aware of, and easily resolvable as the trees go in in the
merge window.  So any infrastructure that builds a unified tree has to
be aware of them too.

James


