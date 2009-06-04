Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbZFDGAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbZFDGAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 02:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756921AbZFDF6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:58:47 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:3495 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787AbZFDF6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:58:45 -0400
Subject: [PATCH v2 06/11] ACPI: simplify acpi_pci_irq_del_prt() API
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Date: Wed, 03 Jun 2009 23:58:47 -0600
Message-ID: <20090604055847.18802.98452.stgit@bob.kio>
In-Reply-To: <20090604054504.18802.21690.stgit@bob.kio>
References: <20090604054504.18802.21690.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to pass a segment/bus tuple to this API, as the callsite
always has a struct pci_bus. We can derive segment/bus from the
struct pci_bus, so let's take this opportunit to simplify the API and
make life easier for the callers.

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/pci_bind.c     |    3 +--
 drivers/acpi/pci_irq.c      |    7 ++++---
 include/acpi/acpi_drivers.h |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
index 6eb58ef..62cb383 100644
--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -113,8 +113,7 @@ static int acpi_pci_unbind(struct acpi_device *device)
 		return 0;
 
 	if (dev->subordinate)
-		acpi_pci_irq_del_prt(pci_domain_nr(dev->bus),
-				     dev->subordinate->number);
+		acpi_pci_irq_del_prt(dev->subordinate);
 
 	pci_dev_put(dev);
 	return 0;
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 3ed944c..ef9509e 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -280,16 +280,17 @@ int acpi_pci_irq_add_prt(acpi_handle handle, struct pci_bus *bus)
 	return 0;
 }
 
-void acpi_pci_irq_del_prt(int segment, int bus)
+void acpi_pci_irq_del_prt(struct pci_bus *bus)
 {
 	struct acpi_prt_entry *entry, *tmp;
 
 	printk(KERN_DEBUG
 	       "ACPI: Delete PCI Interrupt Routing Table for %04x:%02x\n",
-	       segment, bus);
+	       pci_domain_nr(bus), bus->number);
 	spin_lock(&acpi_prt_lock);
 	list_for_each_entry_safe(entry, tmp, &acpi_prt_list, list) {
-		if (segment == entry->id.segment && bus == entry->id.bus) {
+		if (pci_domain_nr(bus) == entry->id.segment
+			&& bus->number == entry->id.bus) {
 			list_del(&entry->list);
 			kfree(entry);
 		}
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index 702b12e..12e99c3 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -91,7 +91,7 @@ int acpi_pci_link_free_irq(acpi_handle handle);
 /* ACPI PCI Interrupt Routing (pci_irq.c) */
 
 int acpi_pci_irq_add_prt(acpi_handle handle, struct pci_bus *bus);
-void acpi_pci_irq_del_prt(int segment, int bus);
+void acpi_pci_irq_del_prt(struct pci_bus *bus);
 
 /* ACPI PCI Device Binding (pci_bind.c) */
 

