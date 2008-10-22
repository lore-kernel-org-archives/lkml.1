Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbYJVHk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbYJVHk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 03:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYJVHkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 03:40:32 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:57795 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbYJVHka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 03:40:30 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, jeff@garzik.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/2] libata: get rid of ATA_MAX_QUEUE loop in ata_qc_complete_multiple()
Date: Wed, 22 Oct 2008 09:40:42 +0200
Message-Id: <1224661243-7929-2-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.0.2.588.g3102
In-Reply-To: <1224661243-7929-1-git-send-email-jens.axboe@oracle.com>
References: <1224661243-7929-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We very rarely (if ever) complete more than one command in the
sactive mask at the time, even for extremely high IO rates. So
looping over the entire range of possible tags is pointless,
instead use __ffs() to just find the completed tags directly.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/ata/libata-core.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 1ee9499..c3c53e7 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4799,9 +4799,9 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
  */
 int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active)
 {
+	unsigned int i = 0;
 	int nr_done = 0;
 	u32 done_mask;
-	int i;
 
 	done_mask = ap->qc_active ^ qc_active;
 
@@ -4811,16 +4811,19 @@ int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active)
 		return -EINVAL;
 	}
 
-	for (i = 0; i < ATA_MAX_QUEUE; i++) {
+	while (done_mask) {
 		struct ata_queued_cmd *qc;
+		unsigned int next = __ffs(done_mask);
 
-		if (!(done_mask & (1 << i)))
-			continue;
-
-		if ((qc = ata_qc_from_tag(ap, i))) {
+		qc = ata_qc_from_tag(ap, i + next);
+		if (qc) {
 			ata_qc_complete(qc);
 			nr_done++;
 		}
+		if (++next >= ATA_MAX_QUEUE)
+			break;
+		i += next;
+		done_mask >>= next;
 	}
 
 	return nr_done;
-- 
1.6.0.2.588.g3102

