Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788Ab0A1EDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab0A1EDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 23:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932181Ab0A1EDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 23:03:30 -0500
Received: from jgarrett.org ([64.5.53.252]:33574 "EHLO jgarrett.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725Ab0A1ED1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 23:03:27 -0500
Date: Wed, 27 Jan 2010 22:02:26 -0600
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with
 pci=use_crs)
Message-ID: <20100128040226.GB8964@jgarrett.org>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
 <201001261348.59508.rjw@sisk.pl>
 <201001261032.37053.bjorn.helgaas@hp.com>
 <201001261902.13911.rjw@sisk.pl>
 <20100126101752.78196900@jbarnes-piketon>
 <4B5F735B.2040308@kernel.org>
 <alpine.LFD.2.00.1001271748300.3570@localhost.localdomain>
 <20100127192409.79af96db@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127192409.79af96db@jbarnes-piketon>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: jeff@jgarrett.org (Jeff Garrett)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 07:24:09PM -0800, Jesse Barnes wrote:
> On Wed, 27 Jan 2010 17:50:17 -0800 (PST)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Tue, 26 Jan 2010, Yinghai Lu wrote:
> > > 
> > > [PATCH] x86/pci: don't use ioh resource if only have one ioh
> > 
> > Please, no.
> > 
> > This patch is too ugly to live.
> > 
> > And it's totally unacceptable to probe every single possible PCI device 
> > for something like this.
> > 
> > If we don't know enough about the hardware workings of those Intel bridges 
> > to know when they are active and how they decode things, then please let's 
> > just disable intel_bus.c entirely.
> > 
> > There's no excuse for hacky tests like this.
> 
> Ok, we'll just kill it entirely then.  I'll send a patch tomorrow
> unless Yinghai beats me to it.

What about something like this (works for me, without pci=use_crs)?

---
    Remove intel_bus.c Intel-specific PCI/IOH logic
    
    Signed-off-by: Jeff Garrett <jeff@jgarrett.org>
---
 arch/x86/pci/Makefile    |    2 +-
 arch/x86/pci/intel_bus.c |   94 ----------------------------------------------
 2 files changed, 1 insertions(+), 95 deletions(-)

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
