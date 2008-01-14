Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbYANVd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbYANVd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYANVdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:33:50 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:55625 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYANVdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:33:49 -0500
Date: Mon, 14 Jan 2008 13:37:49 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 3/3] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG
 is used.
In-reply-to: <200801141336.35351.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200801141337.50194.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801141331.45898.yinghai.lu@sun.com>
 <200801141335.15558.yinghai.lu@sun.com> <200801141336.35351.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 3/3] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG is used.

reuse pci_cfg_space_size but skip check pci express and pci-x CAP ID.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

===================================================================
Index: linux-2.6/arch/x86/pci/fixup.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/fixup.c
+++ linux-2.6/arch/x86/pci/fixup.c
@@ -491,3 +491,17 @@ static void __devinit pci_siemens_interr
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SIEMENS, 0x0015,
 			  pci_siemens_interrupt_controller);
+
+/*
+ * Regular PCI devices have 256 bytes, but AMD Family 10h Opteron ext config
+ * have 4096 bytes.  Even if the device is capable, that doesn't mean we can
+ * access it.  Maybe we don't have a way to generate extended config space
+ * accesses.   So check it
+ */
+static void fam10h_pci_cfg_space_size(struct pci_dev *dev)
+{
+	dev->cfg_size = pci_cfg_space_size_ext(dev, 0);
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_ANY_ID,
+			 fam10h_pci_cfg_space_size);
Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -838,11 +838,14 @@ static void set_pcie_port_type(struct pc
  * reading the dword at 0x100 which must either be 0 or a valid extended
  * capability header.
  */
-int pci_cfg_space_size(struct pci_dev *dev)
+int pci_cfg_space_size_ext(struct pci_dev *dev, unsigned check_exp_pcix)
 {
 	int pos;
 	u32 status;
 
+	if (!check_exp_pcix)
+		goto skip;
+
 	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
 	if (!pos) {
 		pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
@@ -854,6 +857,7 @@ int pci_cfg_space_size(struct pci_dev *d
 			goto fail;
 	}
 
+ skip:
 	if (pci_read_config_dword(dev, 256, &status) != PCIBIOS_SUCCESSFUL)
 		goto fail;
 	if (status == 0xffffffff)
@@ -865,6 +869,11 @@ int pci_cfg_space_size(struct pci_dev *d
 	return PCI_CFG_SPACE_SIZE;
 }
 
+int pci_cfg_space_size(struct pci_dev *dev)
+{
+	return pci_cfg_space_size_ext(dev, 1);
+}
+
 static void pci_release_bus_bridge_dev(struct device *dev)
 {
 	kfree(dev);
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -639,6 +639,7 @@ int pci_scan_bridge(struct pci_bus *bus,
 
 void pci_walk_bus(struct pci_bus *top, void (*cb)(struct pci_dev *, void *),
 		  void *userdata);
+int pci_cfg_space_size_ext(struct pci_dev *dev, unsigned check_exp_pcix);
 int pci_cfg_space_size(struct pci_dev *dev);
 unsigned char pci_bus_max_busnr(struct pci_bus* bus);
 
