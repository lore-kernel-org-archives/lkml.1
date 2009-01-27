Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZA0Ii0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZA0Ii0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 03:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZA0IiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 03:38:18 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:38833 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZA0IiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 03:38:18 -0500
Date: Tue, 27 Jan 2009 11:38:23 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: compile fixes
Message-ID: <20090127083823.GB15452@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- jensen build: fix conflicting declarations for pci_alloc_consistent()
  and undefined virt_to_phys();

- SMP: arch/alpha/kernel/smp.c:124: warning: passing argument 2
       of '__cpu_test_and_set' discards qualifiers from pointer target type
  Interestingly, this only happens with gcc-4.2; gcc <= 4.1 and gcc-4.3
  are OK. Fixed with extra assignment.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/include/asm/dma-mapping.h |    2 ++
 arch/alpha/kernel/pci-noop.c         |    3 ++-
 arch/alpha/kernel/smp.c              |    3 ++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/include/asm/dma-mapping.h b/arch/alpha/include/asm/dma-mapping.h
index a5801ae..04eb568 100644
--- a/arch/alpha/include/asm/dma-mapping.h
+++ b/arch/alpha/include/asm/dma-mapping.h
@@ -29,6 +29,8 @@
 
 #else	/* no PCI - no IOMMU. */
 
+#include <asm/io.h>	/* for virt_to_phys() */
+
 struct scatterlist;
 void *dma_alloc_coherent(struct device *dev, size_t size,
 			 dma_addr_t *dma_handle, gfp_t gfp);
diff --git a/arch/alpha/kernel/pci-noop.c b/arch/alpha/kernel/pci-noop.c
index 8ac0831..c19a376 100644
--- a/arch/alpha/kernel/pci-noop.c
+++ b/arch/alpha/kernel/pci-noop.c
@@ -109,7 +109,8 @@ sys_pciconfig_write(unsigned long bus, unsigned long dfn,
 /* Stubs for the routines in pci_iommu.c: */
 
 void *
-pci_alloc_consistent(struct pci_dev *pdev, size_t size, dma_addr_t *dma_addrp)
+__pci_alloc_consistent(struct pci_dev *pdev, size_t size,
+		       dma_addr_t *dma_addrp, gfp_t gfp)
 {
 	return NULL;
 }
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index d953e51..00f1dc3 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -120,8 +120,9 @@ void __cpuinit
 smp_callin(void)
 {
 	int cpuid = hard_smp_processor_id();
+	cpumask_t mask = cpu_online_map;
 
-	if (cpu_test_and_set(cpuid, cpu_online_map)) {
+	if (cpu_test_and_set(cpuid, mask)) {
 		printk("??, cpu 0x%x already present??\n", cpuid);
 		BUG();
 	}
