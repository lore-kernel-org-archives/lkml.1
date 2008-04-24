Return-Path: <linux-kernel-owner+w=401wt.eu-S1759461AbYDXMwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461AbYDXMwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 08:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756998AbYDXMv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 08:51:59 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:38583 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbYDXMv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 08:51:58 -0400
Date: Thu, 24 Apr 2008 16:51:55 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: fix legacy mode PCI IDE controllers
Message-ID: <20080424125155.GA5048@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Legacy IDE resources were never properly allocated on most
alpha platforms, so IDE expectedly stopped working after
commit 10f000a2fd805e8ccfe988e8615545467bb7f7df (generic
pci_enable_resources).

Always allocate "fixed" PCI resources before doing anything else;
remove Cypress IDE quirk, as it's a generic problem which is
handled in common PCI probe code.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/kernel/pci.c          |   22 +++++-----------------
 arch/alpha/kernel/sys_nautilus.c |    2 ++
 2 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/arch/alpha/kernel/pci.c b/arch/alpha/kernel/pci.c
index c107cc0..7835779 100644
--- a/arch/alpha/kernel/pci.c
+++ b/arch/alpha/kernel/pci.c
@@ -71,25 +71,13 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82378, quirk_i
 static void __init
 quirk_cypress(struct pci_dev *dev)
 {
-	/* The Notorious Cy82C693 chip.  */
-
-	/* The Cypress IDE controller doesn't support native mode, but it
-	   has programmable addresses of IDE command/control registers.
-	   This violates PCI specifications, confuses the IDE subsystem and
-	   causes resource conflicts between the primary HD_CMD register and
-	   the floppy controller.  Ugh.  Fix that.  */
-	if (dev->class >> 8 == PCI_CLASS_STORAGE_IDE) {
-		dev->resource[0].flags = 0;
-		dev->resource[1].flags = 0;
-	}
-
 	/* The Cypress bridge responds on the PCI bus in the address range
 	   0xffff0000-0xffffffff (conventional x86 BIOS ROM).  There is no
 	   way to turn this off.  The bridge also supports several extended
 	   BIOS ranges (disabled after power-up), and some consoles do turn
 	   them on.  So if we use a large direct-map window, or a large SG
 	   window, we must avoid the entire 0xfff00000-0xffffffff region.  */
-	else if (dev->class >> 8 == PCI_CLASS_BRIDGE_ISA) {
+	if (dev->class >> 8 == PCI_CLASS_BRIDGE_ISA) {
 		if (__direct_map_base + __direct_map_size >= 0xfff00000UL)
 			__direct_map_size = 0xfff00000UL - __direct_map_base;
 		else {
@@ -391,7 +379,7 @@ pcibios_set_master(struct pci_dev *dev)
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, 64);
 }
 
-static void __init
+void __init
 pcibios_claim_one_bus(struct pci_bus *b)
 {
 	struct pci_dev *dev;
@@ -405,7 +393,8 @@ pcibios_claim_one_bus(struct pci_bus *b)
 
 			if (r->parent || !r->start || !r->flags)
 				continue;
-			pci_claim_resource(dev, i);
+			if (pci_probe_only || (r->flags & IORESOURCE_PCI_FIXED))
+				pci_claim_resource(dev, i);
 		}
 	}
 
@@ -444,8 +433,7 @@ common_init_pci(void)
 		}
 	}
 
-	if (pci_probe_only)
-		pcibios_claim_console_setup();
+	pcibios_claim_console_setup();
 
 	pci_assign_unassigned_resources();
 	pci_fixup_irqs(alpha_mv.pci_swizzle, alpha_mv.pci_map_irq);
diff --git a/arch/alpha/kernel/sys_nautilus.c b/arch/alpha/kernel/sys_nautilus.c
index 920196b..a7f23b5 100644
--- a/arch/alpha/kernel/sys_nautilus.c
+++ b/arch/alpha/kernel/sys_nautilus.c
@@ -187,6 +187,7 @@ nautilus_machine_check(unsigned long vector, unsigned long la_ptr)
 }
 
 extern void free_reserved_mem(void *, void *);
+extern void pcibios_claim_one_bus(struct pci_bus *);
 
 static struct resource irongate_mem = {
 	.name	= "Irongate PCI MEM",
@@ -205,6 +206,7 @@ nautilus_init_pci(void)
 	/* Scan our single hose.  */
 	bus = pci_scan_bus(0, alpha_mv.pci_ops, hose);
 	hose->bus = bus;
+	pcibios_claim_one_bus(bus);
 
 	irongate = pci_get_bus_and_slot(0, 0);
 	bus->self = irongate;
