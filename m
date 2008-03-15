Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbYCOO7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbYCOO7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 10:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbYCOO6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 10:58:44 -0400
Received: from pecan.exetel.com.au ([220.233.0.17]:51413 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751861AbYCOO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 10:58:43 -0400
From: oakad@exemail.com.au
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 2/3] memstick: add support for 8-bit parallel mode
Date: Sun, 16 Mar 2008 01:58:37 +1100
Message-Id: <1205593118-30418-2-git-send-email-oakad@exemail.com.au>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1205593118-30418-1-git-send-email-oakad@exemail.com.au>
References: <1205593118-30418-1-git-send-email-oakad@exemail.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Dubov <oakad@yahoo.com>

Newer MemoryStick (HG) cards and hosts support 8-bit parallel mode of
operation in addition to original 4-bit and 1-bit modes.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/core/mspro_block.c |   81 +++++++++++++++++++++++-----------
 1 files changed, 55 insertions(+), 26 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index e5356f9..557dbbb 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -816,12 +816,13 @@ static int mspro_block_wait_for_ced(struct memstick_dev *card)
 	return card->current_mrq.error;
 }
 
-static int mspro_block_switch_to_parallel(struct memstick_dev *card)
+static int mspro_block_set_interface(struct memstick_dev *card,
+				     unsigned char sys_reg)
 {
 	struct memstick_host *host = card->host;
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 	struct mspro_param_register param = {
-		.system = MEMSTICK_SYS_PAR4,
+		.system = sys_reg,
 		.data_count = 0,
 		.data_address = 0,
 		.tpc_param = 0
@@ -833,41 +834,70 @@ static int mspro_block_switch_to_parallel(struct memstick_dev *card)
 			  sizeof(param));
 	memstick_new_req(host);
 	wait_for_completion(&card->mrq_complete);
-	if (card->current_mrq.error)
-		return card->current_mrq.error;
+	return card->current_mrq.error;
+}
+
+static int mspro_block_switch_interface(struct memstick_dev *card)
+{
+	struct memstick_host *host = card->host;
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	int rc = 0;
+
+	if (msb->caps & MEMSTICK_CAP_PAR4)
+		rc = mspro_block_set_interface(card, MEMSTICK_SYS_PAR4);
+	else
+		return 0;
+
+	if (rc) {
+		printk(KERN_WARNING
+		       "%s: could not switch to 4-bit mode, error %d\n",
+		       card->dev.bus_id, rc);
+		return 0;
+	}
 
 	msb->system = MEMSTICK_SYS_PAR4;
 	host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_PAR4);
+	printk(KERN_INFO "%s: switching to 4-bit parallel mode\n",
+	       card->dev.bus_id);
+
+	if (msb->caps & MEMSTICK_CAP_PAR8) {
+		rc = mspro_block_set_interface(card, MEMSTICK_SYS_PAR8);
+
+		if (!rc) {
+			msb->system = MEMSTICK_SYS_PAR8;
+			host->set_param(host, MEMSTICK_INTERFACE,
+					MEMSTICK_PAR8);
+			printk(KERN_INFO
+			       "%s: switching to 8-bit parallel mode\n",
+			       card->dev.bus_id);
+		} else
+			printk(KERN_WARNING
+			       "%s: could not switch to 8-bit mode, error %d\n",
+			       card->dev.bus_id, rc);
+	}
 
 	card->next_request = h_mspro_block_req_init;
 	msb->mrq_handler = h_mspro_block_default;
 	memstick_init_req(&card->current_mrq, MS_TPC_GET_INT, NULL, 1);
 	memstick_new_req(card->host);
 	wait_for_completion(&card->mrq_complete);
+	rc = card->current_mrq.error;
 
-	if (card->current_mrq.error) {
+	if (rc) {
+		printk(KERN_WARNING
+		       "%s: interface error, trying to fall back to serial\n",
+		       card->dev.bus_id);
 		msb->system = MEMSTICK_SYS_SERIAL;
 		host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
-		msleep(1000);
+		msleep(10);
 		host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
 		host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
 
-		if (memstick_set_rw_addr(card))
-			return card->current_mrq.error;
-
-		param.system = msb->system;
-
-		card->next_request = h_mspro_block_req_init;
-		msb->mrq_handler = h_mspro_block_default;
-		memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG, &param,
-				  sizeof(param));
-		memstick_new_req(host);
-		wait_for_completion(&card->mrq_complete);
-
-		return -EFAULT;
+		rc = memstick_set_rw_addr(card);
+		if (!rc)
+			rc = mspro_block_set_interface(card, msb->system);
 	}
-
-	return 0;
+	return rc;
 }
 
 /* Memory allocated for attributes by this function should be freed by
@@ -1053,12 +1083,11 @@ static int mspro_block_init_card(struct memstick_dev *card)
 		return -EIO;
 
 	msb->caps = host->caps;
-	if (msb->caps & MEMSTICK_CAP_PAR4) {
-		if (mspro_block_switch_to_parallel(card))
-			printk(KERN_WARNING "%s: could not switch to "
-			       "parallel interface\n", card->dev.bus_id);
-	}
+	rc = mspro_block_switch_interface(card);
+	if (rc)
+		return rc;
 
+	msleep(200);
 	rc = mspro_block_wait_for_ced(card);
 	if (rc)
 		return rc;
-- 
1.5.3.6

