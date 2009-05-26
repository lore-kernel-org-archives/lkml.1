Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbZEZCQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbZEZCQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 22:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbZEZCQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 22:16:30 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:64831 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbZEZCQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 22:16:30 -0400
Message-ID: <4A1B50F8.1050401@ct.jp.nec.com>
Date: Tue, 26 May 2009 11:16:24 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 2.6-block/for-2.6.31] block: fix no diskstat problem
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

The commit below in 2.6-block/for-2.6.31 causes no diskstat problem
because the blk_discard_rq() check was added with '&&'.
It should be 'blk_fs_request() || blk_discard_rq()'.
This patch does it and fixes the no diskstat problem.
Please review and apply.

------ /proc/diskstat without this patch -------------------------------------
   8       0 sda 0 0 0 0 0 0 0 0 0 0 0
------------------------------------------------------------------------------

----- /proc/diskstat with this patch applied ---------------------------------
   8       0 sda 4186 303 373621 61600 9578 3859 107468 169479 2 89755 231059
------------------------------------------------------------------------------

--------------------------------------------------------------------------
commit c69d48540c201394d08cb4d48b905e001313d9b8
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Apr 24 08:12:19 2009 +0200

    block: include discard requests in IO accounting
    
    We currently don't do merging on discard requests, but we potentially
    could. If we do, then we need to include discard requests in the IO
    accounting, or merging would end up decrementing in_flight IO counters
    for an IO which never incremented them.
    
    So enable accounting for discard requests.
    
<snip>

 static inline int blk_do_io_stat(struct request *rq)
 {
-       return rq->rq_disk && blk_rq_io_stat(rq) && blk_fs_request(rq);
+       return rq->rq_disk && blk_rq_io_stat(rq) && blk_fs_request(rq) &&
+               blk_discard_rq(rq);
 }
--------------------------------------------------------------------------

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-block/block/blk.h
===================================================================
--- linux-2.6-block.orig/block/blk.h
+++ linux-2.6-block/block/blk.h
@@ -156,12 +156,12 @@ static inline int blk_cpu_to_group(int c
  *
  *	a) it's attached to a gendisk, and
  *	b) the queue had IO stats enabled when this request was started, and
- *	c) it's a file system request
+ *	c) it's a file system request or a discard request
  */
 static inline int blk_do_io_stat(struct request *rq)
 {
-	return rq->rq_disk && blk_rq_io_stat(rq) && blk_fs_request(rq) &&
-		blk_discard_rq(rq);
+	return rq->rq_disk && blk_rq_io_stat(rq) &&
+	       (blk_fs_request(rq) || blk_discard_rq(rq));
 }
 
 #endif
