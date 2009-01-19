Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbZASAbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbZASAbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 19:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbZASAbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 19:31:04 -0500
Received: from ozlabs.org ([203.10.76.45]:33106 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084AbZASAbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 19:31:03 -0500
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, <linux-kernel@vger.kernel.org>,
       <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
       <linuxppc-dev@ozlabs.org>
Message-Id: <d1c931db79adf22f3506aa0343aec5361600b37e.1232325038.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] pci/msi: Use #ifdefs instead of weak functions
Date: Mon, 19 Jan 2009 11:31:00 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Weak functions aren't all they're cracked up to be. They lead to
incorrect binaries with some toolchains, they require us to have empty
functions we otherwise wouldn't, and the unused code is not elided
(as of gcc 4.3.2 anyway).

So replace the weak MSI arch hooks with the #define foo foo idiom. We no
longer need empty versions of arch_setup/teardown_msi_irq().

This is less source (by 1 line!), and results in smaller binaries too:

   text	   data	    bss	    dec	    hex	filename
9354300	1693916	 678424	11726640 b2ef30	build/powerpc/vmlinux-before
9354052	1693852	 678424	11726328 b2edf8	build/powerpc/vmlinux-after

Also smaller on x86_64 and arm (iop13xx).

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/include/asm/pci.h |    4 ++++
 arch/x86/include/asm/pci.h     |    3 +++
 drivers/pci/msi.c              |   26 +++++++++-----------------
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/include/asm/pci.h b/arch/powerpc/include/asm/pci.h
index 3548159..ba17d5d 100644
--- a/arch/powerpc/include/asm/pci.h
+++ b/arch/powerpc/include/asm/pci.h
@@ -114,6 +114,10 @@ extern int pci_domain_nr(struct pci_bus *bus);
 /* Decide whether to display the domain number in /proc */
 extern int pci_proc_domain(struct pci_bus *bus);
 
+/* MSI arch hooks */
+#define arch_setup_msi_irqs arch_setup_msi_irqs
+#define arch_teardown_msi_irqs arch_teardown_msi_irqs
+#define arch_msi_check_device arch_msi_check_device
 
 struct vm_area_struct;
 /* Map a range of PCI memory or I/O space for a device into user space */
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index a977de2..a0301bf 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -86,6 +86,9 @@ static inline void early_quirks(void) { }
 
 extern void pci_iommu_alloc(void);
 
+/* MSI arch hook */
+#define arch_setup_msi_irqs arch_setup_msi_irqs
+
 #endif  /* __KERNEL__ */
 
 #ifdef CONFIG_X86_32
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index b4a90ba..aa791db 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -27,20 +27,15 @@ static int pci_msi_enable = 1;
 
 /* Arch hooks */
 
-int __attribute__ ((weak))
-arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
+#ifndef arch_msi_check_device
+int arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
 {
 	return 0;
 }
+#endif
 
-int __attribute__ ((weak))
-arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *entry)
-{
-	return 0;
-}
-
-int __attribute__ ((weak))
-arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+#ifndef arch_setup_msi_irqs
+int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	struct msi_desc *entry;
 	int ret;
@@ -53,14 +48,10 @@ arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 
 	return 0;
 }
+#endif
 
-void __attribute__ ((weak)) arch_teardown_msi_irq(unsigned int irq)
-{
-	return;
-}
-
-void __attribute__ ((weak))
-arch_teardown_msi_irqs(struct pci_dev *dev)
+#ifndef arch_teardown_msi_irqs
+void arch_teardown_msi_irqs(struct pci_dev *dev)
 {
 	struct msi_desc *entry;
 
@@ -69,6 +60,7 @@ arch_teardown_msi_irqs(struct pci_dev *dev)
 			arch_teardown_msi_irq(entry->irq);
 	}
 }
+#endif
 
 static void __msi_set_enable(struct pci_dev *dev, int pos, int enable)
 {
-- 
1.5.5

