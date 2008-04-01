Return-Path: <linux-kernel-owner+w=401wt.eu-S1761128AbYDAPXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761128AbYDAPXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759442AbYDAPS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:18:26 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:34943 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759355AbYDAPSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:18:08 -0400
Message-Id: <20080401151740.219745325@ldl.fc.hp.com>
References: <20080401151634.730901933@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 09:16:57 -0600
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
Subject: [patch 23/37] PNP: make generic pnp_add_mem_resource()
Content-Disposition: inline; filename=pnp-common-add-mem-resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pnp_add_mem_resource() that can be used by all the PNP
backends.  This consolidates a little more pnp_resource_table
knowledge into one place.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h             |    1 
 drivers/pnp/interface.c        |   17 ++++---------
 drivers/pnp/isapnp/core.c      |    4 ---
 drivers/pnp/pnpacpi/rsparser.c |   50 +++++++++--------------------------------
 drivers/pnp/pnpbios/rsparser.c |   26 ++-------------------
 drivers/pnp/resource.c         |   24 +++++++++++++++++++
 6 files changed, 46 insertions(+), 76 deletions(-)

Index: work7/drivers/pnp/base.h
===================================================================
--- work7.orig/drivers/pnp/base.h	2008-03-31 17:10:57.000000000 -0600
+++ work7/drivers/pnp/base.h	2008-03-31 17:10:59.000000000 -0600
@@ -19,3 +19,4 @@
 int pnp_add_irq_resource(struct pnp_dev *dev, int irq, int flags);
 int pnp_add_dma_resource(struct pnp_dev *dev, int dma, int flags);
 int pnp_add_io_resource(struct pnp_dev *dev, resource_size_t start, resource_size_t len, int flags);
+int pnp_add_mem_resource(struct pnp_dev *dev, resource_size_t start, resource_size_t len, int flags);
Index: work7/drivers/pnp/resource.c
===================================================================
--- work7.orig/drivers/pnp/resource.c	2008-03-31 17:10:57.000000000 -0600
+++ work7/drivers/pnp/resource.c	2008-03-31 17:10:59.000000000 -0600
@@ -536,6 +536,30 @@
 	return 0;
 }
 
