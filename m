Return-Path: <linux-kernel-owner+w=401wt.eu-S1762609AbYCYVog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762609AbYCYVog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYCYVjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:39:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760823AbYCYVjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:39:00 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: [PATCH 18/20] x86: unify dma_mapping_error
Date: Tue, 25 Mar 2008 18:36:37 -0300
Message-Id: <1206480999-21767-19-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
In-Reply-To: <1206480999-21767-18-git-send-email-gcosta@redhat.com>
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
 <1206480999-21767-16-git-send-email-gcosta@redhat.com>
 <1206480999-21767-17-git-send-email-gcosta@redhat.com>
 <1206480999-21767-18-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We provide a map_error function in pci-base_32.c to make
sure i386 keeps with the same behaviour it used to.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-base_32.c    |    7 +++++++
 include/asm-x86/dma-mapping.h    |    8 ++++++++
 include/asm-x86/dma-mapping_32.h |    6 ------
 include/asm-x86/dma-mapping_64.h |    8 --------
 4 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/pci-base_32.c b/arch/x86/kernel/pci-base_32.c
index 033d94e..89d3587 100644
--- a/arch/x86/kernel/pci-base_32.c
+++ b/arch/x86/kernel/pci-base_32.c
@@ -30,6 +30,12 @@ static int pci32_dma_map_sg(struct device *dev, struct scatterlist *sglist,
 	return nents;
 }
 
+/* Make sure we keep the same behaviour */
+static int pci32_map_error(dma_addr_t dma_addr)
+{
+	return 0;
+}
+
 static const struct dma_mapping_ops pci32_dma_ops = {
 	.map_single = pci32_map_single,
 	.unmap_single = NULL,
@@ -41,6 +47,7 @@ static const struct dma_mapping_ops pci32_dma_ops = {
 	.sync_single_range_for_device = NULL,
 	.sync_sg_for_cpu = NULL,
 	.sync_sg_for_device = NULL,
+	.mapping_error = pci32_map_error,
 };
 
 const struct dma_mapping_ops *dma_ops = &pci32_dma_ops;
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 908fcaa..352433b 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -54,6 +54,14 @@ struct dma_mapping_ops {
 
 extern const struct dma_mapping_ops *dma_ops;
 
+static inline int dma_mapping_error(dma_addr_t dma_addr)
+{
+	if (dma_ops->mapping_error)
+		return dma_ops->mapping_error(dma_addr);
+
+	return (dma_addr == bad_dma_address);
+}
+
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
diff --git a/include/asm-x86/dma-mapping_32.h b/include/asm-x86/dma-mapping_32.h
index d0512c9..03a75f8 100644
--- a/include/asm-x86/dma-mapping_32.h
+++ b/include/asm-x86/dma-mapping_32.h
@@ -8,12 +8,6 @@
 #include <asm/io.h>
 #include <asm/bug.h>
 
-static inline int
-dma_mapping_error(dma_addr_t dma_addr)
-{
-	return 0;
-}
-
 extern int forbid_dac;
 
 static inline int
diff --git a/include/asm-x86/dma-mapping_64.h b/include/asm-x86/dma-mapping_64.h
index 352bf41..8353025 100644
--- a/include/asm-x86/dma-mapping_64.h
+++ b/include/asm-x86/dma-mapping_64.h
@@ -3,14 +3,6 @@
 
 extern int iommu_merge;
 
-static inline int dma_mapping_error(dma_addr_t dma_addr)
-{
-	if (dma_ops->mapping_error)
-		return dma_ops->mapping_error(dma_addr);
-
-	return (dma_addr == bad_dma_address);
-}
-
 /* same for gart, swiotlb, and nommu */
 static inline int dma_get_cache_alignment(void)
 {
-- 
1.5.0.6

