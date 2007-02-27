Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbXB0T3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbXB0T3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 14:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbXB0T3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 14:29:13 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54867 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbXB0T3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 14:29:12 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@atrey.karlin.mff.cuni.cz>,
       Michael Ellerman <michael@ellerman.id.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/3] msi:  Sanely support hardware level msi disabling.
References: <m1tzx7l7z2.fsf@ebiederm.dsl.xmission.com>
Date: Tue, 27 Feb 2007 12:28:40 -0700
In-Reply-To: <m1tzx7l7z2.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's
	message of "Tue, 27 Feb 2007 12:24:17 -0700")
Message-ID: <m1ps7vl7rr.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In some cases when we are not using msi we need a way to ensure that
the hardware does not have an msi capability enabled.  Currently the
code has been calling disable_msi_mode to try and achieve that.
However disable_msi_mode has several other side effects and is only
available when msi support is compiled in so it isn't really
appropriate.

Instead this patch implements pci_msi_off which disables all msi and
msix capabilities unconditionally with no additional side effects.


pci_disable_device was redundantly clearing the bus master enable flag
and clearing the msi enable bit.  A device that is not allowed to
perform bus mastering operations cannot generate intx or msi interrupt
messages as those are essentially a special case of dma, and require
bus mastering.  So the call in pci_disable_device to disable msi
capabilities was redundant.

quirk_pcie_pxh also called disable_msi_mode and is updated to use
pci_msi_off.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/powerpc/kernel/irq.c |    1 -
 drivers/pci/msi.c         |    2 +-
 drivers/pci/pci.c         |   34 +++++++++++++++++++++++++++-------
 drivers/pci/pci.h         |    2 --
 drivers/pci/quirks.c      |    4 ++--
 include/linux/pci.h       |    1 +
 include/linux/pci_regs.h  |    7 ++++---
 7 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 919fbf5..1009308 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -968,7 +968,6 @@ void pci_scan_msi_device(struct pci_dev *dev) {}
 int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int nvec) {return -1;}
 void pci_disable_msix(struct pci_dev *dev) {}
 void msi_remove_pci_irq_vectors(struct pci_dev *dev) {}
-void disable_msi_mode(struct pci_dev *dev, int pos, int type) {}
 void pci_no_msi(void) {}
 EXPORT_SYMBOL(pci_enable_msix);
 EXPORT_SYMBOL(pci_disable_msix);
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 68555c1..fd1068b 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -211,7 +211,7 @@ static void enable_msi_mode(struct pci_dev *dev, int pos, int type)
 	pci_intx(dev, 0);  /* disable intx */
 }
 
-void disable_msi_mode(struct pci_dev *dev, int pos, int type)
+static void disable_msi_mode(struct pci_dev *dev, int pos, int type)
 {
 	u16 control;
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 1e74e1e..bd44a48 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -881,13 +881,6 @@ pci_disable_device(struct pci_dev *dev)
 	if (atomic_sub_return(1, &dev->enable_cnt) != 0)
 		return;
 
-	if (dev->msi_enabled)
-		disable_msi_mode(dev, pci_find_capability(dev, PCI_CAP_ID_MSI),
-			PCI_CAP_ID_MSI);
-	if (dev->msix_enabled)
-		disable_msi_mode(dev, pci_find_capability(dev, PCI_CAP_ID_MSI),
-			PCI_CAP_ID_MSIX);
-
 	pci_read_config_word(dev, PCI_COMMAND, &pci_command);
 	if (pci_command & PCI_COMMAND_MASTER) {
 		pci_command &= ~PCI_COMMAND_MASTER;
@@ -1277,6 +1270,33 @@ pci_intx(struct pci_dev *pdev, int enable)
 	}
 }
 
+/**
+ * pci_msi_off - disables any msi or msix capabilities
+ * @pdev: the PCI device to operate on
+ * 
+ * If you want to use msi see pci_enable_msi and friends.
+ * This is a lower level primitive that allows us to disable
+ * msi operation at the device level.
+ */
+void pci_msi_off(struct pci_dev *dev)
+{
+	int pos;
+	u16 control;
+
+	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
+	if (pos) {
+		pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &control);
+		control &= ~PCI_MSI_FLAGS_ENABLE;
+		pci_write_config_word(dev, pos + PCI_MSI_FLAGS, control);
+	}
+	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
+	if (pos) {
+		pci_read_config_word(dev, pos + PCI_MSIX_FLAGS, &control);
+		control &= ~PCI_MSIX_FLAGS_ENABLE;
+		pci_write_config_word(dev, pos + PCI_MSIX_FLAGS, control);
+	}
+}
+ 
 #ifndef HAVE_ARCH_PCI_SET_DMA_MASK
 /*
  * These can be overridden by arch-specific implementations
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index a4f2d58..ae7a975 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -46,10 +46,8 @@ extern struct rw_semaphore pci_bus_sem;
 extern unsigned int pci_pm_d3_delay;
 
 #ifdef CONFIG_PCI_MSI
-void disable_msi_mode(struct pci_dev *dev, int pos, int type);
 void pci_no_msi(void);
 #else
-static inline void disable_msi_mode(struct pci_dev *dev, int pos, int type) { }
 static inline void pci_no_msi(void) { }
 #endif
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 1e6eda2..e9f9d3b 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1415,8 +1415,8 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_E7525_MCH,	quir
  */
 static void __devinit quirk_pcie_pxh(struct pci_dev *dev)
 {
-	disable_msi_mode(dev, pci_find_capability(dev, PCI_CAP_ID_MSI),
-					PCI_CAP_ID_MSI);
+	pci_msi_off(dev);
+
 	dev->no_msi = 1;
 
 	printk(KERN_WARNING "PCI: PXH quirk detected, "
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2c4b684..78417e4 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -543,6 +543,7 @@ void pci_set_master(struct pci_dev *dev);
 int __must_check pci_set_mwi(struct pci_dev *dev);
 void pci_clear_mwi(struct pci_dev *dev);
 void pci_intx(struct pci_dev *dev, int enable);
+void pci_msi_off(struct pci_dev *dev);
 int pci_set_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask);
 void pci_update_resource(struct pci_dev *dev, struct resource *res, int resno);
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index 7a6d34e..f09cce2 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -292,9 +292,10 @@
 #define PCI_MSI_DATA_64		12	/* 16 bits of data for 64-bit devices */
 #define PCI_MSI_MASK_BIT	16	/* Mask bits register */
 
-/* MSI-X registers (these are at offset PCI_MSI_FLAGS) */
-#define PCI_MSIX_FLAGS_QSIZE	0x7FF
-#define PCI_MSIX_FLAGS_ENABLE	(1 << 15)
+/* MSI-X registers (these are at offset PCI_MSIX_FLAGS) */
+#define PCI_MSIX_FLAGS		2
+#define  PCI_MSIX_FLAGS_QSIZE	0x7FF
+#define  PCI_MSIX_FLAGS_ENABLE	(1 << 15)
 #define PCI_MSIX_FLAGS_BIRMASK	(7 << 0)
 #define PCI_MSIX_FLAGS_BITMASK	(1 << 0)
 
-- 
1.5.0.g53756

