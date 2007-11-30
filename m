Return-Path: <linux-kernel-owner+w=401wt.eu-S1760614AbXK3X2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614AbXK3X2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758088AbXK3X20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:28:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758747AbXK3X2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:28:25 -0500
Date: Fri, 30 Nov 2007 18:27:33 -0500 (EST)
Message-Id: <20071130.182733.111208989.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 07/28] blk_end_request: changing floppy (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts floppy to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/floppy.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/block/floppy.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/block/floppy.c
+++ 2.6.24-rc3-mm2/drivers/block/floppy.c
@@ -2290,18 +2290,16 @@ static int do_format(int drive, struct f
 static void floppy_end_request(struct request *req, int uptodate)
 {
 	unsigned int nr_sectors = current_count_sectors;
+	unsigned int drive = (unsigned int)req->rq_disk->private_data;
 
 	/* current_count_sectors can be zero if transfer failed */
 	if (!uptodate)
 		nr_sectors = req->current_nr_sectors;
-	if (end_that_request_first(req, uptodate, nr_sectors))
+	if (__blk_end_request(req, uptodate, nr_sectors << 9))
 		return;
-	add_disk_randomness(req->rq_disk);
-	floppy_off((long)req->rq_disk->private_data);
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, uptodate);
 
 	/* We're done with the request */
+	floppy_off(drive);
 	current_req = NULL;
 }
 
