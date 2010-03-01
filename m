Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0CATBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:01:51 -0500
Received: from www.tglx.de ([62.245.132.106]:45421 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab0CATBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:01:49 -0500
Date: Mon, 1 Mar 2010 20:01:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [PATCH] mmc: omap_hsmmc: Fix conditional locking
Message-ID: <alpine.LFD.2.00.1003011952470.4245@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conditional locking on (!in_interrupt()) is broken by design and there
is no reason to keep the host->irq_lock across the call to
mmc_request_done(). Also the host->protect_card magic hack does not
depend on the context

Fix the mess by dropping host->irq_lock before calling
mmc_request_done().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 4b23225..99a3383 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -468,14 +468,6 @@ omap_hsmmc_start_command(struct omap_hsmmc_host *host, struct mmc_command *cmd,
 	if (host->use_dma)
 		cmdreg |= DMA_EN;
 
-	/*
-	 * In an interrupt context (i.e. STOP command), the spinlock is unlocked
-	 * by the interrupt handler, otherwise (i.e. for a new request) it is
-	 * unlocked here.
-	 */
-	if (!in_interrupt())
-		spin_unlock_irqrestore(&host->irq_lock, host->flags);
-
 	OMAP_HSMMC_WRITE(host->base, ARG, cmd->arg);
 	OMAP_HSMMC_WRITE(host->base, CMD, cmdreg);
 }
@@ -506,7 +498,9 @@ omap_hsmmc_xfer_done(struct omap_hsmmc_host *host, struct mmc_data *data)
 		}
 
 		host->mrq = NULL;
+		spin_unlock(&host->irq_lock);
 		mmc_request_done(host->mmc, mrq);
+		spin_lock(&host->irq_lock);
 		return;
 	}
 
@@ -523,7 +517,9 @@ omap_hsmmc_xfer_done(struct omap_hsmmc_host *host, struct mmc_data *data)
 
 	if (!data->stop) {
 		host->mrq = NULL;
+		spin_unlock(&host->irq_lock);
 		mmc_request_done(host->mmc, data->mrq);
+		spin_lock(&host->irq_lock);
 		return;
 	}
 	omap_hsmmc_start_command(host, data->stop, NULL);
@@ -551,7 +547,9 @@ omap_hsmmc_cmd_done(struct omap_hsmmc_host *host, struct mmc_command *cmd)
 	}
 	if ((host->data == NULL && !host->response_busy) || cmd->error) {
 		host->mrq = NULL;
+		spin_unlock(&host->irq_lock);
 		mmc_request_done(host->mmc, cmd->mrq);
+		spin_lock(&host->irq_lock);
 	}
 }
 
@@ -1077,37 +1075,31 @@ static void omap_hsmmc_request(struct mmc_host *mmc, struct mmc_request *req)
 	struct omap_hsmmc_host *host = mmc_priv(mmc);
 	int err;
 
+	spin_lock_irqsave(&host->irq_lock, host->flags);
 	/*
-	 * Prevent races with the interrupt handler because of unexpected
-	 * interrupts, but not if we are already in interrupt context i.e.
-	 * retries.
+	 * Protect the card from I/O if there is a possibility
+	 * it can be removed.
 	 */
-	if (!in_interrupt()) {
-		spin_lock_irqsave(&host->irq_lock, host->flags);
-		/*
-		 * Protect the card from I/O if there is a possibility
-		 * it can be removed.
-		 */
-		if (host->protect_card) {
-			if (host->reqs_blocked < 3) {
-				/*
-				 * Ensure the controller is left in a consistent
-				 * state by resetting the command and data state
-				 * machines.
-				 */
-				omap_hsmmc_reset_controller_fsm(host, SRD);
-				omap_hsmmc_reset_controller_fsm(host, SRC);
-				host->reqs_blocked += 1;
-			}
-			req->cmd->error = -EBADF;
-			if (req->data)
-				req->data->error = -EBADF;
-			spin_unlock_irqrestore(&host->irq_lock, host->flags);
-			mmc_request_done(mmc, req);
-			return;
-		} else if (host->reqs_blocked)
-			host->reqs_blocked = 0;
-	}
+	if (host->protect_card) {
+		if (host->reqs_blocked < 3) {
+			/*
+			 * Ensure the controller is left in a consistent
+			 * state by resetting the command and data state
+			 * machines.
+			 */
+			omap_hsmmc_reset_controller_fsm(host, SRD);
+			omap_hsmmc_reset_controller_fsm(host, SRC);
+			host->reqs_blocked += 1;
+		}
+		req->cmd->error = -EBADF;
+		if (req->data)
+			req->data->error = -EBADF;
+		spin_unlock_irqrestore(&host->irq_lock, host->flags);
+		mmc_request_done(mmc, req);
+		return;
+	} else if (host->reqs_blocked)
+		host->reqs_blocked = 0;
+
 	WARN_ON(host->mrq != NULL);
 	host->mrq = req;
 	err = omap_hsmmc_prepare_data(host, req);
@@ -1116,13 +1108,13 @@ static void omap_hsmmc_request(struct mmc_host *mmc, struct mmc_request *req)
 		if (req->data)
 			req->data->error = err;
 		host->mrq = NULL;
-		if (!in_interrupt())
-			spin_unlock_irqrestore(&host->irq_lock, host->flags);
+		spin_unlock_irqrestore(&host->irq_lock, host->flags);
 		mmc_request_done(mmc, req);
 		return;
 	}
 
 	omap_hsmmc_start_command(host, req->cmd, req->data);
+	spin_unlock_irqrestore(&host->irq_lock, host->flags);
 }
 
 /* Routine to configure clock values. Exposed API to core */
