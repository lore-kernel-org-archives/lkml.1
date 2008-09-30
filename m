Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbYI3DWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbYI3DWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYI3DUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:20:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:23303 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbYI3DUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:20:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,334,1220252400"; 
   d="scan'208";a="621752659"
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [RFC PATCH 10/12] e1000e: Use set_memory_ro()/set_memory_rw() to
	protect flash memory
To: linux-kernel@vger.kernel.org
Cc: linux-netdev@vger.kernel.org, kkeil@suse.de, agospoda@redhat.com,
       arjan@linux.intel.com, david.graham@intel.com, bruce.w.allan@intel.com,
       jkosina@suse.cz, john.ronciak@intel.com, tglx@linutronix.de,
       chris.jones@canonical.com, tim.gardner@intel.com, airlied@gmail.com,
       Bruce Allan <bruce.w.allan@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Date: Mon, 29 Sep 2008 20:20:08 -0700
Message-ID: <20080930032008.22950.69702.stgit@jbrandeb-bw.jf.intel.com>
In-Reply-To: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
User-Agent: StGIT/0.14.3.163.g06f9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Sep 2008 03:20:08.0387 (UTC) FILETIME=[70CAF130:01C922AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

A number of users have reported NVM corruption on various ICHx platform
LOMs.  One possible reasons for this could be unexpected and/or malicious
writes to the flash memory area mapped into kernel memory.  Once the
interface is up, there should be very few reads/writes of the mapped flash
memory.  This patch makes use of the x86 set_memory_*() functions to set
the mapped memory read-only and temporarily set it writable only when the
driver needs to write to it.  With the memory set read-only, any unexpected
write will be logged with a stack dump indicating the offending code.

Since these LOMs are only on x86 ICHx platforms, it does not matter that
this API is not yet available on other architectures, however it is
dependent on a previous patch that exports these function name symbols.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---

 drivers/net/e1000e/e1000.h   |    1 +
 drivers/net/e1000e/hw.h      |    1 +
 drivers/net/e1000e/ich8lan.c |   16 ++++++++++++++++
 drivers/net/e1000e/netdev.c  |   11 +++++++----
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/net/e1000e/e1000.h b/drivers/net/e1000e/e1000.h
index f80e43a..2a3a311 100644
--- a/drivers/net/e1000e/e1000.h
+++ b/drivers/net/e1000e/e1000.h
@@ -36,6 +36,7 @@
 #include <linux/workqueue.h>
 #include <linux/io.h>
 #include <linux/netdevice.h>
+#include <asm/cacheflush.h>
 
 #include "hw.h"
 
diff --git a/drivers/net/e1000e/hw.h b/drivers/net/e1000e/hw.h
index 74f263a..dd25009 100644
--- a/drivers/net/e1000e/hw.h
+++ b/drivers/net/e1000e/hw.h
@@ -863,6 +863,7 @@ struct e1000_hw {
 
 	u8 __iomem *hw_addr;
 	u8 __iomem *flash_address;
+	resource_size_t flash_len;
 
 	struct e1000_mac_info  mac;
 	struct e1000_fc_info   fc;
diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
index 57c6d2f..2b1aa2a 100644
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -176,12 +176,28 @@ static inline u32 __er32flash(struct e1000_hw *hw, unsigned long reg)
 
 static inline void __ew16flash(struct e1000_hw *hw, unsigned long reg, u16 val)
 {
+#ifdef _ASM_X86_CACHEFLUSH_H
+	set_memory_rw((unsigned long)hw->flash_address,
+	              hw->flash_len >> PAGE_SHIFT);
+#endif
 	writew(val, hw->flash_address + reg);
+#ifdef _ASM_X86_CACHEFLUSH_H
+	set_memory_ro((unsigned long)hw->flash_address,
+	              hw->flash_len >> PAGE_SHIFT);
+#endif
 }
 
 static inline void __ew32flash(struct e1000_hw *hw, unsigned long reg, u32 val)
 {
+#ifdef _ASM_X86_CACHEFLUSH_H
+	set_memory_rw((unsigned long)hw->flash_address,
+	              hw->flash_len >> PAGE_SHIFT);
+#endif
 	writel(val, hw->flash_address + reg);
+#ifdef _ASM_X86_CACHEFLUSH_H
+	set_memory_ro((unsigned long)hw->flash_address,
+	              hw->flash_len >> PAGE_SHIFT);
+#endif
 }
 
 #define er16flash(reg)		__er16flash(hw, (reg))
diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 57cead3..f04de5a 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -4402,7 +4402,6 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 	struct e1000_hw *hw;
 	const struct e1000_info *ei = e1000_info_tbl[ent->driver_data];
 	resource_size_t mmio_start, mmio_len;
-	resource_size_t flash_start, flash_len;
 
 	static int cards_found;
 	int i, err, pci_using_dac;
@@ -4472,11 +4471,15 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 
 	if ((adapter->flags & FLAG_HAS_FLASH) &&
 	    (pci_resource_flags(pdev, 1) & IORESOURCE_MEM)) {
-		flash_start = pci_resource_start(pdev, 1);
-		flash_len = pci_resource_len(pdev, 1);
-		adapter->hw.flash_address = ioremap(flash_start, flash_len);
+		adapter->hw.flash_len = pci_resource_len(pdev, 1);
+		adapter->hw.flash_address = ioremap(pci_resource_start(pdev, 1),
+		                                    adapter->hw.flash_len);
 		if (!adapter->hw.flash_address)
 			goto err_flashmap;
+#ifdef _ASM_X86_CACHEFLUSH_H
+		set_memory_ro((unsigned long)adapter->hw.flash_address,
+		              adapter->hw.flash_len >> PAGE_SHIFT);
+#endif
 	}
 
 	/* construct the net_device struct */

