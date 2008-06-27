Return-Path: <linux-kernel-owner+w=401wt.eu-S1764980AbYF0XDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764980AbYF0XDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764352AbYF0W7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:59:03 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:19520 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763817AbYF0W6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:58:53 -0400
Message-Id: <20080627225759.487467988@ldl.fc.hp.com>
References: <20080627225651.663174474@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 16:56:57 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
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
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 06/28] PNP: replace pnp_resource_table with dynamically allocated resources
Content-Disposition: inline; filename=pnp-convert-to-lists
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PNP used to have a fixed-size pnp_resource_table for tracking the
resources used by a device.  This table often overflowed, so we've
had to increase the table size, which wastes memory because most
devices have very few resources.

This patch replaces the table with a linked list of resources where
the entries are allocated on demand.

This removes messages like these:

    pnpacpi: exceeded the max number of IO resources
    00:01: too many I/O port resources

References:

    http://bugzilla.kernel.org/show_bug.cgi?id=9535
    http://bugzilla.kernel.org/show_bug.cgi?id=9740
    http://lkml.org/lkml/2007/11/30/110

This patch also changes the way PNP uses the IORESOURCE_UNSET,
IORESOURCE_AUTO, and IORESOURCE_DISABLED flags.

Prior to this patch, the pnp_resource_table entries used the flags
like this:

    IORESOURCE_UNSET
	This table entry is unused and available for use.  When this flag
	is set, we shouldn't look at anything else in the resource structure.
	This flag is set when a resource table entry is initialized.

    IORESOURCE_AUTO
	This resource was assigned automatically by pnp_assign_{io,mem,etc}().

	This flag is set when a resource table entry is initialized and
	cleared whenever we discover a resource setting by reading an ISAPNP
	config register, parsing a PNPBIOS resource data stream, parsing an
	ACPI _CRS list, or interpreting a sysfs "set" command.

	Resources marked IORESOURCE_AUTO are reinitialized and marked as
	IORESOURCE_UNSET by pnp_clean_resource_table() in these cases:

	    - before we attempt to assign resources automatically,
	    - if we fail to assign resources automatically,
	    - after disabling a device

    IORESOURCE_DISABLED
	Set by pnp_assign_{io,mem,etc}() when automatic assignment fails.
	Also set by PNPBIOS and PNPACPI for:

	    - invalid IRQs or GSI registration failures
	    - invalid DMA channels
	    - I/O ports above 0x10000
	    - mem ranges with negative length

After this patch, there is no pnp_resource_table, and the resource list
entries use the flags like this:

    IORESOURCE_UNSET
	This flag is no longer used in PNP.  Instead of keeping
	IORESOURCE_UNSET entries in the resource list, we remove
	entries from the list and free them.

    IORESOURCE_AUTO
	No change in meaning: it still means the resource was assigned
	automatically by pnp_assign_{port,mem,etc}(), but these functions
	now set the bit explicitly.

	We still "clean" a device's resource list in the same places,
	but rather than reinitializing IORESOURCE_AUTO entries, we
	just remove them from the list.

	Note that IORESOURCE_AUTO entries are always at the end of the
	list, so removing them doesn't reorder other list entries.
	This is because non-IORESOURCE_AUTO entries are added by the
	ISAPNP, PNPBIOS, or PNPACPI "get resources" methods and by the
	sysfs "set" command.  In each of these cases, we completely free
	the resource list first.

    IORESOURCE_DISABLED
	In addition to the cases where we used to set this flag, ISAPNP now
	adds an IORESOURCE_DISABLED resource when it reads a configuration
	register with a "disabled" value.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h             |   18 ---
 drivers/pnp/core.c             |   25 +++-
 drivers/pnp/interface.c        |   60 ++++-------
 drivers/pnp/isapnp/core.c      |   12 --
 drivers/pnp/manager.c          |  218 ++++++++++-------------------------------
 drivers/pnp/pnpacpi/rsparser.c |  131 ++++++++++++++++--------
 drivers/pnp/pnpbios/rsparser.c |   95 ++++++++++++-----
 drivers/pnp/quirks.c           |    3 
 drivers/pnp/resource.c         |   86 +++-------------
 drivers/pnp/support.c          |   79 ++++++--------
 drivers/pnp/system.c           |    4 
 include/linux/pnp.h            |   20 ++-
 12 files changed, 330 insertions(+), 421 deletions(-)

Index: work14/drivers/pnp/base.h
===================================================================
--- work14.orig/drivers/pnp/base.h	2008-06-17 14:45:32.000000000 -0600
+++ work14/drivers/pnp/base.h	2008-06-24 16:53:06.000000000 -0600
@@ -46,27 +46,15 @@ int pnp_check_dma(struct pnp_dev *dev, s
 char *pnp_resource_type_name(struct resource *res);
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc);
 
-void pnp_init_resource(struct resource *res);
+void pnp_free_resources(struct pnp_dev *dev);
 int pnp_resource_type(struct resource *res);
 
-struct pnp_resource *pnp_get_pnp_resource(struct pnp_dev *dev,
-					  unsigned int type, unsigned int num);
-
-#define PNP_MAX_PORT		40
-#define PNP_MAX_MEM		24
-#define PNP_MAX_IRQ		 2
-#define PNP_MAX_DMA		 2
-
 struct pnp_resource {
+	struct list_head list;
 	struct resource res;
 };
 
-struct pnp_resource_table {
-	struct pnp_resource port[PNP_MAX_PORT];
-	struct pnp_resource mem[PNP_MAX_MEM];
-	struct pnp_resource dma[PNP_MAX_DMA];
-	struct pnp_resource irq[PNP_MAX_IRQ];
-};
+void pnp_free_resource(struct pnp_resource *pnp_res);
 
 struct pnp_resource *pnp_add_irq_resource(struct pnp_dev *dev, int irq,
 					  int flags);
Index: work14/drivers/pnp/core.c
===================================================================
--- work14.orig/drivers/pnp/core.c	2008-06-17 14:45:32.000000000 -0600
+++ work14/drivers/pnp/core.c	2008-06-24 16:53:05.000000000 -0600
@@ -99,6 +99,21 @@ static void pnp_free_ids(struct pnp_dev 
 	}
 }
 
