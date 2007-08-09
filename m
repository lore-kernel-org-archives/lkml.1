Return-Path: <linux-kernel-owner+w=401wt.eu-S965310AbXHINGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965310AbXHINGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 09:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935657AbXHINGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 09:06:38 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:64537 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935578AbXHINGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 09:06:36 -0400
Date: Thu, 9 Aug 2007 16:06:30 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [0/12] x86 Late merge bug fixes for 2.6.23
Message-ID: <20070809130630.GK3311@rhun.haifa.ibm.com>
References: <20070809241.425881000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809241.425881000@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 02:41:27PM +0200, Andi Kleen wrote:
> 
> Various simple bug fixes, no new features. Please review.  I plan to
> send them to Linus later.
> 
> I don't have anything else critical pending. If you believe a x86
> patch is critical and really needs to make .23 please send email.

We also need this fix for the current sysdata regression:

Subject: finish i386 and x86-64 sysdata conversion

This patch finishes the i386 and x86-64 ->sysdata conversion and
hopefully also fixes Riku's and Andy's observed bugs. It is based on
Yinghai Lu's and Andy Whitcroft's patches (thanks!) with some changes:

- introduce pci_scan_bus_with_sysdata() and use it instead of
  pci_scan_bus() where appropriate. pci_scan_bus_with_sysdata() will
  allocate the sysdata structure and then call pci_scan_bus().
- always allocate pci_sysdata dynamically. The whole point of this
  sysdata work is to make it easy to do root-bus specific things
  (e.g., support PCI domains and IOMMU's). I dislike using a default
  struct pci_sysdata in some places and a dynamically allocated
  pci_sysdata elsewhere - the potential for someone indavertantly
  changing the default structure is too high.
- this patch only makes the minimal changes necessary, i.e., the NUMA node is
  always initialized to -1. Patches to do the right thing with regards
  to the NUMA node can build on top of this (either add a 'node'
  parameter to pci_scan_bus_with_sysdata() or just update the node
  when it becomes known).

The patch was compile tested with various configurations (e.g., NUMAQ,
VISWS) and run-time tested on i386 and x86-64. Unfortunately none of
my machines exhibited the bugs so caveat emptor.

Andy, could you please see if this fixes the NUMA issues you've seen?
Riku, does this fix "pci=noacpi" on your laptop?

Comments appreciated. If this looks ok it should go into 2.6.23.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
Cc: riku.seppala@kymp.net
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Jeff Garzik <jeff@garzik.org>
---
 arch/i386/pci/common.c   |   23 +++++++++++++++++++++++
 arch/i386/pci/fixup.c    |    6 +++---
 arch/i386/pci/irq.c      |    5 +++--
 arch/i386/pci/legacy.c   |    2 +-
 arch/i386/pci/numa.c     |   15 +++++++++------
 arch/i386/pci/visws.c    |    4 ++--
 include/asm-i386/pci.h   |    3 +++
 include/asm-x86_64/pci.h |    2 ++
 8 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/arch/i386/pci/common.c b/arch/i386/pci/common.c
index 85503de..ebc6f3c 100644
--- a/arch/i386/pci/common.c
+++ b/arch/i386/pci/common.c
@@ -455,3 +455,26 @@ void pcibios_disable_device (struct pci_dev *dev)
 	if (!dev->msi_enabled && pcibios_disable_irq)
 		pcibios_disable_irq(dev);
 }
+
+struct pci_bus *pci_scan_bus_with_sysdata(int busno)
+{
+	struct pci_bus *bus = NULL;
+	struct pci_sysdata *sd;
+
+	/*
+	 * Allocate per-root-bus (not per bus) arch-specific data.
+	 * TODO: leak; this memory is never freed.
+	 * It's arguable whether it's worth the trouble to care.
+	 */
+	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
+	if (!sd) {
+		printk(KERN_ERR "PCI: OOM, skipping PCI bus %02x\n", busno);
+		return NULL;
+	}
+	sd->node = -1;
+	bus = pci_scan_bus(busno, &pci_root_ops, sd);
+	if (!bus)
+		kfree(sd);
+
+	return bus;
+}
diff --git a/arch/i386/pci/fixup.c b/arch/i386/pci/fixup.c
index e7306db..c82cbf4 100644
--- a/arch/i386/pci/fixup.c
+++ b/arch/i386/pci/fixup.c
@@ -25,9 +25,9 @@ static void __devinit pci_fixup_i450nx(struct pci_dev *d)
 		pci_read_config_byte(d, reg++, &subb);
 		DBG("i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno, suba, subb);
 		if (busno)
-			pci_scan_bus(busno, &pci_root_ops, NULL);	/* Bus A */
+			pci_scan_bus_with_sysdata(busno);	/* Bus A */
 		if (suba < subb)
-			pci_scan_bus(suba+1, &pci_root_ops, NULL);	/* Bus B */
+			pci_scan_bus_with_sysdata(suba+1);	/* Bus B */
 	}
 	pcibios_last_bus = -1;
 }
@@ -42,7 +42,7 @@ static void __devinit pci_fixup_i450gx(struct pci_dev *d)
 	u8 busno;
 	pci_read_config_byte(d, 0x4a, &busno);
 	printk(KERN_INFO "PCI: i440KX/GX host bridge %s: secondary bus %02x\n", pci_name(d), busno);
