Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbYG1Rjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbYG1Rjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759501AbYG1RjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:39:08 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:49335 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbYG1RjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:39:06 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, eric@anholt.net,
       Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 3/3] PCI: Add pci_read_base() API
Date: Mon, 28 Jul 2008 13:39:01 -0400
Message-Id: <1217266741-26519-4-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1217266741-26519-1-git-send-email-matthew@wil.cx>
References: <1217266741-26519-1-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices have a BAR at a non-standard address.  The pci_read_base()
API allows us to probe these BARs and fill in a resource for it as if
they were standard BARs.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/pci/probe.c |   47 ++++++++++++++++++++++++++++++++++++++++-------
 include/linux/pci.h |   10 ++++++++++
 2 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 2036300..a977d07 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -181,13 +181,6 @@ static u64 pci_size(u64 base, u64 maxbase, u64 mask)
 	return size;
 }
 
-enum pci_bar_type {
-	pci_bar_unknown,	/* Standard PCI BAR probe */
-	pci_bar_io,		/* An io port BAR */
-	pci_bar_mem32,		/* A 32-bit memory BAR */
-	pci_bar_mem64,		/* A 64-bit memory BAR */
-};
-
 static inline enum pci_bar_type decode_bar(struct resource *res, u32 bar)
 {
 	if ((bar & PCI_BASE_ADDRESS_SPACE) == PCI_BASE_ADDRESS_SPACE_IO) {
@@ -300,6 +293,46 @@ static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 	goto out;
 }
 
+/**
+ * pci_read_base - Read a BAR from a specified location
+ * @dev: The PCI device to read
+ * @type: The type of BAR to read
+ * @res: A struct resource to be filled in
+ * @reg: The address in PCI config space to read the BAR from.
+ *
+ * Some devices have BARs in unusual places.  This function lets a driver ask
+ * the PCI subsystem to read it and place it in the resource tree.  If it is
+ * like a ROM BAR with an enable in bit 0, the caller should specify a @type
+ * of io, mem32 or mem64.  If it's like a normal BAR with memory type in the
+ * low bits, specify unknown, even if the caller knows what kind of BAR it is.
+ *
+ * Returns -ENXIO if the BAR was not successfully read.  If the BAR is read,
+ * but no suitable parent resource can be found for the BAR, this function
+ * returns -ENODEV.  If the resource cannot be inserted into the resource tree,
+ * it will return -EBUSY.  Note that the resource is still 'live' for these
+ * last two cases; the caller should set res->flags to 0 if this is not wanted.
+ */
+int pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
+					struct resource *res, unsigned int reg)
+{
+	struct pci_bus_region region;
+	struct resource *parent;
+
+	__pci_read_base(dev, type, res, reg);
+	if (!res->flags)
+		return -ENXIO;
+
+	region.start = res->start;
+	region.end = res->end;
+	pcibios_bus_to_resource(dev, res, &region);
+
+	parent = pci_find_parent_resource(dev, res);
+	if (!parent)
+		return -ENODEV;
+	return request_resource(parent, res);
+}
+EXPORT_SYMBOL_GPL(pci_read_base);
+
 static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 {
 	unsigned int pos, reg;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a6a088e..f6ad5e8 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -310,6 +310,16 @@ struct pci_bus {
 #define pci_bus_b(n)	list_entry(n, struct pci_bus, node)
 #define to_pci_bus(n)	container_of(n, struct pci_bus, dev)
 
+enum pci_bar_type {
+	pci_bar_unknown,	/* Standard PCI BAR probe */
+	pci_bar_io,		/* An io port BAR */
+	pci_bar_mem32,		/* A 32-bit memory BAR */
+	pci_bar_mem64,		/* A 64-bit memory BAR */
+};
+
+int pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
+					struct resource *res, unsigned int reg);
+
 /*
  * Error values that may be returned by PCI functions.
  */
-- 
1.5.5.4

