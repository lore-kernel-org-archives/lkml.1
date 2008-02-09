Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbYBIRL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbYBIRL7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbYBIRLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:11:52 -0500
Received: from 1wt.eu ([62.212.114.60]:1788 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387AbYBIRLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:11:52 -0500
Date: Sat, 9 Feb 2008 17:19:57 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mike Galbraith <efault@gmx.de>
Cc: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived threads
Message-ID: <20080209161957.GA3364@1wt.eu>
References: <20080209000456.GA21021@lixom.net> <1202543920.9578.3.camel@homer.simson.net> <20080209080319.GO8953@1wt.eu> <1202554705.10287.12.camel@homer.simson.net> <20080209114009.GP8953@1wt.eu> <1202564259.4035.18.camel@homer.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202564259.4035.18.camel@homer.simson.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 02:37:39PM +0100, Mike Galbraith wrote:
> 
> On Sat, 2008-02-09 at 12:40 +0100, Willy Tarreau wrote: 
> > On Sat, Feb 09, 2008 at 11:58:25AM +0100, Mike Galbraith wrote:
> > > 
> > > On Sat, 2008-02-09 at 09:03 +0100, Willy Tarreau wrote:
> > > 
> > > > How many CPUs do you have ?
> > > 
> > > It's a P4/HT, so 1 plus $CHUMP_CHANGE_MAYBE
> > > 
> > > > > 2.6.25-smp (git today)
> > > > > time 29 ms
> > > > > time 61 ms
> > > > > time 72 ms
> > > > 
> > > > These ones look rather strange. What type of workload is it ? Can you
> > > > publish the program for others to test it ?
> > > 
> > > It's the proglet posted in this thread.
> > 
> > OK sorry, I did not notice it when I first read the report.
> 
> Hm.  The 2.6.25-smp kernel is the only one that looks like it's doing
> what proggy wants to do, massive context switching.  Bump threads to
> larger number so you can watch: the supposedly good kernel (22) is doing
> everything on one CPU.  Everybody else sucks differently (idleness), and
> the clear throughput winner, via mad over-schedule (!?!), is git today.

For me, 2.6.25-smp gives pretty irregular results :

time 6548 ms
time 7272 ms
time 1188 ms
time 3772 ms

The CPU usage is quite irregular too and never goes beyond 50% (this is a
dual-athlon). If I start two of these processes, 100% of the CPU is used,
the context switch rate is more regular (about 700/s) and the total time
is more regular too (between 14.8 and 18.5 seconds).

Increasing the parallel run time of the two threads by changing the upper
limit of the for(j) loop correctly saturates both processors. I think that
this program simply does not have enough work to do for each thread to run
for a full timeslice, thus showing a random behaviour.

However, I fail to understand the goal of the reproducer. Granted it shows
irregularities in the scheduler under such conditions, but what *real*
workload would spend its time sequentially creating then immediately killing
threads, never using more than 2 at a time ?

If this could be turned into a DoS, I could understand, but here it looks
a bit pointless :-/

Regards,
Willy

