Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbZIKW71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbZIKW71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbZIKW71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:59:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343AbZIKW70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:59:26 -0400
Date: Fri, 11 Sep 2009 15:58:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesper Juhl <jj@chaosbits.net>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [GIT PULL] sched/core for v2.6.32
In-Reply-To: <alpine.LNX.2.00.0909120032270.31018@swampdragon.chaosbits.net>
Message-ID: <alpine.LFD.2.01.0909111546050.3654@localhost.localdomain>
References: <20090911192505.GA20006@elte.hu> <alpine.LNX.2.00.0909120032270.31018@swampdragon.chaosbits.net>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Sep 2009, Jesper Juhl wrote:
> [...]
> > Highlights:
> > 
> >  - Child-runs-first is now off - i.e. we run parent first.
> >    [ Warning: this might trigger races in user-space. ]
> [...]
> 
> Ouch. Do we dare do that?

We would want to at least try.

There are various reasons why we'd like to run the child first, ranging 
from just pure latency (quite often, the child is the one that is 
critical) to getting rid of page sharing for COW early thanks to execve 
etc.

But similarly, there are various reasons to run the parent first, like 
just the fact that we already have the state active in the TLB's and 
caches.

Finally, we've never made any guarantees, because the timeslice for the 
parent might be just about to end, so child-first vs parent-first is never 
a guarantee, it's always just a preference.

[ And we _have_ had that preference expose user-level bugs. Long long ago 
  we hit some problem with child-runs-first and 'bash' being unhappy about 
  a really low-cost and quick child process exiting even _before_ bash 
  itself had had time to fill in the process tables, and then when the 
  SIGCHLD handler ran bash said "I got a SIGCHLD for something I don't 
  even know about". 

  That was very much a bash bug, but it was a bash bug that forced us to 
  do 'parent-runs-first' for a while. So the heuristic can show problems ]

> vfork() is supposed to always run the child first.

vfork() has always run the child first, since the parent won't even be 
runnable. The parent will get stuck in

	wait_for_completion(&vfork);

so the "child-runs-first" is just an issue for regular fork or clone, not 
vfork. For vfork there is never any question about it.

> Most people I've talked to over the years assume that using fork(), the 
> child runs first (yes, I know, that's not guaranteed, but people have come 
> to believe that it is so and some may even depend on it).

It really hasn't been that way in Linux. We've done it both ways. 

			Linus
