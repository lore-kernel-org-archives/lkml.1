Return-Path: <linux-kernel-owner+w=401wt.eu-S1422821AbXDYW2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422821AbXDYW2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422857AbXDYW2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:28:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:38539 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422821AbXDYW2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:28:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OJjM/gA29vd05Hd+SPol3HC8jrDm1hFLPujzBio9ZaaUxikFN5ugD27xKlza0hXPcZ9/T9P3FI48hi6cvXktmTP9gGdx8gFE3GHCeTOmLt0P9Nzdy/BeYxWhSUh0Hy+b7qBqpUDHU2nAXNUnjjUv8uN6JTkl0PHta5YqCrxnX8E=
From: Sergey Yanovich <ynvich@gmail.com>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx,
       Sergey Yanovich <ynvich@gmail.com>
Subject: [PATCH] [mmc] Removes custom debug macro
Date: Thu, 26 Apr 2007 00:44:13 +0300
Message-Id: <1177537454195-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: 200704200056.33866.arnd@arndb.de
References: 200704200056.33866.arnd@arndb.de
Message-Id: <5e03dd4e0b14c8155162a5b5b1cea4ed7e04cea3.1177536862.git.ynvich@gmail.com>
In-Reply-To: <200704200056.33866.arnd@arndb.de>
References: <200704200056.33866.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Sergey Yanovich <ynvich@gmail.com>
---
 drivers/mmc/tifm.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/mmc/tifm.c b/drivers/mmc/tifm.c
index 5410e66..30cab30 100644
--- a/drivers/mmc/tifm.c
+++ b/drivers/mmc/tifm.c
@@ -28,15 +28,6 @@
 #define DRIVER_NAME "tifm"
 #define DRIVER_VERSION "0.7"
 
-/*#define CONFIG_MMC_DEBUG*/
-#ifdef CONFIG_MMC_DEBUG
-#define DBG(f,arg...) \
-	printk(KERN_DEBUG DRIVER_NAME ": " f,##arg)
-#else /* CONFIG_MMC_DEBUG */
-#define DBG(f,arg...) \
-	do { } while (0)
-#endif /* CONFIG_MMC_DEBUG */
-
 static int no_dma = 0;
 
 struct tifm_chip;
@@ -594,7 +585,6 @@ mmc_tifm_irq(int irq, void *dev_id)
 		if(card_status && chip->socket[cnt])
 			mmc_tifm_irq_card(chip->socket[cnt],card_status);
 	}
-	/*DBG("got irq status 0x%08x\n", irq_status);*/
 	spin_unlock(&chip->lock);
 	return IRQ_HANDLED;
 }
@@ -611,7 +601,7 @@ mmc_tifm_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	struct mmc_data *data = mrq->cmd->data;
 
 	spin_lock_irqsave(&socket->lock, flags);
-	DBG("executing opcode %u\n",mrq->cmd->opcode);
+	dev_dbg(socket->chip->pdev,"executing opcode %u\n",mrq->cmd->opcode);
 	if(!(socket->flags & POWER_ON)){
 		spin_unlock_irqrestore(&socket->lock, flags);
 		goto err_out;
@@ -665,7 +655,7 @@ mmc_tifm_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	int cnt;
 
 	spin_lock_irqsave(&socket->lock, flags);
-	DBG("setting io for socket %u\n",socket->index);
+	dev_dbg(socket->chip->pdev,"setting io for socket %u\n",socket->index);
 
 	if(!(socket->flags & MEDIA_MMC)){
 		writel(0,socket->addr + SOCK_MMCSD_INT_ENABLE);
@@ -808,7 +798,7 @@ mmc_tifm_suspend(struct pci_dev *pdev, pm_message_t state)
 		spin_unlock_irqrestore(chip->socket[cnt]->lock,flags);
 		mmc=container_of((void*)chip->socket[cnt],
 				struct mmc_host,private);
-		DBG(" ... socket %u\n",cnt);
+		dev_dbg(chip->pdev," ... socket %u\n",cnt);
 		mmc_suspend_host(mmc,state);
 		spin_lock_irqsave(chip->socket[cnt]->lock,flags);
 		chip->socket[cnt]->flags = 0;
@@ -889,14 +879,14 @@ mmc_tifm_probe_socket(struct tifm_chip *chip, int num)
 	mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
 	mmc->max_seg_size = mmc->max_req_size;
 
-	DBG("initing tasklets for socket %u\n",num);
+	dev_dbg(chip->pdev,"initing tasklets for socket %u\n",num);
 	tasklet_init(&socket->irq_chip,mmc_tifm_irq_chip,(unsigned long)socket);
 	tasklet_init(&socket->cmd_end,mmc_tifm_cmd_end,(unsigned long)socket);
 	setup_timer(&socket->timer,mmc_tifm_timer,(unsigned long)socket);
 	chip->socket[num] = socket;
 	tifm_socket_event(chip,num,1);
 
-	DBG("adding mmc host for socket %u\n",num);
+	dev_dbg(chip->pdev,"adding mmc host for socket %u\n",num);
 	mmc_add_host(mmc);
 	
 	return rc;
@@ -983,7 +973,7 @@ mmc_tifm_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 		else
 			break;
 	}
-	DBG("created %u socket(s)\n",sockets-cnt-1);
+	dev_dbg(chip->pdev,"created %u socket(s)\n",sockets-cnt-1);
 	if(rc)
 		goto err_out_unmap;
 	return 0;
-- 
1.5.1.2

