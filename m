Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbYGQTA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbYGQTA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbYGQTAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:00:13 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:50887
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbYGQTAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:00:11 -0400
Subject: [PATCH] synclink_gt improve and simplify write method
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 12:58:41 -0500
Message-Id: <1216317521.3842.40.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve write method by allowing multiple HDLC frames
to be loaded into tx DMA buffer ring for continuous
frame transmission. This simplifies the transmit code
by using the common procedures for all serial protocols.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/drivers/char/synclink_gt.c	2008-07-17 08:39:06.000000000 -0500
+++ b/drivers/char/synclink_gt.c	2008-07-17 12:44:09.000000000 -0500
@@ -857,6 +857,7 @@ static int write(struct tty_struct *tty,
 	int ret = 0;
 	struct slgt_info *info = tty->driver_data;
 	unsigned long flags;
+	unsigned int bufs_needed;
 
 	if (sanity_check(info, tty->name, "write"))
 		goto cleanup;
@@ -873,25 +874,16 @@ static int write(struct tty_struct *tty,
 	if (!count)
 		goto cleanup;
 
-	if (info->params.mode == MGSL_MODE_RAW ||
-	    info->params.mode == MGSL_MODE_MONOSYNC ||
-	    info->params.mode == MGSL_MODE_BISYNC) {
-		unsigned int bufs_needed = (count/DMABUFSIZE);
-		unsigned int bufs_free = free_tbuf_count(info);
-		if (count % DMABUFSIZE)
-			++bufs_needed;
-		if (bufs_needed > bufs_free)
-			goto cleanup;
-	} else {
-		if (info->tx_active)
-			goto cleanup;
-		if (info->tx_count) {
-			/* send accumulated data from send_char() calls */
-			/* as frame and wait before accepting more data. */
-			tx_load(info, info->tx_buf, info->tx_count);
-			goto start;
-		}
+	if (!info->tx_active && info->tx_count) {
+		/* send accumulated data from send_char() */
+		tx_load(info, info->tx_buf, info->tx_count);
+		goto start;
 	}
+	bufs_needed = (count/DMABUFSIZE);
+	if (count % DMABUFSIZE)
+		++bufs_needed;
+	if (bufs_needed > free_tbuf_count(info))
+		goto cleanup;
 
 	ret = info->tx_count = count;
 	tx_load(info, buf, count);
@@ -3946,15 +3938,7 @@ static void tdma_start(struct slgt_info 
 
 	/* set 1st descriptor address */
 	wr_reg32(info, TDDAR, info->tbufs[info->tbuf_start].pdesc);
-	switch(info->params.mode) {
-	case MGSL_MODE_RAW:
-	case MGSL_MODE_MONOSYNC:
-	case MGSL_MODE_BISYNC:
-		wr_reg32(info, TDCSR, BIT2 + BIT0); /* IRQ + DMA enable */
-		break;
-	default:
-		wr_reg32(info, TDCSR, BIT0); /* DMA enable */
-	}
+	wr_reg32(info, TDCSR, BIT2 + BIT0); /* IRQ + DMA enable */
 }
 
 static void tx_stop(struct slgt_info *info)


