Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbYGHQdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbYGHQdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbYGHQcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:32:14 -0400
Received: from mail.suse.de ([195.135.220.2]:37656 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbYGHQcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:32:11 -0400
From: Olaf Dabrunz <od@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, Olaf Dabrunz <od@suse.de>,
       Stefan Assmann <sassmann@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
       Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>
Subject: [PATCH 1/3] Add quirk to disable boot interrupt generation on broadcom HT1000
Date: Tue,  8 Jul 2008 15:59:47 +0200
Message-Id: <12155255882405-git-send-email-od@suse.de>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12155255883170-git-send-email-od@suse.de>
References: <12155255883170-git-send-email-od@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Dabrunz <od@suse.de>

Signed-off-by: Olaf Dabrunz <od@suse.de>
Signed-off-by: Stefan Assmann <sassmann@suse.de>
---
 drivers/pci/quirks.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 292cf26..b3ec3f8 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1417,6 +1417,38 @@ static void quirk_disable_intel_boot_interrupt(struct pci_dev *dev)
 		dev->vendor, dev->device);
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ESB_10, 	quirk_disable_intel_boot_interrupt);
+
+/*
+ * disable boot interrupts on HT-1000
+ */
+#define BC_HT1000_FEATURE_REG		0x64
+#define BC_HT1000_PIC_REGS_ENABLE	(1<<0)
+#define BC_HT1000_MAP_IDX		0xC00
+#define BC_HT1000_MAP_DATA		0xC01
+
+static void quirk_disable_broadcom_boot_interrupt(struct pci_dev *dev)
+{
+	u32 pci_config_dword;
+	u8 irq;
+
+	if (noioapicquirk)
+		return;
+
+	pci_read_config_dword(dev, BC_HT1000_FEATURE_REG, &pci_config_dword);
+	pci_write_config_dword(dev, BC_HT1000_FEATURE_REG, pci_config_dword |
+			BC_HT1000_PIC_REGS_ENABLE);
+
+	for (irq = 0x10; irq < 0x10 + 32; irq++) {
+		outb(irq, BC_HT1000_MAP_IDX);
+		outb(0x00, BC_HT1000_MAP_DATA);
+	}
+
+	pci_write_config_dword(dev, BC_HT1000_FEATURE_REG, pci_config_dword);
+
+	printk(KERN_INFO "disabled boot interrupts on PCI device"
+			"0x%04x:0x%04x\n", dev->vendor, dev->device);
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS,   PCI_DEVICE_ID_SERVERWORKS_HT1000SB, 	quirk_disable_broadcom_boot_interrupt);
 #endif /* CONFIG_X86_IO_APIC */
 
 /*
-- 
1.5.2.4

