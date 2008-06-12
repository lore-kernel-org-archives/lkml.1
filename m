Return-Path: <linux-kernel-owner+w=401wt.eu-S1761969AbYFLNge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761969AbYFLNge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759280AbYFLNgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:36:23 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:46197 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757769AbYFLNgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:36:22 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Fix coherent DMA mask for PCI devices
Date: Thu, 12 Jun 2008 15:33:13 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Glauber Costa <gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121533.14435.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes setting the coherent DMA mask for PCI devices.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue this bugfix for 2.6.26

The whole SSB DMA API should be rewritten, as it makes too many bad
assumptions about the other subsytems. I will do that soon.
But let's apply this patch for now, as it fixes this particular bug.


Index: wireless-testing/drivers/ssb/main.c
===================================================================
--- wireless-testing.orig/drivers/ssb/main.c	2008-05-17 18:44:32.000000000 +0200
+++ wireless-testing/drivers/ssb/main.c	2008-06-12 15:24:04.000000000 +0200
@@ -1165,21 +1165,27 @@ u32 ssb_dma_translation(struct ssb_devic
 }
 EXPORT_SYMBOL(ssb_dma_translation);
 
 int ssb_dma_set_mask(struct ssb_device *ssb_dev, u64 mask)
 {
 	struct device *dma_dev = ssb_dev->dma_dev;
+	int err = 0;
 
 #ifdef CONFIG_SSB_PCIHOST
-	if (ssb_dev->bus->bustype == SSB_BUSTYPE_PCI)
-		return dma_set_mask(dma_dev, mask);
+	if (ssb_dev->bus->bustype == SSB_BUSTYPE_PCI) {
+		err = pci_set_dma_mask(ssb_dev->bus->host_pci, mask);
+		if (err)
+			return err;
+		err = pci_set_consistent_dma_mask(ssb_dev->bus->host_pci, mask);
+		return err;
+	}
 #endif
 	dma_dev->coherent_dma_mask = mask;
 	dma_dev->dma_mask = &dma_dev->coherent_dma_mask;
 
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL(ssb_dma_set_mask);
 
 int ssb_bus_may_powerdown(struct ssb_bus *bus)
 {
 	struct ssb_chipcommon *cc;
