Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbXEYEVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbXEYEVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 00:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbXEYEVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 00:21:10 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45051 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbXEYEVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 00:21:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@NineX.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       ninex@o2.pl, <linux-kernel@vger.kernel.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 1/2] msi: Invert the sense of the MSI enables.
References: <200705122146.l4CLkH6q012322@fire-2.osdl.org>
	<m1mz09p1t7.fsf@ebiederm.dsl.xmission.com>
	<20070513014622.c5702928.akpm@linux-foundation.org>
	<46470209.9000502@bellsouth.net> <46470515.50000@NineX.eu.org>
	<464707F7.6080600@bellsouth.net>
	<m1irawpwy2.fsf@ebiederm.dsl.xmission.com>
	<20070513204407.7ba35010@osprey.hogchain.net>
	<4647FA38.3090108@NineX.eu.org> <46480EA5.40400@NineX.eu.org>
	<20070514053406.478bf93f@osprey.hogchain.net>
	<m1d513oddj.fsf@ebiederm.dsl.xmission.com>
	<20070514093829.377e04bc@osprey.hogchain.net>
	<m18xbrnyxi.fsf@ebiederm.dsl.xmission.com>
	<20070514160005.627435e3@osprey.hogchain.net>
	<m1odkmmft4.fsf@ebiederm.dsl.xmission.com>
	<20070515212200.517fcba2@osprey.hogchain.net>
	<m14pmcmz8r.fsf@ebiederm.dsl.xmission.com>
	<20070516185225.3f3ac082@osprey.hogchain.net>
	<m1sl9wl28m.fsf@ebiederm.dsl.xmission.com>
	<20070522204103.134bf5a2@osprey.hogchain.net>
Date: Thu, 24 May 2007 22:19:09 -0600
In-Reply-To: <20070522204103.134bf5a2@osprey.hogchain.net> (Jay Cliburn's
	message of "Tue, 22 May 2007 20:41:03 -0500")
Message-ID: <m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Currently we blacklist known bad msi configurations which means we
keep getting MSI enabled on chipsets that either do not support MSI,
or MSI is implemented improperly.  Since the normal IRQ routing
mechanism seems to works even when MSI does not, this is a bad default
and causes non-functioning systems for no good reason.

So this patch inverts the sense of the MSI bus flag to only enable
MSI on known good systems.  I am seeding that list with the set of
chipsets with an enabled hypertransport MSI mapping capability.  Which
is as close as I can come to an generic MSI enable.  So for actually
using MSI this patch is a regression, but for just having MSI enabled
in the kernel by default things should just work with this patch
applied.

People can still enable MSI on a per bus level for testing by writing
to sysfs so discovering chipsets that actually work (assuming we are
using modular drivers) should be pretty straight forward.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 Documentation/MSI-HOWTO.txt |   30 +++++++++++++------
 drivers/pci/msi.c           |   19 ++++++++----
 drivers/pci/pci-sysfs.c     |    6 ++--
 drivers/pci/quirks.c        |   66 ++++---------------------------------------
 include/linux/pci.h         |    2 +-
 5 files changed, 42 insertions(+), 81 deletions(-)

diff --git a/Documentation/MSI-HOWTO.txt b/Documentation/MSI-HOWTO.txt
index 0d82407..81f4e18 100644
--- a/Documentation/MSI-HOWTO.txt
+++ b/Documentation/MSI-HOWTO.txt
@@ -485,21 +485,31 @@ single device.  This may be achieved by either not calling pci_enable_msi()
 or all, or setting the pci_dev->no_msi flag before (most of the time
 in a quirk).
 
