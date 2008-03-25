Return-Path: <linux-kernel-owner+w=401wt.eu-S1762501AbYCYVoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501AbYCYVoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760819AbYCYVi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:38:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760815AbYCYVi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:38:58 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: [PATCH 15/20] x86: move dma_supported and dma_set_mask to pci-dma_32.c
Date: Tue, 25 Mar 2008 18:36:34 -0300
Message-Id: <1206480999-21767-16-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
In-Reply-To: <1206480999-21767-15-git-send-email-gcosta@redhat.com>
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
 <1206480999-21767-14-git-send-email-gcosta@redhat.com>
 <1206480999-21767-15-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the way x86_64 does, so this make them equal. They have
to be extern now in the header, and the extern definition is moved to
the common dma-mapping.h header

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma_32.c     |   33 +++++++++++++++++++++++++++++++++
 include/asm-x86/dma-mapping.h    |    3 +++
 include/asm-x86/dma-mapping_32.h |   29 -----------------------------
 include/asm-x86/dma-mapping_64.h |    4 ----
 4 files changed, 36 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index 5133032..453b4bd 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -156,6 +156,39 @@ EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
 int forbid_dac;
 EXPORT_SYMBOL(forbid_dac);
 
+int
+dma_supported(struct device *dev, u64 mask)
+{
+	/*
+	 * we fall back to GFP_DMA when the mask isn't all 1s,
+	 * so we can't guarantee allocations that must be
+	 * within a tighter range than GFP_DMA..
+	 */
+	if (mask < 0x00ffffff)
+		return 0;
+
+	/* Work around chipset bugs */
+	if (forbid_dac > 0 && mask > 0xffffffffULL)
+		return 0;
+
+	if (dma_ops->dma_supported)
+		return dma_ops->dma_supported(dev, mask);
+
+	return 1;
+}
+
+int
+dma_set_mask(struct device *dev, u64 mask)
+{
+	if (!dev->dma_mask || !dma_supported(dev, mask))
+		return -EIO;
+
+	*dev->dma_mask = mask;
+
+	return 0;
+}
+
+
 static __devinit void via_no_dac(struct pci_dev *dev)
 {
 	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 70a5ede..06eb448 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -62,6 +62,9 @@ void dma_free_coherent(struct device *dev, size_t size,
 			 void *vaddr, dma_addr_t dma_handle);
 
 
+extern int dma_supported(struct device *hwdev, u64 mask);
+extern int dma_set_mask(struct device *dev, u64 mask);
+
 #ifdef CONFIG_X86_32
 # include "dma-mapping_32.h"
 #else
diff --git a/include/asm-x86/dma-mapping_32.h b/include/asm-x86/dma-mapping_32.h
index e60c30a..fd7246d 100644
--- a/include/asm-x86/dma-mapping_32.h
+++ b/include/asm-x86/dma-mapping_32.h
@@ -17,35 +17,6 @@ dma_mapping_error(dma_addr_t dma_addr)
 extern int forbid_dac;
 
 static inline int
-dma_supported(struct device *dev, u64 mask)
-{
-        /*
-         * we fall back to GFP_DMA when the mask isn't all 1s,
-         * so we can't guarantee allocations that must be
-         * within a tighter range than GFP_DMA..
-         */
-        if(mask < 0x00ffffff)
-                return 0;
-
-	/* Work around chipset bugs */
-	if (forbid_dac > 0 && mask > 0xffffffffULL)
-		return 0;
-
-	return 1;
-}
-
-static inline int
-dma_set_mask(struct device *dev, u64 mask)
-{
-	if(!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-
-	return 0;
-}
-
-static inline int
 dma_get_cache_alignment(void)
 {
 	/* no easy way to get cache size on all x86, so return the
diff --git a/include/asm-x86/dma-mapping_64.h b/include/asm-x86/dma-mapping_64.h
index b1bc6ca..9674dac 100644
--- a/include/asm-x86/dma-mapping_64.h
+++ b/include/asm-x86/dma-mapping_64.h
@@ -12,8 +12,6 @@ static inline int dma_mapping_error(dma_addr_t dma_addr)
 	return (dma_addr == bad_dma_address);
 }
 
-extern int dma_supported(struct device *hwdev, u64 mask);
-
 /* same for gart, swiotlb, and nommu */
 static inline int dma_get_cache_alignment(void)
 {
@@ -22,8 +20,6 @@ static inline int dma_get_cache_alignment(void)
 
 #define dma_is_consistent(d, h) 1
 
-extern int dma_set_mask(struct device *dev, u64 mask);
-
 extern struct device fallback_dev;
 extern int panic_on_overflow;
 
-- 
1.5.0.6

