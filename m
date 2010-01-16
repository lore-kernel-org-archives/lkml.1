Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab0APCqZ (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 21:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758242Ab0APCpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 21:45:53 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:57733 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236Ab0APCnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 21:43:25 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 15 Jan 2010 18:41:59 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 09/11] pci: pci_bridge_release_res
In-reply-to: <1263609721-3921-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Message-id: <1263609721-3921-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263609721-3921-1-git-send-email-yinghai@kernel.org>
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
index 2ff34ca..89a531f 100644
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
 static void pci_bridge_release_resources(struct pci_bus *bus,
 					  unsigned long type)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 0e240ed..b8c7e45 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -805,6 +805,7 @@ int pci_vpd_truncate(struct pci_dev *dev, size_t size);
 void pci_bus_assign_resources(const struct pci_bus *bus);
 void pci_bus_size_bridges(struct pci_bus *bus);
 int pci_claim_resource(struct pci_dev *, int);
+void pci_bridge_release_res(struct pci_bus *bus);
 void pci_assign_unassigned_resources(void);
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge);
 void pdev_enable_device(struct pci_dev *);
-- 
1.6.4.2

