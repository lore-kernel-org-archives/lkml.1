Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbXC3VRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbXC3VRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbXC3VQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:16:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51688 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbXC3VMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:12:02 -0400
Date: Fri, 30 Mar 2007 14:06:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Vasily Averin <vvs@sw.ru>,
       Markus Lidel <Markus.Lidel@shadowconnect.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 28/37] i2o: block IO errors on i2o disk
Message-ID: <20070330210637.GE29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i2o-block-io-errors-on-i2o-disk.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Vasily Averin <vvs@sw.ru>

[PATCH] i2o: block IO errors on i2o disk

I2O subsystem has been broken in mainstream several months ago (after
2.6.18).  Commit 4aff5e2333c9a1609662f2091f55c3f6fffdad36 from Jens
Axboe split struct request ->flags into two parts: cmd_type and
cmd_flags.

In i2o layer this patch has replaced flag REQ_SPECIAL by the according
cmd_type.  However i2o has used REQ_SPECIAL not as command type but as
driver-specific flag for the debug purposes.  As result all i2o requests
have type "special" now, are not processed to the hardware and fail with
I/O error:

   i2o/hda:<3>Buffer I/O error on device i2o/hda, logical block 0
  Buffer I/O error on device i2o/hda, logical block 0
  Buffer I/O error on device i2o/hda, logical block 0
   unable to read partition table
  block-osm: device added (TID: 207): i2o/hda

The following patch removes the extra debug checks without any drawbacks and
restores the normal driver's work.

Signed-off-by:	Vasily Averin <vvs@sw.ru>
Acked-by: Markus Lidel <Markus.Lidel@shadowconnect.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
From: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/message/i2o/i2o_block.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
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

-- 
