Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbZIJSd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbZIJSd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbZIJSd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:33:58 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44295 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbZIJSdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:33:55 -0400
Subject: [PATCH v2 1/2] PCI Hotplug: acpiphp: find bridges the easy way
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Date: Thu, 10 Sep 2009 12:34:04 -0600
Message-ID: <20090910183403.20011.32299.stgit@bob.kio>
In-Reply-To: <20090910183219.20011.41679.stgit@bob.kio>
References: <20090910183219.20011.41679.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of constantly evaluating _ADR and _SEG over and over again,
let's simplify our lives by using:

	acpi_pci_find_root() for root bridges
	acpi_get_pci_dev() for p2p bridges

This change eliminates some copy 'n paste code and also allows us
to simplify some internal interfaces.

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/acpiphp_glue.c |   81 +++++++++---------------------------
 1 files changed, 21 insertions(+), 60 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 2e5f259..e72e0ad 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -277,14 +277,15 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 
 
 /* see if it's worth looking at this bridge */
-static int detect_ejectable_slots(struct pci_bus *pbus)
+static int detect_ejectable_slots(acpi_handle handle)
 {
-	int found = acpi_pci_detect_ejectable(pbus);
+	int found;
+	struct pci_bus *pbus;
+
+	pbus = pci_bus_from_handle(handle);
+	found = acpi_pci_detect_ejectable(pbus);
 	if (!found) {
-		acpi_handle bridge_handle = acpi_pci_get_bridge_handle(pbus);
-		if (!bridge_handle)
-			return 0;
-		acpi_walk_namespace(ACPI_TYPE_DEVICE, bridge_handle, (u32)1,
+		acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
 				    is_pci_dock_device, (void *)&found, NULL);
 	}
 	return found;
@@ -415,9 +416,10 @@ static inline void config_p2p_bridge_flags(struct acpiphp_bridge *bridge)
 
 
 /* allocate and initialize host bridge data structure */
-static void add_host_bridge(acpi_handle *handle, struct pci_bus *pci_bus)
+static void add_host_bridge(acpi_handle *handle)
 {
 	struct acpiphp_bridge *bridge;
+	struct acpi_pci_root *root = acpi_pci_find_root(handle);
 
 	bridge = kzalloc(sizeof(struct acpiphp_bridge), GFP_KERNEL);
 	if (bridge == NULL)
@@ -426,7 +428,7 @@ static void add_host_bridge(acpi_handle *handle, struct pci_bus *pci_bus)
 	bridge->type = BRIDGE_TYPE_HOST;
 	bridge->handle = handle;
 
-	bridge->pci_bus = pci_bus;
+	bridge->pci_bus = root->bus;
 
 	spin_lock_init(&bridge->res_lock);
 
@@ -435,7 +437,7 @@ static void add_host_bridge(acpi_handle *handle, struct pci_bus *pci_bus)
 
 
 /* allocate and initialize PCI-to-PCI bridge data structure */
-static void add_p2p_bridge(acpi_handle *handle, struct pci_dev *pci_dev)
+static void add_p2p_bridge(acpi_handle *handle)
 {
 	struct acpiphp_bridge *bridge;
 
@@ -449,8 +451,8 @@ static void add_p2p_bridge(acpi_handle *handle, struct pci_dev *pci_dev)
 	bridge->handle = handle;
 	config_p2p_bridge_flags(bridge);
 
-	bridge->pci_dev = pci_dev_get(pci_dev);
-	bridge->pci_bus = pci_dev->subordinate;
+	bridge->pci_dev = acpi_get_pci_dev(handle);
+	bridge->pci_bus = bridge->pci_dev->subordinate;
 	if (!bridge->pci_bus) {
 		err("This is not a PCI-to-PCI bridge!\n");
 		goto err;
@@ -467,7 +469,7 @@ static void add_p2p_bridge(acpi_handle *handle, struct pci_dev *pci_dev)
 	init_bridge_misc(bridge);
 	return;
  err:
-	pci_dev_put(pci_dev);
+	pci_dev_put(bridge->pci_dev);
 	kfree(bridge);
 	return;
 }
@@ -478,39 +480,21 @@ static acpi_status
 find_p2p_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
 	acpi_status status;
-	acpi_handle dummy_handle;
-	unsigned long long tmp;
-	int device, function;
 	struct pci_dev *dev;
-	struct pci_bus *pci_bus = context;
-
-	status = acpi_get_handle(handle, "_ADR", &dummy_handle);
-	if (ACPI_FAILURE(status))
-		return AE_OK;		/* continue */
-
-	status = acpi_evaluate_integer(handle, "_ADR", NULL, &tmp);
-	if (ACPI_FAILURE(status)) {
-		dbg("%s: _ADR evaluation failure\n", __func__);
-		return AE_OK;
-	}
-
-	device = (tmp >> 16) & 0xffff;
-	function = tmp & 0xffff;
-
-	dev = pci_get_slot(pci_bus, PCI_DEVFN(device, function));
 
+	dev = acpi_get_pci_dev(handle);
 	if (!dev || !dev->subordinate)
 		goto out;
 
 	/* check if this bridge has ejectable slots */
-	if ((detect_ejectable_slots(dev->subordinate) > 0)) {
+	if ((detect_ejectable_slots(handle) > 0)) {
 		dbg("found PCI-to-PCI bridge at PCI %s\n", pci_name(dev));
-		add_p2p_bridge(handle, dev);
+		add_p2p_bridge(handle);
 	}
 
 	/* search P2P bridges under this p2p bridge */
 	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
-				     find_p2p_bridge, dev->subordinate, NULL);
+				     find_p2p_bridge, NULL, NULL);
 	if (ACPI_FAILURE(status))
 		warn("find_p2p_bridge failed (error code = 0x%x)\n", status);
 
@@ -525,9 +509,7 @@ static int add_bridge(acpi_handle handle)
 {
 	acpi_status status;
 	unsigned long long tmp;
-	int seg, bus;
 	acpi_handle dummy_handle;
-	struct pci_bus *pci_bus;
 
 	/* if the bridge doesn't have _STA, we assume it is always there */
 	status = acpi_get_handle(handle, "_STA", &dummy_handle);
@@ -542,36 +524,15 @@ static int add_bridge(acpi_handle handle)
 			return 0;
 	}
 
-	/* get PCI segment number */
-	status = acpi_evaluate_integer(handle, "_SEG", NULL, &tmp);
-
-	seg = ACPI_SUCCESS(status) ? tmp : 0;
-
-	/* get PCI bus number */
-	status = acpi_evaluate_integer(handle, "_BBN", NULL, &tmp);
-
-	if (ACPI_SUCCESS(status)) {
-		bus = tmp;
-	} else {
-		warn("can't get bus number, assuming 0\n");
-		bus = 0;
-	}
-
-	pci_bus = pci_find_bus(seg, bus);
-	if (!pci_bus) {
-		err("Can't find bus %04x:%02x\n", seg, bus);
-		return 0;
-	}
-
 	/* check if this bridge has ejectable slots */
-	if (detect_ejectable_slots(pci_bus) > 0) {
+	if (detect_ejectable_slots(handle) > 0) {
 		dbg("found PCI host-bus bridge with hot-pluggable slots\n");
-		add_host_bridge(handle, pci_bus);
+		add_host_bridge(handle);
 	}
 
 	/* search P2P bridges under this host bridge */
 	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
-				     find_p2p_bridge, pci_bus, NULL);
+				     find_p2p_bridge, NULL, NULL);
 
 	if (ACPI_FAILURE(status))
 		warn("find_p2p_bridge failed (error code = 0x%x)\n", status);

