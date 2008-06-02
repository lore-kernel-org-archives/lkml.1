Return-Path: <linux-kernel-owner+w=401wt.eu-S1762136AbYFBNxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762136AbYFBNxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757677AbYFBNwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:52:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:53238 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053AbYFBNv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:51:57 -0400
From: Olaf Dabrunz <od@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org,
       Olaf Dabrunz <od@suse.de>, Stefan Assmann <sassmann@suse.de>
Subject: [PATCH 3/7] disable legacy boot interrupt generation
Date: Mon,  2 Jun 2008 14:45:03 +0200
Message-Id: <12124107072533-git-send-email-od@suse.de>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12124107071847-git-send-email-od@suse.de>
References: <12124107071847-git-send-email-od@suse.de>
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
 drivers/pci/quirks.c    |   28 ++++++++++++++++++++++++++++
 include/linux/pci_ids.h |    1 +
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6173be5..8f09f8f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1377,6 +1377,34 @@ int nobootirqquirk_setup(char *str)
 __setup("nobootirqquirk", nobootirqquirk_setup);
 
 /*
+ * On some chipsets we can disable the generation of legacy INTx boot
+ * interrupts.
+ */
+#define PCI_IOAPIC_ALTERNATE_BASE_ADDRESS	0x40
+#define INTEL_6300_ESB_BOOT_INTERRUPT_ENABLE	(1<<14)
+static void quirk_disable_intel_boot_interrupt(struct pci_dev *dev)
+{
+	u16 cnf;
+
+	if (nobootirqquirk)
+		return;
+
+	pci_read_config_word(dev, PCI_IOAPIC_ALTERNATE_BASE_ADDRESS, &cnf);
+	/* this disables the boot interrupt even though it reads ENABLE */
+	cnf |= INTEL_6300_ESB_BOOT_INTERRUPT_ENABLE;
+	pci_write_config_word(dev, PCI_IOAPIC_ALTERNATE_BASE_ADDRESS, cnf);
+
+	printk(KERN_INFO "disabled boot interrupt on device 0x%04x:0x%04x\n",
+		dev->vendor, dev->device);
+}
+#undef PCI_IOAPIC_ALTERNATE_BASE_ADDRESS
+/*
+ * IO-APIC1 on 6300ESB generates boot interrupts, see intel order no
+ * 300641-004US, section 5.7.3.
+ */
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ESB_10, 	quirk_disable_intel_boot_interrupt);
+
+/*
  * Boot interrupts on some chipsets cannot be turned off. For these chipsets,
  * remap the original interrupt in the linux kernel to the boot interrupt, so
  * that a PCI device's interrupt handler is installed on the boot interrupt
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index c675399..b89616d 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2309,6 +2309,7 @@
 #define PCI_DEVICE_ID_INTEL_ESB_4	0x25a4
 #define PCI_DEVICE_ID_INTEL_ESB_5	0x25a6
 #define PCI_DEVICE_ID_INTEL_ESB_9	0x25ab
+#define PCI_DEVICE_ID_INTEL_ESB_10	0x25ac
 #define PCI_DEVICE_ID_INTEL_82820_HB	0x2500
 #define PCI_DEVICE_ID_INTEL_82820_UP_HB	0x2501
 #define PCI_DEVICE_ID_INTEL_82850_HB	0x2530
-- 
1.5.2.4

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

