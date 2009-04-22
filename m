Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZDVWkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZDVWkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 18:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZDVWkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 18:40:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:54379 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbZDVWkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 18:40:05 -0400
Message-ID: <49EF9C4A.7030806@kernel.org>
Date: Wed, 22 Apr 2009 15:38:02 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: [RFC PATCH 2/2] pci: try to assign res for device under transparent
 bridges
References: <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <49E99054.6050208@kernel.org> <alpine.LFD.2.00.0904181142530.4042@localhost.localdomain> <49EA57C4.1000603@kernel.org> <alpine.LFD.2.00.0904181602030.2199@localhost.localdomain> <alpine.LFD.2.00.0904182149240.2199@localhost.localdomain> <20090419090208.GA30211@elte.hu> <20090419090615.GA30631@elte.hu> <20090420223305.GA15340@jurassic.park.msu.ru> <49ED0EBC.4070901@kernel.org> <20090421105629.GB17904@jurassic.park.msu.ru> <49EF9C10.6090107@kernel.org>
In-Reply-To: <49EF9C10.6090107@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


try to get resource on parent bus if bridge is transparent...

[ Impact: second try to get resource for unassigned resource with transparent bridges ]

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
+		if (bus->self->transparent)
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
