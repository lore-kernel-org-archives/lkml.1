Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbZCFNgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbZCFNgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbZCFNbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:31:07 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:25865 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbZCFNa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:30:56 -0500
X-BigFish: VPS-2(zz18c1Kzzzzz32i61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KG36UW-01-JL1-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/18] dma-debug: add add checking for map/unmap_sg
Date: Fri, 6 Mar 2009 14:30:21 +0100
Message-ID: <1236346229-6618-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 06 Mar 2009 13:30:30.0323 (UTC) FILETIME=[B805A830:01C99E5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add debug callbacks for dma_{un}map_sg

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/dma-debug.h |   16 ++++++++++
 lib/dma-debug.c           |   73 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index 65f7352..ee9fdb3 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -23,6 +23,7 @@
 #include <linux/types.h>
 
 struct device;
+struct scatterlist;
 
 #ifdef CONFIG_DMA_API_DEBUG
 
@@ -36,6 +37,11 @@ extern void debug_dma_map_page(struct device *dev, struct page *page,
 extern void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
 				 size_t size, int direction, bool map_single);
 
+extern void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
+			     int nents, int mapped_ents, int direction);
+
+extern void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
+			       int nelems, int dir);
 
 #else /* CONFIG_DMA_API_DEBUG */
 
@@ -56,6 +62,16 @@ static inline void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
 {
 }
 
+static inline void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
+				    int nents, int mapped_ents, int direction)
+{
+}
+
+static inline void debug_dma_unmap_sg(struct device *dev,
+				      struct scatterlist *sglist,
+				      int nelems, int dir)
+{
+}
 
 #endif /* CONFIG_DMA_API_DEBUG */
 
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index a2ed2b7..26e40e9 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -17,6 +17,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
+#include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
 #include <linux/dma-debug.h>
 #include <linux/spinlock.h>
@@ -619,3 +620,75 @@ void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
 }
 EXPORT_SYMBOL(debug_dma_unmap_page);
 
+void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
+		      int nents, int mapped_ents, int direction)
+{
+	struct dma_debug_entry *entry;
+	struct scatterlist *s;
+	int i;
+
+	if (unlikely(global_disable))
+		return;
+
+	for_each_sg(sg, s, mapped_ents, i) {
+		entry = dma_entry_alloc();
+		if (!entry)
+			return;
+
+		entry->type           = dma_debug_sg;
+		entry->dev            = dev;
+		entry->paddr          = sg_phys(s);
+		entry->size           = s->length;
+		entry->dev_addr       = s->dma_address;
+		entry->direction      = direction;
+		entry->sg_call_ents   = nents;
+		entry->sg_mapped_ents = mapped_ents;
+
+		check_for_stack(dev, sg_virt(s));
+
+		add_dma_entry(entry);
+	}
+}
+EXPORT_SYMBOL(debug_dma_map_sg);
+
+void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
+			int nelems, int dir)
+{
+	struct dma_debug_entry *entry;
+	struct scatterlist *s;
+	int mapped_ents = 0, i;
+	unsigned long flags;
+
+	if (unlikely(global_disable))
+		return;
+
+	for_each_sg(sglist, s, nelems, i) {
+
+		struct dma_debug_entry ref = {
+			.type           = dma_debug_sg,
+			.dev            = dev,
+			.paddr          = sg_phys(s),
+			.dev_addr       = s->dma_address,
+			.size           = s->length,
+			.direction      = dir,
+			.sg_call_ents   = 0,
+		};
+
+		if (mapped_ents && i >= mapped_ents)
+			break;
+
+		if (mapped_ents == 0) {
+			struct hash_bucket *bucket;
+			ref.sg_call_ents = nelems;
+			bucket = get_hash_bucket(&ref, &flags);
+			entry = hash_bucket_find(bucket, &ref);
+			if (entry)
+				mapped_ents = entry->sg_mapped_ents;
+			put_hash_bucket(bucket, &flags);
+		}
+
+		check_unmap(&ref);
+	}
+}
+EXPORT_SYMBOL(debug_dma_unmap_sg);
+
-- 
1.5.6.4


