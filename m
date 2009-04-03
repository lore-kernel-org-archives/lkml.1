Return-Path: <linux-kernel-owner+w=401wt.eu-S1765426AbZDCLtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765426AbZDCLtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765345AbZDCLtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:49:13 -0400
Received: from sh.osrg.net ([192.16.179.4]:39850 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765328AbZDCLtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:49:12 -0400
Date: Fri, 3 Apr 2009 20:49:03 +0900
To: Jens.Axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: fix SG_IO to return a proper error value
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090403204911X.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 03 Apr 2009 20:49:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_rq_unmap_user() returns -EFAULT if a program passes an invalid
address to kernel. SG_IO path needs to pass the returned value to user
space instead of ignoring it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/scsi_ioctl.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 626ee27..84b7f87 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -217,7 +217,7 @@ static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 				 struct bio *bio)
 {
-	int ret = 0;
+	int r, ret = 0;
 
 	/*
 	 * fill in all the output members
@@ -242,7 +242,9 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 			ret = -EFAULT;
 	}
 
-	blk_rq_unmap_user(bio);
+	r = blk_rq_unmap_user(bio);
+	if (!ret)
+		ret = r;
 	blk_put_request(rq);
 
 	return ret;
-- 
1.6.0.6

