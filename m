Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYEAOqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYEAOqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 10:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbYEAOpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 10:45:17 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:51802 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941AbYEAOpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 10:45:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       John Linville <linville@tuxdriver.com>
Subject: [PATCH 1/3] Add dma_set_mask_weak() API
Date: Thu, 1 May 2008 16:40:16 +0200
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
Message-Id: <200805011640.17281.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a new DMA subsystem API call for "weak" setting
of the DMA mask.
Weak means that it will fallback to smaller masks in case the
DMA subsystem rejects a big mask.
Currently such rejection may happen if the driver requests a 64bit
mask on a VIA machine, for example. dma_set_mask_weak() will fallback
to 32bit, in that case, and tell the caller about it by modifying the
passed mask.

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: wireless-testing/drivers/base/dma-mapping.c
===================================================================
--- wireless-testing.orig/drivers/base/dma-mapping.c	2008-04-28 23:34:19.000000000 +0200
+++ wireless-testing/drivers/base/dma-mapping.c	2008-04-28 23:46:25.000000000 +0200
@@ -216,3 +216,38 @@ void dmam_release_declared_memory(struct
 EXPORT_SYMBOL(dmam_release_declared_memory);
 
 #endif
+
+/**
+ * dma_set_mask_weak - Set the DMA mask. Retry with smaller masks.
+ * @dev: Device to set the mask on.
+ * @mask: Pointer to the mask that you want to set. The function will
+ * 	modify the mask and set it to the actually used mask, in case
+ * 	it had to fall back to a smaller mask.
+ *
+ * Set the DMA mask and allow falling back to smaller masks in
+ * case of an error.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+int dma_set_mask_weak(struct device *dev, u64 *mask)
+{
+	u64 m = *mask;
+	int err;
+
+	if (m < DMA_MIN_FALLBACK_MASK)
+		return -EINVAL;
+	while (1) {
+		err = dma_set_mask(dev, m);
+		if (!err)
+			break;
+		/* Did not like this one. Try a smaller one. */
+		m >>= 1;
+		if (m < DMA_MIN_FALLBACK_MASK)
+			return err;
+	}
+	*mask = m;
+
+	return 0;
+}
+EXPORT_SYMBOL(dma_set_mask_weak);
Index: wireless-testing/include/linux/dma-mapping.h
===================================================================
--- wireless-testing.orig/include/linux/dma-mapping.h	2008-04-28 23:34:19.000000000 +0200
+++ wireless-testing/include/linux/dma-mapping.h	2008-04-28 23:35:35.000000000 +0200
@@ -60,6 +60,11 @@ static inline int is_device_dma_capable(
 
 extern u64 dma_get_required_mask(struct device *dev);
 
+extern int dma_set_mask_weak(struct device *dev, u64 *mask);
+/* Smallest mask fallback used by dma_set_mask_weak(). */
+#define DMA_MIN_FALLBACK_MASK	DMA_BIT_MASK(24) /* 16 MB */
+
+
 static inline unsigned int dma_get_max_seg_size(struct device *dev)
 {
 	return dev->dma_parms ? dev->dma_parms->max_segment_size : 65536;


-- 
Greetings Michael.
