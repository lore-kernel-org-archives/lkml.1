Return-Path: <linux-kernel-owner+w=401wt.eu-S1758325AbYGRP2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325AbYGRP2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbYGRP20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:28:26 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:44165
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbYGRP2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:28:25 -0400
Subject: [PATCH] synclink_gt fix locking in error path of rx enable
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 09:27:26 -0500
Message-Id: <1216391246.17213.3.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix locking in error path of rx_enable() introduced by
synclink_gt-add-rx-dma-buffer-fill-level-control patch.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>


--- a/drivers/char/synclink_gt.c	2008-07-18 09:14:41.000000000 -0500
+++ b/drivers/char/synclink_gt.c	2008-07-18 09:13:57.000000000 -0500
@@ -2700,8 +2700,10 @@ static int rx_enable(struct slgt_info *i
 	 */
 	rbuf_fill_level = ((unsigned int)enable) >> 16;
 	if (rbuf_fill_level) {
-		if ((rbuf_fill_level > DMABUFSIZE) || (rbuf_fill_level % 4))
+		if ((rbuf_fill_level > DMABUFSIZE) || (rbuf_fill_level % 4)) {
+			spin_unlock_irqrestore(&info->lock, flags);
 			return -EINVAL;
+		}
 		info->rbuf_fill_level = rbuf_fill_level;
 		rx_stop(info); /* restart receiver to use new fill level */
 	}


