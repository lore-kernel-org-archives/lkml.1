Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbYJWNRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbYJWNRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbYJWNRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:17:19 -0400
Received: from sh.osrg.net ([192.16.179.4]:60697 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114AbYJWNRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:17:17 -0400
Date: Thu, 23 Oct 2008 22:16:39 +0900
To: adobriyan@gmail.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, David.Woodhouse@intel.com,
       tony.luck@intel.com, fenghua.yu@intel.com, mingo@elte.hu
Subject: Re: linux-next: undefined reference to 'forbid_dac'
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081023122604.GB15805@x200.localdomain>
References: <20081023213637.eff9b414.sfr@canb.auug.org.au>
	<20081023122604.GB15805@x200.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081023221703Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008 16:26:04 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On i386-allnoconfig:
> 
> arch/x86/kernel/built-in.o: In function `iommu_setup':
> pci-dma.c:(.init.text+0x3491): undefined reference to `forbid_dac'
> pci-dma.c:(.init.text+0x3497): undefined reference to `forbid_dac'
> pci-dma.c:(.init.text+0x34b1): undefined reference to `forbid_dac'
> pci-dma.c:(.init.text+0x34b7): undefined reference to `forbid_dac'
> pci-dma.c:(.init.text+0x34f7): undefined reference to `forbid_dac'

Hmm, the following forbid_dac relocation doesn't look related to
adding VT-d support to IA64...


=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86: fix undefined reference to forbid_dac

The following commit moves forbid_dac from arch/kernel/pci-dma.c to
drivers/pci/quirks.c, which breaks !CONFIG_PCI_QUIRKS:

commit 5b6985ce8ec7127b4d60ad450b64ca8b82748a3b
Author: Fenghua Yu <fenghua.yu@intel.com>
Date:   Thu Oct 16 18:02:32 2008 -0700

    intel-iommu: IA64 support

    The current Intel IOMMU code assumes that both host page size and Intel
    IOMMU page size are 4KiB. The first patch supports variable page size.
    This provides support for IA64 which has multiple page sizes.

    This patch also adds some other code hooks for IA64 platform including
    DMAR_OPERATION_TIMEOUT definition.

    [dwmw2: some cleanup]
    Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
    Signed-off-by: Tony Luck <tony.luck@intel.com>
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

---
 arch/x86/kernel/pci-dma.c |   16 ++++++++++++++++
 drivers/pci/quirks.c      |   14 --------------
 2 files changed, 16 insertions(+), 14 deletions(-)

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
-- 
1.5.5.GIT

