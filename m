Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbYBJUqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbYBJUqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbYBJUqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:46:02 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:37009 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbYBJUqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:46:00 -0500
Date: Sun, 10 Feb 2008 13:45:57 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Tony Camuso <tcamuso@redhat.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [PATCH] Change pci_raw_ops to pci_raw_read/write
Message-ID: <20080210204556.GG5299@parisc-linux.org>
References: <20080129025615.GC20198@parisc-linux.org> <20080129030340.GE20198@parisc-linux.org> <86802c440802022330o771cf98btcf750c790668b6e9@mail.gmail.com> <47AB299D.4000500@redhat.com> <20080209124138.GA28967@parisc-linux.org> <86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com> <20080210072116.GA12375@kroah.com> <20080210145122.GC5299@parisc-linux.org> <86802c440802101216t3b04c0b4y89a05ac9a04a0ac5@mail.gmail.com> <alpine.LFD.1.00.0802101222560.2896@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="A6N2fC+uXW/VQSAv"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802101222560.2896@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 10, 2008 at 12:24:18PM -0800, Linus Torvalds wrote:
> On Sun, 10 Feb 2008, Yinghai Lu wrote:
> > >
> > > I suggest Ivan's patch be merged ASAP as it actually fixes bugs.
> > > This patch is just cleanup (and takes care of some future concerns).
> > 
> > your patch and Ivan's patch should be merged in one...
> 
> I really don't care whether they get merges as one or separately, but I 
> think it should be merged _now_ (-rc1 is already delayed), and I'd like to 
> see the final versions of both. Does anybody have them in a final 
> agreed-upon format (preferably with that oddness in quirk_intel_irqbalance 
> also fixed?)

I just looked at fixing that -- the reason seems to be that we don't
actually have the struct pci_dev at that point.  I can fix it, but I
think it's actually buggy.  I want to look at some chipset docs to
confirm that though.

I've attached the two patches that I believe are the ones we want.  We
can (and should) fix quirk_intel_irqbalance separately.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-Ivan-s-PCI-patch.patch"

>From fc1e24786c764bf7e7a73128f839b58a0559739c Mon Sep 17 00:00:00 2001
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Date: Mon, 14 Jan 2008 17:31:09 -0500
Subject: [PATCH] PCI x86: always use conf1 to access config space below 256 bytes

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
1.5.2.5


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-Change-pci_raw_ops-to-pci_raw_read-write.patch"

>From ad4c3f135cda6f5210735231d30ef8e9dbd58c7c Mon Sep 17 00:00:00 2001
From: Matthew Wilcox <matthew@wil.cx>
Date: Sun, 10 Feb 2008 09:45:28 -0500
Subject: [PATCH] Change pci_raw_ops to pci_raw_read/write

We want to allow different implementations of pci_raw_ops for standard
and extended config space on x86.  Rather than clutter generic code with
knowledge of this, we make pci_raw_ops private to x86 and use it to
implement the new raw interface -- raw_pci_read() and raw_pci_write().

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 arch/ia64/pci/pci.c               |   25 ++++++++-----------------
 arch/ia64/sn/pci/tioce_provider.c |   16 ++++++++--------
 arch/x86/kernel/quirks.c          |    2 +-
 arch/x86/pci/common.c             |   25 +++++++++++++++++++++++--
 arch/x86/pci/direct.c             |    4 ++--
 arch/x86/pci/fixup.c              |    6 ++++--
 arch/x86/pci/legacy.c             |    2 +-
 arch/x86/pci/mmconfig-shared.c    |    6 +++---
 arch/x86/pci/mmconfig_32.c        |   10 ++--------
 arch/x86/pci/mmconfig_64.c        |    8 +-------
 arch/x86/pci/pci.h                |   15 +++++++++++----
 arch/x86/pci/visws.c              |    3 ---
 drivers/acpi/osl.c                |   25 ++++++-------------------
 include/linux/pci.h               |   16 ++++++++--------
 14 files changed, 78 insertions(+), 85 deletions(-)

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 488e48a..8fd7e82 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -43,8 +43,7 @@
 #define PCI_SAL_EXT_ADDRESS(seg, bus, devfn, reg)	\
 	(((u64) seg << 28) | (bus << 20) | (devfn << 12) | (reg))
 
