Return-Path: <linux-kernel-owner+w=401wt.eu-S933526AbZJFVek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526AbZJFVek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933501AbZJFVej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:34:39 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:43543 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933264AbZJFVeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:34:36 -0400
Subject: [PATCH 7/7] PNP: print resources consistently with %pRt
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Date: Tue, 06 Oct 2009 15:34:00 -0600
Message-ID: <20091006213359.4272.75248.stgit@bob.kio>
In-Reply-To: <20091006213259.4272.68068.stgit@bob.kio>
References: <20091006213259.4272.68068.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses %pRt and %pRf to print additional resource information (type,
size, prefetchability, etc.) consistently.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 drivers/pnp/quirks.c   |   12 +++---------
 drivers/pnp/resource.c |   10 ++++------
 drivers/pnp/support.c  |   43 +++++--------------------------------------
 drivers/pnp/system.c   |   14 ++++++--------
 4 files changed, 18 insertions(+), 61 deletions(-)

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 8473fe5..3a2031b 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -285,15 +285,9 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 				 * the PCI region, and that might prevent a PCI
 				 * driver from requesting its resources.
 				 */
-				dev_warn(&dev->dev, "%s resource "
-					"(0x%llx-0x%llx) overlaps %s BAR %d "
-					"(0x%llx-0x%llx), disabling\n",
-					pnp_resource_type_name(res),
-					(unsigned long long) pnp_start,
-					(unsigned long long) pnp_end,
-					pci_name(pdev), i,
-					(unsigned long long) pci_start,
-					(unsigned long long) pci_end);
+				dev_warn(&dev->dev, "resource %pRt overlaps %s "
+					 "BAR %d %pRt, disabling\n", res,
+					 pci_name(pdev), i, &pdev->resource[i]);
 				res->flags |= IORESOURCE_DISABLED;
 			}
 		}
diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index ba97654..18557d7 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -517,7 +517,7 @@ struct pnp_resource *pnp_add_irq_resource(struct pnp_dev *dev, int irq,
 	res->start = irq;
 	res->end = irq;
 
-	pnp_dbg(&dev->dev, "  add irq %d flags %#x\n", irq, flags);
+	pnp_dbg(&dev->dev, "  add %pRf\n", res);
 	return pnp_res;
 }
 
@@ -538,7 +538,7 @@ struct pnp_resource *pnp_add_dma_resource(struct pnp_dev *dev, int dma,
 	res->start = dma;
 	res->end = dma;
 
-	pnp_dbg(&dev->dev, "  add dma %d flags %#x\n", dma, flags);
+	pnp_dbg(&dev->dev, "  add %pRf\n", res);
 	return pnp_res;
 }
 
@@ -562,8 +562,7 @@ struct pnp_resource *pnp_add_io_resource(struct pnp_dev *dev,
 	res->start = start;
 	res->end = end;
 
-	pnp_dbg(&dev->dev, "  add io  %#llx-%#llx flags %#x\n",
-		(unsigned long long) start, (unsigned long long) end, flags);
+	pnp_dbg(&dev->dev, "  add %pRf\n", res);
 	return pnp_res;
 }
 
@@ -587,8 +586,7 @@ struct pnp_resource *pnp_add_mem_resource(struct pnp_dev *dev,
 	res->start = start;
 	res->end = end;
 
-	pnp_dbg(&dev->dev, "  add mem %#llx-%#llx flags %#x\n",
-		(unsigned long long) start, (unsigned long long) end, flags);
+	pnp_dbg(&dev->dev, "  add %pRf\n", res);
 	return pnp_res;
 }
 
diff --git a/drivers/pnp/support.c b/drivers/pnp/support.c
index 63087d5..1f8a33b 100644
--- a/drivers/pnp/support.c
+++ b/drivers/pnp/support.c
@@ -75,47 +75,14 @@ char *pnp_resource_type_name(struct resource *res)
 
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
 {
-	char buf[128];
-	int len;
 	struct pnp_resource *pnp_res;
-	struct resource *res;
 
-	if (list_empty(&dev->resources)) {
+	if (list_empty(&dev->resources))
 		pnp_dbg(&dev->dev, "%s: no current resources\n", desc);
-		return;
-	}
-
-	pnp_dbg(&dev->dev, "%s: current resources:\n", desc);
-	list_for_each_entry(pnp_res, &dev->resources, list) {
-		res = &pnp_res->res;
-		len = 0;
-
-		len += scnprintf(buf + len, sizeof(buf) - len, "  %-3s ",
-				 pnp_resource_type_name(res));
-
-		if (res->flags & IORESOURCE_DISABLED) {
-			pnp_dbg(&dev->dev, "%sdisabled\n", buf);
-			continue;
-		}
-
-		switch (pnp_resource_type(res)) {
-		case IORESOURCE_IO:
-		case IORESOURCE_MEM:
-			len += scnprintf(buf + len, sizeof(buf) - len,
-					 "%#llx-%#llx flags %#lx",
-					 (unsigned long long) res->start,
-					 (unsigned long long) res->end,
-					 res->flags);
-			break;
-		case IORESOURCE_IRQ:
-		case IORESOURCE_DMA:
-			len += scnprintf(buf + len, sizeof(buf) - len,
-					 "%lld flags %#lx",
-					 (unsigned long long) res->start,
-					 res->flags);
-			break;
-		}
-		pnp_dbg(&dev->dev, "%s\n", buf);
+	else {
+		pnp_dbg(&dev->dev, "%s: current resources:\n", desc);
+		list_for_each_entry(pnp_res, &dev->resources, list)
+			pnp_dbg(&dev->dev, "%pRf\n", &pnp_res->res);
 	}
 }
 
diff --git a/drivers/pnp/system.c b/drivers/pnp/system.c
index 59b9092..242d3a8 100644
--- a/drivers/pnp/system.c
+++ b/drivers/pnp/system.c
@@ -22,11 +22,11 @@ static const struct pnp_device_id pnp_dev_table[] = {
 	{"", 0}
 };
 
-static void reserve_range(struct pnp_dev *dev, resource_size_t start,
-			  resource_size_t end, int port)
+static void reserve_range(struct pnp_dev *dev, struct resource *r, int port)
 {
 	char *regionid;
 	const char *pnpid = dev_name(&dev->dev);
+	resource_size_t start = r->start, end = r->end;
 	struct resource *res;
 
 	regionid = kmalloc(16, GFP_KERNEL);
@@ -48,10 +48,8 @@ static void reserve_range(struct pnp_dev *dev, resource_size_t start,
 	 * example do reserve stuff they know about too, so we may well
 	 * have double reservations.
 	 */
-	dev_info(&dev->dev, "%s range 0x%llx-0x%llx %s reserved\n",
-		port ? "ioport" : "iomem",
-		(unsigned long long) start, (unsigned long long) end,
-		res ? "has been" : "could not be");
+	dev_info(&dev->dev, "%pRt %s reserved\n", r,
+		 res ? "has been" : "could not be");
 }
 
 static void reserve_resources_of_dev(struct pnp_dev *dev)
@@ -77,14 +75,14 @@ static void reserve_resources_of_dev(struct pnp_dev *dev)
 		if (res->end < res->start)
 			continue;	/* invalid */
 
-		reserve_range(dev, res->start, res->end, 1);
+		reserve_range(dev, res, 1);
 	}
 
 	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
 		if (res->flags & IORESOURCE_DISABLED)
 			continue;
 
-		reserve_range(dev, res->start, res->end, 0);
+		reserve_range(dev, res, 0);
 	}
 }
 

