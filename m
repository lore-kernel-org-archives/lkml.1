Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbZKDPt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbZKDPt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbZKDPt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:49:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35519 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661AbZKDPt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:49:27 -0500
Date: Wed, 4 Nov 2009 16:48:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20091104154831.GA16681@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
lib/dma-debug.c                    # 59a40e70: dma-debug: Fix compile warning w

 Thanks,

	Ingo

------------------>
Dave Jones (1):
      x86: Fix printk message typo in mtrr cleanup code

Gottfried Haider (1):
      x86: Add reboot quirk for 3 series Mac mini

Joerg Roedel (3):
      x86/amd-iommu: Workaround for erratum 63
      x86/amd-iommu: Un__init function required on shutdown
      dma-debug: Fix compile warning with PAE enabled


 arch/x86/include/asm/amd_iommu.h   |    1 +
 arch/x86/kernel/amd_iommu.c        |    2 ++
 arch/x86/kernel/amd_iommu_init.c   |   24 +++++++++++++++++++++++-
 arch/x86/kernel/cpu/mtrr/cleanup.c |    2 +-
 arch/x86/kernel/reboot.c           |    8 ++++++++
 lib/dma-debug.c                    |    6 ++++--
 6 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu.h b/arch/x86/include/asm/amd_iommu.h
index ac95995..4b18089 100644
--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -31,6 +31,7 @@ extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
 extern void amd_iommu_flush_all_domains(void);
 extern void amd_iommu_flush_all_devices(void);
 extern void amd_iommu_shutdown(void);
+extern void amd_iommu_apply_erratum_63(u16 devid);
 #else
 static inline int amd_iommu_init(void) { return -ENODEV; }
 static inline void amd_iommu_detect(void) { }
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 98f230f..0285521 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1220,6 +1220,8 @@ static void __detach_device(struct protection_domain *domain, u16 devid)
 	amd_iommu_dev_table[devid].data[1] = 0;
 	amd_iommu_dev_table[devid].data[2] = 0;
 
+	amd_iommu_apply_erratum_63(devid);
+
 	/* decrease reference counter */
 	domain->dev_cnt -= 1;
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index b4b61d4..c20001e 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -240,7 +240,7 @@ static void iommu_feature_enable(struct amd_iommu *iommu, u8 bit)
 	writel(ctrl, iommu->mmio_base + MMIO_CONTROL_OFFSET);
 }
 
-static void __init iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
+static void iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 {
 	u32 ctrl;
 
@@ -519,6 +519,26 @@ static void set_dev_entry_bit(u16 devid, u8 bit)
 	amd_iommu_dev_table[devid].data[i] |= (1 << _bit);
 }
 
+static int get_dev_entry_bit(u16 devid, u8 bit)
+{
+	int i = (bit >> 5) & 0x07;
+	int _bit = bit & 0x1f;
+
+	return (amd_iommu_dev_table[devid].data[i] & (1 << _bit)) >> _bit;
+}
+
+
+void amd_iommu_apply_erratum_63(u16 devid)
+{
+	int sysmgt;
+
+	sysmgt = get_dev_entry_bit(devid, DEV_ENTRY_SYSMGT1) |
+		 (get_dev_entry_bit(devid, DEV_ENTRY_SYSMGT2) << 1);
+
+	if (sysmgt == 0x01)
+		set_dev_entry_bit(devid, DEV_ENTRY_IW);
+}
+
 /* Writes the specific IOMMU for a device into the rlookup table */
 static void __init set_iommu_for_device(struct amd_iommu *iommu, u16 devid)
 {
@@ -547,6 +567,8 @@ static void __init set_dev_entry_from_acpi(struct amd_iommu *iommu,
 	if (flags & ACPI_DEVFLAG_LINT1)
 		set_dev_entry_bit(devid, DEV_ENTRY_LINT1_PASS);
 
+	amd_iommu_apply_erratum_63(devid);
+
 	set_iommu_for_device(iommu, devid);
 }
 
diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index 315738c..73c86db 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -846,7 +846,7 @@ int __init mtrr_cleanup(unsigned address_bits)
 	sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
 
 	range_sums = sum_ranges(range, nr_range);
-	printk(KERN_INFO "total RAM coverred: %ldM\n",
+	printk(KERN_INFO "total RAM covered: %ldM\n",
 	       range_sums >> (20 - PAGE_SHIFT));
 
 	if (mtrr_chunk_size && mtrr_gran_size) {
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index a1a3cdd..f930787 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -436,6 +436,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5"),
 		},
 	},
+	{	/* Handle problems with rebooting on Apple Macmini3,1 */
+		.callback = set_pci_reboot,
+		.ident = "Apple Macmini3,1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini3,1"),
+		},
+	},
 	{ }
 };
 
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 58a9f9f..ce6b7ea 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -819,9 +819,11 @@ static void check_unmap(struct dma_debug_entry *ref)
 		err_printk(ref->dev, entry, "DMA-API: device driver frees "
 			   "DMA memory with different CPU address "
 			   "[device address=0x%016llx] [size=%llu bytes] "
-			   "[cpu alloc address=%p] [cpu free address=%p]",
+			   "[cpu alloc address=0x%016llx] "
+			   "[cpu free address=0x%016llx]",
 			   ref->dev_addr, ref->size,
-			   (void *)entry->paddr, (void *)ref->paddr);
+			   (unsigned long long)entry->paddr,
+			   (unsigned long long)ref->paddr);
 	}
 
 	if (ref->sg_call_ents && ref->type == dma_debug_sg &&
