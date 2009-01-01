Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbZAATDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbZAATDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 14:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbZAATC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 14:02:58 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:41078 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297AbZAATC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 14:02:58 -0500
Date: Thu, 1 Jan 2009 20:02:54 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: [PATCH 2.6.28 1/3] PCI-quirks: Unhide MCH5/6 memory controller configuration device
Message-ID: <20090101190254.GA22845@rere.qmqm.pl>
References: <20081223215030.GA32525@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081223215030.GA32525@rere.qmqm.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some BIOSes hide 'overflow' device (dev #6) for i82875P/PE chipsets.
The same happens for i82865P/PE. Add a quirk to enable this device.
This allows i82875 EDAC driver to bind to chipset's dev #6 and not
dev #0 as the latter is used by AGP driver.

This is rebased against 2.6.28 vanilla kernel, including trimming
of long lines.

After testing this patch for couple of days on my laptop (i82856P)
it looks like something is resetting device 0 (MCH) config register
0xF4 to zero and effectively disabling the device again. The delay
looks random to me. I can easily update the register using
'hexedit /sys/bus/pci/devices/0000\:00\:00.0/config' and see
correct values in lspci output afterwards. This is probably
BIOS's fault. This changes nothing as far as i82875P EDAC driver
is concerned as it has the same assumption that BIOS is well behaved.

In case some really broken BIOS is found, this can be wrapped around
some new Kconfig #ifdef.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

diff -urN a/drivers/pci/quirks.c b/drivers/pci/quirks.c
--- a/drivers/pci/quirks.c	2008-10-10 00:13:53.000000000 +0200
+++ b/drivers/pci/quirks.c	2008-12-06 22:18:46.000000000 +0100
@@ -1946,6 +1947,27 @@
 
 #endif /* CONFIG_PCI_MSI */
 
+/* Originally in EDAC sources for i82875P:
+ * Intel tells BIOS developers to hide device 6 which
+ * configures the overflow device access containing
+ * the DRBs - this is where we expose device 6.
+ * http://www.x86-secret.com/articles/tweak/pat/patsecrets-2.htm
+ */
+static void __devinit quirk_unhide_mch_dev6(struct pci_dev *dev)
+{
+	u8 reg;
+
+	if (pci_read_config_byte(dev, 0xF4, &reg) == 0 && !(reg & 0x02)) {
+		dev_info(&dev->dev, "Enabling MCH 'Overflow' Device\n");
+		pci_write_config_byte(dev, 0xF4, reg | 0x02);
+	}
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82865_HB,
+			 quirk_unhide_mch_dev6);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82875_HB,
+			 quirk_unhide_mch_dev6);
+
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f, struct pci_fixup *end)
 {
 	while (f < end) {
