Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350Ab0AUGRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0AUGRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 01:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819Ab0AUGQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 01:16:34 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:35748 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab0AUGO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 01:14:57 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 20 Jan 2010 22:14:14 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 7/9] pci: pciehp clean flow in pciehp_configure_device
In-reply-to: <1264054456-12694-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1264054456-12694-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1264054456-12694-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move out bus_size_bridges and assign resources out of pciehp_add_bridge()
and at last do them all together one time including slot bridge, to avoid to
call assign resources several times, when there are several bridges under the
slot bridge.
use pci_assign_nassigned_bridge_resources

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/hotplug/pciehp_pci.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_pci.c b/drivers/pci/hotplug/pciehp_pci.c
index 2173310..0a16444 100644
--- a/drivers/pci/hotplug/pciehp_pci.c
+++ b/drivers/pci/hotplug/pciehp_pci.c
@@ -53,17 +53,15 @@ static int __ref pciehp_add_bridge(struct pci_dev *dev)
 		busnr = pci_scan_bridge(parent, dev, busnr, pass);
 	if (!dev->subordinate)
 		return -1;
-	pci_bus_size_bridges(dev->subordinate);
-	pci_bus_assign_resources(parent);
-	pci_enable_bridges(parent);
-	pci_bus_add_devices(parent);
+
 	return 0;
 }
 
 int pciehp_configure_device(struct slot *p_slot)
 {
 	struct pci_dev *dev;
-	struct pci_bus *parent = p_slot->ctrl->pcie->port->subordinate;
+	struct pci_dev *bridge = p_slot->ctrl->pcie->port;
+	struct pci_bus *parent = bridge->subordinate;
 	int num, fn;
 	struct controller *ctrl = p_slot->ctrl;
 
@@ -96,12 +94,25 @@ int pciehp_configure_device(struct slot *p_slot)
 				(dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)) {
 			pciehp_add_bridge(dev);
 		}
+		pci_dev_put(dev);
+	}
+
+	pci_assign_unassigned_bridge_resources(bridge);
+
+	for (fn = 0; fn < 8; fn++) {
+		dev = pci_get_slot(parent, PCI_DEVFN(0, fn));
+		if (!dev)
+			continue;
+		if ((dev->class >> 16) == PCI_BASE_CLASS_DISPLAY) {
+			pci_dev_put(dev);
+			continue;
+		}
 		pci_configure_slot(dev);
 		pci_dev_put(dev);
 	}
 
-	pci_bus_assign_resources(parent);
 	pci_bus_add_devices(parent);
+
 	return 0;
 }
 
-- 
1.6.4.2

