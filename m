Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbZGWXEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbZGWXEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 19:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbZGWXEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 19:04:24 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:25662 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbZGWXEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 19:04:23 -0400
Subject: [PATCH v3 2/2] PCI Hotplug: acpiphp: get pci_bus from acpi handle
	correctly
To: jbarnes@virtuousgeek.org, lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Date: Thu, 23 Jul 2009 17:03:05 -0600
Message-ID: <20090723230305.4247.81288.stgit@bob.kio>
In-Reply-To: <20090723230026.4247.12759.stgit@bob.kio>
References: <20090723230026.4247.12759.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot simply call acpi_get_pci_dev() on any random ACPI handle
and hope that it works, because a PCI root bridge may not have
an associated struct pci_dev.

This is allowed per the PCI specification, and is referred to as a
non-materialized bridge.

So, depending on the type of PCI bridge that the handle points to,
use the appropriate interface to return the struct pci_bus correctly.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/acpiphp_glue.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 0cb0f83..2e5f259 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -62,6 +62,22 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(acpi_handle handle, struct pci_bus *bus);
 static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *context);
 
+static struct pci_bus *pci_bus_from_handle(acpi_handle handle)
+{
+	struct pci_bus *pbus;
+	struct acpi_pci_root *root;
+
+	root = acpi_pci_find_root(handle);
+	if (root)
+		pbus = root->bus;
+	else {
+		struct pci_dev *pdev = acpi_get_pci_dev(handle);
+		pbus = pdev->subordinate;
+		pci_dev_put(pdev);
+	}
+	return pbus;
+}
+
 /* callback routine to check for the existence of a pci dock device */
 static acpi_status
 is_pci_dock_device(acpi_handle handle, u32 lvl, void *context, void **rv)
@@ -1387,16 +1403,7 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus)
 /* Program resources in newly inserted bridge */
 static int acpiphp_configure_bridge (acpi_handle handle)
 {
-	struct pci_dev *dev;
-	struct pci_bus *bus;
-
-	dev = acpi_get_pci_dev(handle);
-	if (!dev) {
-		err("cannot get PCI domain and bus number for bridge\n");
-		return -EINVAL;
-	}
-
-	bus = dev->bus;
+	struct pci_bus *bus = pci_bus_from_handle(handle);
 
 	pci_bus_size_bridges(bus);
 	pci_bus_assign_resources(bus);
@@ -1404,7 +1411,6 @@ static int acpiphp_configure_bridge (acpi_handle handle)
 	acpiphp_set_hpp_values(handle, bus);
 	pci_enable_bridges(bus);
 	acpiphp_configure_ioapics(handle);
-	pci_dev_put(dev);
 	return 0;
 }
 

