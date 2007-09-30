Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbXI3W5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbXI3W5z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 18:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbXI3W5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 18:57:43 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:59419 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbXI3W5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:57:41 -0400
Date: Sun, 30 Sep 2007 16:57:33 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2 5/6] Sysace: Move IRQ handler registration to occur after
	FSM is initialized
In-reply-to: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       axboe@kernel.dk
Message-id: <20070930225726.2476.44211.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net>
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

The FSM needs to be initialized before it is safe to call the ISR

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/block/xsysace.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 10bb4e5..296d567 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -949,15 +949,6 @@ static int __devinit ace_setup(struct ace_device *ace)
 	if (!ace->baseaddr)
 		goto err_ioremap;
 
-	if (ace->irq != NO_IRQ) {
-		rc = request_irq(ace->irq, ace_interrupt, 0, "systemace", ace);
-		if (rc) {
-			/* Failure - fall back to polled mode */
-			dev_err(ace->dev, "request_irq failed\n");
-			ace->irq = NO_IRQ;
-		}
-	}
-
 	/*
 	 * Initialize the state machine tasklet and stall timer
 	 */
@@ -1015,6 +1006,16 @@ static int __devinit ace_setup(struct ace_device *ace)
 	val |= ACE_CTRL_DATABUFRDYIRQ | ACE_CTRL_ERRORIRQ;
 	ace_out(ace, ACE_CTRL, val);
 
+	/* Now we can hook up the irq handler */
+	if (ace->irq != NO_IRQ) {
+		rc = request_irq(ace->irq, ace_interrupt, 0, "systemace", ace);
+		if (rc) {
+			/* Failure - fall back to polled mode */
+			dev_err(ace->dev, "request_irq failed\n");
+			ace->irq = NO_IRQ;
+		}
+	}
+
 	/* Print the identification */
 	dev_info(ace->dev, "Xilinx SystemACE revision %i.%i.%i\n",
 		 (version >> 12) & 0xf, (version >> 8) & 0x0f, version & 0xff);
@@ -1035,8 +1036,6 @@ static int __devinit ace_setup(struct ace_device *ace)
 	blk_cleanup_queue(ace->queue);
       err_blk_initq:
 	iounmap(ace->baseaddr);
-	if (ace->irq != NO_IRQ)
-		free_irq(ace->irq, ace);
       err_ioremap:
 	dev_info(ace->dev, "xsysace: error initializing device at 0x%lx\n",
 	       ace->physaddr);

