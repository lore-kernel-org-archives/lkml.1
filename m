Return-Path: <linux-kernel-owner+w=401wt.eu-S1762027AbYDAP16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762027AbYDAP16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759482AbYDAPTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:19:00 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:27374 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759475AbYDAPSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:18:38 -0400
Message-Id: <20080401151739.626854225@ldl.fc.hp.com>
References: <20080401151634.730901933@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 09:16:54 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 20/37] PNP: make generic pnp_add_irq_resource()
Content-Disposition: inline; filename=pnp-common-add-irq-resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pnp_add_irq_resource() that can be used by all the PNP
backends.  This consolidates a little more pnp_resource_table
knowledge into one place.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h             |    2 ++
 drivers/pnp/interface.c        |   14 ++++----------
 drivers/pnp/isapnp/core.c      |    4 +---
 drivers/pnp/pnpacpi/rsparser.c |   28 +++++-----------------------
 drivers/pnp/pnpbios/rsparser.c |   23 ++---------------------
 drivers/pnp/resource.c         |   26 ++++++++++++++++++++++++++
 6 files changed, 40 insertions(+), 57 deletions(-)

Index: work7/drivers/pnp/base.h
===================================================================
--- work7.orig/drivers/pnp/base.h	2008-03-31 17:07:34.000000000 -0600
+++ work7/drivers/pnp/base.h	2008-03-31 17:10:52.000000000 -0600
@@ -15,3 +15,5 @@
 int pnp_check_mem(struct pnp_dev * dev, int idx);
 int pnp_check_irq(struct pnp_dev * dev, int idx);
 int pnp_check_dma(struct pnp_dev * dev, int idx);
+
+int pnp_add_irq_resource(struct pnp_dev *dev, int irq, int flags);
Index: work7/drivers/pnp/resource.c
===================================================================
--- work7.orig/drivers/pnp/resource.c	2008-03-31 16:59:07.000000000 -0600
+++ work7/drivers/pnp/resource.c	2008-03-31 17:10:52.000000000 -0600
@@ -461,6 +461,32 @@
 #endif
 }
 
+#define set(flags)	((flags & IORESOURCE_UNSET) == 0)
+
+int pnp_add_irq_resource(struct pnp_dev *dev, int irq, int flags)
+{
+	struct pnp_resource_table *res = &dev->res;
+	int i = 0;
+	static unsigned char warned;
+
+	while (set(res->irq_resource[i].flags) && i < PNP_MAX_IRQ)
+		i++;
+	if (i >= PNP_MAX_IRQ && !warned) {
+		dev_err(&dev->dev, "too many IRQs (max %d)\n", PNP_MAX_IRQ);
+		warned = 1;
+		return -ENOSPC;
+	}
+
+	res->irq_resource[i].flags = IORESOURCE_IRQ | flags;
+	if (irq < 0) {
+		res->irq_resource[i].flags |= IORESOURCE_DISABLED;
+		return -EINVAL;
+	}
+	res->irq_resource[i].start = irq;
+	res->irq_resource[i].end = irq;
+	return 0;
+}
+
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 static int __init pnp_setup_reserve_irq(char *str)
 {
Index: work7/drivers/pnp/isapnp/core.c
===================================================================
--- work7.orig/drivers/pnp/isapnp/core.c	2008-03-31 17:10:48.000000000 -0600
+++ work7/drivers/pnp/isapnp/core.c	2008-03-31 17:10:52.000000000 -0600
@@ -952,9 +952,7 @@
 			     8);
 			if (!ret)
 				continue;
