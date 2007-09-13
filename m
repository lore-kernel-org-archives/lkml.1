Return-Path: <linux-kernel-owner+w=401wt.eu-S1761454AbXIMCM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761454AbXIMCM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 22:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbXIMCMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 22:12:51 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:38853 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbXIMCMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 22:12:50 -0400
Date: Wed, 12 Sep 2007 19:21:43 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG is
 used
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Greg KH <greg@kroah.com>,
       Martin Mares <mj@ucw.cz>, dean gaudet <dean@arctic.org>,
       Robert Richter <robert.richter@amd.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200709121921.43950.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG is used.

reuse pci_cfg_space_size but skip check pci express and pci-x CAP ID.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

 arch/i386/pci/fixup.c |   13 +++++++++++++
 drivers/pci/probe.c   |   11 ++++++++++-
 include/linux/pci.h   |    1 +
 3 files changed, 24 insertions(+), 1 deletion(-)

===================================================================
Index: linux-2.6/arch/i386/pci/fixup.c
===================================================================
--- linux-2.6.orig/arch/i386/pci/fixup.c	2007-09-12 19:00:56.000000000 -0700
+++ linux-2.6/arch/i386/pci/fixup.c	2007-09-12 19:01:32.000000000 -0700
@@ -444,3 +444,16 @@
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SIEMENS, 0x0015,
 			  pci_siemens_interrupt_controller);
+
+/**
+ * Regular PCI devices have 256 bytes, but AMD Family 10h Opteron ext config
+ * have 4096 bytes.  Even if the device is capable, that doesn't mean we can
+ * access it.  Maybe we don't have a way to generate extended config space
+ * accesses.   So check it
+ */
+static void fam10h_pci_cfg_space_size(struct pci_dev *dev)
+{
+        dev->cfg_size = pci_cfg_space_size_ext(dev, 0);
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_ANY_ID, fam10h_pci_cfg_space_size);
Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c	2007-09-12 19:00:56.000000000 -0700
+++ linux-2.6/drivers/pci/probe.c	2007-09-12 19:01:32.000000000 -0700
@@ -831,11 +831,14 @@
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
@@ -847,6 +850,7 @@
 			goto fail;
 	}
 
+ skip:
 	if (pci_read_config_dword(dev, 256, &status) != PCIBIOS_SUCCESSFUL)
 		goto fail;
 	if (status == 0xffffffff)
@@ -858,6 +862,11 @@
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
--- linux-2.6.orig/include/linux/pci.h	2007-09-12 19:00:56.000000000 -0700
+++ linux-2.6/include/linux/pci.h	2007-09-12 19:01:32.000000000 -0700
@@ -626,6 +626,7 @@
 
 void pci_walk_bus(struct pci_bus *top, void (*cb)(struct pci_dev *, void *),
 		  void *userdata);
+int pci_cfg_space_size_ext(struct pci_dev *dev, unsigned check_exp_pcix);
 int pci_cfg_space_size(struct pci_dev *dev);
 unsigned char pci_bus_max_busnr(struct pci_bus* bus);
 
