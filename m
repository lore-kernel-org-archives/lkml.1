Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbZBNHB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbZBNHB4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 02:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbZBNHBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 02:01:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38085
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbZBNHBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 02:01:46 -0500
Date: Fri, 13 Feb 2009 23:01:40 -0800 (PST)
Message-Id: <20090213.230140.226960615.davem@davemloft.net>
To: airlied@linux.ie
CC: benh@kernel.crashing.org, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH]: drm: ati_pcigart: Fix limit check in
 drm_ati_pcigart_init().
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


drm: ati_pcigart: Fix limit check in drm_ati_pcigart_init().

The variable 'max_pages' is ambiguous.  There are two concepts
of "pages" being used in this function.

First, we have ATI GART pages which are always 4096 bytes.
Then, we have system pages which are of size PAGE_SIZE.

Eliminate the confusion by creating max_ati_pages and
max_real_pages.  Calculate and use them as appropriate.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/gpu/drm/ati_pcigart.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/ati_pcigart.c b/drivers/gpu/drm/ati_pcigart.c
index 7972ec8..4d86a62 100644
--- a/drivers/gpu/drm/ati_pcigart.c
+++ b/drivers/gpu/drm/ati_pcigart.c
@@ -102,7 +102,7 @@ int drm_ati_pcigart_init(struct drm_device *dev, struct drm_ati_pcigart_info *ga
 	u32 *pci_gart, page_base, gart_idx;
 	dma_addr_t bus_address = 0;
 	int i, j, ret = 0;
-	int max_pages;
+	int max_ati_pages, max_real_pages;
 
 	if (!entry) {
 		DRM_ERROR("no scatter/gather memory!\n");
@@ -130,14 +130,15 @@ int drm_ati_pcigart_init(struct drm_device *dev, struct drm_ati_pcigart_info *ga
 
 	pci_gart = (u32 *) address;
 
-	max_pages = (gart_info->table_size / sizeof(u32));
-	pages = (entry->pages <= max_pages)
-	    ? entry->pages : max_pages;
+	max_ati_pages = (gart_info->table_size / sizeof(u32));
+	max_real_pages = max_ati_pages / (PAGE_SIZE / ATI_PCIGART_PAGE_SIZE);
+	pages = (entry->pages <= max_real_pages)
+	    ? entry->pages : max_real_pages;
 
 	if (gart_info->gart_table_location == DRM_ATI_GART_MAIN) {
-		memset(pci_gart, 0, max_pages * sizeof(u32));
+		memset(pci_gart, 0, max_ati_pages * sizeof(u32));
 	} else {
-		for (gart_idx = 0; gart_idx < max_pages; gart_idx++)
+		for (gart_idx = 0; gart_idx < max_ati_pages; gart_idx++)
 			DRM_WRITE32(map, gart_idx * sizeof(u32), 0);
 	}
 
-- 
1.6.1.2.350.g88cc

