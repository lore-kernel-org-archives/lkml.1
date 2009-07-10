Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbZGJTnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbZGJTnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 15:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbZGJTmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 15:42:40 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:23743 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926AbZGJTmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 15:42:39 -0400
Subject: [PATCH 1/3] ACPI: export acpi_pci_root and friends
To: jbarnes@virtuousgeek.org, lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Fri, 10 Jul 2009 13:42:38 -0600
Message-ID: <20090710194238.30165.41133.stgit@bob.kio>
In-Reply-To: <20090710193601.30165.62311.stgit@bob.kio>
References: <20090710193601.30165.62311.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can simplify ACPI drivers if we can tell whether a handle is an
ACPI PCI root or not.

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/pci_root.c |   17 ++---------------
 include/acpi/acpi_bus.h |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 55b5b90..31b961c 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -61,20 +61,6 @@ static struct acpi_driver acpi_pci_root_driver = {
 		},
 };
 
-struct acpi_pci_root {
-	struct list_head node;
-	struct acpi_device *device;
-	struct pci_bus *bus;
-	u16 segment;
-	u8 bus_nr;
-
-	u32 osc_support_set;	/* _OSC state of support bits */
-	u32 osc_control_set;	/* _OSC state of control bits */
-	u32 osc_control_qry;	/* the latest _OSC query result */
-
-	u32 osc_queried:1;	/* has _OSC control been queried? */
-};
-
 static LIST_HEAD(acpi_pci_roots);
 
 static struct acpi_pci_driver *sub_driver;
@@ -317,7 +303,7 @@ static acpi_status acpi_pci_osc_support(struct acpi_pci_root *root, u32 flags)
 	return status;
 }
 
-static struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle)
+struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle)
 {
 	struct acpi_pci_root *root;
 
@@ -327,6 +313,7 @@ static struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle)
 	}
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(acpi_pci_find_root);
 
 struct acpi_handle_node {
 	struct list_head node;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index c65e4ce..21f7152 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -369,10 +369,24 @@ int register_acpi_bus_type(struct acpi_bus_type *);
 int unregister_acpi_bus_type(struct acpi_bus_type *);
 struct device *acpi_get_physical_device(acpi_handle);
 
+struct acpi_pci_root {
+	struct list_head node;
+	struct acpi_device * device;
+	struct acpi_pci_id id;
+	struct pci_bus *bus;
+
+	u32 osc_support_set;	/* _OSC state of support bits */
+	u32 osc_control_set;	/* _OSC state of control bits */
+	u32 osc_control_qry;	/* the latest _OSC query result */
+
+	u32 osc_queried:1;	/* has _OSC control been queried? */
+};
+
 /* helper */
 acpi_handle acpi_get_child(acpi_handle, acpi_integer);
 int acpi_is_root_bridge(acpi_handle);
 acpi_handle acpi_get_pci_rootbridge_handle(unsigned int, unsigned int);
+struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle);
 #define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)((dev)->archdata.acpi_handle))
 
 #ifdef CONFIG_PM_SLEEP

