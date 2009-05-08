Return-Path: <linux-kernel-owner+w=401wt.eu-S1761564AbZEHC4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761564AbZEHC4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 22:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbZEHC4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:56:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:36172 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230AbZEHC4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:56:09 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, rusty@rustcorp.com.au,
       James.Bottomley@HansenPartnership.com, mike.miller@hp.com,
       donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net,
       Geert.Uytterhoeven@sonycom.com, davem@davemloft.net,
       Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com,
       grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk,
       sfr@canb.auug.org.au, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, oakad@yahoo.com, drzeus@drzeus.cx,
       dwmw2@infradead.org, Markus.Lidel@shadowconnect.com, wein@de.ibm.com,
       schwidefsky@de.ibm.com, zaitcev@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/18] mg_disk: fix queue hang / infinite retry on !fs requests
Date: Fri,  8 May 2009 11:54:00 +0900
Message-Id: <1241751256-17435-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 02:54:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both request functions in mg_disk simply return when they encounter a
!fs request, which means the request will never be cleared from the
queue causing queue hang and indefinite retry of the request.  Fix it.

While at it, flatten condition checks and add unlikely to !fs tests.

[ Impact: fix possible queue hang / infinite retry of !fs requests ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: unsik Kim <donari75@gmail.com>
---
 drivers/block/mg_disk.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 826c349..be32388 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -672,16 +672,16 @@ static void mg_request_poll(struct request_queue *q)
 
 	while ((req = elv_next_request(q)) != NULL) {
 		host = req->rq_disk->private_data;
-		if (blk_fs_request(req)) {
-			switch (rq_data_dir(req)) {
-			case READ:
-				mg_read(req);
-				break;
-			case WRITE:
-				mg_write(req);
-				break;
-			}
+
+		if (unlikely(!blk_fs_request(req))) {
+			__blk_end_request_cur(req, -EIO);
+			continue;
 		}
+
+		if (rq_data_dir(req) == READ)
+			mg_read(req);
+		else
+			mg_write(req);
 	}
 }
 
@@ -766,8 +766,10 @@ static void mg_request(struct request_queue *q)
 			continue;
 		}
 
-		if (!blk_fs_request(req))
-			return;
+		if (unlikely(!blk_fs_request(req))) {
+			__blk_end_request_cur(req, -EIO);
+			continue;
+		}
 
 		if (!mg_issue_req(req, host, sect_num, sect_cnt))
 			return;
-- 
1.6.0.2

