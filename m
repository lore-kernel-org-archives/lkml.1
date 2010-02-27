Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030655Ab0B0SpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:45:17 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:62344 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030625Ab0B0SpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:45:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lPBPp7cZ1RXQmYro4SOLehzhJ3uR3lrzDp8ThYQ5ayr1nW60z2esaMx5RgM0S3MajI
         TnAxI3oH852Fa6eM/tbBYOTEuQCjRCzl4RxT/z6gPC+kVyVfpnCfbMSH3Hc/IOU05IGi
         0TbkUEn0M9WoeJoG8iqzXZZSxYG/15Q6qHaWU=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Corrado Zoccolo <czoccolo@gmail.com>
Subject: [PATCH 2/2] cfq-iosched: rethink seeky detection for SSDs
Date: Sat, 27 Feb 2010 19:45:40 +0100
Message-Id: <1267296340-3820-3-git-send-email-czoccolo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1267296340-3820-2-git-send-email-czoccolo@gmail.com>
References: <1267296340-3820-1-git-send-email-czoccolo@gmail.com>
 <1267296340-3820-2-git-send-email-czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CFQ currently applies the same logic of detecting seeky queues and
grouping them together for rotational disks as well as SSDs.
For SSDs, the time to complete a request doesn't depend on the
request location, but only on the size.
This patch therefore changes the criterion to group queues by
request size in case of SSDs, in order to achieve better fairness.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 806d30b..f27e535 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -47,6 +47,7 @@ static const int cfq_hist_divisor = 4;
 #define CFQ_SERVICE_SHIFT       12
 
 #define CFQQ_SEEK_THR		(sector_t)(8 * 100)
+#define CFQQ_SECT_THR_NONROT	(sector_t)(2 * 32)
 #define CFQQ_SEEKY(cfqq)	(hweight32(cfqq->seek_history) > 32/8)
 
 #define RQ_CIC(rq)		\
@@ -2958,6 +2959,7 @@ cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		       struct request *rq)
 {
 	sector_t sdist = 0;
+	sector_t n_sec = blk_rq_sectors(rq);
 	if (cfqq->last_request_pos) {
 		if (cfqq->last_request_pos < blk_rq_pos(rq))
 			sdist = blk_rq_pos(rq) - cfqq->last_request_pos;
@@ -2966,7 +2968,10 @@ cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	}
 
 	cfqq->seek_history <<= 1;
-	cfqq->seek_history |= (sdist > CFQQ_SEEK_THR);
+	if (blk_queue_nonrot(cfqd->queue))
+		cfqq->seek_history |= (n_sec < CFQQ_SECT_THR_NONROT);
+	else
+		cfqq->seek_history |= (sdist > CFQQ_SEEK_THR);
 }
 
 /*
-- 
1.6.4.4

