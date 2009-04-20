Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbZDTBza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbZDTBza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 21:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbZDTBzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 21:55:18 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60088 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZDTBzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 21:55:17 -0400
Message-ID: <49EBD5EC.4040905@jp.fujitsu.com>
Date: Mon, 20 Apr 2009 10:54:52 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 1/2] pci, msi: Remove unused/obsolete macros and definitions
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, spec compliance

This patch does:

 - Remove unused msi/msix_enable/disable macros.
   User should use msi/msix_set_enable() functions instead.

 - Remove unused msix_mask/unmask/pending macros.
   These macros are useless because they are not based on any of
   the PCI Local Bus Specifications properly.
   It seems that they were written based on a draft of PCI spec,
   and that the draft was the MSI-X ECN that underwent membership
   review in September 2002.
   (* In the draft, the size of a entry in MSI-X table was 64bit,
      containing 32bit message data and DWORD aligned lower address
      plus a pending bit and a mask bit.(30+1+1bit)  The higher
      address was placed in MSI-X capability structure and shared
      by all entries.)

 - Remove PCI_MSIX_FLAGS_BITMASK.
   This definition also come from the draft ECN.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/msi.h        |    8 +-------
 include/linux/pci_regs.h |    1 -
 2 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/msi.h b/drivers/pci/msi.h
index 71f4df2..4fed592 100644
--- a/drivers/pci/msi.h
+++ b/drivers/pci/msi.h
@@ -19,18 +19,12 @@
 	( (is64bit == 1) ? base+PCI_MSI_DATA_64 : base+PCI_MSI_DATA_32 )
 #define msi_mask_bits_reg(base, is64bit) \
 	( (is64bit == 1) ? base+PCI_MSI_MASK_BIT : base+PCI_MSI_MASK_BIT-4)
-#define msi_disable(control)		control &= ~PCI_MSI_FLAGS_ENABLE
 #define is_64bit_address(control)	(!!(control & PCI_MSI_FLAGS_64BIT))
 #define is_mask_bit_support(control)	(!!(control & PCI_MSI_FLAGS_MASKBIT))
 
 #define msix_table_offset_reg(base)	(base + 0x04)
 #define msix_pba_offset_reg(base)	(base + 0x08)
-#define msix_enable(control)	 	control |= PCI_MSIX_FLAGS_ENABLE
-#define msix_disable(control)	 	control &= ~PCI_MSIX_FLAGS_ENABLE
 #define msix_table_size(control) 	((control & PCI_MSIX_FLAGS_QSIZE)+1)
-#define multi_msix_capable		msix_table_size
-#define msix_unmask(address)	 	(address & ~PCI_MSIX_FLAGS_BITMASK)
-#define msix_mask(address)		(address | PCI_MSIX_FLAGS_BITMASK)
-#define msix_is_pending(address) 	(address & PCI_MSIX_FLAGS_PENDMASK)
+#define multi_msix_capable(control)	msix_table_size((control))
 
 #endif /* MSI_H */
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index e4d08c1..ad57aa8 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -304,7 +304,6 @@
 #define  PCI_MSIX_FLAGS_ENABLE	(1 << 15)
 #define  PCI_MSIX_FLAGS_MASKALL	(1 << 14)
 #define PCI_MSIX_FLAGS_BIRMASK	(7 << 0)
-#define PCI_MSIX_FLAGS_BITMASK	(1 << 0)
 
 /* CompactPCI Hotswap Register */
 
-- 
1.6.2.2


