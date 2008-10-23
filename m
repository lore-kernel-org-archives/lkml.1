Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYJWXvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYJWXvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYJWXvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:51:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:53927 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbYJWXvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:51:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,473,1220252400"; 
   d="scan'208";a="351776618"
Date: Thu, 23 Oct 2008 16:51:00 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
       "Woodhouse, David" <david.woodhouse@intel.com>, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, mingo@elte.hu, fenghua.yu@intel.com,
       fujita.tomonori@lab.ntt.co.jp, adobriyan@gmail.com
Subject: Re: build failure at x86/kernel/pci-dma.c with !CONFIG_PCI
Message-ID: <20081023235100.GA2192@linux-os.sc.intel.com>
References: <a4423d670810231609h76323d2fqa4ed7d9ba0a46e3b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670810231609h76323d2fqa4ed7d9ba0a46e3b@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 04:09:52PM -0700, Alexander Beregalov wrote:
> arch/x86/kernel/built-in.o: In function `iommu_setup':
> pci-dma.c:(.init.text+0x36ad): undefined reference to `forbid_dac'
> pci-dma.c:(.init.text+0x36cc): undefined reference to `forbid_dac'
> pci-dma.c:(.init.text+0x3711): undefined reference to `forbid_dac
> 
> commit 5b6985ce8ec7127b4d60ad450b64ca8b82748a3b
> Author: Fenghua Yu <fenghua.yu@intel.com>
> Date:   Thu Oct 16 18:02:32 2008 -0700
> 
>     intel-iommu: IA64 support

Could you please try the following fix patch?

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 arch/ia64/include/asm/iommu.h |    1 -
 arch/ia64/kernel/pci-dma.c    |    7 -------
 arch/x86/include/asm/iommu.h  |    1 -
 arch/x86/kernel/pci-dma.c     |   16 ++++++++++++++++
 drivers/pci/pci.h             |    0 
 drivers/pci/quirks.c          |   14 --------------
 6 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/arch/ia64/include/asm/iommu.h b/arch/ia64/include/asm/iommu.h
index 5fb2bb9..0490794 100644
--- a/arch/ia64/include/asm/iommu.h
+++ b/arch/ia64/include/asm/iommu.h
@@ -11,6 +11,5 @@ extern int force_iommu, no_iommu;
 extern int iommu_detected;
 extern void iommu_dma_init(void);
 extern void machvec_init(const char *name);
-extern int forbid_dac;
 
 #endif
diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index 10a75b5..031abbf 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -89,13 +89,6 @@ int iommu_dma_supported(struct device *dev, u64 mask)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(dev);
 
-#ifdef CONFIG_PCI
-	if (mask > 0xffffffff && forbid_dac > 0) {
-		dev_info(dev, "Disallowing DAC for device\n");
-		return 0;
-	}
-#endif
-
 	if (ops->dma_supported_op)
 		return ops->dma_supported_op(dev, mask);
 
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 1972266..1926248 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -9,6 +9,8 @@
 #include <asm/calgary.h>
 #include <asm/amd_iommu.h>
 
+static int forbid_dac __read_mostly;
+
 struct dma_mapping_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
@@ -291,3 +293,17 @@ void pci_iommu_shutdown(void)
 }
 /* Must execute after PCI subsystem */
 fs_initcall(pci_iommu_init);
+
+#ifdef CONFIG_PCI
+/* Many VIA bridges seem to corrupt data for DAC. Disable it here */
+
+static __devinit void via_no_dac(struct pci_dev *dev)
+{
+	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
+		printk(KERN_INFO "PCI: VIA PCI bridge detected."
+				 "Disabling DAC.\n");
+		forbid_dac = 1;
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID, via_no_dac);
+#endif
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 96cf8ec..bbf66ea 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -43,20 +43,6 @@ static void __devinit quirk_mellanox_tavor(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX,PCI_DEVICE_ID_MELLANOX_TAVOR,quirk_mellanox_tavor);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX,PCI_DEVICE_ID_MELLANOX_TAVOR_BRIDGE,quirk_mellanox_tavor);
 
-/* Many VIA bridges seem to corrupt data for DAC. Disable it here */
-int forbid_dac __read_mostly;
-EXPORT_SYMBOL(forbid_dac);
-
-static __devinit void via_no_dac(struct pci_dev *dev)
-{
-	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI && forbid_dac == 0) {
-		dev_info(&dev->dev,
-			"VIA PCI bridge detected. Disabling DAC.\n");
-		forbid_dac = 1;
-	}
-}
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_ANY_ID, via_no_dac);
-
 /* Deal with broken BIOS'es that neglect to enable passive release,
    which can cause problems in combination with the 82441FX/PPro MTRRs */
 static void quirk_passive_release(struct pci_dev *dev)
diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index 2daaffc..9a118bf 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -7,7 +7,6 @@ extern struct dma_mapping_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 extern int dmar_disabled;
-extern int forbid_dac;
 
 extern unsigned long iommu_nr_pages(unsigned long addr, unsigned long len);
 
