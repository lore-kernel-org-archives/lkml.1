Return-Path: <linux-kernel-owner+w=401wt.eu-S932771AbXCZIHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbXCZIHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 04:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932936AbXCZIHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 04:07:48 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:48818 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932771AbXCZIHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 04:07:47 -0400
Message-ID: <46077F48.2000105@sw.ru>
Date: Mon, 26 Mar 2007 12:07:36 +0400
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Markus Lidel <Markus.Lidel@shadowconnect.com>,
       Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
       linux-kernel@vger.kernel.org, devel@openvz.org
CC: Chuck Ebbert <cebbert@redhat.com>, Sam Hokin <sam@ims.net>,
       Mark Gray <mvg001@markvgray.com>,
       Enrico Scholz <enrico.scholz@informatik.tu-chemnitz.de>
Subject: [PATCH 2.6.21-rc5] [I2O] block IO errors on i2o disk
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I2O subsystem has been broken in mainstream several months ago (after 2.6.18).
The following patch from Jens Axboe splits struct request ->flags into two
parts: cmd_type and cmd_flags
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4aff5e2333c9a1609662f2091f55c3f6fffdad36

In i2o layer this patch has replaced flag REQ_SPECIAL by the according cmd_type.
However i2o has used REQ_SPECIAL not as command type but as driver-specific flag
for the debug purposes. As result all i2o requests have type "special" now, are
not processed to the hardware and fail with I/O error:

 i2o/hda:<3>Buffer I/O error on device i2o/hda, logical block 0
Buffer I/O error on device i2o/hda, logical block 0
Buffer I/O error on device i2o/hda, logical block 0
 unable to read partition table
block-osm: device added (TID: 207): i2o/hda

The following patch removes the extra debug checks without any drawbacks and
restores the normal driver's work.

Signed-off-by:	Vasily Averin <vvs@sw.ru>

--- 2.6.21-rc5/drivers/message/i2o/i2o_block.c	2007-02-04 21:44:54.000000000 +0300
+++ 2.6.21-rc5/drivers/message/i2o/i2o_block.c	2007-03-26 11:03:52.000000000 +0400
@@ -390,13 +390,6 @@ static int i2o_block_prep_req_fn(struct
 		return BLKPREP_KILL;
 	}

-	/* request is already processed by us, so return */
-	if (blk_special_request(req)) {
-		osm_debug("REQ_SPECIAL already set!\n");
-		req->cmd_flags |= REQ_DONTPREP;
-		return BLKPREP_OK;
-	}
-
 	/* connect the i2o_block_request to the request */
 	if (!req->special) {
 		ireq = i2o_block_request_alloc();
@@ -408,11 +401,8 @@ static int i2o_block_prep_req_fn(struct
 		ireq->i2o_blk_dev = i2o_blk_dev;
 		req->special = ireq;
 		ireq->req = req;
-	} else
-		ireq = req->special;
-
+	}
 	/* do not come back here */
-	req->cmd_type = REQ_TYPE_SPECIAL;
 	req->cmd_flags |= REQ_DONTPREP;

 	return BLKPREP_OK;
