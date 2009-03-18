Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbZCRWlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbZCRWlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758235AbZCRWjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:39:49 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:27660 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbZCRWjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:39:48 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v4 04/12] PCI: always scan child buses
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alex Chiang <achiang@hp.com>
Date: Wed, 18 Mar 2009 16:39:46 -0600
Message-ID: <20090318223946.887.62372.stgit@bob.kio>
In-Reply-To: <20090318222426.887.1008.stgit@bob.kio>
References: <20090318222426.887.1008.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While scanning bridges, we stop our scan if we encounter a bus
that we've seen before, to work around some buggy chipsets. This
is a good idea, but prevents us from fully scanning the PCI bus
at a future time (to find newly hot-added devices, for example).

Change the logic so that we skip _re-adding_ an existing bus
that we've seen before, but also allow the scan to descend to
all child buses.

Now that we're potentially scanning our child buses again, we
also need to be sure not to attempt re-initializing their BARs
so we avoid that.

This patch lays the groundwork to allow the user to issue a
rescan of the PCI bus at any time.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/probe.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index d392813..a3959ce 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -511,21 +511,21 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 
 		/*
 		 * If we already got to this bus through a different bridge,
-		 * ignore it.  This can happen with the i450NX chipset.
+		 * don't re-add it. This can happen with the i450NX chipset.
+		 *
+		 * However, we continue to descend down the hierarchy and
+		 * scan remaining child buses.
 		 */
-		if (pci_find_bus(pci_domain_nr(bus), busnr)) {
-			dev_info(&dev->dev, "bus %04x:%02x already known\n",
-				 pci_domain_nr(bus), busnr);
-			goto out;
+		child = pci_find_bus(pci_domain_nr(bus), busnr);
+		if (!child) {
+			child = pci_add_new_bus(bus, dev, busnr);
+			if (!child)
+				goto out;
+			child->primary = buses & 0xFF;
+			child->subordinate = (buses >> 16) & 0xFF;
+			child->bridge_ctl = bctl;
 		}
 
-		child = pci_add_new_bus(bus, dev, busnr);
-		if (!child)
-			goto out;
-		child->primary = buses & 0xFF;
-		child->subordinate = (buses >> 16) & 0xFF;
-		child->bridge_ctl = bctl;
-
 		cmax = pci_scan_child_bus(child);
 		if (cmax > max)
 			max = cmax;
@@ -1075,8 +1075,13 @@ unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 	 * After performing arch-dependent fixup of the bus, look behind
 	 * all PCI-to-PCI bridges on this bus.
 	 */
-	pr_debug("PCI: Fixups for bus %04x:%02x\n", pci_domain_nr(bus), bus->number);
-	pcibios_fixup_bus(bus);
+	if (!bus->is_added) {
+		pr_debug("PCI: Fixups for bus %04x:%02x\n", pci_domain_nr(bus), bus->number);
+		pcibios_fixup_bus(bus);
+		if (pci_is_root_bus(bus))
+			bus->is_added = 1;
+	}
+
 	for (pass=0; pass < 2; pass++)
 		list_for_each_entry(dev, &bus->devices, bus_list) {
 			if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||

