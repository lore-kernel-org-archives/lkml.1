Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbZKKQuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbZKKQuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 11:50:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758150AbZKKQuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 11:50:05 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:35689 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959AbZKKQuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 11:50:03 -0500
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 13/17] hpsa: Retry driver initiated commands on unit attention
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com
Date: Wed, 11 Nov 2009 10:51:29 -0600
Message-ID: <20091111165129.17754.71091.stgit@beardog.cce.hp.com>
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpsa: Retry driver initiated commands on unit attention.
There are a some commands initiated by the driver which
are neither ioctls nor normal i/o.  If any of these commands
completes with UNIT ATTENTION, they should be retried.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/scsi/hpsa.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6f63d45..e3b80fa 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1173,7 +1173,7 @@ static void hpsa_map_one(struct pci_dev *pdev,
 	cp->Header.SGTotal = (__u16) 1; /* total sgs in this cmd list */
 }
 
-static void hpsa_scsi_do_simple_cmd_core(struct ctlr_info *h,
+static inline void hpsa_scsi_do_simple_cmd_core(struct ctlr_info *h,
 	struct CommandList *c)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
@@ -1183,6 +1183,19 @@ static void hpsa_scsi_do_simple_cmd_core(struct ctlr_info *h,
 	wait_for_completion(&wait);
 }
 
+static void hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
+	struct CommandList *c, int data_direction)
+{
+	int retry_count = 0;
+
+	do {
+		memset(c->err_info, 0, sizeof(c->err_info));
+		hpsa_scsi_do_simple_cmd_core(h, c);
+		retry_count++;
+	} while (check_for_unit_attention(h, c) && retry_count <= 3);
+	hpsa_pci_unmap(h->pdev, c, 1, data_direction);
+}
+
 static void hpsa_scsi_interpret_error(struct CommandList *cp)
 {
 	struct ErrorInfo *ei;
@@ -1262,9 +1275,7 @@ static int hpsa_scsi_do_inquiry(struct ctlr_info *h, unsigned char *scsi3addr,
 	rc = fill_cmd(c, HPSA_INQUIRY, h, buf, bufsize, page, scsi3addr,
 		TYPE_CMD);
 	if (rc == 0) {
-		hpsa_scsi_do_simple_cmd_core(h, c);
-		hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_FROMDEVICE);
-
+		hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE);
 		ei = c->err_info;
 		if (ei->CommandStatus != 0 &&
 		    ei->CommandStatus != CMD_DATA_UNDERRUN) {
@@ -1369,8 +1380,7 @@ static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
 
 	if (extended_response)
 		c->Request.CDB[1] = extended_response;
-	hpsa_scsi_do_simple_cmd_core(h, c);
-	hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_FROMDEVICE);
+	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE);
 	ei = c->err_info;
 	if (ei->CommandStatus != 0 &&
 	    ei->CommandStatus != CMD_DATA_UNDERRUN) {

