Return-Path: <linux-kernel-owner+w=401wt.eu-S932204AbXK3Xet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbXK3Xet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbXK3XeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:34:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763538AbXK3XeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:34:16 -0500
Date: Fri, 30 Nov 2007 18:33:03 -0500 (EST)
Message-Id: <20071130.183303.106440108.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 21/28] blk_end_request: changing xsysace (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts xsysace to use blk_end_request().

xsysace is a little bit different from "normal" drivers.
xsysace driver has a state machine in it.
It calls end_that_request_first() and end_that_request_last()
from different states. (ACE_FSM_STATE_REQ_TRANSFER and
ACE_FSM_STATE_REQ_COMPLETE, respectively.)

However, those states are consecutive and without any interruption
inbetween.
So we can just follow the standard conversion rule (b) mentioned in
the patch subject "[PATCH 01/27] blk_end_request: add new request
completion interface".

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/xsysace.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/block/xsysace.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/block/xsysace.c
+++ 2.6.24-rc3-mm2/drivers/block/xsysace.c
@@ -703,7 +703,7 @@ static void ace_fsm_dostate(struct ace_d
 
 		/* bio finished; is there another one? */
 		i = ace->req->current_nr_sectors;
-		if (end_that_request_first(ace->req, 1, i)) {
+		if (__blk_end_request(ace->req, 1, i)) {
 			/* dev_dbg(ace->dev, "next block; h=%li c=%i\n",
 			 *      ace->req->hard_nr_sectors,
 			 *      ace->req->current_nr_sectors);
@@ -718,9 +718,6 @@ static void ace_fsm_dostate(struct ace_d
 		break;
 
 	case ACE_FSM_STATE_REQ_COMPLETE:
-		/* Complete the block request */
-		blkdev_dequeue_request(ace->req);
-		end_that_request_last(ace->req, 1);
 		ace->req = NULL;
 
 		/* Finished request; go to idle state */
