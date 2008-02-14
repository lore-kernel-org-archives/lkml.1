Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYBNPg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYBNPg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYBNPgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:36:47 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:8753 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYBNPgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:36:45 -0500
Message-ID: <47B46008.9020804@hp.com>
Date: Thu, 14 Feb 2008 10:36:40 -0500
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       npiggin@suse.de, dgc@sgi.com, arjan@linux.intel.com
Subject: Re: IO queueing and complete affinity w/ threads: Some results
References: <47B0B69B.1050807@hp.com>
In-Reply-To: <47B0B69B.1050807@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Taking a step back, I went to a very simple test environment:

o  4-way IA64
o  2 disks (on separate RAID controller, handled by separate ports on the same FC HBA - generates different IRQs).
o  Using write-cached tests - keep all IOs inside of the RAID controller's cache, so no perturbations due to platter accesses)

Basically:

o  CPU 0 handled IRQs for /dev/sds
o  CPU 2 handled IRQs for /dev/sdaa

We placed an IO generator on CPU1 (for /dev/sds) and CPU3 (for /dev/sdaa). The IO generator performed 4KiB sequential direct AIOs in a very small range (2MB - well within the controller cache on the external storage device). We have found that this is a simple way to maximize throughput, and thus be able to watch the system for effects without worrying about odd seek & other platter-induced issues. Each test took about 6 minutes to run (ran a specific amount of IO, so we could compare & contrast system measurements).

First: overall performance

2.6.24 (no patches)              : 106.90 MB/sec

2.6.24 + original patches + rq=0 : 103.09 MB/sec
                            rq=1 :  98.81 MB/sec

2.6.24 + kthreads patches + rq=0 : 106.85 MB/sec
                            rq=1 : 107.16 MB/sec

So, the kthreads patches works much better here - and on-par or better than straight 2.6.24. I also ran Caliper (akin to Oprofile, proprietary and ia64-specific, sorry), and looked at the cycles used. On an ia64 back-end-bubbles are deadly, and can be caused by cache misses &c. Looking at the gross data:

Kernel                                CPU_CYCLES       BACK END BUBBLES  100.0 * (BEB/CC)
--------------------------------   -----------------  -----------------  ----------------
2.6.24 (no patches)              : 2,357,215,454,852    231,547,237,267   9.8%

2.6.24 + original patches + rq=0 : 2,444,895,579,790    242,719,920,828   9.9%
                            rq=1 : 2,551,175,203,455    148,586,145,513   5.8%

2.6.24 + kthreads patches + rq=0 : 2,359,376,156,043    255,563,975,526  10.8%
                            rq=1 : 2,350,539,631,362    208,888,961,094   8.9%

For both the original & kthreads patches we see a /significant/ drop in bubbles when setting rq=1 over rq=0. This shows up in extra CPU cycles available (not spent in %system) - a graph is provided up on http://free.linux.hp.com/~adb/jens/cached_mps.png - it shows the results from stats extracted from running mpstat in conjunction with the IO runs.

Combining %sys & %soft IRQ, we see:

Kernel                              % user     % sys   % iowait   % idle
--------------------------------   --------  --------  --------  --------
2.6.24 (no patches)              :   0.141%   10.088%   43.949%   45.819%

2.6.24 + original patches + rq=0 :   0.123%   11.361%   43.507%   45.008%
                            rq=1 :   0.156%    6.030%   44.021%   49.794%

2.6.24 + kthreads patches + rq=0 :   0.163%   10.402%   43.744%   45.686%
                            rq=1 :   0.156%    8.160%   41.880%   49.804%

The good news (I think) is that even with rq=0 with the kthreads patches we're getting on-par performance w/ 2.6.24, so the default case should be ok...

I've only done a few runs by hand with this - these results are from one representative run out of the bunch - but at least this (I believe) shows what this patch stream is intending to do: optimize placement of IO completion handling to minimize cache & TLB disruptions. Freeing up cycles in the kernel is always helpful! :-)

I'm going to try similar runs on an AMD64 w/ Oprofile and see what results I get there... (BTW: I'll be dropping testing of the original patch sequence, the kthreads patches look better in general (both in terms of code & results, coincidence?).

Alan

