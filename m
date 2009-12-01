Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbZLAHE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbZLAHE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZLAHE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:04:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:32815 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbZLAHEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:04:55 -0500
Message-ID: <4B14BFDD.3020802@kernel.org>
Date: Mon, 30 Nov 2009 23:03:57 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Alex Williamson <alex.williamson@hp.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Grant Grundler <grundler@parisc-linux.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Alex Chiang <achiang@hp.com>
Subject: [PATCH] pci: fix bridge 64bit flag setting
References: <20091130212228.7555.43533.stgit@debian.lart>	 <4B143AE5.7040702@kernel.org> <1259617381.8949.281.camel@8530w.home>	 <4B143E83.6020105@kernel.org> <1259618496.8949.290.camel@8530w.home>	 <4B144346.50608@kernel.org> <1259619578.8949.295.camel@8530w.home>	 <4B1455FD.90002@kernel.org> <1259625224.8949.319.camel@8530w.home>	 <4B145C9D.70601@kernel.org> <1259632564.10482.10.camel@2710p.home>	 <4B147EE0.8080209@kernel.org>  <4B148485.3000107@kernel.org> <1259637804.10482.20.camel@2710p.home> <4B14B928.2000108@kernel.org>
In-Reply-To: <4B14B928.2000108@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alex found one system that one pci bridge pref mmio 64 is not set correctly.
aka, the upper32 base/limit is not cleaned.
he found that bridge is supporting 64 bit pref mmio, but device under that
does not support that. so that IORESOURCE_MEM_64 get cleared in pbus_size_mem()

the fix will be:
make pci_bridge_check_ranges() to store the PCI_PREF_RANGE_TYPE_64 in addition
to IORESOURCE_MEM_64. just like pci_read_bridge_bases()
and later will use that bit in  pci_setup_bridge_mmio_pref instead of
IORESOURCE_MEM_64.
also avoid touching upper32 regs if the bridge does not support 64bit pref.

Reported-by: Alex Williamson <alex.williamson@hp.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -289,7 +289,6 @@ static void pci_setup_bridge_mmio_pref(s
 	struct resource *res;
 	struct pci_bus_region region;
 	u32 l, bu, lu;
-	int pref_mem64;
 
 	/* Clear out the upper 32 bits of PREF limit.
 	   If PCI_PREF_BASE_UPPER32 was non-zero, this temporarily
@@ -297,7 +296,6 @@ static void pci_setup_bridge_mmio_pref(s
 	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, 0);
 
 	/* Set up PREF base/limit. */
-	pref_mem64 = 0;
 	bu = lu = 0;
 	res = bus->resource[2];
 	pcibios_resource_to_bus(bridge, &region, res);
@@ -305,7 +303,6 @@ static void pci_setup_bridge_mmio_pref(s
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
 		if (res->flags & IORESOURCE_MEM_64) {
-			pref_mem64 = 1;
 			bu = upper_32_bits(region.start);
 			lu = upper_32_bits(region.end);
 		}
@@ -317,7 +314,7 @@ static void pci_setup_bridge_mmio_pref(s
 	}
 	pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, l);
 
-	if (pref_mem64) {
+	if (res->flags & PCI_PREF_RANGE_TYPE_64) {
 		/* Set the upper 32 bits of PREF base & limit. */
 		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
 		pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
@@ -385,8 +382,10 @@ static void pci_bridge_check_ranges(stru
 	}
 	if (pmem) {
 		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
-		if ((pmem & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64)
+		if ((pmem & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64) {
 			b_res[2].flags |= IORESOURCE_MEM_64;
+			b_res[2].flags |= PCI_PREF_RANGE_TYPE_64;
+		}
 	}
 
 	/* double check if bridge does support 64 bit pref */
