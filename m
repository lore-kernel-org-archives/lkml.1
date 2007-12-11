Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbXLKWog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbXLKWog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756152AbXLKWny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:43:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371AbXLKWnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:43:51 -0500
Date: Tue, 11 Dec 2007 17:42:53 -0500 (EST)
Message-Id: <20071211.174253.106440139.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com, jdike@karaya.com
Subject: [PATCH 05/30] blk_end_request: changing um (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts um to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

As a result, the interface of internal function, ubd_end_request(),
is changed.

Cc: Jeff Dike <jdike@karaya.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 arch/um/drivers/ubd_kern.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

Index: 2.6.24-rc4/arch/um/drivers/ubd_kern.c
===================================================================
--- 2.6.24-rc4.orig/arch/um/drivers/ubd_kern.c
+++ 2.6.24-rc4/arch/um/drivers/ubd_kern.c
@@ -475,17 +475,9 @@ static void do_ubd_request(struct reques
 /* Only changed by ubd_init, which is an initcall. */
 int thread_fd = -1;
 
-static void ubd_end_request(struct request *req, int bytes, int uptodate)
+static void ubd_end_request(struct request *req, int bytes, int error)
 {
-	if (!end_that_request_first(req, uptodate, bytes >> 9)) {
-		struct ubd *dev = req->rq_disk->private_data;
-		unsigned long flags;
-
-		add_disk_randomness(req->rq_disk);
-		spin_lock_irqsave(&dev->lock, flags);
-		end_that_request_last(req, uptodate);
-		spin_unlock_irqrestore(&dev->lock, flags);
-	}
+	blk_end_request(req, error, bytes);
 }
 
 /* Callable only from interrupt context - otherwise you need to do
@@ -493,10 +485,10 @@ static void ubd_end_request(struct reque
 static inline void ubd_finish(struct request *req, int bytes)
 {
 	if(bytes < 0){
-		ubd_end_request(req, 0, 0);
+		ubd_end_request(req, 0, -EIO);
 		return;
 	}
-	ubd_end_request(req, bytes, 1);
+	ubd_end_request(req, bytes, 0);
 }
 
 static LIST_HEAD(restart);
