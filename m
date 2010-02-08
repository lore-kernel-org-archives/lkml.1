Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab0BHWoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 17:44:37 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:42241 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab0BHWoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 17:44:30 -0500
Subject: [PATCH v2 2/7] PCI: break out primary/secondary/subordinate for
	readability
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-pci@vger.kernel.org, Peter Haight <peterh@sapros.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 08 Feb 2010 15:44:28 -0700
Message-ID: <20100208224428.27954.48021.stgit@bob.kio>
In-Reply-To: <20100208224236.27954.4358.stgit@bob.kio>
References: <20100208224236.27954.4358.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No functional change; just add names for the primary/secondary/subordinate
bus numbers read from config space rather than repeatedly masking/shifting.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pci/probe.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)


diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 2555d66..8d3df71 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -635,16 +635,20 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 	int is_cardbus = (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS);
 	u32 buses, i, j = 0;
 	u16 bctl;
+	u8 primary, secondary, subordinate;
 	int broken = 0;
 
 	pci_read_config_dword(dev, PCI_PRIMARY_BUS, &buses);
+	primary = buses & 0xFF;
+	secondary = (buses >> 8) & 0xFF;
+	subordinate = (buses >> 16) & 0xFF;
 
-	dev_dbg(&dev->dev, "scanning behind bridge, config %06x, pass %d\n",
-		buses & 0xffffff, pass);
+	dev_dbg(&dev->dev, "scanning [bus %02x-%02x] behind bridge, pass %d\n",
+		secondary, subordinate, pass);
 
 	/* Check if setup is sensible at all */
 	if (!pass &&
-	    ((buses & 0xff) != bus->number || ((buses >> 8) & 0xff) <= bus->number)) {
+	    (primary != bus->number || secondary <= bus->number)) {
 		dev_dbg(&dev->dev, "bus configuration invalid, reconfiguring\n");
 		broken = 1;
 	}
@@ -655,15 +659,15 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 	pci_write_config_word(dev, PCI_BRIDGE_CONTROL,
 			      bctl & ~PCI_BRIDGE_CTL_MASTER_ABORT);
 
-	if ((buses & 0xffff00) && !pcibios_assign_all_busses() && !is_cardbus && !broken) {
-		unsigned int cmax, busnr;
+	if ((secondary || subordinate) && !pcibios_assign_all_busses() &&
+	    !is_cardbus && !broken) {
+		unsigned int cmax;
 		/*
 		 * Bus already configured by firmware, process it in the first
 		 * pass and just note the configuration.
 		 */
 		if (pass)
 			goto out;
-		busnr = (buses >> 8) & 0xFF;
 
 		/*
 		 * If we already got to this bus through a different bridge,
@@ -672,13 +676,13 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 		 * However, we continue to descend down the hierarchy and
 		 * scan remaining child buses.
 		 */
-		child = pci_find_bus(pci_domain_nr(bus), busnr);
+		child = pci_find_bus(pci_domain_nr(bus), secondary);
 		if (!child) {
-			child = pci_add_new_bus(bus, dev, busnr);
+			child = pci_add_new_bus(bus, dev, secondary);
 			if (!child)
 				goto out;
-			child->primary = buses & 0xFF;
-			child->subordinate = (buses >> 16) & 0xFF;
+			child->primary = primary;
+			child->subordinate = subordinate;
 			child->bridge_ctl = bctl;
 		}
 

