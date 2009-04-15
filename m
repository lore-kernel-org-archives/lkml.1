Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbZDOG1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbZDOG1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbZDOG0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:26:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43510 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbZDOG0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:26:51 -0400
Date: Wed, 15 Apr 2009 08:26:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: tiobench read 50% regression with 2.6.30-rc1
Message-ID: <20090415062649.GO5178@kernel.dk>
References: <1239265763.2567.769.camel@ymzhang> <20090409095706.GD5178@kernel.dk> <1239330541.2567.779.camel@ymzhang> <20090414121431.GH5178@kernel.dk> <x49fxgaimq8.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49fxgaimq8.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15 2009, Jeff Moyer wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > On Fri, Apr 10 2009, Zhang, Yanmin wrote:
> >> On Thu, 2009-04-09 at 11:57 +0200, Jens Axboe wrote:
> >> > On Thu, Apr 09 2009, Zhang, Yanmin wrote:
> >> > > Comparing with 2.6.29's result, tiobench (read) has about 50% regression
> >> > > with 2.6.30-rc1 on all my machines. Bisect down to below patch.
> >> > > 
> >> > > b029195dda0129b427c6e579a3bb3ae752da3a93 is first bad commit
> >> > > commit b029195dda0129b427c6e579a3bb3ae752da3a93
> >> > > Author: Jens Axboe <jens.axboe@oracle.com>
> >> > > Date:   Tue Apr 7 11:38:31 2009 +0200
> >> > > 
> >> > >     cfq-iosched: don't let idling interfere with plugging
> >> > >     
> >> > >     When CFQ is waiting for a new request from a process, currently it'll
> >> > >     immediately restart queuing when it sees such a request. This doesn't
> >> > >     work very well with streamed IO, since we then end up splitting IO
> >> > >     that would otherwise have been merged nicely. For a simple dd test,
> >> > >     this causes 10x as many requests to be issued as we should have.
> >> > >     Normally this goes unnoticed due to the low overhead of requests
> >> > >     at the device side, but some hardware is very sensitive to request
> >> > >     sizes and there it can cause big slow downs.
> >> > > 
> >> > > 
> >> > > 
> >> > > Command to start the testing:
> >> > > #tiotest -k0 -k1 -k3 -f 80 -t 32
> >> > > 
> >> > > It's a multi-threaded program and starts 32 threads. Every thread does I/O
> >> > > on its own 80MB file.
> >> The files should be created before the testing and pls. drop page caches
> >> by "echo 3 >/proc/sys/vm/drop_caches" before testing.
> >> 
> >> > 
> >> > It's not a huge surprise that we regressed there. I'll get this fixed up
> >> > next week. Can you I talk you into trying to change the 'quantum' sysfs
> >> > variable for the drive? It's in /sys/block/xxx/queue/iosched where xxx
> >> > is your drive(s). It's set to 4, if you could try progressively larger
> >> > settings and retest, that would help get things started.
> >> I tried 4,8,16,64,128 and didn't find result difference.
> >
> > Can you try with this patch?
> >
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index a4809de..66f00e5 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -1905,10 +1905,17 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> >  		 * Remember that we saw a request from this process, but
> >  		 * don't start queuing just yet. Otherwise we risk seeing lots
> >  		 * of tiny requests, because we disrupt the normal plugging
> > -		 * and merging.
> > +		 * and merging. If the request is already larger than a single
> > +		 * page, let it rip immediately. For that case we assume that
> > +		 * merging is already done.
> >  		 */
> > -		if (cfq_cfqq_wait_request(cfqq))
> > +		if (cfq_cfqq_wait_request(cfqq)) {
> > +			if (blk_rq_bytes(rq) > PAGE_CACHE_SIZE) {
> > +				del_timer(&cfqd->idle_slice_timer);
> > +				blk_start_queueing(cfqd->queue);
> > +			}
> >  			cfq_mark_cfqq_must_dispatch(cfqq);
> > +		}
> >  	} else if (cfq_should_preempt(cfqd, cfqq, rq)) {
> >  		/*
> >  		 * not the active queue - expire current slice if it is
> 
> I tested this using iozone to read a file from an NFS client.  The
> iozone command line was:
>   iozone -s 2000000 -r 64 -f /mnt/test/testfile -i 1 -w
> 
> The numbers in the nfsd's row represent the number of nfsd threads.  I
> included numbers for the deadline scheduler as well for comparison.
> 
>                v2.6.29
> 
> nfsd's  |   1    |  2   |   4   |   8
> --------+---------------+-------+------
> cfq     | 91356 | 66391 | 61942 | 51674
> deadline| 43207 | 67436 | 96289 | 107784
> 
>               2.6.30-rc1
> 
> nfsd's  |   1   |   2   |   4   |   8
> --------+---------------+-------+------
> cfq     | 43127 | 22354 | 20858 | 21179
> deadline| 43732 | 68059 | 76659 | 83231
> 
>           2.6.30-rc1 + cfq fix
> 
> nfsd's  |   1    |    2   |   4   |   8
> --------+-----------------+-------+------
> cfq     | 114602 | 102280 | 43479 | 43160
> 
> As you can see, for 1 and 2 threads, the patch *really* helps out.  We
> still don't get back the performance for 4 and 8 nfsd threads, though.
> It's interesting to note that the deadline scheduler regresses for 4 and
> 8 threads, as well.  I think we've still got some digging to do.

Wow, that does indeed look pretty good!

> I'll try the cfq close cooperator patches next.

I have a pending update on the coop patch that isn't pushed out yet, I
hope to have it finalized and tested later today. Hopefully, with that,
we should be able to maintain > 100Mb/sec for 4 and 8 threads.

-- 
Jens Axboe

