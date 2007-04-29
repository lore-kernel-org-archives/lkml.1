Return-Path: <linux-kernel-owner+w=401wt.eu-S1161323AbXD2VBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161323AbXD2VBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161303AbXD2VBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:01:55 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:48250 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161323AbXD2VBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:01:54 -0400
Message-id: <181033173971179592@wsc.cz>
In-reply-to: <1726067771982725064@wsc.cz>
Subject: [PATCH 13/21] Char: cyclades, fix blockmove
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2007 23:01:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, fix blockmove

tty has no longer flip buffers accessible externally. Fix it by moving the
code to the tty_*flip* helpers.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 147542c38691d4e5049b916b083dc93bc3bf8c3b
tree 8986e0764afc717d7d283326b87aa5e3dff8b052
parent 300e8efee2151f3bd26ed824f932fba53a7313f4
author Jiri Slaby <jirislaby@gmail.com> Fri, 27 Apr 2007 15:48:28 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 28 Apr 2007 23:48:17 +0200

 drivers/char/cyclades.c |   34 ++++++++++++++++------------------
 1 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index c236e9f..9160953 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1560,7 +1560,7 @@ cyz_handle_rx(struct cyclades_port *info, struct CH_CTRL __iomem *ch_ctrl,
 	int char_count;
 	int len;
 #ifdef BLOCKMOVE
-	int small_count;
+	unsigned char *buf;
 #else
 	char data;
 #endif
@@ -1596,25 +1596,23 @@ cyz_handle_rx(struct cyclades_port *info, struct CH_CTRL __iomem *ch_ctrl,
 		/* we'd like to use memcpy(t, f, n) and memset(s, c, count)
 		   for performance, but because of buffer boundaries, there
 		   may be several steps to the operation */
-			while (0 < (small_count = min_t(unsigned int,
-					rx_bufsize - new_rx_get,
-					min_t(unsigned int, TTY_FLIPBUF_SIZE -
-						tty->flip.count, char_count)))){
-				memcpy_fromio(tty->flip.char_buf_ptr,
-					(char *)(cinfo->base_addr + rx_bufaddr +
-						new_rx_get),
-					small_count);
+			while (1) {
+				len = tty_prepare_flip_string(tty, &buf,
+						char_count);
+				if (!len)
+					break;
 
-				tty->flip.char_buf_ptr += small_count;
-				memset(tty->flip.flag_buf_ptr, TTY_NORMAL,
-					small_count);
-				tty->flip.flag_buf_ptr += small_count;
-				new_rx_get = (new_rx_get + small_count) &
+				len = min_t(unsigned int, min(len, char_count),
+						rx_bufsize - new_rx_get);
+
+				memcpy_fromio(buf, cinfo->base_addr +
+						rx_bufaddr + new_rx_get, len);
+
+				new_rx_get = (new_rx_get + len) &
 						(rx_bufsize - 1);
-				char_count -= small_count;
-				info->icount.rx += small_count;
-				info->idle_stats.recv_bytes += small_count;
-				tty->flip.count += small_count;
+				char_count -= len;
+				info->icount.rx += len;
+				info->idle_stats.recv_bytes += len;
 			}
 #else
 			len = tty_buffer_request_room(tty, char_count);
