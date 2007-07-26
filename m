Return-Path: <linux-kernel-owner+w=401wt.eu-S936272AbXGZSGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936272AbXGZSGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934674AbXGZSGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:06:30 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:53336
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936119AbXGZSG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:06:29 -0400
Subject: [PATCH] synclink_gt fix transmit DMA stall
From: Paul Fulghum <paulkf@microgate.com>
To: "akpm@osdl.org" <akpm@osdl.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 12:06:18 -0500
Message-Id: <1185469578.3875.5.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix transmit DMA stall when write() called in window after
previous transmit DMA completes but before previous serial
transmission completes.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/drivers/char/synclink_gt.c	2007-07-08 18:32:17.000000000 -0500
+++ b/drivers/char/synclink_gt.c	2007-07-26 10:39:56.000000000 -0500
@@ -1,5 +1,5 @@
 /*
- * $Id: synclink_gt.c,v 4.36 2006/08/28 20:47:14 paulkf Exp $
+ * $Id: synclink_gt.c,v 4.50 2007/07/25 19:29:25 paulkf Exp $
  *
  * Device driver for Microgate SyncLink GT serial adapters.
  *
@@ -93,7 +93,7 @@
  * module identification
  */
 static char *driver_name     = "SyncLink GT";
-static char *driver_version  = "$Revision: 4.36 $";
+static char *driver_version  = "$Revision: 4.50 $";
 static char *tty_driver_name = "synclink_gt";
 static char *tty_dev_prefix  = "ttySLG";
 MODULE_LICENSE("GPL");
@@ -479,6 +479,7 @@ static void tx_set_idle(struct slgt_info
 static unsigned int free_tbuf_count(struct slgt_info *info);
 static void reset_tbufs(struct slgt_info *info);
 static void tdma_reset(struct slgt_info *info);
+static void tdma_start(struct slgt_info *info);
 static void tx_load(struct slgt_info *info, const char *buf, unsigned int count);
 
 static void get_signals(struct slgt_info *info);
@@ -912,6 +913,8 @@ start:
 		spin_lock_irqsave(&info->lock,flags);
 		if (!info->tx_active)
 		 	tx_start(info);
+		else
+			tdma_start(info);
 		spin_unlock_irqrestore(&info->lock,flags);
  	}
 
@@ -3880,44 +3883,58 @@ static void tx_start(struct slgt_info *i
 			slgt_irq_on(info, IRQ_TXUNDER + IRQ_TXIDLE);
 			/* clear tx idle and underrun status bits */
 			wr_reg16(info, SSR, (unsigned short)(IRQ_TXIDLE + IRQ_TXUNDER));
-
-			if (!(rd_reg32(info, TDCSR) & BIT0)) {
-				/* tx DMA stopped, restart tx DMA */
-				tdma_reset(info);
-				/* set 1st descriptor address */
-				wr_reg32(info, TDDAR, info->tbufs[info->tbuf_start].pdesc);
-				switch(info->params.mode) {
-				case MGSL_MODE_RAW:
-				case MGSL_MODE_MONOSYNC:
-				case MGSL_MODE_BISYNC:
-					wr_reg32(info, TDCSR, BIT2 + BIT0); /* IRQ + DMA enable */
-					break;
-				default:
-					wr_reg32(info, TDCSR, BIT0); /* DMA enable */
-				}
-			}
-
 			if (info->params.mode == MGSL_MODE_HDLC)
 				mod_timer(&info->tx_timer, jiffies +
 						msecs_to_jiffies(5000));
 		} else {
-			tdma_reset(info);
-			/* set 1st descriptor address */
-			wr_reg32(info, TDDAR, info->tbufs[info->tbuf_start].pdesc);
-
 			slgt_irq_off(info, IRQ_TXDATA);
 			slgt_irq_on(info, IRQ_TXIDLE);
 			/* clear tx idle status bit */
 			wr_reg16(info, SSR, IRQ_TXIDLE);
-
-			/* enable tx DMA */
-			wr_reg32(info, TDCSR, BIT0);
 		}
-
+		tdma_start(info);
 		info->tx_active = 1;
 	}
 }
 
+/*
+ * start transmit DMA if inactive and there are unsent buffers
+ */
+static void tdma_start(struct slgt_info *info)
+{
+	unsigned int i;
+
+	if (rd_reg32(info, TDCSR) & BIT0)
+		return;
+
+	/* transmit DMA inactive, check for unsent buffers */
+	i = info->tbuf_start;
+	while (!desc_count(info->tbufs[i])) {
+		if (++i == info->tbuf_count)
+			i = 0;
+		if (i == info->tbuf_current)
+			return;
+	}
+	info->tbuf_start = i;
+
+	/* there are unsent buffers, start transmit DMA */
+
+	/* reset needed if previous error condition */
+	tdma_reset(info);
+
+	/* set 1st descriptor address */
+	wr_reg32(info, TDDAR, info->tbufs[info->tbuf_start].pdesc);
+	switch(info->params.mode) {
+	case MGSL_MODE_RAW:
+	case MGSL_MODE_MONOSYNC:
+	case MGSL_MODE_BISYNC:
+		wr_reg32(info, TDCSR, BIT2 + BIT0); /* IRQ + DMA enable */
+		break;
+	default:
+		wr_reg32(info, TDCSR, BIT0); /* DMA enable */
+	}
+}
+
 static void tx_stop(struct slgt_info *info)
 {
 	unsigned short val;
@@ -4651,8 +4668,8 @@ static unsigned int free_tbuf_count(stru
 			i=0;
 	} while (i != info->tbuf_current);
 
-	/* last buffer with zero count may be in use, assume it is */
-	if (count)
+	/* if tx DMA active, last zero count buffer is in use */
+	if (count && (rd_reg32(info, TDCSR) & BIT0))
 		--count;
 
 	return count;


