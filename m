Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbXLTElz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbXLTElz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 23:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbXLTElq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 23:41:46 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:63186 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbXLTElp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 23:41:45 -0500
Date: Wed, 19 Dec 2007 23:41:42 -0500
From: Jon Smirl <jonsmirl@gmail.com>
Subject: [PATCH 3/5] Clean up error returns
In-reply-to: <20071220044136.20091.70984.stgit@terra.home>
To: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-id: <20071220044142.20091.68330.stgit@terra.home>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071220044136.20091.70984.stgit@terra.home>
User-Agent: StGIT/0.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return errors that were being ignored in the mpc-i2c driver

Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
---

 drivers/i2c/busses/i2c-mpc.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)


diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index d8de4ac..7c35a8f 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -180,7 +180,7 @@ static void mpc_i2c_stop(struct mpc_i2c *i2c)
 static int mpc_write(struct mpc_i2c *i2c, int target,
 		     const u8 * data, int length, int restart)
 {
-	int i;
+	int i, result;
 	unsigned timeout = i2c->adap.timeout;
 	u32 flags = restart ? CCR_RSTA : 0;
 
@@ -192,15 +192,17 @@ static int mpc_write(struct mpc_i2c *i2c, int target,
 	/* Write target byte */
 	writeb((target << 1), i2c->base + MPC_I2C_DR);
 
-	if (i2c_wait(i2c, timeout, 1) < 0)
-		return -1;
+	result = i2c_wait(i2c, timeout, 1);
+	if (result < 0)
+		return result;
 
 	for (i = 0; i < length; i++) {
 		/* Write data byte */
 		writeb(data[i], i2c->base + MPC_I2C_DR);
 
-		if (i2c_wait(i2c, timeout, 1) < 0)
-			return -1;
+		result = i2c_wait(i2c, timeout, 1);
+		if (result < 0)
+			return result;
 	}
 
 	return 0;
@@ -210,7 +212,7 @@ static int mpc_read(struct mpc_i2c *i2c, int target,
 		    u8 * data, int length, int restart)
 {
 	unsigned timeout = i2c->adap.timeout;
-	int i;
+	int i, result;
 	u32 flags = restart ? CCR_RSTA : 0;
 
 	/* Start with MEN */
@@ -221,8 +223,9 @@ static int mpc_read(struct mpc_i2c *i2c, int target,
 	/* Write target address byte - this time with the read flag set */
 	writeb((target << 1) | 1, i2c->base + MPC_I2C_DR);
 
-	if (i2c_wait(i2c, timeout, 1) < 0)
-		return -1;
+	result = i2c_wait(i2c, timeout, 1);
+	if (result < 0)
+		return result;
 
 	if (length) {
 		if (length == 1)
@@ -234,8 +237,9 @@ static int mpc_read(struct mpc_i2c *i2c, int target,
 	}
 
 	for (i = 0; i < length; i++) {
-		if (i2c_wait(i2c, timeout, 0) < 0)
-			return -1;
+		result = i2c_wait(i2c, timeout, 0);
+		if (result < 0)
+			return result;
 
 		/* Generate txack on next to last byte */
 		if (i == length - 2)
@@ -321,9 +325,9 @@ static int fsl_i2c_probe(struct platform_device *pdev)
 
 	pdata = (struct fsl_i2c_platform_data *) pdev->dev.platform_data;
 
-	if (!(i2c = kzalloc(sizeof(*i2c), GFP_KERNEL))) {
+	i2c = kzalloc(sizeof(*i2c), GFP_KERNEL);
+	if (!i2c)
 		return -ENOMEM;
-	}
 
 	i2c->irq = platform_get_irq(pdev, 0);
 	if (i2c->irq < 0) {
@@ -381,7 +385,7 @@ static int fsl_i2c_remove(struct platform_device *pdev)
 	i2c_del_adapter(&i2c->adap);
 	platform_set_drvdata(pdev, NULL);
 
-	if (i2c->irq != 0)
+	if (i2c->irq != NO_IRQ)
 		free_irq(i2c->irq, i2c);
 
 	iounmap(i2c->base);

