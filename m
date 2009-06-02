Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbZFBP0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbZFBP0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbZFBPZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:25:17 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:32549 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756884AbZFBPZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:25:14 -0400
Subject: [PATCH 08/10] ACPI: simplify acpi_pci_irq_add_prt() API
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Date: Tue, 02 Jun 2009 09:25:16 -0600
Message-ID: <20090602152516.7346.24236.stgit@bob.kio>
In-Reply-To: <20090602152351.7346.48697.stgit@bob.kio>
References: <20090602152351.7346.48697.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A PCI domain cannot change as you descend down subordinate buses, which
makes the 'segment' argument to acpi_pci_irq_add_prt() useless.

Change the interface to take a struct pci_bus *, from whence we can derive
the bus number and segment. Reducing the number of arguments makes life
simpler for callers.

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/pci_bind.c     |    8 ++++----
 drivers/acpi/pci_irq.c      |   10 +++++-----
 drivers/acpi/pci_root.c     |    5 +++--
 include/acpi/acpi_drivers.h |    2 +-
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
index 0469cf2..96264d2 100644
--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -137,7 +137,7 @@ static int acpi_pci_bind(struct acpi_device *device)
 {
 	acpi_status status;
 	acpi_handle handle;
-	unsigned char bus;
+	struct pci_bus *bus;
 	struct pci_dev *dev;
 
 	dev = acpi_get_pci_dev(device->handle);
@@ -170,11 +170,11 @@ static int acpi_pci_bind(struct acpi_device *device)
 		return 0;
 
 	if (dev->subordinate)
-		bus = dev->subordinate->number;
+		bus = dev->subordinate;
 	else
-		bus = dev->bus->number;
+		bus = dev->bus;
 
-	acpi_pci_irq_add_prt(device->handle, pci_domain_nr(dev->bus), bus);
+	acpi_pci_irq_add_prt(device->handle, bus);
 
 	return 0;
 }
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 51b9f82..3ed944c 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -182,7 +182,7 @@ static void do_prt_fixups(struct acpi_prt_entry *entry,
 	}
 }
 
-static int acpi_pci_irq_add_entry(acpi_handle handle, int segment, int bus,
+static int acpi_pci_irq_add_entry(acpi_handle handle, struct pci_bus *bus,
 				  struct acpi_pci_routing_table *prt)
 {
 	struct acpi_prt_entry *entry;
@@ -196,8 +196,8 @@ static int acpi_pci_irq_add_entry(acpi_handle handle, int segment, int bus,
 	 * 1=INTA, 2=INTB.  We use the PCI encoding throughout, so convert
 	 * it here.
 	 */
-	entry->id.segment = segment;
-	entry->id.bus = bus;
+	entry->id.segment = pci_domain_nr(bus);
+	entry->id.bus = bus->number;
 	entry->id.device = (prt->address >> 16) & 0xFFFF;
 	entry->pin = prt->pin + 1;
 
@@ -242,7 +242,7 @@ static int acpi_pci_irq_add_entry(acpi_handle handle, int segment, int bus,
 	return 0;
 }
 
-int acpi_pci_irq_add_prt(acpi_handle handle, int segment, int bus)
+int acpi_pci_irq_add_prt(acpi_handle handle, struct pci_bus *bus)
 {
 	acpi_status status;
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
@@ -271,7 +271,7 @@ int acpi_pci_irq_add_prt(acpi_handle handle, int segment, int bus)
 
 	entry = buffer.pointer;
 	while (entry && (entry->length > 0)) {
-		acpi_pci_irq_add_entry(handle, segment, bus, entry);
+		acpi_pci_irq_add_entry(handle, bus, entry);
 		entry = (struct acpi_pci_routing_table *)
 		    ((unsigned long)entry + entry->length);
 	}
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 25ddbb6..aa67f72 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -537,8 +537,9 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	 */
 	status = acpi_get_handle(device->handle, METHOD_NAME__PRT, &handle);
 	if (ACPI_SUCCESS(status))
-		result = acpi_pci_irq_add_prt(device->handle, root->id.segment,
-					      root->id.bus);
+		result = acpi_pci_irq_add_prt(device->handle,
+					      pci_find_bus(root->id.segment,
+							   root->id.bus));
 
 	/*
 	 * Scan and bind all _ADR-Based Devices
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index 1c50f4f..c21d83f 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -90,7 +90,7 @@ int acpi_pci_link_free_irq(acpi_handle handle);
 
 /* ACPI PCI Interrupt Routing (pci_irq.c) */
 
-int acpi_pci_irq_add_prt(acpi_handle handle, int segment, int bus);
+int acpi_pci_irq_add_prt(acpi_handle handle, struct pci_bus *bus);
 void acpi_pci_irq_del_prt(int segment, int bus);
 
 /* ACPI PCI Device Binding (pci_bind.c) */

