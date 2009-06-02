Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbZFBPZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbZFBPZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757838AbZFBPY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:24:56 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:47268 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803AbZFBPYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:24:54 -0400
Subject: [PATCH 04/10] ACPI: Introduce acpi_get_pci_dev()
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Date: Tue, 02 Jun 2009 09:24:56 -0600
Message-ID: <20090602152456.7346.64853.stgit@bob.kio>
In-Reply-To: <20090602152351.7346.48697.stgit@bob.kio>
References: <20090602152351.7346.48697.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert an ACPI CA handle to a struct pci_dev.

Performing this lookup dynamically allows us to get rid of the
ACPI-PCI binding code, which:

	- eliminates struct acpi_device vs struct pci_dev lifetime issues
	- lays more groundwork for eliminating .start from acpi_device_ops
	  and thus simplifying ACPI drivers
	- whacks out a lot of code

This change also changes the time-space tradeoff ever so slightly.

Looking up the ACPI-PCI binding is never in the performance path, and by
eliminating this caching, we save 24 bytes for each _ADR device in the
ACPI namespace.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/pci_bind.c     |   83 +++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_drivers.h |    1 +
 2 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
index 236765c..584fa30 100644
--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -56,6 +56,89 @@ static void acpi_pci_data_handler(acpi_handle handle, u32 function,
 	return;
 }
 
+struct acpi_handle_node {
+	struct list_head node;
+	acpi_handle handle;
+};
+
+/**
+ * acpi_get_pci_dev - convert ACPI CA handle to struct pci_dev
+ * @handle: the handle in question
+ *
+ * Given an ACPI CA handle, the desired PCI device is located in the
+ * list of PCI devices.
+ *
+ * If the device is found, its reference count is increased and this
+ * function returns a pointer to its data structure.  The caller must
+ * decrement the reference count by calling pci_dev_put().
+ * If no device is found, %NULL is returned.
+ */
+struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
+{
+	int dev, fn;
+	unsigned long long adr;
+	acpi_status status;
+	acpi_handle phandle;
+	struct pci_bus *pbus;
+	struct pci_dev *pdev = NULL;
+	struct acpi_handle_node *node, *tmp;
+	struct acpi_pci_root *root;
+	LIST_HEAD(device_list);
+
+	/*
+	 * Walk up the ACPI CA namespace until we reach a PCI root bridge.
+	 */
+	phandle = handle;
+	while (!acpi_is_root_bridge(phandle)) {
+		node = kzalloc(sizeof(struct acpi_handle_node), GFP_KERNEL);
+		if (!node)
+			goto out;
+
+		INIT_LIST_HEAD(&node->node);
+		node->handle = phandle;
+		list_add(&node->node, &device_list);
+
+		status = acpi_get_parent(phandle, &phandle);
+		if (ACPI_FAILURE(status))
+			goto out;
+	}
+
+	root = acpi_pci_find_root(phandle);
+	if (!root)
+		goto out;
+
+	pbus = pci_find_bus(root->id.segment, root->id.bus);
+	if (!pbus)
+		goto out;
+
+	/*
+	 * Now, walk back down the PCI device tree until we return to our
+	 * original handle. Assumes that everything between the PCI root
+	 * bridge and the device we're looking for must be a P2P bridge.
+	 */
+	list_for_each_entry_safe(node, tmp, &device_list, node) {
+		acpi_handle hnd = node->handle;
+		status = acpi_evaluate_integer(hnd, "_ADR", NULL, &adr);
+		if (ACPI_FAILURE(status))
+			goto out;
+		dev = (adr >> 16) & 0xffff;
+		fn  = adr & 0xffff;
+
+		list_del(&node->node);
+		kfree(node);
+
+		pdev = pci_get_slot(pbus, PCI_DEVFN(dev, fn));
+		if (hnd == handle)
+			break;
+
+		pbus = pdev->subordinate;
+		pci_dev_put(pdev);
+	}
+out:
+	return pdev;
+}
+EXPORT_SYMBOL_GPL(acpi_get_pci_dev);
+
 /**
  * acpi_get_pci_id
  * ------------------
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index bbe9207..1ef529b 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -97,6 +97,7 @@ void acpi_pci_irq_del_prt(int segment, int bus);
 
 struct pci_bus;
 
+struct pci_dev *acpi_get_pci_dev(acpi_handle);
 acpi_status acpi_get_pci_id(acpi_handle handle, struct acpi_pci_id *id);
 int acpi_pci_bind_root(struct acpi_device *device, struct acpi_pci_id *id,
 		       struct pci_bus *bus);

