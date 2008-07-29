Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbYG2BWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbYG2BWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYG2BWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:22:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:51125 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbYG2BWG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:22:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,269,1215414000"; 
   d="scan'208";a="365544271"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 3/3] PCI: Add pci_read_base() API
Date: Tue, 29 Jul 2008 09:22:03 +0800
Message-ID: <7A25B56E4BE99C4283EB931CD1A40E1101586F18@pdsmsx414.ccr.corp.intel.com>
In-Reply-To: <1217266741-26519-4-git-send-email-matthew@wil.cx>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/3] PCI: Add pci_read_base() API
Thread-Index: Acjw4jyRmQFgS4ZzQ9en3sw2OHpC5gANkJkw
References: <1217266741-26519-1-git-send-email-matthew@wil.cx> <1217266741-26519-4-git-send-email-matthew@wil.cx>
From: "Zhao, Yu" <yu.zhao@intel.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Cc: <linux-kernel@vger.kernel.org>, <eric@anholt.net>,
       "Matthew Wilcox" <willy@linux.intel.com>, <jbarnes@virtuousgeek.org>
X-OriginalArrivalTime: 29 Jul 2008 01:22:05.0075 (UTC) FILETIME=[82C90E30:01C8F119]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

It would be nice if people can have an enhanced pci_update_resource to update non-standard BARs probed by pci_read_base.

Thanks,
Yu

>-----Original Message-----
>From: linux-pci-owner@vger.kernel.org
>[mailto:linux-pci-owner@vger.kernel.org] On Behalf Of Matthew Wilcox
>Sent: Tuesday, July 29, 2008 1:39 AM
>To: jbarnes@virtuousgeek.org
>Cc: linux-kernel@vger.kernel.org; eric@anholt.net; Matthew Wilcox; Matthew
>Wilcox
>Subject: [PATCH 3/3] PCI: Add pci_read_base() API
>
>Some devices have a BAR at a non-standard address.  The pci_read_base()
>API allows us to probe these BARs and fill in a resource for it as if
>they were standard BARs.
>
>Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
>---
> drivers/pci/probe.c |   47 ++++++++++++++++++++++++++++++++++++++++-------
> include/linux/pci.h |   10 ++++++++++
> 2 files changed, 50 insertions(+), 7 deletions(-)
>
>diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>index 2036300..a977d07 100644
>--- a/drivers/pci/probe.c
>+++ b/drivers/pci/probe.c
>@@ -181,13 +181,6 @@ static u64 pci_size(u64 base, u64 maxbase, u64 mask)
> 	return size;
> }
>
>-enum pci_bar_type {
>-	pci_bar_unknown,	/* Standard PCI BAR probe */
>-	pci_bar_io,		/* An io port BAR */
>-	pci_bar_mem32,		/* A 32-bit memory BAR */
>-	pci_bar_mem64,		/* A 64-bit memory BAR */
>-};
>-
> static inline enum pci_bar_type decode_bar(struct resource *res, u32 bar)
> {
> 	if ((bar & PCI_BASE_ADDRESS_SPACE) == PCI_BASE_ADDRESS_SPACE_IO) {
>@@ -300,6 +293,46 @@ static int __pci_read_base(struct pci_dev *dev, enum
>pci_bar_type type,
> 	goto out;
> }
>
>+/**
>+ * pci_read_base - Read a BAR from a specified location
>+ * @dev: The PCI device to read
>+ * @type: The type of BAR to read
>+ * @res: A struct resource to be filled in
>+ * @reg: The address in PCI config space to read the BAR from.
>+ *
>+ * Some devices have BARs in unusual places.  This function lets a driver ask
>+ * the PCI subsystem to read it and place it in the resource tree.  If it is
>+ * like a ROM BAR with an enable in bit 0, the caller should specify a @type
>+ * of io, mem32 or mem64.  If it's like a normal BAR with memory type in the
>+ * low bits, specify unknown, even if the caller knows what kind of BAR it is.
>+ *
>+ * Returns -ENXIO if the BAR was not successfully read.  If the BAR is read,
>+ * but no suitable parent resource can be found for the BAR, this function
>+ * returns -ENODEV.  If the resource cannot be inserted into the resource tree,
>+ * it will return -EBUSY.  Note that the resource is still 'live' for these
>+ * last two cases; the caller should set res->flags to 0 if this is not wanted.
>+ */
>+int pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>+					struct resource *res, unsigned int reg)
>+{
>+	struct pci_bus_region region;
>+	struct resource *parent;
>+
>+	__pci_read_base(dev, type, res, reg);
>+	if (!res->flags)
>+		return -ENXIO;
>+
>+	region.start = res->start;
>+	region.end = res->end;
>+	pcibios_bus_to_resource(dev, res, &region);
>+
>+	parent = pci_find_parent_resource(dev, res);
>+	if (!parent)
>+		return -ENODEV;
>+	return request_resource(parent, res);
>+}
>+EXPORT_SYMBOL_GPL(pci_read_base);
>+
> static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
> {
> 	unsigned int pos, reg;
>diff --git a/include/linux/pci.h b/include/linux/pci.h
>index a6a088e..f6ad5e8 100644
>--- a/include/linux/pci.h
>+++ b/include/linux/pci.h
>@@ -310,6 +310,16 @@ struct pci_bus {
> #define pci_bus_b(n)	list_entry(n, struct pci_bus, node)
> #define to_pci_bus(n)	container_of(n, struct pci_bus, dev)
>
>+enum pci_bar_type {
>+	pci_bar_unknown,	/* Standard PCI BAR probe */
>+	pci_bar_io,		/* An io port BAR */
>+	pci_bar_mem32,		/* A 32-bit memory BAR */
>+	pci_bar_mem64,		/* A 64-bit memory BAR */
>+};
>+
>+int pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>+					struct resource *res, unsigned int reg);
>+
> /*
>  * Error values that may be returned by PCI functions.
>  */
>--
>1.5.5.4
>--
>To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
