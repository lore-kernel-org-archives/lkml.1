Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbXILHiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbXILHiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbXILHij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:38:39 -0400
Received: from mylar.outflux.net ([69.93.193.226]:33825 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759432AbXILHig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:38:36 -0400
X-Greylist: delayed 1838 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Sep 2007 03:38:36 EDT
Date: Tue, 11 Sep 2007 23:41:34 -0700
From: Kees Cook <kees@ubuntu.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Collins <bcollins@ubuntu.com>, Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] pci: fix unterminated pci_device_id lists
Message-ID: <20070912064134.GO7910@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Outflux
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch against 2.6.23-rc6 fixes a couple drivers that do not
correctly terminate their pci_device_id lists.  This results in garbage
being spewed into modules.pcimap when the module happens to not have
28 NULL bytes following the table, and/or the last PCI ID is actually
truncated from the table when calculating the modules.alias PCI aliases,
cause those unfortunate device IDs to not auto-load.

Signed-off-by: Kees Cook <kees@ubuntu.com>
---
For example, cafe_nand...

drivers/mtd/nand/cafe_nand.c:
static struct pci_device_id cafe_nand_tbl[] = {
        { 0x11ab, 0x4100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MEMORY_FLASH << 8, 0xFFFF0 }
};

# should have 1 PCI alias, but we have none
$ modinfo cafe_nand | grep alias | wc -l
0

# should have 1 PCI map, but we have lots of trash
$ grep cafe_nand /lib/modules/$(uname -r)/modules.pcimap
modules.pcimap:cafe_nand            0x000011ab 0x00004100 0xffffffff 0xffffffff 0x00050100 0x000ffff0 0x0
modules.pcimap:cafe_nand            0x696d6974 0x0000676e 0x00000000 0x00000000 0x00000000 0x00000000 0x0
modules.pcimap:cafe_nand            0x00000003 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x0
modules.pcimap:cafe_nand            0x00000004 0x00000000 0x00000000 0x00000000 0x63656863 0x6363656b 0x0
modules.pcimap:cafe_nand            0x65640067 0x00677562 0x70696b73 0x00746262 0x64657375 0x4200616d 0x0
modules.pcimap:cafe_nand            0x000000bc 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x0

It may make sense to patch module-init-tools to correctly yell about
mismatches, as it has all the details when examining the ELF.

Note also, then p54 driver (in p54/prism54pci.c, not in mainline yet) suffers
from the same problem.


 linux-2.6.23-rc6/drivers/char/ipmi/ipmi_si_intf.c |    3 ++-
 linux-2.6.23-rc6/drivers/mtd/nand/cafe_nand.c     |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)
---
diff -uNrp linux-2.6.23-rc6~/drivers/char/ipmi/ipmi_si_intf.c linux-2.6.23-rc6/drivers/char/ipmi/ipmi_si_intf.c
--- linux-2.6.23-rc6~/drivers/char/ipmi/ipmi_si_intf.c	2007-09-11 23:17:13.000000000 -0700
+++ linux-2.6.23-rc6/drivers/char/ipmi/ipmi_si_intf.c	2007-09-11 23:21:51.000000000 -0700
@@ -2215,7 +2215,8 @@ static int ipmi_pci_resume(struct pci_de
 
 static struct pci_device_id ipmi_pci_devices[] = {
 	{ PCI_DEVICE(PCI_HP_VENDOR_ID, PCI_MMC_DEVICE_ID) },
-	{ PCI_DEVICE_CLASS(PCI_ERMC_CLASSCODE, PCI_ERMC_CLASSCODE_MASK) }
+	{ PCI_DEVICE_CLASS(PCI_ERMC_CLASSCODE, PCI_ERMC_CLASSCODE_MASK) },
+	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, ipmi_pci_devices);
 
diff -uNrp linux-2.6.23-rc6~/drivers/mtd/nand/cafe_nand.c linux-2.6.23-rc6/drivers/mtd/nand/cafe_nand.c
--- linux-2.6.23-rc6~/drivers/mtd/nand/cafe_nand.c	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.23-rc6/drivers/mtd/nand/cafe_nand.c	2007-09-11 23:22:11.000000000 -0700
@@ -816,7 +816,8 @@ static void __devexit cafe_nand_remove(s
 }
 
 static struct pci_device_id cafe_nand_tbl[] = {
-	{ 0x11ab, 0x4100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MEMORY_FLASH << 8, 0xFFFF0 }
+	{ 0x11ab, 0x4100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MEMORY_FLASH << 8, 0xFFFF0 },
+	{ 0, }
 };
 
 MODULE_DEVICE_TABLE(pci, cafe_nand_tbl);




-- 
Kees Cook
