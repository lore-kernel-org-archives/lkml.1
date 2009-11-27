Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZK0N4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZK0N4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:56:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbZK0N4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:56:01 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:18096 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbZK0Nz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:56 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTCZ-01-6RG-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/34] x86/amd-iommu: Add an index field to struct amd_iommu
Date: Fri, 27 Nov 2009 14:55:14 +0100
Message-ID: <1259330145-14865-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:47.0764 (UTC) FILETIME=[525E4740:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an index field to struct amd_iommu which can
be used to lookup it up in an array. This index will be used
in struct protection_domain to keep track which protection
domain has devices behind which IOMMU.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |   17 +++++++++++++++++
 arch/x86/kernel/amd_iommu_init.c       |   15 +++++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index df5e9c8..ab3e7bf 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -25,6 +25,11 @@
 #include <linux/spinlock.h>
 
 /*
+ * Maximum number of IOMMUs supported
+ */
+#define MAX_IOMMUS	32
+
+/*
  * some size calculation constants
  */
 #define DEV_TABLE_ENTRY_SIZE		32
@@ -291,6 +296,9 @@ struct dma_ops_domain {
 struct amd_iommu {
 	struct list_head list;
 
+	/* Index within the IOMMU array */
+	int index;
+
 	/* locks the accesses to the hardware */
 	spinlock_t lock;
 
@@ -357,6 +365,15 @@ struct amd_iommu {
 extern struct list_head amd_iommu_list;
 
 /*
+ * Array with pointers to each IOMMU struct
+ * The indices are referenced in the protection domains
+ */
+extern struct amd_iommu *amd_iommus[MAX_IOMMUS];
+
+/* Number of IOMMUs present in the system */
+extern int amd_iommus_present;
+
+/*
  * Structure defining one entry in the device table
  */
 struct dev_table_entry {
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index cee1142..8567d16 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -137,6 +137,10 @@ bool amd_iommu_unmap_flush;		/* if true, flush on every unmap */
 LIST_HEAD(amd_iommu_list);		/* list of all AMD IOMMUs in the
 					   system */
 
+/* Array to assign indices to IOMMUs*/
+struct amd_iommu *amd_iommus[MAX_IOMMUS];
+int amd_iommus_present;
+
 /*
  * Pointer to the device table which is shared by all AMD IOMMUs
  * it is indexed by the PCI device id or the HT unit id and contains
@@ -840,7 +844,18 @@ static void __init free_iommu_all(void)
 static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 {
 	spin_lock_init(&iommu->lock);
+
+	/* Add IOMMU to internal data structures */
 	list_add_tail(&iommu->list, &amd_iommu_list);
+	iommu->index             = amd_iommus_present++;
+
+	if (unlikely(iommu->index >= MAX_IOMMUS)) {
+		WARN(1, "AMD-Vi: System has more IOMMUs than supported by this driver\n");
+		return -ENOSYS;
+	}
+
+	/* Index is fine - add IOMMU to the array */
+	amd_iommus[iommu->index] = iommu;
 
 	/*
 	 * Copy data from ACPI table entry to the iommu struct
-- 
1.6.5.3


