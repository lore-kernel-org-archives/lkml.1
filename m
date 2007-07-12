Return-Path: <linux-kernel-owner+w=401wt.eu-S1763908AbXGLX4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763908AbXGLX4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932680AbXGLXz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:55:29 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59658 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932512AbXGLXz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:55:27 -0400
Date: Fri, 13 Jul 2007 01:56:02 +0200
From: Adrian Bunk <bunk@stusta.de>
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/mmc/core/: make 4 functions static
Message-ID: <20070712235602.GV3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- sd_ops.c: mmc_app_cmd()
- sd_ops.c: mmc_wait_for_app_cmd()
- core.c: __mmc_release_bus()
- core.c: mmc_start_request()

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/mmc/core/core.c   |   49 +++++++++++++++++++----------
 drivers/mmc/core/core.h   |   22 -------------
 drivers/mmc/core/sd_ops.c |   64 ++++++++++++++++++--------------------
 drivers/mmc/core/sd_ops.h |    1 
 include/linux/mmc/core.h  |    2 -
 5 files changed, 64 insertions(+), 74 deletions(-)

--- linux-2.6.22-rc6-mm1/include/linux/mmc/core.h.old	2007-07-11 22:06:20.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/linux/mmc/core.h	2007-07-11 22:06:32.000000000 +0200
@@ -101,8 +101,6 @@
 
 extern int mmc_wait_for_req(struct mmc_host *, struct mmc_request *);
 extern int mmc_wait_for_cmd(struct mmc_host *, struct mmc_command *, int);
-extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
-	struct mmc_command *, int);
 
 extern void mmc_set_data_timeout(struct mmc_data *, const struct mmc_card *, int);
 
--- linux-2.6.22-rc6-mm1/drivers/mmc/core/sd_ops.h.old	2007-07-11 22:09:30.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/mmc/core/sd_ops.h	2007-07-11 22:09:37.000000000 +0200
@@ -12,7 +12,6 @@
 #ifndef _MMC_SD_OPS_H
 #define _MMC_SD_OPS_H
 
-int mmc_app_cmd(struct mmc_host *host, struct mmc_card *card);
 int mmc_app_set_bus_width(struct mmc_card *card, int width);
 int mmc_send_app_op_cond(struct mmc_host *host, u32 ocr, u32 *rocr);
 int mmc_send_if_cond(struct mmc_host *host, u32 ocr);
--- linux-2.6.22-rc6-mm1/drivers/mmc/core/sd_ops.c.old	2007-07-11 22:06:50.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/mmc/core/sd_ops.c	2007-07-11 22:09:15.000000000 +0200
@@ -21,6 +21,35 @@
 #include "core.h"
 #include "sd_ops.h"
 
+static int mmc_app_cmd(struct mmc_host *host, struct mmc_card *card)
+{
+	int err;
+	struct mmc_command cmd;
+
+	BUG_ON(!host);
+	BUG_ON(card && (card->host != host));
+
+	cmd.opcode = MMC_APP_CMD;
+
+	if (card) {
+		cmd.arg = card->rca << 16;
+		cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
+	} else {
+		cmd.arg = 0;
+		cmd.flags = MMC_RSP_R1 | MMC_CMD_BCR;
+	}
+
+	err = mmc_wait_for_cmd(host, &cmd, 0);
+	if (err != MMC_ERR_NONE)
+		return err;
+
+	/* Check that card supported application commands */
+	if (!(cmd.resp[0] & R1_APP_CMD))
+		return MMC_ERR_FAILED;
+
+	return MMC_ERR_NONE;
+}
+
 /**
  *	mmc_wait_for_app_cmd - start an application command and wait for
  			       completion
@@ -34,8 +63,8 @@
  *	that occurred while the command was executing.  Do not attempt to
  *	parse the response.
  */
-int mmc_wait_for_app_cmd(struct mmc_host *host, struct mmc_card *card,
-	struct mmc_command *cmd, int retries)
+static int mmc_wait_for_app_cmd(struct mmc_host *host, struct mmc_card *card,
+				struct mmc_command *cmd, int retries)
 {
 	struct mmc_request mrq;
 
@@ -75,37 +104,6 @@
 	return err;
 }
 
