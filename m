Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbZIKXex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbZIKXex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 19:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbZIKXew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 19:34:52 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12433 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbZIKXew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 19:34:52 -0400
Date: Sat, 12 Sep 2009 01:34:54 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [GIT PULL] sched/core for v2.6.32
In-Reply-To: <alpine.LFD.2.01.0909111546050.3654@localhost.localdomain>
Message-ID: <alpine.LNX.2.00.0909120119190.31018@swampdragon.chaosbits.net>
References: <20090911192505.GA20006@elte.hu> <alpine.LNX.2.00.0909120032270.31018@swampdragon.chaosbits.net> <alpine.LFD.2.01.0909111546050.3654@localhost.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009, Linus Torvalds wrote:

> 
> 
> On Sat, 12 Sep 2009, Jesper Juhl wrote:
> > [...]
> > > Highlights:
> > > 
> > >  - Child-runs-first is now off - i.e. we run parent first.
> > >    [ Warning: this might trigger races in user-space. ]
> > [...]
> > 
> > Ouch. Do we dare do that?
> 
> We would want to at least try.
> 
> There are various reasons why we'd like to run the child first, ranging 
> from just pure latency (quite often, the child is the one that is 
> critical) to getting rid of page sharing for COW early thanks to execve 
> etc.
> 
> But similarly, there are various reasons to run the parent first, like 
> just the fact that we already have the state active in the TLB's and 
> caches.
> 
> Finally, we've never made any guarantees, because the timeslice for the 
> parent might be just about to end, so child-first vs parent-first is never 
> a guarantee, it's always just a preference.
> 
Sure. I'm aware that it has never been a guarantee. I'm just worried that 
userspace programs have come to rely on a certain behaviour and changing 
that behaviour may result in undesired results for some apps.
In a perfect world people would just fix those apps that (incorrectly) 
relied on a certain child-/parent-runs-first behaviour, but the world is 
not perfect, and many apps may not even have source available.


> [ And we _have_ had that preference expose user-level bugs. Long long ago 
>   we hit some problem with child-runs-first and 'bash' being unhappy about 
>   a really low-cost and quick child process exiting even _before_ bash 
>   itself had had time to fill in the process tables, and then when the 
>   SIGCHLD handler ran bash said "I got a SIGCHLD for something I don't 
>   even know about". 
> 
>   That was very much a bash bug, but it was a bash bug that forced us to
>   do 'parent-runs-first' for a while. So the heuristic can show problems ]
>
In some far off corner of my mind I think I actually remember that one... 
But, do we really want to risk that sort of problems again?  Since then 
Linux has moved from being a toy to being a first-class operating system 
that people use to do real work. And like it or not, most people who write 
apps do not read documentation, they do not read standards, they do not 
care how things are supposed to behave - they just see a certain behaviour 
when testing and assume that it is always so. Those people may be in for a 
nasty surprise with this change.  I'm not saying that people who assume 
specific behaviour that is not guaranteed are not wrong and that their 
code is not broken - all I'm saying is that we should have a pretty damn 
good reason for breaking their assumptions - if we can allow their 
assumptions to be true and their code to work without it costing us much, 
then I think we should...


> > vfork() is supposed to always run the child first.
> 
> vfork() has always run the child first, since the parent won't even be 
> runnable. The parent will get stuck in
> 
> 	wait_for_completion(&vfork);
> 
> so the "child-runs-first" is just an issue for regular fork or clone, not 
> vfork. For vfork there is never any question about it.
> 
Good. Then at least one can use vfork() if one knows that one needs 
child-runs-first semantics (and knows the differences between vfork() and 
fork()). Good to hear that that's not going to break - that would have 
been bad.

> > Most people I've talked to over the years assume that using fork(), the 
> > child runs first (yes, I know, that's not guaranteed, but people have come 
> > to believe that it is so and some may even depend on it).
> 
> It really hasn't been that way in Linux. We've done it both ways. 
> 
That may be so; but most people I've ever talked to about multiple 
processes, fork, vfork and the like, have mostly assumed child-runs-first.
That is just my personal experience.  
So I get worried when that assumption is made false.


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

