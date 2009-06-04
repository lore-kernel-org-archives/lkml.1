Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbZFDF7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbZFDF7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbZFDF6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:58:31 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:28858 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbZFDF63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:58:29 -0400
Subject: [PATCH v2 03/11] ACPI: Introduce acpi_get_pci_dev()
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Date: Wed, 03 Jun 2009 23:58:31 -0600
Message-ID: <20090604055831.18802.52360.stgit@bob.kio>
In-Reply-To: <20090604054504.18802.21690.stgit@bob.kio>
References: <20090604054504.18802.21690.stgit@bob.kio>
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

This change lays the groundwork for eliminating much of pci_bind.c.

Although pci_root.c may not be the most logical place for this
change, putting it here saves us from having to export acpi_pci_find_root.

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/pci_root.c     |   81 +++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_drivers.h |    1 +
 2 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 888cb9f..e509991 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -329,6 +329,87 @@ static struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle)
 	return NULL;
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
+	pbus = root->bus;
+
+	/*
+	 * Now, walk back down the PCI device tree until we return to our
+	 * original handle. Assumes that everything between the PCI root
+	 * bridge and the device we're looking for must be a P2P bridge.
+	 */
+	list_for_each_entry(node, &device_list, node) {
+		acpi_handle hnd = node->handle;
+		status = acpi_evaluate_integer(hnd, "_ADR", NULL, &adr);
+		if (ACPI_FAILURE(status))
+			goto out;
+		dev = (adr >> 16) & 0xffff;
+		fn  = adr & 0xffff;
+
+		pdev = pci_get_slot(pbus, PCI_DEVFN(dev, fn));
+		if (hnd == handle)
+			break;
+
+		pbus = pdev->subordinate;
+		pci_dev_put(pdev);
+	}
+out:
+	list_for_each_entry_safe(node, tmp, &device_list, node)
+		kfree(node);
+
+	return pdev;
+}
+EXPORT_SYMBOL_GPL(acpi_get_pci_dev);
+
 /**
  * acpi_pci_osc_control_set - commit requested control to Firmware
  * @handle: acpi_handle for the target ACPI object
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

