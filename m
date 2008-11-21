Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbYKUQ1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbYKUQ1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbYKUQ0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:26:33 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:2944 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468AbYKUQ0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:26:30 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KAOYZM-04-Y1H-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/10] x86: add check code for map/unmap_single code
Date: Fri, 21 Nov 2008 17:26:05 +0100
Message-ID: <1227284770-19215-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 21 Nov 2008 16:26:10.0584 (UTC) FILETIME=[DD221980:01C94BF5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: detect bugs in map/unmap_single usage

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/dma-mapping.h |    9 +++++-
 arch/x86/include/asm/dma_debug.h   |   20 +++++++++++++
 arch/x86/kernel/pci-dma-debug.c    |   55 ++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 83d7b7d..c9bead2 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -98,9 +98,14 @@ dma_map_single(struct device *hwdev, void *ptr, size_t size,
 	       int direction)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+	dma_addr_t addr;
 
 	BUG_ON(!valid_dma_direction(direction));
-	return ops->map_single(hwdev, virt_to_phys(ptr), size, direction);
+	addr = ops->map_single(hwdev, virt_to_phys(ptr), size, direction);
+
+	debug_map_single(hwdev, ptr, size, direction, addr);
+
+	return addr;
 }
 
 static inline void
@@ -112,6 +117,8 @@ dma_unmap_single(struct device *dev, dma_addr_t addr, size_t size,
 	BUG_ON(!valid_dma_direction(direction));
 	if (ops->unmap_single)
 		ops->unmap_single(dev, addr, size, direction);
+
+	debug_unmap_single(dev, addr, size, direction);
 }
 
 static inline int
diff --git a/arch/x86/include/asm/dma_debug.h b/arch/x86/include/asm/dma_debug.h
index f2c3d53..ba4d9b7 100644
--- a/arch/x86/include/asm/dma_debug.h
+++ b/arch/x86/include/asm/dma_debug.h
@@ -43,6 +43,14 @@ struct dma_debug_entry {
 extern
 void dma_debug_init(void);
 
+extern
+void debug_map_single(struct device *dev, void *ptr, size_t size,
+		      int direction, dma_addr_t dma_addr);
+
+extern
+void debug_unmap_single(struct device *dev, dma_addr_t addr,
+			size_t size, int direction);
+
 #else /* CONFIG_DMA_API_DEBUG */
 
 static inline
@@ -50,6 +58,18 @@ void dma_debug_init(void)
 {
 }
 
+static inline
+void debug_map_single(struct device *dev, void *ptr, size_t size,
+		      int direction, dma_addr_t dma_addr)
+{
+}
+
+static inline
+void debug_unmap_single(struct device *dev, dma_addr_t addr,
+			size_t size, int direction)
+{
+}
+
 #endif /* CONFIG_DMA_API_DEBUG */
 
 #endif /* __ASM_X86_DMA_DEBUG */
diff --git a/arch/x86/kernel/pci-dma-debug.c b/arch/x86/kernel/pci-dma-debug.c
index fc95631..9afb6c8 100644
--- a/arch/x86/kernel/pci-dma-debug.c
+++ b/arch/x86/kernel/pci-dma-debug.c
@@ -234,3 +234,58 @@ void dma_debug_init(void)
 	printk(KERN_INFO "PCI-DMA: DMA API debugging enabled by kernel config\n");
 }
 
+void debug_map_single(struct device *dev, void *ptr, size_t size,
+		      int direction, dma_addr_t dma_addr)
+{
+	unsigned long flags;
+	struct dma_debug_entry *entry;
+
+	if (dma_addr == bad_dma_address)
+		return;
+
+	entry = dma_entry_alloc();
+	if (!entry)
+		return;
+
+	entry->dev = dev;
+	entry->type = DMA_DEBUG_SINGLE;
+	entry->cpu_addr = ptr;
+	entry->dev_addr = dma_addr;
+	entry->size = size;
+	entry->direction = direction;
+
+	spin_lock_irqsave(&dma_lock, flags);
+	add_dma_entry(entry);
+	spin_unlock_irqrestore(&dma_lock, flags);
+}
+EXPORT_SYMBOL(debug_map_single);
+
+void debug_unmap_single(struct device *dev, dma_addr_t addr,
+			size_t size, int direction)
+{
+	unsigned long flags;
+	struct dma_debug_entry ref = {
+		.type = DMA_DEBUG_SINGLE,
+		.dev = dev,
+		.dev_addr = addr,
+		.size = size,
+		.direction = direction,
+	};
+	struct dma_debug_entry *entry;
+
+	if (addr == bad_dma_address)
+		return;
+
+	spin_lock_irqsave(&dma_lock, flags);
+
+	entry = find_dma_entry(&ref);
+
+	if (check_unmap(&ref, entry)) {
+		remove_dma_entry(entry);
+		dma_entry_free(entry);
+	}
+
+	spin_unlock_irqrestore(&dma_lock, flags);
+}
+EXPORT_SYMBOL(debug_unmap_single);
+
-- 
1.5.6.4


