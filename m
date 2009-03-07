Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbZCGSrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbZCGSrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 13:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZCGSrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 13:47:10 -0500
Received: from support.balabit.hu ([195.70.41.86]:37600 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753806AbZCGSrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 13:47:09 -0500
Subject: Re: scheduler oddity [bug?]
From: Balazs Scheidler <bazsi@balabit.hu>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1236448069.16726.21.camel@bzorp.balabit>
References: <1236448069.16726.21.camel@bzorp.balabit>
Content-Type: text/plain
Date: Sat, 07 Mar 2009 19:47:04 +0100
Message-Id: <1236451624.16726.32.camel@bzorp.balabit>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-07 at 18:47 +0100, Balazs Scheidler wrote:
> Hi,
> 
> I'm experiencing an odd behaviour from the Linux scheduler. I have an
> application that feeds data to another process using a pipe. Both
> processes use a fair amount of CPU time apart from writing to/reading
> from this pipe.
> 
> The machine I'm running on  is an Opteron Quad-Core CPU:
> model name	: Quad-Core AMD Opteron(tm) Processor 2347 HE
> stepping	: 3
> 
> What I see is that only one of the cores is used, the other three is
> idling without doing any work. If I explicitly set the CPU affinity of
> the processes to use distinct CPUs the performance goes up
> significantly. (e.g. it starts to use the other cores and the load
> scales linearly).
> 
> I've tried to reproduce the problem by writing a small test program,
> which you can find attached. The program creates two processes, one
> feeds the other using a pipe and each does a series of memset() calls to
> simulate CPU load. I've also added capability to the program to set its
> own CPU affinity. The results (the more the better):
> 
> Without enabling CPU affinity:
> $ ./a.out
> Check: 0 loops/sec, sum: 1 
> Check: 12 loops/sec, sum: 13 
> Check: 41 loops/sec, sum: 54 
> Check: 41 loops/sec, sum: 95 
> Check: 41 loops/sec, sum: 136 
> Check: 41 loops/sec, sum: 177 
> Check: 41 loops/sec, sum: 218 
> Check: 40 loops/sec, sum: 258 
> Check: 41 loops/sec, sum: 299 
> Check: 41 loops/sec, sum: 340 
> Check: 41 loops/sec, sum: 381 
> Check: 41 loops/sec, sum: 422 
> Check: 41 loops/sec, sum: 463 
> Check: 41 loops/sec, sum: 504 
> Check: 41 loops/sec, sum: 545 
> Check: 40 loops/sec, sum: 585 
> Check: 41 loops/sec, sum: 626 
> Check: 41 loops/sec, sum: 667 
> Check: 41 loops/sec, sum: 708 
> Check: 41 loops/sec, sum: 749 
> Check: 41 loops/sec, sum: 790 
> Check: 41 loops/sec, sum: 831 
> Final: 39 loops/sec, sum: 831
> 
> 
> With CPU affinity:
> # ./a.out 1
> Check: 0 loops/sec, sum: 1 
> Check: 41 loops/sec, sum: 42 
> Check: 49 loops/sec, sum: 91 
> Check: 49 loops/sec, sum: 140 
> Check: 49 loops/sec, sum: 189 
> Check: 49 loops/sec, sum: 238 
> Check: 49 loops/sec, sum: 287 
> Check: 50 loops/sec, sum: 337 
> Check: 49 loops/sec, sum: 386 
> Check: 49 loops/sec, sum: 435 
> Check: 49 loops/sec, sum: 484 
> Check: 49 loops/sec, sum: 533 
> Check: 49 loops/sec, sum: 582 
> Check: 49 loops/sec, sum: 631 
> Check: 49 loops/sec, sum: 680 
> Check: 49 loops/sec, sum: 729 
> Check: 49 loops/sec, sum: 778 
> Check: 49 loops/sec, sum: 827 
> Check: 49 loops/sec, sum: 876 
> Check: 49 loops/sec, sum: 925 
> Check: 50 loops/sec, sum: 975 
> Check: 49 loops/sec, sum: 1024 
> Final: 48 loops/sec, sum: 1024
> 
> The difference is about 20%, which is about the same work performed by
> the slave process. If the two processes race for the same CPU this 20%
> of performance is lost.
> 
> I've tested this on 3 computers and each showed the same symptoms:
>  * quad core Opteron, running Ubuntu kernel 2.6.27-13.29
>  * Core 2 Duo, running Ubuntu kernel 2.6.27-11.27
>  * Dual Core Opteron, Debian backports.org kernel 2.6.26-13~bpo40+1
> 
> Is this a bug, or a feature?
> 

One new interesting information: I've retested with a 2.6.22 based
kernel, and it still works there, setting the CPU affinity does not
change the performance of the test program and mpstat nicely shows that
2 cores are working, not just one.

Maybe this is CFS related? That was merged for 2.6.23 IIRC.

Also, I tried changing various scheduler knobs
in /proc/sys/kernel/sched_* but they didn't help. I've tried to change
these:

 * sched_migration_cost: changed from the default 500000 to 100000 and
then 10000 but neither helped.
 * sched_nr_migrate: increased it to 64, but again nothing

I'm starting to think that this is a regression that may or may not be
related to CFS. 

I don't have a box where I could bisect on, but the test program makes
the problem quite obvious.


-- 
Bazsi


