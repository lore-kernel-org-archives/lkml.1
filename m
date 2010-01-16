Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab0APLKA (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 06:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932123Ab0APLJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 06:09:56 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:63401 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab0APLIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 06:08:54 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Sat, 16 Jan 2010 03:07:14 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/11] pci: pciehp second try to get big range for pcie devices
In-reply-to: <1263640037-24134-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Message-id: <1263640037-24134-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263640037-24134-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

handle the case the slot bridge that doesn't get pre-allocated big enough
resources from FW.
for example pcie devices need 256M, but the bridge only get preallocated 2M...

-v2: use resource_list_x
-v3: use tried_times instead of second tried...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index e56b198..1966b5e 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -983,12 +983,62 @@ enable_and_dump:
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 {
 	struct pci_bus *parent = bridge->subordinate;
+	int tried_times = 0;
+	struct resource_list_x head, *list;
 	int retval;
+	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+				  IORESOURCE_PREFETCH;
+
+	head.next = NULL;
 
+again:
 	pci_bus_size_bridges(parent);
-	__pci_bridge_assign_resources(bridge, NULL);
+	__pci_bridge_assign_resources(bridge, &head);
 	retval = pci_reenable_device(bridge);
 	pci_set_master(bridge);
 	pci_enable_bridges(parent);
+
+	tried_times++;
+
+	/* any device complain? */
+	if (!head.next)
+		return;
+
+	if (tried_times  >= 2) {
+		/* still fail, don't need to try more */
+		free_failed_list(&head);
+		return;
+	}
+
+	printk(KERN_DEBUG "PCI: No. %d try to assign unassigned res\n",
+			 tried_times + 1);
+
+	/*
+	 * Try to release leaf bridge's resources that doesn't fit resource of
+	 * child device under that bridge
+	 */
+	for (list = head.next; list;) {
+		struct pci_bus *bus = list->dev->bus;
+		unsigned long flags = list->flags;
+
+		pci_bus_release_bridge_resources(bus, flags & type_mask,
+						 whole_subtree);
+		list = list->next;
+	}
+	/* retore size and flags */
+	for (list = head.next; list;) {
+		struct resource *res = list->res;
+
+		res->start = list->start;
+		res->end = list->end;
+		res->flags = list->flags;
+		if (list->dev->subordinate)
+			res->flags = 0;
+
+		list = list->next;
+	}
+	free_failed_list(&head);
+
+	goto again;
 }
 EXPORT_SYMBOL_GPL(pci_assign_unassigned_bridge_resources);
-- 
1.6.4.2