-	pci_scan_bus(busno, &pci_root_ops, NULL);
+	pci_scan_bus_with_sysdata(busno);
 	pcibios_last_bus = -1;
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82454GX, pci_fixup_i450gx);
diff --git a/arch/i386/pci/irq.c b/arch/i386/pci/irq.c
index f2cb942..665db06 100644
--- a/arch/i386/pci/irq.c
+++ b/arch/i386/pci/irq.c
@@ -138,8 +138,9 @@ static void __init pirq_peer_trick(void)
 	for(i = 1; i < 256; i++) {
 		if (!busmap[i] || pci_find_bus(0, i))
 			continue;
-		if (pci_scan_bus(i, &pci_root_ops, NULL))
-			printk(KERN_INFO "PCI: Discovered primary peer bus %02x [IRQ]\n", i);
+		if (pci_scan_bus_with_sysdata(i))
+			printk(KERN_INFO "PCI: Discovered primary peer "
+			       "bus %02x [IRQ]\n", i);
 	}
 	pcibios_last_bus = -1;
 }
diff --git a/arch/i386/pci/legacy.c b/arch/i386/pci/legacy.c
index 149a958..5565d70 100644
--- a/arch/i386/pci/legacy.c
+++ b/arch/i386/pci/legacy.c
@@ -26,7 +26,7 @@ static void __devinit pcibios_fixup_peer_bridges(void)
 			    l != 0x0000 && l != 0xffff) {
 				DBG("Found device at %02x:%02x [%04x]\n", n, devfn, l);
 				printk(KERN_INFO "PCI: Discovered peer bus %02x\n", n);
-				pci_scan_bus(n, &pci_root_ops, NULL);
+				pci_scan_bus_with_sysdata(n);
 				break;
 			}
 		}
diff --git a/arch/i386/pci/numa.c b/arch/i386/pci/numa.c
index adbe17a..f5f165f 100644
--- a/arch/i386/pci/numa.c
+++ b/arch/i386/pci/numa.c
@@ -96,10 +96,14 @@ static void __devinit pci_fixup_i450nx(struct pci_dev *d)
 		pci_read_config_byte(d, reg++, &suba);
 		pci_read_config_byte(d, reg++, &subb);
 		DBG("i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno, suba, subb);
-		if (busno)
-			pci_scan_bus(QUADLOCAL2BUS(quad,busno), &pci_root_ops, NULL);	/* Bus A */
-		if (suba < subb)
-			pci_scan_bus(QUADLOCAL2BUS(quad,suba+1), &pci_root_ops, NULL);	/* Bus B */
+		if (busno) {
+			/* Bus A */
+			pci_scan_bus_with_sysdata(QUADLOCAL2BUS(quad, busno));
+		}
+		if (suba < subb) {
+			/* Bus B */
+			pci_scan_bus_with_sysdata(QUADLOCAL2BUS(quad, suba+1));
+		}
 	}
 	pcibios_last_bus = -1;
 }
@@ -123,8 +127,7 @@ static int __init pci_numa_init(void)
 				continue;
 			printk("Scanning PCI bus %d for quad %d\n", 
 				QUADLOCAL2BUS(quad,0), quad);
-			pci_scan_bus(QUADLOCAL2BUS(quad,0), 
-				&pci_root_ops, NULL);
+			pci_scan_bus_with_sysdata(QUADLOCAL2BUS(quad, 0));
 		}
 	return 0;
 }
diff --git a/arch/i386/pci/visws.c b/arch/i386/pci/visws.c
index f1b486d..8ecb1c7 100644
--- a/arch/i386/pci/visws.c
+++ b/arch/i386/pci/visws.c
@@ -101,8 +101,8 @@ static int __init pcibios_init(void)
 		"bridge B (PIIX4) bus: %u\n", pci_bus1, pci_bus0);
 
 	raw_pci_ops = &pci_direct_conf1;
-	pci_scan_bus(pci_bus0, &pci_root_ops, NULL);
-	pci_scan_bus(pci_bus1, &pci_root_ops, NULL);
+	pci_scan_bus_with_sysdata(pci_bus0);
+	pci_scan_bus_with_sysdata(pci_bus1);
 	pci_fixup_irqs(visws_swizzle, visws_map_irq);
 	pcibios_resource_survey();
 	return 0;
diff --git a/include/asm-i386/pci.h b/include/asm-i386/pci.h
index d790343..4fcacc7 100644
--- a/include/asm-i386/pci.h
+++ b/include/asm-i386/pci.h
@@ -8,6 +8,9 @@ struct pci_sysdata {
 	int		node;		/* NUMA node */
 };
 
+/* scan a bus after allocating a pci_sysdata for it */
+extern struct pci_bus *pci_scan_bus_with_sysdata(int busno);
+
 #include <linux/mm.h>		/* for struct page */
 
 /* Can be used to override the logic in pci_scan_bus for skipping
diff --git a/include/asm-x86_64/pci.h b/include/asm-x86_64/pci.h
index 88926eb..5da8cb0 100644
--- a/include/asm-x86_64/pci.h
+++ b/include/asm-x86_64/pci.h
@@ -10,6 +10,8 @@ struct pci_sysdata {
 	void*		iommu;		/* IOMMU private data */
 };
 
+extern struct pci_bus *pci_scan_bus_with_sysdata(int busno);
+
 #ifdef CONFIG_CALGARY_IOMMU
 static inline void* pci_iommu(struct pci_bus *bus)
 {
-- 
1.5.2





