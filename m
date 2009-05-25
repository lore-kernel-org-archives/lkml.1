Return-Path: <linux-kernel-owner+w=401wt.eu-S1753683AbZEYHbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbZEYHbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZEYHbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:31:14 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38654 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbZEYHbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:31:11 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 01/13] libata: get rid of ATA_MAX_QUEUE loop in ata_qc_complete_multiple()
Date: Mon, 25 May 2009 09:30:44 +0200
Message-Id: <1243236668-3398-2-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We very rarely (if ever) complete more than one command in the
sactive mask at the time, even for extremely high IO rates. So
looping over the entire range of possible tags is pointless,
instead use __ffs() to just find the completed tags directly.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/ata/libata-core.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c924230..ca4d208 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5031,7 +5031,6 @@ int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active)
 {
 	int nr_done = 0;
 	u32 done_mask;
-	int i;
 
 	done_mask = ap->qc_active ^ qc_active;
 
@@ -5041,16 +5040,16 @@ int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active)
 		return -EINVAL;
 	}
 
-	for (i = 0; i < ATA_MAX_QUEUE; i++) {
+	while (done_mask) {
 		struct ata_queued_cmd *qc;
+		unsigned int tag = __ffs(done_mask);
 
-		if (!(done_mask & (1 << i)))
-			continue;
-
-		if ((qc = ata_qc_from_tag(ap, i))) {
+		qc = ata_qc_from_tag(ap, tag);
+		if (qc) {
 			ata_qc_complete(qc);
 			nr_done++;
 		}
+		done_mask &= ~(1 << tag);
 	}
 
 	return nr_done;
-- 
1.6.3.rc0.1.gf800

