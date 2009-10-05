Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbZJEAz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbZJEAz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758243AbZJEAzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:55:23 -0400
Received: from mail.perches.com ([173.55.12.10]:1721 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758241AbZJEAzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:55:16 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Joerg Roedel <joerg.roedel@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH 05/21] amd_iommu.c: use pr_<level> and add pr_fmt(fmt)
Date: Sun,  4 Oct 2009 17:53:32 -0700
Message-Id: <2a3001d41382d567f2693f72b7fda331c2fe1d52.1254701151.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Converted a few bare printks to pr_cont

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/amd_iommu.c |   71 ++++++++++++++++++++++--------------------
 1 files changed, 37 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 98f230f..0296b42 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -17,6 +17,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
+#define pr_fmt(fmt) "AMD-Vi: " fmt
+
 #include <linux/pci.h>
 #include <linux/gfp.h>
 #include <linux/bitops.h>
@@ -147,7 +149,7 @@ static void dump_dte_entry(u16 devid)
 	int i;
 
 	for (i = 0; i < 8; ++i)
-		pr_err("AMD-Vi: DTE[%d]: %08x\n", i,
+		pr_err("DTE[%d]: %08x\n", i,
 			amd_iommu_dev_table[devid].data[i]);
 }
 
@@ -157,7 +159,7 @@ static void dump_command(unsigned long phys_addr)
 	int i;
 
 	for (i = 0; i < 4; ++i)
-		pr_err("AMD-Vi: CMD[%d]: %08x\n", i, cmd->data[i]);
+		pr_err("CMD[%d]: %08x\n", i, cmd->data[i]);
 }
 
 static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
@@ -169,57 +171,58 @@ static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
 	int flags = (event[1] >> EVENT_FLAGS_SHIFT) & EVENT_FLAGS_MASK;
 	u64 address = (u64)(((u64)event[3]) << 32) | event[2];
 
-	printk(KERN_ERR "AMD-Vi: Event logged [");
+	pr_err("Event logged [");
 
 	switch (type) {
 	case EVENT_TYPE_ILL_DEV:
-		printk("ILLEGAL_DEV_TABLE_ENTRY device=%02x:%02x.%x "
-		       "address=0x%016llx flags=0x%04x]\n",
-		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-		       address, flags);
+		pr_cont("ILLEGAL_DEV_TABLE_ENTRY device=%02x:%02x.%x "
+			"address=0x%016llx flags=0x%04x]\n",
+			PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+			address, flags);
 		dump_dte_entry(devid);
 		break;
 	case EVENT_TYPE_IO_FAULT:
-		printk("IO_PAGE_FAULT device=%02x:%02x.%x "
-		       "domain=0x%04x address=0x%016llx flags=0x%04x]\n",
-		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-		       domid, address, flags);
+		pr_cont("IO_PAGE_FAULT device=%02x:%02x.%x "
+			"domain=0x%04x address=0x%016llx flags=0x%04x]\n",
+			PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+			domid, address, flags);
 		break;
 	case EVENT_TYPE_DEV_TAB_ERR:
-		printk("DEV_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
-		       "address=0x%016llx flags=0x%04x]\n",
-		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-		       address, flags);
+		pr_cont("DEV_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
+			"address=0x%016llx flags=0x%04x]\n",
+			PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+			address, flags);
 		break;
 	case EVENT_TYPE_PAGE_TAB_ERR:
-		printk("PAGE_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
-		       "domain=0x%04x address=0x%016llx flags=0x%04x]\n",
-		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-		       domid, address, flags);
+		pr_cont("PAGE_TAB_HARDWARE_ERROR device=%02x:%02x.%x "
+			"domain=0x%04x address=0x%016llx flags=0x%04x]\n",
+			PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+			domid, address, flags);
 		break;
 	case EVENT_TYPE_ILL_CMD:
-		printk("ILLEGAL_COMMAND_ERROR address=0x%016llx]\n", address);
+		pr_cont("ILLEGAL_COMMAND_ERROR address=0x%016llx]\n", address);
 		reset_iommu_command_buffer(iommu);
 		dump_command(address);
 		break;
 	case EVENT_TYPE_CMD_HARD_ERR:
-		printk("COMMAND_HARDWARE_ERROR address=0x%016llx "
-		       "flags=0x%04x]\n", address, flags);
+		pr_cont("COMMAND_HARDWARE_ERROR address=0x%016llx "
+			"flags=0x%04x]\n", address, flags);
 		break;
 	case EVENT_TYPE_IOTLB_INV_TO:
-		printk("IOTLB_INV_TIMEOUT device=%02x:%02x.%x "
-		       "address=0x%016llx]\n",
-		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-		       address);
+		pr_cont("IOTLB_INV_TIMEOUT device=%02x:%02x.%x "
+			"address=0x%016llx]\n",
+			PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+			address);
 		break;
 	case EVENT_TYPE_INV_DEV_REQ:
-		printk("INVALID_DEVICE_REQUEST device=%02x:%02x.%x "
-		       "address=0x%016llx flags=0x%04x]\n",
-		       PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-		       address, flags);
+		pr_cont("INVALID_DEVICE_REQUEST device=%02x:%02x.%x "
+			"address=0x%016llx flags=0x%04x]\n",
+			PCI_BUS(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+			address, flags);
 		break;
 	default:
-		printk(KERN_ERR "UNKNOWN type=0x%02x]\n", type);
+		pr_cont("\n");
+		pr_err("UNKNOWN type=0x%02x]\n", type);
 	}
 }
 
@@ -558,10 +561,10 @@ static void flush_devices_by_domain(struct protection_domain *domain)
 
 static void reset_iommu_command_buffer(struct amd_iommu *iommu)
 {
-	pr_err("AMD-Vi: Resetting IOMMU command buffer\n");
+	pr_err("Resetting IOMMU command buffer\n");
 
 	if (iommu->reset_in_progress)
-		panic("AMD-Vi: ILLEGAL_COMMAND_ERROR while resetting command buffer\n");
+		panic(pr_fmt("ILLEGAL_COMMAND_ERROR while resetting command buffer\n"));
 
 	iommu->reset_in_progress = true;
 
@@ -2418,7 +2421,7 @@ int __init amd_iommu_init_passthrough(void)
 		__attach_device(iommu, pt_domain, devid2);
 	}
 
-	pr_info("AMD-Vi: Initialized for Passthrough Mode\n");
+	pr_info("Initialized for Passthrough Mode\n");
 
 	return 0;
 }
-- 
1.6.3.1.10.g659a0.dirty