+void pnp_free_resource(struct pnp_resource *pnp_res)
+{
+	list_del(&pnp_res->list);
+	kfree(pnp_res);
+}
+
+void pnp_free_resources(struct pnp_dev *dev)
+{
+	struct pnp_resource *pnp_res, *tmp;
+
+	list_for_each_entry_safe(pnp_res, tmp, &dev->resources, list) {
+		pnp_free_resource(pnp_res);
+	}
+}
+
 static void pnp_release_device(struct device *dmdev)
 {
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
@@ -106,7 +121,7 @@ static void pnp_release_device(struct de
 	pnp_free_option(dev->independent);
 	pnp_free_option(dev->dependent);
 	pnp_free_ids(dev);
-	kfree(dev->res);
+	pnp_free_resources(dev);
 	kfree(dev);
 }
 
@@ -119,12 +134,7 @@ struct pnp_dev *pnp_alloc_dev(struct pnp
 	if (!dev)
 		return NULL;
 
-	dev->res = kzalloc(sizeof(struct pnp_resource_table), GFP_KERNEL);
-	if (!dev->res) {
-		kfree(dev);
-		return NULL;
-	}
-
+	INIT_LIST_HEAD(&dev->resources);
 	dev->protocol = protocol;
 	dev->number = id;
 	dev->dma_mask = DMA_24BIT_MASK;
@@ -140,7 +150,6 @@ struct pnp_dev *pnp_alloc_dev(struct pnp
 
 	dev_id = pnp_add_id(dev, pnpid);
 	if (!dev_id) {
-		kfree(dev->res);
 		kfree(dev);
 		return NULL;
 	}
Index: work14/drivers/pnp/interface.c
===================================================================
--- work14.orig/drivers/pnp/interface.c	2008-06-17 14:45:32.000000000 -0600
+++ work14/drivers/pnp/interface.c	2008-06-24 16:53:06.000000000 -0600
@@ -269,46 +269,38 @@ static ssize_t pnp_show_current_resource
 		pnp_printf(buffer, "disabled\n");
 
 	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IO, i)); i++) {
-		if (pnp_resource_valid(res)) {
-			pnp_printf(buffer, "io");
-			if (res->flags & IORESOURCE_DISABLED)
-				pnp_printf(buffer, " disabled\n");
-			else
-				pnp_printf(buffer, " 0x%llx-0x%llx\n",
-					   (unsigned long long) res->start,
-					   (unsigned long long) res->end);
-		}
+		pnp_printf(buffer, "io");
+		if (res->flags & IORESOURCE_DISABLED)
+			pnp_printf(buffer, " disabled\n");
+		else
+			pnp_printf(buffer, " 0x%llx-0x%llx\n",
+				   (unsigned long long) res->start,
+				   (unsigned long long) res->end);
 	}
 	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
-		if (pnp_resource_valid(res)) {
-			pnp_printf(buffer, "mem");
-			if (res->flags & IORESOURCE_DISABLED)
-				pnp_printf(buffer, " disabled\n");
-			else
-				pnp_printf(buffer, " 0x%llx-0x%llx\n",
-					   (unsigned long long) res->start,
-					   (unsigned long long) res->end);
-		}
+		pnp_printf(buffer, "mem");
+		if (res->flags & IORESOURCE_DISABLED)
+			pnp_printf(buffer, " disabled\n");
+		else
+			pnp_printf(buffer, " 0x%llx-0x%llx\n",
+				   (unsigned long long) res->start,
+				   (unsigned long long) res->end);
 	}
 	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IRQ, i)); i++) {
-		if (pnp_resource_valid(res)) {
-			pnp_printf(buffer, "irq");
-			if (res->flags & IORESOURCE_DISABLED)
-				pnp_printf(buffer, " disabled\n");
-			else
-				pnp_printf(buffer, " %lld\n",
-					   (unsigned long long) res->start);
-		}
+		pnp_printf(buffer, "irq");
+		if (res->flags & IORESOURCE_DISABLED)
+			pnp_printf(buffer, " disabled\n");
+		else
+			pnp_printf(buffer, " %lld\n",
+				   (unsigned long long) res->start);
 	}
 	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_DMA, i)); i++) {
-		if (pnp_resource_valid(res)) {
-			pnp_printf(buffer, "dma");
-			if (res->flags & IORESOURCE_DISABLED)
-				pnp_printf(buffer, " disabled\n");
-			else
-				pnp_printf(buffer, " %lld\n",
-					   (unsigned long long) res->start);
-		}
+		pnp_printf(buffer, "dma");
+		if (res->flags & IORESOURCE_DISABLED)
+			pnp_printf(buffer, " disabled\n");
+		else
+			pnp_printf(buffer, " %lld\n",
+				   (unsigned long long) res->start);
 	}
 	ret = (buffer->curr - buf);
 	kfree(buffer);
