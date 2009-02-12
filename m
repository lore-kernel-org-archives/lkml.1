Return-Path: <linux-kernel-owner+w=401wt.eu-S1758439AbZBLKQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439AbZBLKQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758347AbZBLKPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:15:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41532
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758323AbZBLKPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:15:40 -0500
Date: Thu, 12 Feb 2009 02:15:34 -0800 (PST)
Message-Id: <20090212.021534.233341037.davem@davemloft.net>
To: airlied@linux.ie
CC: benh@kernel.crashing.org, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/5]: drm: ati_pcigart: Need to use PCI_DMA_BIDIRECTIONAL.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The buffers mapped by the PCI GART can be written to by the device,
not just read.

For example, this happens via the RB_RPTR writeback on Radeon.

So we can't use PCI_DMA_TODEVICE else we'll get protection faults
on IOMMU platforms.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/gpu/drm/ati_pcigart.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ati_pcigart.c b/drivers/gpu/drm/ati_pcigart.c
index 2cd827a..7972ec8 100644
--- a/drivers/gpu/drm/ati_pcigart.c
+++ b/drivers/gpu/drm/ati_pcigart.c
@@ -77,7 +77,7 @@ int drm_ati_pcigart_cleanup(struct drm_device *dev, struct drm_ati_pcigart_info
 			if (!entry->busaddr[i])
 				break;
 			pci_unmap_page(dev->pdev, entry->busaddr[i],
-					 PAGE_SIZE, PCI_DMA_TODEVICE);
+					 PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
 		}
 
 		if (gart_info->gart_table_location == DRM_ATI_GART_MAIN)
@@ -145,7 +145,7 @@ int drm_ati_pcigart_init(struct drm_device *dev, struct drm_ati_pcigart_info *ga
 	for (i = 0; i < pages; i++) {
 		/* we need to support large memory configurations */
 		entry->busaddr[i] = pci_map_page(dev->pdev, entry->pagelist[i],
-						 0, PAGE_SIZE, PCI_DMA_TODEVICE);
+						 0, PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
 		if (entry->busaddr[i] == 0) {
 			DRM_ERROR("unable to map PCIGART pages!\n");
 			drm_ati_pcigart_cleanup(dev, gart_info);
-- 
1.6.1.2.350.g88cc

