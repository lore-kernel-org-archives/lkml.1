Return-Path: <linux-kernel-owner+w=401wt.eu-S1751565AbXLEKZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbXLEKZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 05:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbXLEKZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 05:25:06 -0500
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:41393 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752355AbXLEKZD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 05:25:03 -0500
Message-Id: <475634F8.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 05 Dec 2007 05:19:52 -0500
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>,
       <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 3/3] Subject: SCHED - Use a 2-d bitmap for
	searching lowest-pri CPU
References: <20071205025137.4494.18683.stgit@novell1.haskins.net>
 <20071205025538.4494.52380.stgit@novell1.haskins.net>
 <20071205093412.GA17911@elte.hu>
In-Reply-To: <20071205093412.GA17911@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Wed, Dec 5, 2007 at  4:34 AM, in message <20071205093412.GA17911@elte.hu>,
Ingo Molnar <mingo@elte.hu> wrote: 

> * Gregory Haskins <ghaskins@novell.com> wrote:
> 
>> The current code use a linear algorithm which causes scaling issues on 
>> larger SMP machines.  This patch replaces that algorithm with a 
>> 2-dimensional bitmap to reduce latencies in the wake-up path.
> 
> hm, what kind of scaling issues

well, the linear algorithm scales with the number of online-cpus, so as you add more cpus the latencies increase, thus decreasing determinism.

> - do you have any numbers?  What workload did you measure and on what hardware?
> 

The vast majority of my own work was on 4-way and 8-way systems with -rt which I can dig up and share with you if you like.  Generally speaking, I would present various loads (make -j 128 being the defacto standard) and simultaneously measure RT latency performance with tools such as cyclictest and/or preempt-test.  Typically, I would let these loads/measurements run overnight to really seek out the worst-case maximums.

As a synopsis, the 2-d alg helps even on the 4-way, but even more so on the 8-way.  I expect that trend to continue as we add more cpus.  The general numbers I recall from memory are that the 2-d alg reduces max latencies by about 25-40% on the 8-way.

However, that said, Steven's testing work on the mainline port of our series sums it up very nicely, so I will present that in lieu of digging up my -rt numbers unless you specifically want them too.  Here they are:


http://people.redhat.com/srostedt/rt-benchmarks/

As I believe you are aware, these numbers were generated on a 64-way SMP beast.  To break down what we are looking at, lets start with the first row of graphs (under Kernel and System Information).  What we see here are scatterplots of wake-latencies generated from Steven's "rt-migrate" test.  We start with the vanilla "rc3" kernel, and make our way through "sdr" (the first 7-8 patches from v7), "gh" (patches 8-20), and finally "cpupri" (patches 21-23).  (Ignore the "noavoid" runs, that was an experiment that Steven and I agree was a flop so its dropped from the series). 

The test has a default run-interval of 20ms, which is employed here in this test.  What we expect to see is that the red points (high-priority) should be allowed to start immediately (close to 0 latency), whereas green points (low-priority) may sometimes happen to start first, or may start after the 20ms interval depending on luck of the draw.

You can see that "rc3" has issues keeping the red-points near zero, which is part of the problem we were addressing in this series.

http://people.redhat.com/srostedt/rt-benchmarks/imgs/results-rt-migrate-test-2.6.24-rc3.out.png

Rolling in "sdr" we fix the wandering/20ms red-points, but you still see a degree of jitter in the red-points staying close to zero.

http://people.redhat.com/srostedt/rt-benchmarks/imgs/results-rt-migrate-test-2.6.24-rc3-sdr.out-sm.png

This is "ok".  The code technically passes the test and does the right thing from a balancing perspective.  The remainder of the series is performance related.

We then apply "gh" which adds support for considering things like NUMA/MC distance and we can see a higher degree of determinism, particularly on the red-points.  

http://people.redhat.com/srostedt/rt-benchmarks/imgs/results-rt-migrate-test-2.6.24-rc3-gh.out-sm.png

Rolling in "cpupri" we substitute the linear search for the 2-d bitmap optimization, are we observe a further increase in determinism:

http://people.redhat.com/srostedt/rt-benchmarks/imgs/results-rt-migrate-test-2.6.24-rc3-gh-cpupri.out-sm.png

The numbers presented in these scatterplots can be summarized in the following bar-graph for easier comparison:

http://people.redhat.com/srostedt/rt-benchmarks/imgs/results-rt-migrate-hist-sm.png

You can clearly see the latencies dropping as we move through the 23 patches.  This is similar to my findings under -rt with the 4/8 ways that I mentioned earlier, but I can find those numbers for you next if you feel it is necessary.

I hope this helps to show the difference.  Thanks for hanging in there on this long mail!

Regards,
-Greg






