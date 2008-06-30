Return-Path: <linux-kernel-owner+w=401wt.eu-S1761081AbYF3XyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081AbYF3XyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 19:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbYF3XxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 19:53:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:64574 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbYF3XxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 19:53:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,729,1204531200"; 
   d="scan'208";a="403806300"
From: Tomas Winkler <tomas.winkler@intel.com>
To: drzeus-list@drzeus.cx
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5/5] MMC: cleanup endianity conversions
Date: Tue,  1 Jul 2008 02:53:04 +0300
Message-Id: <1214869984-20115-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1214869984-20115-4-git-send-email-tomas.winkler@intel.com>
References: <1214869984-20115-1-git-send-email-tomas.winkler@intel.com>
 <1214869984-20115-2-git-send-email-tomas.winkler@intel.com>
 <1214869984-20115-3-git-send-email-tomas.winkler@intel.com>
 <1214869984-20115-4-git-send-email-tomas.winkler@intel.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up endianity conversions im mmc core

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/mmc/card/block.c   |    5 ++---
 drivers/mmc/core/mmc_ops.c |   12 ++++++------
 drivers/mmc/core/sd_ops.c  |    7 ++++---
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index f9ad960..4b840de 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -144,7 +144,7 @@ struct mmc_blk_request {
 static u32 mmc_sd_num_wr_blocks(struct mmc_card *card)
 {
 	int err;
-	u32 blocks;
+	__be32 blocks;
 
 	struct mmc_request mrq;
 	struct mmc_command cmd;
@@ -203,9 +203,8 @@ static u32 mmc_sd_num_wr_blocks(struct mmc_card *card)
 	if (cmd.error || data.error)
 		return (u32)-1;
 
-	blocks = ntohl(blocks);
 
-	return blocks;
+	return be32_to_cpu(blocks);
 }
 
 static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index e6703e5..3ad340c 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -271,17 +271,17 @@ mmc_send_cxd_data(struct mmc_card *card, struct mmc_host *host,
 int mmc_send_csd(struct mmc_card *card, u32 *csd)
 {
 	int ret, i;
-
+	__be32 csd_buf[4];
 	if (!mmc_host_is_spi(card->host))
 		return mmc_send_cxd_native(card->host, card->rca << 16,
 				csd, MMC_SEND_CSD);
 
-	ret = mmc_send_cxd_data(card, card->host, MMC_SEND_CSD, csd, 16);
+	ret = mmc_send_cxd_data(card, card->host, MMC_SEND_CSD, csd_buf, 16);
 	if (ret)
 		return ret;
 
 	for (i = 0;i < 4;i++)
-		csd[i] = be32_to_cpu(csd[i]);
+		csd[i] = be32_to_cpu(csd_buf[i]);
 
 	return 0;
 }
@@ -289,7 +289,7 @@ int mmc_send_csd(struct mmc_card *card, u32 *csd)
 int mmc_send_cid(struct mmc_host *host, u32 *cid)
 {
 	int ret, i;
-
+	__be32 cid_buf[4];
 	if (!mmc_host_is_spi(host)) {
 		if (!host->card)
 			return -EINVAL;
@@ -297,12 +297,12 @@ int mmc_send_cid(struct mmc_host *host, u32 *cid)
 				cid, MMC_SEND_CID);
 	}
 
-	ret = mmc_send_cxd_data(NULL, host, MMC_SEND_CID, cid, 16);
+	ret = mmc_send_cxd_data(NULL, host, MMC_SEND_CID, cid_buf, 16);
 	if (ret)
 		return ret;
 
 	for (i = 0;i < 4;i++)
-		cid[i] = be32_to_cpu(cid[i]);
+		cid[i] = be32_to_cpu(cid_buf[i]);
 
 	return 0;
 }
diff --git a/drivers/mmc/core/sd_ops.c b/drivers/mmc/core/sd_ops.c
index 0d96080..7ef7b6c 100644
--- a/drivers/mmc/core/sd_ops.c
+++ b/drivers/mmc/core/sd_ops.c
@@ -254,6 +254,7 @@ int mmc_app_send_scr(struct mmc_card *card, u32 *scr)
 	struct mmc_command cmd;
 	struct mmc_data data;
 	struct scatterlist sg;
+	__be32 scr_buf[2];
 
 	BUG_ON(!card);
 	BUG_ON(!card->host);
@@ -282,7 +283,7 @@ int mmc_app_send_scr(struct mmc_card *card, u32 *scr)
 	data.sg = &sg;
 	data.sg_len = 1;
 
-	sg_init_one(&sg, scr, 8);
+	sg_init_one(&sg, scr_buf, 8);
 
 	mmc_set_data_timeout(&data, card);
 
@@ -293,8 +294,8 @@ int mmc_app_send_scr(struct mmc_card *card, u32 *scr)
 	if (data.error)
 		return data.error;
 
-	scr[0] = be32_to_cpu(scr[0]);
-	scr[1] = be32_to_cpu(scr[1]);
+	scr[0] = be32_to_cpu(scr_buf[0]);
+	scr[1] = be32_to_cpu(scr_buf[1]);
 
 	return 0;
 }
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

