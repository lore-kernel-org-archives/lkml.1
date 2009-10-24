Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbZJXIDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbZJXIDq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 04:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZJXIDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 04:03:45 -0400
Received: from thunk.org ([69.25.196.29]:36648 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbZJXIDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 04:03:39 -0400
Date: Sat, 24 Oct 2009 04:03:26 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Nicolas Pitre <nico@fluxnic.net>, "Luck, Tony" <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] to rebase or not to rebase on linux-next
Message-ID: <20091024080326.GA7461@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Nicolas Pitre <nico@fluxnic.net>,
	"Luck, Tony" <tony.luck@intel.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jeff Garzik <jeff@garzik.org>,
	Robert Richter <robert.richter@amd.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jean Delvare <khali@linux-fr.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20091022122042.e535d43c.sfr@canb.auug.org.au> <20091023112732.GB5886@elte.hu> <4AE19A74.1090709@garzik.org> <20091023123555.GA25366@elte.hu> <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com> <20091023134115.GD27097@elte.hu> <alpine.LFD.2.00.0910231424440.21460@xanadu.home> <20091023191631.GA1879@elte.hu> <1256326512.26028.34.camel@gandalf.stny.rr.com> <20091023205400.GA8356@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091023205400.GA8356@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 10:54:00PM +0200, Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Here's the basic gist, some people believe that linux-next is used as 
> > a dumping ground for their repos that get rebased all the time. They 
> > use linux-next for early testing, and mostly to make sure their repo 
> > will not collide with other developers repos.
> 
> I see signs of such an attitude, and i think it's somewhat harmful.
> 
> As far as using linux-next for a test-and-rebase workflow - IMO 
> maintainer trees should lead with a good example and should not push 
> 'avoidable crap that might need rebasing' into linux-next (knowingly at 
> least - there's enough unintentional damage) that they wouldnt push 
> upstream to Linus to begin with.

I think we need to be a bit careful in this discussion.  There are two
things that cause a particular git tree to be one which can't be used
as a the basis for subtrees.  One is "rebasing", where a series of
commits is dropped onto a new version, or base, hence "rebasing".  The
other is where one or more commits are *modified* --- perhaps to add
ack-ed by, or tested-by comment lines, or to improve comments, or to
fix outright bugs in the the patch series.  Perhaps it's better to
call this "rewinding", since in most cases this doesn't actually cause
a change in the "base" of the patch series.

The reason why it's important to make this distinction is that some of
the arguments about why constantly changing the base of a patch series
don't apply when we are just fixing up patches in the patch series or
git tree.

So given that, why do I think "rewinding" has a place as a development
methodology for patch sources that feed into linux-next.

1) Linux-next is by definition a constantly rewinding branch.  It is
thrown away and recreated every day, based on the tip of Linus's
mainline tree, and so the date of the merge commits means that you can
never base anything on top of linux-next.  This has always been the
case, and so trying to impose a straightjacket on all of the sources
of linux-next doesn't actually buy anything as far as the properties
of linux-next.

2) There are many legitimate reasons for "rewinding".  In addition to
being able to add credit for tested-by and acked-by lines, sometimes
patches are subtle.  More than once, patches have been sitting in the
ext4 tree that have passed the XFSQA test, and thus have been "unit
tested", but they still have bugs; in some cases, subtle bugs.  In
some cases, bugs that cause data corruption.  In the case where the
patches have hit linux-next, but the merge window hasn't opened yet, I
prefer to fix the patch by mutating it, and rewinding the ext4 tree,
instead of adding a fix later.  It makes it easier to cherry pick
patches to the stable tree later, and it keeps the ext4 tree clean,
and it has no downside in terms of linux-next --- see (1) above.

3) I don't have the same access to vast amounts of hardware and
platforms that Ingo does.  As a result, while I make a practice of
testing every single patch against the XFS test suite (yes, it's slow
and painful, but I think it's worth it; I'm very paranoid about patch
quality), every once in a while the patch has warnings or doesn't
compile on some platform for which I don't have build/test machines.
Today, this gets tested in linux-next, and when it does, if it the
merge window hasn't opened yet, I will fix it the patch instead of
creating an extra patch.  This helps git bisectability for platforms I
don't have access to.

4) The practice of rewinding and updating patches has a long and
honored history.  It's the way Andrew Morton has worked with
linux-mm/mmotm, for example.  And many patch series sources for
linux-next.  One argument which Ingo has advanced is perhaps those
subsystems shouldn't use git at all, and just use patch series.  I
think this is nonsense.  First of all, it's more convenient to deliver
patches to linux-next and Linus via git.  Secondly, sending a git pull
request *does* provide more information than just a patch series.  The
git pull request includes one critical bit of information --- the base
version that the maintainer has tested against, and that is preserved
when patches are delivered via a git pull request.  If the ext4 tree
was delievered via a patch series, then by definition when the patches
are applied, they will be rebased, in the proper sense of the term,
and you get all of the evils about *rebasing* (as opposed to rewinding
and fixing up patches) that people have complained about.  

Ultimately, one of the things that Linus has said recently, both at
LinuxCon and again at Kernel Summit, is on the whole he's very happy
with how the development process has been moving, and one the things
that he has pointed at is linux-next.  So I'd argue, let's not break
something that is working quite well.  Whether or not a particular
subsystem uses patch series, a rewinding git tree (using tools like
guilt or stgit), or an append-only git tree, is currently up to the
maintainer and the circumstances of how many developers participate in
a particular subsystem, and whether subtrees would actually be helpful
for that particular subsystem.  I don't think we should be imposing
straightjackets on maintainers.  What works well for one subsystem may
not work well for others.  And again, on the whole, Linus has said
that he's very pleased with how things are working today.  So maybe we
should leave well enough alone, and not try to impose a procrustean
bed on all maintainers.

Regards,

						- Ted
