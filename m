Return-Path: <linux-kernel-owner+w=401wt.eu-S934160AbZJMTXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934160AbZJMTXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934151AbZJMTXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:23:11 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:21954 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934144AbZJMTXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:23:07 -0400
Subject: [PATCH v2 7/9] x86/PCI: print resources consistently with %pR
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Joe Perches <joe@perches.com>, Len Brown <lenb@kernel.org>
Date: Tue, 13 Oct 2009 13:22:30 -0600
Message-ID: <20091013192230.22336.89900.stgit@bob.kio>
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
 arch/x86/pci/acpi.c |   15 ++++++++++++---
 arch/x86/pci/i386.c |   13 ++++++-------
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 1014eb4..6bf8091 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -7,6 +7,7 @@
 #include <asm/pci_x86.h>
 
 struct pci_root_info {
+	struct acpi_device *bridge;
 	char *name;
 	unsigned int res_num;
 	struct resource *res;
@@ -107,12 +108,19 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 	res->child = NULL;
 
 	if (insert_resource(root, res)) {
-		printk(KERN_ERR "PCI: Failed to allocate 0x%lx-0x%lx "
-			"from %s for %s\n", (unsigned long) res->start,
-			(unsigned long) res->end, root->name, info->name);
+		dev_err(&info->bridge->dev,
+			"can't allocate host bridge window %pR\n", res);
 	} else {
 		info->bus->resource[info->res_num] = res;
 		info->res_num++;
+		if (addr.translation_offset)
+			dev_info(&info->bridge->dev, "host bridge window %pR "
+				 "(PCI address [%#llx-%#llx])\n",
+				 res, res->start - addr.translation_offset,
+				 res->end - addr.translation_offset);
+		else
+			dev_info(&info->bridge->dev,
+				 "host bridge window %pR\n", res);
 	}
 	return AE_OK;
 }
@@ -124,6 +132,7 @@ get_current_resources(struct acpi_device *device, int busnum,
 	struct pci_root_info info;
 	size_t size;
 
+	info.bridge = device;
 	info.bus = bus;
 	info.res_num = 0;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_resource,
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index b22d13b..f5fac0f 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -129,7 +129,7 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
 					continue;
 				if (!r->start ||
 				    pci_claim_resource(dev, idx) < 0) {
-					dev_info(&dev->dev, "BAR %d: can't allocate resource\n", idx);
+					dev_info(&dev->dev, "BAR %d: can't allocate %pR\n", idx, r);
 					/*
 					 * Something is wrong with the region.
 					 * Invalidate the resource to prevent
@@ -164,12 +164,11 @@ static void __init pcibios_allocate_resources(int pass)
 			else
 				disabled = !(command & PCI_COMMAND_MEMORY);
 			if (pass == disabled) {
-				dev_dbg(&dev->dev, "resource %#08llx-%#08llx (f=%lx, d=%d, p=%d)\n",
-					(unsigned long long) r->start,
-					(unsigned long long) r->end,
-					r->flags, disabled, pass);
+				dev_dbg(&dev->dev,
+					"BAR %d: claiming %pr (d=%d, p=%d)\n",
+					idx, r, disabled, pass);
 				if (pci_claim_resource(dev, idx) < 0) {
-					dev_info(&dev->dev, "BAR %d: can't allocate resource\n", idx);
+					dev_info(&dev->dev, "BAR %d: can't claim %pR\n", idx, r);
 					/* We'll assign a new address later */
 					r->end -= r->start;
 					r->start = 0;
@@ -182,7 +181,7 @@ static void __init pcibios_allocate_resources(int pass)
 				/* Turn the ROM off, leave the resource region,
 				 * but keep it unregistered. */
 				u32 reg;
-				dev_dbg(&dev->dev, "disabling ROM\n");
+				dev_dbg(&dev->dev, "disabling ROM %pR\n", r);
 				r->flags &= ~IORESOURCE_ROM_ENABLE;
 				pci_read_config_dword(dev,
 						dev->rom_base_reg, &reg);

