Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbYFPCNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbYFPCNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 22:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYFPCNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 22:13:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:26681 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbYFPCNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 22:13:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,649,1204531200"; 
   d="scan'208";a="577935393"
Subject: FIO: kjournald blocked for more than 120 seconds
From: Lin Ming <ming.m.lin@intel.com>
To: jens.axboe@oracle.com
Cc: "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 10:04:35 +0800
Message-Id: <1213581875.7398.32.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jens

When runnig FIO benchmark, kjournald blocked for more than 120 seconds.
Detailed root cause analysis and proposed solutions as below.

Any comment is appreciated.

Hardware Environment
---------------------
13 SEAGATE ST373307FC disks in a JBOD, connected by a Qlogic ISP2312
Fibe Channel HBA.

Bug description
----------------
fio vsync random read 4K in 13 disks, 4 processes per disk, fio global
paramter as below,
[global]
direct=0
ioengine=vsync
iodepth=256
iodepth_batch=32
size=2G
bs=4k
numjobs=2
loops=5
runtime=1200
group_reporting

Tested 4 IO schedulers, issue is only seen in CFQ.

INFO: task kjournald:20558 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
kjournald     D ffff810010820978  6712 20558      2
ffff81022ddb1d10 0000000000000046 ffff81022e7baa10 ffffffff803ba6f2
ffff81022ecd0000 ffff8101e6dc9160 ffff81022ecd0348 000000008048b6cb
0000000000000086 ffff81022c4e8d30 0000000000000000 ffffffff80247537
Call Trace:
[<ffffffff803ba6f2>] kobject_get+0x12/0x17
[<ffffffff80247537>] getnstimeofday+0x2f/0x83
[<ffffffff8029c1ac>] sync_buffer+0x0/0x3f
[<ffffffff8066d195>] io_schedule+0x5d/0x9f
[<ffffffff8029c1e7>] sync_buffer+0x3b/0x3f
[<ffffffff8066d3f0>] __wait_on_bit+0x40/0x6f
[<ffffffff8029c1ac>] sync_buffer+0x0/0x3f
[<ffffffff8066d48b>] out_of_line_wait_on_bit+0x6c/0x78
[<ffffffff80243909>] wake_bit_function+0x0/0x23
[<ffffffff8029e3ad>] sync_dirty_buffer+0x98/0xcb
[<ffffffff8030056b>] journal_commit_transaction+0x97d/0xcb6
[<ffffffff8023a676>] lock_timer_base+0x26/0x4b
[<ffffffff8030300a>] kjournald+0xc1/0x1fb
[<ffffffff802438db>] autoremove_wake_function+0x0/0x2e
[<ffffffff80302f49>] kjournald+0x0/0x1fb
[<ffffffff802437bb>] kthread+0x47/0x74
[<ffffffff8022de51>] schedule_tail+0x28/0x5d
[<ffffffff8020cac8>] child_rip+0xa/0x12
[<ffffffff80243774>] kthread+0x0/0x74
[<ffffffff8020cabe>] child_rip+0x0/0x12

Other people reported the similar issue on LKML. 
http://lkml.org/lkml/2008/3/26/494 

I did lots of kernel instrumentation and testing, and located the root
cause.

Root cause analysis
-------------------

kjournald is blocked at: 
journal_write_commit_record -> 
sync_dirty_buffer(bh) -> 
wait_on_buffer(bh)

Buffer is submitted but it never finished.

git bisect to below patch,

commit cc19747977824ece6aa1c56a29e974fef5ec2b32
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Apr 20 20:45:39 2007 +0200

    cfq-iosched: tighten queue request overlap condition
    
    For tagged devices, allow overlap of requests if the idle window
    isn't enabled on the current active queue.
    
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a8237be..e859b49 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -989,7 +989,8 @@ static struct cfq_queue *cfq_select_queue(struct
cfq_data *cfqd)
* flight or is idling for a new request, allow either of these
* conditions to happen (or time out) before selecting a new queue.
*/
- if (cfqq->dispatched || timer_pending(&cfqd->idle_slice_timer)) {
+ if (timer_pending(&cfqd->idle_slice_timer) ||
+     (cfqq->dispatched && cfq_cfqq_idle_window(cfqq))) {
cfqq = NULL;
goto keep_queue;
}

The disks of my testing machine are tagged devices, so the CFQ idle
window is disabled. In other words, the active queue of tagged
devices(cfqd->hw_tag=1) never idle for a new request.

This causes active queue be expired immediately if it's empty, although
it has not run out of time. CFQ will select next queue as active queue.
In this testcase, there are thousands of FIO read requests in sync
queues, only a few write requests by journal_write_commit_record in
async queues.

In the other hand, all processes use the default io class and priority.
They share the async queue for the same device, but have their own sync
queue, so the sync queue number is 4 while asyn queue number is just 1
for the same device.

So sync queue has much more chances be selected as new active queue than
async queue.

Sync queues do not idle and they are dispatched all the time. This leads
to many unfinished requests in external queue, 
namely, cfqd->sync_flight > 0.

static int cfq_dispatch_requests (...) {
	....
	while ((cfqq = cfq_select_queue(cfqd)) != NULL) {
	....
	if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
		break;
		....
		__cfq_dispatch_requests(cfqq)
	}
	....
}

When cfq_select_queue selects the async queue which includes kjournald's
write request, this selected async queue will never be dispatched since
cfqd->sync_flight > 0, so kjournald is blocked.

Proposed 3 solutions
------------------
1. Do not check cfqd->sync_flight

-               if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
-                       break;

2. If we do need to check cfqd->sync_flight, then for tagged devices, we
should give a little more chances to async queue to be dispatched.

@@ -1102,7 +1102,7 @@ static int cfq_dispatch_requests(struct
request_queue *q, int force)
                                break;
                }

-               if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq))
+               if (cfqd->sync_flight && !cfq_cfqq_sync(cfqq) && !
cfqd->hw_tag)
                        break;

3. Force write request issued by journal_write_commit_record as sync
request. As a matter of fact, it looks like most write requests
submitted by kjournald is async request. We need convert them to sync
requests.

Cheers,
Lin Ming






