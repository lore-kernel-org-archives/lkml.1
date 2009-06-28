Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbZF1VMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbZF1VMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbZF1VMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:12:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:50774 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbZF1VMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:12:36 -0400
Message-ID: <4A47DCB5.7080901@kernel.org>
Date: Sun, 28 Jun 2009 14:12:21 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH] pci/dmar: print out iommu seq_id
References: <4A47DBD5.6070307@kernel.org>
In-Reply-To: <4A47DBD5.6070307@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


more info on multi iommu system.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/dmar.c           |    3 ++-
 drivers/pci/intel-iommu.c    |    9 ++++++---
 drivers/pci/intr_remapping.c |    6 +++---
 3 files changed, 11 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/pci/dmar.c
===================================================================
--- linux-2.6.orig/drivers/pci/dmar.c
+++ linux-2.6/drivers/pci/dmar.c
@@ -669,7 +669,8 @@ int alloc_iommu(struct dmar_drhd_unit *d
 	}
 
 	ver = readl(iommu->reg + DMAR_VER_REG);
-	pr_debug("IOMMU %llx: ver %d:%d cap %llx ecap %llx\n",
+	pr_debug("IOMMU %d: reg_base_addr %llx ver %d:%d cap %llx ecap %llx\n",
+		iommu->seq_id,
 		(unsigned long long)drhd->reg_base_addr,
 		DMAR_VER_MAJOR(ver), DMAR_VER_MINOR(ver),
 		(unsigned long long)iommu->cap,
Index: linux-2.6/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.orig/drivers/pci/intel-iommu.c
+++ linux-2.6/drivers/pci/intel-iommu.c
@@ -1117,7 +1117,8 @@ static int iommu_init_domains(struct int
 	unsigned long nlongs;
 
 	ndomains = cap_ndoms(iommu->cap);
-	pr_debug("Number of Domains supportd <%ld>\n", ndomains);
+	pr_debug("IOMMU %d: Number of Domains supportd <%ld>\n", iommu->seq_id,
+			ndomains);
 	nlongs = BITS_TO_LONGS(ndomains);
 
 	/* TBD: there might be 64K domains,
@@ -2230,14 +2231,16 @@ int __init init_dmars(void)
 			 */
 			iommu->flush.flush_context = __iommu_flush_context;
 			iommu->flush.flush_iotlb = __iommu_flush_iotlb;
-			printk(KERN_INFO "IOMMU 0x%Lx: using Register based "
+			printk(KERN_INFO "IOMMU %d 0x%Lx: using Register based "
 			       "invalidation\n",
+				iommu->seq_id,
 			       (unsigned long long)drhd->reg_base_addr);
 		} else {
 			iommu->flush.flush_context = qi_flush_context;
 			iommu->flush.flush_iotlb = qi_flush_iotlb;
-			printk(KERN_INFO "IOMMU 0x%Lx: using Queued "
+			printk(KERN_INFO "IOMMU %d 0x%Lx: using Queued "
 			       "invalidation\n",
+				iommu->seq_id,
 			       (unsigned long long)drhd->reg_base_addr);
 		}
 	}
Index: linux-2.6/drivers/pci/intr_remapping.c
===================================================================
--- linux-2.6.orig/drivers/pci/intr_remapping.c
+++ linux-2.6/drivers/pci/intr_remapping.c
@@ -760,9 +760,9 @@ static int ir_parse_ioapic_scope(struct
 				return -1;
 			}
 
-			printk(KERN_INFO "IOAPIC id %d under DRHD base"
-			       " 0x%Lx\n", scope->enumeration_id,
-			       drhd->address);
+			printk(KERN_INFO "IOAPIC id %d under DRHD base "
+			       " 0x%Lx IOMMU %d\n", scope->enumeration_id,
+			       drhd->address, iommu->seq_id);
 
 			ir_parse_one_ioapic_scope(scope, iommu);
 		}
