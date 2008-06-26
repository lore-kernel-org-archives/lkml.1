Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbYFZJtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbYFZJtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYFZJtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:49:16 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20212 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbYFZJtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:49:15 -0400
Date: Thu, 26 Jun 2008 11:49:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: FIO: kjournald blocked for more than 120 seconds
Message-ID: <20080626094912.GN20851@kernel.dk>
References: <1213581875.7398.32.camel@minggr> <20080616192950.GZ20851@kernel.dk> <37E52D09333DE2469A03574C88DBF40F02011751@pdsmsx414.ccr.corp.intel.com> <20080617083600.GE20851@kernel.dk> <1213693347.21721.8.camel@minggr> <20080617093119.GL20851@kernel.dk> <1214472823.3057.7.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214472823.3057.7.camel@minggr.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26 2008, Lin Ming wrote:
> Jens,
> 
> How about below patch?
> 
> If cfqd->sync_flight > 0, we still allow async queue to be dispached,
> and its slice time would be decreased. So sync queue never starve async
> queue.
> 
> Introduce a sysfs interface cfq_slice_async_penalty to adjust the
> percentages of slice that will be decreased.

I don't think it's a good change, for a variety of reasons:

- The reason we don't dispatch async with sync in flight, is to avoid
  interference of the async IO with the sync IO. Perhaps that is OK in
  this case, since elv_dispatch_sort() by default doesn't allow crossing
  read vs write boundaries.

- async queue is typically expired immediately, so the slice length
  doesn't factor into it so much.

- I don't think more tunables are going to help solve anything.

With the current check, we risk starving async IO in presence of lots of
sync IO. Without the check, we risk starving sync process in presence of
lots of async IO. So we need some sort of middle ground. Async IO is
penalized in the presence of lots of sync IO already. As the number of
sync queues grow, async IO gets a continually smaller part of the total
disk time. That isn't very fair to begin with.

For 2.6.26, how about adding the WRITE_SYNC change to buffer.c that we
discussed earlier? I've been using it here since and it's a less risky
change. Then for 2.6.27 we can look into tweaking CFQ.



> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  block/cfq-iosched.c |   33 ++++++++++++++++++++++++++++++++-
>  1 files changed, 32 insertions(+), 1 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index d01b411..8bdc931 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -26,6 +26,12 @@ static const int cfq_slice_sync = HZ / 10;
>  static int cfq_slice_async = HZ / 25;
>  static const int cfq_slice_async_rq = 2;
>  static int cfq_slice_idle = HZ / 125;
> +/*
> + * penalty of dispatching async queue
> + * if there are unfinished requests in sync queue
> + * by default, 50% of time slice decreased
> + */
> +static int cfq_slice_async_penalty = 50;
>  
>  /*
>   * offset from end of service tree
> @@ -114,6 +120,7 @@ struct cfq_data {
>  	unsigned int cfq_slice[2];
>  	unsigned int cfq_slice_async_rq;
>  	unsigned int cfq_slice_idle;
> +	unsigned int cfq_slice_async_penalty;
>  
>  	struct list_head cic_list;
>  };
> @@ -288,6 +295,25 @@ static inline int cfq_slice_used(struct cfq_queue
> *cfqq)
>  }
>  
>  /*
> + * Get the slice time to be decreased
> + * when async queue is dispatched and
> + * there are unfinished requests in sync queue
> + */
> +static inline int
> +cfq_async_penalty(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> +{
> +	int penalty;
> +
> +	if (cfq_cfqq_sync(cfqq))
> +		return 0;
> +
> +	penalty = (cfqq->slice_end - jiffies) *
> +			cfqd->cfq_slice_async_penalty / 100;
> +
> +	return penalty;
> +}
> +
> +/*
>   * Lifted from AS - choose which of rq1 and rq2 that is best served
> now.
>   * We choose the request that is closest to the head right now.
> Distance
>   * behind the head is penalized and only allowed to a certain extent.
> @@ -1103,7 +1129,7 @@ static int cfq_dispatch_requests(struct
> request_queue *q, int force)
>  		}
>  
>  		if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
> -			break;
> +			cfqq->slice_end -= cfq_async_penalty(cfqd, cfqq);
>  
>  		cfq_clear_cfqq_must_dispatch(cfqq);
>  		cfq_clear_cfqq_wait_request(cfqq);
> @@ -2143,6 +2169,7 @@ static void *cfq_init_queue(struct request_queue
> *q)
>  	cfqd->cfq_slice[1] = cfq_slice_sync;
>  	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
>  	cfqd->cfq_slice_idle = cfq_slice_idle;
> +	cfqd->cfq_slice_async_penalty = cfq_slice_async_penalty;
>  
>  	return cfqd;
>  }
> @@ -2211,6 +2238,7 @@ SHOW_FUNCTION(cfq_slice_idle_show,
> cfqd->cfq_slice_idle, 1);
>  SHOW_FUNCTION(cfq_slice_sync_show, cfqd->cfq_slice[1], 1);
>  SHOW_FUNCTION(cfq_slice_async_show, cfqd->cfq_slice[0], 1);
>  SHOW_FUNCTION(cfq_slice_async_rq_show, cfqd->cfq_slice_async_rq, 0);
> +SHOW_FUNCTION(cfq_slice_async_penalty_show,
> cfqd->cfq_slice_async_penalty, 0);
>  #undef SHOW_FUNCTION
>  
>  #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
> @@ -2242,6 +2270,8 @@ STORE_FUNCTION(cfq_slice_sync_store,
> &cfqd->cfq_slice[1], 1, UINT_MAX, 1);
>  STORE_FUNCTION(cfq_slice_async_store, &cfqd->cfq_slice[0], 1, UINT_MAX,
> 1);
>  STORE_FUNCTION(cfq_slice_async_rq_store, &cfqd->cfq_slice_async_rq, 1,
>  		UINT_MAX, 0);
> +STORE_FUNCTION(cfq_slice_async_penalty_store,
> &cfqd->cfq_slice_async_penalty, 0,
> +		100, 0);
>  #undef STORE_FUNCTION
>  
>  #define CFQ_ATTR(name) \
> @@ -2257,6 +2287,7 @@ static struct elv_fs_entry cfq_attrs[] = {
>  	CFQ_ATTR(slice_async),
>  	CFQ_ATTR(slice_async_rq),
>  	CFQ_ATTR(slice_idle),
> +	CFQ_ATTR(slice_async_penalty),
>  	__ATTR_NULL
>  };
>  
> Lin Ming
> 
> On Tue, 2008-06-17 at 11:31 +0200, Jens Axboe wrote:
> > On Tue, Jun 17 2008, Lin Ming wrote:
> > > 
> > > On Tue, 2008-06-17 at 10:36 +0200, Jens Axboe wrote:
> > > > On Tue, Jun 17 2008, Zhang, Yanmin wrote:
> > > > > >>-----Original Message-----
> > > > > >>From: Jens Axboe [mailto:jens.axboe@oracle.com]
> > > > > >>Sent: Tuesday, June 17, 2008 3:30 AM
> > > > > >>To: Lin, Ming M
> > > > > >>Cc: Zhang, Yanmin; Linux Kernel Mailing List
> > > > > >>Subject: Re: FIO: kjournald blocked for more than 120 seconds
> > > > > >>
> > > > > >>On Mon, Jun 16 2008, Lin Ming wrote:
> > > > > >>> Hi, Jens
> > > > > >>>
> > > > > >>> When runnig FIO benchmark, kjournald blocked for more than 120
> > > > > seconds.
> > > > > >>> Detailed root cause analysis and proposed solutions as below.
> > > > > >>>
> > > > > >>> Any comment is appreciated.
> > > > > >>>
> > > > > >>> Hardware Environment
> > > > > >>> ---------------------
> > > > > >>> 13 SEAGATE ST373307FC disks in a JBOD, connected by a Qlogic ISP2312
> > > > > >>> Fibe Channel HBA.
> > > > > >>>
> > > > > >>> Bug description
> > > > > >>> ----------------
> > > > > >>> fio vsync random read 4K in 13 disks, 4 processes per disk, fio
> > > > > global
> > > > > >>> paramter as below,
> > > > > >>> Tested 4 IO schedulers, issue is only seen in CFQ.
> > > > > >>>
> > > > > >>> INFO: task kjournald:20558 blocked for more than 120 seconds.
> > > > > >>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> > > > > >>> message.
> > > > > >>> kjournald     D ffff810010820978  6712 20558      2
> > > > > >>> ffff81022ddb1d10 0000000000000046 ffff81022e7baa10 ffffffff803ba6f2
> > > > > >>> ffff81022ecd0000 ffff8101e6dc9160 ffff81022ecd0348 000000008048b6cb
> > > > > >>> 0000000000000086 ffff81022c4e8d30 0000000000000000 ffffffff80247537
> > > > > >>> Call Trace:
> > > > > >>> [<ffffffff803ba6f2>] kobject_get+0x12/0x17
> > > > > >>> The disks of my testing machine are tagged devices, so the CFQ idle
> > > > > >>> window is disabled. In other words, the active queue of tagged
> > > > > >>> devices(cfqd->hw_tag=1) never idle for a new request.
> > > > > >>>
> > > > > >>> This causes active queue be expired immediately if it's empty,
> > > > > although
> > > > > >>> it has not run out of time. CFQ will select next queue as active
> > > > > queue.
> > > > > >>> In this testcase, there are thousands of FIO read requests in sync
> > > > > >>> queues, only a few write requests by journal_write_commit_record in
> > > > > >>> async queues.
> > > > > >>>
> > > > > >>> In the other hand, all processes use the default io class and
> > > > > priority.
> > > > > >>> They share the async queue for the same device, but have their own
> > > > > sync
> > > > > >>> queue, so the sync queue number is 4 while asyn queue number is just
> > > > > 1
> > > > > >>> for the same device.
> > > > > >>>
> > > > > >>> So sync queue has much more chances be selected as new active queue
> > > > > than
> > > > > >>> async queue.
> > > > > >>>
> > > > > >>> Sync queues do not idle and they are dispatched all the time. This
> > > > > leads
> > > > > >>> to many unfinished requests in external queue,
> > > > > >>> namely, cfqd->sync_flight > 0.
> > > > > >>>
> > > > > >>> static int cfq_dispatch_requests (...) {
> > > > > >>> 	....
> > > > > >>> 	while ((cfqq = cfq_select_queue(cfqd)) != NULL) {
> > > > > >>> 	....
> > > > > >>> 	if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
> > > > > >>> 		break;
> > > > > >>> 		....
> > > > > >>> 		__cfq_dispatch_requests(cfqq)
> > > > > >>> 	}
> > > > > >>> 	....
> > > > > >>> }
> > > > > >>>
> > > > > >>> When cfq_select_queue selects the async queue which includes
> > > > > kjournald's
> > > > > >>> write request, this selected async queue will never be dispatched
> > > > > since
> > > > > >>> cfqd->sync_flight > 0, so kjournald is blocked.
> > > > > >>>
> > > > > >>> Proposed 3 solutions
> > > > > >>> ------------------
> > > > > >>> 1. Do not check cfqd->sync_flight
> > > > > >>>
> > > > > >>> -               if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
> > > > > >>> -                       break;
> > > > > >>>
> > > > > >>> 2. If we do need to check cfqd->sync_flight, then for tagged
> > > > > devices, we
> > > > > >>> should give a little more chances to async queue to be dispatched.
> > > > > >>>
> > > > > >>> @@ -1102,7 +1102,7 @@ static int cfq_dispatch_requests(struct
> > > > > >>> request_queue *q, int force)
> > > > > >>>                                 break;
> > > > > >>>                 }
> > > > > >>>
> > > > > >>> -               if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
> > > > > >>> +               if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq) && !
> > > > > >>> cfqd->hw_tag)
> > > > > >>>                         break;
> > > > > >>>
> > > > > >>> 3. Force write request issued by journal_write_commit_record as sync
> > > > > >>> request. As a matter of fact, it looks like most write requests
> > > > > >>> submitted by kjournald is async request. We need convert them to
> > > > > sync
> > > > > >>> requests.
> > > > > >>
> > > > > >>Thanks for the very detailed analysis of the problem, complete with
> > > > > >>suggestions. While I think that any code that does:
> > > > > >>
> > > > > >>        submit async io
> > > > > >>        wait for it
> > > > > >>
> > > > > >>should be issuing sync IO (or, better, automatically upgrade the
> > > > > request
> > > > > >>from async -> sync), we cannot rely on that.
> > > > > [YM] We can talk case by case. We could convert some important async io
> > > > > codes
> > > > >  to sync io codes at least. For example, kjournald calls
> > > > > sync_dirty_buffer what 
> > > > > we captured in this case.
> > > > 
> > > > I agree, we should fix the obvious cases. My point was merely that there
> > > > will probably always be missed cases, so we should attempt to handle it
> > > > in the scheduler as well. Does the below buffer patch make it any
> > > > better?
> > > 
> > > Yes, kjournald blocked issue is gone with below patch applied.
> > 
> > I think it's obviously the right thing to do, but I'm also a bit worried
> > about applying it so close to 2.6.26 release. OTOH, we need to do
> > SOMETHING for 2.6.26 release, so...
> > 
> > > 
> > > Lin Ming
> > > 
> > > > 
> > > > > Another case is writeback. If processes do mmapped I/O and they might
> > > > > stop in 
> > > > > page fault to wait writeback finishing. Or a buffer write might trigger
> > > > > a dirty 
> > > > > page balance. As the latest kernel is more aggressive to start
> > > > > writeback, it might 
> > > > > be an issue now.
> > > > 
> > > > Sync process getting stuck in async writeout is another problem of the
> > > > same variety.
> > > > 
> > > > diff --git a/fs/buffer.c b/fs/buffer.c
> > > > index a073f3f..1957a8f 100644
> > > > --- a/fs/buffer.c
> > > > +++ b/fs/buffer.c
> > > > @@ -2978,7 +2978,7 @@ int sync_dirty_buffer(struct buffer_head *bh)
> > > >  	if (test_clear_buffer_dirty(bh)) {
> > > >  		get_bh(bh);
> > > >  		bh->b_end_io = end_buffer_write_sync;
> > > > -		ret = submit_bh(WRITE, bh);
> > > > +		ret = submit_bh(WRITE_SYNC, bh);
> > > >  		wait_on_buffer(bh);
> > > >  		if (buffer_eopnotsupp(bh)) {
> > > >  			clear_buffer_eopnotsupp(bh);
> > > > 
> > > 
> > 
> 

-- 
Jens Axboe

