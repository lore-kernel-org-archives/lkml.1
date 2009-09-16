Return-Path: <linux-kernel-owner+w=401wt.eu-S1760630AbZIPXiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630AbZIPXiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760577AbZIPXio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:38:44 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45255 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416AbZIPXin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:38:43 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Bryan Wu <cooloney@kernel.org>, Cliff Cai <cliff.cai@analog.com>
Subject: [PATCH 01/11] USB: musb: tweak musb_read_fifo() to avoid unused warnings
Date: Wed, 16 Sep 2009 19:38:35 -0400
Message-Id: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise gcc will whine about epnum/dma_reg being unused when building
for BF54x parts.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Cliff Cai <cliff.cai@analog.com>
---
 drivers/usb/musb/blackfin.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index f2f66eb..80c765e 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -54,13 +54,11 @@ void musb_write_fifo(struct musb_hw_ep *hw_ep, u16 len, const u8 *src)
 void musb_read_fifo(struct musb_hw_ep *hw_ep, u16 len, u8 *dst)
 {
 	void __iomem *fifo = hw_ep->fifo;
+
+#ifdef CONFIG_BF52x
 	u8 epnum = hw_ep->epnum;
 	u16 dma_reg = 0;
 
-	DBG(4, "%cX ep%d fifo %p count %d buf %p\n",
-			'R', hw_ep->epnum, fifo, len, dst);
-
-#ifdef CONFIG_BF52x
 	invalidate_dcache_range((unsigned int)dst,
 		(unsigned int)(dst + len));
 
@@ -103,6 +101,9 @@ void musb_read_fifo(struct musb_hw_ep *hw_ep, u16 len, u8 *dst)
 			len & 0x01 ? (len >> 1) + 1 : len >> 1);
 #endif
 
+	DBG(4, "%cX ep%d fifo %p count %d buf %p\n",
+			'R', hw_ep->epnum, fifo, len, dst);
+
 	dump_fifo_data(dst, len);
 }
 
-- 
1.6.5.rc1

