Return-Path: <linux-kernel-owner+w=401wt.eu-S1756322AbZHNVdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbZHNVdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbZHNVdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:33:49 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:22610 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbZHNVdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:33:47 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 11/11] SFI: Hook PCI MMCONFIG
Date: Fri, 14 Aug 2009 16:38:15 -0400
Message-id: <dd0954bc5bbb20ca31bef49c656819a5c8085a0b.1250281826.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.4.122.g6ffd7
In-reply-to: <1250282295-25216-1-git-send-email-lenb@kernel.org>
References: <1250282295-25216-1-git-send-email-lenb@kernel.org>
In-reply-to: <0763223ab0ef5c0016b7a179c1acccaabbefea02.1250281826.git.len.brown@intel.com>
References: <0763223ab0ef5c0016b7a179c1acccaabbefea02.1250281826.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

First check ACPI, and if that fails, ask SFI to find the MCFG.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/Kconfig               |    2 +-
 arch/x86/pci/mmconfig-shared.c |    6 ++++--
 arch/x86/pci/mmconfig_32.c     |    2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d8ba424..4c92c91 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1880,7 +1880,7 @@ config PCI_DIRECT
 
 config PCI_MMCONFIG
 	def_bool y
-	depends on X86_32 && PCI && ACPI && (PCI_GOMMCONFIG || PCI_GOANY)
+	depends on X86_32 && PCI && (ACPI || SFI) && (PCI_GOMMCONFIG || PCI_GOANY)
 
 config PCI_OLPC
 	def_bool y
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index b707a01..602c172 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -13,10 +13,12 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/acpi.h>
+#include <linux/sfi_acpi.h>
 #include <linux/bitmap.h>
 #include <linux/sort.h>
 #include <asm/e820.h>
 #include <asm/pci_x86.h>
+#include <asm/acpi.h>
 
 #define PREFIX "PCI: "
 
@@ -493,7 +495,7 @@ static void __init pci_mmcfg_reject_broken(int early)
 		       (unsigned int)cfg->start_bus_number,
 		       (unsigned int)cfg->end_bus_number);
 
-		if (!early)
+		if (!early && !acpi_disabled)
 			valid = is_mmconf_reserved(is_acpi_reserved, addr, size, i, cfg, 0);
 
 		if (valid)
@@ -608,7 +610,7 @@ static void __init __pci_mmcfg_init(int early)
 	}
 
 	if (!known_bridge)
-		acpi_table_parse(ACPI_SIG_MCFG, pci_parse_mcfg);
+		acpi_sfi_table_parse(ACPI_SIG_MCFG, pci_parse_mcfg);
 
 	pci_mmcfg_reject_broken(early);
 
diff --git a/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
index 8b2d561..f10a7e9 100644
--- a/arch/x86/pci/mmconfig_32.c
+++ b/arch/x86/pci/mmconfig_32.c
@@ -11,9 +11,9 @@
 
 #include <linux/pci.h>
 #include <linux/init.h>
-#include <linux/acpi.h>
 #include <asm/e820.h>
 #include <asm/pci_x86.h>
+#include <acpi/acpi.h>
 
 /* Assume systems with more busses have correct MCFG */
 #define mmcfg_virt_addr ((void __iomem *) fix_to_virt(FIX_PCIE_MCFG))
-- 
1.6.0.6

