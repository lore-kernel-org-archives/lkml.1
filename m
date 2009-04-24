Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbZDXDvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbZDXDvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 23:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZDXDvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 23:51:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:35454 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbZDXDvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 23:51:37 -0400
Message-ID: <49F136C5.3000403@kernel.org>
Date: Thu, 23 Apr 2009 20:49:25 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: [PATCH 2/4] pci: try to assign res for device under transparent bridges
 -v2
References: <20090420223305.GA15340@jurassic.park.msu.ru> <49ED0EBC.4070901@kernel.org> <20090421105629.GB17904@jurassic.park.msu.ru> <49EF9C10.6090107@kernel.org> <20090422154900.08f8f366@hobbes> <49EFBB0E.3030401@kernel.org> <20090422180505.2518e837@hobbes> <49EFCE15.3030605@kernel.org> <20090423132202.GB13984@jurassic.park.msu.ru> <49F08580.9050407@kernel.org> <20090423221936.GA24171@jurassic.park.msu.ru> <49F13690.3080902@kernel.org>
In-Reply-To: <49F13690.3080902@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we could run out of space under under 4g, but device under transparent bridge
still use 64bit resource, so try on parent bus again and again.

[ Impact: better support for assigne unassigned resources ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
 
---
 drivers/pci/setup-bus.c |    1 
 drivers/pci/setup-res.c |   49 +++++++++++++++++++++++++++++++++++-------------
 2 files changed, 36 insertions(+), 14 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -58,7 +58,6 @@ static void pbus_assign_resources_sorted
 		res = list->res;
 		idx = res - &list->dev->resource[0];
 		if (pci_assign_resource(list->dev, idx)) {
-			/* FIXME: get rid of this */
 			res->start = 0;
 			res->end = 0;
 			res->flags = 0;
Index: linux-2.6/drivers/pci/setup-res.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-res.c
+++ linux-2.6/drivers/pci/setup-res.c
@@ -135,23 +135,16 @@ void pci_disable_bridge_window(struct pc
 }
 #endif	/* CONFIG_PCI_QUIRKS */
 
-int pci_assign_resource(struct pci_dev *dev, int resno)
+static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
+				 int resno)
 {
-	struct pci_bus *bus = dev->bus;
 	struct resource *res = dev->resource + resno;
 	resource_size_t size, min, align;
 	int ret;
 
 	size = resource_size(res);
 	min = (res->flags & IORESOURCE_IO) ? PCIBIOS_MIN_IO : PCIBIOS_MIN_MEM;
-
 	align = resource_alignment(res);
-	if (!align) {
-		dev_info(&dev->dev, "BAR %d: can't allocate resource (bogus "
-			"alignment) %pR flags %#lx\n",
-			resno, res, res->flags);
-		return -EINVAL;
-	}
 
 	/* First, try exact prefetching match.. */
 	ret = pci_bus_alloc_resource(bus, res, size, align, min,
@@ -169,10 +162,7 @@ int pci_assign_resource(struct pci_dev *
 					     pcibios_align_resource, dev);
 	}
 
-	if (ret) {
-		dev_info(&dev->dev, "BAR %d: can't allocate %s resource %pR\n",
-			resno, res->flags & IORESOURCE_IO ? "I/O" : "mem", res);
-	} else {
+	if (!ret) {
 		res->flags &= ~IORESOURCE_STARTALIGN;
 		if (resno < PCI_BRIDGE_RESOURCES)
 			pci_update_resource(dev, resno);
@@ -180,6 +170,39 @@ int pci_assign_resource(struct pci_dev *
 
 	return ret;
 }
+
+int pci_assign_resource(struct pci_dev *dev, int resno)
+{
+	struct resource *res = dev->resource + resno;
+	resource_size_t align;
+	struct pci_bus *bus;
+	int ret;
+
+	align = resource_alignment(res);
+	if (!align) {
+		dev_info(&dev->dev, "BAR %d: can't allocate resource (bogus "
+			"alignment) %pR flags %#lx\n",
+			resno, res, res->flags);
+		return -EINVAL;
+	}
+
+	bus = dev->bus;
+	while ((ret = __pci_assign_resource(bus, dev, resno))) {
+		if (bus->parent && bus->self->transparent)
+			bus = bus->parent;
+		else
+			bus = NULL;
+		if (bus)
+			continue;
+		break;
+	}
+
+	if (ret)
+		dev_info(&dev->dev, "BAR %d: can't allocate %s resource %pR\n",
+			resno, res->flags & IORESOURCE_IO ? "I/O" : "mem", res);
+
+	return ret;
+}
 
 #if 0
 int pci_assign_resource_fixed(struct pci_dev *dev, int resno)
