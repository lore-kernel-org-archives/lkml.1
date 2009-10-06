Return-Path: <linux-kernel-owner+w=401wt.eu-S933482AbZJFVe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482AbZJFVe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933472AbZJFVeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:34:25 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:31409 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933445AbZJFVeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:34:21 -0400
Subject: [PATCH 4/7] PCI: print resources consistently with %pRt
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Date: Tue, 06 Oct 2009 15:33:44 -0600
Message-ID: <20091006213344.4272.61588.stgit@bob.kio>
In-Reply-To: <20091006213259.4272.68068.stgit@bob.kio>
References: <20091006213259.4272.68068.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses %pRt to print additional resource information (type, size,
prefetchability, etc.) consistently.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 drivers/pci/pci.c       |    4 +---
 drivers/pci/probe.c     |   26 ++++++++------------------
 drivers/pci/setup-bus.c |    9 +++------
 drivers/pci/setup-res.c |   28 ++++++++++++----------------
 4 files changed, 24 insertions(+), 43 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6edecff..d760776 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1665,9 +1665,7 @@ static int __pci_request_region(struct pci_dev *pdev, int bar, const char *res_n
 	return 0;
 
 err_out:
-	dev_warn(&pdev->dev, "BAR %d: can't reserve %s region %pR\n",
-		 bar,
-		 pci_resource_flags(pdev, bar) & IORESOURCE_IO ? "I/O" : "mem",
+	dev_warn(&pdev->dev, "BAR %d: can't reserve %pRt\n", bar,
 		 &pdev->resource[bar]);
 	return -EBUSY;
 }
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index ca08416..94b2b9c 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -222,6 +222,8 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		if (!sz64)
 			goto fail;
 
+		res->flags |= IORESOURCE_MEM_64;
+
 		if ((sizeof(resource_size_t) < 8) && (sz64 > 0x100000000ULL)) {
 			dev_err(&dev->dev, "can't handle 64-bit BAR\n");
 			goto fail;
@@ -234,14 +236,9 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		} else {
 			res->start = l64;
 			res->end = l64 + sz64;
-			dev_printk(KERN_DEBUG, &dev->dev,
-				"reg %x %s: %pR\n", pos,
-				 (res->flags & IORESOURCE_PREFETCH) ?
-					"64bit mmio pref" : "64bit mmio",
-				 res);
+			dev_printk(KERN_DEBUG, &dev->dev, "reg %x: %pRt\n",
+				   pos, res);
 		}
-
-		res->flags |= IORESOURCE_MEM_64;
 	} else {
 		sz = pci_size(l, sz, mask);
 
@@ -251,11 +248,7 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		res->start = l;
 		res->end = l + sz;
 
-		dev_printk(KERN_DEBUG, &dev->dev, "reg %x %s: %pR\n", pos,
-			(res->flags & IORESOURCE_IO) ? "io port" :
-			 ((res->flags & IORESOURCE_PREFETCH) ?
-				 "32bit mmio pref" : "32bit mmio"),
-			res);
+		dev_printk(KERN_DEBUG, &dev->dev, "reg %x: %pRt\n", pos, res);
 	}
 
  out:
@@ -323,7 +316,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		dev_printk(KERN_DEBUG, &dev->dev, "bridge io port: %pR\n", res);
+		dev_printk(KERN_DEBUG, &dev->dev, "bridge window: %pRt\n", res);
 	}
 
 	res = child->resource[1];
@@ -335,8 +328,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		dev_printk(KERN_DEBUG, &dev->dev, "bridge 32bit mmio: %pR\n",
-			res);
+		dev_printk(KERN_DEBUG, &dev->dev, "bridge window: %pRt\n", res);
 	}
 
 	res = child->resource[2];
