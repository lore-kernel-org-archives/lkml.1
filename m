Return-Path: <linux-kernel-owner+w=401wt.eu-S1161173AbXCAXkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161173AbXCAXkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 18:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161195AbXCAXkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:40:22 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54283 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161173AbXCAXkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:40:21 -0500
Date: Thu, 1 Mar 2007 15:36:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: 2.6.21-rc1: known regressions (part 2)
In-Reply-To: <20070301104117.GA22788@elte.hu>
Message-ID: <Pine.LNX.4.64.0703011510130.12485@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
 <20070225175559.GC12392@stusta.de> <20070227100202.GV3822@kernel.dk>
 <20070227102109.GG6745@elf.ucw.cz> <20070227103021.GA2250@kernel.dk>
 <20070227103407.GA17819@elte.hu> <20070227105922.GD2250@kernel.dk>
 <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu>
 <20070301104117.GA22788@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Mar 2007, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > update: f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38 works for me too, and 
> > 01363220f5d23ef68276db8974e46a502e43d01d is broken. I too will attempt 
> > to bisect this.
> 
> hm. There's some weird bisection artifact here. Here are the commits i 
> tested, in git-log order:
> 
> #1 commit 01363220f5d23ef68276db8974e46a502e43d01d bad
> #2 commit ee404566f97f9254433399fbbcfa05390c7c55f7 bad
> #3 commit f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38 good
> #4 commit c827ba4cb49a30ce581201fd0ba2be77cde412c7 bad

Use "git bisect visualize" to see what bisect ends up doing.

> if i tell git-bisect that #1 is bad and #3 is good, then it offers me #2 
> - that's OK. But when i tell it that #2 is bad, it offers #4 - which is 
> out of order!

No it's not. "git bisect" does exactly the right thing. There is no simple 
ordering in a complex branch-merge schenario, you can't just put the 
commits in some "ordering" and test things in time order. That would be 
totally broken, and idiotic. It doesn't give the right results.

What git bisect does is to find the commit that most closely *bisects* the 
history of commits, so that if it is marked good/bad, it will leave you 
with about 50% of the commits left. But if you are looking at date order, 
you're entirely confused.

For example, let's take a really simple case

	    a <- bad
	   / \
          b   c
	  |   |
	  d   e
	  |   |
	  f   g
	   \ /
	    h
            |
	    * <-good

and if you are looking to find something "in the middle", you might thing 
that "d" or "e" are the best choices, since time-wise, they are in the 
middle.

But that's not true AT ALL.

If you actually want to bisect that kind of history, you need to choose 
"b" or "c", even though they may both be *much* more "recent" than the 
others. Why? Because if you pick "d", you're really only testing three 
commits ('d' 'f' and 'h') out of the 8 commits you have to test.

In contrast, if you pick 'b', you are testing the effects of *four* 
commits ('b', 'd', 'f' and 'h') and you have thus neatly bisected the 
commits into two equal groups for testing (one group _with_ those four 
commits, and one group _without_) instead of having partitioned them as 3 
commits vs 5 commits.

So please realize that non-linear history very much means that you MUST 
NOT think that you just pick a commit "in the middle". No, git bisect is a 
LOT smarter than that - it picks a commit that *reaches* about half the 
commits you have left to test.

> The bisection goes off into la-la land after that and 
> never gets back to a commit that is /after/ the good commit. How is this 
> possible? (I upgraded from git-1.4.4 to 1.5.0 to make sure this isnt 
> some git bug that's already fixed.)

It's possible because git knows what it is doing, and you didn't think 
things through.

The commits that "git bisect" picked out are the right ones. Quite often, 
there may be two or more "equally good" commits (in my example above, you 
can choose either "b" or "c", and it will bisect the set of untested 
commits equally well - in two groups of four, but two *different* groups 
of four commits), and yes, it's possible that git has a bug that makes it 
pick the wrong ones, but quite frankly, I seriously doubt it. "git bisect" 
has been very successful indeed, and is generally a *lot* better at 
picking a commit "in the middle" than people are, exactly because it's 
quite hard to see which commit "reaches" half the commits if you have lots 
of merges and branches.

Try out

	git bisect visualize

and it will literally show you what it is doing.

What can be confusing is that if the "good" and "bad" markers are ON 
DIFFERENT BRANCHES OF DEVELOPMENT, you may not even *see* the "good" 
marker, because you may well have something like this:


	a <- bad
	|
	b   * <- good
	|   |
	c   d
	 \ /
	  e
	  |
	  f
	  |
	 ...

and what do you think "git bisect visualize" will actually show you?

Since 'd', 'e' and 'f' are all in the "good" set (they both exist as 
commits in something leading up to a commit that has already been deemed 
fine), they aren't *interesting* - they can't be introducing the bug, 
since if that was the case, the good commit wouldn't have been good. So as 
far as bisection is concerned, the tree actually looks like

	 a <- bad
	 |
	 b
	 |
	 c
	 |
	...

and you have just three commits that are potentially interesting: 'a', 'b' 
and 'c'.

Now, with three commits, you cannot test them half-and-half, so you have 
to test it in groups of 1 vs 2 commits, so it's arbitrary whether you 
choose 'b' or 'c' to test, but you'd test one of them. Say that you choose 
'b', and it turns out to be good. If so, you're done: 'a' is bad and 'b' 
is good, so the bug was introduced in 'a'. But if it turns out to be bad, 
you'll still have to test 'c' too, since you don't know if the bug was 
*introduced* in 'b' or not.

See? 

> i'll try to straighten this out manually

Don't. You're just going to make your bisection much less effective. The 
whole point of bisection is that you can usually cut the number of commits 
to test pretty exactly in half.  If you start mucking with the commits to 
test, and you don't understand about the reachability graph, you'll just 
choose a much worse set of commits to test than "git bisect" will do.

So learn to trust "git bisect". It really does know what it is doing.

		Linus
