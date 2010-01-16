Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab0APCnd (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 21:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758397Ab0APCnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 21:43:32 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:57732 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235Ab0APCnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 21:43:25 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 15 Jan 2010 18:41:58 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/11] pci: pciehp second try to get big range for pcie devices
In-reply-to: <1263609721-3921-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Message-id: <1263609721-3921-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263609721-3921-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

handle the case the slot bridge that doesn't get pre-allocated big enough res
from FW.
for example pcie devices need 256M, but the bridge only get preallocated 2M...

-v2: use resource_list_x

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 49 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index c348882..2ff34ca 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1009,12 +1009,60 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 {
 	struct pci_bus *bus;
 	struct pci_bus *parent = bridge->subordinate;
+	bool second_tried = false;
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
+	/* any device complain? */
+	if (!head.next)
+		return;
+
+	if (second_tried) {
+		/* still fail, don't need to try more */
+		free_failed_list(&head);
+		return;
+	}
+
+	second_tried = true;
+	printk(KERN_DEBUG "PCI: second try to assign unassigned res\n");
+
+	/*
+	 * Try to release leaf bridge's resources that doesn't fit resource of
+	 * child device under that bridge
+	 */
+	for (list = head.next; list;) {
+		unsigned long flags = list->flags;
+
+		bus = list->dev->bus;
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

