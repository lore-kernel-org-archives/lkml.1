Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab0APLMB (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 06:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707Ab0APLIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 06:08:50 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38783 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab0APLIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 06:08:49 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Sat, 16 Jan 2010 03:07:08 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/11] pci: add failed_list to record failed one for
 pci_bus_assign_resources
In-reply-to: <1263640037-24134-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Message-id: <1263640037-24134-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263640037-24134-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so later we can try to assign resource those failed devices again.

-v2: store start, end, flags aside. so could keep res cleared when assign
     failed. and make following assignment of its children do not go wild
-v3: update comments

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |   66 ++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 7a18428..fa9f4e2 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -27,7 +27,52 @@
 #include <linux/slab.h>
 #include "pci.h"
 
-static void pbus_assign_resources_sorted(const struct pci_bus *bus)
+struct resource_list_x {
+	struct resource_list_x *next;
+	struct resource *res;
+	struct pci_dev *dev;
+	resource_size_t start;
+	resource_size_t end;
+	unsigned long flags;
+};
+
+static void add_to_failed_list(struct resource_list_x *head,
+				 struct pci_dev *dev, struct resource *res)
+{
+	struct resource_list_x *list = head;
+	struct resource_list_x *ln = list->next;
+	struct resource_list_x *tmp;
+
+	tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
+	if (!tmp) {
+		pr_warning("add_to_failed_list: kmalloc() failed!\n");
+		return;
+	}
+
+	tmp->next = ln;
+	tmp->res = res;
+	tmp->dev = dev;
+	tmp->start = res->start;
+	tmp->end = res->end;
+	tmp->flags = res->flags;
+	list->next = tmp;
+}
+
+static void free_failed_list(struct resource_list_x *head)
+{
+	struct resource_list_x *list, *tmp;
+
+	for (list = head->next; list;) {
+		tmp = list;
+		list = list->next;
+		kfree(tmp);
+	}
+
+	head->next = NULL;
+}
+
+static void pbus_assign_resources_sorted(const struct pci_bus *bus,
+					 struct resource_list_x *fail_head)
 {
 	struct pci_dev *dev;
 	struct resource *res;
@@ -58,6 +103,13 @@ static void pbus_assign_resources_sorted(const struct pci_bus *bus)
 		res = list->res;
 		idx = res - &list->dev->resource[0];
 		if (pci_assign_resource(list->dev, idx)) {
+			if (fail_head && !pci_is_root_bus(list->dev->bus)) {
+				/*
+				 * device need to keep flags and size
+				 * for next try
+				 */
+				add_to_failed_list(fail_head, list->dev, res);
+			}
 			res->start = 0;
 			res->end = 0;
 			res->flags = 0;
@@ -572,19 +624,20 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
 }
 EXPORT_SYMBOL(pci_bus_size_bridges);
 
-void __ref pci_bus_assign_resources(const struct pci_bus *bus)
+static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
+					 struct resource_list_x *fail_head)
 {
 	struct pci_bus *b;
 	struct pci_dev *dev;
 
-	pbus_assign_resources_sorted(bus);
+	pbus_assign_resources_sorted(bus, fail_head);
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		b = dev->subordinate;
 		if (!b)
 			continue;
 
-		pci_bus_assign_resources(b);
+		__pci_bus_assign_resources(b, fail_head);
 
 		switch (dev->class >> 8) {
 		case PCI_CLASS_BRIDGE_PCI:
@@ -602,6 +655,11 @@ void __ref pci_bus_assign_resources(const struct pci_bus *bus)
 		}
 	}
 }
+
+void __ref pci_bus_assign_resources(const struct pci_bus *bus)
+{
+	__pci_bus_assign_resources(bus, NULL);
+}
 EXPORT_SYMBOL(pci_bus_assign_resources);
 
 static void pci_bridge_release_resources(struct pci_bus *bus,
-- 
1.6.4.2