-static int
-pci_sal_read (unsigned int seg, unsigned int bus, unsigned int devfn,
+int raw_pci_read(unsigned int seg, unsigned int bus, unsigned int devfn,
 	      int reg, int len, u32 *value)
 {
 	u64 addr, data = 0;
@@ -68,8 +67,7 @@ pci_sal_read (unsigned int seg, unsigned int bus, unsigned int devfn,
 	return 0;
 }
 
-static int
-pci_sal_write (unsigned int seg, unsigned int bus, unsigned int devfn,
+int raw_pci_write(unsigned int seg, unsigned int bus, unsigned int devfn,
 	       int reg, int len, u32 value)
 {
 	u64 addr;
@@ -91,24 +89,17 @@ pci_sal_write (unsigned int seg, unsigned int bus, unsigned int devfn,
 	return 0;
 }
 
-static struct pci_raw_ops pci_sal_ops = {
-	.read =		pci_sal_read,
-	.write =	pci_sal_write
-};
-
-struct pci_raw_ops *raw_pci_ops = &pci_sal_ops;
-
-static int
-pci_read (struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
+static int pci_read(struct pci_bus *bus, unsigned int devfn, int where,
+							int size, u32 *value)
 {
-	return raw_pci_ops->read(pci_domain_nr(bus), bus->number,
+	return raw_pci_read(pci_domain_nr(bus), bus->number,
 				 devfn, where, size, value);
 }
 
-static int
-pci_write (struct pci_bus *bus, unsigned int devfn, int where, int size, u32 value)
+static int pci_write(struct pci_bus *bus, unsigned int devfn, int where,
+							int size, u32 value)
 {
-	return raw_pci_ops->write(pci_domain_nr(bus), bus->number,
+	return raw_pci_write(pci_domain_nr(bus), bus->number,
 				  devfn, where, size, value);
 }
 
diff --git a/arch/ia64/sn/pci/tioce_provider.c b/arch/ia64/sn/pci/tioce_provider.c
index e1a3e19..999f14f 100644
--- a/arch/ia64/sn/pci/tioce_provider.c
+++ b/arch/ia64/sn/pci/tioce_provider.c
@@ -752,13 +752,13 @@ tioce_kern_init(struct tioce_common *tioce_common)
 	 * Determine the secondary bus number of the port2 logical PPB.
 	 * This is used to decide whether a given pci device resides on
 	 * port1 or port2.  Note:  We don't have enough plumbing set up
-	 * here to use pci_read_config_xxx() so use the raw_pci_ops vector.
+	 * here to use pci_read_config_xxx() so use raw_pci_read().
 	 */
 
 	seg = tioce_common->ce_pcibus.bs_persist_segment;
 	bus = tioce_common->ce_pcibus.bs_persist_busnum;
 
-	raw_pci_ops->read(seg, bus, PCI_DEVFN(2, 0), PCI_SECONDARY_BUS, 1,&tmp);
+	raw_pci_read(seg, bus, PCI_DEVFN(2, 0), PCI_SECONDARY_BUS, 1,&tmp);
 	tioce_kern->ce_port1_secondary = (u8) tmp;
 
 	/*
@@ -799,11 +799,11 @@ tioce_kern_init(struct tioce_common *tioce_common)
 
 		/* mem base/limit */
 
-		raw_pci_ops->read(seg, bus, PCI_DEVFN(dev, 0),
+		raw_pci_read(seg, bus, PCI_DEVFN(dev, 0),
 				  PCI_MEMORY_BASE, 2, &tmp);
 		base = (u64)tmp << 16;
 
-		raw_pci_ops->read(seg, bus, PCI_DEVFN(dev, 0),
+		raw_pci_read(seg, bus, PCI_DEVFN(dev, 0),
 				  PCI_MEMORY_LIMIT, 2, &tmp);
 		limit = (u64)tmp << 16;
 		limit |= 0xfffffUL;
@@ -817,21 +817,21 @@ tioce_kern_init(struct tioce_common *tioce_common)
 		 * attributes.
 		 */
 
-		raw_pci_ops->read(seg, bus, PCI_DEVFN(dev, 0),
+		raw_pci_read(seg, bus, PCI_DEVFN(dev, 0),
 				  PCI_PREF_MEMORY_BASE, 2, &tmp);
 		base = ((u64)tmp & PCI_PREF_RANGE_MASK) << 16;
 
-		raw_pci_ops->read(seg, bus, PCI_DEVFN(dev, 0),
+		raw_pci_read(seg, bus, PCI_DEVFN(dev, 0),
 				  PCI_PREF_BASE_UPPER32, 4, &tmp);
 		base |= (u64)tmp << 32;
 
-		raw_pci_ops->read(seg, bus, PCI_DEVFN(dev, 0),
+		raw_pci_read(seg, bus, PCI_DEVFN(dev, 0),
 				  PCI_PREF_MEMORY_LIMIT, 2, &tmp);
 
 		limit = ((u64)tmp & PCI_PREF_RANGE_MASK) << 16;
 		limit |= 0xfffffUL;
 
-		raw_pci_ops->read(seg, bus, PCI_DEVFN(dev, 0),
+		raw_pci_read(seg, bus, PCI_DEVFN(dev, 0),
 				  PCI_PREF_LIMIT_UPPER32, 4, &tmp);
 		limit |= (u64)tmp << 32;
 
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 6ba33ca..1941482 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -27,7 +27,7 @@ static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
 	pci_write_config_byte(dev, 0xf4, config|0x2);
 
 	/* read xTPR register */
-	raw_pci_ops->read(0, 0, 0x40, 0x4c, 2, &word);
+	raw_pci_read(0, 0, 0x40, 0x4c, 2, &word);
 
 	if (!(word & (1 << 13))) {
 		dev_info(&dev->dev, "Intel E7520/7320/7525 detected; "
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 52deabc..b7c67a1 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -26,16 +26,37 @@ int pcibios_last_bus = -1;
 unsigned long pirq_table_addr;
 struct pci_bus *pci_root_bus;
 struct pci_raw_ops *raw_pci_ops;
+struct pci_raw_ops *raw_pci_ext_ops;
+
+int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
+						int reg, int len, u32 *val)
+{
+	if (reg < 256 && raw_pci_ops)
+		return raw_pci_ops->read(domain, bus, devfn, reg, len, val);
+	if (raw_pci_ext_ops)
+		return raw_pci_ext_ops->read(domain, bus, devfn, reg, len, val);
+	return -EINVAL;
+}
+
+int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
+						int reg, int len, u32 val)
+{
+	if (reg < 256 && raw_pci_ops)
+		return raw_pci_ops->write(domain, bus, devfn, reg, len, val);
+	if (raw_pci_ext_ops)
+		return raw_pci_ext_ops->write(domain, bus, devfn, reg, len, val);
+	return -EINVAL;
+}
 
 static int pci_read(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
 {
-	return raw_pci_ops->read(pci_domain_nr(bus), bus->number,
+	return raw_pci_read(pci_domain_nr(bus), bus->number,
 				 devfn, where, size, value);
 }
 
 static int pci_write(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 value)
 {
-	return raw_pci_ops->write(pci_domain_nr(bus), bus->number,
+	return raw_pci_write(pci_domain_nr(bus), bus->number,
 				  devfn, where, size, value);
 }
 
diff --git a/arch/x86/pci/direct.c b/arch/x86/pci/direct.c
index 431c9a5..42f3e4c 100644
--- a/arch/x86/pci/direct.c
+++ b/arch/x86/pci/direct.c
@@ -14,7 +14,7 @@
 #define PCI_CONF1_ADDRESS(bus, devfn, reg) \
 	(0x80000000 | (bus << 16) | (devfn << 8) | (reg & ~3))
 
-int pci_conf1_read(unsigned int seg, unsigned int bus,
+static int pci_conf1_read(unsigned int seg, unsigned int bus,
 			  unsigned int devfn, int reg, int len, u32 *value)
 {
 	unsigned long flags;
@@ -45,7 +45,7 @@ int pci_conf1_read(unsigned int seg, unsigned int bus,
 	return 0;
 }
 
-int pci_conf1_write(unsigned int seg, unsigned int bus,
+static int pci_conf1_write(unsigned int seg, unsigned int bus,
 			   unsigned int devfn, int reg, int len, u32 value)
 {
 	unsigned long flags;
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 74d30ff..a5ef5f5 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -215,7 +215,8 @@ static int quirk_aspm_offset[MAX_PCIEROOT << 3];
 
 static int quirk_pcie_aspm_read(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
 {
-	return raw_pci_ops->read(0, bus->number, devfn, where, size, value);
+	return raw_pci_read(pci_domain_nr(bus), bus->number,
+						devfn, where, size, value);
 }
 
 /*
@@ -231,7 +232,8 @@ static int quirk_pcie_aspm_write(struct pci_bus *bus, unsigned int devfn, int wh
 	if ((offset) && (where == offset))
 		value = value & 0xfffffffc;
 
-	return raw_pci_ops->write(0, bus->number, devfn, where, size, value);
+	return raw_pci_write(pci_domain_nr(bus), bus->number,
+						devfn, where, size, value);
 }
 
 static struct pci_ops quirk_pcie_aspm_ops = {
diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index 5565d70..e041ced 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -22,7 +22,7 @@ static void __devinit pcibios_fixup_peer_bridges(void)
 		if (pci_find_bus(0, n))
 			continue;
 		for (devfn = 0; devfn < 256; devfn += 8) {
-			if (!raw_pci_ops->read(0, n, devfn, PCI_VENDOR_ID, 2, &l) &&
+			if (!raw_pci_read(0, n, devfn, PCI_VENDOR_ID, 2, &l) &&
 			    l != 0x0000 && l != 0xffff) {
 				DBG("Found device at %02x:%02x [%04x]\n", n, devfn, l);
 				printk(KERN_INFO "PCI: Discovered peer bus %02x\n", n);
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 6b521d3..8d54df4 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -28,7 +28,7 @@ static int __initdata pci_mmcfg_resources_inserted;
 static const char __init *pci_mmcfg_e7520(void)
 {
 	u32 win;
-	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);
+	pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);
 
 	win = win & 0xf000;
 	if(win == 0x0000 || win == 0xf000)
@@ -53,7 +53,7 @@ static const char __init *pci_mmcfg_intel_945(void)
 
 	pci_mmcfg_config_num = 1;
 
-	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
+	pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
 
 	/* Enable bit */
 	if (!(pciexbar & 1))
@@ -118,7 +118,7 @@ static int __init pci_mmcfg_check_hostbridge(void)
 	int i;
 	const char *name;
 
-	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0, 4, &l);
+	pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0, 4, &l);
 	vendor = l & 0xffff;
 	device = (l >> 16) & 0xffff;
 
diff --git a/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
index 7b75e65..081816a 100644
--- a/arch/x86/pci/mmconfig_32.c
+++ b/arch/x86/pci/mmconfig_32.c
@@ -68,9 +68,6 @@ err:		*value = -1;
 		return -EINVAL;
 	}
 
-	if (reg < 256)
-		return pci_conf1_read(seg,bus,devfn,reg,len,value);
-
 	base = get_base_addr(seg, bus, devfn);
 	if (!base)
 		goto err;
@@ -104,9 +101,6 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 	if ((bus > 255) || (devfn > 255) || (reg > 4095))
 		return -EINVAL;
 
-	if (reg < 256)
-		return pci_conf1_write(seg,bus,devfn,reg,len,value);
-
 	base = get_base_addr(seg, bus, devfn);
 	if (!base)
 		return -EINVAL;
@@ -138,7 +132,7 @@ static struct pci_raw_ops pci_mmcfg = {
 
 int __init pci_mmcfg_arch_init(void)
 {
-	printk(KERN_INFO "PCI: Using MMCONFIG\n");
-	raw_pci_ops = &pci_mmcfg;
+	printk(KERN_INFO "PCI: Using MMCONFIG for extended config space\n");
+	raw_pci_ext_ops = &pci_mmcfg;
 	return 1;
 }
diff --git a/arch/x86/pci/mmconfig_64.c b/arch/x86/pci/mmconfig_64.c
index c4cf318..9207fd4 100644
--- a/arch/x86/pci/mmconfig_64.c
+++ b/arch/x86/pci/mmconfig_64.c
@@ -58,9 +58,6 @@ err:		*value = -1;
 		return -EINVAL;
 	}
 
-	if (reg < 256)
-		return pci_conf1_read(seg,bus,devfn,reg,len,value);
-
 	addr = pci_dev_base(seg, bus, devfn);
 	if (!addr)
 		goto err;
@@ -89,9 +86,6 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 	if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095)))
 		return -EINVAL;
 
-	if (reg < 256)
-		return pci_conf1_write(seg,bus,devfn,reg,len,value);
-
 	addr = pci_dev_base(seg, bus, devfn);
 	if (!addr)
 		return -EINVAL;
@@ -150,6 +144,6 @@ int __init pci_mmcfg_arch_init(void)
 			return 0;
 		}
 	}
-	raw_pci_ops = &pci_mmcfg;
+	raw_pci_ext_ops = &pci_mmcfg;
 	return 1;
 }
diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
index 36cb44c..3431518 100644
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -85,10 +85,17 @@ extern spinlock_t pci_config_lock;
 extern int (*pcibios_enable_irq)(struct pci_dev *dev);
 extern void (*pcibios_disable_irq)(struct pci_dev *dev);
 
-extern int pci_conf1_write(unsigned int seg, unsigned int bus,
-			   unsigned int devfn, int reg, int len, u32 value);
-extern int pci_conf1_read(unsigned int seg, unsigned int bus,
-			  unsigned int devfn, int reg, int len, u32 *value);
+struct pci_raw_ops {
+	int (*read)(unsigned int domain, unsigned int bus, unsigned int devfn,
+						int reg, int len, u32 *val);
+	int (*write)(unsigned int domain, unsigned int bus, unsigned int devfn,
+						int reg, int len, u32 val);
+};
+
+extern struct pci_raw_ops *raw_pci_ops;
+extern struct pci_raw_ops *raw_pci_ext_ops;
+
+extern struct pci_raw_ops pci_direct_conf1;
 
 extern int pci_direct_probe(void);
 extern void pci_direct_init(int type);
diff --git a/arch/x86/pci/visws.c b/arch/x86/pci/visws.c
index 8ecb1c7..c2df4e9 100644
--- a/arch/x86/pci/visws.c
+++ b/arch/x86/pci/visws.c
@@ -13,9 +13,6 @@
 
 #include "pci.h"
 
-
-extern struct pci_raw_ops pci_direct_conf1;
-
 static int pci_visws_enable_irq(struct pci_dev *dev) { return 0; }
 static void pci_visws_disable_irq(struct pci_dev *dev) { }
 
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index a14501c..34b3386 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -200,15 +200,6 @@ acpi_status __init acpi_os_initialize(void)
 
 acpi_status acpi_os_initialize1(void)
 {
-	/*
-	 * Initialize PCI configuration space access, as we'll need to access
-	 * it while walking the namespace (bus 0 and root bridges w/ _BBNs).
-	 */
-	if (!raw_pci_ops) {
-		printk(KERN_ERR PREFIX
-		       "Access to PCI configuration space unavailable\n");
-		return AE_NULL_ENTRY;
-	}
 	kacpid_wq = create_singlethread_workqueue("kacpid");
 	kacpi_notify_wq = create_singlethread_workqueue("kacpi_notify");
 	BUG_ON(!kacpid_wq);
@@ -653,11 +644,9 @@ acpi_os_read_pci_configuration(struct acpi_pci_id * pci_id, u32 reg,
 		return AE_ERROR;
 	}
 
-	BUG_ON(!raw_pci_ops);
-
-	result = raw_pci_ops->read(pci_id->segment, pci_id->bus,
-				   PCI_DEVFN(pci_id->device, pci_id->function),
-				   reg, size, value);
+	result = raw_pci_read(pci_id->segment, pci_id->bus,
+				PCI_DEVFN(pci_id->device, pci_id->function),
+				reg, size, value);
 
 	return (result ? AE_ERROR : AE_OK);
 }
@@ -682,11 +671,9 @@ acpi_os_write_pci_configuration(struct acpi_pci_id * pci_id, u32 reg,
 		return AE_ERROR;
 	}
 
-	BUG_ON(!raw_pci_ops);
-
-	result = raw_pci_ops->write(pci_id->segment, pci_id->bus,
-				    PCI_DEVFN(pci_id->device, pci_id->function),
-				    reg, size, value);
+	result = raw_pci_write(pci_id->segment, pci_id->bus,
+				PCI_DEVFN(pci_id->device, pci_id->function),
+				reg, size, value);
 
 	return (result ? AE_ERROR : AE_OK);
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7215d3b..87195b6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -301,14 +301,14 @@ struct pci_ops {
 	int (*write)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 val);
 };
 
-struct pci_raw_ops {
-	int (*read)(unsigned int domain, unsigned int bus, unsigned int devfn,
-		    int reg, int len, u32 *val);
-	int (*write)(unsigned int domain, unsigned int bus, unsigned int devfn,
-		     int reg, int len, u32 val);
-};
-
-extern struct pci_raw_ops *raw_pci_ops;
+/*
+ * ACPI needs to be able to access PCI config space before we've done a
+ * PCI bus scan and created pci_bus structures.
+ */
+extern int raw_pci_read(unsigned int domain, unsigned int bus,
+			unsigned int devfn, int reg, int len, u32 *val);
+extern int raw_pci_write(unsigned int domain, unsigned int bus,
+			unsigned int devfn, int reg, int len, u32 val);
 
 struct pci_bus_region {
 	resource_size_t start;
-- 
1.5.2.5


--A6N2fC+uXW/VQSAv--
