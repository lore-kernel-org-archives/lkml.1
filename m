Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab0BCXkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 18:40:25 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:31155 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab0BCXkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 18:40:02 -0500
Subject: [PATCH v1 1/7] x86/PCI: remove IOH range fetching
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-pci@vger.kernel.org, Peter Haight <peterh@sapros.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Date: Wed, 03 Feb 2010 16:39:00 -0700
Message-ID: <20100203233900.10803.76562.stgit@bob.kio>
In-Reply-To: <20100203233617.10803.92102.stgit@bob.kio>
References: <20100203233617.10803.92102.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is Jeff Garrett's patch to remove intel_bus.c.  It's already in
Linus' tree (e8e06eae4ffd), but not yet in Jesse's tree.  It's only
here so the subsequent patches don't have to update intel_bus.c.
---

 arch/x86/pci/Makefile    |    2 -
 arch/x86/pci/intel_bus.c |   94 ----------------------------------------------
 2 files changed, 1 insertions(+), 95 deletions(-)
 delete mode 100644 arch/x86/pci/intel_bus.c


diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 564b008..39fba37 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -15,7 +15,7 @@ obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 
 obj-y				+= common.o early.o
 obj-y				+= amd_bus.o
-obj-$(CONFIG_X86_64)		+= bus_numa.o intel_bus.o
+obj-$(CONFIG_X86_64)		+= bus_numa.o
 
 ifeq ($(CONFIG_PCI_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/arch/x86/pci/intel_bus.c b/arch/x86/pci/intel_bus.c
deleted file mode 100644
index f81a2fa..0000000
--- a/arch/x86/pci/intel_bus.c
+++ /dev/null
@@ -1,94 +0,0 @@
-/*
- * to read io range from IOH pci conf, need to do it after mmconfig is there
- */
-
-#include <linux/delay.h>
-#include <linux/dmi.h>
-#include <linux/pci.h>
-#include <linux/init.h>
-#include <asm/pci_x86.h>
-
-#include "bus_numa.h"
-
-static inline void print_ioh_resources(struct pci_root_info *info)
-{
-	int res_num;
-	int busnum;
-	int i;
-
-	printk(KERN_DEBUG "IOH bus: [%02x, %02x]\n",
-			info->bus_min, info->bus_max);
-	res_num = info->res_num;
-	busnum = info->bus_min;
-	for (i = 0; i < res_num; i++) {
-		struct resource *res;
-
-		res = &info->res[i];
-		printk(KERN_DEBUG "IOH bus: %02x index %x %s: [%llx, %llx]\n",
-			busnum, i,
-			(res->flags & IORESOURCE_IO) ? "io port" :
-							"mmio",
-			res->start, res->end);
-	}
-}
-
-#define IOH_LIO			0x108
-#define IOH_LMMIOL		0x10c
-#define IOH_LMMIOH		0x110
-#define IOH_LMMIOH_BASEU	0x114
-#define IOH_LMMIOH_LIMITU	0x118
-#define IOH_LCFGBUS		0x11c
-
-static void __devinit pci_root_bus_res(struct pci_dev *dev)
-{
-	u16 word;
-	u32 dword;
-	struct pci_root_info *info;
-	u16 io_base, io_end;
-	u32 mmiol_base, mmiol_end;
-	u64 mmioh_base, mmioh_end;
-	int bus_base, bus_end;
-
-	/* some sys doesn't get mmconf enabled */
-	if (dev->cfg_size < 0x120)
-		return;
-
-	if (pci_root_num >= PCI_ROOT_NR) {
-		printk(KERN_DEBUG "intel_bus.c: PCI_ROOT_NR is too small\n");
-		return;
-	}
-
-	info = &pci_root_info[pci_root_num];
-	pci_root_num++;
-
-	pci_read_config_word(dev, IOH_LCFGBUS, &word);
-	bus_base = (word & 0xff);
-	bus_end = (word & 0xff00) >> 8;
-	sprintf(info->name, "PCI Bus #%02x", bus_base);
-	info->bus_min = bus_base;
-	info->bus_max = bus_end;
-
-	pci_read_config_word(dev, IOH_LIO, &word);
-	io_base = (word & 0xf0) << (12 - 4);
-	io_end = (word & 0xf000) | 0xfff;
-	update_res(info, io_base, io_end, IORESOURCE_IO, 0);
-
-	pci_read_config_dword(dev, IOH_LMMIOL, &dword);
-	mmiol_base = (dword & 0xff00) << (24 - 8);
-	mmiol_end = (dword & 0xff000000) | 0xffffff;
-	update_res(info, mmiol_base, mmiol_end, IORESOURCE_MEM, 0);
-
-	pci_read_config_dword(dev, IOH_LMMIOH, &dword);
-	mmioh_base = ((u64)(dword & 0xfc00)) << (26 - 10);
-	mmioh_end = ((u64)(dword & 0xfc000000) | 0x3ffffff);
-	pci_read_config_dword(dev, IOH_LMMIOH_BASEU, &dword);
-	mmioh_base |= ((u64)(dword & 0x7ffff)) << 32;
-	pci_read_config_dword(dev, IOH_LMMIOH_LIMITU, &dword);
-	mmioh_end |= ((u64)(dword & 0x7ffff)) << 32;
-	update_res(info, mmioh_base, mmioh_end, IORESOURCE_MEM, 0);
-
-	print_ioh_resources(info);
-}
-
-/* intel IOH */
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x342e, pci_root_bus_res);

