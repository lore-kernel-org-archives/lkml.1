Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYLDTqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYLDTqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbYLDTqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:46:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44815 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbYLDTq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:46:28 -0500
Date: Thu, 4 Dec 2008 20:46:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20081204194612.GA32327@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      x86: fix early panic with boot option "nosmp"

Eric Dumazet (1):
      oprofile: fix CPU unplug panic in ppro_stop()

Joerg Roedel (3):
      x86: fix broken flushing in GART nofullflush path
      AMD IOMMU: set device table entry for aliased devices
      AMD IOMMU: fix possible race while accessing iommu->need_sync

Richard Kennedy (1):
      AMD IOMMU: struct amd_iommu remove padding on 64 bit

Thomas Bogendoerfer (1):
      x86: fix dma_mapping_error for 32bit x86

William Cohen (1):
      x86/oprofile: fix Intel cpu family 6 detection


 arch/x86/include/asm/amd_iommu_types.h |   24 ++++++++++----------
 arch/x86/include/asm/dma-mapping.h     |    6 +---
 arch/x86/kernel/amd_iommu.c            |   36 ++++++++++++++-----------------
 arch/x86/kernel/mpparse.c              |    3 ++
 arch/x86/kernel/pci-gart_64.c          |    2 +
 arch/x86/oprofile/nmi_int.c            |    5 +--
 arch/x86/oprofile/op_model_ppro.c      |    4 +++
 7 files changed, 41 insertions(+), 39 deletions(-)

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
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 7f225a4..097794f 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -71,15 +71,13 @@ static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
 /* Make sure we keep the same behaviour */
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-#ifdef CONFIG_X86_32
-	return 0;
-#else
+#ifdef CONFIG_X86_64
 	struct dma_mapping_ops *ops = get_dma_ops(dev);
 	if (ops->mapping_error)
 		return ops->mapping_error(dev, dma_addr);
 
-	return (dma_addr == bad_dma_address);
 #endif
+	return (dma_addr == bad_dma_address);
 }
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
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
 
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index f98f4e1..0f4c1fd 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -604,6 +604,9 @@ static void __init __get_smp_config(unsigned int early)
 		printk(KERN_INFO "Using ACPI for processor (LAPIC) "
 		       "configuration information\n");
 
+	if (!mpf)
+		return;
+
 	printk(KERN_INFO "Intel MultiProcessor Specification v1.%d\n",
 	       mpf->mpf_specification);
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index a42b02b..ba7ad83 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -123,6 +123,8 @@ static void free_iommu(unsigned long offset, int size)
 
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
 	iommu_area_free(iommu_gart_bitmap, offset, size);
+	if (offset >= next_bit)
+		next_bit = offset + size;
 	spin_unlock_irqrestore(&iommu_bitmap_lock, flags);
 }
 
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 022cd41..202864a 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -401,14 +401,13 @@ static int __init ppro_init(char **cpu_type)
 		*cpu_type = "i386/pii";
 		break;
 	case 6 ... 8:
+	case 10 ... 11:
 		*cpu_type = "i386/piii";
 		break;
 	case 9:
+	case 13:
 		*cpu_type = "i386/p6_mobile";
 		break;
-	case 10 ... 13:
-		*cpu_type = "i386/p6";
-		break;
 	case 14:
 		*cpu_type = "i386/core";
 		break;
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 716d26f..e9f80c7 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -156,6 +156,8 @@ static void ppro_start(struct op_msrs const * const msrs)
 	unsigned int low, high;
 	int i;
 
+	if (!reset_value)
+		return;
 	for (i = 0; i < num_counters; ++i) {
 		if (reset_value[i]) {
 			CTRL_READ(low, high, msrs, i);
@@ -171,6 +173,8 @@ static void ppro_stop(struct op_msrs const * const msrs)
 	unsigned int low, high;
 	int i;
 
+	if (!reset_value)
+		return;
 	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
