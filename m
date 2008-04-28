Return-Path: <linux-kernel-owner+w=401wt.eu-S937770AbYD1W7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937770AbYD1W7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966884AbYD1WiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:38:11 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:9550 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966719AbYD1Wh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:37:27 -0400
Message-Id: <20080428223626.532872288@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:36 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 49/55] PNP: make generic pnp_add_io_resource()
Content-Disposition: inline; filename=pnp-common-add-io-resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pnp_add_io_resource() that can be used by all the PNP
backends.  This consolidates a little more pnp_resource_table
knowledge into one place.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h             |    3 +++
 drivers/pnp/interface.c        |   20 ++++++++------------
 drivers/pnp/isapnp/core.c      |    8 +++-----
 drivers/pnp/pnpacpi/rsparser.c |   35 ++++++++++-------------------------
 drivers/pnp/pnpbios/rsparser.c |   23 ++++++-----------------
 drivers/pnp/resource.c         |   29 +++++++++++++++++++++++++++++
 6 files changed, 59 insertions(+), 59 deletions(-)

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-28 16:09:46.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-28 16:09:47.000000000 -0600
@@ -45,3 +45,6 @@
 					  int flags);
 struct pnp_resource *pnp_add_dma_resource(struct pnp_dev *dev, int dma,
 					  int flags);
+struct pnp_resource *pnp_add_io_resource(struct pnp_dev *dev,
+					 resource_size_t start,
+					 resource_size_t end, int flags);
Index: work10/drivers/pnp/interface.c
===================================================================
--- work10.orig/drivers/pnp/interface.c	2008-04-28 16:09:46.000000000 -0600
+++ work10/drivers/pnp/interface.c	2008-04-28 16:09:47.000000000 -0600
@@ -324,7 +324,7 @@
 	struct resource *res;
 	char *buf = (void *)ubuf;
 	int retval = 0;
-	resource_size_t start;
+	resource_size_t start, end;
 
 	if (dev->status & PNP_ATTACHED) {
 		retval = -EBUSY;
@@ -382,24 +382,20 @@
 				buf += 2;
 				while (isspace(*buf))
 					++buf;
-				pnp_res = pnp_get_pnp_resource(dev,
-						IORESOURCE_IO, nport);
-				if (!pnp_res)
-					break;
-				pnp_res->index = nport;
-				res = &pnp_res->res;
-				res->start = simple_strtoul(buf, &buf, 0);
+				start = simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
 				if (*buf == '-') {
 					buf += 1;
 					while (isspace(*buf))
 						++buf;
-					res->end = simple_strtoul(buf, &buf, 0);
+					end = simple_strtoul(buf, &buf, 0);
 				} else
-					res->end = res->start;
-				res->flags = IORESOURCE_IO;
-				nport++;
+					end = start;
+				pnp_res = pnp_add_io_resource(dev, start, end,
+							      0);
+				if (pnp_res)
+					pnp_res->index = nport++;
 				continue;
 			}
 			if (!strnicmp(buf, "mem", 3)) {
Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-28 16:09:46.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-28 16:09:47.000000000 -0600
@@ -941,11 +941,9 @@
 			ret = isapnp_read_word(ISAPNP_CFG_PORT + (tmp << 1));
 			if (!ret)
 				continue;
-			pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IO, tmp);
-			pnp_res->index = tmp;
-			res = &pnp_res->res;
-			res->start = ret;
-			res->flags = IORESOURCE_IO;
+			pnp_res = pnp_add_io_resource(dev, ret, ret, 0);
+			if (pnp_res)
+				pnp_res->index = tmp;
 		}
 		for (tmp = 0; tmp < ISAPNP_MAX_MEM; tmp++) {
 			ret =
Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-28 16:09:46.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-04-28 16:09:47.000000000 -0600
@@ -158,33 +158,18 @@
 	return flags;
 }
 
