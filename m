Return-Path: <linux-kernel-owner+w=401wt.eu-S1760969AbXEJLog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760969AbXEJLog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760827AbXEJLlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:41:20 -0400
Received: from brick.kernel.dk ([80.160.20.94]:4886 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758056AbXEJLlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:41:09 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 5/12] scsi: convert to using sg helpers
Date: Thu, 10 May 2007 13:40:30 +0200
Message-Id: <11787972373853-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
In-Reply-To: <11787972373654-git-send-email-jens.axboe@oracle.com>
References: <11787972373654-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the SCSI mid layer to using the sg helpers for looking up
sg elements, instead of doing it manually.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/scsi_lib.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1f5a07b..f944690 100644
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
@@ -2240,18 +2241,19 @@ EXPORT_SYMBOL_GPL(scsi_target_unblock);
  *
  * Returns virtual address of the start of the mapped page
  */
-void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
+void *scsi_kmap_atomic_sg(struct scatterlist *sgl, int sg_count,
 			  size_t *offset, size_t *len)
 {
 	int i;
 	size_t sg_len = 0, len_complete = 0;
+	struct scatterlist *sg;
 	struct page *page;
 
 	WARN_ON(!irqs_disabled());
 
-	for (i = 0; i < sg_count; i++) {
+	for_each_sg(sgl, sg, sg_count, i) {
 		len_complete = sg_len; /* Complete sg-entries */
-		sg_len += sg[i].length;
+		sg_len += sg->length;
 		if (sg_len > *offset)
 			break;
 	}
@@ -2265,10 +2267,10 @@ void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 	}
 
 	/* Offset starting from the beginning of first page in this sg-entry */
-	*offset = *offset - len_complete + sg[i].offset;
+	*offset = *offset - len_complete + sg->offset;
 
 	/* Assumption: contiguous pages can be accessed as "page + i" */
-	page = nth_page(sg[i].page, (*offset >> PAGE_SHIFT));
+	page = nth_page(sg->page, (*offset >> PAGE_SHIFT));
 	*offset &= ~PAGE_MASK;
 
 	/* Bytes in this sg-entry from *offset to the end of the page */
-- 
1.5.2.rc1

