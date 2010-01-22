Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732Ab0AVJGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab0AVJGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 04:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595Ab0AVJDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 04:03:11 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45862 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab0AVJDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 04:03:06 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 22 Jan 2010 01:02:24 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 5/9] pci: update bridge res to get more big range in pci assign
 unssign
In-reply-to: <1264150948-9052-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1264150948-9052-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1264150948-9052-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BIOS separate IO range between several IOHs, and on some slots, BIOS assign the
resource to the bridge, but stop assigning resource to the device under that
bridge, because the device need big resource.

1. pci assign unassign and record the failed device resource.
2. clear the BIOS assigned resource of the parent bridge of fail device
3. go back and call pci assign unsigned
4. if it still fail, will go up more bridges. and clear and try again.

use pci_try_num to control back track bridge levels.

-v2: update it with resource_list_x
-v3: make pci_try_num default to 1. and when pci_try_num is set to more than 1
     will check it with max_depth, and adjust that to make sure it is bigger
     enough
-v4: update to enum release_type and _used_calling
-v5: seems all doesn't like pci=try=N at this point, let remove it at first
-v6: fix typo about restore ...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |  114 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 112 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index f560814..f76f6e9 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -780,11 +780,65 @@ static void pci_bus_dump_resources(struct pci_bus *bus)
 	}
 }
 
+static int __init pci_bus_get_depth(struct pci_bus *bus)
+{
+	int depth = 0;
+	struct pci_dev *dev;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		int ret;
+		struct pci_bus *b = dev->subordinate;
+		if (!b)
+			continue;
+
+		ret = pci_bus_get_depth(b);
+		if (ret + 1 > depth)
+			depth = ret + 1;
+	}
+
+	return depth;
+}
+static int __init pci_get_max_depth(void)
+{
+	int depth = 0;
+	struct pci_bus *bus;
+
+	list_for_each_entry(bus, &pci_root_buses, node) {
+		int ret;
+
+		ret = pci_bus_get_depth(bus);
+		if (ret > depth)
+			depth = ret;
+	}
+
+	return depth;
+}
+
+/*
+ * first try will not touch pci bridge res
+ * second  and later try will clear small leaf bridge res
+ * will stop till to the max  deepth if can not find good one
+ */
 void __init
 pci_assign_unassigned_resources(void)
 {
 	struct pci_bus *bus;
+	int tried_times = 0;
+	enum release_type rel_type = leaf_only;
+	struct resource_list_x head, *list;
+	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+				  IORESOURCE_PREFETCH;
+	unsigned long failed_type;
+	int max_depth = pci_get_max_depth();
+	int pci_try_num;
+
+	head.next = NULL;
 
+	pci_try_num = max_depth + 1;
+	printk(KERN_DEBUG "PCI: max bus depth: %d pci_try_num: %d\n",
+		 max_depth, pci_try_num);
+
+again:
 	/* Depth first, calculate sizes and alignments of all
 	   subordinate buses. */
 	list_for_each_entry(bus, &pci_root_buses, node) {
@@ -792,9 +846,65 @@ pci_assign_unassigned_resources(void)
 	}
 	/* Depth last, allocate resources and update the hardware. */
 	list_for_each_entry(bus, &pci_root_buses, node) {
-		pci_bus_assign_resources(bus);
-		pci_enable_bridges(bus);
+		__pci_bus_assign_resources(bus, &head);
+	}
+	tried_times++;
+
+	/* any device complain? */
+	if (!head.next)
+		goto enable_and_dump;
+	failed_type = 0;
+	for (list = head.next; list;) {
+		failed_type |= list->flags;
+		list = list->next;
+	}
+	/*
+	 * io port are tight, don't try extra
+	 * or if reach the limit, don't want to try more
+	 */
+	failed_type &= type_mask;
+	if ((failed_type == IORESOURCE_IO) || (tried_times >= pci_try_num)) {
+		free_failed_list(&head);
+		goto enable_and_dump;
+	}
+
+	printk(KERN_DEBUG "PCI: No. %d try to assign unassigned res\n",
+			 tried_times + 1);
+
+	/* third times and later will not check if it is leaf */
+	if ((tried_times + 1) > 2)
+		rel_type = whole_subtree;
+
+	/*
+	 * Try to release leaf bridge's resources that doesn't fit resource of
+	 * child device under that bridge
+	 */
+	for (list = head.next; list;) {
+		bus = list->dev->bus;
+		pci_bus_release_bridge_resources(bus, list->flags & type_mask,
+						  rel_type);
+		list = list->next;
 	}
+	/* restore size and flags */
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
+
+enable_and_dump:
+	/* Depth last, update the hardware. */
+	list_for_each_entry(bus, &pci_root_buses, node)
+		pci_enable_bridges(bus);
 
 	/* dump the resource on buses */
 	list_for_each_entry(bus, &pci_root_buses, node) {
-- 
1.6.4.2

