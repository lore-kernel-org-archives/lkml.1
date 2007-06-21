Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbXFUHaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbXFUHaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 03:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbXFUHar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 03:30:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47894 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbXFUHaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 03:30:46 -0400
Date: Thu, 21 Jun 2007 09:30:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070621073031.GA683@elte.hu>
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> In other words, spinlocks are optimized for *lack* of contention. If a 
> spinlock has contention, you don't try to make the spinlock "fair". 
> No, you try to fix the contention instead!

yeah, and if there's no easy solution, change it to a mutex. Fastpath 
performance of spinlocks and mutexes is essentially the same, and if 
there's any measurable contention then the scheduler is pretty good at 
sorting things out. Say if the average contention is longer than 10-20 
microseconds then likely we could already win by scheduling away to some 
other task. (the best is of course to have no contention at all - but 
there are causes where it is real hard, and there are cases where it's 
outright unmaintainable.)

Hw makers are currently producing transistors disproportionatly faster 
than humans are producing parallel code, as a result of which we've got 
more CPU cache than ever, even taking natural application bloat into 
account. (it just makes no sense to spend those transistors on 
parallelism when applications are just not making use of it yet. Plus 
caches are a lot less power intense than functional units of the CPU, 
and the limit these days is power input.)

So scheduling more frequently and more agressively makes more sense than 
ever before and that trend will likely not stop for some time to come. 

> The patch I sent out was an example of that. You *can* fix contention 
> problems. Does it take clever approaches? Yes. It's why we have hashed 
> spinlocks, RCU, and code sequences that are entirely lockless and use 
> optimistic approaches. And suddenly you get fairness *and* 
> performance!

what worries me a bit though is that my patch that made spinlocks 
equally agressive to that loop didnt solve the hangs! So there is some 
issue we dont understand yet - why was the wait_inactive_task() 
open-coded spin-trylock loop starving the other core which had ... an 
open-coded spin-trylock loop coded up in assembly? And we've got a 
handful of other open-coded loops in the kernel (networking for example) 
so this issue could come back and haunt us in a situation where we dont 
have a gifted hacker like Miklos being able to spend _weeks_ to track 
down the problem...

	Ingo