Index: work14/drivers/pnp/isapnp/core.c
===================================================================
--- work14.orig/drivers/pnp/isapnp/core.c	2008-06-17 14:45:32.000000000 -0600
+++ work14/drivers/pnp/isapnp/core.c	2008-06-24 16:53:06.000000000 -0600
@@ -973,8 +973,7 @@ static int isapnp_set_resources(struct p
 	dev->active = 1;
 	for (tmp = 0; tmp < ISAPNP_MAX_PORT; tmp++) {
 		res = pnp_get_resource(dev, IORESOURCE_IO, tmp);
-		if (res && pnp_resource_valid(res) &&
-		    !(res->flags & IORESOURCE_DISABLED)) {
+		if (pnp_resource_enabled(res)) {
 			dev_dbg(&dev->dev, "  set io  %d to %#llx\n",
 				tmp, (unsigned long long) res->start);
 			isapnp_write_word(ISAPNP_CFG_PORT + (tmp << 1),
@@ -983,8 +982,7 @@ static int isapnp_set_resources(struct p
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_IRQ; tmp++) {
 		res = pnp_get_resource(dev, IORESOURCE_IRQ, tmp);
-		if (res && pnp_resource_valid(res) &&
-		    !(res->flags & IORESOURCE_DISABLED)) {
+		if (pnp_resource_enabled(res)) {
 			int irq = res->start;
 			if (irq == 2)
 				irq = 9;
@@ -994,8 +992,7 @@ static int isapnp_set_resources(struct p
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_DMA; tmp++) {
 		res = pnp_get_resource(dev, IORESOURCE_DMA, tmp);
-		if (res && pnp_resource_valid(res) &&
-		    !(res->flags & IORESOURCE_DISABLED)) {
+		if (pnp_resource_enabled(res)) {
 			dev_dbg(&dev->dev, "  set dma %d to %lld\n",
 				tmp, (unsigned long long) res->start);
 			isapnp_write_byte(ISAPNP_CFG_DMA + tmp, res->start);
@@ -1003,8 +1000,7 @@ static int isapnp_set_resources(struct p
 	}
 	for (tmp = 0; tmp < ISAPNP_MAX_MEM; tmp++) {
 		res = pnp_get_resource(dev, IORESOURCE_MEM, tmp);
-		if (res && pnp_resource_valid(res) &&
-		    !(res->flags & IORESOURCE_DISABLED)) {
+		if (pnp_resource_enabled(res)) {
 			dev_dbg(&dev->dev, "  set mem %d to %#llx\n",
 				tmp, (unsigned long long) res->start);
 			isapnp_write_word(ISAPNP_CFG_MEM + (tmp << 3),
Index: work14/drivers/pnp/manager.c
===================================================================
--- work14.orig/drivers/pnp/manager.c	2008-06-17 14:45:32.000000000 -0600
+++ work14/drivers/pnp/manager.c	2008-06-24 16:53:05.000000000 -0600
@@ -19,40 +19,30 @@ DEFINE_MUTEX(pnp_res_mutex);
 
 static int pnp_assign_port(struct pnp_dev *dev, struct pnp_port *rule, int idx)
 {
-	struct pnp_resource *pnp_res;
-	struct resource *res;
+	struct resource *res, local_res;
 
-	pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IO, idx);
-	if (!pnp_res) {
-		dev_err(&dev->dev, "too many I/O port resources\n");
-		/* pretend we were successful so at least the manager won't try again */
-		return 1;
-	}
-
-	res = &pnp_res->res;
-
-	/* check if this resource has been manually set, if so skip */
-	if (!(res->flags & IORESOURCE_AUTO)) {
+	res = pnp_get_resource(dev, IORESOURCE_IO, idx);
+	if (res) {
 		dev_dbg(&dev->dev, "  io %d already set to %#llx-%#llx "
 			"flags %#lx\n", idx, (unsigned long long) res->start,
 			(unsigned long long) res->end, res->flags);
 		return 1;
 	}
 
-	/* set the initial values */
-	res->flags |= rule->flags | IORESOURCE_IO;
-	res->flags &= ~IORESOURCE_UNSET;
+	res = &local_res;
+	res->flags = rule->flags | IORESOURCE_AUTO;
+	res->start = 0;
+	res->end = 0;
 
 	if (!rule->size) {
 		res->flags |= IORESOURCE_DISABLED;
 		dev_dbg(&dev->dev, "  io %d disabled\n", idx);
-		return 1;	/* skip disabled resource requests */
+		goto __add;
 	}
 
 	res->start = rule->min;
 	res->end = res->start + rule->size - 1;
 
-	/* run through until pnp_check_port is happy */
 	while (!pnp_check_port(dev, res)) {
 		res->start += rule->align;
 		res->end = res->start + rule->size - 1;
@@ -61,38 +51,29 @@ static int pnp_assign_port(struct pnp_de
 			return 0;
 		}
 	}
-	dev_dbg(&dev->dev, "  assign io  %d %#llx-%#llx\n", idx,
-		(unsigned long long) res->start, (unsigned long long) res->end);
+
+__add:
+	pnp_add_io_resource(dev, res->start, res->end, res->flags);
 	return 1;
 }
 
 static int pnp_assign_mem(struct pnp_dev *dev, struct pnp_mem *rule, int idx)
 {
-	struct pnp_resource *pnp_res;
-	struct resource *res;
-
-	pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_MEM, idx);
-	if (!pnp_res) {
-		dev_err(&dev->dev, "too many memory resources\n");
-		/* pretend we were successful so at least the manager won't try again */
-		return 1;
-	}
-
-	res = &pnp_res->res;
+	struct resource *res, local_res;
 
-	/* check if this resource has been manually set, if so skip */
-	if (!(res->flags & IORESOURCE_AUTO)) {
+	res = pnp_get_resource(dev, IORESOURCE_MEM, idx);
+	if (res) {
 		dev_dbg(&dev->dev, "  mem %d already set to %#llx-%#llx "
 			"flags %#lx\n", idx, (unsigned long long) res->start,
 			(unsigned long long) res->end, res->flags);
 		return 1;
 	}
 
-	/* set the initial values */
-	res->flags |= rule->flags | IORESOURCE_MEM;
-	res->flags &= ~IORESOURCE_UNSET;
+	res = &local_res;
+	res->flags = rule->flags | IORESOURCE_AUTO;
+	res->start = 0;
+	res->end = 0;
 
-	/* convert pnp flags to standard Linux flags */
 	if (!(rule->flags & IORESOURCE_MEM_WRITEABLE))
 		res->flags |= IORESOURCE_READONLY;
 	if (rule->flags & IORESOURCE_MEM_CACHEABLE)
@@ -105,13 +86,12 @@ static int pnp_assign_mem(struct pnp_dev
 	if (!rule->size) {
 		res->flags |= IORESOURCE_DISABLED;
 		dev_dbg(&dev->dev, "  mem %d disabled\n", idx);
-		return 1;	/* skip disabled resource requests */
+		goto __add;
 	}
 
 	res->start = rule->min;
 	res->end = res->start + rule->size - 1;
 
-	/* run through until pnp_check_mem is happy */
 	while (!pnp_check_mem(dev, res)) {
 		res->start += rule->align;
 		res->end = res->start + rule->size - 1;
@@ -120,15 +100,15 @@ static int pnp_assign_mem(struct pnp_dev
 			return 0;
 		}
 	}
-	dev_dbg(&dev->dev, "  assign mem %d %#llx-%#llx\n", idx,
-		(unsigned long long) res->start, (unsigned long long) res->end);
+
+__add:
+	pnp_add_mem_resource(dev, res->start, res->end, res->flags);
 	return 1;
 }
 
 static int pnp_assign_irq(struct pnp_dev *dev, struct pnp_irq *rule, int idx)
 {
-	struct pnp_resource *pnp_res;
-	struct resource *res;
+	struct resource *res, local_res;
 	int i;
 
 	/* IRQ priority: this table is good for i386 */
@@ -136,58 +116,48 @@ static int pnp_assign_irq(struct pnp_dev
 		5, 10, 11, 12, 9, 14, 15, 7, 3, 4, 13, 0, 1, 6, 8, 2
 	};
 
-	pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IRQ, idx);
-	if (!pnp_res) {
-		dev_err(&dev->dev, "too many IRQ resources\n");
-		/* pretend we were successful so at least the manager won't try again */
-		return 1;
-	}
-
-	res = &pnp_res->res;
-
-	/* check if this resource has been manually set, if so skip */
-	if (!(res->flags & IORESOURCE_AUTO)) {
+	res = pnp_get_resource(dev, IORESOURCE_IRQ, idx);
+	if (res) {
 		dev_dbg(&dev->dev, "  irq %d already set to %d flags %#lx\n",
 			idx, (int) res->start, res->flags);
 		return 1;
 	}
 
-	/* set the initial values */
-	res->flags |= rule->flags | IORESOURCE_IRQ;
-	res->flags &= ~IORESOURCE_UNSET;
+	res = &local_res;
+	res->flags = rule->flags | IORESOURCE_AUTO;
+	res->start = -1;
+	res->end = -1;
 
 	if (bitmap_empty(rule->map, PNP_IRQ_NR)) {
 		res->flags |= IORESOURCE_DISABLED;
 		dev_dbg(&dev->dev, "  irq %d disabled\n", idx);
-		return 1;	/* skip disabled resource requests */
+		goto __add;
 	}
 
 	/* TBD: need check for >16 IRQ */
 	res->start = find_next_bit(rule->map, PNP_IRQ_NR, 16);
 	if (res->start < PNP_IRQ_NR) {
 		res->end = res->start;
-		dev_dbg(&dev->dev, "  assign irq %d %d\n", idx,
-			(int) res->start);
-		return 1;
+		goto __add;
 	}
 	for (i = 0; i < 16; i++) {
 		if (test_bit(xtab[i], rule->map)) {
 			res->start = res->end = xtab[i];
-			if (pnp_check_irq(dev, res)) {
-				dev_dbg(&dev->dev, "  assign irq %d %d\n", idx,
-					(int) res->start);
-				return 1;
-			}
+			if (pnp_check_irq(dev, res))
+				goto __add;
 		}
 	}
 	dev_dbg(&dev->dev, "  couldn't assign irq %d\n", idx);
 	return 0;
+
+__add:
+	pnp_add_irq_resource(dev, res->start, res->flags);
+	return 1;
 }
 
 static void pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
 {
-	struct pnp_resource *pnp_res;
-	struct resource *res;
+	struct resource *res, local_res;
 	int i;
 
 	/* DMA priority: this table is good for i386 */
@@ -195,127 +165,47 @@ static void pnp_assign_dma(struct pnp_de
 		1, 3, 5, 6, 7, 0, 2, 4
 	};
 
-	pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_DMA, idx);
-	if (!pnp_res) {
-		dev_err(&dev->dev, "too many DMA resources\n");
-		return;
-	}
-
-	res = &pnp_res->res;
-
-	/* check if this resource has been manually set, if so skip */
-	if (!(res->flags & IORESOURCE_AUTO)) {
+	res = pnp_get_resource(dev, IORESOURCE_DMA, idx);
+	if (res) {
 		dev_dbg(&dev->dev, "  dma %d already set to %d flags %#lx\n",
 			idx, (int) res->start, res->flags);
 		return;
 	}
 
-	/* set the initial values */
-	res->flags |= rule->flags | IORESOURCE_DMA;
-	res->flags &= ~IORESOURCE_UNSET;
+	res = &local_res;
+	res->flags = rule->flags | IORESOURCE_AUTO;
+	res->start = -1;
+	res->end = -1;
 
 	for (i = 0; i < 8; i++) {
 		if (rule->map & (1 << xtab[i])) {
 			res->start = res->end = xtab[i];
-			if (pnp_check_dma(dev, res)) {
-				dev_dbg(&dev->dev, "  assign dma %d %d\n", idx,
-					(int) res->start);
-				return;
-			}
+			if (pnp_check_dma(dev, res))
+				goto __add;
 		}
 	}
 #ifdef MAX_DMA_CHANNELS
 	res->start = res->end = MAX_DMA_CHANNELS;
 #endif
-	res->flags |= IORESOURCE_UNSET | IORESOURCE_DISABLED;
+	res->flags |= IORESOURCE_DISABLED;
 	dev_dbg(&dev->dev, "  disable dma %d\n", idx);
-}
 
-void pnp_init_resource(struct resource *res)
-{
-	unsigned long type;
-
-	type = res->flags & (IORESOURCE_IO  | IORESOURCE_MEM |
-			     IORESOURCE_IRQ | IORESOURCE_DMA);
-
-	res->name = NULL;
-	res->flags = type | IORESOURCE_AUTO | IORESOURCE_UNSET;
-	if (type == IORESOURCE_IRQ || type == IORESOURCE_DMA) {
-		res->start = -1;
-		res->end = -1;
-	} else {
-		res->start = 0;
-		res->end = 0;
-	}
+__add:
+	pnp_add_dma_resource(dev, res->start, res->flags);
 }
 
-/**
- * pnp_init_resources - Resets a resource table to default values.
- * @table: pointer to the desired resource table
- */
 void pnp_init_resources(struct pnp_dev *dev)
 {
-	struct resource *res;
-	int idx;
-
-	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
-		res = &dev->res->irq[idx].res;
-		res->flags = IORESOURCE_IRQ;
-		pnp_init_resource(res);
-	}
-	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
-		res = &dev->res->dma[idx].res;
-		res->flags = IORESOURCE_DMA;
-		pnp_init_resource(res);
-	}
-	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
-		res = &dev->res->port[idx].res;
-		res->flags = IORESOURCE_IO;
-		pnp_init_resource(res);
-	}
-	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
-		res = &dev->res->mem[idx].res;
-		res->flags = IORESOURCE_MEM;
-		pnp_init_resource(res);
-	}
+	pnp_free_resources(dev);
 }
 
-/**
- * pnp_clean_resources - clears resources that were not manually set
- * @res: the resources to clean
- */
 static void pnp_clean_resource_table(struct pnp_dev *dev)
 {
-	struct resource *res;
-	int idx;
+	struct pnp_resource *pnp_res, *tmp;
 
-	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
-		res = &dev->res->irq[idx].res;
-		if (res->flags & IORESOURCE_AUTO) {
-			res->flags = IORESOURCE_IRQ;
-			pnp_init_resource(res);
-		}
-	}
-	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
-		res = &dev->res->dma[idx].res;
-		if (res->flags & IORESOURCE_AUTO) {
-			res->flags = IORESOURCE_DMA;
-			pnp_init_resource(res);
-		}
-	}
-	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
-		res = &dev->res->port[idx].res;
-		if (res->flags & IORESOURCE_AUTO) {
-			res->flags = IORESOURCE_IO;
-			pnp_init_resource(res);
-		}
-	}
-	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
-		res = &dev->res->mem[idx].res;
-		if (res->flags & IORESOURCE_AUTO) {
-			res->flags = IORESOURCE_MEM;
-			pnp_init_resource(res);
-		}
+	list_for_each_entry_safe(pnp_res, tmp, &dev->resources, list) {
+		if (pnp_res->res.flags & IORESOURCE_AUTO)
+			pnp_free_resource(pnp_res);
 	}
 }
 
Index: work14/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work14.orig/drivers/pnp/pnpacpi/rsparser.c	2008-06-17 14:44:52.000000000 -0600
+++ work14/drivers/pnp/pnpacpi/rsparser.c	2008-06-24 16:53:06.000000000 -0600
@@ -806,6 +806,13 @@ static void pnpacpi_encode_irq(struct pn
 	struct acpi_resource_irq *irq = &resource->data.irq;
 	int triggering, polarity, shareable;
 
+	if (!pnp_resource_enabled(p)) {
+		irq->interrupt_count = 0;
+		dev_dbg(&dev->dev, "  encode irq (%s)\n",
+			p ? "disabled" : "missing");
+		return;
+	}
+
 	decode_irq_flags(dev, p->flags, &triggering, &polarity, &shareable);
 	irq->triggering = triggering;
 	irq->polarity = polarity;
@@ -828,6 +835,13 @@ static void pnpacpi_encode_ext_irq(struc
 	struct acpi_resource_extended_irq *extended_irq = &resource->data.extended_irq;
 	int triggering, polarity, shareable;
 
+	if (!pnp_resource_enabled(p)) {
+		extended_irq->interrupt_count = 0;
+		dev_dbg(&dev->dev, "  encode extended irq (%s)\n",
+			p ? "disabled" : "missing");
+		return;
+	}
+
 	decode_irq_flags(dev, p->flags, &triggering, &polarity, &shareable);
 	extended_irq->producer_consumer = ACPI_CONSUMER;
 	extended_irq->triggering = triggering;
@@ -848,6 +862,13 @@ static void pnpacpi_encode_dma(struct pn
 {
 	struct acpi_resource_dma *dma = &resource->data.dma;
 
+	if (!pnp_resource_enabled(p)) {
+		dma->channel_count = 0;
+		dev_dbg(&dev->dev, "  encode dma (%s)\n",
+			p ? "disabled" : "missing");
+		return;
+	}
+
 	/* Note: pnp_assign_dma will copy pnp_dma->flags into p->flags */
 	switch (p->flags & IORESOURCE_DMA_SPEED_MASK) {
 	case IORESOURCE_DMA_TYPEA:
@@ -889,17 +910,21 @@ static void pnpacpi_encode_io(struct pnp
 {
 	struct acpi_resource_io *io = &resource->data.io;
 
-	/* Note: pnp_assign_port will copy pnp_port->flags into p->flags */
-	io->io_decode = (p->flags & PNP_PORT_FLAG_16BITADDR) ?
-	    ACPI_DECODE_16 : ACPI_DECODE_10;
-	io->minimum = p->start;
-	io->maximum = p->end;
-	io->alignment = 0;	/* Correct? */
-	io->address_length = p->end - p->start + 1;
-
-	dev_dbg(&dev->dev, "  encode io %#llx-%#llx decode %#x\n",
-		(unsigned long long) p->start, (unsigned long long) p->end,
-		io->io_decode);
+	if (pnp_resource_enabled(p)) {
+		/* Note: pnp_assign_port copies pnp_port->flags into p->flags */
+		io->io_decode = (p->flags & PNP_PORT_FLAG_16BITADDR) ?
+		    ACPI_DECODE_16 : ACPI_DECODE_10;
+		io->minimum = p->start;
+		io->maximum = p->end;
+		io->alignment = 0;	/* Correct? */
+		io->address_length = p->end - p->start + 1;
+	} else {
+		io->minimum = 0;
+		io->address_length = 0;
+	}
+
+	dev_dbg(&dev->dev, "  encode io %#x-%#x decode %#x\n", io->minimum,
+		io->minimum + io->address_length - 1, io->io_decode);
 }
 
 static void pnpacpi_encode_fixed_io(struct pnp_dev *dev,
@@ -908,11 +933,16 @@ static void pnpacpi_encode_fixed_io(stru
 {
 	struct acpi_resource_fixed_io *fixed_io = &resource->data.fixed_io;
 
-	fixed_io->address = p->start;
-	fixed_io->address_length = p->end - p->start + 1;
+	if (pnp_resource_enabled(p)) {
+		fixed_io->address = p->start;
+		fixed_io->address_length = p->end - p->start + 1;
+	} else {
+		fixed_io->address = 0;
+		fixed_io->address_length = 0;
+	}
 
-	dev_dbg(&dev->dev, "  encode fixed_io %#llx-%#llx\n",
-		(unsigned long long) p->start, (unsigned long long) p->end);
+	dev_dbg(&dev->dev, "  encode fixed_io %#x-%#x\n", fixed_io->address,
+		fixed_io->address + fixed_io->address_length - 1);
 }
 
 static void pnpacpi_encode_mem24(struct pnp_dev *dev,
@@ -921,17 +951,22 @@ static void pnpacpi_encode_mem24(struct 
 {
 	struct acpi_resource_memory24 *memory24 = &resource->data.memory24;
 
-	/* Note: pnp_assign_mem will copy pnp_mem->flags into p->flags */
-	memory24->write_protect =
-	    (p->flags & IORESOURCE_MEM_WRITEABLE) ?
-	    ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
-	memory24->minimum = p->start;
-	memory24->maximum = p->end;
-	memory24->alignment = 0;
-	memory24->address_length = p->end - p->start + 1;
+	if (pnp_resource_enabled(p)) {
+		/* Note: pnp_assign_mem copies pnp_mem->flags into p->flags */
+		memory24->write_protect = p->flags & IORESOURCE_MEM_WRITEABLE ?
+		    ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
+		memory24->minimum = p->start;
+		memory24->maximum = p->end;
+		memory24->alignment = 0;
+		memory24->address_length = p->end - p->start + 1;
+	} else {
+		memory24->minimum = 0;
+		memory24->address_length = 0;
+	}
 
-	dev_dbg(&dev->dev, "  encode mem24 %#llx-%#llx write_protect %#x\n",
-		(unsigned long long) p->start, (unsigned long long) p->end,
+	dev_dbg(&dev->dev, "  encode mem24 %#x-%#x write_protect %#x\n",
+		memory24->minimum,
+		memory24->minimum + memory24->address_length - 1,
 		memory24->write_protect);
 }
 
@@ -941,16 +976,21 @@ static void pnpacpi_encode_mem32(struct 
 {
 	struct acpi_resource_memory32 *memory32 = &resource->data.memory32;
 
-	memory32->write_protect =
-	    (p->flags & IORESOURCE_MEM_WRITEABLE) ?
-	    ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
-	memory32->minimum = p->start;
-	memory32->maximum = p->end;
-	memory32->alignment = 0;
-	memory32->address_length = p->end - p->start + 1;
+	if (pnp_resource_enabled(p)) {
+		memory32->write_protect = p->flags & IORESOURCE_MEM_WRITEABLE ?
+		    ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
+		memory32->minimum = p->start;
+		memory32->maximum = p->end;
+		memory32->alignment = 0;
+		memory32->address_length = p->end - p->start + 1;
+	} else {
+		memory32->minimum = 0;
+		memory32->alignment = 0;
+	}
 
-	dev_dbg(&dev->dev, "  encode mem32 %#llx-%#llx write_protect %#x\n",
-		(unsigned long long) p->start, (unsigned long long) p->end,
+	dev_dbg(&dev->dev, "  encode mem32 %#x-%#x write_protect %#x\n",
+		memory32->minimum,
+		memory32->minimum + memory32->address_length - 1,
 		memory32->write_protect);
 }
 
@@ -960,15 +1000,20 @@ static void pnpacpi_encode_fixed_mem32(s
 {
 	struct acpi_resource_fixed_memory32 *fixed_memory32 = &resource->data.fixed_memory32;
 
-	fixed_memory32->write_protect =
-	    (p->flags & IORESOURCE_MEM_WRITEABLE) ?
-	    ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
-	fixed_memory32->address = p->start;
-	fixed_memory32->address_length = p->end - p->start + 1;
-
-	dev_dbg(&dev->dev, "  encode fixed_mem32 %#llx-%#llx "
-		"write_protect %#x\n",
-		(unsigned long long) p->start, (unsigned long long) p->end,
+	if (pnp_resource_enabled(p)) {
+		fixed_memory32->write_protect =
+		    p->flags & IORESOURCE_MEM_WRITEABLE ?
+		    ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
+		fixed_memory32->address = p->start;
+		fixed_memory32->address_length = p->end - p->start + 1;
+	} else {
+		fixed_memory32->address = 0;
+		fixed_memory32->address_length = 0;
+	}
+
+	dev_dbg(&dev->dev, "  encode fixed_mem32 %#x-%#x write_protect %#x\n",
+		fixed_memory32->address,
+		fixed_memory32->address + fixed_memory32->address_length - 1,
 		fixed_memory32->write_protect);
 }
 
Index: work14/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work14.orig/drivers/pnp/pnpbios/rsparser.c	2008-06-17 14:44:52.000000000 -0600
+++ work14/drivers/pnp/pnpbios/rsparser.c	2008-06-24 16:53:06.000000000 -0600
@@ -526,8 +526,16 @@ len_err:
 static void pnpbios_encode_mem(struct pnp_dev *dev, unsigned char *p,
 			       struct resource *res)
 {
-	unsigned long base = res->start;
-	unsigned long len = res->end - res->start + 1;
+	unsigned long base;
+	unsigned long len;
+
+	if (pnp_resource_enabled(res)) {
+		base = res->start;
+		len = res->end - res->start + 1;
+	} else {
+		base = 0;
+		len = 0;
+	}
 
 	p[4] = (base >> 8) & 0xff;
 	p[5] = ((base >> 8) >> 8) & 0xff;
@@ -536,15 +544,22 @@ static void pnpbios_encode_mem(struct pn
 	p[10] = (len >> 8) & 0xff;
 	p[11] = ((len >> 8) >> 8) & 0xff;
 
-	dev_dbg(&dev->dev, "  encode mem %#llx-%#llx\n",
-		(unsigned long long) res->start, (unsigned long long) res->end);
+	dev_dbg(&dev->dev, "  encode mem %#lx-%#lx\n", base, base + len - 1);
 }
 
 static void pnpbios_encode_mem32(struct pnp_dev *dev, unsigned char *p,
 				 struct resource *res)
 {
-	unsigned long base = res->start;
-	unsigned long len = res->end - res->start + 1;
+	unsigned long base;
+	unsigned long len;
+
+	if (pnp_resource_enabled(res)) {
+		base = res->start;
+		len = res->end - res->start + 1;
+	} else {
+		base = 0;
+		len = 0;
+	}
 
 	p[4] = base & 0xff;
 	p[5] = (base >> 8) & 0xff;
@@ -559,15 +574,22 @@ static void pnpbios_encode_mem32(struct 
 	p[18] = (len >> 16) & 0xff;
 	p[19] = (len >> 24) & 0xff;
 
-	dev_dbg(&dev->dev, "  encode mem32 %#llx-%#llx\n",
-		(unsigned long long) res->start, (unsigned long long) res->end);
+	dev_dbg(&dev->dev, "  encode mem32 %#lx-%#lx\n", base, base + len - 1);
 }
 
 static void pnpbios_encode_fixed_mem32(struct pnp_dev *dev, unsigned char *p,
 				       struct resource *res)
 {
-	unsigned long base = res->start;
-	unsigned long len = res->end - res->start + 1;
+	unsigned long base;
+	unsigned long len;
+
+	if (pnp_resource_enabled(res)) {
+		base = res->start;
+		len = res->end - res->start + 1;
+	} else {
+		base = 0;
+		len = 0;
+	}
 
 	p[4] = base & 0xff;
 	p[5] = (base >> 8) & 0xff;
@@ -578,40 +600,54 @@ static void pnpbios_encode_fixed_mem32(s
 	p[10] = (len >> 16) & 0xff;
 	p[11] = (len >> 24) & 0xff;
 
-	dev_dbg(&dev->dev, "  encode fixed_mem32 %#llx-%#llx\n",
-		(unsigned long long) res->start, (unsigned long long) res->end);
+	dev_dbg(&dev->dev, "  encode fixed_mem32 %#lx-%#lx\n", base,
+		base + len - 1);
 }
 
 static void pnpbios_encode_irq(struct pnp_dev *dev, unsigned char *p,
 			       struct resource *res)
 {
-	unsigned long map = 0;
+	unsigned long map;
+
+	if (pnp_resource_enabled(res))
+		map = 1 << res->start;
+	else
+		map = 0;
 
-	map = 1 << res->start;
 	p[1] = map & 0xff;
 	p[2] = (map >> 8) & 0xff;
 
-	dev_dbg(&dev->dev, "  encode irq %llu\n",
-		(unsigned long long)res->start);
+	dev_dbg(&dev->dev, "  encode irq mask %#lx\n", map);
 }
 
 static void pnpbios_encode_dma(struct pnp_dev *dev, unsigned char *p,
 			       struct resource *res)
 {
-	unsigned long map = 0;
+	unsigned long map;
+
+	if (pnp_resource_enabled(res))
+		map = 1 << res->start;
+	else
+		map = 0;
 
-	map = 1 << res->start;
 	p[1] = map & 0xff;
 
-	dev_dbg(&dev->dev, "  encode dma %llu\n",
-		(unsigned long long)res->start);
+	dev_dbg(&dev->dev, "  encode dma mask %#lx\n", map);
 }
 
 static void pnpbios_encode_port(struct pnp_dev *dev, unsigned char *p,
 				struct resource *res)
 {
-	unsigned long base = res->start;
-	unsigned long len = res->end - res->start + 1;
+	unsigned long base;
+	unsigned long len;
+
+	if (pnp_resource_enabled(res)) {
+		base = res->start;
+		len = res->end - res->start + 1;
+	} else {
+		base = 0;
+		len = 0;
+	}
 
 	p[2] = base & 0xff;
 	p[3] = (base >> 8) & 0xff;
@@ -619,8 +655,7 @@ static void pnpbios_encode_port(struct p
 	p[5] = (base >> 8) & 0xff;
 	p[7] = len & 0xff;
 
-	dev_dbg(&dev->dev, "  encode io %#llx-%#llx\n",
-		(unsigned long long) res->start, (unsigned long long) res->end);
+	dev_dbg(&dev->dev, "  encode io %#lx-%#lx\n", base, base + len - 1);
 }
 
 static void pnpbios_encode_fixed_port(struct pnp_dev *dev, unsigned char *p,
@@ -629,12 +664,20 @@ static void pnpbios_encode_fixed_port(st
 	unsigned long base = res->start;
 	unsigned long len = res->end - res->start + 1;
 
+	if (pnp_resource_enabled(res)) {
+		base = res->start;
+		len = res->end - res->start + 1;
+	} else {
+		base = 0;
+		len = 0;
+	}
+
 	p[1] = base & 0xff;
 	p[2] = (base >> 8) & 0xff;
 	p[3] = len & 0xff;
 
-	dev_dbg(&dev->dev, "  encode fixed_io %#llx-%#llx\n",
-		(unsigned long long) res->start, (unsigned long long) res->end);
+	dev_dbg(&dev->dev, "  encode fixed_io %#lx-%#lx\n", base,
+		base + len - 1);
 }
 
 static unsigned char *pnpbios_encode_allocated_resource_data(struct pnp_dev
Index: work14/drivers/pnp/quirks.c
===================================================================
--- work14.orig/drivers/pnp/quirks.c	2008-06-17 14:45:32.000000000 -0600
+++ work14/drivers/pnp/quirks.c	2008-06-24 16:53:05.000000000 -0600
@@ -248,8 +248,7 @@ static void quirk_system_pci_resources(s
 			for (j = 0;
 			     (res = pnp_get_resource(dev, IORESOURCE_MEM, j));
 			     j++) {
-				if (res->flags & IORESOURCE_UNSET ||
-				    (res->start == 0 && res->end == 0))
+				if (res->start == 0 && res->end == 0)
 					continue;
 
 				pnp_start = res->start;
Index: work14/drivers/pnp/resource.c
===================================================================
--- work14.orig/drivers/pnp/resource.c	2008-06-17 14:45:32.000000000 -0600
+++ work14/drivers/pnp/resource.c	2008-06-24 16:53:06.000000000 -0600
@@ -237,7 +237,7 @@ void pnp_free_option(struct pnp_option *
 	!((*(enda) < *(startb)) || (*(endb) < *(starta)))
 
 #define cannot_compare(flags) \
-((flags) & (IORESOURCE_UNSET | IORESOURCE_DISABLED))
+((flags) & IORESOURCE_DISABLED)
 
 int pnp_check_port(struct pnp_dev *dev, struct resource *res)
 {
@@ -505,81 +505,31 @@ int pnp_resource_type(struct resource *r
 			     IORESOURCE_IRQ | IORESOURCE_DMA);
 }
 
-struct pnp_resource *pnp_get_pnp_resource(struct pnp_dev *dev,
-					  unsigned int type, unsigned int num)
-{
-	struct pnp_resource_table *res = dev->res;
-
-	switch (type) {
-	case IORESOURCE_IO:
-		if (num >= PNP_MAX_PORT)
-			return NULL;
-		return &res->port[num];
-	case IORESOURCE_MEM:
-		if (num >= PNP_MAX_MEM)
-			return NULL;
-		return &res->mem[num];
-	case IORESOURCE_IRQ:
-		if (num >= PNP_MAX_IRQ)
-			return NULL;
-		return &res->irq[num];
-	case IORESOURCE_DMA:
-		if (num >= PNP_MAX_DMA)
-			return NULL;
-		return &res->dma[num];
-	}
-	return NULL;
-}
-
 struct resource *pnp_get_resource(struct pnp_dev *dev,
 				  unsigned int type, unsigned int num)
 {
 	struct pnp_resource *pnp_res;
+	struct resource *res;
 
-	pnp_res = pnp_get_pnp_resource(dev, type, num);
-	if (pnp_res)
-		return &pnp_res->res;
-
+	list_for_each_entry(pnp_res, &dev->resources, list) {
+		res = &pnp_res->res;
+		if (pnp_resource_type(res) == type && num-- == 0)
+			return res;
+	}
 	return NULL;
 }
 EXPORT_SYMBOL(pnp_get_resource);
 
-static struct pnp_resource *pnp_new_resource(struct pnp_dev *dev, int type)
+static struct pnp_resource *pnp_new_resource(struct pnp_dev *dev)
 {
 	struct pnp_resource *pnp_res;
-	int i;
 
-	switch (type) {
-	case IORESOURCE_IO:
-		for (i = 0; i < PNP_MAX_PORT; i++) {
-			pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IO, i);
-			if (pnp_res && !pnp_resource_valid(&pnp_res->res))
-				return pnp_res;
-		}
-		break;
-	case IORESOURCE_MEM:
-		for (i = 0; i < PNP_MAX_MEM; i++) {
-			pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_MEM, i);
-			if (pnp_res && !pnp_resource_valid(&pnp_res->res))
-				return pnp_res;
-		}
-		break;
-	case IORESOURCE_IRQ:
-		for (i = 0; i < PNP_MAX_IRQ; i++) {
-			pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_IRQ, i);
-			if (pnp_res && !pnp_resource_valid(&pnp_res->res))
-				return pnp_res;
-		}
-		break;
-	case IORESOURCE_DMA:
-		for (i = 0; i < PNP_MAX_DMA; i++) {
-			pnp_res = pnp_get_pnp_resource(dev, IORESOURCE_DMA, i);
-			if (pnp_res && !pnp_resource_valid(&pnp_res->res))
-				return pnp_res;
-		}
-		break;
-	}
-	return NULL;
+	pnp_res = kzalloc(sizeof(struct pnp_resource), GFP_KERNEL);
+	if (!pnp_res)
+		return NULL;
+
+	list_add_tail(&pnp_res->list, &dev->resources);
+	return pnp_res;
 }
 
 struct pnp_resource *pnp_add_irq_resource(struct pnp_dev *dev, int irq,
@@ -589,7 +539,7 @@ struct pnp_resource *pnp_add_irq_resourc
 	struct resource *res;
 	static unsigned char warned;
 
-	pnp_res = pnp_new_resource(dev, IORESOURCE_IRQ);
+	pnp_res = pnp_new_resource(dev);
 	if (!pnp_res) {
 		if (!warned) {
 			dev_err(&dev->dev, "can't add resource for IRQ %d\n",
@@ -615,7 +565,7 @@ struct pnp_resource *pnp_add_dma_resourc
 	struct resource *res;
 	static unsigned char warned;
 
-	pnp_res = pnp_new_resource(dev, IORESOURCE_DMA);
+	pnp_res = pnp_new_resource(dev);
 	if (!pnp_res) {
 		if (!warned) {
 			dev_err(&dev->dev, "can't add resource for DMA %d\n",
@@ -642,7 +592,7 @@ struct pnp_resource *pnp_add_io_resource
 	struct resource *res;
 	static unsigned char warned;
 
-	pnp_res = pnp_new_resource(dev, IORESOURCE_IO);
+	pnp_res = pnp_new_resource(dev);
 	if (!pnp_res) {
 		if (!warned) {
 			dev_err(&dev->dev, "can't add resource for IO "
@@ -671,7 +621,7 @@ struct pnp_resource *pnp_add_mem_resourc
 	struct resource *res;
 	static unsigned char warned;
 
-	pnp_res = pnp_new_resource(dev, IORESOURCE_MEM);
+	pnp_res = pnp_new_resource(dev);
 	if (!pnp_res) {
 		if (!warned) {
 			dev_err(&dev->dev, "can't add resource for MEM "
Index: work14/drivers/pnp/support.c
===================================================================
--- work14.orig/drivers/pnp/support.c	2008-06-17 14:45:32.000000000 -0600
+++ work14/drivers/pnp/support.c	2008-06-24 16:58:34.000000000 -0600
@@ -16,6 +16,10 @@
  */
 int pnp_is_active(struct pnp_dev *dev)
 {
+	/*
+	 * I don't think this is very reliable because pnp_disable_dev()
+	 * only clears out auto-assigned resources.
+	 */
 	if (!pnp_port_start(dev, 0) && pnp_port_len(dev, 0) <= 1 &&
 	    !pnp_mem_start(dev, 0) && pnp_mem_len(dev, 0) <= 1 &&
 	    pnp_irq(dev, 0) == -1 && pnp_dma(dev, 0) == -1)
@@ -70,54 +74,41 @@ char *pnp_resource_type_name(struct reso
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
 {
 #ifdef DEBUG
+	char buf[128];
+	int len = 0;
+	struct pnp_resource *pnp_res;
 	struct resource *res;
-	int i;
 
 	dev_dbg(&dev->dev, "current resources: %s\n", desc);
+	list_for_each_entry(pnp_res, &dev->resources, list) {
+		res = &pnp_res->res;
 
-	for (i = 0; i < PNP_MAX_IRQ; i++) {
-		res = pnp_get_resource(dev, IORESOURCE_IRQ, i);
-		if (res && !(res->flags & IORESOURCE_UNSET))
-			dev_dbg(&dev->dev, "  irq %lld flags %#lx%s%s\n",
-				(unsigned long long) res->start, res->flags,
-				res->flags & IORESOURCE_DISABLED ?
-					" DISABLED" : "",
-				res->flags & IORESOURCE_AUTO ?
-					" AUTO" : "");
-	}
-	for (i = 0; i < PNP_MAX_DMA; i++) {
-		res = pnp_get_resource(dev, IORESOURCE_DMA, i);
-		if (res && !(res->flags & IORESOURCE_UNSET))
-			dev_dbg(&dev->dev, "  dma %lld flags %#lx%s%s\n",
-				(unsigned long long) res->start, res->flags,
-				res->flags & IORESOURCE_DISABLED ?
-					" DISABLED" : "",
-				res->flags & IORESOURCE_AUTO ?
-					" AUTO" : "");
-	}
-	for (i = 0; i < PNP_MAX_PORT; i++) {
-		res = pnp_get_resource(dev, IORESOURCE_IO, i);
-		if (res && !(res->flags & IORESOURCE_UNSET))
-			dev_dbg(&dev->dev, "  io  %#llx-%#llx flags %#lx"
-				"%s%s\n",
-				(unsigned long long) res->start,
-				(unsigned long long) res->end, res->flags,
-				res->flags & IORESOURCE_DISABLED ?
-					" DISABLED" : "",
-				res->flags & IORESOURCE_AUTO ?
-					" AUTO" : "");
-	}
-	for (i = 0; i < PNP_MAX_MEM; i++) {
-		res = pnp_get_resource(dev, IORESOURCE_MEM, i);
-		if (res && !(res->flags & IORESOURCE_UNSET))
-			dev_dbg(&dev->dev, "  mem %#llx-%#llx flags %#lx"
-				"%s%s\n",
-				(unsigned long long) res->start,
-				(unsigned long long) res->end, res->flags,
-				res->flags & IORESOURCE_DISABLED ?
-					" DISABLED" : "",
-				res->flags & IORESOURCE_AUTO ?
-					" AUTO" : "");
+		len += snprintf(buf + len, sizeof(buf) - len, "  %-3s ",
+				pnp_resource_type_name(res));
+
+		if (res->flags & IORESOURCE_DISABLED) {
+			dev_dbg(&dev->dev, "%sdisabled\n", buf);
+			continue;
+		}
+
+		switch (pnp_resource_type(res)) {
+		case IORESOURCE_IO:
+		case IORESOURCE_MEM:
+			len += snprintf(buf + len, sizeof(buf) - len,
+					"%#llx-%#llx flags %#lx",
+					(unsigned long long) res->start,
+					(unsigned long long) res->end,
+					res->flags);
+			break;
+		case IORESOURCE_IRQ:
+		case IORESOURCE_DMA:
+			len += snprintf(buf + len, sizeof(buf) - len,
+					"%lld flags %#lx",
+					(unsigned long long) res->start,
+					res->flags);
+			break;
+		}
+		dev_dbg(&dev->dev, "%s\n", buf);
 	}
 #endif
 }
Index: work14/drivers/pnp/system.c
===================================================================
--- work14.orig/drivers/pnp/system.c	2008-06-17 14:45:32.000000000 -0600
+++ work14/drivers/pnp/system.c	2008-06-17 14:45:35.000000000 -0600
@@ -60,7 +60,7 @@ static void reserve_resources_of_dev(str
 	int i;
 
 	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IO, i)); i++) {
-		if (res->flags & IORESOURCE_UNSET)
+		if (res->flags & IORESOURCE_DISABLED)
 			continue;
 		if (res->start == 0)
 			continue;	/* disabled */
@@ -81,7 +81,7 @@ static void reserve_resources_of_dev(str
 	}
 
 	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
-		if (res->flags & (IORESOURCE_UNSET | IORESOURCE_DISABLED))
+		if (res->flags & IORESOURCE_DISABLED)
 			continue;
 
 		reserve_range(dev, res->start, res->end, 0);
Index: work14/include/linux/pnp.h
===================================================================
--- work14.orig/include/linux/pnp.h	2008-06-17 14:45:32.000000000 -0600
+++ work14/include/linux/pnp.h	2008-06-24 16:53:06.000000000 -0600
@@ -15,7 +15,6 @@
 
 struct pnp_protocol;
 struct pnp_dev;
-struct pnp_resource_table;
 
 /*
  * Resource Management
@@ -24,7 +23,14 @@ struct resource *pnp_get_resource(struct
 
 static inline int pnp_resource_valid(struct resource *res)
 {
-	if (res && !(res->flags & IORESOURCE_UNSET))
+	if (res)
+		return 1;
+	return 0;
+}
+
+static inline int pnp_resource_enabled(struct resource *res)
+{
+	if (res && !(res->flags & IORESOURCE_DISABLED))
 		return 1;
 	return 0;
 }
@@ -64,7 +70,7 @@ static inline unsigned long pnp_port_fla
 
 	if (pnp_resource_valid(res))
 		return res->flags;
-	return IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
+	return IORESOURCE_IO | IORESOURCE_AUTO;
 }
 
 static inline int pnp_port_valid(struct pnp_dev *dev, unsigned int bar)
@@ -109,7 +115,7 @@ static inline unsigned long pnp_mem_flag
 
 	if (pnp_resource_valid(res))
 		return res->flags;
-	return IORESOURCE_MEM | IORESOURCE_AUTO | IORESOURCE_UNSET;
+	return IORESOURCE_MEM | IORESOURCE_AUTO;
 }
 
 static inline int pnp_mem_valid(struct pnp_dev *dev, unsigned int bar)
@@ -143,7 +149,7 @@ static inline unsigned long pnp_irq_flag
 
 	if (pnp_resource_valid(res))
 		return res->flags;
-	return IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
+	return IORESOURCE_IRQ | IORESOURCE_AUTO;
 }
 
 static inline int pnp_irq_valid(struct pnp_dev *dev, unsigned int bar)
@@ -167,7 +173,7 @@ static inline unsigned long pnp_dma_flag
 
 	if (pnp_resource_valid(res))
 		return res->flags;
-	return IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
+	return IORESOURCE_DMA | IORESOURCE_AUTO;
 }
 
 static inline int pnp_dma_valid(struct pnp_dev *dev, unsigned int bar)
@@ -296,7 +302,7 @@ struct pnp_dev {
 	int capabilities;
 	struct pnp_option *independent;
 	struct pnp_option *dependent;
-	struct pnp_resource_table *res;
+	struct list_head resources;
 
 	char name[PNP_NAME_LEN];	/* contains a human-readable name */
 	int flags;			/* used by protocols */

-- 
