Return-Path: <linux-kernel-owner+w=401wt.eu-S933531AbZIDJpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531AbZIDJpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933558AbZIDJpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:45:40 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:47239
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933350AbZIDJpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:45:15 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXR9-03-O45-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/8] x86/amd-iommu: Reset command buffer on ILLEGAL_COMMAND_ERROR
Date: Fri, 4 Sep 2009 11:44:40 +0200
Message-ID: <1252057482-32207-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057482-32207-1-git-send-email-joerg.roedel@amd.com>
References: <1252057482-32207-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:44:45.0429 (UTC) FILETIME=[55D15A50:01CA2D44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an ILLEGAL_COMMAND_ERROR the IOMMU stops executing
further commands. This patch changes the code to handle this
case better by resetting the command buffer in the IOMMU.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 2dc0933..2333d61 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -61,6 +61,7 @@ static u64* alloc_pte(struct protection_domain *dom,
 static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
 				      unsigned long start_page,
 				      unsigned int pages);
+static void reset_iommu_command_buffer(struct amd_iommu *iommu);
 
 #ifndef BUS_NOTIFY_UNBOUND_DRIVER
 #define BUS_NOTIFY_UNBOUND_DRIVER 0x0005
@@ -156,7 +157,7 @@ static void dump_command(unsigned long phys_addr)
 		pr_err("AMD-Vi: CMD[%d]: %08x\n", i, cmd->data[i]);
 }
 
-static void iommu_print_event(void *__evt)
+static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
 {
 	u32 *event = __evt;
 	int type  = (event[1] >> EVENT_TYPE_SHIFT)  & EVENT_TYPE_MASK;
@@ -195,6 +196,7 @@ static void iommu_print_event(void *__evt)
 		break;
 	case EVENT_TYPE_ILL_CMD:
 		printk("ILLEGAL_COMMAND_ERROR address=0x%016llx]\n", address);
+		reset_iommu_command_buffer(iommu);
 		dump_command(address);
 		break;
 	case EVENT_TYPE_CMD_HARD_ERR:
@@ -229,7 +231,7 @@ static void iommu_poll_events(struct amd_iommu *iommu)
 	tail = readl(iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
 
 	while (head != tail) {
-		iommu_print_event(iommu->evt_buf + head);
+		iommu_print_event(iommu, iommu->evt_buf + head);
 		head = (head + EVENT_ENTRY_SIZE) % iommu->evt_buf_size;
 	}
 
@@ -547,6 +549,15 @@ void amd_iommu_flush_all_devices(void)
 	}
 }
 
+static void reset_iommu_command_buffer(struct amd_iommu *iommu)
+{
+	pr_err("AMD-Vi: Resetting IOMMU command buffer\n");
+
+	amd_iommu_reset_cmd_buffer(iommu);
+	flush_all_devices_for_iommu(iommu);
+	flush_all_domains_on_iommu(iommu);
+}
+
 /****************************************************************************
  *
  * The functions below are used the create the page table mappings for
-- 
1.6.3.3


