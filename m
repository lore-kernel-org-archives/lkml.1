Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYGIXl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYGIXl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 19:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYGIXlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 19:41:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:10917 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbYGIXlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 19:41:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,333,1212390000"; 
   d="scan'208";a="9411916"
From: Tomas Winkler <tomas.winkler@intel.com>
To: drzeus-list@drzeus.cx
Cc: linux-kernel@vger.kernel.org, Benzi Zbit <benzi.zbit@intel.com>
Subject: [PATCH 1/1 V3] MMC: core - fix the use of hard coded timeout value.
Date: Thu, 10 Jul 2008 02:41:43 +0300
Message-Id: <1215646903-810-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.5.4.1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benzi Zbit <benzi.zbit@intel.com>

This adds reading and using of enable_timeout from the CIS

Signed-off-by: Benzi Zbit <benzi.zbit@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/mmc/core/sdio_cis.c   |    6 ++++++
 drivers/mmc/core/sdio_io.c    |    6 +-----
 include/linux/mmc/sdio_func.h |    2 ++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
index d5e51b1..956bd76 100644
--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -129,6 +129,12 @@ static int cistpl_funce_func(struct sdio_func *func,
 	/* TPLFE_MAX_BLK_SIZE */
 	func->max_blksize = buf[12] | (buf[13] << 8);
 
+	/* TPLFE_ENABLE_TIMEOUT_VAL, present in ver 1.1 and above */
+	if (vsn > SDIO_SDIO_REV_1_00)
+		func->enable_timeout = (buf[28] | (buf[29] << 8)) * 10;
+	else
+		func->enable_timeout = jiffies_to_msecs(HZ);
+
 	return 0;
 }
 
diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
index 3ccf691..0888df6 100755
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -76,11 +76,7 @@ int sdio_enable_func(struct sdio_func *func)
 	if (ret)
 		goto err;
 
-	/*
-	 * FIXME: This should timeout based on information in the CIS,
-	 * but we don't have card to parse that yet.
-	 */
-	timeout = jiffies + HZ;
+	timeout = jiffies + msecs_to_jiffies(func->enable_timeout);
 
 	while (1) {
 		ret = mmc_io_rw_direct(func->card, 0, 0, SDIO_CCCR_IORx, 0, &reg);
diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
index 28fb0a3..07bee4a 100755
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -46,6 +46,8 @@ struct sdio_func {
 	unsigned		max_blksize;	/* maximum block size */
 	unsigned		cur_blksize;	/* current block size */
 
+	unsigned		enable_timeout;	/* max enable timeout in msec */
+
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

