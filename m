Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbZDTBzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbZDTBzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 21:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbZDTBzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 21:55:25 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60097 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZDTBzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 21:55:23 -0400
Message-ID: <49EBD5F3.9090107@jp.fujitsu.com>
Date: Mon, 20 Apr 2009 10:54:59 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 2/2] pci, msi: Define PCI_MSI_MASK_32/64
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, improve readability

Define PCI_MSI_MASK_32/64 for 32/64bit devices, instead of using
implicit offset (-4), "PCI_MSI_MASK_BIT - 4" and "PCI_MSI_MASK_BIT".

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/msi.c        |    2 +-
 drivers/pci/msi.h        |    6 +++---
 include/linux/pci_regs.h |    3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 6f2e629..0f4d51b 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -381,7 +381,7 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
 	entry->msi_attrib.default_irq = dev->irq;	/* Save IOAPIC IRQ */
 	entry->msi_attrib.pos = pos;
 
-	entry->mask_pos = msi_mask_bits_reg(pos, entry->msi_attrib.is_64);
+	entry->mask_pos = msi_mask_reg(pos, entry->msi_attrib.is_64);
 	/* All MSIs are unmasked by default, Mask them all */
 	if (entry->msi_attrib.maskbit)
 		pci_read_config_dword(dev, entry->mask_pos, &entry->masked);
diff --git a/drivers/pci/msi.h b/drivers/pci/msi.h
index 4fed592..a066284 100644
--- a/drivers/pci/msi.h
+++ b/drivers/pci/msi.h
@@ -16,9 +16,9 @@
 #define msi_lower_address_reg(base)	(base + PCI_MSI_ADDRESS_LO)
 #define msi_upper_address_reg(base)	(base + PCI_MSI_ADDRESS_HI)
 #define msi_data_reg(base, is64bit)	\
-	( (is64bit == 1) ? base+PCI_MSI_DATA_64 : base+PCI_MSI_DATA_32 )
-#define msi_mask_bits_reg(base, is64bit) \
-	( (is64bit == 1) ? base+PCI_MSI_MASK_BIT : base+PCI_MSI_MASK_BIT-4)
+	(base + ((is64bit == 1) ? PCI_MSI_DATA_64 : PCI_MSI_DATA_32))
+#define msi_mask_reg(base, is64bit)	\
+	(base + ((is64bit == 1) ? PCI_MSI_MASK_64 : PCI_MSI_MASK_32))
 #define is_64bit_address(control)	(!!(control & PCI_MSI_FLAGS_64BIT))
 #define is_mask_bit_support(control)	(!!(control & PCI_MSI_FLAGS_MASKBIT))
 
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index ad57aa8..a81890a 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -295,8 +295,9 @@
 #define PCI_MSI_ADDRESS_LO	4	/* Lower 32 bits */
 #define PCI_MSI_ADDRESS_HI	8	/* Upper 32 bits (if PCI_MSI_FLAGS_64BIT set) */
 #define PCI_MSI_DATA_32		8	/* 16 bits of data for 32-bit devices */
+#define PCI_MSI_MASK_32		12	/* Mask bits register for 32-bit devices */
 #define PCI_MSI_DATA_64		12	/* 16 bits of data for 64-bit devices */
-#define PCI_MSI_MASK_BIT	16	/* Mask bits register */
+#define PCI_MSI_MASK_64		16	/* Mask bits register for 64-bit devices */
 
 /* MSI-X registers (these are at offset PCI_MSIX_FLAGS) */
 #define PCI_MSIX_FLAGS		2
-- 
1.6.2.2


