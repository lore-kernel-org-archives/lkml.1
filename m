Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbYJXSFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbYJXSFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbYJXSFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:05:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:26604 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998AbYJXSFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:05:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,479,1220252400"; 
   d="scan'208";a="631290204"
Date: Fri, 24 Oct 2008 11:05:41 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: Linux 2.6.28-rc1
Message-ID: <20081024180541.GA13637@linux-os.sc.intel.com>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org> <1224868194.3248.13.camel@calx> <1224870872.3248.20.camel@calx> <49020C99.8090108@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49020C99.8090108@oracle.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 10:57:45AM -0700, Randy Dunlap wrote:
> Matt Mackall wrote:
> > On Fri, 2008-10-24 at 12:10 -0500, Matt Mackall wrote:
> >> On Thu, 2008-10-23 at 21:10 -0700, Linus Torvalds wrote:
> >>> It's been two weeks, so it's time to close the merge window. A 2.6.28-rc1 
> >>> is out there, and it's hopefully all good.
> >> This fails building on allnoconfig on at least x86-64 because forbid_dac
> >> used by arch/x86/kernel/pci-dma.c is defined off in
> >> drivers/pci/quirks.c, which isn't built if CONFIG_PCI isn't set.
> > 
> > (Also fails on x86-32)
> > 
> > Bisection points to: 
> > 
> > 5b6985ce8ec7127b4d60ad450b64ca8b82748a3b
> > intel-iommu: IA64 support
> 
> Patch for this has been posted.  I don't have it handy ATM.
> 

Yes, the fix patch has been posted yesterday. And it has been merged into linux-next tree already. In case you need it, I post it here again.

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
 