@@ -375,9 +367,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 			res->flags |= IORESOURCE_MEM_64;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		dev_printk(KERN_DEBUG, &dev->dev, "bridge %sbit mmio pref: %pR\n",
-			(res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
-			res);
+		dev_printk(KERN_DEBUG, &dev->dev, "bridge window: %pRt\n", res);
 	}
 }
 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index cb1a027..ceb7533 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -390,8 +390,8 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			align = pci_resource_alignment(dev, r);
 			order = __ffs(align) - 20;
 			if (order > 11) {
-				dev_warn(&dev->dev, "BAR %d bad alignment %llx: "
-					 "%pR\n", i, (unsigned long long)align, r);
+				dev_warn(&dev->dev, "BAR %d: bad alignment %llx: "
+					 "%pRt\n", i, (unsigned long long)align, r);
 				r->flags = 0;
 				continue;
 			}
@@ -582,10 +582,7 @@ static void pci_bus_dump_res(struct pci_bus *bus)
                 if (!res || !res->end)
                         continue;
 
-		dev_printk(KERN_DEBUG, &bus->dev, "resource %d %s %pR\n", i,
-			   (res->flags & IORESOURCE_IO) ? "io: " :
-			    ((res->flags & IORESOURCE_PREFETCH)? "pref mem":"mem:"),
-			   res);
+		dev_printk(KERN_DEBUG, &bus->dev, "resource %d %pRt\n", i, res);
         }
 }
 
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index c54526b..5e78f20 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -51,11 +51,9 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 
 	pcibios_resource_to_bus(dev, &region, res);
 
-	dev_dbg(&dev->dev, "BAR %d: got res %pR bus [%#llx-%#llx] "
-		"flags %#lx\n", resno, res,
-		 (unsigned long long)region.start,
-		 (unsigned long long)region.end,
-		 (unsigned long)res->flags);
+	dev_dbg(&dev->dev, "BAR %d: got %pRf (bus addr [%#llx-%#llx])\n",
+		resno, res, (unsigned long long)region.start,
+		(unsigned long long)region.end);
 
 	new = region.start | (res->flags & PCI_REGION_FLAG_MASK);
 	if (res->flags & IORESOURCE_IO)
@@ -91,9 +89,9 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 		}
 	}
 	res->flags &= ~IORESOURCE_UNSET;
-	dev_dbg(&dev->dev, "BAR %d: moved to bus [%#llx-%#llx] flags %#lx\n",
+	dev_dbg(&dev->dev, "BAR %d: moved to bus addr [%#llx-%#llx]\n",
 		resno, (unsigned long long)region.start,
-		(unsigned long long)region.end, res->flags);
+		(unsigned long long)region.end);
 }
 
 int pci_claim_resource(struct pci_dev *dev, int resource)
@@ -110,7 +108,7 @@ int pci_claim_resource(struct pci_dev *dev, int resource)
 
 	if (err) {
 		const char *dtype = resource < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
-		dev_err(&dev->dev, "BAR %d: %s of %s %pR\n",
+		dev_err(&dev->dev, "BAR %d: %s %s %pRt\n",
 			resource,
 			root ? "address space collision on" :
 				"no parent found for",
@@ -181,9 +179,8 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 
 	align = pci_resource_alignment(dev, res);
 	if (!align) {
-		dev_info(&dev->dev, "BAR %d: can't allocate resource (bogus "
-			"alignment) %pR flags %#lx\n",
-			resno, res, res->flags);
+		dev_info(&dev->dev, "BAR %d: can't allocate %pRf "
+			 "(bogus alignment)\n", resno, res);
 		return -EINVAL;
 	}
 
@@ -199,8 +196,8 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	}
 
 	if (ret)
-		dev_info(&dev->dev, "BAR %d: can't allocate %s resource %pR\n",
-			resno, res->flags & IORESOURCE_IO ? "I/O" : "mem", res);
+		dev_info(&dev->dev, "BAR %d: can't allocate %pRt\n",
+			 resno, res);
 
 	return ret;
 }
@@ -225,9 +222,8 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
 
 		r_align = pci_resource_alignment(dev, r);
 		if (!r_align) {
-			dev_warn(&dev->dev, "BAR %d: bogus alignment "
-				"%pR flags %#lx\n",
-				i, r, r->flags);
+			dev_warn(&dev->dev, "BAR %d: bogus alignment %pRf\n",
+				 i, r);
 			continue;
 		}
 		for (list = head; ; list = list->next) {

