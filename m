Return-Path: <linux-kernel-owner+w=401wt.eu-S933088AbZJLTOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbZJLTOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933081AbZJLTOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:14:43 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:46170 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933079AbZJLTOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:14:42 -0400
Subject: [PATCH v2 1/4] PCI: add pci_get_domain_bus_and_slot function
To: ying.huang@intel.com
From: Andrew Patterson <andrew.patterson@hp.com>
Cc: prarit@redhat.com, linux-pci@vger.kernel.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
Date: Mon, 12 Oct 2009 13:14:00 -0600
Message-ID: <20091012191359.14959.65418.stgit@bob.kio>
In-Reply-To: <20091012191354.14959.47024.stgit@bob.kio>
References: <20091012191354.14959.47024.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI: add pci_get_domain_bus_and_slot function

Added the pci_get_domain_and_slot_function which is analogous to
pci_get_bus_and_slot. It returns a pci_dev given a domain (segment) number,
bus number, and devnr. Like pci_get_bus_and_slot,
pci_get_domain_bus_and_slot holds a reference to the returned pci_dev.

Converted pci_get_bus_and_slot to a wrapper that calls
pci_get_domain_bus_and_slot with the domain hard-coded to 0.

This routine was patterned off code suggested by Bjorn Helgaas.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index ec41535..7582648 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -149,32 +149,33 @@ struct pci_dev * pci_get_slot(struct pci_bus *bus, unsigned int devfn)
 }
 
 /**
- * pci_get_bus_and_slot - locate PCI device from a given PCI bus & slot
- * @bus: number of PCI bus on which desired PCI device resides
- * @devfn: encodes number of PCI slot in which the desired PCI
- * device resides and the logical device number within that slot
- * in case of multi-function devices.
- *
- * Note: the bus/slot search is limited to PCI domain (segment) 0.
+ * pci_get_domain_bus_and_slot - locate PCI device for a given PCI domain (segment), bus, and slot
+ * @domain: PCI domain/segment on which the PCI device resides.
+ * @bus: PCI bus on which desired PCI device resides
+ * @devfn: encodes number of PCI slot in which the desired PCI device
+ * resides and the logical device number within that slot in case of
+ * multi-function devices.
  *
- * Given a PCI bus and slot/function number, the desired PCI device
- * is located in system global list of PCI devices.  If the device
- * is found, a pointer to its data structure is returned.  If no
- * device is found, %NULL is returned. The returned device has its
- * reference count bumped by one.
+ * Given a PCI domain, bus, and slot/function number, the desired PCI
+ * device is located in the list of PCI devices. If the device is
+ * found, its reference count is increased and this function returns a
+ * pointer to its data structure.  The caller must decrement the
+ * reference count by calling pci_dev_put().  If no device is found,
+ * %NULL is returned.
  */
-
-struct pci_dev * pci_get_bus_and_slot(unsigned int bus, unsigned int devfn)
+struct pci_dev *pci_get_domain_bus_and_slot(int domain, unsigned int bus,
+					    unsigned int devfn)
 {
 	struct pci_dev *dev = NULL;
 
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-		if (pci_domain_nr(dev->bus) == 0 &&
-		   (dev->bus->number == bus && dev->devfn == devfn))
+		if (pci_domain_nr(dev->bus) == domain &&
+		    (dev->bus->number == bus && dev->devfn == devfn))
 			return dev;
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(pci_get_domain_bus_and_slot);
 
 static int match_pci_dev_by_id(struct device *dev, void *data)
 {
@@ -354,5 +355,4 @@ EXPORT_SYMBOL(pci_find_next_bus);
 EXPORT_SYMBOL(pci_get_device);
 EXPORT_SYMBOL(pci_get_subsys);
 EXPORT_SYMBOL(pci_get_slot);
-EXPORT_SYMBOL(pci_get_bus_and_slot);
 EXPORT_SYMBOL(pci_get_class);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index f5c7cd3..b9b5cd5 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -635,7 +635,13 @@ struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
 				unsigned int ss_vendor, unsigned int ss_device,
 				struct pci_dev *from);
 struct pci_dev *pci_get_slot(struct pci_bus *bus, unsigned int devfn);
-struct pci_dev *pci_get_bus_and_slot(unsigned int bus, unsigned int devfn);
+struct pci_dev *pci_get_domain_bus_and_slot(int domain, unsigned int bus,
+					    unsigned int devfn);
+static inline struct pci_dev *pci_get_bus_and_slot(unsigned int bus,
+						   unsigned int devfn)
+{
+	return pci_get_domain_bus_and_slot(0, bus, devfn);
+}
 struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from);
 int pci_dev_present(const struct pci_device_id *ids);
 

