Return-Path: <linux-kernel-owner+w=401wt.eu-S1761611AbXFWNbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761611AbXFWNbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760172AbXFWNZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:25:44 -0400
Received: from 1wt.eu ([62.212.114.60]:3122 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760175AbXFWNZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:25:41 -0400
Date: Sat, 23 Jun 2007 15:24:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070623132418.GA32449@1wt.eu>
References: <20070622220202.GA16872@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622220202.GA16872@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sat, Jun 23, 2007 at 12:02:02AM +0200, Ingo Molnar wrote:
> 
> i'm pleased to announce release -v18 of the CFS scheduler patchset.
> 
> The rolled-up CFS patch against today's -git kernel, v2.6.22-rc5, 
> v2.6.22-rc4-mm2, v2.6.21.5 or v2.6.20.14 can be downloaded from the 
> usual place:
> 
>    http://people.redhat.com/mingo/cfs-scheduler/
> 
> The biggest change in -v18 are various performance related improvements. 
> Thomas Gleixner has eliminated expensive 64-bit divisions by converting 
> the arithmetics to scaled math (without impacting the quality of 
> calculations). Srivatsa Vaddagiri and Dmitry Adamushko have continued 
> the abstraction and cleanup work. Srivatsa Vaddagiri and Christoph 
> Lameter fixed the NUMA balancing bug reported by Paul McKenney. There 
> were also a good number of other refinements to the CFS code. (No 
> reproducible behavioral regressions were reported against -v17 so far, 
> so the 'behavioral' bits are mostly unchanged.)

Today I had a little time to try CFS again (last time it was -v9!). I ran it
on top of 2.6.20.14, and simply tried ocbench again. You remember ? With -v9,
I ran 64 processes which all progressed very smoothly. With -v18, it's not
the case anymore. When I run 64 processes, only 7 of them show smooth rounds,
while all the other ones are only updated once a second. Sometimes they only
progress by one iteration, sometimes by a full round. Some are even updated
once ever 2 seconds, because if I drag an xterm above them and quickly remove
it, the xterm leaves a trace there for up to 2 seconds.

Also, only one of my 2 CPUs is used. I see the rq vary between 1 and 5, with 
a permanent 50% idle... :

   procs                      memory      swap          io     system      cpu
 r  b  w   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id
 1  0  0      0 874400   7864  90436    0    0     0     0  279  2204 50  0 50
 3  0  0      0 874408   7864  90436    0    0     0     0  273  2122 50  1 50
 1  0  0      0 874408   7864  90436    0    0     0     0  253  1660 49  1 50
 3  0  0      0 874408   7864  90436    0    0     0     0  252  1977 50  0 50
 2  0  0      0 874408   7864  90436    0    0     0     0  253  2274 49  1 50
 3  0  0      0 874408   7864  90436    0    0     0     0  252  1846 49  1 50
 1  0  0      0 874408   7864  90436    0    0     0     0  339  1782 49  1 50

I have no idea about what version brought that unexpected behaviour, but it's
clearly something which needs to be tracked down.

My scheduler is at 250 Hz, and here are the values I found in /proc/sys/kernel:
root@pcw:kernel# grep '' sched_*
sched_batch_wakeup_granularity_ns:40000000
sched_child_runs_first:1
sched_features:14
sched_granularity_ns:10000000
sched_runtime_limit_ns:40000000
sched_stat_granularity_ns:0
sched_wakeup_granularity_ns:4000000

I have tried to change each of them, with absolutely no effect. Seems really
strange. Unfortunately, I have to leave right now. Maybe you can try on your
side with this simple command :

  $ ./ocbench -x 8 -y 8

Sorry for not giving more information right now.

Regards,
Willy

