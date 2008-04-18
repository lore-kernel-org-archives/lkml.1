Return-Path: <linux-kernel-owner+w=401wt.eu-S1763507AbYDRVJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763507AbYDRVJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761139AbYDRUxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:53:21 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:7624 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761096AbYDRUwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:52:31 -0400
Message-Id: <20080418205055.774927244@ldl.fc.hp.com>
References: <20080418204955.342963315@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 14:50:37 -0600
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
Subject: [patch 42/53] PNP: make generic pnp_add_mem_resource()
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
 drivers/pnp/resource.c         |   26 ++++++++++++++++++++++++++
 drivers/pnp/interface.c        |   17 +++++++----------
 drivers/pnp/isapnp/core.c      |    9 +++------
 drivers/pnp/pnpacpi/rsparser.c |   32 ++++++++------------------------
 drivers/pnp/pnpbios/rsparser.c |   23 ++++++-----------------
 6 files changed, 53 insertions(+), 57 deletions(-)

Index: work8/drivers/pnp/base.h
===================================================================
--- work8.orig/drivers/pnp/base.h	2008-04-18 11:05:06.000000000 -0600
+++ work8/drivers/pnp/base.h	2008-04-18 11:06:13.000000000 -0600
@@ -43,3 +43,6 @@
 struct pnp_resource *pnp_add_io_resource(struct pnp_dev *dev,
 					 resource_size_t start,
 					 resource_size_t end, int flags);
+struct pnp_resource *pnp_add_mem_resource(struct pnp_dev *dev,
+					  resource_size_t start,
+					  resource_size_t end, int flags);
Index: work8/drivers/pnp/resource.c
===================================================================
--- work8.orig/drivers/pnp/resource.c	2008-04-18 11:05:06.000000000 -0600
+++ work8/drivers/pnp/resource.c	2008-04-18 11:06:13.000000000 -0600
@@ -633,6 +633,32 @@
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
+				"0x%llx-0x%llx\n",(unsigned long long) start,
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
+	return pnp_res;
+}
+
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 static int __init pnp_setup_reserve_irq(char *str)
 {
Index: work8/drivers/pnp/interface.c
===================================================================
--- work8.orig/drivers/pnp/interface.c	2008-04-18 11:05:47.000000000 -0600
+++ work8/drivers/pnp/interface.c	2008-04-18 11:06:50.000000000 -0600
@@ -323,7 +323,6 @@
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
 	struct pnp_resource *pnp_res;
-	struct resource *res;
 	char *buf = (void *)ubuf;
 	int retval = 0;
 	resource_size_t start, end;
@@ -404,22 +403,20 @@
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				res = pnp_get_resource(dev, IORESOURCE_MEM,
-						       nmem);
-				if (!res)
-					break;
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
Index: work8/drivers/pnp/isapnp/core.c
===================================================================
--- work8.orig/drivers/pnp/isapnp/core.c	2008-04-18 11:05:06.000000000 -0600
+++ work8/drivers/pnp/isapnp/core.c	2008-04-18 11:06:13.000000000 -0600
@@ -924,7 +924,6 @@
 static int isapnp_read_resources(struct pnp_dev *dev)
 {
 	struct pnp_resource *pnp_res;
-	struct resource *res;
 	int tmp, ret;
 
 	dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
@@ -942,11 +941,9 @@
 			    isapnp_read_word(ISAPNP_CFG_MEM + (tmp << 3)) << 8;
 			if (!ret)
 				continue;
-			pnp_res = &dev->res->mem[tmp];
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
Index: work8/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work8.orig/drivers/pnp/pnpacpi/rsparser.c	2008-04-18 11:05:06.000000000 -0600
+++ work8/drivers/pnp/pnpacpi/rsparser.c	2008-04-18 11:06:13.000000000 -0600
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
-		res = &dev->res->mem[i].res;
-		if (res->flags & IORESOURCE_UNSET)
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
Index: work8/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work8.orig/drivers/pnp/pnpbios/rsparser.c	2008-04-18 11:05:06.000000000 -0600
+++ work8/drivers/pnp/pnpbios/rsparser.c	2008-04-18 11:06:13.000000000 -0600
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
-		res = &dev->res->mem[i].res;
-		if (res->flags & IORESOURCE_UNSET)
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