-6.2. Disabling MSI below a bridge
-
-The vast majority of MSI quirks are required by PCI bridges not
-being able to route MSI between busses. In this case, MSI have to be
-disabled on all devices behind this bridge. It is achieves by setting
-the PCI_BUS_FLAGS_NO_MSI flag in the pci_bus->bus_flags of the bridge
+6.2. Enabling MSI below a bridge
+
+Despite being standard, mandated by the pci-express spec, supported
+by plugin cards, and less hassle to deal with then irq routing tables
+not all hardware, and not all chipsets enable MSI, and not all
+motherboards enable MSI support in MSI supporting hardware.  So until
+a hardware specific test is implemted to test if MSI is supported and
+enabled on a piece of hardware we disable MSI support by default.
+This at least ensures users will have a working system using older
+mechanisms.
+
+So to enable MSI support on a particular chipset we need a MSI quirk
+that recognizes the chipset and test to see if MSI is enabled.  In
+this case, MSI has to be enabled on all bridges that are capable of
+transform MSI messages into irqs.  It is achieved by setting
+the PCI_BUS_FLAGS_MSI flag in the pci_bus->bus_flags of the bridge
 subordinate bus. There is no need to set the same flag on bridges that
-are below the broken bridge. When pci_enable_msi() is called to enable
-MSI on a device, pci_msi_supported() takes care of checking the NO_MSI
-flag in all parent busses of the device.
+are below the working bridge. When pci_enable_msi() is called to enable
+MSI on a device, pci_msi_supported() takes care of checking to ensure
+at least one parent buss supports MSI.
 
 Some bridges actually support dynamic MSI support enabling/disabling
 by changing some bits in their PCI configuration space (especially
 the Hypertransport chipsets such as the nVidia nForce and Serverworks
-HT2000). It may then be required to update the NO_MSI flag on the
+HT2000). It may then be required to update the MSI flag on the
 corresponding devices in the sysfs hierarchy. To enable MSI support
 on device "0000:00:0e", do:
 
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index d9cbd58..000c9ae 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -467,15 +467,20 @@ static int pci_msi_check_device(struct pci_dev* dev, int nvec, int type)
 	if (nvec < 1)
 		return -ERANGE;
 
-	/* Any bridge which does NOT route MSI transactions from it's
-	 * secondary bus to it's primary bus must set NO_MSI flag on
-	 * the secondary pci_bus.
-	 * We expect only arch-specific PCI host bus controller driver
-	 * or quirks for specific PCI bridges to be setting NO_MSI.
+	/* For pure pci bridges routing MSI traffic is just another
+	 * example of routing a small DMA transaction so it should be
+	 * no problem.  However getting MSI traffic from PCI to the
+	 * the non PCI part of the chipset is a problem.  So this
+	 * code checks to see if we have an upstream bus where
+	 * MSI is known to work.
+	 *
+	 * Only non pci to pci bridges are expected to set this flag.
 	 */
 	for (bus = dev->bus; bus; bus = bus->parent)
-		if (bus->bus_flags & PCI_BUS_FLAGS_NO_MSI)
-			return -EINVAL;
+		if (bus->bus_flags & PCI_BUS_FLAGS_MSI)
+			break;
+	if (!bus)
+		return -EINVAL;
 
 	ret = arch_msi_check_device(dev, nvec, type);
 	if (ret)
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 284e83a..4cebb60 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -160,7 +160,7 @@ msi_bus_show(struct device *dev, struct device_attribute *attr, char *buf)
 		return 0;
 
 	return sprintf (buf, "%u\n",
-			!(pdev->subordinate->bus_flags & PCI_BUS_FLAGS_NO_MSI));
+			!!(pdev->subordinate->bus_flags & PCI_BUS_FLAGS_MSI));
 }
 
 static ssize_t
@@ -178,13 +178,13 @@ msi_bus_store(struct device *dev, struct device_attribute *attr,
 		return count;
 
 	if (*buf == '0') {
-		pdev->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MSI;
+		pdev->subordinate->bus_flags &= ~PCI_BUS_FLAGS_MSI;
 		dev_warn(&pdev->dev, "forced subordinate bus to not support MSI,"
 			 " bad things could happen.\n");
 	}
 
 	if (*buf == '1') {
-		pdev->subordinate->bus_flags &= ~PCI_BUS_FLAGS_NO_MSI;
+		pdev->subordinate->bus_flags |= PCI_BUS_FLAGS_MSI;
 		dev_warn(&pdev->dev, "forced subordinate bus to support MSI,"
 			 " bad things could happen.\n");
 	}
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6ccc2e9..f60c6c6 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1625,33 +1625,6 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_NVIDIA,  PCI_DEVICE_ID_NVIDIA_CK804_PCIE,
 			quirk_nvidia_ck804_pcie_aer_ext_cap);
 
 #ifdef CONFIG_PCI_MSI
