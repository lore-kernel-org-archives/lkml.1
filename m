Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbXFPODq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbXFPODq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 10:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbXFPODk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 10:03:40 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:9990 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbXFPODj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 10:03:39 -0400
Date: Sat, 16 Jun 2007 16:03:40 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: My kernel hangs again: Help with git please
Message-ID: <20070616140340.GA30861@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Daniel Barkalow <barkalow@iabervon.org>,
	linux-kernel@vger.kernel.org
References: <20070616001255.GA11403@alinoe.com> <Pine.LNX.4.64.0706152026320.4740@iabervon.org> <20070616040747.GA21076@alinoe.com> <Pine.LNX.4.64.0706160059210.4740@iabervon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706160059210.4740@iabervon.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 01:28:13AM -0400, Daniel Barkalow wrote:
> That's not actually the right image. There's a graph of commits with a lot 
> of splitting and joining lines. Each branch and each tag sits something in 
> this web. The difference between branches and tags is that you're expected 
> to move branch pointers around, and tags stay mostly in place. There's no 
> accounting of commits newer than the current spot in the web for a branch 
> belonging to that branch, so if you move a branch back to an older tag (or 
> other commit), the spot it's leaving is no longer "on the branch".

Okay, it took me two hours before I understood this... but here's the
picture that I have in mind now:

	   master->X        (merge point)
		  /|
		 / |
      ^ branch->3  X
 Time |         |  |
      |         2  X
		|  |
	        1  X
		|  |
		 \ |
		  \|
		   X        (branch point)
		   |

Then if I define a branch pointer to point to '3', then the branch is
3--2--1. If next I move the branch pointer to point to '2', node '3' is
no longer on the branch because now the branch exists of 2--1, and
HEAD moves to '2' as well.

This seems to make most sense in the light of your last sentence.
I don't understand how I'd have moved branch pointers however. I thought
I would just change my working copy along the branch by specifying
tag nodes. Ie, I have a branch '3'(--2--1) and I say: give me '2',
then give me '1' - and when I do: git reset --hard HEAD - it moves
me to 3 because the branch was never touched.

> So master is a point in the web, and bisect jumps around through the web 
> according to some special rules (due to having git-bisect use the good/bad 
> marks do determine which commit to try next, and jump there). git-bisect 
> doesn't really even care that you started on any single branch. It's just 
> operating on the web, and the branch you start on is treated as an 
> arbitrary commit that has the problem.

Ok - so it does something magical that I don't have to understand :P
The only thing that matters is that I choose the begin and end point,
the first two points, correctly: where one is bad and the other is good.
I seems that git bisect can't deal with swapping good/bad (the 'bad'
one always has to be the newest revision), so I had decided to call
'kernel hangs' good and 'kernel works' bad. The problem then is that
I can't find any starting point anymore that is 'bad'.

> You may find "gitk --all" informative.

The dates on the right side seem to make no sense. Even in a part
where there are no branches/merges at all, the date goes in both
direction (sometimes older, sometimes newer). Roughly it seems that
the newest date is at the top - but I see a lot of times things like:

|||O||  Description   Author1  2007-05-14 03:43:20
|||O||  Description   Author2  2007-05-15 15:10:34
|||O||  Description   Author3  2007-05-13 17:50:27

Thus, there seems to be no time related ordering :/

> It looks like you moved master back to 2.6.22-rc4 (with git reset --hard 
> v2.6.22-rc4) at some point.

Yup, I can see that in the gitk --all graph :)

> What you should do now is:
> 
> $ git checkout master
> $ git merge origin
> 
> Which should move master forward through the web to "origin", which is 
> (unless you've moved it) what you got from upsteam.

$ git merge origin
fatal: Needed a single revision
Usage: /usr/bin/git-merge [-n] [--no-commit] [--squash] [-s <strategy>]... <merge-message> <head> <remote>+

For some reason I don't think I should be needing commands that need
"<merge-message>"; I don't want to change the (local) tree in anyway.

Isn't there another way to just move master back to the HEAD of origin?

> Alternatively:
> 
> $ git checkout master
> $ git pull
> 
> Should fetch the latest stuff and advance master to the fetched version.

I'd rather first reproduce a working kernel - that should be possible
without pulling in more commits.

-- 
Carlo Wood <carlo@alinoe.com>