-static void pnpacpi_parse_allocated_ioresource(struct pnp_dev *dev,
-					       u64 io, u64 len, int io_decode)
+static void pnpacpi_parse_allocated_ioresource(struct pnp_dev *dev, u64 start,
+					       u64 len, int io_decode)
 {
-	struct resource *res;
-	int i;
-	static unsigned char warned;
+	int flags = 0;
+	u64 end = start + len - 1;
 
-	for (i = 0; i < PNP_MAX_PORT; i++) {
-		res = pnp_get_resource(dev, IORESOURCE_IO, i);
-		if (!pnp_resource_valid(res))
-			break;
-	}
-	if (i < PNP_MAX_PORT) {
-		res->flags = IORESOURCE_IO;	// Also clears _UNSET flag
-		if (io_decode == ACPI_DECODE_16)
-			res->flags |= PNP_PORT_FLAG_16BITADDR;
-		if (len <= 0 || (io + len - 1) >= 0x10003) {
-			res->flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		res->start = io;
-		res->end = io + len - 1;
-	} else if (!warned) {
-		printk(KERN_WARNING "pnpacpi: exceeded the max number of IO "
-				"resources: %d \n", PNP_MAX_PORT);
-		warned = 1;
-	}
+	if (io_decode == ACPI_DECODE_16)
+		flags |= PNP_PORT_FLAG_16BITADDR;
+	if (len == 0 || end >= 0x10003)
+		flags |= IORESOURCE_DISABLED;
+
+	pnp_add_io_resource(dev, start, end, flags);
 }
 
 static void pnpacpi_parse_allocated_memresource(struct pnp_dev *dev,
Index: work10/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/rsparser.c	2008-04-28 16:09:46.000000000 -0600
+++ work10/drivers/pnp/pnpbios/rsparser.c	2008-04-28 16:09:47.000000000 -0600
@@ -55,26 +55,15 @@
  */
 
 static void pnpbios_parse_allocated_ioresource(struct pnp_dev *dev,
-					       int io, int len)
+					       int start, int len)
 {
-	struct resource *res;
-	int i;
+	int flags = 0;
+	int end = start + len - 1;
 
-	for (i = 0; i < PNP_MAX_PORT; i++) {
-		res = pnp_get_resource(dev, IORESOURCE_IO, i);
-		if (!pnp_resource_valid(res))
-			break;
-	}
+	if (len <= 0 || end >= 0x10003)
+		flags |= IORESOURCE_DISABLED;
 
-	if (i < PNP_MAX_PORT) {
-		res->flags = IORESOURCE_IO;	// Also clears _UNSET flag
-		if (len <= 0 || (io + len - 1) >= 0x10003) {
-			res->flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		res->start = (unsigned long)io;
-		res->end = (unsigned long)(io + len - 1);
-	}
+	pnp_add_io_resource(dev, start, end, flags);
 }
 
 static void pnpbios_parse_allocated_memresource(struct pnp_dev *dev,
Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-04-28 16:09:46.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-04-28 16:09:47.000000000 -0600
@@ -628,6 +628,35 @@
 	return pnp_res;
 }
 
+struct pnp_resource *pnp_add_io_resource(struct pnp_dev *dev,
+					 resource_size_t start,
+					 resource_size_t end, int flags)
+{
+	struct pnp_resource *pnp_res;
+	struct resource *res;
+	static unsigned char warned;
+
+	pnp_res = pnp_new_resource(dev, IORESOURCE_IO);
+	if (!pnp_res) {
+		if (!warned) {
+			dev_err(&dev->dev, "can't add resource for IO "
+				"%#llx-%#llx\n",(unsigned long long) start,
+				(unsigned long long) end);
+			warned = 1;
+		}
+		return NULL;
+	}
+
+	res = &pnp_res->res;
+	res->flags = IORESOURCE_IO | flags;
+	res->start = start;
+	res->end = end;
+
+	dev_dbg(&dev->dev, "  add io  %#llx-%#llx flags %#x\n",
+		(unsigned long long) start, (unsigned long long) end, flags);
+	return pnp_res;
+}
+
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 static int __init pnp_setup_reserve_irq(char *str)
 {

-- 
