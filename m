Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZCIFuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZCIFuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 01:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbZCIFtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 01:49:04 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:43850 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbZCIFtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 01:49:02 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v3 05/11] PCI: beef up pci_do_scan_bus()
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alex Chiang <achiang@hp.com>
Date: Sun, 08 Mar 2009 23:49:01 -0600
Message-ID: <20090309054900.3918.4473.stgit@bob.kio>
In-Reply-To: <20090309052933.3918.86601.stgit@bob.kio>
References: <20090309052933.3918.86601.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a nice interface for re-scanning a PCI bus which will
discover newly added devices, add them to the device tree, and
enable them properly.

Ensure that the bridge resources are properly sized and assigned
during the rescan.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug-pci.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/hotplug-pci.c b/drivers/pci/hotplug-pci.c
index 4d4a644..33ab2d2 100644
--- a/drivers/pci/hotplug-pci.c
+++ b/drivers/pci/hotplug-pci.c
@@ -6,13 +6,21 @@
 
 unsigned int __devinit pci_do_scan_bus(struct pci_bus *bus)
 {
-	unsigned int max;
+	unsigned int max, pass;
+	struct pci_dev *dev;
 
 	max = pci_scan_child_bus(bus);
 
-	/*
-	 * Make the discovered devices available.
-	 */
+	for (pass=0; pass < 2; pass++)
+		list_for_each_entry(dev, &bus->devices, bus_list) {
+			if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
+			    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
+				if (pass && dev->subordinate)
+					pci_bus_size_bridges(dev->subordinate);
+		}
+
+	pci_bus_assign_resources(bus);
+	pci_enable_bridges(bus);
 	pci_bus_add_devices(bus);
 
 	return max;

