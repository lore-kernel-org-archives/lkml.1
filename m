Return-Path: <linux-kernel-owner+w=401wt.eu-S932805AbZJFOgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbZJFOgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932754AbZJFOgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:36:22 -0400
Received: from mailserv59-us.natinst.com ([130.164.14.243]:3294 "EHLO
	mailserv59-us.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932765AbZJFOgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:36:21 -0400
X-Greylist: delayed 958 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2009 10:36:21 EDT
From: Gabe Black <gabe.black@ni.com>
To: jbarnes@virtuousgeek.org
Cc: shawn.bohrer@ni.com, mike.hoogendyk@ni.com, knan@anduin.net,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       arjan@infradead.org, Gabe Black <gabe.black@ni.com>
Subject: [PATCH] TI XIO200a bridge quirk: erroneously reports support for fast b2b transfers
Date: Tue, 6 Oct 2009 09:19:45 -0500
Message-Id: <1254838785-10254-1-git-send-email-gabe.black@ni.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <8a15eb2b0910060432m3c062776md718ea19baf19a3f@mail.gmail.com>
References: <8a15eb2b0910060432m3c062776md718ea19baf19a3f@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.0.2 FP2|June 23, 2009) at
 10/06/2009 09:19:46 AM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.0.2 FP2|June 23, 2009) at
 10/06/2009 09:36:26 AM,
	Serialize complete at 10/06/2009 09:36:26 AM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This quirk will disable fast back to back transfer on the secondary bus
segment of the TI Bridge.

Signed-off-by: Gabe Black <gabe.black@ni.com>
---
 drivers/pci/quirks.c    |   19 +++++++++++++++++++
 include/linux/pci_ids.h |    1 +
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6099fac..efa6534 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -670,6 +670,25 @@ static void __devinit quirk_vt8235_acpi(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8235,	quirk_vt8235_acpi);
 
+/*
+ * TI XIO2000a PCIe-PCI Bridge erroneously reports it supports fast back-to-back:
+ *	Disable fast back-to-back on the secondary bus segment
+ */
+static void __devinit quirk_xio2000a(struct pci_dev *dev)
+{
+	struct pci_dev *pdev;
+	u16 command;
+
+	dev_warn(&dev->dev, "TI XIO2000a quirk detected; "
+		"secondary bus fast back-to-back transfers disabled\n");
+	list_for_each_entry(pdev, &dev->subordinate->devices, bus_list) {
+		pci_read_config_word(pdev, PCI_COMMAND, &command);
+		if (command & PCI_COMMAND_FAST_BACK)
+			pci_write_config_word(pdev, PCI_COMMAND, command & ~PCI_COMMAND_FAST_BACK);
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_XIO2000A,
+			quirk_xio2000a);
 
 #ifdef CONFIG_X86_IO_APIC 
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index da1fda8..f490e7a 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -776,6 +776,7 @@
 #define PCI_DEVICE_ID_TI_X515		0x8036
 #define PCI_DEVICE_ID_TI_XX12		0x8039
 #define PCI_DEVICE_ID_TI_XX12_FM	0x803b
+#define PCI_DEVICE_ID_TI_XIO2000A	0x8231
 #define PCI_DEVICE_ID_TI_1130		0xac12
 #define PCI_DEVICE_ID_TI_1031		0xac13
 #define PCI_DEVICE_ID_TI_1131		0xac15
-- 
1.6.0.4

