Return-Path: <linux-kernel-owner+w=401wt.eu-S934173AbZJMTXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934173AbZJMTXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934165AbZJMTXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:23:18 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:13031 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934151AbZJMTXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:23:14 -0400
Subject: [PATCH v2 8/9] ia64/PCI: print resources consistently with %pR
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Joe Perches <joe@perches.com>, Len Brown <lenb@kernel.org>
Date: Tue, 13 Oct 2009 13:22:35 -0600
Message-ID: <20091013192235.22336.65357.stgit@bob.kio>
In-Reply-To: <20091013192040.22336.84876.stgit@bob.kio>
References: <20091013192040.22336.84876.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses %pR to print additional resource information (type, size,
prefetchability, etc.) consistently.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 arch/ia64/pci/pci.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 7de76dd..4704f47 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -126,6 +126,7 @@ alloc_pci_controller (int seg)
 }
 
 struct pci_root_info {
+	struct acpi_device *bridge;
 	struct pci_controller *controller;
 	char *name;
 };
@@ -292,9 +293,20 @@ static __devinit acpi_status add_window(struct acpi_resource *res, void *data)
 	window->offset = offset;
 
 	if (insert_resource(root, &window->resource)) {
-		printk(KERN_ERR "alloc 0x%llx-0x%llx from %s for %s failed\n",
-			window->resource.start, window->resource.end,
-			root->name, info->name);
+		dev_err(&info->bridge->dev,
+			"can't allocate host bridge window %pR\n",
+			&window->resource);
+	} else {
+		if (offset)
+			dev_info(&info->bridge->dev, "host bridge window %pR "
+				 "(PCI address [%#llx-%#llx])\n",
+				 &window->resource,
+				 window->resource.start - offset,
+				 window->resource.end - offset);
+		else
+			dev_info(&info->bridge->dev,
+				 "host bridge window %pR\n",
+				 &window->resource);
 	}
 
 	return AE_OK;
@@ -314,8 +326,9 @@ pcibios_setup_root_windows(struct pci_bus *bus, struct pci_controller *ctrl)
 		    (res->end - res->start < 16))
 			continue;
 		if (j >= PCI_BUS_NUM_RESOURCES) {
-			printk("Ignoring range [%#llx-%#llx] (%lx)\n",
-					res->start, res->end, res->flags);
+			dev_warn(&bus->dev,
+				 "ignoring host bridge window %pR (no space)\n",
+				 res);
 			continue;
 		}
 		bus->resource[j++] = res;
@@ -359,6 +372,7 @@ pci_acpi_scan_root(struct acpi_device *device, int domain, int bus)
 			goto out3;
 
 		sprintf(name, "PCI Bus %04x:%02x", domain, bus);
+		info.bridge = device;
 		info.controller = controller;
 		info.name = name;
 		acpi_walk_resources(device->handle, METHOD_NAME__CRS,

