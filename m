Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbYIVQjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbYIVQjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYIVQit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:38:49 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:35074 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbYIVQis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:38:48 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 1/4] atmel-mci: Implement tasklet as a state machine
Date: Mon, 22 Sep 2008 18:38:14 +0200
Message-Id: <1222101497-21183-2-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1222101497-21183-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1222101497-21183-1-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 22 Sep 2008 16:38:05.0938 (UTC) FILETIME=[96BB7520:01C91CD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current system of completed/pending events, things may get
handled in different order depending on which event triggers first. For
example, if the data transfer is complete before the command, the stop
command must be sent after the command is complete, not the data. This
creates a bit of complexity around the stop command.

By having the tasklet go through a sequence of clearly defined states,
things always happen in a certain order even if the events come at
different times, so the stop command can simply be sent when we exit the
"sending data" state because we will never enter that state before the
command has been sent successfully.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/mmc/host/atmel-mci.c |  249 ++++++++++++++++++++++++------------------
 1 files changed, 145 insertions(+), 104 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 917035e..caa67fe 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -36,11 +36,17 @@
 
 enum {
 	EVENT_CMD_COMPLETE = 0,
-	EVENT_DATA_ERROR,
-	EVENT_DATA_COMPLETE,
-	EVENT_STOP_SENT,
-	EVENT_STOP_COMPLETE,
 	EVENT_XFER_COMPLETE,
+	EVENT_DATA_COMPLETE,
+	EVENT_DATA_ERROR,
+};
+
+enum atmel_mci_state {
+	STATE_SENDING_CMD = 0,
+	STATE_SENDING_DATA,
+	STATE_DATA_BUSY,
+	STATE_SENDING_STOP,
+	STATE_DATA_ERROR,
 };
 
 struct atmel_mci {
@@ -56,7 +62,6 @@ struct atmel_mci {
 
 	u32			cmd_status;
 	u32			data_status;
-	u32			stop_status;
 	u32			stop_cmdr;
 
 	u32			mode_reg;
@@ -65,6 +70,7 @@ struct atmel_mci {
 	struct tasklet_struct	tasklet;
 	unsigned long		pending_events;
 	unsigned long		completed_events;
+	enum atmel_mci_state	state;
 
 	int			present;
 	int			detect_pin;
@@ -79,18 +85,12 @@ struct atmel_mci {
 	struct platform_device	*pdev;
 };
 
-#define atmci_is_completed(host, event)				\
-	test_bit(event, &host->completed_events)
 #define atmci_test_and_clear_pending(host, event)		\
 	test_and_clear_bit(event, &host->pending_events)
-#define atmci_test_and_set_completed(host, event)		\
-	test_and_set_bit(event, &host->completed_events)
 #define atmci_set_completed(host, event)			\
 	set_bit(event, &host->completed_events)
 #define atmci_set_pending(host, event)				\
 	set_bit(event, &host->pending_events)
-#define atmci_clear_pending(host, event)			\
-	clear_bit(event, &host->pending_events)
 
 /*
  * The debugfs stuff below is mostly optimized away when
@@ -258,6 +258,10 @@ static void atmci_init_debugfs(struct atmel_mci *host)
 	if (!node)
 		goto err;
 
+	node = debugfs_create_u32("state", S_IRUSR, root, (u32 *)&host->state);
+	if (!node)
+		goto err;
+
 	node = debugfs_create_x32("pending_events", S_IRUSR, root,
 				     (u32 *)&host->pending_events);
 	if (!node)
@@ -378,8 +382,6 @@ static void atmci_start_command(struct atmel_mci *host,
 				struct mmc_command *cmd,
 				u32 cmd_flags)
 {
-	/* Must read host->cmd after testing event flags */
-	smp_rmb();
 	WARN_ON(host->cmd);
 	host->cmd = cmd;
 
@@ -474,6 +476,7 @@ static void atmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	host->mrq = mrq;
 	host->pending_events = 0;
 	host->completed_events = 0;
+	host->state = STATE_SENDING_CMD;
 
 	atmci_enable(host);
 
@@ -594,8 +597,10 @@ static struct mmc_host_ops atmci_ops = {
 };
 
 static void atmci_command_complete(struct atmel_mci *host,
-			struct mmc_command *cmd, u32 status)
+			struct mmc_command *cmd)
 {
+	u32		status = host->cmd_status;
+
 	/* Read the response from the card (up to 16 bytes) */
 	cmd->resp[0] = mci_readl(host, RSPR);
 	cmd->resp[1] = mci_readl(host, RSPR);
@@ -664,20 +669,32 @@ static void atmci_detect_change(unsigned long data)
 			 * commands or data transfers.
 			 */
 			mci_writel(host, CR, MCI_CR_SWRST);
+			mci_readl(host, SR);
 
-			if (!atmci_is_completed(host, EVENT_CMD_COMPLETE))
-				mrq->cmd->error = -ENOMEDIUM;
+			host->data = NULL;
+			host->cmd = NULL;
 
-			if (mrq->data && !atmci_is_completed(host,
-						EVENT_DATA_COMPLETE)) {
-				host->data = NULL;
+			switch (host->state) {
+			case STATE_SENDING_CMD:
+				mrq->cmd->error = -ENOMEDIUM;
+				if (!mrq->data)
+					break;
+				/* fall through */
+			case STATE_SENDING_DATA:
 				mrq->data->error = -ENOMEDIUM;
-			}
-			if (mrq->stop && !atmci_is_completed(host,
-						EVENT_STOP_COMPLETE))
+				break;
+			case STATE_DATA_BUSY:
+			case STATE_DATA_ERROR:
+				if (mrq->data->error == -EINPROGRESS)
+					mrq->data->error = -ENOMEDIUM;
+				if (!mrq->stop)
+					break;
+				/* fall through */
+			case STATE_SENDING_STOP:
 				mrq->stop->error = -ENOMEDIUM;
+				break;
+			}
 
-			host->cmd = NULL;
 			atmci_request_end(host->mmc, mrq);
 		}
 
@@ -691,81 +708,116 @@ static void atmci_tasklet_func(unsigned long priv)
 	struct atmel_mci	*host = mmc_priv(mmc);
 	struct mmc_request	*mrq = host->mrq;
 	struct mmc_data		*data = host->data;
+	struct mmc_command	*cmd = host->cmd;
+	enum atmel_mci_state	state = host->state;
+	enum atmel_mci_state	prev_state;
+	u32			status;
+
+	state = host->state;
 
 	dev_vdbg(&mmc->class_dev,
-		"tasklet: pending/completed/mask %lx/%lx/%x\n",
-		host->pending_events, host->completed_events,
+		"tasklet: state %u pending/completed/mask %lx/%lx/%x\n",
+		state, host->pending_events, host->completed_events,
 		mci_readl(host, IMR));
 
-	if (atmci_test_and_clear_pending(host, EVENT_CMD_COMPLETE)) {
-		/*
-		 * host->cmd must be set to NULL before the interrupt
-		 * handler sees EVENT_CMD_COMPLETE
-		 */
-		host->cmd = NULL;
-		smp_wmb();
-		atmci_set_completed(host, EVENT_CMD_COMPLETE);
-		atmci_command_complete(host, mrq->cmd, host->cmd_status);
-
-		if (!mrq->cmd->error && mrq->stop
-				&& atmci_is_completed(host, EVENT_XFER_COMPLETE)
-				&& !atmci_test_and_set_completed(host,
-					EVENT_STOP_SENT))
-			send_stop_cmd(host->mmc, mrq->data);
-	}
-	if (atmci_test_and_clear_pending(host, EVENT_STOP_COMPLETE)) {
-		/*
-		 * host->cmd must be set to NULL before the interrupt
-		 * handler sees EVENT_STOP_COMPLETE
-		 */
-		host->cmd = NULL;
-		smp_wmb();
-		atmci_set_completed(host, EVENT_STOP_COMPLETE);
-		atmci_command_complete(host, mrq->stop, host->stop_status);
-	}
-	if (atmci_test_and_clear_pending(host, EVENT_DATA_ERROR)) {
-		u32 status = host->data_status;
+	do {
+		prev_state = state;
 
-		dev_vdbg(&mmc->class_dev, "data error: status=%08x\n", status);
+		switch (state) {
+		case STATE_SENDING_CMD:
+			if (!atmci_test_and_clear_pending(host,
+						EVENT_CMD_COMPLETE))
+				break;
 
-		atmci_set_completed(host, EVENT_DATA_ERROR);
-		atmci_set_completed(host, EVENT_DATA_COMPLETE);
+			host->cmd = NULL;
+			atmci_set_completed(host, EVENT_CMD_COMPLETE);
+			atmci_command_complete(host, mrq->cmd);
+			if (!mrq->data || cmd->error) {
+				atmci_request_end(mmc, host->mrq);
+				break;
+			}
 
-		if (status & MCI_DTOE) {
-			dev_dbg(&mmc->class_dev,
-					"data timeout error\n");
-			data->error = -ETIMEDOUT;
-		} else if (status & MCI_DCRCE) {
-			dev_dbg(&mmc->class_dev, "data CRC error\n");
-			data->error = -EILSEQ;
-		} else {
-			dev_dbg(&mmc->class_dev,
-					"data FIFO error (status=%08x)\n",
-					status);
-			data->error = -EIO;
-		}
+			prev_state = state = STATE_SENDING_DATA;
+			/* fall through */
 
-		if (host->present && data->stop
-				&& atmci_is_completed(host, EVENT_CMD_COMPLETE)
-				&& !atmci_test_and_set_completed(
-					host, EVENT_STOP_SENT))
-			send_stop_cmd(host->mmc, data);
+		case STATE_SENDING_DATA:
+			if (atmci_test_and_clear_pending(host,
+						EVENT_DATA_ERROR)) {
+				if (data->stop)
+					send_stop_cmd(host->mmc, data);
+				state = STATE_DATA_ERROR;
+				break;
+			}
 
-		host->data = NULL;
-	}
-	if (atmci_test_and_clear_pending(host, EVENT_DATA_COMPLETE)) {
-		atmci_set_completed(host, EVENT_DATA_COMPLETE);
+			if (!atmci_test_and_clear_pending(host,
+						EVENT_XFER_COMPLETE))
+				break;
 
-		if (!atmci_is_completed(host, EVENT_DATA_ERROR)) {
-			data->bytes_xfered = data->blocks * data->blksz;
-			data->error = 0;
-		}
+			atmci_set_completed(host, EVENT_XFER_COMPLETE);
+			prev_state = state = STATE_DATA_BUSY;
+			/* fall through */
 
-		host->data = NULL;
-	}
+		case STATE_DATA_BUSY:
+			if (!atmci_test_and_clear_pending(host,
+						EVENT_DATA_COMPLETE))
+				break;
+
+			host->data = NULL;
+			atmci_set_completed(host, EVENT_DATA_COMPLETE);
+			status = host->data_status;
+			if (unlikely(status & ATMCI_DATA_ERROR_FLAGS)) {
+				if (status & MCI_DTOE) {
+					dev_dbg(&mmc->class_dev,
+							"data timeout error\n");
+					data->error = -ETIMEDOUT;
+				} else if (status & MCI_DCRCE) {
+					dev_dbg(&mmc->class_dev,
+							"data CRC error\n");
+					data->error = -EILSEQ;
+				} else {
+					dev_dbg(&mmc->class_dev,
+						"data FIFO error (status=%08x)\n",
+						status);
+					data->error = -EIO;
+				}
+			} else {
+				data->bytes_xfered = data->blocks * data->blksz;
+				data->error = 0;
+			}
+
+			if (!data->stop) {
+				atmci_request_end(mmc, host->mrq);
+				prev_state = state;
+				break;
+			}
 
-	if (host->mrq && !host->cmd && !host->data)
-		atmci_request_end(mmc, host->mrq);
+			prev_state = state = STATE_SENDING_STOP;
+			if (!data->error)
+				send_stop_cmd(host->mmc, data);
+			/* fall through */
+
+		case STATE_SENDING_STOP:
+			if (!atmci_test_and_clear_pending(host,
+						EVENT_CMD_COMPLETE))
+				break;
+
+			host->cmd = NULL;
+			atmci_command_complete(host, mrq->stop);
+			atmci_request_end(mmc, host->mrq);
+			prev_state = state;
+			break;
+
+		case STATE_DATA_ERROR:
+			if (!atmci_test_and_clear_pending(host,
+						EVENT_XFER_COMPLETE))
+				break;
+
+			state = STATE_DATA_BUSY;
+			break;
+		}
+	} while (state != prev_state);
+
+	host->state = state;
 }
 
 static void atmci_read_data_pio(struct atmel_mci *host)
@@ -830,10 +882,7 @@ done:
 	mci_writel(host, IDR, MCI_RXRDY);
 	mci_writel(host, IER, MCI_NOTBUSY);
 	data->bytes_xfered += nbytes;
-	atmci_set_completed(host, EVENT_XFER_COMPLETE);
-	if (data->stop && atmci_is_completed(host, EVENT_CMD_COMPLETE)
-			&& !atmci_test_and_set_completed(host, EVENT_STOP_SENT))
-		send_stop_cmd(host->mmc, data);
+	atmci_set_pending(host, EVENT_XFER_COMPLETE);
 }
 
 static void atmci_write_data_pio(struct atmel_mci *host)
@@ -901,10 +950,7 @@ done:
 	mci_writel(host, IDR, MCI_TXRDY);
 	mci_writel(host, IER, MCI_NOTBUSY);
 	data->bytes_xfered += nbytes;
-	atmci_set_completed(host, EVENT_XFER_COMPLETE);
-	if (data->stop && atmci_is_completed(host, EVENT_CMD_COMPLETE)
-			&& !atmci_test_and_set_completed(host, EVENT_STOP_SENT))
-		send_stop_cmd(host->mmc, data);
+	atmci_set_pending(host, EVENT_XFER_COMPLETE);
 }
 
 static void atmci_cmd_interrupt(struct mmc_host *mmc, u32 status)
