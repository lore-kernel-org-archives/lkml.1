Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZLVXF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZLVXF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 18:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbZLVXFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 18:05:42 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61982 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbZLVXDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 18:03:48 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 22 Dec 2009 15:02:31 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 11/14] pci: pciehp second try to get big range for pcie devices
In-reply-to: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1261522954-12591-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.0.2
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

handle the case the slot bridge that doesn't get pre-allocated big enough res
from FW.
for example pcie devices need 256M, but the bridge only get preallocated 2M...

-v2: use resource_list_x

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 056b98d..cc3474e 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1007,13 +1007,60 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
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
 	pci_clear_master(bridge);
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
+		pci_bus_release_unused_bridge_res(bus, flags & type_mask, 0);
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
1.6.0.2

