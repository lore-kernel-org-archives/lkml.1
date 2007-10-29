Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbXJ2Ev1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbXJ2Ev1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 00:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbXJ2EvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 00:51:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59671 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbXJ2EvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 00:51:19 -0400
Date: Mon, 29 Oct 2007 04:51:16 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: anil.s.keshavamurthy@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] intel-iommu fixes
Message-ID: <20071029045116.GB8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	* off by one in dmar_get_fault_reason() (maximal index in
array is ARRAY_SIZE()-1, not ARRAY_SIZE())
	* NULL noise removal
	* __iomem annotation fix

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 0c4ab3b..9b35259 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -745,7 +745,7 @@ static char *fault_reason_strings[] =
 	"non-zero reserved fields in PTE",
 	"Unknown"
 };
-#define MAX_FAULT_REASON_IDX 	ARRAY_SIZE(fault_reason_strings)
+#define MAX_FAULT_REASON_IDX 	ARRAY_SIZE(fault_reason_strings) - 1
 
 char *dmar_get_fault_reason(u8 fault_reason)
 {
@@ -995,7 +995,6 @@ static struct intel_iommu *alloc_iommu(struct dmar_drhd_unit *drhd)
 	return iommu;
 error_unmap:
 	iounmap(iommu->reg);
-	iommu->reg = 0;
 error:
 	kfree(iommu);
 	return NULL;
@@ -1808,7 +1807,7 @@ get_valid_domain_for_dev(struct pci_dev *pdev)
 	if (!domain) {
 		printk(KERN_ERR
 			"Allocating domain for %s failed", pci_name(pdev));
-		return 0;
+		return NULL;
 	}
 
 	/* make sure context mapping is ok */
@@ -1818,7 +1817,7 @@ get_valid_domain_for_dev(struct pci_dev *pdev)
 			printk(KERN_ERR
 				"Domain context map for %s failed",
 				pci_name(pdev));
-			return 0;
+			return NULL;
 		}
 	}
 
diff --git a/drivers/pci/intel-iommu.h b/drivers/pci/intel-iommu.h
index ee88dd2..459ad1f 100644
--- a/drivers/pci/intel-iommu.h
+++ b/drivers/pci/intel-iommu.h
@@ -58,7 +58,7 @@
 		hi = readl(dmar + reg + 4); \
 		(((u64) hi) << 32) + lo; })
 */
-static inline u64 dmar_readq(void *addr)
+static inline u64 dmar_readq(void __iomem *addr)
 {
 	u32 lo, hi;
 	lo = readl(addr);
