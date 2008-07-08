Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbYGHQcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbYGHQcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYGHQcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:32:13 -0400
Received: from mx1.suse.de ([195.135.220.2]:37644 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbYGHQcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:32:11 -0400
From: Olaf Dabrunz <od@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, Olaf Dabrunz <od@suse.de>,
       Stefan Assmann <sassmann@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
       Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>
Subject: [PATCH 2/3] disable AMD/ATI legacy boot interrupt generation
Date: Tue,  8 Jul 2008 15:59:48 +0200
Message-Id: <12155255883516-git-send-email-od@suse.de>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12155255883170-git-send-email-od@suse.de>
References: <12155255883170-git-send-email-od@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Dabrunz <od@suse.de>

Add quirks for several AMD/ATI chipsets to prevent generation of legacy boot
interrupts.

Integrates a separate older quirk to make IO-APIC mode work on AMD 8131 rev. A0
and B0, which was due to an AMD erratum.

Signed-off-by: Olaf Dabrunz <od@suse.de>
Signed-off-by: Stefan Assmann <sassmann@suse.de>
---
 drivers/pci/quirks.c |   71 +++++++++++++++++++++++++++++++++++---------------
 1 files changed, 50 insertions(+), 21 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index b3ec3f8..2f78d6f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -602,27 +602,6 @@ static void __init quirk_ioapic_rmw(struct pci_dev *dev)
 		sis_apic_bug = 1;
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SI,	PCI_ANY_ID,			quirk_ioapic_rmw);
-
-#define AMD8131_revA0        0x01
-#define AMD8131_revB0        0x11
-#define AMD8131_MISC         0x40
-#define AMD8131_NIOAMODE_BIT 0
-static void quirk_amd_8131_ioapic(struct pci_dev *dev)
-{ 
-        unsigned char tmp;
-        
-        if (nr_ioapics == 0) 
-                return;
-
-        if (dev->revision == AMD8131_revA0 || dev->revision == AMD8131_revB0) {
-                dev_info(&dev->dev, "Fixing up AMD8131 IOAPIC mode\n");
-                pci_read_config_byte( dev, AMD8131_MISC, &tmp);
-                tmp &= ~(1 << AMD8131_NIOAMODE_BIT);
-                pci_write_config_byte( dev, AMD8131_MISC, tmp);
-        }
-} 
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8131_BRIDGE, quirk_amd_8131_ioapic);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8131_BRIDGE, quirk_amd_8131_ioapic);
 #endif /* CONFIG_X86_IO_APIC */
 
 /*
@@ -1449,6 +1428,56 @@ static void quirk_disable_broadcom_boot_interrupt(struct pci_dev *dev)
 			"0x%04x:0x%04x\n", dev->vendor, dev->device);
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS,   PCI_DEVICE_ID_SERVERWORKS_HT1000SB, 	quirk_disable_broadcom_boot_interrupt);
+
+/*
+ * disable boot interrupts on AMD and ATI chipsets
+ */
+/*
+ * NOIOAMODE needs to be disabled to disable "boot interrupts". For AMD 8131
+ * rev. A0 and B0, NOIOAMODE needs to be disabled anyway to fix IO-APIC mode
+ * (due to an erratum).
+ */
+#define AMD_813X_MISC			0x40
+#define AMD_813X_NOIOAMODE		(1<<0)
+
+static void quirk_disable_amd_813x_boot_interrupt(struct pci_dev *dev)
+{
+	u32 pci_config_dword;
+
+	if (noioapicquirk)
+		return;
+
+	pci_read_config_dword(dev, AMD_813X_MISC, &pci_config_dword);
+	pci_config_dword &= ~AMD_813X_NOIOAMODE;
+	pci_write_config_dword(dev, AMD_813X_MISC, pci_config_dword);
+
+	printk(KERN_INFO "disabled boot interrupts on PCI device "
+			"0x%04x:0x%04x\n", dev->vendor, dev->device);
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD,   PCI_DEVICE_ID_AMD_8131_BRIDGE, 	quirk_disable_amd_813x_boot_interrupt);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD,   PCI_DEVICE_ID_AMD_8132_BRIDGE, 	quirk_disable_amd_813x_boot_interrupt);
+
+#define AMD_8111_PCI_IRQ_ROUTING	0x56
+
+static void quirk_disable_amd_8111_boot_interrupt(struct pci_dev *dev)
+{
+	u16 pci_config_word;
+
+	if (noioapicquirk)
+		return;
+
+	pci_read_config_word(dev, AMD_8111_PCI_IRQ_ROUTING, &pci_config_word);
+	if (!pci_config_word) {
+		printk(KERN_INFO "boot interrupts on PCI device 0x%04x:0x%04x "
+				"already disabled\n",
+				dev->vendor, dev->device);
+		return;
+	}
+	pci_write_config_word(dev, AMD_8111_PCI_IRQ_ROUTING, 0);
+	printk(KERN_INFO "disabled boot interrupts on PCI device "
+			"0x%04x:0x%04x\n", dev->vendor, dev->device);
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD,   PCI_DEVICE_ID_AMD_8111_SMBUS, 	quirk_disable_amd_8111_boot_interrupt);
 #endif /* CONFIG_X86_IO_APIC */
 
 /*
-- 
1.5.2.4

