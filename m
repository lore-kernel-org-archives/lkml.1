Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbYFBNx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbYFBNx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758195AbYFBNwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:52:00 -0400
Received: from mail.suse.de ([195.135.220.2]:53240 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385AbYFBNv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:51:57 -0400
From: Olaf Dabrunz <od@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org,
       Olaf Dabrunz <od@suse.de>, Stefan Assmann <sassmann@suse.de>
Subject: [PATCH 5/7] disable AMD/ATI legacy boot interrupt generation
Date: Mon,  2 Jun 2008 14:45:05 +0200
Message-Id: <12124107073972-git-send-email-od@suse.de>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12124107071847-git-send-email-od@suse.de>
References: <12124107071847-git-send-email-od@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Dabrunz <od@suse.de>

Add quirks for several AMD/ATI chipsets to prevent generation of legacy boot
interrupts.

Signed-off-by: Olaf Dabrunz <od@suse.de>
Signed-off-by: Stefan Assmann <sassmann@suse.de>
---
 drivers/pci/quirks.c |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 93 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e2fed6c..090ce38 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1377,6 +1377,99 @@ int nobootirqquirk_setup(char *str)
 __setup("nobootirqquirk", nobootirqquirk_setup);
 
 /*
+ * disable boot interrupts on AMD and ATI chipsets
+ */
+#define PCI_X_MISC			0x40
+#define  PCI_X_AMD813X_NIOAMODE		(1<<0)
+static void quirk_disable_amd_813x_boot_interrupt(struct pci_dev *dev)
+{
+	u32 pci_x_misc;
+
+	if (nobootirqquirk)
+		return;
+
+	pci_read_config_dword(dev, PCI_X_MISC, &pci_x_misc);
+	pci_x_misc &= ~PCI_X_AMD813X_NIOAMODE;
+	pci_write_config_dword(dev, PCI_X_MISC, pci_x_misc);
+
+	printk(KERN_INFO "disabled boot interrupts on PCI device "
+			"0x%04x:0x%04x\n", dev->vendor, dev->device);
+}
+#undef PCI_X_MISC
+#undef PCI_X_AMD813X_NIOAMODE
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD,   PCI_DEVICE_ID_AMD_8131_BRIDGE, 	quirk_disable_amd_813x_boot_interrupt);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD,   PCI_DEVICE_ID_AMD_8132_BRIDGE, 	quirk_disable_amd_813x_boot_interrupt);
+
+#define PCI_AMD8111_PCI_IRQ_ROUTING	0x56
+static void quirk_disable_amd_8111_boot_interrupt(struct pci_dev *dev)
+{
+	u16 pci_irq_routing;
+
+	if (nobootirqquirk)
+		return;
+
+	pci_read_config_word(dev, PCI_AMD8111_PCI_IRQ_ROUTING,
+						&pci_irq_routing);
+	if (!pci_irq_routing) {
+		printk(KERN_INFO "boot interrupts on PCI "
+				"device 0x%04x:0x%04x were "
+				"already disabled\n",
+				dev->vendor, dev->device);
+		return;
+	}
+	pci_write_config_word(dev, PCI_AMD8111_PCI_IRQ_ROUTING, 0);
+	printk(KERN_INFO "disabled boot interrupts on PCI device "
+			"0x%04x:0x%04x\n", dev->vendor, dev->device);
+}
+#undef PCI_AMD8111_PCI_IRQ_ROUTING
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD,   PCI_DEVICE_ID_AMD_8111_SMBUS, 	quirk_disable_amd_8111_boot_interrupt);
+
+#define PCI_AMD_SB700S_FEATURES_ENABLE	0x64
+#define  PCI_AMD_SB700S_PIC_ENABLE	(1<<0)
+#define PIC_PCI_INTR_INDEX		0xC00
+#define PIC_PCI_INTR_DATA		0xC01
+#define CLEAR_PIC_IRQ_ROUTING(irq)					\
+	outb(irq, PIC_PCI_INTR_INDEX);					\
+	outb(0x00, PIC_PCI_INTR_DATA);
+static void quirk_disable_amd_sb700s_boot_interrupt(struct pci_dev *dev)
+{
+	u32 feature_enable;
+	u32 saved_feature_enable;
+
+	if (nobootirqquirk)
+		return;
+
+	pci_read_config_dword(dev, PCI_AMD_SB700S_FEATURES_ENABLE,
+						&feature_enable);
+	saved_feature_enable = feature_enable;
+	feature_enable |= PCI_AMD_SB700S_PIC_ENABLE;
+	pci_write_config_dword(dev, PCI_AMD_SB700S_FEATURES_ENABLE,
+						feature_enable);
+
+	CLEAR_PIC_IRQ_ROUTING(0x0);
+	CLEAR_PIC_IRQ_ROUTING(0x1);
+	CLEAR_PIC_IRQ_ROUTING(0x2);
+	CLEAR_PIC_IRQ_ROUTING(0x3);
+	CLEAR_PIC_IRQ_ROUTING(0x4);
+	CLEAR_PIC_IRQ_ROUTING(0x9);
+	CLEAR_PIC_IRQ_ROUTING(0xA);
+	CLEAR_PIC_IRQ_ROUTING(0xB);
+	CLEAR_PIC_IRQ_ROUTING(0xC);
+
+	pci_write_config_dword(dev, PCI_AMD_SB700S_FEATURES_ENABLE,
+						saved_feature_enable);
+
+	printk(KERN_INFO "disabled boot interrupts on PCI device "
+			"0x%04x:0x%04x\n", dev->vendor, dev->device);
+}
+#undef PCI_AMD_SB700S_FEATURES_ENABLE
+#undef PCI_AMD_SB700S_PIC_ENABLE
+#undef PIC_PCI_INTR_INDEX
+#undef PIC_PCI_INTR_DATA
+#undef CLEAR_PIC_IRQ_ROUTING
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ATI,   PCI_DEVICE_ID_ATI_IXP600_SMBUS, 	quirk_disable_amd_sb700s_boot_interrupt);
+
+/*
  * disabled boot interrupts on HT-1000
  */
 static void quirk_disable_broadcom_boot_interrupt(struct pci_dev *dev)
-- 
1.5.2.4

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

