Return-Path: <linux-kernel-owner+w=401wt.eu-S932939AbZLRU6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939AbZLRU6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932808AbZLRU54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:57:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:57513 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932894AbZLRU4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:56:48 -0500
Message-ID: <4B2BEC40.5070403@kernel.org>
Date: Fri, 18 Dec 2009 12:55:28 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 8/12] pci: pciehp clean flow in pciehp_configure_device
References: <4B2BE9DD.3040504@kernel.org>
In-Reply-To: <4B2BE9DD.3040504@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
 1 file changed, 17 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/pci/hotplug/pciehp_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_pci.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_pci.c
@@ -53,17 +53,15 @@ static int __ref pciehp_add_bridge(struc
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
 
@@ -96,12 +94,25 @@ int pciehp_configure_device(struct slot
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
 


