Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbYA2C5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbYA2C5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 21:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbYA2C5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 21:57:46 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:55112 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbYA2C5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 21:57:44 -0500
Date: Mon, 28 Jan 2008 19:57:44 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: Tony Camuso <tcamuso@redhat.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: PCI x86: always use conf1 to access config space below 256 bytes
Message-ID: <20080129025743.GD20198@parisc-linux.org>
References: <20080114230448.GL9847@does.not.exist> <478CD8A5.5090608@myri.com> <20080115174643.GB28238@kroah.com> <20080115175641.GE18741@parisc-linux.org> <20080119165809.GB11553@colo.lackof.org> <479E1FA6.1030708@redhat.com> <20080128204431.GA15227@kroah.com> <20080128223141.GA31101@parisc-linux.org> <20080128225334.GD4720@kroah.com> <20080129025615.GC20198@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129025615.GC20198@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI x86: always use conf1 to access config space below 256 bytes

Thanks to Loic Prylli <loic@myri.com>, who originally proposed
this idea.

Always using legacy configuration mechanism for the legacy config space
and extended mechanism (mmconf) for the extended config space is
a simple and very logical approach. It's supposed to resolve all
known mmconf problems. It still allows per-device quirks (tweaking
dev->cfg_size). It also allows to get rid of mmconf fallback code.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 arch/x86/pci/mmconfig-shared.c |   35 -----------------------------------
 arch/x86/pci/mmconfig_32.c     |   22 +++++++++-------------
 arch/x86/pci/mmconfig_64.c     |   22 ++++++++++------------
 arch/x86/pci/pci.h             |    7 -------
 4 files changed, 19 insertions(+), 67 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 4df637e..6b521d3 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -22,42 +22,9 @@
 #define MMCONFIG_APER_MIN	(2 * 1024*1024)
 #define MMCONFIG_APER_MAX	(256 * 1024*1024)
 
-DECLARE_BITMAP(pci_mmcfg_fallback_slots, 32*PCI_MMCFG_MAX_CHECK_BUS);
-
 /* Indicate if the mmcfg resources have been placed into the resource table. */
 static int __initdata pci_mmcfg_resources_inserted;
 
