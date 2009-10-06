Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbZJFPp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbZJFPp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbZJFPp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:45:57 -0400
Received: from mailserv58-us.natinst.com ([130.164.14.247]:4636 "EHLO
	mailserv58-us.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbZJFPp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:45:57 -0400
From: Gabe Black <gabe.black@ni.com>
To: jbarnes@virtuousgeek.org
Cc: shawn.bohrer@ni.com, mike.hoogendyk@ni.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Gabe Black <gabe.black@ni.com>
Subject: [PATCH] Populate subsystem vendor and device IDs for PCI-Bridges
Date: Tue, 6 Oct 2009 10:45:19 -0500
Message-Id: <1254843919-13809-1-git-send-email-gabe.black@ni.com>
X-Mailer: git-send-email 1.6.0.4
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.0.2 FP2|June 23, 2009) at
 10/06/2009 10:45:19 AM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.0.2 FP2|June 23, 2009) at
 10/06/2009 10:46:01 AM,
	Serialize complete at 10/06/2009 10:46:01 AM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change to populate the subsystem vendor and subsytem device IDs for
PCI-PCI bridges that implement the PCI Subsystem Vendor ID capability.
Previously bridges left subsystem vendor IDs unpopulated.

Signed-off-by: Gabe Black <gabe.black@ni.com>
---
 drivers/pci/probe.c      |    6 ++++++
 include/linux/pci_regs.h |    5 +++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8105e32..6d90246 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -731,6 +731,7 @@ int pci_setup_device(struct pci_dev *dev)
 	u32 class;
 	u8 hdr_type;
 	struct pci_slot *slot;
+	int pos = 0;
 
 	if (pci_read_config_byte(dev, PCI_HEADER_TYPE, &hdr_type))
 		return -EIO;
@@ -822,6 +823,11 @@ int pci_setup_device(struct pci_dev *dev)
 		dev->transparent = ((dev->class & 0xff) == 1);
 		pci_read_bases(dev, 2, PCI_ROM_ADDRESS1);
 		set_pcie_hotplug_bridge(dev);
+		pos = pci_find_capability(dev, PCI_CAP_ID_SSVID);
+		if (pos) {
+			pci_read_config_word(dev, pos + PCI_SSVID_VENDOR_ID, &dev->subsystem_vendor);
+			pci_read_config_word(dev, pos + PCI_SSVID_DEVICE_ID, &dev->subsystem_device);
+		}
 		break;
 
 	case PCI_HEADER_TYPE_CARDBUS:		    /* CardBus bridge header */
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index dd0bed4..d3b0cfb 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -365,6 +365,11 @@
 #define  PCI_X_STATUS_266MHZ	0x40000000	/* 266 MHz capable */
 #define  PCI_X_STATUS_533MHZ	0x80000000	/* 533 MHz capable */
 
+/* PCI Bridge Subsystem ID registers */
+
+#define PCI_SSVID_VENDOR_ID     4	/* PCI-Bridge subsystem vendor id register */
+#define PCI_SSVID_DEVICE_ID     6	/* PCI-Bridge subsystem device id register */
+
 /* PCI Express capability registers */
 
 #define PCI_EXP_FLAGS		2	/* Capabilities register */
-- 
1.6.0.4

