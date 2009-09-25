Return-Path: <linux-kernel-owner+w=401wt.eu-S1752780AbZIYOKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbZIYOKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 10:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZIYOKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 10:10:20 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:37777 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbZIYOKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 10:10:19 -0400
Date: Fri, 25 Sep 2009 10:10:14 -0400
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, jack@suse.cz
Subject: [PATCH] bdi_sync_writeback should WB_SYNC_NONE first
Message-ID: <20090925141014.GB15853@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, jens.axboe@oracle.com, jack@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt012.oracle.com [141.146.116.21]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4ABCCF48.016E:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At unmount time, we do writeback in two stages.  First we call
sync_filesystems with wait == 0, and then we call it with wait == 1.

When wait == 1, WB_SYNC_ALL is used.  WB_SYNC_ALL will pass wait == 1 to
the filesystem write_inode function if the inode was I_DIRTY_SYNC, and
the filesystem write_inode function is then expected to commit the
running transaction.

The new bdi threads try to keep this two stage writeback, but the
problem is that they do it by calling bdi_writeback_all, which just
kicks a few procs here and there and returns.

The end result is that btrfs is getting stuck in a loop where it commits
the transaction for every dirty inode, and unmount takes forever.

This patch is one possible fix. It just changes bdi_sync_writeback to
always do a WB_SYNC_NONE run synchronously before the WB_SYNC_ALL run.
I'm not sure I've got the bdi calling conventions right, but we need
something along these lines.

We could also make a synchronous form of bdi_writeback_all, but unmount
really isn't the common case so I think this patch is sufficient.

Signed-off-by: Chris Mason <chris.mason@oracle.com>

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8e1e5e1..27f8e0e 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -225,7 +225,7 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
 {
 	struct wb_writeback_args args = {
 		.sb		= sb,
-		.sync_mode	= WB_SYNC_ALL,
+		.sync_mode	= WB_SYNC_NONE,
 		.nr_pages	= LONG_MAX,
 		.range_cyclic	= 0,
 	};
@@ -236,6 +236,13 @@ static void bdi_sync_writeback(struct backing_dev_info *bdi,
 
 	bdi_queue_work(bdi, &work);
 	bdi_wait_on_work_clear(&work);
+
+	args.sync_mode = WB_SYNC_ALL;
+	args.nr_pages = LONG_MAX;
+
+	work.state = WS_USED | WS_ONSTACK;
+	bdi_queue_work(bdi, &work);
+	bdi_wait_on_work_clear(&work);
 }
 
 /**
