Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbYGQRjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbYGQRjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758198AbYGQRiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:38:52 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:38119
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041AbYGQRiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:38:51 -0400
Subject: [PATCH] synclink_gt add rx DMA buffer fill level control
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 11:37:51 -0500
Message-Id: <1216312671.3842.22.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add run time control for receive DMA buffer fill level
to allow application to control receive latency when using
stream oriented serial protocols that pass receive data
to application only after a DMA buffer fills. This was
previously a compile time option, but run time control
is needed when application changes data rate (and latency
requirements) or uses different data rates on different ports.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/drivers/char/synclink_gt.c	2008-07-17 08:39:06.000000000 -0500
+++ b/drivers/char/synclink_gt.c	2008-07-17 11:18:27.000000000 -0500
@@ -310,7 +310,7 @@ struct slgt_info {
 	u32 idle_mode;
 	u32 max_frame_size;       /* as set by device config */
 
-	unsigned int raw_rx_size;
+	unsigned int rbuf_fill_level;
 	unsigned int if_mode;
 
 	/* device status */
@@ -2690,8 +2690,29 @@ static int tx_abort(struct slgt_info *in
 static int rx_enable(struct slgt_info *info, int enable)
 {
  	unsigned long flags;
-	DBGINFO(("%s rx_enable(%d)\n", info->device_name, enable));
+	unsigned int rbuf_fill_level;
+	DBGINFO(("%s rx_enable(%08x)\n", info->device_name, enable));
 	spin_lock_irqsave(&info->lock,flags);
+	/*
+	 * enable[31..16] = receive DMA buffer fill level
+	 * 0 = noop (leave fill level unchanged)
+	 * fill level must be multiple of 4 and <= buffer size
+	 */
+	rbuf_fill_level = ((unsigned int)enable) >> 16;
+	if (rbuf_fill_level) {
+		if ((rbuf_fill_level > DMABUFSIZE) || (rbuf_fill_level % 4))
+			return -EINVAL;
+		info->rbuf_fill_level = rbuf_fill_level;
+		rx_stop(info); /* restart receiver to use new fill level */
+	}
+
+	/*
+	 * enable[1..0] = receiver enable command
+	 * 0 = disable
+	 * 1 = enable
+	 * 2 = enable or force hunt mode if already enabled
+	 */
+	enable &= 3;
 	if (enable) {
 		if (!info->rx_enabled)
 			rx_start(info);
@@ -3457,7 +3478,7 @@ static struct slgt_info *alloc_dev(int a
 		info->magic = MGSL_MAGIC;
 		INIT_WORK(&info->task, bh_handler);
 		info->max_frame_size = 4096;
-		info->raw_rx_size = DMABUFSIZE;
+		info->rbuf_fill_level = DMABUFSIZE;
 		info->close_delay = 5*HZ/10;
 		info->closing_wait = 30*HZ;
 		init_waitqueue_head(&info->open_wait);
@@ -4468,16 +4489,7 @@ static void free_rbufs(struct slgt_info 
 	while(!done) {
 		/* reset current buffer for reuse */
 		info->rbufs[i].status = 0;
-		switch(info->params.mode) {
-		case MGSL_MODE_RAW:
-		case MGSL_MODE_MONOSYNC:
-		case MGSL_MODE_BISYNC:
-			set_desc_count(info->rbufs[i], info->raw_rx_size);
-			break;
-		default:
-			set_desc_count(info->rbufs[i], DMABUFSIZE);
-		}
-
+		set_desc_count(info->rbufs[i], info->rbuf_fill_level);
 		if (i == last)
 			done = 1;
 		if (++i == info->rbuf_count)
@@ -4585,7 +4597,7 @@ check_again:
 
 	DBGBH(("%s rx frame status=%04X size=%d\n",
 		info->device_name, status, framesize));
-	DBGDATA(info, info->rbufs[start].buf, min_t(int, framesize, DMABUFSIZE), "rx");
+	DBGDATA(info, info->rbufs[start].buf, min_t(int, framesize, info->rbuf_fill_level), "rx");
 
 	if (framesize) {
 		if (!(info->params.crc_type & HDLC_CRC_RETURN_EX)) {
@@ -4605,7 +4617,7 @@ check_again:
 			info->icount.rxok++;
 
 			while(copy_count) {
-				int partial_count = min(copy_count, DMABUFSIZE);
+				int partial_count = min_t(int, copy_count, info->rbuf_fill_level);
 				memcpy(p, info->rbufs[i].buf, partial_count);
 				p += partial_count;
 				copy_count -= partial_count;


