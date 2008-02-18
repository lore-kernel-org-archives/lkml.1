Return-Path: <linux-kernel-owner+w=401wt.eu-S1760169AbYBRMhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169AbYBRMhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758833AbYBRMhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:37:23 -0500
Received: from brick.kernel.dk ([87.55.233.238]:16435 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758562AbYBRMhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:37:21 -0500
Date: Mon, 18 Feb 2008 13:37:17 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, dgc@sgi.com,
       arjan@linux.intel.com
Subject: Re: IO queueing and complete affinity w/ threads: Some results
Message-ID: <20080218123717.GW23197@kernel.dk>
References: <47B0B69B.1050807@hp.com> <47B46008.9020804@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B46008.9020804@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14 2008, Alan D. Brunelle wrote:
> Taking a step back, I went to a very simple test environment:
> 
> o  4-way IA64
> o  2 disks (on separate RAID controller, handled by separate ports on the same FC HBA - generates different IRQs).
> o  Using write-cached tests - keep all IOs inside of the RAID controller's cache, so no perturbations due to platter accesses)
> 
> Basically:
> 
> o  CPU 0 handled IRQs for /dev/sds
> o  CPU 2 handled IRQs for /dev/sdaa
> 
> We placed an IO generator on CPU1 (for /dev/sds) and CPU3 (for /dev/sdaa). The IO generator performed 4KiB sequential direct AIOs in a very small range (2MB - well within the controller cache on the external storage device). We have found that this is a simple way to maximize throughput, and thus be able to watch the system for effects without worrying about odd seek & other platter-induced issues. Each test took about 6 minutes to run (ran a specific amount of IO, so we could compare & contrast system measurements).
> 
> First: overall performance
> 
> 2.6.24 (no patches)              : 106.90 MB/sec
> 
> 2.6.24 + original patches + rq=0 : 103.09 MB/sec
>                             rq=1 :  98.81 MB/sec
> 
> 2.6.24 + kthreads patches + rq=0 : 106.85 MB/sec
>                             rq=1 : 107.16 MB/sec
> 
> So, the kthreads patches works much better here - and on-par or better than straight 2.6.24. I also ran Caliper (akin to Oprofile, proprietary and ia64-specific, sorry), and looked at the cycles used. On an ia64 back-end-bubbles are deadly, and can be caused by cache misses &c. Looking at the gross data:
> 
> Kernel                                CPU_CYCLES       BACK END BUBBLES  100.0 * (BEB/CC)
> --------------------------------   -----------------  -----------------  ----------------
> 2.6.24 (no patches)              : 2,357,215,454,852    231,547,237,267   9.8%
> 
> 2.6.24 + original patches + rq=0 : 2,444,895,579,790    242,719,920,828   9.9%
>                             rq=1 : 2,551,175,203,455    148,586,145,513   5.8%
> 
> 2.6.24 + kthreads patches + rq=0 : 2,359,376,156,043    255,563,975,526  10.8%
>                             rq=1 : 2,350,539,631,362    208,888,961,094   8.9%
> 
> For both the original & kthreads patches we see a /significant/ drop in bubbles when setting rq=1 over rq=0. This shows up in extra CPU cycles available (not spent in %system) - a graph is provided up on http://free.linux.hp.com/~adb/jens/cached_mps.png - it shows the results from stats extracted from running mpstat in conjunction with the IO runs.
> 
> Combining %sys & %soft IRQ, we see:
> 
> Kernel                              % user     % sys   % iowait   % idle
> --------------------------------   --------  --------  --------  --------
> 2.6.24 (no patches)              :   0.141%   10.088%   43.949%   45.819%
> 
> 2.6.24 + original patches + rq=0 :   0.123%   11.361%   43.507%   45.008%
>                             rq=1 :   0.156%    6.030%   44.021%   49.794%
> 
> 2.6.24 + kthreads patches + rq=0 :   0.163%   10.402%   43.744%   45.686%
>                             rq=1 :   0.156%    8.160%   41.880%   49.804%
> 
> The good news (I think) is that even with rq=0 with the kthreads patches we're getting on-par performance w/ 2.6.24, so the default case should be ok...
> 
> I've only done a few runs by hand with this - these results are from one representative run out of the bunch - but at least this (I believe) shows what this patch stream is intending to do: optimize placement of IO completion handling to minimize cache & TLB disruptions. Freeing up cycles in the kernel is always helpful! :-)
> 
> I'm going to try similar runs on an AMD64 w/ Oprofile and see what results I get there... (BTW: I'll be dropping testing of the original patch sequence, the kthreads patches look better in general (both in terms of code & results, coincidence?).

Alan, thanks for your very nice testing efforts on this! It's very
encouraging to see that the kthread based approach is even faster than
the softirq one, since the code is indeed much simpler and doesn't
require any arch modifications. So I'd agree that just testing the
kthread approach is the best way forward, and that scrapping the remote
softirq trigger stuff is sanest.

My main worry with the current code is the ->lock in the per-cpu
completion structure. If we do a lot of migrations to other CPUs, then
that cacheline will be bounced around. But we'll be dirtying the list of
that CPU structure anyway, so playing games to make that part lockless
is probably pretty pointless. So if you get around to testing on bigger
SMP boxes, it'd be interesting to look for. So far it looks like it's a
net win with more idle time, the benefit of keeping the rq completion
queue local must be out weighing the cost of diddling with the per-cpu
data.

-- 
Jens Axboe

