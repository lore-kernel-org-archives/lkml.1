Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbZASOwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbZASOwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:52:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbZASOr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:47:27 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:3510 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbZASOrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:47:22 -0500
X-BigFish: VPS-2(zz18c1Kzzzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KDQ3QF-01-ARR-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, linux-kernel@vger.kernel.org
CC: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/16] dma-debug: add add checking for map/unmap_sg
Date: Mon, 19 Jan 2009 15:46:57 +0100
Message-ID: <1232376423-11067-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jan 2009 14:47:04.0016 (UTC) FILETIME=[CB131500:01C97A44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add debug callbacks for dma_{un}map_sg

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/dma-debug.h |   15 ++++++++++++
 lib/dma-debug.c           |   53 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index ea6a283..61f559d 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -36,6 +36,11 @@ extern void debug_dma_map_page(struct device *dev, struct page *page,
 extern void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
 				 size_t size, int direction, bool map_single);
 
+extern void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
+			     int nents, int direction);
+
+extern void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
+			       int nelems, int dir);
 
 #else /* CONFIG_DMA_API_DEBUG */
 
@@ -56,6 +61,16 @@ static inline void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
 {
 }
 
+static inline void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
+				    int nents, int direction)
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
index 9219c41..f3e0145 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -17,6 +17,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
+#include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
 #include <linux/dma-debug.h>
 #include <linux/spinlock.h>
@@ -576,3 +577,55 @@ void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
 }
 EXPORT_SYMBOL(debug_dma_unmap_page);
 
+void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
+		      int nents, int direction)
+{
+	struct dma_debug_entry *entry;
+	struct scatterlist *s;
+	int i;
+
+	if (unlikely(global_disable))
+		return;
+
+	for_each_sg(sg, s, nents, i) {
+		entry = dma_entry_alloc();
+		if (!entry)
+			return;
+
+		entry->type      = dma_debug_sg;
+		entry->dev       = dev;
+		entry->paddr     = sg_phys(s);
+		entry->size      = s->length;
+		entry->dev_addr  = s->dma_address;
+		entry->direction = direction;
+
+		add_dma_entry(entry);
+	}
+}
+EXPORT_SYMBOL(debug_dma_map_sg);
+
+void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
+			int nelems, int dir)
+{
+	struct scatterlist *s;
+	int i;
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
+		};
+
+		check_unmap(&ref);
+	}
+}
+EXPORT_SYMBOL(debug_dma_unmap_sg);
+
-- 
1.5.6.4


