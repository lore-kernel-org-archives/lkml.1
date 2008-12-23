Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbYLWV6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbYLWV6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 16:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYLWV5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 16:57:54 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:51696 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbYLWV5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 16:57:53 -0500
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Dec 2008 16:57:53 EST
Date: Tue, 23 Dec 2008 22:50:31 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net
Subject: [PATCH] pci-quirks: Unhide 'Overflow' device on i828{6,7}5P/PE chipsets
Message-ID: <20081223215030.GA32525@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I found out from EDAC driver sources for i82875P some BIOSes for
i82875P/PE hide 'overflow' device 6. The same thing happens for
i82865P/PE chipsets.

After testing this patch for couple of days on my laptop (i82856P)
it looks like something is resetting device 0 (MCH) config register
0xF4 to zero and effectively disabling the device again. The delay
looks random to me. I can easily update the register using
'hexedit /sys/bus/pci/devices/0000\:00\:00.0/config' and see
correct values in lspci output afterwards.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

diff -urN linux-2.6.27.7-brfix1-nvpid/drivers/pci/quirks.c pci-quirks/drivers/pci/quirks.c
--- linux-2.6.27.7-brfix1-nvpid/drivers/pci/quirks.c	2008-10-10 00:13:53.000000000 +0200
+++ pci-quirks/drivers/pci/quirks.c	2008-12-06 22:18:46.000000000 +0100
@@ -2007,3 +2008,25 @@
 			quirk_msi_intx_disable_bug);
 
 #endif /* CONFIG_PCI_MSI */
+
+/* Originally in EDAC sources for i82875P:
+ * Intel tells BIOS developers to hide device 6 which
+ * configures the overflow device access containing
+ * the DRBs - this is where we expose device 6.
+ * http://www.x86-secret.com/articles/tweak/pat/patsecrets-2.htm
+ */
+static void __devinit quirk_unhide_mch_memory_controller_dev6(struct pci_dev *dev)
+{
+	u8 reg;
+
+	if (pci_read_config_byte(dev, 0xF4, &reg) == 0 && !(reg & 0x02)) {
+		dev_info(&dev->dev, "Enabling MCH Memory Controller 'Overflow' Device");
+		pci_write_config_byte(dev, 0xF4, reg | 0x02);
+	}
+}
+
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82865_HB,
+			quirk_unhide_mch_memory_controller_dev6);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82875_HB,
+			quirk_unhide_mch_memory_controller_dev6);
+
