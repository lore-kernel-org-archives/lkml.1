Return-Path: <linux-kernel-owner+w=401wt.eu-S1759100AbYGKPPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbYGKPPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYGKPOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:14:55 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:4900 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbYGKPOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:14:54 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K3UL0C-04-EOH-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/16] AMD IOMMU: add comments to amd_iommu_types.h
Date: Fri, 11 Jul 2008 17:14:20 +0200
Message-ID: <1215789275-20975-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
References: <1215789275-20975-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 15:14:35.0914 (UTC) FILETIME=[D45EB6A0:01C8E368]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/asm-x86/amd_iommu_types.h |  104 ++++++++++++++++++++++++++++++++++--
 1 files changed, 98 insertions(+), 6 deletions(-)

diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index 7bfcb47..945fd49 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -158,78 +158,170 @@
 
 #define MAX_DOMAIN_ID 65536
 
+/*
+ * This structure contains generic data for  IOMMU protection domains
+ * independent of their use.
+ */
 struct protection_domain {
-	spinlock_t lock;
-	u16 id;
-	int mode;
-	u64 *pt_root;
-	void *priv;
+	spinlock_t lock; /* mostly used to lock the page table*/
+	u16 id;		 /* the domain id written to the device table */
+	int mode;	 /* paging mode (0-6 levels) */
+	u64 *pt_root;	 /* page table root pointer */
+	void *priv;	 /* private data */
 };
 
+/*
+ * Data container for a dma_ops specific protection domain
+ */
 struct dma_ops_domain {
 	struct list_head list;
+
+	/* generic protection domain information */
 	struct protection_domain domain;
+
+	/* size of the aperture for the mappings */
 	unsigned long aperture_size;
+
+	/* address we start to search for free addresses */
 	unsigned long next_bit;
+
+	/* address allocation bitmap */
 	unsigned long *bitmap;
+
+	/*
+	 * Array of PTE pages for the aperture. In this array we save all the
+	 * leaf pages of the domain page table used for the aperture. This way
+	 * we don't need to walk the page table to find a specific PTE. We can
+	 * just calculate its address in constant time.
+	 */
 	u64 **pte_pages;
 };
 
+/*
+ * Structure where we save information about one hardware AMD IOMMU in the
+ * system.
+ */
 struct amd_iommu {
 	struct list_head list;
+
+	/* locks the accesses to the hardware */
 	spinlock_t lock;
 
+	/* device id of this IOMMU */
 	u16 devid;
+	/*
+	 * Capability pointer. There could be more than one IOMMU per PCI
+	 * device function if there are more than one AMD IOMMU capability
+	 * pointers.
+	 */
 	u16 cap_ptr;
 
+	/* physical address of MMIO space */
 	u64 mmio_phys;
+	/* virtual address of MMIO space */
 	u8 *mmio_base;
+
+	/* capabilities of that IOMMU read from ACPI */
 	u32 cap;
+
+	/* first device this IOMMU handles. read from PCI */
 	u16 first_device;
+	/* last device this IOMMU handles. read from PCI */
 	u16 last_device;
+
+	/* start of exclusion range of that IOMMU */
 	u64 exclusion_start;
+	/* length of exclusion range of that IOMMU */
 	u64 exclusion_length;
 
+	/* command buffer virtual address */
 	u8 *cmd_buf;
+	/* size of command buffer */
 	u32 cmd_buf_size;
 
+	/* if one, we need to send a completion wait command */
 	int need_sync;
 
+	/* default dma_ops domain for that IOMMU */
 	struct dma_ops_domain *default_dom;
 };
 
+/*
+ * List with all IOMMUs in the system. This list is not locked because it is
+ * only written and read at driver initialization or suspend time
+ */
 extern struct list_head amd_iommu_list;
 
+/*
+ * Structure defining one entry in the device table
+ */
 struct dev_table_entry {
 	u32 data[8];
 };
 
+/*
+ * One entry for unity mappings parsed out of the ACPI table.
+ */
 struct unity_map_entry {
 	struct list_head list;
+
+	/* starting device id this entry is used for (including) */
 	u16 devid_start;
+	/* end device id this entry is used for (including) */
 	u16 devid_end;
+
+	/* start address to unity map (including) */
 	u64 address_start;
+	/* end address to unity map (including) */
 	u64 address_end;
+
+	/* required protection */
 	int prot;
 };
 
+/*
+ * List of all unity mappings. It is not locked because as runtime it is only
+ * read. It is created at ACPI table parsing time.
+ */
 extern struct list_head amd_iommu_unity_map;
 
-/* data structures for device handling */
+/*
+ * Data structures for device handling
+ */
+
+/*
+ * Device table used by hardware. Read and write accesses by software are
+ * locked with the amd_iommu_pd_table lock.
+ */
 extern struct dev_table_entry *amd_iommu_dev_table;
+
+/*
+ * Alias table to find requestor ids to device ids. Not locked because only
+ * read on runtime.
+ */
 extern u16 *amd_iommu_alias_table;
+
+/*
+ * Reverse lookup table to find the IOMMU which translates a specific device.
+ */
 extern struct amd_iommu **amd_iommu_rlookup_table;
 
+/* size of the dma_ops aperture as power of 2 */
 extern unsigned amd_iommu_aperture_order;
 
+/* largest PCI device id we expect translation requests for */
 extern u16 amd_iommu_last_bdf;
 
 /* data structures for protection domain handling */
 extern struct protection_domain **amd_iommu_pd_table;
+
+/* allocation bitmap for domain ids */
 extern unsigned long *amd_iommu_pd_alloc_bitmap;
 
+/* will be 1 if device isolation is enabled */
 extern int amd_iommu_isolate;
 
+/* takes a PCI device id and prints it out in a readable form */
 static inline void print_devid(u16 devid, int nl)
 {
 	int bus = devid >> 8;
-- 
1.5.3.7


