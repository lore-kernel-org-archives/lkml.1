Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbZBMUU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbZBMUU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760112AbZBMUTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:19:21 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:32812 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761246AbZBMUTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:19:19 -0500
From: Alex Chiang <achiang@hp.com>
Subject: [RFC PATCH v2 05/12] PCI: beef up pci_do_scan_bus()
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alex Chiang <achiang@hp.com>
Date: Fri, 13 Feb 2009 13:19:18 -0700
Message-ID: <20090213201918.19262.31746.stgit@bob.kio>
In-Reply-To: <20090213201135.19262.67924.stgit@bob.kio>
References: <20090213201135.19262.67924.stgit@bob.kio>
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

