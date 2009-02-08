Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbZBHVpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbZBHVpj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZBHVp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:45:28 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:55182 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbZBHVp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:45:26 -0500
Date: Sun, 8 Feb 2009 22:45:24 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/6] drivers/pci: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0902082244490.25891@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc should free the allocated data.
Since the subsequent code that could provoke an error does not use the
allocated data, the allocation is just moved below it.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,l;
position p1,p2;
expression *ptr != NULL;
@@

(
if ((x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...)) == NULL) S
|
x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
)
<... when != x
     when != if (...) { <+...x...+> }
x->f = E
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/pci/hotplug/pciehp_acpi.c   |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_acpi.c b/drivers/pci/hotplug/pciehp_acpi.c
index 21734c3..9604801 100644
--- a/drivers/pci/hotplug/pciehp_acpi.c
+++ b/drivers/pci/hotplug/pciehp_acpi.c
@@ -79,14 +79,15 @@ static int __init dummy_probe(struct pcie_device *dev)
 	struct slot *slot, *tmp;
 	struct pci_dev *pdev = dev->port;
 	struct pci_bus *pbus = pdev->subordinate;
-	if (!(slot = kzalloc(sizeof(*slot), GFP_KERNEL)))
-		return -ENOMEM;
 	/* Note: pciehp_detect_mode != PCIEHP_DETECT_ACPI here */
 	if (pciehp_get_hp_hw_control_from_firmware(pdev))
 		return -ENODEV;
 	if (!(pos = pci_find_capability(pdev, PCI_CAP_ID_EXP)))
 		return -ENODEV;
 	pci_read_config_dword(pdev, pos + PCI_EXP_SLTCAP, &slot_cap);
+	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
+	if (!slot)
+		return -ENOMEM;
 	slot->number = slot_cap >> 19;
 	list_for_each_entry(tmp, &dummy_slots, slot_list) {
 		if (tmp->number == slot->number)
