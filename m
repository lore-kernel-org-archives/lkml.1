Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZAIQWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZAIQWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZAIQUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:20:11 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:47695 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbZAIQUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:20:09 -0500
X-BigFish: VPS0(zz18c1Kzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KD7PCJ-03-IX4-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: mingo@redhat.com, dwmw2@infradead.org, fujita.tomonori@lab.ntt.co.jp,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/16] dma-debug: add add checking for map/unmap_sg
Date: Fri, 9 Jan 2009 17:19:24 +0100
Message-ID: <1231517970-20288-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Jan 2009 16:19:30.0810 (UTC) FILETIME=[0D172DA0:01C97276]
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
index 82ae9ca..b2131f4 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -34,6 +34,11 @@ extern void debug_map_single(struct device *dev, void *ptr, size_t size,
 extern void debug_unmap_single(struct device *dev, dma_addr_t addr,
 			       size_t size, int direction);
 
+extern void debug_map_sg(struct device *dev, struct scatterlist *sg,
+			 int nents, int direction);
+
+extern void debug_unmap_sg(struct device *dev, struct scatterlist *sglist,
+			   int nelems, int dir);
 
 #else /* CONFIG_DMA_API_DEBUG */
 
@@ -52,6 +57,16 @@ static inline void debug_unmap_single(struct device *dev, dma_addr_t addr,
 {
 }
 
+static inline void debug_map_sg(struct device *dev, struct scatterlist *sg,
+				int nents, int direction)
+{
+}
+
+static inline void debug_unmap_sg(struct device *dev,
+				  struct scatterlist *sglist,
+				  int nelems, int dir)
+{
+}
 
 #endif /* CONFIG_DMA_API_DEBUG */
 
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index d4d14e5..e6d45f9 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -17,6 +17,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
+#include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
 #include <linux/dma-debug.h>
 #include <linux/spinlock.h>
@@ -551,3 +552,55 @@ void debug_unmap_single(struct device *dev, dma_addr_t addr,
 }
 EXPORT_SYMBOL(debug_unmap_single);
 
+void debug_map_sg(struct device *dev, struct scatterlist *sg,
+		  int nents, int direction)
+{
+	struct dma_debug_entry *entry;
+	struct scatterlist *s;
+	int i;
+
+	if (global_disable)
+		return;
+
+	for_each_sg(sg, s, nents, i) {
+		entry = dma_entry_alloc();
+		if (!entry)
+			return;
+
+		entry->type      = dma_debug_sg;
+		entry->dev       = dev;
+		entry->cpu_addr  = sg_virt(s);
+		entry->size      = s->length;
+		entry->dev_addr  = s->dma_address;
+		entry->direction = direction;
+
+		add_dma_entry(entry);
+	}
+}
+EXPORT_SYMBOL(debug_map_sg);
+
+void debug_unmap_sg(struct device *dev, struct scatterlist *sglist,
+		    int nelems, int dir)
+{
+	struct scatterlist *s;
+	int i;
+
+	if (global_disable)
+		return;
+
+	for_each_sg(sglist, s, nelems, i) {
+
+		struct dma_debug_entry ref = {
+			.type           = dma_debug_sg,
+			.dev            = dev,
+			.cpu_addr       = sg_virt(s),
+			.dev_addr       = s->dma_address,
+			.size           = s->length,
+			.direction      = dir,
+		};
+
+		check_unmap(&ref);
+	}
+}
+EXPORT_SYMBOL(debug_unmap_sg);
+
-- 
1.5.6.4


