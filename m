Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbYBJF2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbYBJF2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 00:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbYBJF2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 00:28:01 -0500
Received: from lixom.net ([66.141.50.11]:40871 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbYBJF2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 00:28:00 -0500
Date: Sat, 9 Feb 2008 23:29:41 -0600
From: Olof Johansson <olof@lixom.net>
To: Willy Tarreau <w@1wt.eu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived
	threads
Message-ID: <20080210052941.GA4731@lixom.net>
References: <20080209000456.GA21021@lixom.net> <1202543920.9578.3.camel@homer.simson.net> <20080209080319.GO8953@1wt.eu> <1202554705.10287.12.camel@homer.simson.net> <20080209114009.GP8953@1wt.eu> <1202564259.4035.18.camel@homer.simson.net> <20080209161957.GA3364@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080209161957.GA3364@1wt.eu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 05:19:57PM +0100, Willy Tarreau wrote:
> On Sat, Feb 09, 2008 at 02:37:39PM +0100, Mike Galbraith wrote:
> > 
> > On Sat, 2008-02-09 at 12:40 +0100, Willy Tarreau wrote: 
> > > On Sat, Feb 09, 2008 at 11:58:25AM +0100, Mike Galbraith wrote:
> > > > 
> > > > On Sat, 2008-02-09 at 09:03 +0100, Willy Tarreau wrote:
> > > > 
> > > > > How many CPUs do you have ?
> > > > 
> > > > It's a P4/HT, so 1 plus $CHUMP_CHANGE_MAYBE
> > > > 
> > > > > > 2.6.25-smp (git today)
> > > > > > time 29 ms
> > > > > > time 61 ms
> > > > > > time 72 ms
> > > > > 
> > > > > These ones look rather strange. What type of workload is it ? Can you
> > > > > publish the program for others to test it ?
> > > > 
> > > > It's the proglet posted in this thread.
> > > 
> > > OK sorry, I did not notice it when I first read the report.
> > 
> > Hm.  The 2.6.25-smp kernel is the only one that looks like it's doing
> > what proggy wants to do, massive context switching.  Bump threads to
> > larger number so you can watch: the supposedly good kernel (22) is doing
> > everything on one CPU.  Everybody else sucks differently (idleness), and
> > the clear throughput winner, via mad over-schedule (!?!), is git today.
> 
> For me, 2.6.25-smp gives pretty irregular results :
> 
> time 6548 ms
> time 7272 ms
> time 1188 ms
> time 3772 ms
> 
> The CPU usage is quite irregular too and never goes beyond 50% (this is a
> dual-athlon). If I start two of these processes, 100% of the CPU is used,
> the context switch rate is more regular (about 700/s) and the total time
> is more regular too (between 14.8 and 18.5 seconds).
> 
> Increasing the parallel run time of the two threads by changing the upper
> limit of the for(j) loop correctly saturates both processors. I think that
> this program simply does not have enough work to do for each thread to run
> for a full timeslice, thus showing a random behaviour.

Right. I should have tinkered a bit more with it before I posted it, the
version posted had too little going on in the first loop and thus got
hung up on the second busywait loop instead.

I did a bunch of runs with various loop sizes. Basically, what seems to
happen is that the older kernels are quicker at rebalancing a new thread
over to the other cpu, while newer kernels let them share the same cpu
longer (and thus increases wall clock runtime).

All of these are built with gcc without optimization, larger loop size
and an added sched_yield() in the busy-wait loop at the end to take that
out as a factor. As you've seen yourself, runtimes can be quite noisy
but the trends are quite clear anyway. All of these numbers were
collected with default scheduler runtime options, same kernels and
configs as previously posted.

Loop to 1M:
2.6.22		time 4015 ms
2.6.23		time 4581 ms
2.6.24		time 10765 ms
2.6.24-git19	time 8286 ms

2M:
2.6.22		time 7574 ms
2.6.23		time 9031 ms
2.6.24		time 12844 ms
2.6.24-git19	time 10959 ms

3M:
2.6.22		time 8015 ms
2.6.23		time 13053 ms
2.6.24		time 16204 ms
2.6.24-git19	time 14984 ms

4M:
2.6.22		time 10045 ms
2.6.23		time 16642 ms
2.6.24		time 16910 ms
2.6.24-git19	time 16468 ms

5M:
2.6.22		time 12055 ms
2.6.23		time 21024 ms
<missed 2.6.24 here>
2.6.24-git19	time 16040 ms

10M:
2.6.22		time 24030 ms
2.6.23		time 33082 ms
2.6.24		time 34139 ms
2.6.24-git19	time 33724 ms

20M:
2.6.22		time 50015 ms
2.6.23		time 63963 ms
2.6.24		time 65100 ms
2.6.24-git19	time 63092 ms

40M:
2.6.22		time 94315 ms
2.6.23		time 107930 ms
2.6.24		time 113291 ms
2.6.24-git19	time 110360 ms

So with more work per thread, the differences become less but they're
still there. At the 40M loop, with 500 threads it's quite a bit of
runtime per thread.

> However, I fail to understand the goal of the reproducer. Granted it shows
> irregularities in the scheduler under such conditions, but what *real*
> workload would spend its time sequentially creating then immediately killing
> threads, never using more than 2 at a time ?
>
> If this could be turned into a DoS, I could understand, but here it looks
> a bit pointless :-/

It seems generally unfortunate that it takes longer for a new thread to
move over to the second cpu even when the first is busy with the original
thread. I can certainly see cases where this causes suboptimal overall
system behaviour.

I agree that the testcase is highly artificial. Unfortunately, it's
not uncommon to see these kind of weird testcases from customers tring
to evaluate new hardware. :( They tend to be pared-down versions of
whatever their real workload is (the real workload is doing things more
appropriately, but the smaller version is used for testing). I was lucky
enough to get source snippets to base a standalone reproduction case on
for this, normally we wouldn't even get copies of their binaries.


-Olof
