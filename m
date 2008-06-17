Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbYFQIgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbYFQIgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 04:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbYFQIgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 04:36:05 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25683 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbYFQIgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 04:36:02 -0400
Date: Tue, 17 Jun 2008 10:36:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Zhang, Yanmin" <yanmin.zhang@intel.com>
Cc: "Lin, Ming M" <ming.m.lin@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: FIO: kjournald blocked for more than 120 seconds
Message-ID: <20080617083600.GE20851@kernel.dk>
References: <1213581875.7398.32.camel@minggr> <20080616192950.GZ20851@kernel.dk> <37E52D09333DE2469A03574C88DBF40F02011751@pdsmsx414.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37E52D09333DE2469A03574C88DBF40F02011751@pdsmsx414.ccr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17 2008, Zhang, Yanmin wrote:
> >>-----Original Message-----
> >>From: Jens Axboe [mailto:jens.axboe@oracle.com]
> >>Sent: Tuesday, June 17, 2008 3:30 AM
> >>To: Lin, Ming M
> >>Cc: Zhang, Yanmin; Linux Kernel Mailing List
> >>Subject: Re: FIO: kjournald blocked for more than 120 seconds
> >>
> >>On Mon, Jun 16 2008, Lin Ming wrote:
> >>> Hi, Jens
> >>>
> >>> When runnig FIO benchmark, kjournald blocked for more than 120
> seconds.
> >>> Detailed root cause analysis and proposed solutions as below.
> >>>
> >>> Any comment is appreciated.
> >>>
> >>> Hardware Environment
> >>> ---------------------
> >>> 13 SEAGATE ST373307FC disks in a JBOD, connected by a Qlogic ISP2312
> >>> Fibe Channel HBA.
> >>>
> >>> Bug description
> >>> ----------------
> >>> fio vsync random read 4K in 13 disks, 4 processes per disk, fio
> global
> >>> paramter as below,
> >>> Tested 4 IO schedulers, issue is only seen in CFQ.
> >>>
> >>> INFO: task kjournald:20558 blocked for more than 120 seconds.
> >>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
> >>> message.
> >>> kjournald     D ffff810010820978  6712 20558      2
> >>> ffff81022ddb1d10 0000000000000046 ffff81022e7baa10 ffffffff803ba6f2
> >>> ffff81022ecd0000 ffff8101e6dc9160 ffff81022ecd0348 000000008048b6cb
> >>> 0000000000000086 ffff81022c4e8d30 0000000000000000 ffffffff80247537
> >>> Call Trace:
> >>> [<ffffffff803ba6f2>] kobject_get+0x12/0x17
> >>> The disks of my testing machine are tagged devices, so the CFQ idle
> >>> window is disabled. In other words, the active queue of tagged
> >>> devices(cfqd->hw_tag=1) never idle for a new request.
> >>>
> >>> This causes active queue be expired immediately if it's empty,
> although
> >>> it has not run out of time. CFQ will select next queue as active
> queue.
> >>> In this testcase, there are thousands of FIO read requests in sync
> >>> queues, only a few write requests by journal_write_commit_record in
> >>> async queues.
> >>>
> >>> In the other hand, all processes use the default io class and
> priority.
> >>> They share the async queue for the same device, but have their own
> sync
> >>> queue, so the sync queue number is 4 while asyn queue number is just
> 1
> >>> for the same device.
> >>>
> >>> So sync queue has much more chances be selected as new active queue
> than
> >>> async queue.
> >>>
> >>> Sync queues do not idle and they are dispatched all the time. This
> leads
> >>> to many unfinished requests in external queue,
> >>> namely, cfqd->sync_flight > 0.
> >>>
> >>> static int cfq_dispatch_requests (...) {
> >>> 	....
> >>> 	while ((cfqq = cfq_select_queue(cfqd)) != NULL) {
> >>> 	....
> >>> 	if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
> >>> 		break;
> >>> 		....
> >>> 		__cfq_dispatch_requests(cfqq)
> >>> 	}
> >>> 	....
> >>> }
> >>>
> >>> When cfq_select_queue selects the async queue which includes
> kjournald's
> >>> write request, this selected async queue will never be dispatched
> since
> >>> cfqd->sync_flight > 0, so kjournald is blocked.
> >>>
> >>> Proposed 3 solutions
> >>> ------------------
> >>> 1. Do not check cfqd->sync_flight
> >>>
> >>> -               if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
> >>> -                       break;
> >>>
> >>> 2. If we do need to check cfqd->sync_flight, then for tagged
> devices, we
> >>> should give a little more chances to async queue to be dispatched.
> >>>
> >>> @@ -1102,7 +1102,7 @@ static int cfq_dispatch_requests(struct
> >>> request_queue *q, int force)
> >>>                                 break;
> >>>                 }
> >>>
> >>> -               if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
> >>> +               if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq) && !
> >>> cfqd->hw_tag)
> >>>                         break;
> >>>
> >>> 3. Force write request issued by journal_write_commit_record as sync
> >>> request. As a matter of fact, it looks like most write requests
> >>> submitted by kjournald is async request. We need convert them to
> sync
> >>> requests.
> >>
> >>Thanks for the very detailed analysis of the problem, complete with
> >>suggestions. While I think that any code that does:
> >>
> >>        submit async io
> >>        wait for it
> >>
> >>should be issuing sync IO (or, better, automatically upgrade the
> request
> >>from async -> sync), we cannot rely on that.
> [YM] We can talk case by case. We could convert some important async io
> codes
>  to sync io codes at least. For example, kjournald calls
> sync_dirty_buffer what 
> we captured in this case.

I agree, we should fix the obvious cases. My point was merely that there
will probably always be missed cases, so we should attempt to handle it
in the scheduler as well. Does the below buffer patch make it any
better?

> Another case is writeback. If processes do mmapped I/O and they might
> stop in 
> page fault to wait writeback finishing. Or a buffer write might trigger
> a dirty 
> page balance. As the latest kernel is more aggressive to start
> writeback, it might 
> be an issue now.

Sync process getting stuck in async writeout is another problem of the
same variety.

diff --git a/fs/buffer.c b/fs/buffer.c
index a073f3f..1957a8f 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2978,7 +2978,7 @@ int sync_dirty_buffer(struct buffer_head *bh)
 	if (test_clear_buffer_dirty(bh)) {
 		get_bh(bh);
 		bh->b_end_io = end_buffer_write_sync;
-		ret = submit_bh(WRITE, bh);
+		ret = submit_bh(WRITE_SYNC, bh);
 		wait_on_buffer(bh);
 		if (buffer_eopnotsupp(bh)) {
 			clear_buffer_eopnotsupp(bh);

-- 
Jens Axboe