-/* The Serverworks PCI-X chipset does not support MSI. We cannot easily rely
- * on setting PCI_BUS_FLAGS_NO_MSI in its bus flags because there are actually
- * some other busses controlled by the chipset even if Linux is not aware of it.
- * Instead of setting the flag on all busses in the machine, simply disable MSI
- * globally.
- */
-static void __init quirk_svw_msi(struct pci_dev *dev)
-{
-	pci_no_msi();
-	printk(KERN_WARNING "PCI: MSI quirk detected. MSI deactivated.\n");
-}
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_svw_msi);
-
-/* Disable MSI on chipsets that are known to not support it */
-static void __devinit quirk_disable_msi(struct pci_dev *dev)
-{
-	if (dev->subordinate) {
-		printk(KERN_WARNING "PCI: MSI quirk detected. "
-		       "PCI_BUS_FLAGS_NO_MSI set for %s subordinate bus.\n",
-		       pci_name(dev));
-		dev->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MSI;
-	}
-}
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8131_BRIDGE, quirk_disable_msi);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_msi);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_msi);
-
 /* Go through the list of Hypertransport capabilities and
  * return 1 if a HT MSI capability is found and enabled */
 static int __devinit msi_ht_cap_enabled(struct pci_dev *dev)
@@ -1677,43 +1650,16 @@ static int __devinit msi_ht_cap_enabled(struct pci_dev *dev)
 	return 0;
 }
 
-/* Check the hypertransport MSI mapping to know whether MSI is enabled or not */
+/* Enable MSI on hypertransport chipsets supporting MSI */
 static void __devinit quirk_msi_ht_cap(struct pci_dev *dev)
 {
-	if (dev->subordinate && !msi_ht_cap_enabled(dev)) {
-		printk(KERN_WARNING "PCI: MSI quirk detected. "
-		       "MSI disabled on chipset %s.\n",
-		       pci_name(dev));
-		dev->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MSI;
+	if (dev->subordinate && msi_ht_cap_enabled(dev)) {
+		printk(KERN_INFO "PCI: Enabled MSI on chipset %s.\n",
+			pci_name(dev));
+		dev->subordinate->bus_flags |= PCI_BUS_FLAGS_MSI;
 	}
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE,
-			quirk_msi_ht_cap);
+DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_msi_ht_cap);
 
-/* The nVidia CK804 chipset may have 2 HT MSI mappings.
- * MSI are supported if the MSI capability set in any of these mappings.
- */
-static void __devinit quirk_nvidia_ck804_msi_ht_cap(struct pci_dev *dev)
-{
-	struct pci_dev *pdev;
-
-	if (!dev->subordinate)
-		return;
 
-	/* check HT MSI cap on this chipset and the root one.
-	 * a single one having MSI is enough to be sure that MSI are supported.
-	 */
-	pdev = pci_get_slot(dev->bus, 0);
-	if (!pdev)
-		return;
-	if (!msi_ht_cap_enabled(dev) && !msi_ht_cap_enabled(pdev)) {
-		printk(KERN_WARNING "PCI: MSI quirk detected. "
-		       "MSI disabled on chipset %s.\n",
-		       pci_name(dev));
-		dev->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MSI;
-	}
-	pci_dev_put(pdev);
-}
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_CK804_PCIE,
-			quirk_nvidia_ck804_msi_ht_cap);
 #endif /* CONFIG_PCI_MSI */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index fbf3766..468d761 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -111,7 +111,7 @@ enum pcie_reset_state {
 
 typedef unsigned short __bitwise pci_bus_flags_t;
 enum pci_bus_flags {
-	PCI_BUS_FLAGS_NO_MSI = (__force pci_bus_flags_t) 1,
+	PCI_BUS_FLAGS_MSI = (__force pci_bus_flags_t) 1,
 };
 
 struct pci_cap_saved_state {
-- 
1.5.1.1.181.g2de0

