Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbYBMDc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbYBMDc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 22:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYBMDcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 22:32:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57912 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752078AbYBMDcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 22:32:16 -0500
Date: Tue, 12 Feb 2008 19:31:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: David Miller <davem@davemloft.net>, jeff@garzik.org, arjan@infradead.org,
       greg@kroah.com, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <1202871616.3137.197.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.00.0802121904270.2920@woody.linux-foundation.org>
References: <47B1CB08.4020101@garzik.org>  <20080212.155853.193190548.davem@davemloft.net>  <alpine.LFD.1.00.0802121610220.2920@woody.linux-foundation.org>  <20080212.172051.58554658.davem@davemloft.net>  <1202869550.3137.182.camel@localhost.localdomain> 
 <alpine.LFD.1.00.0802121832000.2920@woody.linux-foundation.org> <1202871616.3137.197.camel@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, James Bottomley wrote:
> 
> Right at the moment, I maintain a <branch> and a <branch>-base and
> simply cherry pick the commits between the two to do the right thing
> when I know my volatile base has changed.  It would be very helpful to
> have a version of rebase that new my base had been rebased.

Hey, I know, you could use.. drumroll..

	"git rebase"

I know that's a big leap of faith, to use git rebase for rebasing, but 
there you have it. Us git people are kind of odd that way.

IOW, if you know the old broken base, and the new base, just do

	git rebase --onto newbase oldbase

and it should do exactly that (basically lots of automated cherry-picks).

[ But the fact is, if you did anything fancy (like pulled in other peoples 
  work), you cannot sanely rebase _those_ peoples work. They didn't screw 
  up to begin with! You can play with "git rebase -i --preserve-merges", 
  of course, but I really think you're doing something wrong if you start 
  pulling other peoples work into an unstable thing, so while it may work, 
  I'd strongly suggest against even trying, because the problem is your 
  workflow ]

So let's say that you have a remote branch that you track that goes 
rebasing (let's call it "origin/pu" to match the real-life git behaviour), 
then you should literally be able to do

	old=$(git rev-parse origin/pu)	&&
	git fetch			&&
	new=$(git rev-parse origin/pu)	&&
	git rebase --onto $new $old

and no, I didn't actually test it, but hey, it really should be that 
simple.

[ And no, you don't really need to do those "old=" and "new=" things, they 
  are there to make it explicit - you could easily just have done

	git fetch
	.. oh, noticed that origin/pu changed ..
	git rebase --onto origin/pu origin/pu@{1}

  where we just let git take care of the old/new itself using the reflog, 
  so that "origin/pu@{1}" assumes that you just know that the only thing 
  that has changed origin/pu was that previous "git fetch", and that 
  really *did* change it. ]

In other words, git does give you exactly what you want, but nothing 
really changes the fact that you should only rebase like this only if:

 - you haven't already exported the result (or only exported it as those 
   unstables branches that people know to avoid)

 - your changes on top are just your own linear series of commits (where 
   "applying a patch from somebody else" is still _your_ commit, of 
   course, just with authorship attributed to somebody else)

so that part really is very fundamental.

			Linus
