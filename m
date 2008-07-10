Return-Path: <linux-kernel-owner+w=401wt.eu-S1762322AbYGJSrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762322AbYGJSrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758947AbYGJSmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:42:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:47639 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758899AbYGJSmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:42:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="589105650"
Message-Id: <20080710182236.911771000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:41 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 07/26] x64, x2apic/intr-remap: move IOMMU_WAIT_OP() macro to intel-iommu.h
Content-Disposition: inline; filename=move_iommu_wait_io_macro.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move IOMMU_WAIT_OP() macro to header file.

This will be used by both DMA-remapping and Intr-remapping.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/drivers/pci/intel-iommu.c
===================================================================
--- tree-x86.orig/drivers/pci/intel-iommu.c	2008-07-10 09:51:51.000000000 -0700
+++ tree-x86/drivers/pci/intel-iommu.c	2008-07-10 09:51:59.000000000 -0700
@@ -49,8 +49,6 @@
 
 #define DEFAULT_DOMAIN_ADDRESS_WIDTH 48
 
-#define DMAR_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000) /* 10sec */
-
 #define DOMAIN_MAX_ADDR(gaw) ((((u64)1) << gaw) - 1)
 
 
@@ -486,19 +484,6 @@
 	return 0;
 }
 
-#define IOMMU_WAIT_OP(iommu, offset, op, cond, sts) \
-{\
-	cycles_t start_time = get_cycles();\
-	while (1) {\
-		sts = op (iommu->reg + offset);\
-		if (cond)\
-			break;\
-		if (DMAR_OPERATION_TIMEOUT < (get_cycles() - start_time))\
-			panic("DMAR hardware is malfunctioning\n");\
-		cpu_relax();\
-	}\
-}
-
 static void iommu_set_root_entry(struct intel_iommu *iommu)
 {
 	void *addr;
Index: tree-x86/drivers/pci/intel-iommu.h
===================================================================
--- tree-x86.orig/drivers/pci/intel-iommu.h	2008-07-10 09:51:57.000000000 -0700
+++ tree-x86/drivers/pci/intel-iommu.h	2008-07-10 09:51:59.000000000 -0700
@@ -177,6 +177,21 @@
 #define dma_frcd_source_id(c) (c & 0xffff)
 #define dma_frcd_page_addr(d) (d & (((u64)-1) << 12)) /* low 64 bit */
 
+#define DMAR_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000) /* 10sec */
+
+#define IOMMU_WAIT_OP(iommu, offset, op, cond, sts) \
+{\
+	cycles_t start_time = get_cycles();\
+	while (1) {\
+		sts = op (iommu->reg + offset);\
+		if (cond)\
+			break;\
+		if (DMAR_OPERATION_TIMEOUT < (get_cycles() - start_time))\
+			panic("DMAR hardware is malfunctioning\n");\
+		cpu_relax();\
+	}\
+}
+
 struct intel_iommu {
 	void __iomem	*reg; /* Pointer to hardware regs, virtual addr */
 	u64		cap;

-- 

