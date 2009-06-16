Return-Path: <linux-kernel-owner+w=401wt.eu-S1761954AbZFPToU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761954AbZFPToU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbZFPToL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:44:11 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:41366
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbZFPToK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:44:10 -0400
Subject: [PATCH] synclink_gt fix transmit race and timeout
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 14:44:11 -0500
Message-Id: <1245181451.3727.5.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix race condition when adding transmit data to active DMA buffer ring
that can cause transmit stall.
Update transmit timeout when adding data to active DMA buffer ring.
Base transmit timeout on amount of buffered data instead of
using fixed value.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/drivers/char/synclink_gt.c	2009-06-09 22:05:27.000000000 -0500
+++ b/drivers/char/synclink_gt.c	2009-06-16 13:58:14.000000000 -0500
@@ -463,7 +463,6 @@ static unsigned int free_tbuf_count(stru
 static unsigned int tbuf_bytes(struct slgt_info *info);
 static void reset_tbufs(struct slgt_info *info);
 static void tdma_reset(struct slgt_info *info);
-static void tdma_start(struct slgt_info *info);
 static void tx_load(struct slgt_info *info, const char *buf, unsigned int count);
 
 static void get_signals(struct slgt_info *info);
@@ -791,6 +790,18 @@ static void set_termios(struct tty_struc
 	}
 }
 
+static void update_tx_timer(struct slgt_info *info)
+{
+	/*
+	 * use worst case speed of 1200bps to calculate transmit timeout
+	 * based on data in buffers (tbuf_bytes) and FIFO (128 bytes)
+	 */
+	if (info->params.mode == MGSL_MODE_HDLC) {
+		int timeout  = (tbuf_bytes(info) * 7) + 1000;
+		mod_timer(&info->tx_timer, jiffies + msecs_to_jiffies(timeout));
+	}
+}
+
 static int write(struct tty_struct *tty,
 		 const unsigned char *buf, int count)
 {
@@ -834,8 +845,18 @@ start:
 		spin_lock_irqsave(&info->lock,flags);
 		if (!info->tx_active)
 		 	tx_start(info);
-		else
-			tdma_start(info);
+		else if (!(rd_reg32(info, TDCSR) & BIT0)) {
+			/* transmit still active but transmit DMA stopped */
+			unsigned int i = info->tbuf_current;
+			if (!i)
+				i = info->tbuf_count;
+			i--;
+			/* if DMA buf unsent must try later after tx idle */
+			if (desc_count(info->tbufs[i]))
+				ret = 0;
+		}
+		if (ret > 0)
+			update_tx_timer(info);
 		spin_unlock_irqrestore(&info->lock,flags);
  	}
 
@@ -1498,10 +1519,9 @@ static int hdlcdev_xmit(struct sk_buff *
 	/* save start time for transmit timeout detection */
 	dev->trans_start = jiffies;
 
-	/* start hardware transmitter if necessary */
 	spin_lock_irqsave(&info->lock,flags);
-	if (!info->tx_active)
-	 	tx_start(info);
+	tx_start(info);
+	update_tx_timer(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 
 	return 0;
@@ -3886,50 +3906,19 @@ static void tx_start(struct slgt_info *i
 			slgt_irq_on(info, IRQ_TXUNDER + IRQ_TXIDLE);
 			/* clear tx idle and underrun status bits */
 			wr_reg16(info, SSR, (unsigned short)(IRQ_TXIDLE + IRQ_TXUNDER));
-			if (info->params.mode == MGSL_MODE_HDLC)
-				mod_timer(&info->tx_timer, jiffies +
-						msecs_to_jiffies(5000));
 		} else {
 			slgt_irq_off(info, IRQ_TXDATA);
 			slgt_irq_on(info, IRQ_TXIDLE);
 			/* clear tx idle status bit */
 			wr_reg16(info, SSR, IRQ_TXIDLE);
 		}
-		tdma_start(info);
+		/* set 1st descriptor address and start DMA */
+		wr_reg32(info, TDDAR, info->tbufs[info->tbuf_start].pdesc);
+		wr_reg32(info, TDCSR, BIT2 + BIT0);
 		info->tx_active = true;
 	}
 }
 
-/*
- * start transmit DMA if inactive and there are unsent buffers
- */
-static void tdma_start(struct slgt_info *info)
-{
-	unsigned int i;
-
-	if (rd_reg32(info, TDCSR) & BIT0)
-		return;
-
-	/* transmit DMA inactive, check for unsent buffers */
-	i = info->tbuf_start;
-	while (!desc_count(info->tbufs[i])) {
-		if (++i == info->tbuf_count)
-			i = 0;
-		if (i == info->tbuf_current)
-			return;
-	}
-	info->tbuf_start = i;
-
-	/* there are unsent buffers, start transmit DMA */
-
-	/* reset needed if previous error condition */
-	tdma_reset(info);
-
-	/* set 1st descriptor address */
-	wr_reg32(info, TDDAR, info->tbufs[info->tbuf_start].pdesc);
-	wr_reg32(info, TDCSR, BIT2 + BIT0); /* IRQ + DMA enable */
-}
-
 static void tx_stop(struct slgt_info *info)
 {
 	unsigned short val;
@@ -4942,8 +4931,7 @@ static void tx_timeout(unsigned long con
 		info->icount.txtimeout++;
 	}
 	spin_lock_irqsave(&info->lock,flags);
-	info->tx_active = false;
-	info->tx_count = 0;
+	tx_stop(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 
 #if SYNCLINK_GENERIC_HDLC


