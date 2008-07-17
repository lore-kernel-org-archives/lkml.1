Return-Path: <linux-kernel-owner+w=401wt.eu-S1760165AbYGQSXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165AbYGQSXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756666AbYGQSXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:23:38 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:55985
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbYGQSXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:23:37 -0400
Subject: [PATCH] synclink_gt improve TIOCOUTQ accuracy
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 12:23:05 -0500
Message-Id: <1216315385.3842.32.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the accuracy of TIOCOUTQ value as implemented
in chars_in_buffer() method by walking and counting tx DMA buffers,
reading controller tx FIFO level and accounting for controller
tx shift register. The greatly improves application control of
transmit latency at lower data rates.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/drivers/char/synclink_gt.c	2008-07-17 08:39:06.000000000 -0500
+++ b/drivers/char/synclink_gt.c	2008-07-17 12:14:22.000000000 -0500
@@ -214,6 +214,7 @@ struct slgt_desc
 	char *buf;          /* virtual  address of data buffer */
     	unsigned int pdesc; /* physical address of this descriptor */
 	dma_addr_t buf_dma_addr;
+	unsigned short buf_count;
 };
 
 #define set_desc_buffer(a,b) (a).pbuf = cpu_to_le32((unsigned int)(b))
@@ -474,6 +475,7 @@ static void tx_start(struct slgt_info *i
 static void tx_stop(struct slgt_info *info);
 static void tx_set_idle(struct slgt_info *info);
 static unsigned int free_tbuf_count(struct slgt_info *info);
+static unsigned int tbuf_bytes(struct slgt_info *info);
 static void reset_tbufs(struct slgt_info *info);
 static void tdma_reset(struct slgt_info *info);
 static void tdma_start(struct slgt_info *info);
@@ -1404,10 +1406,12 @@ done:
 static int chars_in_buffer(struct tty_struct *tty)
 {
 	struct slgt_info *info = tty->driver_data;
+	int count;
 	if (sanity_check(info, tty->name, "chars_in_buffer"))
 		return 0;
-	DBGINFO(("%s chars_in_buffer()=%d\n", info->device_name, info->tx_count));
-	return info->tx_count;
+	count = tbuf_bytes(info);
+	DBGINFO(("%s chars_in_buffer()=%d\n", info->device_name, count));
+	return count;
 }
 
 /*
@@ -4697,6 +4701,56 @@ static unsigned int free_tbuf_count(stru
 }
 
 /*
+ * return number of bytes in unsent transmit DMA buffers
+ * and the serial controller tx FIFO
+ */
+static unsigned int tbuf_bytes(struct slgt_info *info)
+{
+	unsigned int total_count = 0;
+	unsigned int i = info->tbuf_current;
+	unsigned int reg_value;
+	unsigned int count;
+	unsigned int active_buf_count = 0;
+
+	/*
+	 * Add descriptor counts for all tx DMA buffers.
+	 * If count is zero (cleared by DMA controller after read),
+	 * the buffer is complete or is actively being read from.
+	 *
+	 * Record buf_count of last buffer with zero count starting
+	 * from current ring position. buf_count is mirror
+	 * copy of count and is not cleared by serial controller.
+	 * If DMA controller is active, that buffer is actively
+	 * being read so add to total.
+	 */
+	do {
+		count = desc_count(info->tbufs[i]);
+		if (count)
+			total_count += count;
+		else if (!total_count)
+			active_buf_count = info->tbufs[i].buf_count;
+		if (++i == info->tbuf_count)
+			i = 0;
+	} while (i != info->tbuf_current);
+
+	/* read tx DMA status register */
+	reg_value = rd_reg32(info, TDCSR);
+
+	/* if tx DMA active, last zero count buffer is in use */
+	if (reg_value & BIT0)
+		total_count += active_buf_count;
+
+	/* add tx FIFO count = reg_value[15..8] */
+	total_count += (reg_value >> 8) & 0xff;
+
+	/* if transmitter active add one byte for shift register */
+	if (info->tx_active)
+		total_count++;
+
+	return total_count;
+}
+
+/*
  * load transmit DMA buffer(s) with data
  */
 static void tx_load(struct slgt_info *info, const char *buf, unsigned int size)
@@ -4734,6 +4788,7 @@ static void tx_load(struct slgt_info *in
 			set_desc_eof(*d, 0);
 
 		set_desc_count(*d, count);
+		d->buf_count = count;
 	}
 
 	info->tbuf_current = i;




