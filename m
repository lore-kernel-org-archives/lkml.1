Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbYDHQ3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbYDHQ3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756664AbYDHQ2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:28:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758423AbYDHQ17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:27:59 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 08/28] x86: move definition to pci-dma.c
Date: Tue,  8 Apr 2008 13:20:50 -0300
Message-Id: <12076717261977-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move dma_ops structure definition to pci-dma.c, where it
belongs.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-base_32.c |   11 ++++++++---
 arch/x86/kernel/pci-dma.c     |    3 +++
 arch/x86/mm/init_64.c         |    3 ---
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/pci-base_32.c b/arch/x86/kernel/pci-base_32.c
index 837bbe9..b44ea51 100644
--- a/arch/x86/kernel/pci-base_32.c
+++ b/arch/x86/kernel/pci-base_32.c
@@ -37,7 +37,7 @@ static int pci32_map_error(dma_addr_t dma_addr)
 	return 0;
 }
 
-static const struct dma_mapping_ops pci32_dma_ops = {
+const struct dma_mapping_ops pci32_dma_ops = {
 	.map_single = pci32_map_single,
 	.unmap_single = NULL,
 	.map_sg = pci32_dma_map_sg,
@@ -51,5 +51,10 @@ static const struct dma_mapping_ops pci32_dma_ops = {
 	.mapping_error = pci32_map_error,
 };
 
-const struct dma_mapping_ops *dma_ops = &pci32_dma_ops;
-EXPORT_SYMBOL(dma_ops);
+/* this is temporary */
+int __init no_iommu_init(void)
+{
+	dma_ops = &pci32_dma_ops;
+	return 0;
+}
+fs_initcall(no_iommu_init);
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index f1c24d8..1323cd8 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -1,5 +1,8 @@
 #include <linux/dma-mapping.h>
 
+const struct dma_mapping_ops *dma_ops;
+EXPORT_SYMBOL(dma_ops);
+
 int dma_set_mask(struct device *dev, u64 mask)
 {
 	if (!dev->dma_mask || !dma_supported(dev, mask))
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 8c989b8..f06a51e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -47,9 +47,6 @@
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
 
-const struct dma_mapping_ops *dma_ops;
-EXPORT_SYMBOL(dma_ops);
-
 static unsigned long dma_reserve __initdata;
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-- 
1.5.0.6

