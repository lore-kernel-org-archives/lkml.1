Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYG2WBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYG2WBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYG2WBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:01:30 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:25773 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbYG2WB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:01:29 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: David Airlie <airlied@linux.ie>
Subject: [PATCH] amd64-agp: run fallback when no bridges found,
	not when driver registration fails
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Dave Jones <davej@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Tue, 29 Jul 2008 16:01:13 -0600
Message-ID: <20080729220058.27695.19873.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I think the intent was that if no bridges matched agp_amd64_pci_table[],
we would fall back to checking for any bridge with the AGP capability.
But in the current code, we execute the fallback path only when
pci_register_driver() itself fails, which is unrelated to whether any
matching devices were found.

This patch counts the AGP bridges found in the probe() method and
executes the fallback path when none is found.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/char/agp/amd64-agp.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)


diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 481ffe8..7345f9a 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -34,6 +34,7 @@
 
 static struct resource *aperture_resource;
 static int __initdata agp_try_unsupported = 1;
+static int agp_bridges_found;
 
 static void amd64_tlbflush(struct agp_memory *temp)
 {
@@ -489,6 +490,7 @@ static int __devinit agp_amd64_probe(struct pci_dev *pdev,
 {
 	struct agp_bridge_data *bridge;
 	u8 cap_ptr;
+	int err;
 
 	cap_ptr = pci_find_capability(pdev, PCI_CAP_ID_AGP);
 	if (!cap_ptr)
@@ -536,7 +538,12 @@ static int __devinit agp_amd64_probe(struct pci_dev *pdev,
 	}
 
 	pci_set_drvdata(pdev, bridge);
-	return agp_add_bridge(bridge);
+	err = agp_add_bridge(bridge);
+	if (err < 0)
+		return err;
+
+	agp_bridges_found++;
+	return 0;
 }
 
 static void __devexit agp_amd64_remove(struct pci_dev *pdev)
@@ -713,7 +720,11 @@ int __init agp_amd64_init(void)
 
 	if (agp_off)
 		return -EINVAL;
-	if (pci_register_driver(&agp_amd64_pci_driver) < 0) {
+	err = pci_register_driver(&agp_amd64_pci_driver);
+	if (err < 0)
+		return err;
+
+	if (agp_bridges_found == 0) {
 		struct pci_dev *dev;
 		if (!agp_try_unsupported && !agp_try_unsupported_boot) {
 			printk(KERN_INFO PFX "No supported AGP bridge found.\n");

