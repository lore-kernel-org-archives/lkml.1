Return-Path: <linux-kernel-owner+w=401wt.eu-S1761335AbYDAPY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335AbYDAPY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759463AbYDAPSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:18:31 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:11905 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbYDAPSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:18:18 -0400
Message-Id: <20080401151740.019324412@ldl.fc.hp.com>
References: <20080401151634.730901933@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 09:16:56 -0600
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
Subject: [patch 22/37] PNP: make generic pnp_add_io_resource()
Content-Disposition: inline; filename=pnp-common-add-io-resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pnp_add_io_resource() that can be used by all the PNP
backends.  This consolidates a little more pnp_resource_table
knowledge into one place.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h             |    1 
 drivers/pnp/interface.c        |   20 ++++++------------
 drivers/pnp/isapnp/core.c      |    3 --
 drivers/pnp/pnpacpi/rsparser.c |   45 ++++++-----------------------------------
 drivers/pnp/pnpbios/rsparser.c |   24 +--------------------
 drivers/pnp/resource.c         |   24 +++++++++++++++++++++
 6 files changed, 42 insertions(+), 75 deletions(-)

Index: work7/drivers/pnp/base.h
===================================================================
--- work7.orig/drivers/pnp/base.h	2008-03-31 17:10:54.000000000 -0600
+++ work7/drivers/pnp/base.h	2008-03-31 17:10:57.000000000 -0600
@@ -18,3 +18,4 @@
 
 int pnp_add_irq_resource(struct pnp_dev *dev, int irq, int flags);
 int pnp_add_dma_resource(struct pnp_dev *dev, int dma, int flags);
+int pnp_add_io_resource(struct pnp_dev *dev, resource_size_t start, resource_size_t len, int flags);
Index: work7/drivers/pnp/resource.c
===================================================================
--- work7.orig/drivers/pnp/resource.c	2008-03-31 17:10:54.000000000 -0600
+++ work7/drivers/pnp/resource.c	2008-03-31 17:10:57.000000000 -0600
@@ -511,6 +511,31 @@
 	return 0;
 }
 
+int pnp_add_io_resource(struct pnp_dev *dev, resource_size_t start, resource_size_t len, int flags)
+{
+	struct pnp_resource_table *res = &dev->res;
+	resource_size_t end = start + len - 1;
+	int i = 0;
+	static unsigned char warned;
+
+	while (set(res->port_resource[i].flags) && i < PNP_MAX_PORT)
+		i++;
+	if (i >= PNP_MAX_PORT && !warned) {
+		dev_err(&dev->dev, "too many PORTs (max %d)\n", PNP_MAX_PORT);
+		warned = 1;
+		return -ENOSPC;
+	}
+
+	res->port_resource[i].flags = IORESOURCE_IO | flags;
+	if (len <= 0 || end >= 0x10003) {
+		res->port_resource[i].flags |= IORESOURCE_DISABLED;
+		return -EINVAL;
+	}
+	res->port_resource[i].start = start;
+	res->port_resource[i].end = end;
+	return 0;
+}
+
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 static int __init pnp_setup_reserve_irq(char *str)
 {
Index: work7/drivers/pnp/isapnp/core.c
===================================================================
--- work7.orig/drivers/pnp/isapnp/core.c	2008-03-31 17:10:54.000000000 -0600
+++ work7/drivers/pnp/isapnp/core.c	2008-03-31 17:10:57.000000000 -0600
@@ -935,8 +935,7 @@
 			ret = isapnp_read_word(ISAPNP_CFG_PORT + (tmp << 1));
 			if (!ret)
 				continue;
-			res->port_resource[tmp].start = ret;
-			res->port_resource[tmp].flags = IORESOURCE_IO;
+			pnp_add_io_resource(dev, ret, 1, 0);
 		}
 		for (tmp = 0; tmp < ISAPNP_MAX_MEM; tmp++) {
 			ret =
Index: work7/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpacpi/rsparser.c	2008-03-31 17:10:54.000000000 -0600
+++ work7/drivers/pnp/pnpacpi/rsparser.c	2008-03-31 17:10:57.000000000 -0600
@@ -153,33 +153,6 @@
 	return flags;
 }
 
-static void pnpacpi_parse_allocated_ioresource(struct pnp_dev *dev,
-					       u64 io, u64 len, int io_decode)
-{
-	struct pnp_resource_table *res = &dev->res;
-	int i = 0;
-	static unsigned char warned;
-
-	while (!(res->port_resource[i].flags & IORESOURCE_UNSET) &&
-	       i < PNP_MAX_PORT)
-		i++;
-	if (i < PNP_MAX_PORT) {
-		res->port_resource[i].flags = IORESOURCE_IO;	// Also clears _UNSET flag
-		if (io_decode == ACPI_DECODE_16)
-			res->port_resource[i].flags |= PNP_PORT_FLAG_16BITADDR;
-		if (len <= 0 || (io + len - 1) >= 0x10003) {
-			res->port_resource[i].flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		res->port_resource[i].start = io;
-		res->port_resource[i].end = io + len - 1;
-	} else if (!warned) {
-		printk(KERN_ERR "pnpacpi: exceeded the max number of IO "
-				"resources: %d \n", PNP_MAX_PORT);
-		warned = 1;
-	}
-}
-
 static void pnpacpi_parse_allocated_memresource(struct pnp_dev *dev,
 						u64 mem, u64 len,
 						int write_protect)
@@ -230,10 +203,8 @@
 			p->minimum, p->address_length,
 			p->info.mem.write_protect);
 	else if (p->resource_type == ACPI_IO_RANGE)
