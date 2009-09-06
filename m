Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbZIFVAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbZIFVAF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 17:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758492AbZIFVAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 17:00:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43814 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758119AbZIFVAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 17:00:03 -0400
Date: Sun, 6 Sep 2009 22:59:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090906205952.GA6516@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Con,

I've read your BFS announcement/FAQ with great interest:

    http://ck.kolivas.org/patches/bfs/bfs-faq.txt

First and foremost, let me say that i'm happy that you are hacking 
the Linux scheduler again. It's perhaps proof that hacking the 
scheduler is one of the most addictive things on the planet ;-)

I understand that BFS is still early code and that you are not 
targeting BFS for mainline inclusion - but BFS is an interesting 
and bold new approach, cutting a _lot_ of code out of 
kernel/sched*.c, so it raised my curiosity and interest :-)

In the announcement and on your webpage you have compared BFS to 
the mainline scheduler in various workloads - showing various 
improvements over it. I have tried and tested BFS and ran a set of 
benchmarks - this mail contains the results and my (quick) 
findings.

So ... to get to the numbers - i've tested both BFS and the tip of 
the latest upstream scheduler tree on a testbox of mine. I 
intentionally didnt test BFS on any really large box - because you 
described its upper limit like this in the announcement:

-----------------------
|
| How scalable is it?
|
| I don't own the sort of hardware that is likely to suffer from 
| using it, so I can't find the upper limit. Based on first 
| principles about the overhead of locking, and the way lookups 
| occur, I'd guess that a machine with more than 16 CPUS would 
| start to have less performance. BIG NUMA machines will probably 
| suck a lot with this because it pays no deference to locality of 
| the NUMA nodes when deciding what cpu to use. It just keeps them 
| all busy. The so-called "light NUMA" that constitutes commodity 
| hardware these days seems to really like BFS.
|
-----------------------

I generally agree with you that "light NUMA" is what a Linux 
scheduler needs to concentrate on (at most) in terms of 
scalability. Big NUMA, 4096 CPUs is not very common and we tune the 
Linux scheduler for desktop and small-server workloads mostly.

So the testbox i picked fits into the upper portion of what i 
consider a sane range of systems to tune for - and should still fit 
into BFS's design bracket as well according to your description: 
it's a dual quad core system with hyperthreading. It has twice as 
many cores as the quad you tested on but it's not excessive and 
certainly does not have 4096 CPUs ;-)

Here are the benchmark results:

  kernel build performance:
     http://redhat.com/~mingo/misc/bfs-vs-tip-kbuild.jpg     

  pipe performance:
     http://redhat.com/~mingo/misc/bfs-vs-tip-pipe.jpg

  messaging performance (hackbench):
     http://redhat.com/~mingo/misc/bfs-vs-tip-messaging.jpg  

  OLTP performance (postgresql + sysbench)
     http://redhat.com/~mingo/misc/bfs-vs-tip-oltp.jpg

Alas, as it can be seen in the graphs, i can not see any BFS 
performance improvements, on this box.

Here's a more detailed description of the results:

| Kernel build performance
---------------------------

  http://redhat.com/~mingo/misc/bfs-vs-tip-kbuild.jpg     

