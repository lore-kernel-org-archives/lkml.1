Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325Ab0A1SeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab0A1SeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 13:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755843Ab0A1SeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 13:34:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:58335 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844Ab0A1SeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 13:34:06 -0500
Message-ID: <4B61D7C4.1050405@kernel.org>
Date: Thu, 28 Jan 2010 10:30:28 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeff Garrett <jeff@jgarrett.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86/pci: print ioh resources only
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>	<201001261348.59508.rjw@sisk.pl>	<201001261032.37053.bjorn.helgaas@hp.com>	<201001261902.13911.rjw@sisk.pl>	<20100126101752.78196900@jbarnes-piketon>	<4B5F735B.2040308@kernel.org>	<alpine.LFD.2.00.1001271748300.3570@localhost.localdomain>	<20100127192409.79af96db@jbarnes-piketon>	<20100128040226.GB8964@jgarrett.org> <20100128082432.05a97ebc@jbarnes-piketon>
In-Reply-To: <20100128082432.05a97ebc@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


don't use them for peer pci root bus resource yet.
so could cross check _CRS results

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/intel_bus.c |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

Index: linux-2.6/arch/x86/pci/intel_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/intel_bus.c
+++ linux-2.6/arch/x86/pci/intel_bus.c
@@ -43,7 +43,7 @@ static void __devinit pci_root_bus_res(s
 {
 	u16 word;
 	u32 dword;
-	struct pci_root_info *info;
+	struct pci_root_info info;
 	u16 io_base, io_end;
 	u32 mmiol_base, mmiol_end;
 	u64 mmioh_base, mmioh_end;
@@ -53,30 +53,22 @@ static void __devinit pci_root_bus_res(s
 	if (dev->cfg_size < 0x120)
 		return;
 
-	if (pci_root_num >= PCI_ROOT_NR) {
-		printk(KERN_DEBUG "intel_bus.c: PCI_ROOT_NR is too small\n");
-		return;
-	}
-
-	info = &pci_root_info[pci_root_num];
-	pci_root_num++;
-
 	pci_read_config_word(dev, IOH_LCFGBUS, &word);
 	bus_base = (word & 0xff);
 	bus_end = (word & 0xff00) >> 8;
-	sprintf(info->name, "PCI Bus #%02x", bus_base);
-	info->bus_min = bus_base;
-	info->bus_max = bus_end;
+	sprintf(info.name, "PCI Bus #%02x", bus_base);
+	info.bus_min = bus_base;
+	info.bus_max = bus_end;
 
 	pci_read_config_word(dev, IOH_LIO, &word);
 	io_base = (word & 0xf0) << (12 - 4);
 	io_end = (word & 0xf000) | 0xfff;
-	update_res(info, io_base, io_end, IORESOURCE_IO, 0);
+	update_res(&info, io_base, io_end, IORESOURCE_IO, 0);
 
 	pci_read_config_dword(dev, IOH_LMMIOL, &dword);
 	mmiol_base = (dword & 0xff00) << (24 - 8);
 	mmiol_end = (dword & 0xff000000) | 0xffffff;
-	update_res(info, mmiol_base, mmiol_end, IORESOURCE_MEM, 0);
+	update_res(&info, mmiol_base, mmiol_end, IORESOURCE_MEM, 0);
 
 	pci_read_config_dword(dev, IOH_LMMIOH, &dword);
 	mmioh_base = ((u64)(dword & 0xfc00)) << (26 - 10);
@@ -85,9 +77,9 @@ static void __devinit pci_root_bus_res(s
 	mmioh_base |= ((u64)(dword & 0x7ffff)) << 32;
 	pci_read_config_dword(dev, IOH_LMMIOH_LIMITU, &dword);
 	mmioh_end |= ((u64)(dword & 0x7ffff)) << 32;
-	update_res(info, mmioh_base, mmioh_end, IORESOURCE_MEM, 0);
+	update_res(&info, mmioh_base, mmioh_end, IORESOURCE_MEM, 0);
 
-	print_ioh_resources(info);
+	print_ioh_resources(&info);
 }
 
 /* intel IOH */
