Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbYDOIW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbYDOIW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbYDOIWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:22:43 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25856 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928AbYDOIWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:22:41 -0400
Date: Tue, 15 Apr 2008 10:22:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, paolo.valente@unimore.it
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
Message-ID: <20080415082236.GD12774@kernel.dk>
References: <20080401152903.GB34860@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401152903.GB34860@gandalf.sssup.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01 2008, Fabio Checconi wrote:
> [sorry for reposting, wrong subject]
> 
> Hi,
>     we are working to a new I/O scheduler based on CFQ, aiming at
> improved predictability and fairness of the service, while maintaining
> the high throughput it already provides.
> 
> The patchset, too big for lkml posting, is available here:
>     http://feanor.sssup.it/~fabio/linux/bfq/patches/
> 
> The Budget Fair Queueing (BFQ) scheduler turns the CFQ Round-Robin
> scheduling policy of time slices into a fair queueing scheduling
> of sector budgets.  More precisely, each task is assigned a budget
> measured in number of sectors instead of amount of time, and budgets
> are scheduled using a slightly modified version of WF2Q+.  The
> budget assigned to each task varies over time as a function of its
> behaviour.  However, one can set the maximum value of the budget
> that BFQ can assign to any task.
> 
> The time-based allocation of the disk service in CFQ, while having
> the desirable effect of implicitly charging each application for
> the seek time it incurs, suffers from unfairness problems also
> towards processes making the best possible use of the disk bandwidth.
> In fact, even if the same time slice is assigned to two processes,
> they may get a different throughput each, as a function of the
> positions on the disk of their requests.  On the contrary, BFQ can
> provide strong guarantees on bandwidth distribution because the
> assigned budgets are measured in number of sectors.  Moreover, due
> to its Round Robin policy, CFQ is characterized by an O(N) worst-case
> delay (jitter) in request completion time, where N is the number
> of tasks competing for the disk.  On the contrary, given the accurate
> service distribution of the internal WF2Q+ scheduler, BFQ exhibits
> O(1) delay.
> 
> We made several tests to measure the aggregate throughput, long-term
> bandwidth distribution and single-request completion time guaranteed
> by CFQ and BFQ; what we present here was obtained with an outdated
> version of the code, we are in the process of collecting data for
> the current one (see [1]).
> 
> In the first type of tests, to achieve a higher throughput than CFQ
> (with the default 100 ms time slice), the maximum budget for BFQ
> had to be set to at least 4k sectors.  Using the same value for the
> maximum budget, in the second type of tests, BFQ guaranteed a maximum
> deviation from the desired bandwidth distribution in the order of
> 3% over all the experiments.  On the contrary CFQ exhibited a maximum
> deviation of 28% in consequence of the different positions of the
> files on the disk.
> 
> 		 Slowest task's bw (MB/s)  Fastest task's bw (MB/s)
> -------------------------------------------------------------------
> BFQ (2 files)		9.81 +/- 0.47		9.95 +/- 0.43
> CFQ (2 files)		8.61 +/- 0.67		11.92 +/- 0.44
> -------------------------------------------------------------------
> BFQ (5 files)		4.29 +/- 0.10		4.31 +/- 0.09
> CFQ (5 files)		4.01 +/- 0.17		5.24 +/- 0.14
> 
> Finally, we set up a VLC video streaming server to stream an
> increasing number of movies in presence of disturbing ON/OFF random
> file readers.  Each test ended when a 1% packet loss was reached
> (a packet was deemed as lost if transmitted with a delayed of more
> than 1 second).  With BFQ it was possible to transmit at most 24
> movies in parallel (again with a 4k sectors maximum budget), against
> 15 movies with CFQ (with a time slice of 20 ms).  This is likely
> to be a consequence of the higher jitter of CFQ.
> 
> 			Nr. of movies		Aggr. bw (MB/s)
> ---------------------------------------------------------------
> BFQ (max_budget=4096)	24.00 +/- 0.00		7.56 +/- 0.87
> BFQ (max_budget=16384)	18.70 +/- 9.45		12.78 +/- 5.64
> CFQ (slice_sync=20)	14.35 +/- 1.40		12.59 +/- 2.12
> 
> More stuff related to BFQ (extended results, the test programs used
> and the setup for the tests, a document describing the algorithm in
> detail and so on) can be found at:
> 
> [1] http://algo.ing.unimo.it/people/paolo/disk_sched/
> 
> We would greatly appreciate any sort of feedback from you, comments,
> suggestions, corrections and so on.  Thank you for your attention.

Fabio, I've merged the scheduler for some testing. Overall the code
looks great, you've done a good job!

I didn't touch patches 2 and 3, but I rewrote #1 somewhat. See the
result here:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=973a02c4ea1c324c41e45b69c074b13d3bfa97de;hp=a985aabe4d7a720b109c2b63549f8641676a9c88

I'm sure you'll agree with the hlist_sched_*() functions. I also killed
the ->bfq_ioprio_changed modification, what exactly was the purpose of
that?

The code is now in the 'bfq' branch of the block git repo.

-- 
Jens Axboe

