Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbZLVXGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbZLVXGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 18:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbZLVXFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 18:05:36 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61985 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbZLVXDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 18:03:48 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 22 Dec 2009 15:02:32 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 12/14] pci: pci_bridge_release_res
In-reply-to: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1261522954-12591-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.0.2
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
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
 2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index cc3474e..4c61b8c 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -742,6 +742,49 @@ static void __ref __pci_bridge_assign_resources(const struct pci_dev *bridge,
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
 static void pci_bridge_release_unused_res(struct pci_bus *bus,
 					  unsigned long type)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 31fec6f..4b8d35a 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -770,6 +770,7 @@ int pci_vpd_truncate(struct pci_dev *dev, size_t size);
 void pci_bus_assign_resources(const struct pci_bus *bus);
 void pci_bus_size_bridges(struct pci_bus *bus);
 int pci_claim_resource(struct pci_dev *, int);
+void pci_bridge_release_res(struct pci_bus *bus);
 void pci_assign_unassigned_resources(void);
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge);
 void pdev_enable_device(struct pci_dev *);
-- 
1.6.0.2

