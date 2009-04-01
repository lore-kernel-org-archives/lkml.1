Return-Path: <linux-kernel-owner+w=401wt.eu-S933367AbZDASOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367AbZDASOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 14:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757731AbZDASOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 14:14:22 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:57087
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132AbZDASOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 14:14:21 -0400
Subject: [PATCH] synclink_gt add clock options
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 01 Apr 2009 13:13:28 -0500
Message-Id: <1238609608.4022.3.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for x8 asynchronous sample rate and
ability to specify base clock frequency.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/include/linux/synclink.h	2009-03-23 18:12:14.000000000 -0500
+++ b/include/linux/synclink.h	2009-04-01 10:07:06.000000000 -0500
@@ -125,6 +125,7 @@
 #define MGSL_MODE_MONOSYNC	3
 #define MGSL_MODE_BISYNC	4
 #define MGSL_MODE_RAW		6
+#define MGSL_MODE_BASE_CLOCK    7
 
 #define MGSL_BUS_TYPE_ISA	1
 #define MGSL_BUS_TYPE_EISA	2
--- a/drivers/char/synclink_gt.c	2009-03-23 18:12:14.000000000 -0500
+++ b/drivers/char/synclink_gt.c	2009-04-01 09:54:43.000000000 -0500
@@ -298,6 +298,7 @@ struct slgt_info {
 
 	unsigned int rbuf_fill_level;
 	unsigned int if_mode;
+	unsigned int base_clock;
 
 	/* device status */
 
@@ -1156,22 +1157,26 @@ static long set_params32(struct slgt_inf
 		return -EFAULT;
 
 	spin_lock(&info->lock);
-	info->params.mode            = tmp_params.mode;
-	info->params.loopback        = tmp_params.loopback;
-	info->params.flags           = tmp_params.flags;
-	info->params.encoding        = tmp_params.encoding;
-	info->params.clock_speed     = tmp_params.clock_speed;
-	info->params.addr_filter     = tmp_params.addr_filter;
-	info->params.crc_type        = tmp_params.crc_type;
-	info->params.preamble_length = tmp_params.preamble_length;
-	info->params.preamble        = tmp_params.preamble;
-	info->params.data_rate       = tmp_params.data_rate;
-	info->params.data_bits       = tmp_params.data_bits;
-	info->params.stop_bits       = tmp_params.stop_bits;
-	info->params.parity          = tmp_params.parity;
+	if (tmp_params.mode == MGSL_MODE_BASE_CLOCK) {
+		info->base_clock = tmp_params.clock_speed;
+	} else {
+		info->params.mode            = tmp_params.mode;
+		info->params.loopback        = tmp_params.loopback;
+		info->params.flags           = tmp_params.flags;
+		info->params.encoding        = tmp_params.encoding;
+		info->params.clock_speed     = tmp_params.clock_speed;
+		info->params.addr_filter     = tmp_params.addr_filter;
+		info->params.crc_type        = tmp_params.crc_type;
+		info->params.preamble_length = tmp_params.preamble_length;
+		info->params.preamble        = tmp_params.preamble;
+		info->params.data_rate       = tmp_params.data_rate;
+		info->params.data_bits       = tmp_params.data_bits;
+		info->params.stop_bits       = tmp_params.stop_bits;
+		info->params.parity          = tmp_params.parity;
+	}
 	spin_unlock(&info->lock);
 
- 	change_params(info);
+	program_hw(info);
 
 	return 0;
 }
@@ -2561,10 +2566,13 @@ static int set_params(struct slgt_info *
 		return -EFAULT;
 
 	spin_lock_irqsave(&info->lock, flags);
-	memcpy(&info->params, &tmp_params, sizeof(MGSL_PARAMS));
+	if (tmp_params.mode == MGSL_MODE_BASE_CLOCK)
+		info->base_clock = tmp_params.clock_speed;
+	else
+		memcpy(&info->params, &tmp_params, sizeof(MGSL_PARAMS));
 	spin_unlock_irqrestore(&info->lock, flags);
 
- 	change_params(info);
+	program_hw(info);
 
 	return 0;
 }
@@ -3434,6 +3442,7 @@ static struct slgt_info *alloc_dev(int a
 		info->magic = MGSL_MAGIC;
 		INIT_WORK(&info->task, bh_handler);
 		info->max_frame_size = 4096;
+		info->base_clock = 14745600;
 		info->rbuf_fill_level = DMABUFSIZE;
 		info->port.close_delay = 5*HZ/10;
 		info->port.closing_wait = 30*HZ;
@@ -3781,7 +3790,7 @@ static void enable_loopback(struct slgt_
 static void set_rate(struct slgt_info *info, u32 rate)
 {
 	unsigned int div;
-	static unsigned int osc = 14745600;
+	unsigned int osc = info->base_clock;
 
 	/* div = osc/rate - 1
 	 *
@@ -4085,18 +4094,27 @@ static void async_mode(struct slgt_info 
 	 * 06  CTS      IRQ enable
 	 * 05  DCD      IRQ enable
 	 * 04  RI       IRQ enable
-	 * 03  reserved, must be zero
+	 * 03  0=16x sampling, 1=8x sampling
 	 * 02  1=txd->rxd internal loopback enable
 	 * 01  reserved, must be zero
 	 * 00  1=master IRQ enable
 	 */
 	val = BIT15 + BIT14 + BIT0;
+	/* JCR[8] : 1 = x8 async mode feature available */
+	if ((rd_reg32(info, JCR) & BIT8) && info->params.data_rate &&
+	    ((info->base_clock < (info->params.data_rate * 16)) ||
+	     (info->base_clock % (info->params.data_rate * 16)))) {
+		/* use 8x sampling */
+		val |= BIT3;
+		set_rate(info, info->params.data_rate * 8);
+	} else {
+		/* use 16x sampling */
+		set_rate(info, info->params.data_rate * 16);
+	}
 	wr_reg16(info, SCR, val);
 
 	slgt_irq_on(info, IRQ_RXBREAK | IRQ_RXOVER);
 
-	set_rate(info, info->params.data_rate * 16);
-
 	if (info->params.loopback)
 		enable_loopback(info);
 }


