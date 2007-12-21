Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbXLUU5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbXLUU5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 15:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbXLUU52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 15:57:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbXLUU51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 15:57:27 -0500
Date: Fri, 21 Dec 2007 15:57:14 -0500 (EST)
Message-Id: <20071221.155714.71084400.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH] (linux-2.6-block.git) xsysace: fix size misconversion of
 blk_end_request
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I found this change is not yet included in your linux-2.6-block.git tree:
    http://marc.info/?l=linux-kernel&m=119747954926232&w=2

Please apply this patch (just a rebased version of the above)
to your for-akpm branch before Andrew pulls.
Otherwise, xsysace driver will not work correctly.


This patch fixes the misconversion from sector to byte
in the blk_end_request patch-set.

In ace_fsm_dostate(), the variable 'i' was used only for passing
sector size of the request to __end_end_request().
So I removed it and changed the code to pass the size in bytes
directly to __blk_end_request().

Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/xsysace.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -483,7 +483,6 @@ static void ace_fsm_dostate(struct ace_d
 	u32 status;
 	u16 val;
 	int count;
-	int i;
 
 #if defined(DEBUG)
 	dev_dbg(ace->dev, "fsm_state=%i, id_req_count=%i\n",
@@ -688,7 +687,6 @@ static void ace_fsm_dostate(struct ace_d
 		}
 
 		/* Transfer the next buffer */
-		i = 16;
 		if (ace->fsm_task == ACE_TASK_WRITE)
 			ace->reg_ops->dataout(ace);
 		else
@@ -702,8 +700,8 @@ static void ace_fsm_dostate(struct ace_d
 		}
 
 		/* bio finished; is there another one? */
-		i = ace->req->current_nr_sectors;
-		if (__blk_end_request(ace->req, 0, i)) {
+		if (__blk_end_request(ace->req, 0,
+				      blk_rq_cur_bytes(ace->req))) {
 			/* dev_dbg(ace->dev, "next block; h=%li c=%i\n",
 			 *      ace->req->hard_nr_sectors,
 			 *      ace->req->current_nr_sectors);

Thanks,
Kiyoshi Ueda
