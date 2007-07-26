Return-Path: <linux-kernel-owner+w=401wt.eu-S935584AbXGZTAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935584AbXGZTAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 15:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764931AbXGZTAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 15:00:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:43314 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763079AbXGZTA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 15:00:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,584,1175497200"; 
   d="scan'208";a="110324815"
Date: Thu, 26 Jul 2007 12:00:26 -0700 (PDT)
From: Tong Li <tong.n.li@intel.com>
X-X-Sender: tongli@tongli.jf.intel.com
To: Ingo Molnar <mingo@elte.hu>
cc: "Li, Tong N" <tong.n.li@intel.com>, linux-kernel@vger.kernel.org,
       Chris Snook <csnook@redhat.com>
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
In-Reply-To: <20070725192442.GC4463@elte.hu>
Message-ID: <Pine.LNX.4.64.0707261123060.9352@tongli.jf.intel.com>
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com>
 <20070725110159.GA15076@elte.hu> <20070725120358.GA30755@elte.hu>
 <Pine.LNX.4.64.0707251014520.14515@tongli.jf.intel.com> <20070725192442.GC4463@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007, Ingo Molnar wrote:

> 
> * Tong Li <tong.n.li@intel.com> wrote:
> 
> > Thanks for the patch. It doesn't work well on my 8-way box. Here's the
> > output at two different times. It's also changing all the time.
> 
> you need to measure it over longer periods of time. Its not worth
> balancing for such a thing in any high-frequency manner. (we'd trash the
> cache constantly migrating tasks back and forth.)

I have some data below, but before that, I'd like to say, at the same load 
balancing rate, my proposed approach would allow us to have fairness on 
the order of seconds. I'm less concerned about trashing the cache. The 
important thing is to have a knob that allow users to trade off fairness 
and performance based on their needs. This is the same spirit in CFS, 
which by default can have much more frequent context switches than the old 
O(1) scheduler. A valid concern is that this is going to hurt cache and 
this is something that has not yet been benchmarked thoroughly. On the 
other hand, I fully support CFS on this because I like the idea of having 
a powerful infrastructure in place and exporting a set of knobs that give 
users full flexibility. This is also what I'm trying to achieve with my 
patch for SMP fairness.

> 
> the runtime ranges from 1:38.66 to 1:46.38 - that's a +-3% spread which
> is pretty acceptable for ~90 seconds of runtime. Note that the
> percentages you see above were likely done over a shorter period that's
> why you see them range from 61% to 91%.
> 
> > I'm running 2.6.23-rc1 with your patch on a two-socket quad-core
> > system. Top refresh rate is the default 3s.
> 
> the 3s is the problem: change that to 60s! We no way want to
> over-migrate for SMP fairness, the change i did gives us reasonable
> long-term SMP fairness without the need for high-rate rebalancing.
>

I ran 10 nice 0 tasks on 8 CPUs. Each task does a trivial while (1) loop. 
I ran the whole thing 300 seconds and, at every 60 seconds, I measured for 
each task the following:

1. Actual CPU time the task received during the past 60 seconds.
2. Ideal CPU time it would receive under a perfect fair scheduler.
3. Lag = ideal time - actual time
Positive lag means the task received less CPU time than its fair share and 
negative means it received more.
4. Error = lag / ideal time

