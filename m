Return-Path: <linux-kernel-owner+w=401wt.eu-S1761135AbZLJRIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761135AbZLJRIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761072AbZLJRIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:08:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761043AbZLJRIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:08:46 -0500
Date: Thu, 10 Dec 2009 12:08:45 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Moyer Jeff Moyer <jmoyer@redhat.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [PATCH] Fix a CFQ crash in "for-2.6.33" branch of block tree
Message-ID: <20091210170845.GA8327@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I think my previous patch introduced a bug which can lead to CFQ hitting
BUG_ON().

The offending commit in for-2.6.33 branch is.

commit 7667aa0630407bc07dc38dcc79d29cc0a65553c1
Author: Vivek Goyal <vgoyal@redhat.com>
Date:   Tue Dec 8 17:52:58 2009 -0500

    cfq-iosched: Take care of corner cases of group losing share due to deletion

While doing some stress testing on my box, I enountered following.

login: [ 3165.148841] BUG: scheduling while
atomic: swapper/0/0x10000100
[ 3165.149821] Modules linked in: cfq_iosched dm_multipath qla2xxx igb
scsi_transport_fc dm_snapshot [last unloaded: scsi_wait_scan]
[ 3165.149821] Pid: 0, comm: swapper Not tainted
2.6.32-block-for-33-merged-new #3
[ 3165.149821] Call Trace:
[ 3165.149821]  <IRQ>  [<ffffffff8103fab8>] __schedule_bug+0x5c/0x60
[ 3165.149821]  [<ffffffff8103afd7>] ? __wake_up+0x44/0x4d
[ 3165.149821]  [<ffffffff8153a979>] schedule+0xe3/0x7bc
[ 3165.149821]  [<ffffffff8103a796>] ? cpumask_next+0x1d/0x1f
[ 3165.149821]  [<ffffffffa000b21d>] ? cfq_dispatch_requests+0x6ba/0x93e
[cfq_iosched]
[ 3165.149821]  [<ffffffff810422d8>] __cond_resched+0x2a/0x35
[ 3165.149821]  [<ffffffffa000b21d>] ? cfq_dispatch_requests+0x6ba/0x93e
[cfq_iosched]
[ 3165.149821]  [<ffffffff8153b1ee>] _cond_resched+0x2c/0x37
[ 3165.149821]  [<ffffffff8100e2db>] is_valid_bugaddr+0x16/0x2f
[ 3165.149821]  [<ffffffff811e4161>] report_bug+0x18/0xac
[ 3165.149821]  [<ffffffff8100f1fc>] die+0x39/0x63
[ 3165.149821]  [<ffffffff8153cde1>] do_trap+0x11a/0x129
[ 3165.149821]  [<ffffffff8100d470>] do_invalid_op+0x96/0x9f
[ 3165.149821]  [<ffffffffa000b21d>] ? cfq_dispatch_requests+0x6ba/0x93e
[cfq_iosched]
[ 3165.149821]  [<ffffffff81034b4d>] ? enqueue_task+0x5c/0x67
[ 3165.149821]  [<ffffffff8103ae83>] ? task_rq_unlock+0x11/0x13
[ 3165.149821]  [<ffffffff81041aae>] ? try_to_wake_up+0x292/0x2a4
[ 3165.149821]  [<ffffffff8100c935>] invalid_op+0x15/0x20
[ 3165.149821]  [<ffffffffa000b21d>] ? cfq_dispatch_requests+0x6ba/0x93e
[cfq_iosched]
[ 3165.149821]  [<ffffffff810df5a6>] ? virt_to_head_page+0xe/0x2f
[ 3165.149821]  [<ffffffff811d8c2a>] blk_peek_request+0x191/0x1a7
[ 3165.149821]  [<ffffffff811e5b8d>] ? kobject_get+0x1a/0x21
[ 3165.149821]  [<ffffffff812c8d4c>] scsi_request_fn+0x82/0x3df
[ 3165.149821]  [<ffffffff8110b2de>] ? bio_fs_destructor+0x15/0x17
[ 3165.149821]  [<ffffffff810df5a6>] ? virt_to_head_page+0xe/0x2f
[ 3165.149821]  [<ffffffff811d931f>] __blk_run_queue+0x42/0x71
[ 3165.149821]  [<ffffffff811d9403>] blk_run_queue+0x26/0x3a
[ 3165.149821]  [<ffffffff812c8761>] scsi_run_queue+0x2de/0x375
[ 3165.149821]  [<ffffffff812b60ac>] ? put_device+0x17/0x19
[ 3165.149821]  [<ffffffff812c92d7>] scsi_next_command+0x3b/0x4b
[ 3165.149821]  [<ffffffff812c9b9f>] scsi_io_completion+0x1c9/0x3f5
[ 3165.149821]  [<ffffffff812c3c36>] scsi_finish_command+0xb5/0xbe

I think I have hit following BUG_ON() in cfq_dispatch_request().

BUG_ON(RB_EMPTY_ROOT(&cfqq->sort_list));

Please find attached the patch to fix it. I have done some stress testing
with it and have not seen it happening again.


o We should wait on a queue even after slice expiry only if it is empty. If
  queue is not empty then continue to expire it.

o If we decide to keep the queue then make cfqq=NULL. Otherwise select_queue()
  will return a valid cfqq and cfq_dispatch_request() can hit following
  BUG_ON().

  BUG_ON(RB_EMPTY_ROOT(&cfqq->sort_list))

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux2/block/cfq-iosched.c
===================================================================
--- linux2.orig/block/cfq-iosched.c	2009-12-09 09:54:08.000000000 -0500
+++ linux2/block/cfq-iosched.c	2009-12-10 11:05:45.000000000 -0500
@@ -2145,10 +2145,11 @@ static struct cfq_queue *cfq_select_queu
 		 * have been idling all along on this queue and it should be
 		 * ok to wait for this request to complete.
 		 */
-		if (cfqq->cfqg->nr_cfqq == 1 && cfqq->dispatched
-		    && cfq_should_idle(cfqd, cfqq))
+		if (cfqq->cfqg->nr_cfqq == 1 && RB_EMPTY_ROOT(&cfqq->sort_list)
+		    && cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
+			cfqq = NULL;
 			goto keep_queue;
-		else
+		} else
 			goto expire;
 	}
 
