Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbZFWHOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbZFWHOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZFWHOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:14:32 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:54577 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158AbZFWHON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:14:13 -0400
From: Len Brown <lenb@kernel.org>
To: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 7/8] SFI, PCI: Hook MMCONFIG
Date: Tue, 23 Jun 2009 03:14:05 -0400
Message-id: <ca453e5f6aaefb3e5e0cd1a6212e7de8bfd173ad.1245740912.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.3.3.334.g916e1
In-reply-to: <1245741246-6503-1-git-send-email-lenb@kernel.org>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
In-reply-to: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Logically, if ACPI table parsing doesn't find the MCFG,
then try SFI.  In reality, the systemw will be in either
ACPI or SFI mode, so only one of these routines will run.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/Kconfig               |    2 +-
 arch/x86/pci/mmconfig-shared.c |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 06341a5..1143088 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1838,7 +1838,7 @@ config PCI_DIRECT
 
 config PCI_MMCONFIG
 	def_bool y
-	depends on X86_32 && PCI && ACPI && (PCI_GOMMCONFIG || PCI_GOANY)
+	depends on X86_32 && PCI && (ACPI || SFI) && (PCI_GOMMCONFIG || PCI_GOANY)
 
 config PCI_OLPC
 	def_bool y
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 712443e..c09683d 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -13,6 +13,7 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/acpi.h>
+#include <linux/sfi_acpi.h>
 #include <linux/bitmap.h>
 #include <linux/sort.h>
 #include <asm/e820.h>
@@ -606,7 +607,8 @@ static void __init __pci_mmcfg_init(int early)
 	}
 
 	if (!known_bridge)
-		acpi_table_parse(ACPI_SIG_MCFG, pci_parse_mcfg);
+		if (acpi_table_parse(ACPI_SIG_MCFG, pci_parse_mcfg))
+			sfi_acpi_table_parse(ACPI_SIG_MCFG, NULL, NULL, 0, pci_parse_mcfg);
 
 	pci_mmcfg_reject_broken(early);
 
-- 
1.6.0.6

