Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbYEMP3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbYEMP3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbYEMP3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:29:05 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:57747 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbYEMP3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:29:04 -0400
Date: Tue, 13 May 2008 09:28:46 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080513152846.GI9324@parisc-linux.org>
References: <20080511132636.GA22878@parisc-linux.org> <20080511140017.GA2457@elte.hu> <20080511141818.GT19219@parisc-linux.org> <20080511144203.GB3220@elte.hu> <20080511144821.GW19219@parisc-linux.org> <20080511151909.GA3887@elte.hu> <20080511152942.GY19219@parisc-linux.org> <20080513141129.GC18798@elte.hu> <20080513142135.GF9324@parisc-linux.org> <20080513144207.GA4697@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513144207.GA4697@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 04:42:07PM +0200, Ingo Molnar wrote:
> yes, but even for parallel wakeups for completions it's good in general 
> to keep more tasks in flight than to keep less tasks in flight.

That might be the case for some users, but it isn't the case for XFS.
The first thing that each task does is grab a spinlock, so if you put as
much in flight as early as possible, you end up with horrible contention
on that spinlock.  I have no idea whether this is the common case for
multi-valued semaphores or not, it's just the only one I have data for.

> > So the only thing worth talking about (and indeed, it's now entirely 
> > moot) is what's the best way to solve this problem /for this kind of 
> > semaphore/.
> 
> it's not really moot in terms of improving the completions code i 
> suspect? For XFS i guess performance matters.

I think the completion code is less optimised than the semaphore code
today.  Clearly the same question does arise, but I don't know what the
answer is for completion users either.

Let's do a quick survey.  drivers/net has 5 users:

3c527.c -- execution_cmd has a mutex held, so never more than one task
waiting anyway.  xceiver_cmd is called during open and close which I think
are serialised at a higher level.  In any case, no performance issue here.

iseries_veth.c -- grabs a spinlock soon after being woken.

plip.c -- called in close, no perf implication.

ppp_synctty.c -- called in close, no perf implication.

ps3_gelic_wireless.c - If this isn't serialised, it's buggy.


Maybe drivers/net is a bad example.  Let's look at */*.c:

as-iosched.c -- in exit path.
blk-barrier.c -- completion on stack, so only one waiter.
blk-exec.c -- ditto
cfq-iosched.c -- in exit path

crypto/api.c -- in init path
crypto/gcm.c -- in setkey path
crypto/tcrypt.c -- crypto testing.  Not a perf path.

fs/exec.c -- waiting for coredumps.
kernel/exit.c -- likewise
kernel/fork.c -- completion on stack
kernel/kmod.c -- completion on stack 
kernel/kthread.c -- kthread creation and deletion.  Shouldn't be a hot
path, plus this looks like there's only going to be one task waiting.
kernel/rcupdate.c -- one completion on stack, one synchronised by a mutex
kernel/rcutorture.c -- doesn't matter
kernel/sched.c -- both completions on stack
kernel/stop_machine.c -- completion on stack
kernel/sysctl.c -- completion on stack
kernel/workqueue.c -- completion on stack

lib/klist.c -- This one seems like it could potentially have lots of
waiters, if only anything actually used klists.

It seems like most users use completions where it'd be just as easy
to use a task pointer and call wake_up_task().  In any case, I think
there's no evidence one way or the other about how people are using
multi-sleeper completions.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
