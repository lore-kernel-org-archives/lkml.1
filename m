Return-Path: <linux-kernel-owner+w=401wt.eu-S967999AbYD1XCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967999AbYD1XCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966793AbYD1Wib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:38:31 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:9544 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966818AbYD1Wh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:37:27 -0400
Message-Id: <20080428223626.734315531@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:34:37 -0600
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
Subject: [patch 50/55] PNP: make generic pnp_add_mem_resource()
Content-Disposition: inline; filename=pnp-common-add-mem-resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pnp_add_mem_resource() that can be used by all the PNP
backends.  This consolidates a little more pnp_resource_table
knowledge into one place.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h             |    3 +++
 drivers/pnp/interface.c        |   19 +++++++------------
 drivers/pnp/isapnp/core.c      |   10 +++-------
 drivers/pnp/pnpacpi/rsparser.c |   30 +++++++-----------------------
 drivers/pnp/pnpbios/rsparser.c |   21 +++++----------------
 drivers/pnp/resource.c         |   29 +++++++++++++++++++++++++++++
 6 files changed, 54 insertions(+), 58 deletions(-)

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-28 16:09:47.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-28 16:09:48.000000000 -0600
@@ -48,3 +48,6 @@
 struct pnp_resource *pnp_add_io_resource(struct pnp_dev *dev,
 					 resource_size_t start,
 					 resource_size_t end, int flags);
+struct pnp_resource *pnp_add_mem_resource(struct pnp_dev *dev,
+					  resource_size_t start,
+					  resource_size_t end, int flags);
Index: work10/drivers/pnp/resource.c
===================================================================
--- work10.orig/drivers/pnp/resource.c	2008-04-28 16:09:47.000000000 -0600
+++ work10/drivers/pnp/resource.c	2008-04-28 16:09:48.000000000 -0600
@@ -657,6 +657,35 @@
 	return pnp_res;
 }
 
