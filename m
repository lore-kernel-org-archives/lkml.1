Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbYHMIOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbYHMIOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYHMIOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:14:34 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:33549 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYHMIOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:14:33 -0400
Subject: [PATCH] virtio_blk: use a wrapper function to access io context
	information of IO requests
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       =?UTF-8?Q?=E5=90=89=E5=B7=9D_=E6=8B=93=E5=93=89?= 
	<yoshikawa.takuya@oss.ntt.co.jp>,
       dpshah@google.com
In-Reply-To: <1218611163.8001.108.camel@sebastian.kern.oss.ntt.co.jp>
References: <1218014196.4419.44.camel@sebastian.kern.oss.ntt.co.jp>
	 <200808070633.06112.rusty@rustcorp.com.au>
	 <1218611163.8001.108.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 13 Aug 2008 17:14:31 +0900
Message-Id: <1218615271.16667.38.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty, Jens

What do you think about the patch below? Does it make sense?

---

struct request has an ioprio member but it is never updated because
currently bios do not hold io context information. The implication of
this is that virtio_blk ends up passing useless information to the
backend driver.

That said, some IO schedulers such as CFQ do store io context
information in struct request, but use private members for that, which
means that that information cannot be directly accessed in a IO
scheduler-independent way.

This patch adds a function to obtain the ioprio of a request. We should
avoid accessing ioprio directly and use this function instead, so that
its users do not have to care about changes in block layer structures or
the currently active IO controller.

This patch does not introduce any functional changes but paves the way
for future clean-ups and enhancements. 

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.27-rc3/drivers/block/virtio_blk.c linux-2.6.27-rc3-fixes/drivers/block/virtio_blk.c
--- linux-2.6.27-rc3/drivers/block/virtio_blk.c	2008-08-13 14:25:46.000000000 +0900
+++ linux-2.6.27-rc3-fixes/drivers/block/virtio_blk.c	2008-08-13 16:36:34.000000000 +0900
@@ -84,11 +84,11 @@ static bool do_req(struct request_queue 
 	if (blk_fs_request(vbr->req)) {
 		vbr->out_hdr.type = 0;
 		vbr->out_hdr.sector = vbr->req->sector;
-		vbr->out_hdr.ioprio = vbr->req->ioprio;
+		vbr->out_hdr.ioprio = req_get_bio(vbr->req);
 	} else if (blk_pc_request(vbr->req)) {
 		vbr->out_hdr.type = VIRTIO_BLK_T_SCSI_CMD;
 		vbr->out_hdr.sector = 0;
-		vbr->out_hdr.ioprio = vbr->req->ioprio;
+		vbr->out_hdr.ioprio = req_get_bio(vbr->req);
 	} else {
 		/* We don't put anything else in the queue. */
 		BUG();
diff -urNp linux-2.6.27-rc3/include/linux/blkdev.h linux-2.6.27-rc3-fixes/include/linux/blkdev.h
--- linux-2.6.27-rc3/include/linux/blkdev.h	2008-08-13 14:25:57.000000000 +0900
+++ linux-2.6.27-rc3-fixes/include/linux/blkdev.h	2008-08-13 16:36:40.000000000 +0900
@@ -233,6 +233,11 @@ struct request {
 	struct request *next_rq;
 };
 
+static inline unsigned short req_get_bio(struct request *req)
+{
+	return req->ioprio;
+}
+
 /*
  * State information carried for REQ_TYPE_PM_SUSPEND and REQ_TYPE_PM_RESUME
  * requests. Some step values could eventually be made generic.


