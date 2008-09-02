Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbYIBPlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbYIBPlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 11:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYIBPky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 11:40:54 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:16603 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbYIBPkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 11:40:53 -0400
Date: Tue, 2 Sep 2008 09:40:51 -0600
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] PCI: connect struct pci_dev to struct pci_slot
Message-ID: <20080902154051.GA23638@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-pci <linux-pci@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The introduction of struct pci_slot (f46753c5e354b857b20ab8e0fe7b25)
added a struct pci_slot pointer to struct pci_dev, but we forgot to
associate the two.

Connect the two structs together; the interesting portions of the object
lifetimes are:

	- when a new pci_slot is created, connect it to the appropriate
	  pci_dev's. A single pci_slot may be associated with multiple
	  pci_dev's, e.g. any multi-function PCI device.

	- when a pci_slot is released, look for all the pci_dev's it was
	  associated with, and set their pci_slot pointers to NULL

	- when a pci_dev is created, look for slots to associate with.

Note -- when a pci_dev is released, we don't need to do any bookkeeping,
since pci_slot's do not have pointers to pci_dev's.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
This patch applies to Jesse's linux-next branch.

 drivers/pci/probe.c |    5 +++++
 drivers/pci/slot.c  |   10 ++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index d8d3f90..c4f7d0c 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -944,6 +944,7 @@ EXPORT_SYMBOL(alloc_pci_dev);
 static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 {
 	struct pci_dev *dev;
+	struct pci_slot *slot;
 	u32 l;
 	u8 hdr_type;
 	int delay = 1;
@@ -992,6 +993,10 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 	dev->error_state = pci_channel_io_normal;
 	set_pcie_port_type(dev);
 
+	list_for_each_entry(slot, &bus->slots, list)
+		if (PCI_SLOT(devfn) == slot->number)
+			dev->slot = slot;
+
 	/* Assume 32-bit PCI; let 64-bit PCI cards (which are far rarer)
 	   set this higher, assuming the system even supports it.  */
 	dev->dma_mask = 0xffffffff;
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 7e5b85c..0c6db03 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -49,11 +49,16 @@ static ssize_t address_read_file(struct pci_slot *slot, char *buf)
 
 static void pci_slot_release(struct kobject *kobj)
 {
+	struct pci_dev *dev;
 	struct pci_slot *slot = to_pci_slot(kobj);
 
 	pr_debug("%s: releasing pci_slot on %x:%d\n", __func__,
 		 slot->bus->number, slot->number);
 
+	list_for_each_entry(dev, &slot->bus->devices, bus_list)
+		if (PCI_SLOT(dev->devfn) == slot->number)
+			dev->slot = NULL;
+
 	list_del(&slot->list);
 
 	kfree(slot);
@@ -108,6 +113,7 @@ static struct kobj_type pci_slot_ktype = {
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 				 const char *name)
 {
+	struct pci_dev *dev;
 	struct pci_slot *slot;
 	int err;
 
@@ -150,6 +156,10 @@ placeholder:
 	INIT_LIST_HEAD(&slot->list);
 	list_add(&slot->list, &parent->slots);
 
+	list_for_each_entry(dev, &parent->devices, bus_list)
+		if (PCI_SLOT(dev->devfn) == slot_nr)
+			dev->slot = slot;
+
 	/* Don't care if debug printk has a -1 for slot_nr */
 	pr_debug("%s: created pci_slot on %04x:%02x:%02x\n",
 		 __func__, pci_domain_nr(parent), parent->number, slot_nr);
-- 
1.6.0.1.161.g7f314

