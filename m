Return-Path: <linux-kernel-owner+w=401wt.eu-S1761260AbYFZT35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761260AbYFZT35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760160AbYFZT2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:28:31 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:2015 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759959AbYFZT22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:28:28 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K334QZ-03-2YC-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 19/34] AMD IOMMU: add functions to send IOMMU commands
Date: Thu, 26 Jun 2008 21:27:55 +0200
Message-ID: <1214508490-29683-20-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0886 (UTC) FILETIME=[C59988E0:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds generic handling function as well as all functions to send
specific commands to the IOMMU hardware as required by this driver.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |  106 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 106 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 90392c7..a24ee4a 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -37,4 +37,110 @@ struct command {
 	u32 data[4];
 };
 
+static int __iommu_queue_command(struct amd_iommu *iommu, struct command *cmd)
+{
+	u32 tail, head;
+	u8 *target;
+
+	tail = readl(iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
+	target = (iommu->cmd_buf + tail);
+	memcpy_toio(target, cmd, sizeof(*cmd));
+	tail = (tail + sizeof(*cmd)) % iommu->cmd_buf_size;
+	head = readl(iommu->mmio_base + MMIO_CMD_HEAD_OFFSET);
+	if (tail == head)
+		return -ENOMEM;
+	writel(tail, iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
+
+	return 0;
+}
+
+static int iommu_queue_command(struct amd_iommu *iommu, struct command *cmd)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&iommu->lock, flags);
+	ret = __iommu_queue_command(iommu, cmd);
+	spin_unlock_irqrestore(&iommu->lock, flags);
+
+	return ret;
+}
+
+static int iommu_completion_wait(struct amd_iommu *iommu)
+{
+	int ret;
+	struct command cmd;
+	volatile u64 ready = 0;
+	unsigned long ready_phys = virt_to_phys(&ready);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.data[0] = LOW_U32(ready_phys) | CMD_COMPL_WAIT_STORE_MASK;
+	cmd.data[1] = HIGH_U32(ready_phys);
+	cmd.data[2] = 1; /* value written to 'ready' */
+	CMD_SET_TYPE(&cmd, CMD_COMPL_WAIT);
+
+	iommu->need_sync = 0;
+
+	ret = iommu_queue_command(iommu, &cmd);
+
+	if (ret)
+		return ret;
+
+	while (!ready)
+		cpu_relax();
+
+	return 0;
+}
+
+static int iommu_queue_inv_dev_entry(struct amd_iommu *iommu, u16 devid)
+{
+	struct command cmd;
+
+	BUG_ON(iommu == NULL);
+
+	memset(&cmd, 0, sizeof(cmd));
+	CMD_SET_TYPE(&cmd, CMD_INV_DEV_ENTRY);
+	cmd.data[0] = devid;
+
+	iommu->need_sync = 1;
+
+	return iommu_queue_command(iommu, &cmd);
+}
+
+static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
+		u64 address, u16 domid, int pde, int s)
+{
+	struct command cmd;
+
+	memset(&cmd, 0, sizeof(cmd));
+	address &= PAGE_MASK;
+	CMD_SET_TYPE(&cmd, CMD_INV_IOMMU_PAGES);
+	cmd.data[1] |= domid;
+	cmd.data[2] = LOW_U32(address);
+	cmd.data[3] = HIGH_U32(address);
+	if (s)
+		cmd.data[2] |= CMD_INV_IOMMU_PAGES_SIZE_MASK;
+	if (pde)
+		cmd.data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
+
+	iommu->need_sync = 1;
+
+	return iommu_queue_command(iommu, &cmd);
+}
+
+static int iommu_flush_pages(struct amd_iommu *iommu, u16 domid,
+		u64 address, size_t size)
+{
+	int i;
+	unsigned pages = to_pages(address, size);
+
+	address &= PAGE_MASK;
+
+	for (i = 0; i < pages; ++i) {
+		iommu_queue_inv_iommu_pages(iommu, address, domid, 0, 0);
+		address += PAGE_SIZE;
+	}
+
+	return 0;
+}
 
-- 
1.5.3.7


