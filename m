Return-Path: <linux-kernel-owner+w=401wt.eu-S1760335AbYFKPHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335AbYFKPHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760016AbYFKPGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:06:43 -0400
Received: from ns.suse.de ([195.135.220.2]:60516 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760006AbYFKPGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:06:41 -0400
From: Stefan Assmann <sassmann@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, Olaf Dabrunz <od@suse.de>,
       Stefan Assmann <sassmann@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
       Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>
Subject: [PATCH 4/5] Add quirk to disable boot interrupt generation on intel 6300ESB
Date: Wed, 11 Jun 2008 16:35:16 +0200
Message-Id: <12131949181903-git-send-email-sassmann@suse.de>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12131949173532-git-send-email-sassmann@suse.de>
References: <12131949173532-git-send-email-sassmann@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Assmann <sassmann@suse.de>

Add a quirk to disable legacy boot interrupt generation on intel devices
that support disabling it.

This patch benefited from discussions with Alexander Graf, Torsten Duwe,
Ihno Krumreich, Daniel Gollub, Hannes Reinecke. The conclusions we drew
and the patch itself are the authors' responsibility alone.

Signed-off-by: Stefan Assmann <sassmann@suse.de>
Signed-off-by: Olaf Dabrunz <od@suse.de>
---
 drivers/pci/quirks.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index dabb563..c392f84 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1363,6 +1363,36 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x2609, quirk_intel_pcie_pm);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x260a, quirk_intel_pcie_pm);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x260b, quirk_intel_pcie_pm);
 
+#ifdef CONFIG_X86_IO_APIC
+/*
+ * On some chipsets we can disable the generation of legacy INTx boot
+ * interrupts.
+ */
+
+/*
+ * IO-APIC1 on 6300ESB generates boot interrupts, see intel order no
+ * 300641-004US, section 5.7.3.
+ */
+#define INTEL_6300_IOAPIC_ABAR		0x40
+#define INTEL_6300_DISABLE_BOOT_IRQ	(1<<14)
+
+static void quirk_disable_intel_boot_interrupt(struct pci_dev *dev)
+{
+	u16 pci_config_word;
+
+	if (noioapicquirk)
+		return;
+
+	pci_read_config_word(dev, INTEL_6300_IOAPIC_ABAR, &pci_config_word);
+	pci_config_word |= INTEL_6300_DISABLE_BOOT_IRQ;
+	pci_write_config_word(dev, INTEL_6300_IOAPIC_ABAR, pci_config_word);
+
+	printk(KERN_INFO "disabled boot interrupt on device 0x%04x:0x%04x\n",
+		dev->vendor, dev->device);
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ESB_10, 	quirk_disable_intel_boot_interrupt);
+#endif /* CONFIG_X86_IO_APIC */
+
 /*
  * Toshiba TC86C001 IDE controller reports the standard 8-byte BAR0 size
  * but the PIO transfers won't work if BAR0 falls at the odd 8 bytes.
-- 
1.5.2.4