-/* K8 systems have some devices (typically in the builtin northbridge)
-   that are only accessible using type1
-   Normally this can be expressed in the MCFG by not listing them
-   and assigning suitable _SEGs, but this isn't implemented in some BIOS.
-   Instead try to discover all devices on bus 0 that are unreachable using MM
-   and fallback for them. */
-static void __init unreachable_devices(void)
-{
-	int i, bus;
-	/* Use the max bus number from ACPI here? */
-	for (bus = 0; bus < PCI_MMCFG_MAX_CHECK_BUS; bus++) {
-		for (i = 0; i < 32; i++) {
-			unsigned int devfn = PCI_DEVFN(i, 0);
-			u32 val1, val2;
-
-			pci_conf1_read(0, bus, devfn, 0, 4, &val1);
-			if (val1 == 0xffffffff)
-				continue;
-
-			if (pci_mmcfg_arch_reachable(0, bus, devfn)) {
-				raw_pci_ops->read(0, bus, devfn, 0, 4, &val2);
-				if (val1 == val2)
-					continue;
-			}
-			set_bit(i + 32 * bus, pci_mmcfg_fallback_slots);
-			printk(KERN_NOTICE "PCI: No mmconfig possible on device"
-			       " %02x:%02x\n", bus, i);
-		}
-	}
-}
-
 static const char __init *pci_mmcfg_e7520(void)
 {
 	u32 win;
@@ -270,8 +237,6 @@ void __init pci_mmcfg_init(int type)
 		return;
 
 	if (pci_mmcfg_arch_init()) {
-		if (type == 1)
-			unreachable_devices();
 		if (known_bridge)
 			pci_mmcfg_insert_resources(IORESOURCE_BUSY);
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
diff --git a/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
index 1bf5816..7b75e65 100644
--- a/arch/x86/pci/mmconfig_32.c
+++ b/arch/x86/pci/mmconfig_32.c
@@ -30,10 +30,6 @@ static u32 get_base_addr(unsigned int seg, int bus, unsigned devfn)
 	struct acpi_mcfg_allocation *cfg;
 	int cfg_num;
 
-	if (seg == 0 && bus < PCI_MMCFG_MAX_CHECK_BUS &&
-	    test_bit(PCI_SLOT(devfn) + 32*bus, pci_mmcfg_fallback_slots))
-		return 0;
-
 	for (cfg_num = 0; cfg_num < pci_mmcfg_config_num; cfg_num++) {
 		cfg = &pci_mmcfg_config[cfg_num];
 		if (cfg->pci_segment == seg &&
@@ -68,13 +64,16 @@ static int pci_mmcfg_read(unsigned int seg, unsigned int bus,
 	u32 base;
 
 	if ((bus > 255) || (devfn > 255) || (reg > 4095)) {
-		*value = -1;
+err:		*value = -1;
 		return -EINVAL;
 	}
 
+	if (reg < 256)
+		return pci_conf1_read(seg,bus,devfn,reg,len,value);
+
 	base = get_base_addr(seg, bus, devfn);
 	if (!base)
-		return pci_conf1_read(seg,bus,devfn,reg,len,value);
+		goto err;
 
 	spin_lock_irqsave(&pci_config_lock, flags);
 
@@ -105,9 +104,12 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 	if ((bus > 255) || (devfn > 255) || (reg > 4095))
 		return -EINVAL;
 
+	if (reg < 256)
+		return pci_conf1_write(seg,bus,devfn,reg,len,value);
+
 	base = get_base_addr(seg, bus, devfn);
 	if (!base)
-		return pci_conf1_write(seg,bus,devfn,reg,len,value);
+		return -EINVAL;
 
 	spin_lock_irqsave(&pci_config_lock, flags);
 
@@ -134,12 +136,6 @@ static struct pci_raw_ops pci_mmcfg = {
 	.write =	pci_mmcfg_write,
 };
 
-int __init pci_mmcfg_arch_reachable(unsigned int seg, unsigned int bus,
-				    unsigned int devfn)
-{
-	return get_base_addr(seg, bus, devfn) != 0;
-}
-
 int __init pci_mmcfg_arch_init(void)
 {
 	printk(KERN_INFO "PCI: Using MMCONFIG\n");
diff --git a/arch/x86/pci/mmconfig_64.c b/arch/x86/pci/mmconfig_64.c
index 4095e4d..c4cf318 100644
--- a/arch/x86/pci/mmconfig_64.c
+++ b/arch/x86/pci/mmconfig_64.c
@@ -40,9 +40,7 @@ static char __iomem *get_virt(unsigned int seg, unsigned bus)
 static char __iomem *pci_dev_base(unsigned int seg, unsigned int bus, unsigned int devfn)
 {
 	char __iomem *addr;
-	if (seg == 0 && bus < PCI_MMCFG_MAX_CHECK_BUS &&
-		test_bit(32*bus + PCI_SLOT(devfn), pci_mmcfg_fallback_slots))
-		return NULL;
+
 	addr = get_virt(seg, bus);
 	if (!addr)
 		return NULL;
@@ -56,13 +54,16 @@ static int pci_mmcfg_read(unsigned int seg, unsigned int bus,
 
 	/* Why do we have this when nobody checks it. How about a BUG()!? -AK */
 	if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095))) {
-		*value = -1;
+err:		*value = -1;
 		return -EINVAL;
 	}
 
+	if (reg < 256)
+		return pci_conf1_read(seg,bus,devfn,reg,len,value);
+
 	addr = pci_dev_base(seg, bus, devfn);
 	if (!addr)
-		return pci_conf1_read(seg,bus,devfn,reg,len,value);
+		goto err;
 
 	switch (len) {
 	case 1:
@@ -88,9 +89,12 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 	if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095)))
 		return -EINVAL;
 
+	if (reg < 256)
+		return pci_conf1_write(seg,bus,devfn,reg,len,value);
+
 	addr = pci_dev_base(seg, bus, devfn);
 	if (!addr)
-		return pci_conf1_write(seg,bus,devfn,reg,len,value);
+		return -EINVAL;
 
 	switch (len) {
 	case 1:
@@ -126,12 +130,6 @@ static void __iomem * __init mcfg_ioremap(struct acpi_mcfg_allocation *cfg)
 	return addr;
 }
 
-int __init pci_mmcfg_arch_reachable(unsigned int seg, unsigned int bus,
-				    unsigned int devfn)
-{
-	return pci_dev_base(seg, bus, devfn) != NULL;
-}
-
 int __init pci_mmcfg_arch_init(void)
 {
 	int i;
diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
index ac56d39..36cb44c 100644
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -98,13 +98,6 @@ extern void pcibios_sort(void);
 
 /* pci-mmconfig.c */
 
-/* Verify the first 16 busses. We assume that systems with more busses
-   get MCFG right. */
-#define PCI_MMCFG_MAX_CHECK_BUS 16
-extern DECLARE_BITMAP(pci_mmcfg_fallback_slots, 32*PCI_MMCFG_MAX_CHECK_BUS);
-
-extern int __init pci_mmcfg_arch_reachable(unsigned int seg, unsigned int bus,
-					   unsigned int devfn);
 extern int __init pci_mmcfg_arch_init(void);
 
 /*

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
