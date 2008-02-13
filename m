Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbYBMAp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbYBMAp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYBMApT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:45:19 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40430 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751230AbYBMApQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:45:16 -0500
Date: Tue, 12 Feb 2008 16:44:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: jeff@garzik.org, arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <20080212.155853.193190548.davem@davemloft.net>
Message-ID: <alpine.LFD.1.00.0802121610220.2920@woody.linux-foundation.org>
References: <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <20080212.155853.193190548.davem@davemloft.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, David Miller wrote:
> 
> At 1500 changesets, a merge conflict shows up about once
> every day or two as 2.6.N nears it's release into final
> as bug fixes trickle in.
> 
> I find using GIT to fixup merge errors on a tree of that
> scale to be really painful.  And it only fixes up the final
> result in a merge changeset.

Heh. I've had the reverse situation: "git rebase" often results in *more* 
conflicts than "git merge" (ie "pull").

But one issue is also that when conflicts happen, different people are 
used to different things. I'm particularly used to merge-type conflicts, 
and in fact there's some fairly advanced support in git for helping 
resolve them that people who *don't* do merge-level conflict resolution 
may not even be aware of.

In particular, if you want to try it, do something that conflicts and then 
do

	gitk --merge

to see what the conflict is all about. That is just fancy shorthand for

	gitk HEAD...MERGE_HEAD -- <list of conflicting files>

so what it does is to show only the relevant history (the three dots means 
that it's a _symmetric_ set difference from HEAD to MERGE_HEAD) for the 
merge, and only for the particular files that had conflicts!

This often means that even when you merge a thousand commits (or the thing 
you merge *into* has thousands of commits since the merge base, which is 
the common case for me), you actually only see a couple of commits - only 
the ones that actually modified the conflicting files!

(If you have many files that conflict, you can further narrow it down to 
just one at a time by explicitly listing the file/directory you want to 
work on, ie do "gitk --merge <pathname-here>").

> Let me give you a good example, just yesterday I had to rebase
> my net-2.6 tree a few times.  It's because I put a patch in there
> that the person said was OK but it broke the build.  There is
> zero reason for me to push that tree to Linus with the bad
> commit and the revert, it's just noise and makes the tree harder
> for people to review.

Actually, better than rebase in that situation is to just remove the bad 
commit. Yes, you'd use "rebase" for it, but you'd use it not to move the 
whole series to a newer place, you'd use it just to rebase the commits 
*after* the commit you remove.

This is something where I actually think git could and should do better: 
git has the capability to act as more of a "quilt replacement", but 
because it wasn't part of the original design, we never actualy exposed 
the simple queue management commands to do this (stgit does things like 
that, though).

So if you haven't pushed out, right now you'd have to do this stupid 
thing:

	[ start (and activate) a 'fixup' branch at X ]
	git checkout -b fixup X

	[ edit edit edit to fix it up ]
	..

	[ commit the fixed state ]
	git commit --amend 

	[ go back to the old broken state ]
	git checkout master

	[ now, rebase 'master' on top of the fix ]
	git rebase fixup

	[ ok, done, forget the fixup branch ]
	git branch -d fixup

and I don't discourage this kind of behaviour at all, but it is only good 
iff:

 - you have not pushed things out (obviously), so nobody ever even notices 
   that you've fixed up stuff

 - you haven't pulled anything from outside (so you aren't trying to 
   rebase other peoples commits).

   If you *really* want to try to do this even across merges you've done, 
   there is fancy a "--preserve-merges" thing that you can try to use 
   (needs "-i" to work, but "-i" is often cool for other reasons too!)

Basically, what I'm trying to say is that "git rebase" can be used in 
fancy ways to do things that people outside your repository will never 
even *know* were done. It's only when outsiders can see the effects of git 
rebase that you're in trouble!

			Linus
