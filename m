Return-Path: <linux-kernel-owner+w=401wt.eu-S1422959AbXBAUIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422959AbXBAUIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 15:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422972AbXBAUIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 15:08:24 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33582 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422959AbXBAUIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 15:08:24 -0500
Date: Thu, 1 Feb 2007 12:07:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <20070201083611.GC18233@elte.hu>
Message-ID: <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Feb 2007, Ingo Molnar wrote:
> 
> there's almost no scheduling cost from being able to arbitrarily 
> schedule a kernel thread - but there are /huge/ benefits in it.

That's a singularly *stupid* argument.

Of course scheduling is fast. That's the whole *point* of fibrils. They 
still schedule. Nobody claimed anything else. 

Bringing up RT kernels and scheduling latency is idiotic. It's like saying 
"we should do this because the sky is blue". Sure, that's true, but what 
the *hell* does raleigh scattering have to do with anything?

The cost has _never_ been scheduling. That was never the point. Why do you 
even bring it up? Only to make an argument that makes no sense?

The cost of AIO is

 - maintenance. It'sa separate code-path, and it's one that simply doesn't 
   fit into anything else AT ALL. It works (mostly) for simple things, ie 
   reads and writes, but even there, it's really adding a lot of crud that 
   we could do without.

 - setup and teardown costs: both in CPU and in memory. These are the big 
   costs. It's especially true since a lot of AIO actually ends up cached. 
   The user program just wants the data - 99% of the time it's likely to 
   be there, and the whole point of AIO is to get at it cheaply, but not 
   block if it's not there.

So your scheduling arguments are inane. They totally miss the point. They 
have nothing to do with *anything*.

Ingo: everybody *agrees* that scheduling is cheap. Scheduling isn't the 
issue. Scheduling isn't even needed in the perfect path where the AIO 
didn't need to do any real IO (and that _is_ the path we actually would 
like to optimize most).

So instead of talking about totally irrelevant things, please keep your 
eyes on the ball.

So I claim that the ball is here:

 - cached data (and that is *espectally* true of some of the more 
   interesting things we can do with a more generic AIO thing: path 
   lookup, inode filling (stat/fstat) etc usually has hit-rates in the 99% 
   range, but missing even just 1% of the time can be deadly, if the miss 
   costs you a hundred msec of not doing anythign else!

   Do the math. A "stat()" system call generally takes on the other of a 
   couple of microseconds. But if it misses even just 1% of the time (and 
   takes 100 msec when it does that, because there is other IO also 
   competing for the disk arm), ON AVERAGE it takes 1ms. 

   So what you should aim for is improving that number. The cached case 
   should hopefully still be in the microseconds, and the uncached case 
   should be nonblocking for the caller.

 - setup/teardown costs. Both memory and CPU. This is where the current 
   threads simply don't work. The setup cost of doing a clone/exit is 
   actually much higher than the cost of doing the whole operation, most 
   of the time. Remember: caches still work.

 - maintenance. Clearly AIO will always have some special code, but if we 
   can move the special code *away* from filesystems and networking and 
   all the thousands of device drivers, and into core kernel code, we've 
   done something good. And if we can extend it from just pure read/write 
   into just about *anything*, then people will be happy.

So stop blathering about scheduling costs, RT kernels and interrupts. 
Interrupts generally happen a few thousand times a second. This is 
soemthing you want to do a *million* times a second, without any IO 
happening at all except for when it has to.

			Linus
