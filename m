Return-Path: <linux-kernel-owner+w=401wt.eu-S932966AbZLRU6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbZLRU6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932938AbZLRU62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:58:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:52677 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932859AbZLRU4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:56:34 -0500
Message-ID: <4B2BEC43.80401@kernel.org>
Date: Fri, 18 Dec 2009 12:55:31 -0800
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
Subject: [PATCH 9/12] pci: pciehp second try to get big range for pcie devices
 -v2
References: <4B2BE9DD.3040504@kernel.org>
In-Reply-To: <4B2BE9DD.3040504@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



handle the case the slot bridge that doesn't get pre-allocated big enough res
from FW.
for example pcie devices need 256M, but the bridge only get preallocated 2M...

-v2: use resource_list_x

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -1021,13 +1021,60 @@ void pci_assign_unassigned_bridge_resour
 {
 	struct pci_bus *bus;
 	struct pci_bus *parent = bridge->subordinate;
+	bool second_tried = false;
+	struct resource_list_x head, *list;
 	int retval;
+	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+				  IORESOURCE_PREFETCH;
 
+	head.next = NULL;
+
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


