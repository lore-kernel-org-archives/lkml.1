Return-Path: <linux-kernel-owner+w=401wt.eu-S932847AbZKFWYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbZKFWYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932750AbZKFWXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:49 -0500
Received: from kroah.org ([198.145.64.141]:57236 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744AbZKFWXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:47 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:52 2009
Message-Id: <20091106221552.428914681@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [97/99] powerpc: Fix some late PowerMac G5 with PCIe ATI graphics
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=powerpc-fix-some-late-powermac-g5-with-pcie-ati-graphics.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit cede3930f0ca6fef353fa01306c72a01420bd45e upstream.

A misconfiguration by the firmware of the U4 PCIe bridge on PowerMac G5
with the U4 bridge (latest generations, may also affect the iMac G5
"iSight") is causing us to re-assign the PCI BARs of the video card,
which can get it out of sync with the firmware, thus breaking offb.

This works around it by fixing up the bridge configuration properly
at boot time. It also fixes a bug where the firmware provides us with
an incorrect set of accessible regions in the device-tree.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/powermac/pci.c |   61 ++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h               |    1 
 2 files changed, 62 insertions(+)

--- a/arch/powerpc/platforms/powermac/pci.c
+++ b/arch/powerpc/platforms/powermac/pci.c
@@ -1286,3 +1286,64 @@ static void fixup_k2_sata(struct pci_dev
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SERVERWORKS, 0x0240, fixup_k2_sata);
 
+/*
+ * On U4 (aka CPC945) the PCIe root complex "P2P" bridge resource ranges aren't
+ * configured by the firmware. The bridge itself seems to ignore them but it
+ * causes problems with Linux which then re-assigns devices below the bridge,
+ * thus changing addresses of those devices from what was in the device-tree,
+ * which sucks when those are video cards using offb
+ *
+ * We could just mark it transparent but I prefer fixing up the resources to
+ * properly show what's going on here, as I have some doubts about having them
+ * badly configured potentially being an issue for DMA.
+ *
+ * We leave PIO alone, it seems to be fine
+ *
+ * Oh and there's another funny bug. The OF properties advertize the region
+ * 0xf1000000..0xf1ffffff as being forwarded as memory space. But that's
+ * actually not true, this region is the memory mapped config space. So we
+ * also need to filter it out or we'll map things in the wrong place.
+ */
+static void fixup_u4_pcie(struct pci_dev* dev)
+{
+	struct pci_controller *host = pci_bus_to_host(dev->bus);
+	struct resource *region = NULL;
+	u32 reg;
+	int i;
+
+	/* Only do that on PowerMac */
+	if (!machine_is(powermac))
+		return;
+
+	/* Find the largest MMIO region */
+	for (i = 0; i < 3; i++) {
+		struct resource *r = &host->mem_resources[i];
+		if (!(r->flags & IORESOURCE_MEM))
+			continue;
+		/* Skip the 0xf0xxxxxx..f2xxxxxx regions, we know they
+		 * are reserved by HW for other things
+		 */
+		if (r->start >= 0xf0000000 && r->start < 0xf3000000)
+			continue;
+		if (!region || (r->end - r->start) >
+		    (region->end - region->start))
+			region = r;
+	}
+	/* Nothing found, bail */
+	if (region == 0)
+		return;
+
+	/* Print things out */
+	printk(KERN_INFO "PCI: Fixup U4 PCIe bridge range: %pR\n", region);
+
+	/* Fixup bridge config space. We know it's a Mac, resource aren't
+	 * offset so let's just blast them as-is. We also know that they
+	 * fit in 32 bits
+	 */
+	reg = ((region->start >> 16) & 0xfff0) | (region->end & 0xfff00000);
+	pci_write_config_dword(dev, PCI_MEMORY_BASE, reg);
+	pci_write_config_dword(dev, PCI_PREF_BASE_UPPER32, 0);
+	pci_write_config_dword(dev, PCI_PREF_LIMIT_UPPER32, 0);
+	pci_write_config_dword(dev, PCI_PREF_MEMORY_BASE, 0);
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_APPLE, PCI_DEVICE_ID_APPLE_U4_PCIE, fixup_u4_pcie);
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -880,6 +880,7 @@
 #define PCI_DEVICE_ID_APPLE_SH_SUNGEM   0x0051
 #define PCI_DEVICE_ID_APPLE_U3L_AGP	0x0058
 #define PCI_DEVICE_ID_APPLE_U3H_AGP	0x0059
+#define PCI_DEVICE_ID_APPLE_U4_PCIE	0x005b
 #define PCI_DEVICE_ID_APPLE_IPID2_AGP	0x0066
 #define PCI_DEVICE_ID_APPLE_IPID2_ATA	0x0069
 #define PCI_DEVICE_ID_APPLE_IPID2_FW	0x006a


