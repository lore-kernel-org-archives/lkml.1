Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbZBLKRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbZBLKRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbZBLKPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:15:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41548
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758480AbZBLKPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:15:50 -0500
Date: Thu, 12 Feb 2009 02:15:44 -0800 (PST)
Message-Id: <20090212.021544.54334542.davem@davemloft.net>
To: airlied@linux.ie
CC: benh@kernel.crashing.org, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/5]: drm: radeon: Fix calculation of RB_RPTR_ADDR in
 non-AGP case.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The address needs to be a GART relative address, rather than a PCI
DMA address.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/gpu/drm/radeon/radeon_cp.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_cp.c b/drivers/gpu/drm/radeon/radeon_cp.c
index 9053755..e235778 100644
--- a/drivers/gpu/drm/radeon/radeon_cp.c
+++ b/drivers/gpu/drm/radeon/radeon_cp.c
@@ -655,17 +655,10 @@ static void radeon_cp_init_ring_buffer(struct drm_device * dev,
 	} else
 #endif
 	{
-		struct drm_sg_mem *entry = dev->sg;
-		unsigned long tmp_ofs, page_ofs;
-
-		tmp_ofs = dev_priv->ring_rptr->offset -
-				(unsigned long)dev->sg->virtual;
-		page_ofs = tmp_ofs >> PAGE_SHIFT;
-
-		RADEON_WRITE(RADEON_CP_RB_RPTR_ADDR, entry->busaddr[page_ofs]);
-		DRM_DEBUG("ring rptr: offset=0x%08lx handle=0x%08lx\n",
-			  (unsigned long)entry->busaddr[page_ofs],
-			  entry->handle + tmp_ofs);
+		RADEON_WRITE(RADEON_CP_RB_RPTR_ADDR,
+			     dev_priv->ring_rptr->offset
+			     - ((unsigned long) dev->sg->virtual)
+			     + dev_priv->gart_vm_start);
 	}
 
 	/* Set ring buffer size */
-- 
1.6.1.2.350.g88cc

