Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbYFZTkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbYFZTkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbYFZT3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:29:24 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:14310 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760639AbYFZT3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:29:15 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K334RT-04-UOB-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/34] AMD IOMMU: add command buffer (de-)allocation
Date: Thu, 26 Jun 2008 21:27:45 +0200
Message-ID: <1214508490-29683-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0590 (UTC) FILETIME=[C56C5E60:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the functions to allocate and deallocate the command buffer for
one IOMMU in the system.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index ffb8ac8..c2be3ad 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -278,3 +278,33 @@ static int __init find_last_devid_acpi(struct acpi_table_header *table)
 	return 0;
 }
 
+static u8 * __init alloc_command_buffer(struct amd_iommu *iommu)
+{
+	u8 *cmd_buf = (u8 *)__get_free_pages(GFP_KERNEL,
+			get_order(CMD_BUFFER_SIZE));
+	u64 entry = 0;
+
+	if (cmd_buf == NULL)
+		return NULL;
+
+	iommu->cmd_buf_size = CMD_BUFFER_SIZE;
+
+	memset(cmd_buf, 0, CMD_BUFFER_SIZE);
+
+	entry = (u64)virt_to_phys(cmd_buf);
+	entry |= MMIO_CMD_SIZE_512;
+	memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
+			&entry, sizeof(entry));
+
+	iommu_feature_enable(iommu, CONTROL_CMDBUF_EN);
+
+	return cmd_buf;
+}
+
+static void __init free_command_buffer(struct amd_iommu *iommu)
+{
+	if (iommu->cmd_buf)
+		free_pages((unsigned long)iommu->cmd_buf,
+				get_order(CMD_BUFFER_SIZE));
+}
+
-- 
1.5.3.7


