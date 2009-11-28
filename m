Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbZK1Hkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbZK1Hkt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 02:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZK1Hks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 02:40:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:34575 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbZK1Hkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 02:40:47 -0500
Message-ID: <4B10D2CF.4060200@kernel.org>
Date: Fri, 27 Nov 2009 23:35:43 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH 4/9] pci: add failed_list to record failed one for pci_bus_assign_resources
 -v2
References: <4ADEB601.8020200@kernel.org>	<4AE55D12.30403@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org> <4AFCF7D8.1090207@jp.fujitsu.com> <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org> <4B0B3C13.9030502@jp.fujit! su.com> <4B0C69AD.3030106@kernel. org> <4B0D13EB.9010403@jp.fujitsu.com> <4B10D084.8070608@kerne!
 l.org>
In-Reply-To: <4B10D084.8070608@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so later we can do sth with those failed one

-v2: store start, end, flags aside. so could keep res cleared when assign
     failed. and make following assignment of its children do not go wild

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   66 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 62 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
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
@@ -58,6 +103,13 @@ static void pbus_assign_resources_sorted
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
@@ -577,19 +629,20 @@ void __ref pci_bus_size_bridges(struct p
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
@@ -607,6 +660,11 @@ void __ref pci_bus_assign_resources(cons
 		}
 	}
 }
+
+void __ref pci_bus_assign_resources(const struct pci_bus *bus)
+{
+	__pci_bus_assign_resources(bus, NULL);
+}
 EXPORT_SYMBOL(pci_bus_assign_resources);
 
 static void release_children_resource(struct resource *r)

