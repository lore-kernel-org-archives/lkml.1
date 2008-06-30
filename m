Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbYF3XxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbYF3XxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 19:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbYF3XxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 19:53:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:29435 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbYF3XxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 19:53:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,729,1204531200"; 
   d="scan'208";a="347303415"
From: Tomas Winkler <tomas.winkler@intel.com>
To: drzeus-list@drzeus.cx
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
       Benzi Zbit <Benzi.Zbit@intel.com>
Subject: [PATCH 1/5 V2] MMC: core - fix the use of hard coded timeout value.
Date: Tue,  1 Jul 2008 02:53:00 +0300
Message-Id: <1214869984-20115-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.5.4.1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benzi Zbit <Benzi.Zbit@intel.com>

This adds reading and using of enable_timeout from the CIS

Signed-off-by: Benzi Zbit <Benzi.Zbit@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/mmc/core/sdio_cis.c   |    2 ++
 drivers/mmc/core/sdio_io.c    |    7 ++-----
 include/linux/mmc/sdio_func.h |    1 +
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
index d5e51b1..e3a9797 100644
--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -129,6 +129,8 @@ static int cistpl_funce_func(struct sdio_func *func,
 	/* TPLFE_MAX_BLK_SIZE */
 	func->max_blksize = buf[12] | (buf[13] << 8);
 
+	/* TPLFE_ENABLE_TIMEOUT_VAL */
+	func->enable_timeout = buf[28] | (buf[29] << 8);
 	return 0;
 }
 
diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
index 625b92c..252c4fd 100644
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -76,11 +76,8 @@ int sdio_enable_func(struct sdio_func *func)
 	if (ret)
 		goto err;
 
-	/*
-	 * FIXME: This should timeout based on information in the CIS,
-	 * but we don't have card to parse that yet.
-	 */
-	timeout = jiffies + HZ;
+	/* max enable timeout is in units of 10mS */
+	timeout = jiffies + msecs_to_jiffies(func->enable_timeout * 10);
 
 	while (1) {
 		ret = mmc_io_rw_direct(func->card, 0, 0, SDIO_CCCR_IORx, 0, &reg);
diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
index b050f4d..8de40f1 100644
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -46,6 +46,7 @@ struct sdio_func {
 	unsigned		max_blksize;	/* maximum block size */
 	unsigned		cur_blksize;	/* current block size */
 
+	unsigned		enable_timeout;	/* max enable timeout in units of 10mS steps */
 	unsigned int		state;		/* function state */
 #define SDIO_STATE_PRESENT	(1<<0)		/* present in sysfs */
 
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

