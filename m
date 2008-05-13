Return-Path: <linux-kernel-owner+w=401wt.eu-S1760850AbYEMRO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850AbYEMRO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759855AbYEMROg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:14:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33073 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758502AbYEMROf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:14:35 -0400
Date: Tue, 13 May 2008 19:13:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080513171352.GE22348@elte.hu>
References: <20080511140017.GA2457@elte.hu> <20080511141818.GT19219@parisc-linux.org> <20080511144203.GB3220@elte.hu> <20080511144821.GW19219@parisc-linux.org> <20080511151909.GA3887@elte.hu> <20080511152942.GY19219@parisc-linux.org> <20080513141129.GC18798@elte.hu> <20080513142135.GF9324@parisc-linux.org> <20080513144207.GA4697@elte.hu> <20080513152846.GI9324@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513152846.GI9324@parisc-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Wilcox <matthew@wil.cx> wrote:

> > yes, but even for parallel wakeups for completions it's good in 
> > general to keep more tasks in flight than to keep less tasks in 
> > flight.
> 
> That might be the case for some users, but it isn't the case for XFS. 
> The first thing that each task does is grab a spinlock, so if you put 
> as much in flight as early as possible, you end up with horrible 
> contention on that spinlock. [...]

hm, this sounds like damage that is inflicted on itself by the XFS code. 

Why does it signal to its waiters that "resource is available", when in 
reality that resource is not available but immediately serialized via a 
lock? (even if the lock might technically be some _other_ object)

I have not looked closely at this but the more natural wakeup flow here 
would be that if you know there's going to be immediate contention, to 
signal a _single_ resource to a _single_ waiter, and then once that 
contention point is over a (hopefully) much more parallel processing 
phase occurs, to use a multi-value completion there.

in other words: dont tell the scheduler that there is parallelism in the 
system when in reality there is not. And for the same reason, do not 
throttle wakeups in a completion mechanism artificially because one 
given user utilizes it suboptimally. Once throttled it's not possible to 
regain that lost parallelism.

> [...] I have no idea whether this is the common case for multi-valued 
> semaphores or not, it's just the only one I have data for.

yeah. I'd guess XFS would be the primary user in this area who cares 
about performance.

> It seems like most users use completions where it'd be just as easy to 
> use a task pointer and call wake_up_task(). [...]

yeah - although i guess in general it's a bit safer to use an explicit 
completion. With a task pointer you have to be sure the task is still 
present, etc. (with a completion you are forced to put that completion 
object _somewhere_, which immediately forces one to think about lifetime 
issues. A wakeup to a single task pointer is way too easy to get wrong.)

So in general i'd recommend the use of completions.

> [...] In any case, I think there's no evidence one way or the other 
> about how people are using multi-sleeper completions.

yeah, that's definitely so.

	Ingo
