Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbZK3Vvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbZK3Vvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbZK3Vvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:51:32 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:42724 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbZK3Vvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:51:31 -0500
From: Alex Williamson <alex.williamson@hp.com>
Subject: [PATCH v2] PCI: Always set prefetchable base/limit upper32 registers
To: jbarnes@virtuousgeek.org
Cc: yinghai@kernel.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, alex.williamson@hp.com
Date: Mon, 30 Nov 2009 14:51:44 -0700
Message-ID: <20091130214954.10845.23072.stgit@debian.lart>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prior to 1f82de10 we always initialized the upper 32bits of the
prefetchable memory window, regardless of the address range used.
Now we only touch it for a >32bit address, which means the upper32
registers remain whatever the BIOS initialized them too.

It's valid for the BIOS to set the upper32 base/limit to
0xffffffff/0x00000000, which makes us program prefetchable ranges
like 0xffffffffabc00000 - 0x00000000abc00000

Revert the chunk of 1f82de10 that made this conditional so we always
write the upper32 registers and remove now unused pref_mem64 variable.

Signed-off-by: Alex Williamson <alex.williamson@hp.com>
---

v2:
  Remove pref_mem64 as it's now unused.

 drivers/pci/setup-bus.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index cb1a027..dd58c6a 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -142,7 +142,6 @@ static void pci_setup_bridge(struct pci_bus *bus)
 	struct pci_dev *bridge = bus->self;
 	struct pci_bus_region region;
 	u32 l, bu, lu, io_upper16;
-	int pref_mem64;
 
 	if (pci_is_enabled(bridge))
 		return;
@@ -198,7 +197,6 @@ static void pci_setup_bridge(struct pci_bus *bus)
 	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, 0);
 
 	/* Set up PREF base/limit. */
-	pref_mem64 = 0;
 	bu = lu = 0;
 	pcibios_resource_to_bus(bridge, &region, bus->resource[2]);
 	if (bus->resource[2]->flags & IORESOURCE_PREFETCH) {
@@ -206,7 +204,6 @@ static void pci_setup_bridge(struct pci_bus *bus)
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
 		if (bus->resource[2]->flags & IORESOURCE_MEM_64) {
-			pref_mem64 = 1;
 			bu = upper_32_bits(region.start);
 			lu = upper_32_bits(region.end);
 			width = 16;
@@ -221,11 +218,9 @@ static void pci_setup_bridge(struct pci_bus *bus)
 	}
 	pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, l);
 
-	if (pref_mem64) {
-		/* Set the upper 32 bits of PREF base & limit. */
-		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
-		pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
-	}
+	/* Set the upper 32 bits of PREF base & limit. */
+	pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
+	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
 
 	pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, bus->bridge_ctl);
 }

