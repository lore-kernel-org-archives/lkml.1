Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbXJXAV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbXJXAV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 20:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbXJXAVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 20:21:50 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:50362 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbXJXAVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 20:21:50 -0400
Message-ID: <471E901A.1080903@tiscali.nl>
Date: Wed, 24 Oct 2007 02:21:46 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix unlocking before return in gpio
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Fix unlocking before return in gpio
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/cris/arch-v10/drivers/gpio.c b/arch/cris/arch-v10/drivers/gpio.c
index f389ed6..0d347a7 100644
--- a/arch/cris/arch-v10/drivers/gpio.c
+++ b/arch/cris/arch-v10/drivers/gpio.c
@@ -297,8 +297,10 @@ gpio_poll(struct file *file,
 		data = *R_PORT_PB_DATA;
 	else if (priv->minor == GPIO_MINOR_G)
 		data = *R_PORT_G_DATA;
-	else
+	else {
+		spin_unlock(&gpio_lock);
 		return 0;
+	}
 	
 	if ((data & priv->highalarm) ||
 	    (~data & priv->lowalarm)) {
@@ -381,18 +383,21 @@ static ssize_t gpio_write(struct file * file, const char * buf, size_t count,
 
 	ssize_t retval = count;
 	if (priv->minor !=GPIO_MINOR_A && priv->minor != GPIO_MINOR_B) {
-		return -EFAULT;
+		retval = -EFAULT;
+		goto out;
 	}
     
 	if (!access_ok(VERIFY_READ, buf, count)) {
-		return -EFAULT;
+		retval = -EFAULT;
+		goto out;
 	}
 	clk_mask = priv->clk_mask;
 	data_mask = priv->data_mask;
 	/* It must have been configured using the IO_CFG_WRITE_MODE */
 	/* Perhaps a better error code? */
 	if (clk_mask == 0 || data_mask == 0) {
-		return -EPERM;
+		retval = -EPERM;
+		goto out;
 	}
 	write_msb = priv->write_msb;
 	D(printk("gpio_write: %lu to data 0x%02X clk 0x%02X msb: %i\n",count, data_mask, clk_mask, write_msb));
@@ -425,6 +430,7 @@ static ssize_t gpio_write(struct file * file, const char * buf, size_t count,
 			}
 		}
 	}
+out:
 	spin_unlock(&gpio_lock);
 	return retval;
 }
@@ -506,6 +512,7 @@ gpio_release(struct inode *inode, struct file *filp)
 	while (p) {
 		if (p->highalarm | p->lowalarm) {
 			gpio_some_alarms = 1;
+			spin_unlock(&gpio_lock);
 			return 0;
 		}
 		p = p->next;
