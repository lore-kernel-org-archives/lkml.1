Return-Path: <linux-kernel-owner+w=401wt.eu-S933794AbZIDQ7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794AbZIDQ7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933637AbZIDQ7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:59:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933785AbZIDQ7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:59:00 -0400
Date: Fri, 4 Sep 2009 12:55:45 -0400
From: Stefan Assmann <sassmann@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jcm@redhat.com, sdietrich@novell.com, linux-acpi@vger.kernel.org,
       andi@firstfloor.org, hpa@zytor.com,
       Stefan Assmann <sassmann@redhat.com>, mingo@elte.hu,
       Olaf.Dabrunz@gmx.net, ktokunag@redhat.com, tglx@linutronix.de,
       lenb@kernel.org
Message-Id: <20090904165545.26294.94612.sendpatchset@t500>
In-Reply-To: <20090904165525.26294.31112.sendpatchset@t500>
References: <20090904165525.26294.31112.sendpatchset@t500>
Subject: [RFC][PATCH 2/2] disable boot interrupts on Intel X58 and 55x0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable boot interrupts on Intel X58, 55x0 systems by setting the Disable PCI
INTx Routing to ICH bit (default is 0).

Disable PCI INTx Routing to ICH: When this bit is set, local INTx messages
received from the CB DMA/PCI Express ports of the IOH are not routed to legacy
ICH - they are either converted into MSI via the integrated I/OxAPIC (if the
I/OxAPIC mask bit is clear in the appropriate entries) or cause no further action
(when mask bit is set). When this bit is clear, local INTx messages received from
the CB DMA/PCI Express ports of the IOH are routed to legacy ICH, provided the
corresponding mask bit in the IOAPIC is set.
See Intel document #321328-001, section 19.10.2.27.

Signed-off-by: Stefan Assmann <sassmann@redhat.com>
---

 drivers/pci/quirks.c    |   24 ++++++++++++++++++++++++
 include/linux/pci_ids.h |    1 +
 2 files changed, 25 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1635,6 +1635,30 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_IOAT_TBG9,	quirk_show_intel_qpi_conf_register);
 
 /*
+ * Disable boot interrupts on Intel X58, 55x0 (Tylersburg).
+ * See Intel document #321328-001, section 19.10.2.27.
+ * (Disable PCI INTx Routing to ICH)
+ */
+#define INTEL_X58_55x0_QPIPINTRC_OFFSET	0xe0
+#define INTEL_X58_55x0_QPIPINTRC_BIT	(1<<25)
+static void quirk_disable_intel_tylersburg_boot_interrupt(struct pci_dev *dev)
+{
+	u32 pci_config_dword;
+
+	if (noioapicquirk)
+		return;
+
+	pci_read_config_dword(dev, INTEL_X58_55x0_QPIPINTRC_OFFSET, &pci_config_dword);
+	pci_config_dword |= INTEL_X58_55x0_QPIPINTRC_BIT;
+	pci_write_config_dword(dev, INTEL_X58_55x0_QPIPINTRC_OFFSET, pci_config_dword);
+
+	printk(KERN_INFO "disabled boot interrupt on device 0x%04x:0x%04x\n",
+		dev->vendor, dev->device);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_QPI_TBG15,	quirk_disable_intel_tylersburg_boot_interrupt);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_QPI_TBG15,	quirk_disable_intel_tylersburg_boot_interrupt);
+
+/*
  * disable boot interrupts on HT-1000
  */
 #define BC_HT1000_FEATURE_REG		0x64
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2504,6 +2504,7 @@
 #define PCI_DEVICE_ID_INTEL_ICH9_7	0x2916
 #define PCI_DEVICE_ID_INTEL_ICH9_8	0x2918
 #define PCI_DEVICE_ID_INTEL_82855PM_HB	0x3340
+#define PCI_DEVICE_ID_INTEL_QPI_TBG15	0x3428
 #define PCI_DEVICE_ID_INTEL_IOAT_TBG4	0x3429
 #define PCI_DEVICE_ID_INTEL_IOAT_TBG5	0x342a
 #define PCI_DEVICE_ID_INTEL_IOAT_TBG6	0x342b
