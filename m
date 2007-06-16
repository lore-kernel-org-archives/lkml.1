Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbXFPTNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbXFPTNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 15:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbXFPTNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 15:13:12 -0400
Received: from iabervon.org ([66.92.72.58]:3276 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510AbXFPTNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 15:13:11 -0400
Date: Sat, 16 Jun 2007 15:13:08 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Carlo Wood <carlo@alinoe.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: My kernel hangs again: Help with git please
In-Reply-To: <20070616140340.GA30861@alinoe.com>
Message-ID: <Pine.LNX.4.64.0706161408040.4740@iabervon.org>
References: <20070616001255.GA11403@alinoe.com> <Pine.LNX.4.64.0706152026320.4740@iabervon.org>
 <20070616040747.GA21076@alinoe.com> <Pine.LNX.4.64.0706160059210.4740@iabervon.org>
 <20070616140340.GA30861@alinoe.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jun 2007, Carlo Wood wrote:

> On Sat, Jun 16, 2007 at 01:28:13AM -0400, Daniel Barkalow wrote:
> > That's not actually the right image. There's a graph of commits with a lot 
> > of splitting and joining lines. Each branch and each tag sits something in 
> > this web. The difference between branches and tags is that you're expected 
> > to move branch pointers around, and tags stay mostly in place. There's no 
> > accounting of commits newer than the current spot in the web for a branch 
> > belonging to that branch, so if you move a branch back to an older tag (or 
> > other commit), the spot it's leaving is no longer "on the branch".
> 
> Okay, it took me two hours before I understood this... but here's the
> picture that I have in mind now:
> 
> 	     master->X        (merge point)
> 		    /|
> 		   / |
>       ^ branch->3  X
>  Time |         |  |
>       |         2  X
> 		  |  |
> 	          1  X
> 		  |  |
> 		   \ |
> 		    \|
> 		     X        (branch point)
> 		     |

Right, except that, in your repository, "master" has ended up pointing to 
"3" also. Or, in any case, all of your local branches ("master" is no 
different from other branches, except that it's the initial default name 
for a branch) are somewhere down the web from the latest stuff from 
Linus's repositry.

> Then if I define a branch pointer to point to '3', then the branch is
> 3--2--1. If next I move the branch pointer to point to '2', node '3' is
> no longer on the branch because now the branch exists of 2--1, and
> HEAD moves to '2' as well.

Right, except that "HEAD" is really just a symlink, not a pointer 
directly to the history; the branch it points to is what you've got in 
your working directory currently. So in that case, HEAD moves to '2' 
simply because it's indirection for branch, which has moved to 2.

Side note: in more recent versions of git, there's the feature that you 
seem to be trying to use. It's called "detatched HEAD", and means that you 
can have HEAD be some arbitrary commit, not a link to a branch. You'd do 
this with "git checkout <some revision>", and then your working directory 
would match that revision, and "git branch" would have no *, and you 
wouldn't have a current branch at all, and you wouldn't be moving branch 
pointers around. But I don't think you're using a version of git that 
supports this, and you need to get your branch pointers back to the 
present anyway.

> This seems to make most sense in the light of your last sentence.
> I don't understand how I'd have moved branch pointers however. I thought
> I would just change my working copy along the branch by specifying
> tag nodes. Ie, I have a branch '3'(--2--1) and I say: give me '2',
> then give me '1' - and when I do: git reset --hard HEAD - it moves
> me to 3 because the branch was never touched.

git reset --hard <revision> moves the current branch to that revision, as 
well as moving the working directory (and the index, which doesn't matter 
for your case). If you were thinking that it only changed the working 
directory, you probably moved some branches without realizing it.

> > So master is a point in the web, and bisect jumps around through the web 
> > according to some special rules (due to having git-bisect use the good/bad 
> > marks do determine which commit to try next, and jump there). git-bisect 
> > doesn't really even care that you started on any single branch. It's just 
> > operating on the web, and the branch you start on is treated as an 
> > arbitrary commit that has the problem.
> 
> Ok - so it does something magical that I don't have to understand :P
> The only thing that matters is that I choose the begin and end point,
> the first two points, correctly: where one is bad and the other is good.
> I seems that git bisect can't deal with swapping good/bad (the 'bad'
> one always has to be the newest revision), so I had decided to call
> 'kernel hangs' good and 'kernel works' bad. The problem then is that
> I can't find any starting point anymore that is 'bad'.