Results of CFS (2.6.23-rc1 with Ingo's SCHED_LOAD_SCALE_FUZZ change):

sampling interval 60 sampling length 300 num tasks 10
---------------------------------------------------------
Task 0 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:17:09.314     51.14          48.00       -3.14     -6.54%
04:18:09.316     46.05          48.00        1.95      4.06%
04:19:09.317     44.13          48.00        3.87      8.06%
04:20:09.318     44.78          48.00        3.22      6.71%
04:21:09.320     45.35          48.00        2.65      5.52%
---------------------------------------------------------
Task 1 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:17:09.314     47.06          48.00        0.94      1.96%
04:18:09.316     45.80          48.00        2.20      4.58%
04:19:09.317     49.95          48.00       -1.95     -4.06%
04:20:09.318     47.59          48.00        0.41      0.85%
04:21:09.320     46.50          48.00        1.50      3.12%
---------------------------------------------------------
Task 2 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:17:09.314     48.14          48.00       -0.14     -0.29%
04:18:09.316     48.66          48.00       -0.66     -1.37%
04:19:09.317     47.52          48.00        0.48      1.00%
04:20:09.318     45.90          48.00        2.10      4.37%
04:21:09.320     45.89          48.00        2.11      4.40%
---------------------------------------------------------
Task 3 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:17:09.314     48.71          48.00       -0.71     -1.48%
04:18:09.316     44.70          48.00        3.30      6.87%
04:19:09.317     45.86          48.00        2.14      4.46%
04:20:09.318     45.85          48.00        2.15      4.48%
04:21:09.320     44.91          48.00        3.09      6.44%
---------------------------------------------------------
Task 4 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:17:09.314     49.24          48.00       -1.24     -2.58%
04:18:09.316     45.73          48.00        2.27      4.73%
04:19:09.317     49.13          48.00       -1.13     -2.35%
04:20:09.318     45.37          48.00        2.63      5.48%
04:21:09.320     45.75          48.00        2.25      4.69%
---------------------------------------------------------
Task 5 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:17:09.314     49.28          48.00       -1.28     -2.67%
04:18:09.316     50.46          48.00       -2.46     -5.12%
04:19:09.317     43.92          48.00        4.08      8.50%
04:20:09.318     55.18          48.00       -7.18    -14.96%
04:21:09.320     56.97          48.00       -8.97    -18.69%
---------------------------------------------------------
Task 6 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:17:09.314     45.22          48.00        2.78      5.79%
04:18:09.316     44.80          48.00        3.20      6.67%
04:19:09.317     45.32          48.00        2.68      5.58%
04:20:09.318     46.66          48.00        1.34      2.79%
04:21:09.320     48.25          48.00       -0.25     -0.52%
---------------------------------------------------------
Task 7 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:17:09.314     47.52          48.00        0.48      1.00%
04:18:09.316     49.99          48.00       -1.99     -4.15%
04:19:09.317     53.40          48.00       -5.40    -11.25%
04:20:09.318     48.85          48.00       -0.85     -1.77%
04:21:09.320     44.67          48.00        3.33      6.94%
---------------------------------------------------------
Task 8 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:17:09.314     45.69          48.00        2.31      4.81%
04:18:09.316     47.92          48.00        0.08      0.17%
04:19:09.317     48.49          48.00       -0.49     -1.02%
04:20:09.318     54.47          48.00       -6.47    -13.48%
04:21:09.320     57.80          48.00       -9.80    -20.42%
---------------------------------------------------------
Task 9 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:17:09.314     46.86          48.00        1.14      2.37%
04:18:09.316     54.75          48.00       -6.75    -14.06%
04:19:09.317     51.13          48.00       -3.13     -6.52%
04:20:09.318     44.22          48.00        3.78      7.87%
04:21:09.320     42.76          48.00        5.24     10.92%
---------------------------------------------------------
System-wide stats:
Sampling interval: 60 s
Sampling length 300 s
Num threads: 10
Num CPUs: 8
Max error: 10.92%
Min error: -20.42%

----------------------------------------------------------------
Results of my patch:

sampling interval 60 sampling length 300 num tasks 10
---------------------------------------------------------
Task 0 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:42:35.248     47.92          48.00        0.08      0.17%
04:43:35.249     47.89          48.00        0.11      0.23%
04:44:35.250     47.93          48.00        0.07      0.15%
04:45:35.252     47.89          48.00        0.11      0.23%
04:46:35.254     47.90          48.00        0.10      0.21%
---------------------------------------------------------
Task 1 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:42:35.248     47.88          48.00        0.12      0.25%
04:43:35.249     47.90          48.00        0.10      0.21%
04:44:35.250     47.86          48.00        0.14      0.29%
04:45:35.252     47.89          48.00        0.11      0.23%
04:46:35.254     47.87          48.00        0.13      0.27%
---------------------------------------------------------
Task 2 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:42:35.248     47.89          48.00        0.11      0.23%
04:43:35.249     47.88          48.00        0.12      0.25%
04:44:35.250     47.88          48.00        0.12      0.25%
04:45:35.252     47.91          48.00        0.09      0.19%
04:46:35.254     47.85          48.00        0.15      0.31%
---------------------------------------------------------
Task 3 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:42:35.248     47.87          48.00        0.13      0.27%
04:43:35.249     47.81          48.00        0.19      0.40%
04:44:35.250     47.85          48.00        0.15      0.31%
04:45:35.252     47.92          48.00        0.08      0.17%
04:46:35.254     47.83          48.00        0.17      0.35%
---------------------------------------------------------
Task 4 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:42:35.248     47.84          48.00        0.16      0.33%
04:43:35.249     47.83          48.00        0.17      0.35%
04:44:35.250     47.94          48.00        0.06      0.13%
04:45:35.252     47.87          48.00        0.13      0.27%
04:46:35.254     47.93          48.00        0.07      0.15%
---------------------------------------------------------
Task 5 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:42:35.248     47.84          48.00        0.16      0.33%
04:43:35.249     47.93          48.00        0.07      0.15%
04:44:35.250     47.88          48.00        0.12      0.25%
04:45:35.252     47.85          48.00        0.15      0.31%
04:46:35.254     47.92          48.00        0.08      0.17%
---------------------------------------------------------
Task 6 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:42:35.248     47.89          48.00        0.11      0.23%
04:43:35.249     47.90          48.00        0.10      0.21%
04:44:35.250     47.86          48.00        0.14      0.29%
04:45:35.252     47.89          48.00        0.11      0.23%
04:46:35.254     47.86          48.00        0.14      0.29%
---------------------------------------------------------
Task 7 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:42:35.248     47.93          48.00        0.07      0.15%
04:43:35.249     47.86          48.00        0.14      0.29%
04:44:35.250     47.89          48.00        0.11      0.23%
04:45:35.252     47.86          48.00        0.14      0.29%
04:46:35.254     47.91          48.00        0.09      0.19%
---------------------------------------------------------
Task 8 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:42:35.248     47.88          48.00        0.12      0.25%
04:43:35.249     47.87          48.00        0.13      0.27%
04:44:35.250     47.87          48.00        0.13      0.27%
04:45:35.252     47.87          48.00        0.13      0.27%
04:46:35.254     47.89          48.00        0.11      0.23%
---------------------------------------------------------
Task 9 (unit: second) nice 0 weight 1024
----------------------------------------
Wall Clock     CPU Time       Ideal Time     Lag       Error 
04:42:35.248     47.87          48.00        0.13      0.27%
04:43:35.249     47.92          48.00        0.08      0.17%
04:44:35.250     47.90          48.00        0.10      0.21%
04:45:35.252     47.88          48.00        0.12      0.25%
04:46:35.254     47.88          48.00        0.12      0.25%
---------------------------------------------------------
System-wide stats:
Sampling interval: 60 s
Sampling length 300 s
Num threads: 10
Num CPUs: 8
Max error: 0.40%
Min error: 0.13%

   tong
