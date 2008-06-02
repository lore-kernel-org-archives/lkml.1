Return-Path: <linux-kernel-owner+w=401wt.eu-S1761331AbYFBNwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761331AbYFBNwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbYFBNv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:51:58 -0400
Received: from mx1.suse.de ([195.135.220.2]:53239 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbYFBNv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:51:57 -0400
From: Olaf Dabrunz <od@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org,
       Olaf Dabrunz <od@suse.de>, Stefan Assmann <sassmann@suse.de>
Subject: [PATCH 4/7] disable broadcomm legacy boot interrupt generation
Date: Mon,  2 Jun 2008 14:45:04 +0200
Message-Id: <12124107072891-git-send-email-od@suse.de>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12124107071847-git-send-email-od@suse.de>
References: <12124107071847-git-send-email-od@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Dabrunz <od@suse.de>

Add a quirk to disable legacy boot interrupt generation on broadcomm HT1000.

Signed-off-by: Olaf Dabrunz <od@suse.de>
Signed-off-by: Stefan Assmann <sassmann@suse.de>
---
 drivers/pci/quirks.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 8f09f8f..e2fed6c 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1377,6 +1377,36 @@ int nobootirqquirk_setup(char *str)
 __setup("nobootirqquirk", nobootirqquirk_setup);
 
 /*
+ * disabled boot interrupts on HT-1000
+ */
+static void quirk_disable_broadcom_boot_interrupt(struct pci_dev *dev)
+{
+	u32 feature_enable;
+	u32 saved_feature_enable;
+	u8 irq;
+
+	if (nobootirqquirk)
+		return;
+
+	pci_read_config_dword(dev, 0x64,
+		       &feature_enable);
+	saved_feature_enable = feature_enable;
+	feature_enable |= (1<<0);
+	pci_write_config_dword(dev, 0x64, feature_enable);
+
+	for (irq = 0x10; irq < 0x10 + 32; irq++) {
+		outb(irq, 0xC00);
+		outb(0x00, 0xC01);
+	}
+
+	pci_write_config_dword(dev, 0x64, saved_feature_enable);
+
+	printk(KERN_INFO "disabled boot interrupts on PCI device 0x%04x:0x%04x\n",
+		       dev->vendor, dev->device);
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS,   PCI_DEVICE_ID_SERVERWORKS_HT1000SB, 	quirk_disable_broadcom_boot_interrupt);
+
+/*
  * On some chipsets we can disable the generation of legacy INTx boot
  * interrupts.
  */
-- 
1.5.2.4

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

