Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480Ab0AZXnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab0AZXnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384Ab0AZXn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:27 -0500
Received: from kroah.org ([198.145.64.141]:35215 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab0AZXn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:26 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:25 2010
Message-Id: <20100126233925.207096060@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Williamson <alex.williamson@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@suse.de>
Subject: [33/98] PCI: Always set prefetchable base/limit upper32 registers
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Williamson <alex.williamson@hp.com>

commit 59353ea30e65ab3ae181d6175e3212e1361c3787 upstream.

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
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Rafael J. Wysocki <rjw@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/setup-bus.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -142,7 +142,6 @@ static void pci_setup_bridge(struct pci_
 	struct pci_dev *bridge = bus->self;
 	struct pci_bus_region region;
 	u32 l, bu, lu, io_upper16;
-	int pref_mem64;
 
 	if (pci_is_enabled(bridge))
 		return;
@@ -198,7 +197,6 @@ static void pci_setup_bridge(struct pci_
 	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, 0);
 
 	/* Set up PREF base/limit. */
-	pref_mem64 = 0;
 	bu = lu = 0;
 	pcibios_resource_to_bus(bridge, &region, bus->resource[2]);
 	if (bus->resource[2]->flags & IORESOURCE_PREFETCH) {
@@ -206,7 +204,6 @@ static void pci_setup_bridge(struct pci_
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
 		if (bus->resource[2]->flags & IORESOURCE_MEM_64) {
-			pref_mem64 = 1;
 			bu = upper_32_bits(region.start);
 			lu = upper_32_bits(region.end);
 			width = 16;
@@ -221,11 +218,9 @@ static void pci_setup_bridge(struct pci_
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


