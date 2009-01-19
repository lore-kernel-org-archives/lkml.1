Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbZASS2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbZASS2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZASS2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:28:25 -0500
Received: from brick.kernel.dk ([93.163.65.50]:25704 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbZASS2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:28:24 -0500
Date: Mon, 19 Jan 2009 19:26:54 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrea Arcangeli <andrea@suse.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: [RFC PATCH] block: Fix bio merge induced high I/O latency
Message-ID: <20090119182654.GT30821@kernel.dk>
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal> <20090117190437.GZ30821@kernel.dk> <20090118211234.GA4913@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118211234.GA4913@Krystal>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18 2009, Mathieu Desnoyers wrote:
> I looked at the "ls" behavior (while doing a dd) within my LTTng trace
> to create a fio job file.  The said behavior is appended below as "Part
> 1 - ls I/O behavior". Note that the original "ls" test case was done
> with the anticipatory I/O scheduler, which was active by default on my
> debian system with custom vanilla 2.6.28 kernel. Also note that I am
> running this on a raid-1, but have experienced the same problem on a
> standard partition I created on the same machine.
> 
> I created the fio job file appended as "Part 2 - dd+ls fio job file". It
> consists of one dd-like job and many small jobs reading as many data as
> ls did. I used the small test script to batch run this ("Part 3 - batch
> test").
> 
> The results for the ls-like jobs are interesting :
> 
> I/O scheduler        runt-min (msec)   runt-max (msec)
> noop                       41             10563
> anticipatory               63              8185
> deadline                   52             33387
> cfq                        43              1420

Do you have queuing enabled on your drives? You can check that in
/sys/block/sdX/device/queue_depth. Try setting those to 1 and retest all
schedulers, would be good for comparison.

raid personalities or dm complicates matters, since it introduces a
disconnect between 'ls' and the io scheduler at the bottom...

> > As a quick test, could you try and increase the slice_idle to eg 20ms?
> > Sometimes I've seen timing being slightly off, which makes us miss the
> > sync window for the ls (in your case) process. Then you get a mix of
> > async and sync IO all the time, which very much slows down the sync
> > process.
> > 
> 
> Just to confirm, the quick test you are taking about would be :
> 
> ---
>  block/cfq-iosched.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/block/cfq-iosched.c
> ===================================================================
> --- linux-2.6-lttng.orig/block/cfq-iosched.c	2009-01-18 15:17:32.000000000 -0500
> +++ linux-2.6-lttng/block/cfq-iosched.c	2009-01-18 15:46:38.000000000 -0500
> @@ -26,7 +26,7 @@ static const int cfq_back_penalty = 2;
>  static const int cfq_slice_sync = HZ / 10;
>  static int cfq_slice_async = HZ / 25;
>  static const int cfq_slice_async_rq = 2;
> -static int cfq_slice_idle = HZ / 125;
> +static int cfq_slice_idle = 20;
>  
>  /*
>   * offset from end of service tree
> 
> 
> It does not make much difference with the standard cfq test :
> 
> I/O scheduler        runt-min (msec)   runt-max (msec)
> cfq (standard)             43              1420
> cfq (20ms slice_idle)      31              1573

OK, that's good at least!

> So, I guess 1.5s delay to run ls on a directory when the cache is cold
> with a cfq I/O scheduler is somewhat acceptable, but I doubt the 8, 10
> and 33s response times for the anticipatory, noop and deadline I/O
> schedulers are. I wonder why on earth is the anticipatory I/O scheduler
> activated by default with my kernel given it results in so poor
> interactive behavior when doing large I/O ?

I see you already found out why :-)

-- 
Jens Axboe

