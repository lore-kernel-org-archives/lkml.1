Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbYKTPxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbYKTPxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbYKTPvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:51:09 -0500
Received: from mail07.svc.cra.dublin.eircom.net ([159.134.118.23]:44903 "HELO
	mail07.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754973AbYKTPvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:51:01 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       x86@kernel.org, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 3/8] intel-iommu: move context entry defs out from dma_remapping.h
Date: Thu, 20 Nov 2008 15:49:45 +0000
Message-Id: <1227196190-488-3-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1227196190-488-2-git-send-email-markmc@redhat.com>
References: <1227191861.4901.24.camel@macbook.infradead.org>
 <1227196190-488-1-git-send-email-markmc@redhat.com>
 <1227196190-488-2-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/pci/intel-iommu.c     |   38 ++++++++++++++++++++++++++++++++++++++
 include/linux/dma_remapping.h |   38 --------------------------------------
 2 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 2e56e5a..1c011bb 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -90,6 +90,44 @@ get_context_addr_from_root(struct root_entry *root)
 		NULL);
 }
 
+/*
+ * low 64 bits:
+ * 0: present
+ * 1: fault processing disable
+ * 2-3: translation type
+ * 12-63: address space root
+ * high 64 bits:
+ * 0-2: address width
+ * 3-6: aval
+ * 8-23: domain id
+ */
+struct context_entry {
+	u64 lo;
+	u64 hi;
+};
+#define context_present(c) ((c).lo & 1)
+#define context_fault_disable(c) (((c).lo >> 1) & 1)
+#define context_translation_type(c) (((c).lo >> 2) & 3)
+#define context_address_root(c) ((c).lo & VTD_PAGE_MASK)
+#define context_address_width(c) ((c).hi &  7)
+#define context_domain_id(c) (((c).hi >> 8) & ((1 << 16) - 1))
+
+#define context_set_present(c) do {(c).lo |= 1;} while (0)
+#define context_set_fault_enable(c) \
+	do {(c).lo &= (((u64)-1) << 2) | 1;} while (0)
+#define context_set_translation_type(c, val) \
+	do { \
+		(c).lo &= (((u64)-1) << 4) | 3; \
+		(c).lo |= ((val) & 3) << 2; \
+	} while (0)
+#define CONTEXT_TT_MULTI_LEVEL 0
+#define context_set_address_root(c, val) \
+	do {(c).lo |= (val) & VTD_PAGE_MASK; } while (0)
+#define context_set_address_width(c, val) do {(c).hi |= (val) & 7;} while (0)
+#define context_set_domain_id(c, val) \
+	do {(c).hi |= ((val) & ((1 << 16) - 1)) << 8;} while (0)
+#define context_clear_entry(c) do {(c).lo = 0; (c).hi = 0;} while (0)
+
 static void flush_unmaps_timeout(unsigned long data);
 
 DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
index d852166..9a88f7d 100644
--- a/include/linux/dma_remapping.h
+++ b/include/linux/dma_remapping.h
@@ -12,44 +12,6 @@
 struct root_entry;
 
 /*
- * low 64 bits:
- * 0: present
- * 1: fault processing disable
- * 2-3: translation type
- * 12-63: address space root
- * high 64 bits:
- * 0-2: address width
- * 3-6: aval
- * 8-23: domain id
- */
-struct context_entry {
-	u64 lo;
-	u64 hi;
-};
-#define context_present(c) ((c).lo & 1)
-#define context_fault_disable(c) (((c).lo >> 1) & 1)
-#define context_translation_type(c) (((c).lo >> 2) & 3)
-#define context_address_root(c) ((c).lo & VTD_PAGE_MASK)
-#define context_address_width(c) ((c).hi &  7)
-#define context_domain_id(c) (((c).hi >> 8) & ((1 << 16) - 1))
-
-#define context_set_present(c) do {(c).lo |= 1;} while (0)
-#define context_set_fault_enable(c) \
-	do {(c).lo &= (((u64)-1) << 2) | 1;} while (0)
-#define context_set_translation_type(c, val) \
-	do { \
-		(c).lo &= (((u64)-1) << 4) | 3; \
-		(c).lo |= ((val) & 3) << 2; \
-	} while (0)
-#define CONTEXT_TT_MULTI_LEVEL 0
-#define context_set_address_root(c, val) \
-	do {(c).lo |= (val) & VTD_PAGE_MASK; } while (0)
-#define context_set_address_width(c, val) do {(c).hi |= (val) & 7;} while (0)
-#define context_set_domain_id(c, val) \
-	do {(c).hi |= ((val) & ((1 << 16) - 1)) << 8;} while (0)
-#define context_clear_entry(c) do {(c).lo = 0; (c).hi = 0;} while (0)
-
-/*
  * 0: readable
  * 1: writable
  * 2-6: reserved
-- 
1.5.4.3

