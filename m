Return-Path: <linux-kernel-owner+w=401wt.eu-S1763921AbYA1TQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763921AbYA1TQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761955AbYA1TLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:11:41 -0500
Received: from smtp.nokia.com ([192.100.105.134]:52285 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762641AbYA1TLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:11:40 -0500
Message-ID: <479E2804.4020507@indt.org.br>
Date: Mon, 28 Jan 2008 15:07:48 -0400
From: Carlos Aguiar <carlos.aguiar@indt.org.br>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/18] MMC: OMAP: Abort stuck commands
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2008 19:09:34.0149 (UTC) FILETIME=[5169E750:01C861E1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

When a card is removed while it is being accessed, a command can get stuck so
that no timeout or end of command interrupt ever occurs. The command getting
stuck is almost always CDM12, but also the other commands can get stuck. Catch
a stuck command with a timer and try sending the initiliazation stream until
the controller starts running again and responds with the end of command
status.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/mmc/host/omap.c |   93 ++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 83 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 169f721..62b9d71 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -135,6 +135,9 @@ struct mmc_omap_host {
 	unsigned char		bus_mode;
 	unsigned char		hw_bus_mode;
 
+	struct work_struct	cmd_abort;
+	struct timer_list	cmd_timer;
+
 	unsigned int		sg_len;
 	int			sg_idx;
 	u16 *			buffer;
@@ -329,6 +332,8 @@ mmc_omap_start_command(struct mmc_omap_host *host, struct mmc_command *cmd)
 	if (host->data && !(host->data->flags & MMC_DATA_WRITE))
 		cmdreg |= 1 << 15;
 
+	mod_timer(&host->cmd_timer, jiffies + HZ/2);
+
 	OMAP_MMC_WRITE(host, CTO, 200);
 	OMAP_MMC_WRITE(host, ARGL, cmd->arg & 0xffff);
 	OMAP_MMC_WRITE(host, ARGH, cmd->arg >> 16);
@@ -388,9 +393,37 @@ mmc_omap_xfer_done(struct mmc_omap_host *host, struct mmc_data *data)
 }
 
 static void
+mmc_omap_send_abort(struct mmc_omap_host *host)
+{
+	struct mmc_omap_slot *slot = host->current_slot;
+	unsigned int restarts, passes, timeout;
+	u16 stat = 0;
+
+	/* Sending abort takes 80 clocks. Have some extra and round up */
+	timeout = (120*1000000 + slot->fclk_freq - 1)/slot->fclk_freq;
+	restarts = 0;
+	while (restarts < 10000) {
+		OMAP_MMC_WRITE(host, STAT, 0xFFFF);
+		OMAP_MMC_WRITE(host, CMD, (3 << 12) | (1 << 7));
+
+		passes = 0;
+		while (passes < timeout) {
+			stat = OMAP_MMC_READ(host, STAT);
+			if (stat & OMAP_MMC_STAT_END_OF_CMD)
+				goto out;
+			udelay(1);
+			passes++;
+		}
+
+		restarts++;
+	}
+out:
+	OMAP_MMC_WRITE(host, STAT, stat);
+}
+
+static void
 mmc_omap_abort_xfer(struct mmc_omap_host *host, struct mmc_data *data)
 {
-	int loops;
 	u16 ie;
 
 	if (host->dma_in_use)
@@ -401,16 +434,8 @@ mmc_omap_abort_xfer(struct mmc_omap_host *host, struct mmc_data *data)
 
 	ie = OMAP_MMC_READ(host, IE);
 	OMAP_MMC_WRITE(host, IE, 0);
-	OMAP_MMC_WRITE(host, CMD, 1 << 7);
-	loops = 0;
-	while (!(OMAP_MMC_READ(host, STAT) & OMAP_MMC_STAT_END_OF_CMD)) {
-		udelay(1);
-		loops++;
-		if (loops == 100000)
-			break;
-	}
-	OMAP_MMC_WRITE(host, STAT, OMAP_MMC_STAT_END_OF_CMD);
 	OMAP_MMC_WRITE(host, IE, ie);
+	mmc_omap_send_abort(host);
 }
 
 static void
@@ -466,6 +491,8 @@ mmc_omap_cmd_done(struct mmc_omap_host *host, struct mmc_command *cmd)
 {
 	host->cmd = NULL;
 
+	del_timer(&host->cmd_timer);
+
 	if (cmd->flags & MMC_RSP_PRESENT) {
 		if (cmd->flags & MMC_RSP_136) {
 			/* response type 2 */
@@ -501,6 +528,47 @@ mmc_omap_cmd_done(struct mmc_omap_host *host, struct mmc_command *cmd)
 	}
 }
 
+/*
+ * Abort stuck command. Can occur when card is removed while it is being
+ * read.
+ */
+static void mmc_omap_abort_command(struct work_struct *work)
+{
+	struct mmc_omap_host *host = container_of(work, struct mmc_omap_host,
+						  cmd_abort);
+	u16 ie;
+
+	ie = OMAP_MMC_READ(host, IE);
+	OMAP_MMC_WRITE(host, IE, 0);
+
+	if (!host->cmd) {
+		OMAP_MMC_WRITE(host, IE, ie);
+		return;
+	}
+
+	dev_dbg(mmc_dev(host->mmc), "Aborting stuck command CMD%d\n",
+		host->cmd->opcode);
+
+	if (host->data && host->dma_in_use)
+		mmc_omap_release_dma(host, host->data, 1);
+
+	host->data = NULL;
+	host->sg_len = 0;
+
+	mmc_omap_send_abort(host);
+	host->cmd->error = -ETIMEDOUT;
+	mmc_omap_cmd_done(host, host->cmd);
+	OMAP_MMC_WRITE(host, IE, ie);
+}
+
+static void
+mmc_omap_cmd_timer(unsigned long data)
+{
+	struct mmc_omap_host *host = (struct mmc_omap_host *) data;
+
+	schedule_work(&host->cmd_abort);
+}
+
 /* PIO only */
 static void
 mmc_omap_sg_to_buf(struct mmc_omap_host *host)
@@ -1273,6 +1341,11 @@ static int __init mmc_omap_probe(struct platform_device *pdev)
 		goto err_free_mem_region;
 	}
 
+	INIT_WORK(&host->cmd_abort, mmc_omap_abort_command);
+	init_timer(&host->cmd_timer);
+	host->cmd_timer.function = mmc_omap_cmd_timer;
+	host->cmd_timer.data = (unsigned long) host;
+
 	spin_lock_init(&host->dma_lock);
 	init_timer(&host->dma_timer);
 	spin_lock_init(&host->slot_lock);
-- 1.5.3.GIT

