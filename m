Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbZFBP0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbZFBP0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757766AbZFBPZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:25:00 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:42786 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900AbZFBPY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:24:59 -0400
Subject: [PATCH 05/10] PCI Hotplug: acpiphp: convert to acpi_get_pci_dev
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Date: Tue, 02 Jun 2009 09:25:01 -0600
Message-ID: <20090602152501.7346.41442.stgit@bob.kio>
In-Reply-To: <20090602152351.7346.48697.stgit@bob.kio>
References: <20090602152351.7346.48697.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that acpi_get_pci_dev is available, let's use it instead of
acpi_get_pci_id.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/acpiphp_glue.c |   24 ++++++------------------
 1 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index fc6636e..a288e4e 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -678,18 +678,9 @@ static void remove_bridge(acpi_handle handle)
 
 static struct pci_dev * get_apic_pci_info(acpi_handle handle)
 {
-	struct acpi_pci_id id;
-	struct pci_bus *bus;
 	struct pci_dev *dev;
 
-	if (ACPI_FAILURE(acpi_get_pci_id(handle, &id)))
-		return NULL;
-
-	bus = pci_find_bus(id.segment, id.bus);
-	if (!bus)
-		return NULL;
-
-	dev = pci_get_slot(bus, PCI_DEVFN(id.device, id.function));
+	dev = acpi_get_pci_dev(handle);
 	if (!dev)
 		return NULL;
 
@@ -1396,19 +1387,16 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus)
 /* Program resources in newly inserted bridge */
 static int acpiphp_configure_bridge (acpi_handle handle)
 {
-	struct acpi_pci_id pci_id;
+	struct pci_dev *dev;
 	struct pci_bus *bus;
 
-	if (ACPI_FAILURE(acpi_get_pci_id(handle, &pci_id))) {
+	dev = acpi_get_pci_dev(handle);
+	if (!dev) {
 		err("cannot get PCI domain and bus number for bridge\n");
 		return -EINVAL;
 	}
-	bus = pci_find_bus(pci_id.segment, pci_id.bus);
-	if (!bus) {
-		err("cannot find bus %d:%d\n",
-				pci_id.segment, pci_id.bus);
-		return -EINVAL;
-	}
+
+	bus = dev->bus;
 
 	pci_bus_size_bridges(bus);
 	pci_bus_assign_resources(bus);