Right; since the normal goal is to find regressions, not fixes, "bad" is 
the "after it changed" case, and "good" is the "before it changed". It is 
trying to find a commit which all of the "bad" commits are descended from, 
and which is descended from only "good" commits.

> > You may find "gitk --all" informative.
> 
> The dates on the right side seem to make no sense. Even in a part
> where there are no branches/merges at all, the date goes in both
> direction (sometimes older, sometimes newer). Roughly it seems that
> the newest date is at the top - but I see a lot of times things like:
> 
> |||O||  Description   Author1  2007-05-14 03:43:20
> |||O||  Description   Author2  2007-05-15 15:10:34
> |||O||  Description   Author3  2007-05-13 17:50:27
> 
> Thus, there seems to be no time related ordering :/

Those dates are when the patches which became the commits were written. 
The ordering is the lineage of the revisions in the repository. 
Additionally, people's clocks can be wrong, and people may be in different 
time zones (I'm not sure whether gitk shows the author's time zone or your 
time zone; both pieces of information are available, and both can be 
interesting). In any case, the choice of which date to show is to provide 
information that's not implied by the ordering of the items.

What the ordering of items tells you is that, if you check out that middle 
commit, and they're all on the same line, the change in the bottom commit 
will be represented and the change in the top commit won't; in the 
perspective on the project's history encoded in the repository, the middle 
change was applied on top of the bootm one, and the top one was applied on 
top of that. (Even though we know the authors of those changes were 
working independantly, probably based on some older revision)

> > What you should do now is:
> > 
> > $ git checkout master
> > $ git merge origin
> > 
> > Which should move master forward through the web to "origin", which is 
> > (unless you've moved it) what you got from upsteam.
> 
> $ git merge origin
> fatal: Needed a single revision
> Usage: /usr/bin/git-merge [-n] [--no-commit] [--squash] [-s <strategy>]... <merge-message> <head> <remote>+
> 
> For some reason I don't think I should be needing commands that need
> "<merge-message>"; I don't want to change the (local) tree in anyway.
> 
> Isn't there another way to just move master back to the HEAD of origin?

Ah, the syntax of git-merge changed at some point. Try, instead, the less 
intuitive "git pull . origin". Or "git reset --hard refs/heads/origin" or 
maybe "git reset --hard refs/remotes/origin/master".

When you merge something in git, if the other side is a descendant of your 
current point, it just moves your current point to the point the other 
side is at, and doesn't use the message. This is called a "fast-forward 
merge", because it makes your branch be at a point descended from both the 
old value of your branch and the other side (that being the important 
feature of a "merge"), but it does it without creating anything new, 
because an existing commit was sufficient. So, if you expect that you're 
moving strictly forward in history, you can do this by asking for a merge. 
(But the program called "git merge" in the version you have actually 
doesn't do fast-forwards, sort of confusingly; in later versions, things 
have been rearranged somewhat. In your version, you have to ask to pull in 
changes from your own copy of the repository in order to trigger the 
fast-forward logic.)

> > Alternatively:
> > 
> > $ git checkout master
> > $ git pull
> > 
> > Should fetch the latest stuff and advance master to the fetched version.
> 
> I'd rather first reproduce a working kernel - that should be possible
> without pulling in more commits.

Sure. Hopefully, newer things haven't broken anything else (or the same 
thing again), but it's good to get everything sane first. But if you find 
you've lost all trace of what you'd gotten (if "origin" also got moved, 
for example), you can just get the latest mainline. There's also "git 
lost+found" which can recover bits of history that have been completely 
lost from your local repository, but that's probably more trouble than 
it's worth.

	-Daniel
*This .sig left intentionally blank*