-EXPORT_SYMBOL(mmc_wait_for_app_cmd);
-
-int mmc_app_cmd(struct mmc_host *host, struct mmc_card *card)
-{
-	int err;
-	struct mmc_command cmd;
-
-	BUG_ON(!host);
-	BUG_ON(card && (card->host != host));
-
-	cmd.opcode = MMC_APP_CMD;
-
-	if (card) {
-		cmd.arg = card->rca << 16;
-		cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
-	} else {
-		cmd.arg = 0;
-		cmd.flags = MMC_RSP_R1 | MMC_CMD_BCR;
-	}
-
-	err = mmc_wait_for_cmd(host, &cmd, 0);
-	if (err != MMC_ERR_NONE)
-		return err;
-
-	/* Check that card supported application commands */
-	if (!(cmd.resp[0] & R1_APP_CMD))
-		return MMC_ERR_FAILED;
-
-	return MMC_ERR_NONE;
-}
-
 int mmc_app_set_bus_width(struct mmc_card *card, int width)
 {
 	int err;
--- linux-2.6.22-rc6-mm1/drivers/mmc/core/core.h.old	2007-07-11 22:11:30.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/mmc/core/core.h	2007-07-11 22:12:48.000000000 +0200
@@ -25,28 +25,6 @@
 void mmc_attach_bus(struct mmc_host *host, const struct mmc_bus_ops *ops);
 void mmc_detach_bus(struct mmc_host *host);
 
-void __mmc_release_bus(struct mmc_host *host);
-
-static inline void mmc_bus_get(struct mmc_host *host)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&host->lock, flags);
-	host->bus_refs++;
-	spin_unlock_irqrestore(&host->lock, flags);
-}
-
-static inline void mmc_bus_put(struct mmc_host *host)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&host->lock, flags);
-	host->bus_refs--;
-	if ((host->bus_refs == 0) && host->bus_ops)
-		__mmc_release_bus(host);
-	spin_unlock_irqrestore(&host->lock, flags);
-}
-
 void mmc_set_chip_select(struct mmc_host *host, int mode);
 void mmc_set_clock(struct mmc_host *host, unsigned int hz);
 void mmc_set_bus_mode(struct mmc_host *host, unsigned int mode);
--- linux-2.6.22-rc6-mm1/drivers/mmc/core/core.c.old	2007-07-11 22:07:17.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/mmc/core/core.c	2007-07-11 22:14:44.000000000 +0200
@@ -40,6 +40,38 @@
 static struct workqueue_struct *workqueue;
 
 /*
+ * Cleanup when the last reference to the bus operator is dropped.
+ */
+static void __mmc_release_bus(struct mmc_host *host)
+{
+	BUG_ON(!host);
+	BUG_ON(host->bus_refs);
+	BUG_ON(!host->bus_dead);
+
+	host->bus_ops = NULL;
+}
+
+static void mmc_bus_get(struct mmc_host *host)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->lock, flags);
+	host->bus_refs++;
+	spin_unlock_irqrestore(&host->lock, flags);
+}
+
+static void mmc_bus_put(struct mmc_host *host)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->lock, flags);
+	host->bus_refs--;
+	if ((host->bus_refs == 0) && host->bus_ops)
+		__mmc_release_bus(host);
+	spin_unlock_irqrestore(&host->lock, flags);
+}
+
+/*
  * Internal function. Schedule delayed work in the MMC work queue.
  */
 static int mmc_schedule_delayed_work(struct delayed_work *work,
@@ -94,8 +126,7 @@
  *	Queue a command on the specified host.  We expect the
  *	caller to be holding the host lock with interrupts disabled.
  */
-void
-mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
+static void mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 {
 #ifdef CONFIG_MMC_DEBUG
 	unsigned int i, sz;
@@ -134,8 +165,6 @@
 	host->ops->request(host, mrq);
 }
 
-EXPORT_SYMBOL(mmc_start_request);
-
 static void mmc_wait_done(struct mmc_request *mrq)
 {
 	complete(mrq->done_data);
@@ -482,18 +511,6 @@
 	mmc_bus_put(host);
 }
 
-/*
- * Cleanup when the last reference to the bus operator is dropped.
- */
-void __mmc_release_bus(struct mmc_host *host)
-{
-	BUG_ON(!host);
-	BUG_ON(host->bus_refs);
-	BUG_ON(!host->bus_dead);
-
-	host->bus_ops = NULL;
-}
-
 /**
  *	mmc_detect_change - process change of state on a MMC socket
  *	@host: host which changed state.

