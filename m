Return-Path: <linux-kernel-owner+w=401wt.eu-S1761805AbYEAOqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761805AbYEAOqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 10:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760995AbYEAOp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 10:45:28 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:51823 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbYEAOp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 10:45:26 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       John Linville <linville@tuxdriver.com>
Subject: [PATCH 2/3] ssb: Add weak DMA-mask API
Date: Thu, 1 May 2008 16:41:27 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <200805011638.15910.mb@bu3sch.de>
In-Reply-To: <200805011638.15910.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011641.28135.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a "weak" variant of ssb_dma_set_mask().

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: linux-2.6/drivers/ssb/main.c
===================================================================
--- linux-2.6.orig/drivers/ssb/main.c	2008-05-01 13:19:53.000000000 +0200
+++ linux-2.6/drivers/ssb/main.c	2008-05-01 13:47:29.000000000 +0200
@@ -1165,6 +1165,12 @@ u32 ssb_dma_translation(struct ssb_devic
 }
 EXPORT_SYMBOL(ssb_dma_translation);
 
+static void do_set_dma_mask(struct device *dma_dev, u64 mask)
+{
+	dma_dev->coherent_dma_mask = mask;
+	dma_dev->dma_mask = &dma_dev->coherent_dma_mask;
+}
+
 int ssb_dma_set_mask(struct ssb_device *ssb_dev, u64 mask)
 {
 	struct device *dma_dev = ssb_dev->dma_dev;
@@ -1173,13 +1179,26 @@ int ssb_dma_set_mask(struct ssb_device *
 	if (ssb_dev->bus->bustype == SSB_BUSTYPE_PCI)
 		return dma_set_mask(dma_dev, mask);
 #endif
-	dma_dev->coherent_dma_mask = mask;
-	dma_dev->dma_mask = &dma_dev->coherent_dma_mask;
+	do_set_dma_mask(dma_dev, mask);
 
 	return 0;
 }
 EXPORT_SYMBOL(ssb_dma_set_mask);
 
+int ssb_dma_set_mask_weak(struct ssb_device *ssb_dev, u64 *mask)
+{
+	struct device *dma_dev = ssb_dev->dma_dev;
+
+#ifdef CONFIG_SSB_PCIHOST
+	if (ssb_dev->bus->bustype == SSB_BUSTYPE_PCI)
+		return dma_set_mask_weak(dma_dev, mask);
+#endif
+	do_set_dma_mask(dma_dev, *mask);
+
+	return 0;
+}
+EXPORT_SYMBOL(ssb_dma_set_mask_weak);
+
 int ssb_bus_may_powerdown(struct ssb_bus *bus)
 {
 	struct ssb_chipcommon *cc;
Index: linux-2.6/include/linux/ssb/ssb.h
===================================================================
--- linux-2.6.orig/include/linux/ssb/ssb.h	2008-05-01 13:19:59.000000000 +0200
+++ linux-2.6/include/linux/ssb/ssb.h	2008-05-01 13:43:17.000000000 +0200
@@ -406,6 +406,7 @@ extern u32 ssb_dma_translation(struct ss
 #define SSB_DMA_TRANSLATION_SHIFT	30
 
 extern int ssb_dma_set_mask(struct ssb_device *ssb_dev, u64 mask);
+extern int ssb_dma_set_mask_weak(struct ssb_device *ssb_dev, u64 *mask);
 
 
 #ifdef CONFIG_SSB_PCIHOST

-- 
Greetings Michael.