+int pnp_add_mem_resource(struct pnp_dev *dev, resource_size_t start, resource_size_t len, int flags)
+{
+	struct pnp_resource_table *res = &dev->res;
+	int i = 0;
+	static unsigned char warned;
+
+	while (set(res->mem_resource[i].flags) && i < PNP_MAX_MEM)
+		i++;
+	if (i >= PNP_MAX_MEM && !warned) {
+		dev_err(&dev->dev, "too many MEMs (max %d)\n", PNP_MAX_MEM);
+		warned = 1;
+		return -ENOSPC;
+	}
+
+	res->mem_resource[i].flags = IORESOURCE_MEM | flags;
+	if (len <= 0) {
+		res->mem_resource[i].flags |= IORESOURCE_DISABLED;
+		return -EINVAL;
+	}
+	res->mem_resource[i].start = start;
+	res->mem_resource[i].end = start + len - 1;
+	return 0;
+}
+
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 static int __init pnp_setup_reserve_irq(char *str)
 {
Index: work7/drivers/pnp/isapnp/core.c
===================================================================
--- work7.orig/drivers/pnp/isapnp/core.c	2008-03-31 17:10:57.000000000 -0600
+++ work7/drivers/pnp/isapnp/core.c	2008-03-31 17:10:59.000000000 -0600
@@ -926,7 +926,6 @@
 
 static int isapnp_read_resources(struct pnp_dev *dev)
 {
-	struct pnp_resource_table *res = &dev->res;
 	int tmp, ret;
 
 	dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
@@ -942,8 +941,7 @@
 			    isapnp_read_word(ISAPNP_CFG_MEM + (tmp << 3)) << 8;
 			if (!ret)
 				continue;
-			res->mem_resource[tmp].start = ret;
-			res->mem_resource[tmp].flags = IORESOURCE_MEM;
+			pnp_add_mem_resource(dev, ret, 1, 0);
 		}
 		for (tmp = 0; tmp < ISAPNP_MAX_IRQ; tmp++) {
 			ret =
Index: work7/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/rsparser.c	2008-03-31 17:10:57.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/rsparser.c	2008-03-31 17:10:59.000000000 -0600
@@ -153,35 +153,6 @@
 	return flags;
 }
 
-static void pnpacpi_parse_allocated_memresource(struct pnp_dev *dev,
-						u64 mem, u64 len,
-						int write_protect)
-{
-	struct pnp_resource_table *res = &dev->res;
-	int i = 0;
-	static unsigned char warned;
-
-	while (!(res->mem_resource[i].flags & IORESOURCE_UNSET) &&
-	       (i < PNP_MAX_MEM))
-		i++;
-	if (i < PNP_MAX_MEM) {
-		res->mem_resource[i].flags = IORESOURCE_MEM;	// Also clears _UNSET flag
-		if (len <= 0) {
-			res->mem_resource[i].flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		if (write_protect == ACPI_READ_WRITE_MEMORY)
-			res->mem_resource[i].flags |= IORESOURCE_MEM_WRITEABLE;
-
-		res->mem_resource[i].start = mem;
-		res->mem_resource[i].end = mem + len - 1;
-	} else if (!warned) {
-		printk(KERN_ERR "pnpacpi: exceeded the max number of mem "
-				"resources: %d\n", PNP_MAX_MEM);
-		warned = 1;
-	}
-}
-
 static void pnpacpi_parse_allocated_address_space(struct pnp_dev *dev,
 						  struct acpi_resource *res)
 {
@@ -199,9 +170,9 @@
 		return;
 
 	if (p->resource_type == ACPI_MEMORY_RANGE)
-		pnpacpi_parse_allocated_memresource(dev,
-			p->minimum, p->address_length,
-			p->info.mem.write_protect);
+		pnp_add_mem_resource(dev, p->minimum, p->address_length,
+			p->info.mem.write_protect == ACPI_READ_WRITE_MEMORY ?
+			    IORESOURCE_MEM_WRITEABLE : 0);
 	else if (p->resource_type == ACPI_IO_RANGE)
 		pnp_add_io_resource(dev, p->minimum, p->address_length,
 			p->granularity == 0xfff ? 0 : PNP_PORT_FLAG_16BITADDR);
@@ -272,24 +243,27 @@
 
 	case ACPI_RESOURCE_TYPE_MEMORY24:
 		memory24 = &res->data.memory24;
-		pnpacpi_parse_allocated_memresource(dev,
+		pnp_add_mem_resource(dev,
 			memory24->minimum,
 			memory24->address_length,
-			memory24->write_protect);
+			memory24->write_protect == ACPI_READ_WRITE_MEMORY ?
+			    IORESOURCE_MEM_WRITEABLE : 0);
 		break;
 	case ACPI_RESOURCE_TYPE_MEMORY32:
 		memory32 = &res->data.memory32;
-		pnpacpi_parse_allocated_memresource(dev,
+		pnp_add_mem_resource(dev,
 			memory32->minimum,
 			memory32->address_length,
-			memory32->write_protect);
+			memory32->write_protect == ACPI_READ_WRITE_MEMORY ?
+			    IORESOURCE_MEM_WRITEABLE : 0);
 		break;
 	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
 		fixed_memory32 = &res->data.fixed_memory32;
-		pnpacpi_parse_allocated_memresource(dev,
+		pnp_add_mem_resource(dev,
 			fixed_memory32->address,
 			fixed_memory32->address_length,
-			fixed_memory32->write_protect);
+			fixed_memory32->write_protect == ACPI_READ_WRITE_MEMORY ?
+			    IORESOURCE_MEM_WRITEABLE : 0);
 		break;
 	case ACPI_RESOURCE_TYPE_ADDRESS16:
 	case ACPI_RESOURCE_TYPE_ADDRESS32:
Index: work7/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpbios/rsparser.c	2008-03-31 17:10:57.000000000 -0600
+++ work7/drivers/pnp/pnpbios/rsparser.c	2008-03-31 17:10:59.000000000 -0600
@@ -54,26 +54,6 @@
  * Allocated Resources
  */
 
-static void pnpbios_parse_allocated_memresource(struct pnp_dev *dev,
-						int mem, int len)
-{
-	struct pnp_resource_table *res = &dev->res;
-	int i = 0;
-
-	while (!(res->mem_resource[i].flags & IORESOURCE_UNSET)
-	       && i < PNP_MAX_MEM)
-		i++;
-	if (i < PNP_MAX_MEM) {
-		res->mem_resource[i].flags = IORESOURCE_MEM;	// Also clears _UNSET flag
-		if (len <= 0) {
-			res->mem_resource[i].flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		res->mem_resource[i].start = (unsigned long)mem;
-		res->mem_resource[i].end = (unsigned long)(mem + len - 1);
-	}
-}
-
 static unsigned char *pnpbios_parse_allocated_resource_data(struct pnp_dev *dev,
 							    unsigned char *p,
 							    unsigned char *end)
@@ -104,7 +84,7 @@
 				goto len_err;
 			io = *(short *)&p[4];
 			size = *(short *)&p[10];
-			pnpbios_parse_allocated_memresource(dev, io, size);
+			pnp_add_mem_resource(dev, io, size, 0);
 			break;
 
 		case LARGE_TAG_ANSISTR:
@@ -120,7 +100,7 @@
 				goto len_err;
 			io = *(int *)&p[4];
 			size = *(int *)&p[16];
-			pnpbios_parse_allocated_memresource(dev, io, size);
+			pnp_add_mem_resource(dev, io, size, 0);
 			break;
 
 		case LARGE_TAG_FIXEDMEM32:
@@ -128,7 +108,7 @@
 				goto len_err;
 			io = *(int *)&p[4];
 			size = *(int *)&p[8];
-			pnpbios_parse_allocated_memresource(dev, io, size);
+			pnp_add_mem_resource(dev, io, size, 0);
 			break;
 
 		case SMALL_TAG_IRQ:
Index: work7/drivers/pnp/interface.c
===================================================================
--- work7.orig/drivers/pnp/interface.c	2008-03-31 17:10:57.000000000 -0600
+++ work7/drivers/pnp/interface.c	2008-03-31 17:10:59.000000000 -0600
@@ -370,7 +370,6 @@
 		goto done;
 	}
 	if (!strnicmp(buf, "set", 3)) {
-		int nmem = 0;
 		if (dev->active)
 			goto done;
 		buf += 3;
@@ -401,24 +400,18 @@
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				dev->res.mem_resource[nmem].start =
-				    simple_strtoul(buf, &buf, 0);
+				start = simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
 				if (*buf == '-') {
 					buf += 1;
 					while (isspace(*buf))
 						++buf;
-					dev->res.mem_resource[nmem].end =
-					    simple_strtoul(buf, &buf, 0);
+					end = simple_strtoul(buf, &buf, 0);
 				} else
-					dev->res.mem_resource[nmem].end =
-					    dev->res.mem_resource[nmem].start;
-				dev->res.mem_resource[nmem].flags =
-				    IORESOURCE_MEM;
-				nmem++;
-				if (nmem >= PNP_MAX_MEM)
-					break;
+					end = start;
+				length = end - start + 1;
+				pnp_add_mem_resource(dev, start, length, 0);
 				continue;
 			}
 			if (!strnicmp(buf, "irq", 3)) {

-- 
