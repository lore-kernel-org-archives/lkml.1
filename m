Return-Path: <linux-kernel-owner+w=401wt.eu-S1161292AbXD2VDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161292AbXD2VDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161338AbXD2VDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:03:19 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:48261 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161292AbXD2VDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:03:18 -0400
Message-id: <30900245101364921@wsc.cz>
In-reply-to: <1726067771982725064@wsc.cz>
Subject: [PATCH 15/21] Char: cyclades, remove unused timestamps
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2007 23:03:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, remove unused timestamps

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 5a04eb52bbde6de3f92613f57f5d667a5cb3e8bd
tree 22665c0e01dfd91bc52252cd024a3aa1015be555
parent 86d2bb56b6a8f3c51b7bd537634645fa14862085
author Jiri Slaby <jirislaby@gmail.com> Fri, 27 Apr 2007 16:19:36 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 28 Apr 2007 23:48:33 +0200

 drivers/char/cyclades.c  |   12 ------------
 include/linux/cyclades.h |    2 --
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 14652c1..ab9ad66 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1049,7 +1049,6 @@ static void cyy_intr_chip(struct cyclades_card *cinfo, int chip,
 		channel = (u_short) (save_xir & CyIRChannel);
 		i = channel + chip * 4 + cinfo->first_line;
 		info = &cy_port[i];
-		info->last_active = jiffies;
 		save_car = readb(base_addr + (CyCAR << index));
 		cy_writeb(base_addr + (CyCAR << index), save_xir);
 
@@ -1225,7 +1224,6 @@ static void cyy_intr_chip(struct cyclades_card *cinfo, int chip,
 			goto txend;
 		}
 		info = &cy_port[i];
-		info->last_active = jiffies;
 		if (info->tty == 0) {
 			cy_writeb(base_addr + (CySRER << index),
 				  readb(base_addr + (CySRER << index)) &
@@ -1339,7 +1337,6 @@ txend:
 		save_xir = (u_char) readb(base_addr + (CyMIR << index));
 		channel = (u_short) (save_xir & CyIRChannel);
 		info = &cy_port[channel + chip * 4 + cinfo->first_line];
-		info->last_active = jiffies;
 		save_car = readb(base_addr + (CyCAR << index));
 		cy_writeb(base_addr + (CyCAR << index), save_xir);
 
@@ -1570,9 +1567,6 @@ cyz_handle_rx(struct cyclades_port *info, struct CH_CTRL __iomem *ch_ctrl,
 		char_count = rx_put - rx_get + rx_bufsize;
 
 	if (char_count) {
-		info->last_active = jiffies;
-		info->jiffies[1] = jiffies;
-
 #ifdef CY_ENABLE_MONITORING
 		info->mon.int_count++;
 		info->mon.char_count += char_count;
@@ -1678,8 +1672,6 @@ cyz_handle_tx(struct cyclades_port *info, struct CH_CTRL __iomem *ch_ctrl,
 			info->x_char = 0;
 			char_count--;
 			info->icount.tx++;
-			info->last_active = jiffies;
-			info->jiffies[2] = jiffies;
 		}
 #ifdef BLOCKMOVE
 		while (0 < (small_count = min_t(unsigned int,
@@ -1699,8 +1691,6 @@ cyz_handle_tx(struct cyclades_port *info, struct CH_CTRL __iomem *ch_ctrl,
 			info->xmit_cnt -= small_count;
 			info->xmit_tail = (info->xmit_tail + small_count) &
 					(SERIAL_XMIT_SIZE - 1);
-			info->last_active = jiffies;
-			info->jiffies[2] = jiffies;
 		}
 #else
 		while (info->xmit_cnt && char_count) {
@@ -1713,8 +1703,6 @@ cyz_handle_tx(struct cyclades_port *info, struct CH_CTRL __iomem *ch_ctrl,
 			tx_put = (tx_put + 1) & (tx_bufsize - 1);
 			char_count--;
 			info->icount.tx++;
-			info->last_active = jiffies;
-			info->jiffies[2] = jiffies;
 		}
 #endif
 ztxdone:
diff --git a/include/linux/cyclades.h b/include/linux/cyclades.h
index cdd7739..07791f0 100644
--- a/include/linux/cyclades.h
+++ b/include/linux/cyclades.h
@@ -569,7 +569,6 @@ struct cyclades_port {
 	int			close_delay;
 	unsigned short		closing_wait;
 	unsigned long		event;
-	unsigned long		last_active;
 	int			count;	/* # of fd on device */
 	int                     breakon;
 	int                     breakoff;
@@ -580,7 +579,6 @@ struct cyclades_port {
 	int			xmit_cnt;
         int                     default_threshold;
         int                     default_timeout;
-	unsigned long		jiffies[3];
 	unsigned long		rflush_count;
 	struct cyclades_monitor	mon;
 	struct cyclades_idle_stats	idle_stats;
