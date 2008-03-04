Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbYCDQhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbYCDQhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765467AbYCDQaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:30:52 -0500
Received: from pecan.exetel.com.au ([220.233.0.17]:48615 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765024AbYCDQav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:30:51 -0500
From: oakad@exemail.com.au
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 10/11] memstick: try harder to recover from unsuccessful interface mode switch
Date: Wed,  5 Mar 2008 03:02:27 +1100
Message-Id: <1204646548-27466-11-git-send-email-oakad@exemail.com.au>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204646548-27466-10-git-send-email-oakad@exemail.com.au>
References: <1204646548-27466-1-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-2-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-3-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-4-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-5-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-6-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-7-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-8-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-9-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-10-git-send-email-oakad@exemail.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Dubov <oakad@yahoo.com>

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/core/mspro_block.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 62b913b..1d637e4 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -16,6 +16,7 @@
 #include <linux/idr.h>
 #include <linux/hdreg.h>
 #include <linux/kthread.h>
+#include <linux/delay.h>
 #include <linux/memstick.h>
 
 #define DRIVER_NAME "mspro_block"
@@ -820,7 +821,7 @@ static int mspro_block_switch_to_parallel(struct memstick_dev *card)
 	struct memstick_host *host = card->host;
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 	struct mspro_param_register param = {
-		.system = 0,
+		.system = MEMSTICK_SYS_PAR4,
 		.data_count = 0,
 		.data_address = 0,
 		.tpc_param = 0
@@ -845,8 +846,24 @@ static int mspro_block_switch_to_parallel(struct memstick_dev *card)
 	wait_for_completion(&card->mrq_complete);
 
 	if (card->current_mrq.error) {
-		msb->system = 0x80;
+		msb->system = MEMSTICK_SYS_SERIAL;
+		host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
+		msleep(1000);
+		host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
 		host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_SERIAL);
+
+		if (memstick_set_rw_addr(card))
+			return card->current_mrq.error;
+
+		param.system = msb->system;
+
+		card->next_request = h_mspro_block_req_init;
+		msb->mrq_handler = h_mspro_block_default;
+		memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG, &param,
+				  sizeof(param));
+		memstick_new_req(host);
+		wait_for_completion(&card->mrq_complete);
+
 		return -EFAULT;
 	}
 
-- 
1.5.3.6