-		pnpacpi_parse_allocated_ioresource(dev,
-			p->minimum, p->address_length,
-			p->granularity == 0xfff ? ACPI_DECODE_10 :
-				ACPI_DECODE_16);
+		pnp_add_io_resource(dev, p->minimum, p->address_length,
+			p->granularity == 0xfff ? 0 : PNP_PORT_FLAG_16BITADDR);
 }
 
 static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
@@ -277,10 +248,9 @@
 
 	case ACPI_RESOURCE_TYPE_IO:
 		io = &res->data.io;
-		pnpacpi_parse_allocated_ioresource(dev,
-			io->minimum,
-			io->address_length,
-			io->io_decode);
+		pnp_add_io_resource(dev, io->minimum, io->address_length,
+			io->io_decode == ACPI_DECODE_16 ?
+			    PNP_PORT_FLAG_16BITADDR : 0);
 		break;
 
 	case ACPI_RESOURCE_TYPE_START_DEPENDENT:
@@ -289,10 +259,9 @@
 
 	case ACPI_RESOURCE_TYPE_FIXED_IO:
 		fixed_io = &res->data.fixed_io;
-		pnpacpi_parse_allocated_ioresource(dev,
+		pnp_add_io_resource(dev,
 			fixed_io->address,
-			fixed_io->address_length,
-			ACPI_DECODE_10);
+			fixed_io->address_length, 0);
 		break;
 
 	case ACPI_RESOURCE_TYPE_VENDOR:
Index: work7/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpbios/rsparser.c	2008-03-31 17:10:54.000000000 -0600
+++ work7/drivers/pnp/pnpbios/rsparser.c	2008-03-31 17:10:57.000000000 -0600
@@ -54,26 +54,6 @@
  * Allocated Resources
  */
 
-static void pnpbios_parse_allocated_ioresource(struct pnp_dev *dev,
-					       int io, int len)
-{
-	struct pnp_resource_table *res = &dev->res;
-	int i = 0;
-
-	while (!(res->port_resource[i].flags & IORESOURCE_UNSET)
-	       && i < PNP_MAX_PORT)
-		i++;
-	if (i < PNP_MAX_PORT) {
-		res->port_resource[i].flags = IORESOURCE_IO;	// Also clears _UNSET flag
-		if (len <= 0 || (io + len - 1) >= 0x10003) {
-			res->port_resource[i].flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		res->port_resource[i].start = (unsigned long)io;
-		res->port_resource[i].end = (unsigned long)(io + len - 1);
-	}
-}
-
 static void pnpbios_parse_allocated_memresource(struct pnp_dev *dev,
 						int mem, int len)
 {
@@ -179,7 +159,7 @@
 				goto len_err;
 			io = p[2] + p[3] * 256;
 			size = p[7];
-			pnpbios_parse_allocated_ioresource(dev, io, size);
+			pnp_add_io_resource(dev, io, size, 0);
 			break;
 
 		case SMALL_TAG_VENDOR:
@@ -191,7 +171,7 @@
 				goto len_err;
 			io = p[1] + p[2] * 256;
 			size = p[3];
-			pnpbios_parse_allocated_ioresource(dev, io, size);
+			pnp_add_io_resource(dev, io, size, 0);
 			break;
 
 		case SMALL_TAG_END:
Index: work7/drivers/pnp/interface.c
===================================================================
--- work7.orig/drivers/pnp/interface.c	2008-03-31 17:10:54.000000000 -0600
+++ work7/drivers/pnp/interface.c	2008-03-31 17:10:57.000000000 -0600
@@ -325,7 +325,7 @@
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
 	char *buf = (void *)ubuf;
 	int retval = 0;
-	resource_size_t start;
+	resource_size_t start, end, length;
 
 	if (dev->status & PNP_ATTACHED) {
 		retval = -EBUSY;
@@ -370,7 +370,7 @@
 		goto done;
 	}
 	if (!strnicmp(buf, "set", 3)) {
-		int nport = 0, nmem = 0;
+		int nmem = 0;
 		if (dev->active)
 			goto done;
 		buf += 3;
@@ -383,24 +383,18 @@
 				buf += 2;
 				while (isspace(*buf))
 					++buf;
-				dev->res.port_resource[nport].start =
-				    simple_strtoul(buf, &buf, 0);
+				start = simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
 				if (*buf == '-') {
 					buf += 1;
 					while (isspace(*buf))
 						++buf;
-					dev->res.port_resource[nport].end =
-					    simple_strtoul(buf, &buf, 0);
+					end = simple_strtoul(buf, &buf, 0);
 				} else
-					dev->res.port_resource[nport].end =
-					    dev->res.port_resource[nport].start;
-				dev->res.port_resource[nport].flags =
-				    IORESOURCE_IO;
-				nport++;
-				if (nport >= PNP_MAX_PORT)
-					break;
+					end = start;
+				length = end - start + 1;
+				pnp_add_io_resource(dev, start, length, 0);
 				continue;
 			}
 			if (!strnicmp(buf, "mem", 3)) {

-- 