+struct pnp_resource *pnp_add_mem_resource(struct pnp_dev *dev,
+					  resource_size_t start,
+					  resource_size_t end, int flags)
+{
+	struct pnp_resource *pnp_res;
+	struct resource *res;
+	static unsigned char warned;
+
+	pnp_res = pnp_new_resource(dev, IORESOURCE_MEM);
+	if (!pnp_res) {
+		if (!warned) {
+			dev_err(&dev->dev, "can't add resource for MEM "
+				"%#llx-%#llx\n",(unsigned long long) start,
+				(unsigned long long) end);
+			warned = 1;
+		}
+		return NULL;
+	}
+
+	res = &pnp_res->res;
+	res->flags = IORESOURCE_MEM | flags;
+	res->start = start;
+	res->end = end;
+
+	dev_dbg(&dev->dev, "  add mem %#llx-%#llx flags %#x\n",
+		(unsigned long long) start, (unsigned long long) end, flags);
+	return pnp_res;
+}
+
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 static int __init pnp_setup_reserve_irq(char *str)
 {
Index: work10/drivers/pnp/interface.c
===================================================================
--- work10.orig/drivers/pnp/interface.c	2008-04-28 16:09:47.000000000 -0600
+++ work10/drivers/pnp/interface.c	2008-04-28 16:09:48.000000000 -0600
@@ -321,7 +321,6 @@
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
 	struct pnp_resource *pnp_res;
-	struct resource *res;
 	char *buf = (void *)ubuf;
 	int retval = 0;
 	resource_size_t start, end;
@@ -402,24 +401,20 @@
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				pnp_res = pnp_get_pnp_resource(dev,
-						IORESOURCE_MEM, nmem);
-				if (!pnp_res)
-					break;
-				pnp_res->index = nmem;
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
-				res->flags = IORESOURCE_MEM;
-				nmem++;
+					end = start;
+				pnp_res = pnp_add_mem_resource(dev, start, end,
+							       0);
+				if (pnp_res)
+					pnp_res->index = nmem++;
 				continue;
 			}
 			if (!strnicmp(buf, "irq", 3)) {
Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-28 16:09:47.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-28 16:09:48.000000000 -0600
@@ -932,7 +932,6 @@
 static int isapnp_read_resources(struct pnp_dev *dev)
 {
 	struct pnp_resource *pnp_res;
-	struct resource *res;
 	int tmp, ret;
 
 	dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
@@ -950,12 +949,9 @@
 			    isapnp_read_word(ISAPNP_CFG_MEM + (tmp << 3)) << 8;
 			if (!ret)
 				continue;
-			pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_MEM,
-						       tmp);
-			pnp_res->index = tmp;
-			res = &pnp_res->res;
-			res->start = ret;
-			res->flags = IORESOURCE_MEM;
+			pnp_res = pnp_add_mem_resource(dev, ret, ret, 0);
+			if (pnp_res)
+				pnp_res->index = tmp;
 		}
 		for (tmp = 0; tmp < ISAPNP_MAX_IRQ; tmp++) {
 			ret =
Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-28 16:09:47.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-04-28 16:09:48.000000000 -0600
@@ -173,34 +173,18 @@
 }
 
 static void pnpacpi_parse_allocated_memresource(struct pnp_dev *dev,
-						u64 mem, u64 len,
+						u64 start, u64 len,
 						int write_protect)
 {
-	struct resource *res;
-	int i;
-	static unsigned char warned;
+	int flags = 0;
+	u64 end = start + len - 1;
 
-	for (i = 0; i < PNP_MAX_MEM; i++) {
-		res = pnp_get_resource(dev, IORESOURCE_MEM, i);
-		if (!pnp_resource_valid(res))
-			break;
-	}
-	if (i < PNP_MAX_MEM) {
-		res->flags = IORESOURCE_MEM;	// Also clears _UNSET flag
-		if (len <= 0) {
-			res->flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		if (write_protect == ACPI_READ_WRITE_MEMORY)
-			res->flags |= IORESOURCE_MEM_WRITEABLE;
+	if (len == 0)
+		flags |= IORESOURCE_DISABLED;
+	if (write_protect == ACPI_READ_WRITE_MEMORY)
+		flags |= IORESOURCE_MEM_WRITEABLE;
 
-		res->start = mem;
-		res->end = mem + len - 1;
-	} else if (!warned) {
-		printk(KERN_WARNING "pnpacpi: exceeded the max number of mem "
-				"resources: %d\n", PNP_MAX_MEM);
-		warned = 1;
-	}
+	pnp_add_mem_resource(dev, start, end, flags);
 }
 
 static void pnpacpi_parse_allocated_address_space(struct pnp_dev *dev,
Index: work10/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/rsparser.c	2008-04-28 16:09:47.000000000 -0600
+++ work10/drivers/pnp/pnpbios/rsparser.c	2008-04-28 16:09:48.000000000 -0600
@@ -67,26 +67,15 @@
 }
 
 static void pnpbios_parse_allocated_memresource(struct pnp_dev *dev,
-						int mem, int len)
+						int start, int len)
 {
-	struct resource *res;
-	int i;
+	int flags = 0;
+	int end = start + len - 1;
 
-	for (i = 0; i < PNP_MAX_MEM; i++) {
-		res = pnp_get_resource(dev, IORESOURCE_MEM, i);
-		if (!pnp_resource_valid(res))
-			break;
-	}
+	if (len <= 0)
+		flags |= IORESOURCE_DISABLED;
 
-	if (i < PNP_MAX_MEM) {
-		res->flags = IORESOURCE_MEM;	// Also clears _UNSET flag
-		if (len <= 0) {
-			res->flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		res->start = (unsigned long)mem;
-		res->end = (unsigned long)(mem + len - 1);
-	}
+	pnp_add_mem_resource(dev, start, end, flags);
 }
 
 static unsigned char *pnpbios_parse_allocated_resource_data(struct pnp_dev *dev,

-- 
