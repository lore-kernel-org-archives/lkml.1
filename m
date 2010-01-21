Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462Ab0AUE0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab0AUE0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239Ab0AUE0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:26:11 -0500
Received: from kroah.org ([198.145.64.141]:60197 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab0AUEXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:23:07 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:36 2010
Message-Id: <20100121041836.007303419@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wolfram Sang <w.sang@pengutronix.de>, Jean Delvare <khali@linux-fr.org>
Subject: [27/30] i2c/pca: Dont use *_interruptible
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wolfram Sang <w.sang@pengutronix.de>

commit 22f8b2695eda496026623020811cae34590ee3d7 upstream.

Unexpected signals can disturb the bus-handling and lock it up. Don't use
interruptible in 'wait_event_*' and 'wake_*' as in commits
dc1972d02747d2170fb1d78d114801f5ecb27506 (for cpm),
1ab082d7cbd0f34e39a5396cc6340c00bc5d66ef (for mpc),
b7af349b175af45f9d87b3bf3f0a221e1831ed39 (for omap).

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/busses/i2c-pca-isa.c      |    4 ++--
 drivers/i2c/busses/i2c-pca-platform.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-pca-isa.c
+++ b/drivers/i2c/busses/i2c-pca-isa.c
@@ -75,7 +75,7 @@ static int pca_isa_waitforcompletion(voi
 	unsigned long timeout;
 
 	if (irq > -1) {
-		ret = wait_event_interruptible_timeout(pca_wait,
+		ret = wait_event_timeout(pca_wait,
 				pca_isa_readbyte(pd, I2C_PCA_CON)
 				& I2C_PCA_CON_SI, pca_isa_ops.timeout);
 	} else {
@@ -96,7 +96,7 @@ static void pca_isa_resetchip(void *pd)
 }
 
 static irqreturn_t pca_handler(int this_irq, void *dev_id) {
-	wake_up_interruptible(&pca_wait);
+	wake_up(&pca_wait);
 	return IRQ_HANDLED;
 }
 
--- a/drivers/i2c/busses/i2c-pca-platform.c
+++ b/drivers/i2c/busses/i2c-pca-platform.c
@@ -84,7 +84,7 @@ static int i2c_pca_pf_waitforcompletion(
 	unsigned long timeout;
 
 	if (i2c->irq) {
-		ret = wait_event_interruptible_timeout(i2c->wait,
+		ret = wait_event_timeout(i2c->wait,
 			i2c->algo_data.read_byte(i2c, I2C_PCA_CON)
 			& I2C_PCA_CON_SI, i2c->adap.timeout);
 	} else {
@@ -122,7 +122,7 @@ static irqreturn_t i2c_pca_pf_handler(in
 	if ((i2c->algo_data.read_byte(i2c, I2C_PCA_CON) & I2C_PCA_CON_SI) == 0)
 		return IRQ_NONE;
 
-	wake_up_interruptible(&i2c->wait);
+	wake_up(&i2c->wait);
 
 	return IRQ_HANDLED;
 }