In the kbuild test BFS is showing significant weaknesses up to 16 
CPUs. On 8 CPUs utilized (half load) it's 27.6% slower. All results 
(-j1, -j2... -j15 are slower. The peak at 100% utilization at -j16 
is slightly stronger under BFS, by 1.5%. The 'absolute best' result 
is sched-devel at -j64 with 46.65 seconds - the best BFS result is 
47.38 seconds (at -j64) - 1.5% better.

| Pipe performance
-------------------

  http://redhat.com/~mingo/misc/bfs-vs-tip-pipe.jpg

Pipe performance is a very simple test, two tasks message to each 
other via pipes. I measured 1 million such messages:

   http://redhat.com/~mingo/cfs-scheduler/tools/pipe-test-1m.c

The pipe test ran a number of them in parallel:

   for ((i=0;i<$NR;i++)); do ~/sched-tests/pipe-test-1m & done; wait

and measured elapsed time. This tests two things: basic scheduler 
performance and also scheduler fairness. (if one of these parallel 
jobs is delayed unfairly then the test will finish later.)

[ see further below for a simpler pipe latency benchmark as well. ]

As can be seen in the graph BFS performed very poorly in this test: 
at 8 pairs of tasks it had a runtime of 45.42 seconds - while 
sched-devel finished them in 3.8 seconds.

I saw really bad interactivity in the BFS test here - the system 
was starved for as long as the test ran. I stopped the tests at 8 
loops - the system was unusable and i was getting IO timeouts due 
to the scheduling lag:

 sd 0:0:0:0: [sda] Unhandled error code
 sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
 end_request: I/O error, dev sda, sector 81949243
 Aborting journal on device sda2.
 ext3_abort called.
 EXT3-fs error (device sda2): ext3_journal_start_sb: Detected aborted journal
 Remounting filesystem read-only

I measured interactivity during this test:

   $ time ssh aldebaran /bin/true
   real  2m17.968s
   user  0m0.009s
   sys   0m0.003s

A single command took more than 2 minutes.

| Messaging performance
------------------------

  http://redhat.com/~mingo/misc/bfs-vs-tip-messaging.jpg  

Hackbench ran better - but mainline sched-devel is significantly 
faster for smaller and larger loads as well. With 20 groups 
mainline ran 61.5% faster.

| OLTP performance
--------------------

http://redhat.com/~mingo/misc/bfs-vs-tip-oltp.jpg

As can be seen in the graph for sysbench OLTP performance 
sched-devel outperforms BFS on each of the main stages:

   single client load   (   1 client  -   6.3% faster )
   half load            (   8 clients -  57.6% faster )
   peak performance     (  16 clients - 117.6% faster )
   overload             ( 512 clients - 288.3% faster )

| Other tests
--------------

I also tested a couple of other things, such as lat_tcp:

  BFS:          TCP latency using localhost: 16.5608 microseconds
  sched-devel:  TCP latency using localhost: 13.5528 microseconds [22.1% faster]

lat_pipe:

  BFS:          Pipe latency: 4.9703 microseconds
  sched-devel:  Pipe latency: 2.6137 microseconds [90.1% faster]

General interactivity of BFS seemed good to me - except for the 
pipe test when there was significant lag over a minute. I think 
it's some starvation bug, not an inherent design property of BFS, 
so i'm looking forward to re-test it with the fix.

Test environment: i used latest BFS (205 and then i re-ran under 
208 and the numbers are all from 208), and the latest mainline 
scheduler development tree from:

  http://people.redhat.com/mingo/tip.git/README

Commit 840a065 in particular. It's on a .31-rc8 base while BFS is 
on a .30 base - will be able to test BFS on a .31 base as well once 
you release it. (but it doesnt matter much to the results - there 
werent any heavy core kernel changes impacting these workloads.)

The system had enough RAM to have the workloads cached, and i 
repeated all tests to make sure it's all representative. 
Nevertheless i'd like to encourage others to repeat these (or 
other) tests - the more testing the better.

I also tried to configure the kernel in a BFS friendly way, i used 
HZ=1000 as recommended, turned off all debug options, etc. The 
kernel config i used can be found here:

  http://redhat.com/~mingo/misc/config

( Let me know if you need any more info about any of the tests i
  conducted. )

Also, i'd like to outline that i agree with the general goals 
described by you in the BFS announcement - small desktop systems 
matter more than large systems. We find it critically important 
that the mainline Linux scheduler performs well on those systems 
too - and if you (or anyone else) can reproduce suboptimal behavior 
please let the scheduler folks know so that we can fix/improve it.

I hope to be able to work with you on this, please dont hesitate 
sending patches if you wish - and we'll also be following BFS for 
good ideas and code to adopt to mainline.

Thanks,

	Ingo
