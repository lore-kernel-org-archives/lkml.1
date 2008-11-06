Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYKFPfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYKFPfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 10:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYKFPeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 10:34:44 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37307 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbYKFPen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 10:34:43 -0500
Message-Id: <20081106153135.944900461@redhat.com>
References: <20081106153022.215696930@redhat.com>
User-Agent: quilt/0.46-1
Date: Thu, 06 Nov 2008 10:30:26 -0500
From: vgoyal@redhat.com
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>
Cc: fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       ngupta@google.com, Rik van Riel <riel@redhat.com>,
       Jeff Moyer <jmoyer@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 4/4] io controller: Put IO controller to use in device mapper and standard make_request() function
Content-Disposition: inline; filename=bio-cgroup-tweak-make-request-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


o Tweak standard make_request() function and also the device mapper make
  request functions to enable use of IO controller.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Index: linux17/drivers/md/dm.c
===================================================================
--- linux17.orig/drivers/md/dm.c	2008-11-05 18:12:42.000000000 -0500
+++ linux17/drivers/md/dm.c	2008-11-06 09:16:32.000000000 -0500
@@ -22,6 +22,7 @@
 #include <linux/hdreg.h>
 #include <linux/blktrace_api.h>
 #include <linux/smp_lock.h>
+#include <linux/biocontrol.h>
 
 #define DM_MSG_PREFIX "core"
 
@@ -885,6 +886,7 @@ static int dm_request(struct request_que
 	int r = -EIO;
 	int rw = bio_data_dir(bio);
 	struct mapped_device *md = q->queuedata;
+	int ret;
 
 	/*
 	 * There is no use in forwarding any barrier request since we can't
@@ -895,6 +897,13 @@ static int dm_request(struct request_que
 		return 0;
 	}
 
+	if (!bio_cgroup_disabled() && blk_queue_bio_group_enabled(q)) {
+		ret = bio_group_controller(q, bio);
+		if (ret)
+			/* Either bio got buffered for bio_endio() done */
+			return 0;
+	}
+
 	down_read(&md->io_lock);
 
 	disk_stat_inc(dm_disk(md), ios[rw]);
@@ -1081,6 +1090,10 @@ static struct mapped_device *alloc_dev(i
 	md->queue->unplug_fn = dm_unplug_all;
 	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
 
+	/* Initialize queue spin lock */
+	md->queue->queue_lock = &md->queue->__queue_lock;
+	spin_lock_init(md->queue->queue_lock);
+
 	md->io_pool = mempool_create_slab_pool(MIN_IOS, _io_cache);
 	if (!md->io_pool)
 		goto bad_io_pool;
Index: linux17/block/blk-core.c
===================================================================
--- linux17.orig/block/blk-core.c	2008-11-06 09:14:20.000000000 -0500
+++ linux17/block/blk-core.c	2008-11-06 09:16:32.000000000 -0500
@@ -1117,10 +1117,18 @@ static int __make_request(struct request
 	int el_ret, nr_sectors, barrier, err;
 	const unsigned short prio = bio_prio(bio);
 	const int sync = bio_sync(bio);
-	int rw_flags;
+	int rw_flags, ret;
 
 	nr_sectors = bio_sectors(bio);
 
+	if (!bio_cgroup_disabled() && blk_queue_bio_group_enabled(q)) {
+		ret = bio_group_controller(q, bio);
+		if (ret) {
+			/* Either bio got buffered for bio_endio() done */
+			return 0;
+		}
+	}
+
 	/*
 	 * low level driver can indicate that it wants pages above a
 	 * certain limit bounced to low memory (ie for highmem, or even

-- 

