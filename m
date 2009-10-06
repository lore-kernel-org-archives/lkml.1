Return-Path: <linux-kernel-owner+w=401wt.eu-S933495AbZJFVeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495AbZJFVeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933472AbZJFVea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:34:30 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:43492 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933485AbZJFVe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:34:26 -0400
Subject: [PATCH 5/7] x86/PCI: print resources consistently with %pRt
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Date: Tue, 06 Oct 2009 15:33:49 -0600
Message-ID: <20091006213349.4272.65914.stgit@bob.kio>
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
 arch/x86/pci/acpi.c |   14 +++++++++++---
 arch/x86/pci/i386.c |   12 +++++-------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 2297280..4d4f1df 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -7,6 +7,7 @@
 #include <asm/pci_x86.h>
 
 struct pci_root_info {
+	struct acpi_device *bridge;
 	char *name;
 	unsigned int res_num;
 	struct resource *res;
@@ -107,12 +108,18 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
 	res->child = NULL;
 
 	if (insert_resource(root, res)) {
-		printk(KERN_ERR "PCI: Failed to allocate 0x%lx-0x%lx "
-			"from %s for %s\n", (unsigned long) res->start,
-			(unsigned long) res->end, root->name, info->name);
+		dev_err(&info->bridge->dev, "can't allocate %pRt\n", res);
 	} else {
 		info->bus->resource[info->res_num] = res;
 		info->res_num++;
+		if (addr.translation_offset)
+			dev_info(&info->bridge->dev, "host bridge window: %pRt "
+				 "(PCI address [%#llx-%#llx])\n",
+				 res, res->start - addr.translation_offset,
+				 res->end - addr.translation_offset);
+		else
+			dev_info(&info->bridge->dev,
+				 "host bridge window: %pRt\n", res);
 	}
 	return AE_OK;
 }
@@ -124,6 +131,7 @@ get_current_resources(struct acpi_device *device, int busnum,
 	struct pci_root_info info;
 	size_t size;
 
+	info.bridge = device;
 	info.bus = bus;
 	info.res_num = 0;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_resource,
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index b22d13b..a70a85d 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -129,7 +129,7 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
 					continue;
 				if (!r->start ||
 				    pci_claim_resource(dev, idx) < 0) {
-					dev_info(&dev->dev, "BAR %d: can't allocate resource\n", idx);
+					dev_info(&dev->dev, "BAR %d: can't allocate %pRt\n", idx, r);
 					/*
 					 * Something is wrong with the region.
 					 * Invalidate the resource to prevent
@@ -164,12 +164,10 @@ static void __init pcibios_allocate_resources(int pass)
 			else
 				disabled = !(command & PCI_COMMAND_MEMORY);
 			if (pass == disabled) {
-				dev_dbg(&dev->dev, "resource %#08llx-%#08llx (f=%lx, d=%d, p=%d)\n",
-					(unsigned long long) r->start,
-					(unsigned long long) r->end,
-					r->flags, disabled, pass);
+				dev_dbg(&dev->dev, "%pRf (d=%d, p=%d)\n", r,
+					disabled, pass);
 				if (pci_claim_resource(dev, idx) < 0) {
-					dev_info(&dev->dev, "BAR %d: can't allocate resource\n", idx);
+					dev_info(&dev->dev, "BAR %d: can't allocate %pRt\n", idx, r);
 					/* We'll assign a new address later */
 					r->end -= r->start;
 					r->start = 0;
@@ -182,7 +180,7 @@ static void __init pcibios_allocate_resources(int pass)
 				/* Turn the ROM off, leave the resource region,
 				 * but keep it unregistered. */
 				u32 reg;
-				dev_dbg(&dev->dev, "disabling ROM\n");
+				dev_dbg(&dev->dev, "disabling ROM %pRt\n", r);
 				r->flags &= ~IORESOURCE_ROM_ENABLE;
 				pci_read_config_dword(dev,
 						dev->rom_base_reg, &reg);