@@ -913,14 +959,8 @@ static void atmci_cmd_interrupt(struct mmc_host *mmc, u32 status)
 
 	mci_writel(host, IDR, MCI_CMDRDY);
 
-	if (atmci_is_completed(host, EVENT_STOP_SENT)) {
-		host->stop_status = status;
-		atmci_set_pending(host, EVENT_STOP_COMPLETE);
-	} else {
-		host->cmd_status = status;
-		atmci_set_pending(host, EVENT_CMD_COMPLETE);
-	}
-
+	host->cmd_status = status;
+	atmci_set_pending(host, EVENT_CMD_COMPLETE);
 	tasklet_schedule(&host->tasklet);
 }
 
@@ -949,8 +989,9 @@ static irqreturn_t atmci_interrupt(int irq, void *dev_id)
 			tasklet_schedule(&host->tasklet);
 		}
 		if (pending & MCI_NOTBUSY) {
-			mci_writel(host, IDR, (MCI_NOTBUSY
-					       | ATMCI_DATA_ERROR_FLAGS));
+			mci_writel(host, IDR,
+					ATMCI_DATA_ERROR_FLAGS | MCI_NOTBUSY);
+			host->data_status = status;
 			atmci_set_pending(host, EVENT_DATA_COMPLETE);
 			tasklet_schedule(&host->tasklet);
 		}
-- 
1.5.6.5

