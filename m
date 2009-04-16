Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbZDPPy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbZDPPy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 11:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbZDPPyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 11:54:06 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:47463
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659AbZDPPyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 11:54:04 -0400
Subject: [PATCH] synclink_gt add receive pio mode
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 10:53:24 -0500
Message-Id: <1239897204.13866.7.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add receive programmed IO mode to reduce receive latency
when using low data rates. The receive FIFO trigger
level of 128 bytes used in DMA mode creates excessive latency
when operating at low data rates. PIO mode is selected when user
application requests data in blocks of less than 128 bytes.

--- a/drivers/char/synclink_gt.c	2009-04-16 09:50:46.000000000 -0500
+++ b/drivers/char/synclink_gt.c	2009-04-16 10:04:07.000000000 -0500
@@ -214,6 +214,7 @@ struct slgt_desc
 #define set_desc_next(a,b) (a).next   = cpu_to_le32((unsigned int)(b))
 #define set_desc_count(a,b)(a).count  = cpu_to_le16((unsigned short)(b))
 #define set_desc_eof(a,b)  (a).status = cpu_to_le16((b) ? (le16_to_cpu((a).status) | BIT0) : (le16_to_cpu((a).status) & ~BIT0))
+#define set_desc_status(a, b) (a).status = cpu_to_le16((unsigned short)(b))
 #define desc_count(a)      (le16_to_cpu((a).count))
 #define desc_status(a)     (le16_to_cpu((a).status))
 #define desc_complete(a)   (le16_to_cpu((a).status) & BIT15)
@@ -297,6 +298,7 @@ struct slgt_info {
 	u32 max_frame_size;       /* as set by device config */
 
 	unsigned int rbuf_fill_level;
+	unsigned int rx_pio;
 	unsigned int if_mode;
 
 	/* device status */
@@ -330,6 +332,8 @@ struct slgt_info {
 	struct slgt_desc *rbufs;
 	unsigned int rbuf_current;
 	unsigned int rbuf_index;
+	unsigned int rbuf_fill_index;
+	unsigned short rbuf_fill_count;
 
 	unsigned int tbuf_count;
 	struct slgt_desc *tbufs;
@@ -2107,6 +2111,40 @@ static void ri_change(struct slgt_info *
 	info->pending_bh |= BH_STATUS;
 }
 
+static void isr_rxdata(struct slgt_info *info)
+{
+	unsigned int count = info->rbuf_fill_count;
+	unsigned int i = info->rbuf_fill_index;
+	unsigned short reg;
+
+	while (rd_reg16(info, SSR) & IRQ_RXDATA) {
+		reg = rd_reg16(info, RDR);
+		DBGISR(("isr_rxdata %s RDR=%04X\n", info->device_name, reg));
+		if (desc_complete(info->rbufs[i])) {
+			/* all buffers full */
+			rx_stop(info);
+			info->rx_restart = 1;
+			continue;
+		}
+		info->rbufs[i].buf[count++] = (unsigned char)reg;
+		/* async mode saves status byte to buffer for each data byte */
+		if (info->params.mode == MGSL_MODE_ASYNC)
+			info->rbufs[i].buf[count++] = (unsigned char)(reg >> 8);
+		if (count == info->rbuf_fill_level || (reg & BIT10)) {
+			/* buffer full or end of frame */
+			set_desc_count(info->rbufs[i], count);
+			set_desc_status(info->rbufs[i], BIT15 | (reg >> 8));
+			info->rbuf_fill_count = count = 0;
+			if (++i == info->rbuf_count)
+				i = 0;
+			info->pending_bh |= BH_RECEIVE;
+		}
+	}
+
+	info->rbuf_fill_index = i;
+	info->rbuf_fill_count = count;
+}
+
 static void isr_serial(struct slgt_info *info)
 {
 	unsigned short status = rd_reg16(info, SSR);
@@ -2122,6 +2160,8 @@ static void isr_serial(struct slgt_info 
 			if (info->tx_count)
 				isr_txeom(info, status);
 		}
+		if (info->rx_pio && (status & IRQ_RXDATA))
+			isr_rxdata(info);
 		if ((status & IRQ_RXBREAK) && (status & RXBREAK)) {
 			info->icount.brk++;
 			/* process break detection if tty control allows */
@@ -2138,7 +2178,8 @@ static void isr_serial(struct slgt_info 
 	} else {
 		if (status & (IRQ_TXIDLE + IRQ_TXUNDER))
 			isr_txeom(info, status);
-
+		if (info->rx_pio && (status & IRQ_RXDATA))
+			isr_rxdata(info);
 		if (status & IRQ_RXIDLE) {
 			if (status & RXIDLE)
 				info->icount.rxidle++;
@@ -2636,6 +2677,10 @@ static int rx_enable(struct slgt_info *i
 			return -EINVAL;
 		}
 		info->rbuf_fill_level = rbuf_fill_level;
+		if (rbuf_fill_level < 128)
+			info->rx_pio = 1; /* PIO mode */
+		else
+			info->rx_pio = 0; /* DMA mode */
 		rx_stop(info); /* restart receiver to use new fill level */
 	}
 
@@ -3834,15 +3879,27 @@ static void rx_start(struct slgt_info *i
 	rdma_reset(info);
 	reset_rbufs(info);
 
-	/* set 1st descriptor address */
-	wr_reg32(info, RDDAR, info->rbufs[0].pdesc);
-
-	if (info->params.mode != MGSL_MODE_ASYNC) {
-		/* enable rx DMA and DMA interrupt */
-		wr_reg32(info, RDCSR, (BIT2 + BIT0));
+	if (info->rx_pio) {
+		/* rx request when rx FIFO not empty */
+		wr_reg16(info, SCR, (unsigned short)(rd_reg16(info, SCR) & ~BIT14));
+		slgt_irq_on(info, IRQ_RXDATA);
+		if (info->params.mode == MGSL_MODE_ASYNC) {
+			/* enable saving of rx status */
+			wr_reg32(info, RDCSR, BIT6);
+		}
 	} else {
-		/* enable saving of rx status, rx DMA and DMA interrupt */
-		wr_reg32(info, RDCSR, (BIT6 + BIT2 + BIT0));
+		/* rx request when rx FIFO half full */
+		wr_reg16(info, SCR, (unsigned short)(rd_reg16(info, SCR) | BIT14));
+		/* set 1st descriptor address */
+		wr_reg32(info, RDDAR, info->rbufs[0].pdesc);
+
+		if (info->params.mode != MGSL_MODE_ASYNC) {
+			/* enable rx DMA and DMA interrupt */
+			wr_reg32(info, RDCSR, (BIT2 + BIT0));
+		} else {
+			/* enable saving of rx status, rx DMA and DMA interrupt */
+			wr_reg32(info, RDCSR, (BIT6 + BIT2 + BIT0));
+		}
 	}
 
 	slgt_irq_on(info, IRQ_RXOVER);
@@ -4451,6 +4508,8 @@ static void free_rbufs(struct slgt_info 
 static void reset_rbufs(struct slgt_info *info)
 {
 	free_rbufs(info, 0, info->rbuf_count - 1);
+	info->rbuf_fill_index = 0;
+	info->rbuf_fill_count = 0;
 }
 
 /*


