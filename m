Return-Path: <linux-kernel-owner+w=401wt.eu-S933511AbZJFVef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511AbZJFVef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933501AbZJFVee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:34:34 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:12502 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933472AbZJFVeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:34:31 -0400
Subject: [PATCH 6/7] ia64/PCI: print resources consistently with %pRt
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Date: Tue, 06 Oct 2009 15:33:54 -0600
Message-ID: <20091006213354.4272.70294.stgit@bob.kio>
In-Reply-To: <20091006213259.4272.68068.stgit@bob.kio>
References: <20091006213259.4272.68068.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses %pRt to print additional resource information (type, size,
prefetchability, etc.) consistently.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 arch/ia64/pci/pci.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 7de76dd..0f90259 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -126,6 +126,7 @@ alloc_pci_controller (int seg)
 }
 
 struct pci_root_info {
+	struct acpi_device *bridge;
 	struct pci_controller *controller;
 	char *name;
 };
@@ -292,9 +293,19 @@ static __devinit acpi_status add_window(struct acpi_resource *res, void *data)
 	window->offset = offset;
 
 	if (insert_resource(root, &window->resource)) {
-		printk(KERN_ERR "alloc 0x%llx-0x%llx from %s for %s failed\n",
-			window->resource.start, window->resource.end,
-			root->name, info->name);
+		dev_err(&info->bridge->dev, "can't allocate %pRt\n",
+			&window->resource);
+	} else {
+		if (offset)
+			dev_info(&info->bridge->dev, "host bridge window: %pRt "
+				 "(PCI address [%#llx-%#llx])\n",
+				 &window->resource,
+				 window->resource.start - offset,
+				 window->resource.end - offset);
+		else
+			dev_info(&info->bridge->dev,
+				 "host bridge window: %pRt\n",
+				 &window->resource);
 	}
 
 	return AE_OK;
@@ -314,8 +325,7 @@ pcibios_setup_root_windows(struct pci_bus *bus, struct pci_controller *ctrl)
 		    (res->end - res->start < 16))
 			continue;
 		if (j >= PCI_BUS_NUM_RESOURCES) {
-			printk("Ignoring range [%#llx-%#llx] (%lx)\n",
-					res->start, res->end, res->flags);
+			dev_warn(&bus->dev, "ignoring %pRf (no space)\n", res);
 			continue;
 		}
 		bus->resource[j++] = res;
@@ -359,6 +369,7 @@ pci_acpi_scan_root(struct acpi_device *device, int domain, int bus)
 			goto out3;
 
 		sprintf(name, "PCI Bus %04x:%02x", domain, bus);
+		info.bridge = device;
 		info.controller = controller;
 		info.name = name;
 		acpi_walk_resources(device->handle, METHOD_NAME__CRS,

