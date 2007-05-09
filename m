Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbXEIICh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbXEIICh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbXEIH7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 03:59:50 -0400
Received: from brick.kernel.dk ([80.160.20.94]:20893 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbXEIH7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 03:59:46 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 5/10] scsi: convert to using sg helpers
Date: Wed,  9 May 2007 09:59:19 +0200
Message-Id: <11786975641268-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
In-Reply-To: <11786975641643-git-send-email-jens.axboe@oracle.com>
References: <11786975641643-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the SCSI mid layer to using the sg helpers for looking up
sg elements, instead of doing it manually.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/scsi_lib.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 61fbcdc..9355c5b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -302,14 +302,15 @@ static int scsi_req_map_sg(struct request *rq, struct scatterlist *sgl,
 	struct request_queue *q = rq->q;
 	int nr_pages = (bufflen + sgl[0].offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	unsigned int data_len = 0, len, bytes, off;
+	struct scatterlist *sg;
 	struct page *page;
 	struct bio *bio = NULL;
 	int i, err, nr_vecs = 0;
 
-	for (i = 0; i < nsegs; i++) {
-		page = sgl[i].page;
-		off = sgl[i].offset;
-		len = sgl[i].length;
+	for_each_sg(sgl, sg, nsegs, i) {
+		page = sg->page;
+		off = sg->offset;
+		len = sg->length;
 		data_len += len;
 
 		while (len > 0) {
-- 
1.5.2.rc1

