Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbZK3V5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbZK3V5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZK3V5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:57:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:51876 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbZK3V53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:57:29 -0500
Message-ID: <4B143F35.3060107@kernel.org>
Date: Mon, 30 Nov 2009 13:55:01 -0800
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
Subject: [PATCH 5/9] pci: update leaf bridge res to get more big range in
 pci assign unssign -v3
References: <4ADEB601.8020200@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org> <4AFCF7D8.1090207@jp.fujitsu.com> <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org> <4B0B3C13.9030502@jp.fujit! su.com> <4B0C69AD.3030106@kernel. org> <4B0D13EB.9010403@jp.fujitsu.com> <4B10D084.8070608@kernel.org> <4B10D2DC.6010001@ker!
 nel.org>
In-Reply-To: <4B10D2DC.6010001@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


BIOS separate IO range between several IOHs, and on some slots, BIOS assign the resource to the bridge, but stop
assigning resource to the device under that bridge, because the device need big resource.

1. pci assign unassign and record the failed device resource.
2. clear the BIOS assigned resource of the parent bridge of fail device
3. go back and call pci assign unsigned
4. if it still fail, will go up more bridges. and clear and try again.

use pci_try_num to control back track bridge levels.

-v2: update it with resource_list_x
-v3: make pci_try_num default to 1. and when pci_try_num is set to more than 1
     will check it with max_depth, and adjust that to make sure it is bigger enough

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/pci.c       |    5 ++
 drivers/pci/pci.h       |    2 
 drivers/pci/setup-bus.c |  117 +++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 123 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -810,11 +810,69 @@ static void pci_bus_dump_resources(struc
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
+ * second try will clear small leaf bridge res
+ * third try will clear related bridge: some aggressive
+ */
+int pci_try_num = 1;
 void __init
 pci_assign_unassigned_resources(void)
 {
 	struct pci_bus *bus;
+	int tried_times = 0;
+	int check_leaf = 1;
+	struct resource_list_x head, *list;
+	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+				  IORESOURCE_PREFETCH;
+	unsigned long failed_type;
+	int max_depth = pci_get_max_depth();
 
+	head.next = NULL;
+
+	if (pci_try_num > 1) {
+		if (max_depth + 1 > pci_try_num)
+			pci_try_num = max_depth + 1;
+	}
+
+	printk(KERN_DEBUG "PCI: max depth: %d pci_try_num: %d\n",
+		 max_depth, pci_try_num);
+
+again:
 	/* Depth first, calculate sizes and alignments of all
 	   subordinate buses. */
 	list_for_each_entry(bus, &pci_root_buses, node) {
@@ -822,7 +880,64 @@ pci_assign_unassigned_resources(void)
 	}
 	/* Depth last, allocate resources and update the hardware. */
 	list_for_each_entry(bus, &pci_root_buses, node) {
-		pci_bus_assign_resources(bus);
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
+		check_leaf = 0;
+
+	/*
+	 * Try to release leaf bridge's resources that doesn't fit resource of
+	 * child device under that bridge
+	 */
+	for (list = head.next; list;) {
+		bus = list->dev->bus;
+		pci_bus_release_unused_bridge_res(bus, list->flags & type_mask,
+						  check_leaf);
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
+
+enable_and_dump:
+	/* Depth last, update the hardware. */
+	list_for_each_entry(bus, &pci_root_buses, node) {
 		pci_enable_bridges(bus);
 	}
 
Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -2777,6 +2777,11 @@ static int __init pci_setup(char *str)
 				pci_no_aer();
 			} else if (!strcmp(str, "nodomains")) {
 				pci_no_domains();
+			} else if (!strncmp(str, "try=", 4)) {
+				int try_num = memparse(str + 4, &str);
+
+				if (try_num > 0 && try_num < 16)
+					pci_try_num = try_num;
 			} else if (!strncmp(str, "cbiosize=", 9)) {
 				pci_cardbus_io_size = memparse(str + 9, &str);
 			} else if (!strncmp(str, "cbmemsize=", 10)) {
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -203,6 +203,8 @@ static inline int pci_ari_enabled(struct
 	return bus->self && bus->self->ari_enabled;
 }
 
+extern int pci_try_num;
+
 #ifdef CONFIG_PCI_QUIRKS
 extern int pci_is_reassigndev(struct pci_dev *dev);
 resource_size_t pci_specified_resource_alignment(struct pci_dev *dev);
