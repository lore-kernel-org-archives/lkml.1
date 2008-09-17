Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbYIQQxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbYIQQxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbYIQQxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:12 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:4008 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbYIQQxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:10 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K7CMW6-04-URO-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/23] AMD IOMMU: add event buffer allocation
Date: Wed, 17 Sep 2008 18:52:40 +0200
Message-ID: <1221670377-19295-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:58.0001 (UTC) FILETIME=[D660B810:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the allocation of a event buffer for each AMD IOMMU in
the system. The hardware will log events like device page faults or
other errors to this buffer once this is enabled.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c  |   29 +++++++++++++++++++++++++++++
 include/asm-x86/amd_iommu_types.h |    9 +++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index da631ab..a902eb6 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -418,6 +418,30 @@ static void __init free_command_buffer(struct amd_iommu *iommu)
 	free_pages((unsigned long)iommu->cmd_buf, get_order(CMD_BUFFER_SIZE));
 }
 
+/* allocates the memory where the IOMMU will log its events to */
+static u8 * __init alloc_event_buffer(struct amd_iommu *iommu)
+{
+	u64 entry;
+	iommu->evt_buf = (u8 *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+						get_order(EVT_BUFFER_SIZE));
+
+	if (iommu->evt_buf == NULL)
+		return NULL;
+
+	entry = (u64)virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
+	memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
+		    &entry, sizeof(entry));
+
+	iommu->evt_buf_size = EVT_BUFFER_SIZE;
+
+	return iommu->evt_buf;
+}
+
+static void __init free_event_buffer(struct amd_iommu *iommu)
+{
+	free_pages((unsigned long)iommu->evt_buf, get_order(EVT_BUFFER_SIZE));
+}
+
 /* sets a specific bit in the device table entry. */
 static void set_dev_entry_bit(u16 devid, u8 bit)
 {
@@ -623,6 +647,7 @@ static int __init init_iommu_devices(struct amd_iommu *iommu)
 static void __init free_iommu_one(struct amd_iommu *iommu)
 {
 	free_command_buffer(iommu);
+	free_event_buffer(iommu);
 	iommu_unmap_mmio_space(iommu);
 }
 
@@ -662,6 +687,10 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 	if (!iommu->cmd_buf)
 		return -ENOMEM;
 
+	iommu->evt_buf = alloc_event_buffer(iommu);
+	if (!iommu->evt_buf)
+		return -ENOMEM;
+
 	init_iommu_from_pci(iommu);
 	init_iommu_from_acpi(iommu, h);
 	init_iommu_devices(iommu);
diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index 82a26fb..eabc316 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -116,6 +116,10 @@
 #define MMIO_CMD_SIZE_SHIFT 56
 #define MMIO_CMD_SIZE_512 (0x9ULL << MMIO_CMD_SIZE_SHIFT)
 
+/* constants for event buffer handling */
+#define EVT_BUFFER_SIZE		8192 /* 512 entries */
+#define EVT_LEN_MASK		(0x9ULL << 56)
+
 #define PAGE_MODE_1_LEVEL 0x01
 #define PAGE_MODE_2_LEVEL 0x02
 #define PAGE_MODE_3_LEVEL 0x03
@@ -243,6 +247,11 @@ struct amd_iommu {
 	/* size of command buffer */
 	u32 cmd_buf_size;
 
+	/* event buffer virtual address */
+	u8 *evt_buf;
+	/* size of event buffer */
+	u32 evt_buf_size;
+
 	/* if one, we need to send a completion wait command */
 	int need_sync;
 
-- 
1.5.6.4


