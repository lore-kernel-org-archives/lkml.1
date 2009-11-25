Return-Path: <linux-kernel-owner+w=401wt.eu-S1759706AbZKYUAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706AbZKYUAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759696AbZKYUAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:00:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:56877 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759676AbZKYUAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:00:13 -0500
Message-ID: <4B0D8C94.8020305@kernel.org>
Date: Wed, 25 Nov 2009 11:59:16 -0800
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
Subject: [PATCH 2/9] pci: add pci_bridge_release_unused_res and pci_bus_release_unused_bridge_res
References: <4ADEB601.8020200@kernel.org>	<4AE55D12.30403@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org> <4AFCF7D8.1090207@jp.fujitsu.com> <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org> <4B0B3C13.9030502@jp.fujit! su.com> <4B0C69AD.3030106@kernel. org> <4B0D13EB.9010403@jp.fujitsu.com> <4B0D88A4.5050904@kerne!
 l.org>
In-Reply-To: <4B0D88A4.5050904@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so later we could use it to release small resource before pci assign unassign res

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |  112 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 111 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -609,13 +609,123 @@ void __ref pci_bus_assign_resources(cons
 }
 EXPORT_SYMBOL(pci_bus_assign_resources);
 
+static void release_children_resource(struct resource *r)
+{
+	struct resource *p;
+	resource_size_t size;
+
+	p = r->child;
+	while (p) {
+		release_children_resource(p);
+		release_resource(p);
+		printk(KERN_DEBUG "PCI: release child resource %pRt\n", p);
+		/* need to restore size, and keep flags */
+		size = resource_size(p);
+		p->start = 0;
+		p->end = size - 1;
+		p = r->child;
+	}
+}
+
+static void pci_bridge_release_unused_res(struct pci_bus *bus,
+					  unsigned long type)
+{
+	int idx;
+	bool changed = false;
+	struct pci_dev *dev;
+	struct resource *r;
+	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+				  IORESOURCE_PREFETCH;
+
+	/* for pci bridges res only */
+	dev = bus->self;
+	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_BRIDGE_RESOURCES + 3;
+	    idx++) {
+		r = &dev->resource[idx];
+		if ((r->flags & type_mask) != type)
+			continue;
+		if (!r->parent)
+			continue;
+		/*
+		 * if there are children under that, we should release them
+		 *  all
+		 */
+		release_children_resource(r);
+		if (!release_resource(r)) {
+			dev_printk(KERN_DEBUG, &dev->dev,
+				 "resource %d %pRt released\n", idx, r);
+			r->flags = 0;
+			changed = true;
+		}
+	}
+
+	if (changed) {
+		if (type & IORESOURCE_PREFETCH) {
+			/* avoiding touch the one without PREF */
+			type = IORESOURCE_PREFETCH;
+		}
+		__pci_setup_bridge(bus, type);
+	}
+}
+
+/*
+ * try to release pci bridge resources that is from leaf bridge,
+ * so we can allocate big new one later
+ * check:
+ *    0: only release the bridge and only the bridge is leaf
+ *    1: release all down side bridge for third shoot
+ */
+static void __ref pci_bus_release_unused_bridge_res(struct pci_bus *bus,
+						    unsigned long type,
+						    int check_leaf)
+{
+	struct pci_dev *dev;
+	bool is_leaf_bridge = true;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		struct pci_bus *b = dev->subordinate;
+		if (!b)
+			continue;
+
+		switch (dev->class >> 8) {
+		case PCI_CLASS_BRIDGE_CARDBUS:
+			is_leaf_bridge = false;
+			break;
+
+		case PCI_CLASS_BRIDGE_PCI:
+		default:
+			is_leaf_bridge = false;
+			if (!check_leaf)
+				pci_bus_release_unused_bridge_res(b, type,
+							 check_leaf);
+			break;
+		}
+	}
+
+	/* The root bus? */
+	if (!bus->self)
+		return;
+
+	switch (bus->self->class >> 8) {
+	case PCI_CLASS_BRIDGE_CARDBUS:
+		break;
+
+	case PCI_CLASS_BRIDGE_PCI:
+	default:
+		if ((check_leaf && is_leaf_bridge) || !check_leaf)
+			pci_bridge_release_unused_res(bus, type);
+		break;
+	}
+}
+
 static void pci_bus_dump_res(struct pci_bus *bus)
 {
         int i;
 
         for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
                 struct resource *res = bus->resource[i];
-                if (!res || !res->end)
+
+		if (!res || !res->end)
                         continue;
 
 		dev_printk(KERN_DEBUG, &bus->dev, "resource %d %pR\n", i, res);

