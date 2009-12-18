Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbZLRU6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbZLRU6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932936AbZLRU6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:58:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:57501 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932825AbZLRU4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:56:42 -0500
Message-ID: <4B2BEC48.8030903@kernel.org>
Date: Fri, 18 Dec 2009 12:55:36 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 10/12] pci: pci_bridge_release_res -v2
References: <4B2BE9DD.3040504@kernel.org>
In-Reply-To: <4B2BE9DD.3040504@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


prepare for pciehp_realloc

it will clear the resource size for bridge

-v2: patrick Keller pointed out need to export it...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h     |    1 +
 2 files changed, 44 insertions(+)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -737,6 +737,49 @@ static void __ref __pci_bridge_assign_re
 		break;
 	}
 }
+
+void pci_bridge_release_res(struct pci_bus *bus)
+{
+	int idx;
+	bool changed = false;
+	struct pci_dev *dev;
+	struct resource *r;
+
+	/* The root bus? */
+	if (!bus->self)
+		return;
+
+	/* for pci bridges res only */
+	dev = bus->self;
+	if ((dev->class >> 8) != PCI_CLASS_BRIDGE_PCI)
+		return;
+
+	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_BRIDGE_RESOURCES + 3;
+	     idx++) {
+		r = &dev->resource[idx];
+		if (!r->parent)
+			continue;
+
+		/* if there are children under that, we should not release it */
+		if (r->child)
+			continue;
+
+		if (!release_resource(r)) {
+			dev_printk(KERN_DEBUG, &dev->dev,
+				 "resource %d %pR released\n", idx, r);
+			/* old size is not kept */
+			r->start = 0;
+			r->end   = 0;
+			r->flags = 0;
+			changed = true;
+		}
+	}
+
+	if (changed)
+		pci_setup_bridge(bus);
+}
+EXPORT_SYMBOL_GPL(pci_bridge_release_res);
+
 static void release_child_resources(struct resource *r)
 {
 	struct resource *p;
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -770,6 +770,7 @@ int pci_vpd_truncate(struct pci_dev *dev
 void pci_bus_assign_resources(const struct pci_bus *bus);
 void pci_bus_size_bridges(struct pci_bus *bus);
 int pci_claim_resource(struct pci_dev *, int);
+void pci_bridge_release_res(struct pci_bus *bus);
 void pci_assign_unassigned_resources(void);
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge);
 void pdev_enable_device(struct pci_dev *);


