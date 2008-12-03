Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbYLCLvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbYLCLvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 06:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYLCLv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 06:51:29 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:37790 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbYLCLv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 06:51:28 -0500
X-BigFish: VPS-19(z21eW5edJz4015Mzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBAU9H-04-7JA-01
Date: Wed, 3 Dec 2008 12:51:16 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] AMD IOMMU updates for 2.6.28-rc7
Message-ID: <20081203115116.GF12816@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 03 Dec 2008 11:51:17.0230 (UTC) FILETIME=[734900E0:01C9553D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 061e41fdb5047b1fb161e89664057835935ca1d2:
  Linus Torvalds (1):
        Linux 2.6.28-rc7

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-fixes-2.6.28

Joerg Roedel (2):
      AMD IOMMU: set device table entry for aliased devices
      AMD IOMMU: fix possible race while accessing iommu->need_sync

Richard Kennedy (1):
      AMD IOMMU: struct amd_iommu remove padding on 64 bit

 arch/x86/include/asm/amd_iommu_types.h |   24 ++++++++++----------
 arch/x86/kernel/amd_iommu.c            |   36 ++++++++++++++-----------------
 2 files changed, 28 insertions(+), 32 deletions(-)

Beside the patch from Richard it contains a fix for a possible race
condition and an fix necessary after a specification update.
Find the full diff attached. Please pull.

Thanks,

Joerg

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 1a30c04..ac302a2 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -251,13 +251,6 @@ struct amd_iommu {
 	/* Pointer to PCI device of this IOMMU */
 	struct pci_dev *dev;
 
-	/*
-	 * Capability pointer. There could be more than one IOMMU per PCI
-	 * device function if there are more than one AMD IOMMU capability
-	 * pointers.
-	 */
-	u16 cap_ptr;
-
 	/* physical address of MMIO space */
 	u64 mmio_phys;
 	/* virtual address of MMIO space */
@@ -266,6 +259,13 @@ struct amd_iommu {
 	/* capabilities of that IOMMU read from ACPI */
 	u32 cap;
 
+	/*
+	 * Capability pointer. There could be more than one IOMMU per PCI
+	 * device function if there are more than one AMD IOMMU capability
+	 * pointers.
+	 */
+	u16 cap_ptr;
+
 	/* pci domain of this IOMMU */
 	u16 pci_seg;
 
@@ -284,19 +284,19 @@ struct amd_iommu {
 	/* size of command buffer */
 	u32 cmd_buf_size;
 
-	/* event buffer virtual address */
-	u8 *evt_buf;
 	/* size of event buffer */
 	u32 evt_buf_size;
+	/* event buffer virtual address */
+	u8 *evt_buf;
 	/* MSI number for event interrupt */
 	u16 evt_msi_num;
 
-	/* if one, we need to send a completion wait command */
-	int need_sync;
-
 	/* true if interrupts for this IOMMU are already enabled */
 	bool int_enabled;
 
+	/* if one, we need to send a completion wait command */
+	int need_sync;
+
 	/* default dma_ops domain for that IOMMU */
 	struct dma_ops_domain *default_dom;
 };
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index e4899e0..5662e22 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -187,6 +187,8 @@ static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
 
 	spin_lock_irqsave(&iommu->lock, flags);
 	ret = __iommu_queue_command(iommu, cmd);
+	if (!ret)
+		iommu->need_sync = 1;
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
 	return ret;
@@ -210,10 +212,13 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	cmd.data[0] = CMD_COMPL_WAIT_INT_MASK;
 	CMD_SET_TYPE(&cmd, CMD_COMPL_WAIT);
 
-	iommu->need_sync = 0;
-
 	spin_lock_irqsave(&iommu->lock, flags);
 
+	if (!iommu->need_sync)
+		goto out;
+
+	iommu->need_sync = 0;
+
 	ret = __iommu_queue_command(iommu, &cmd);
 
 	if (ret)
@@ -254,8 +259,6 @@ static int iommu_queue_inv_dev_entry(struct amd_iommu *iommu, u16 devid)
 
 	ret = iommu_queue_command(iommu, &cmd);
 
-	iommu->need_sync = 1;
-
 	return ret;
 }
 
@@ -281,8 +284,6 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
 
 	ret = iommu_queue_command(iommu, &cmd);
 
-	iommu->need_sync = 1;
-
 	return ret;
 }
 
@@ -762,8 +763,6 @@ static void set_device_domain(struct amd_iommu *iommu,
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 
 	iommu_queue_inv_dev_entry(iommu, devid);
-
-	iommu->need_sync = 1;
 }
 
 /*****************************************************************************
@@ -858,6 +857,9 @@ static int get_device_resources(struct device *dev,
 		print_devid(_bdf, 1);
 	}
 
+	if (domain_for_device(_bdf) == NULL)
+		set_device_domain(*iommu, *domain, _bdf);
+
 	return 1;
 }
 
@@ -1031,8 +1033,7 @@ static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
 	if (addr == bad_dma_address)
 		goto out;
 
-	if (unlikely(iommu->need_sync))
-		iommu_completion_wait(iommu);
+	iommu_completion_wait(iommu);
 
 out:
 	spin_unlock_irqrestore(&domain->lock, flags);
@@ -1060,8 +1061,7 @@ static void unmap_single(struct device *dev, dma_addr_t dma_addr,
 
 	__unmap_single(iommu, domain->priv, dma_addr, size, dir);
 
-	if (unlikely(iommu->need_sync))
-		iommu_completion_wait(iommu);
+	iommu_completion_wait(iommu);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
@@ -1127,8 +1127,7 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 			goto unmap;
 	}
 
-	if (unlikely(iommu->need_sync))
-		iommu_completion_wait(iommu);
+	iommu_completion_wait(iommu);
 
 out:
 	spin_unlock_irqrestore(&domain->lock, flags);
@@ -1173,8 +1172,7 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 		s->dma_address = s->dma_length = 0;
 	}
 
-	if (unlikely(iommu->need_sync))
-		iommu_completion_wait(iommu);
+	iommu_completion_wait(iommu);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
@@ -1225,8 +1223,7 @@ static void *alloc_coherent(struct device *dev, size_t size,
 		goto out;
 	}
 
-	if (unlikely(iommu->need_sync))
-		iommu_completion_wait(iommu);
+	iommu_completion_wait(iommu);
 
 out:
 	spin_unlock_irqrestore(&domain->lock, flags);
@@ -1257,8 +1254,7 @@ static void free_coherent(struct device *dev, size_t size,
 
 	__unmap_single(iommu, domain->priv, dma_addr, size, DMA_BIDIRECTIONAL);
 
-	if (unlikely(iommu->need_sync))
-		iommu_completion_wait(iommu);
+	iommu_completion_wait(iommu);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 
-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

