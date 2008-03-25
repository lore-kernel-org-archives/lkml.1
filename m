Return-Path: <linux-kernel-owner+w=401wt.eu-S1762330AbYCYVnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762330AbYCYVnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760802AbYCYVi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:38:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760801AbYCYViz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:38:55 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: [PATCH 13/20] x86: move dma_map_page and dma_unmap_page to common header
Date: Tue, 25 Mar 2008 18:36:32 -0300
Message-Id: <1206480999-21767-14-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
In-Reply-To: <1206480999-21767-13-git-send-email-gcosta@redhat.com>
References: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
 <1206480999-21767-2-git-send-email-gcosta@redhat.com>
 <1206480999-21767-3-git-send-email-gcosta@redhat.com>
 <1206480999-21767-4-git-send-email-gcosta@redhat.com>
 <1206480999-21767-5-git-send-email-gcosta@redhat.com>
 <1206480999-21767-6-git-send-email-gcosta@redhat.com>
 <1206480999-21767-7-git-send-email-gcosta@redhat.com>
 <1206480999-21767-8-git-send-email-gcosta@redhat.com>
 <1206480999-21767-9-git-send-email-gcosta@redhat.com>
 <1206480999-21767-10-git-send-email-gcosta@redhat.com>
 <1206480999-21767-11-git-send-email-gcosta@redhat.com>
 <1206480999-21767-12-git-send-email-gcosta@redhat.com>
 <1206480999-21767-13-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are similar enough to do this move.
the macro version is ugly, and we use inline functions instead

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/dma-mapping.h    |   14 ++++++++++++++
 include/asm-x86/dma-mapping_32.h |   15 ---------------
 include/asm-x86/dma-mapping_64.h |    4 ----
 3 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 3ea3802..b5a413a 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -169,4 +169,18 @@ dma_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
 
 	flush_write_buffers();
 }
+
+static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
+				      size_t offset, size_t size,
+				      int direction)
+{
+	return dma_map_single(dev, page_address(page)+offset, size, direction);
+}
+
+static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
+				  size_t size, int direction)
+{
+	dma_unmap_single(dev, addr, size, direction);
+}
+
 #endif
diff --git a/include/asm-x86/dma-mapping_32.h b/include/asm-x86/dma-mapping_32.h
index d8f6420..c61ae7f 100644
--- a/include/asm-x86/dma-mapping_32.h
+++ b/include/asm-x86/dma-mapping_32.h
@@ -8,21 +8,6 @@
 #include <asm/io.h>
 #include <asm/bug.h>
 
-static inline dma_addr_t
-dma_map_page(struct device *dev, struct page *page, unsigned long offset,
-	     size_t size, enum dma_data_direction direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-	return page_to_phys(page) + offset;
-}
-
-static inline void
-dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-	       enum dma_data_direction direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-}
-
 static inline int
 dma_mapping_error(dma_addr_t dma_addr)
 {
diff --git a/include/asm-x86/dma-mapping_64.h b/include/asm-x86/dma-mapping_64.h
index ce881d9..2b4a430 100644
--- a/include/asm-x86/dma-mapping_64.h
+++ b/include/asm-x86/dma-mapping_64.h
@@ -12,10 +12,6 @@ static inline int dma_mapping_error(dma_addr_t dma_addr)
 	return (dma_addr == bad_dma_address);
 }
 
-#define dma_map_page(dev,page,offset,size,dir) \
-	dma_map_single((dev), page_address(page)+(offset), (size), (dir))
-
-#define dma_unmap_page dma_unmap_single
 extern int dma_supported(struct device *hwdev, u64 mask);
 
 /* same for gart, swiotlb, and nommu */
-- 
1.5.0.6

