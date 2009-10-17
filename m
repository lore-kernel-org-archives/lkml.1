Return-Path: <linux-kernel-owner+w=401wt.eu-S1751548AbZJQGeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbZJQGeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 02:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZJQGeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 02:34:16 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:59128 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbZJQGeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 02:34:15 -0400
Date: Sat, 17 Oct 2009 08:34:18 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/14] drivers/message: Move dereference after NULL test
Message-ID: <Pine.LNX.4.64.0910170833480.9213@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test on dev->i2o_dev or i2o_dev is needed, then the dereference
should be after the NULL test.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/message/i2o/i2o_block.c |    3 ++-
 drivers/message/i2o/i2o_scsi.c  |    3 +--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index d505b68..67da0aa 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -711,7 +711,7 @@ static int i2o_block_transfer(struct request *req)
 {
 	struct i2o_block_device *dev = req->rq_disk->private_data;
 	struct i2o_controller *c;
-	u32 tid = dev->i2o_dev->lct_data.tid;
+	u32 tid;
 	struct i2o_message *msg;
 	u32 *mptr;
 	struct i2o_block_request *ireq = req->special;
@@ -727,6 +727,7 @@ static int i2o_block_transfer(struct request *req)
 		goto exit;
 	}
 
+	tid = dev->i2o_dev->lct_data.tid;
 	c = dev->i2o_dev->iop;
 
 	msg = i2o_msg_get(c);
diff --git a/drivers/message/i2o/i2o_scsi.c b/drivers/message/i2o/i2o_scsi.c
index 3d45817..ea6b219 100644
--- a/drivers/message/i2o/i2o_scsi.c
+++ b/drivers/message/i2o/i2o_scsi.c
@@ -528,7 +528,6 @@ static int i2o_scsi_queuecommand(struct scsi_cmnd *SCpnt,
 	 *      Do the incoming paperwork
 	 */
 	i2o_dev = SCpnt->device->hostdata;
-	c = i2o_dev->iop;
 
 	SCpnt->scsi_done = done;
 
@@ -538,7 +537,7 @@ static int i2o_scsi_queuecommand(struct scsi_cmnd *SCpnt,
 		done(SCpnt);
 		goto exit;
 	}
-
+	c = i2o_dev->iop;
 	tid = i2o_dev->lct_data.tid;
 
 	osm_debug("qcmd: Tid = %03x\n", tid);