-			res->irq_resource[tmp].start =
-			    res->irq_resource[tmp].end = ret;
-			res->irq_resource[tmp].flags = IORESOURCE_IRQ;
+			pnp_add_irq_resource(dev, ret, 0);
 		}
 		for (tmp = 0; tmp < ISAPNP_MAX_DMA; tmp++) {
 			ret = isapnp_read_byte(ISAPNP_CFG_DMA + tmp);
Index: work7/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/rsparser.c	2008-03-31 17:10:48.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/rsparser.c	2008-03-31 17:10:52.000000000 -0600
@@ -22,6 +22,7 @@
 #include <linux/acpi.h>
 #include <linux/pci.h>
 #include "pnpacpi.h"
+#include "../base.h"
 
 #ifdef CONFIG_IA64
 #define valid_IRQ(i) (1)
@@ -80,24 +81,12 @@
 						u32 gsi, int triggering,
 						int polarity, int shareable)
 {
-	struct pnp_resource_table *res = &dev->res;
-	int i = 0;
-	int irq;
+	int irq, flags;
 	int p, t;
-	static unsigned char warned;
 
 	if (!valid_IRQ(gsi))
 		return;
 
-	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET) &&
-	       i < PNP_MAX_IRQ)
-		i++;
-	if (i >= PNP_MAX_IRQ && !warned) {
-		printk(KERN_ERR "pnpacpi: exceeded the max number of IRQ "
-				"resources: %d \n", PNP_MAX_IRQ);
-		warned = 1;
-		return;
-	}
 	/*
 	 * in IO-APIC mode, use overrided attribute. Two reasons:
 	 * 1. BIOS bug in DSDT
@@ -114,18 +103,11 @@
 			polarity = p;
 		}
 	}
+	flags = irq_flags(triggering, polarity, shareable);
 
-	res->irq_resource[i].flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
-	res->irq_resource[i].flags |= irq_flags(triggering, polarity, shareable);
 	irq = acpi_register_gsi(gsi, triggering, polarity);
-	if (irq < 0) {
-		res->irq_resource[i].flags |= IORESOURCE_DISABLED;
-		return;
-	}
-
-	res->irq_resource[i].start = irq;
-	res->irq_resource[i].end = irq;
-	pcibios_penalize_isa_irq(irq, 1);
+	if (pnp_add_irq_resource(dev, irq, flags) == 0)
+		pcibios_penalize_isa_irq(irq, 1);
 }
 
 static int dma_flags(int type, int bus_master, int transfer)
Index: work7/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpbios/rsparser.c	2008-03-31 17:10:48.000000000 -0600
+++ work7/drivers/pnp/pnpbios/rsparser.c	2008-03-31 17:10:52.000000000 -0600
@@ -54,26 +54,6 @@
  * Allocated Resources
  */
 
-static void pnpbios_parse_allocated_irqresource(struct pnp_dev *dev, int irq)
-{
-	struct pnp_resource_table *res = &dev->res;
-	int i = 0;
-
-	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET)
-	       && i < PNP_MAX_IRQ)
-		i++;
-	if (i < PNP_MAX_IRQ) {
-		res->irq_resource[i].flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
-		if (irq == -1) {
-			res->irq_resource[i].flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		res->irq_resource[i].start =
-		    res->irq_resource[i].end = (unsigned long)irq;
-		pcibios_penalize_isa_irq(irq, 1);
-	}
-}
-
 static void pnpbios_parse_allocated_dmaresource(struct pnp_dev *dev, int dma)
 {
 	struct pnp_resource_table *res = &dev->res;
@@ -198,7 +178,8 @@
 			for (i = 0; i < 16; i++, mask = mask >> 1)
 				if (mask & 0x01)
 					io = i;
-			pnpbios_parse_allocated_irqresource(dev, io);
+			if (pnp_add_irq_resource(dev, io, 0) == 0)
+				pcibios_penalize_isa_irq(io, 1);
 			break;
 
 		case SMALL_TAG_DMA:
Index: work7/drivers/pnp/interface.c
===================================================================
--- work7.orig/drivers/pnp/interface.c	2008-03-31 17:10:48.000000000 -0600
+++ work7/drivers/pnp/interface.c	2008-03-31 17:10:52.000000000 -0600
@@ -325,6 +325,7 @@
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
 	char *buf = (void *)ubuf;
 	int retval = 0;
+	resource_size_t start;
 
 	if (dev->status & PNP_ATTACHED) {
 		retval = -EBUSY;
@@ -369,7 +370,7 @@
 		goto done;
 	}
 	if (!strnicmp(buf, "set", 3)) {
-		int nport = 0, nmem = 0, nirq = 0, ndma = 0;
+		int nport = 0, nmem = 0, ndma = 0;
 		if (dev->active)
 			goto done;
 		buf += 3;
@@ -430,14 +431,8 @@
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				dev->res.irq_resource[nirq].start =
-				    dev->res.irq_resource[nirq].end =
-				    simple_strtoul(buf, &buf, 0);
-				dev->res.irq_resource[nirq].flags =
-				    IORESOURCE_IRQ;
-				nirq++;
-				if (nirq >= PNP_MAX_IRQ)
-					break;
+				start = simple_strtoul(buf, &buf, 0);
+				pnp_add_irq_resource(dev, start, 0);
 				continue;
 			}
 			if (!strnicmp(buf, "dma", 3)) {

-- 
