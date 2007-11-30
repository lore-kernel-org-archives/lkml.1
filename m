Return-Path: <linux-kernel-owner+w=401wt.eu-S1763489AbXK3XdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763489AbXK3XdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763556AbXK3Xcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:32:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761777AbXK3Xcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:32:50 -0500
Date: Fri, 30 Nov 2007 18:32:26 -0500 (EST)
Message-Id: <20071130.183226.131913635.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 19/28] blk_end_request: changing scsi (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts scsi mid-layer to use blk_end_request().

The comment above scsi_next_command() is not related to this change.
It had originally been there before scsi_next_command() was included
in scsi_finalize_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/scsi/scsi_lib.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/scsi/scsi_lib.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/scsi/scsi_lib.c
+++ 2.6.24-rc3-mm2/drivers/scsi/scsi_lib.c
@@ -683,7 +683,7 @@ static struct scsi_cmnd *scsi_end_reques
 	 * If there are blocks left over at the end, set up the command
 	 * to queue the remainder of them.
 	 */
-	if (end_that_request_chunk(req, uptodate, bytes)) {
+	if (blk_end_request(req, uptodate, bytes)) {
 		int leftover = (req->hard_nr_sectors << 9);
 
 		if (blk_pc_request(req))
@@ -691,7 +691,7 @@ static struct scsi_cmnd *scsi_end_reques
 
 		/* kill remainder if no retrys */
 		if (!uptodate && blk_noretry_request(req))
-			end_that_request_chunk(req, 0, leftover);
+			blk_end_request(req, 0, leftover);
 		else {
 			if (requeue) {
 				/*
@@ -706,7 +706,11 @@ static struct scsi_cmnd *scsi_end_reques
 		}
 	}
 
-	scsi_finalize_request(cmd, uptodate);
+	/*
+	 * This will goose the queue request function at the end, so we don't
+	 * need to worry about launching another command.
+	 */
+	scsi_next_command(cmd);
 	return NULL;
 }
 
