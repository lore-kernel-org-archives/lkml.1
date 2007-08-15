Return-Path: <linux-kernel-owner+w=401wt.eu-S1761588AbXHOODn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761588AbXHOODn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbXHOODb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:03:31 -0400
Received: from ns1.suse.de ([195.135.220.2]:38396 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513AbXHOOD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:03:29 -0400
Subject: [PATCH] (for review and testing first) Implement dynamic allocated
	array for pnp port/io resources
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Jean Delvare <khali@linux-fr.org>,
       abelay@novell.com, Andi Kleen <ak@suse.de>,
       linux-acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Wed, 15 Aug 2007 16:03:24 +0200
Message-Id: <1187186605.8780.669.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is not a real feature, more a fix.
Without, PNP IO ports might not get considered. This mainly affects ACPI
system board devices with HID PNP0C02 (at least I saw this on my and
some other machines, but it may affect more...).

I expect this got introduced when resources were not handled by the acpi
motherboard driver anymore, but by pnpacpi, should be this one:
a8c78f7fb1571764f48b8af5459abdd2c66a765f
PNP: reserve system board iomem resources as well as ioport resources
Follows: v2.6.20-rc1
Precedes: v2.6.21-rc1
(The follows/precedes stuff, I got from gitk, is there a way to get this
with console git tools?) and this means the patch got introduced in
2.6.20 main kernel?

I expect this is a bit late for 2.6.23?
If this should not go in there, I'd also like to let irq, dma and mem
resources be dynamically allocated if the design of this patch is ok.
It would be great if Andrew can pick it up then.

To be honest I am not sure what the consequences are of not registered
ioport resources for system board or other devices. I expect the risk of
several drivers making use of the same ioports simultaneously is higher,
possibly the devices are not working correctly if the correct ports are
not passed to the driver via pnp?

We have several options here for 2.6.23:
  - leave it as it is
  - increase the statically allocated IO ports to 16/32 (my machine has
    more than 20 ioports for the system board device). This would waste
    some memory -> Andi already complained that the waste is too much
  - add this one -> Not sure how risky this is, in the end it's not so
    much complicated code... still there is risk ...
  - Add Bjorn's "Increase statically used IRQ ports from 2 to 4" should
    be added anyway IMO. This one is really safe, it's here;
    http://lkml.org/lkml/2007/7/17/335

Some parts where a reviewer should have a closer eye on:
  - the border limits (got a '>' mixed up with a '>=' or similar)
  - I removed or better let pnp_init_resource_table invoke
    pnp_clean_resource_table as the only difference between those was 
    the additional NULL assignment to the name. Can this really be
    removed or was this in any way useful :)
  - locking: Andi made me a bit nervous about locking. As I didn't
    modify much in the design/structure of how it currently is done,
    I don't expect simultaneous access to the port resource data
    can happen and additional locking should not be needed,
    but I am not sure about it.
  - Only field tested with pnpacpi

I saw recent Lindentation patches for pnp. I expect they came in after
-rc2?
This one is against 2.6.23-rc2 and might not patch with latest git
repository changes then.

Thanks,

   Thomas

------------------------

Implement dynamic allocated array for pnp port/io resources

PNPACPI devices can use more than 8 port resources.
Statically increasing the ports of each device is not a real option due to too
much memory waste (at least 32 are needed here and some machines might
still have more).

This patch lets the port resources in the resource table of each pnp device
get allocated dynamically.
If a device has no ports, no memory is wasted.
If a device has one io port declaration or more, 8 struct resources are
allocated. If this should still not be enough 8 struct portions are realloced
as needed.

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/pnp/interface.c        |   44 +++++++++---
 drivers/pnp/manager.c          |  140 ++++++++++++++++++++++++-----------------
 drivers/pnp/pnpacpi/rsparser.c |   40 ++++++++---
 drivers/pnp/pnpbios/rsparser.c |   29 ++++++--
 drivers/pnp/quirks.c           |   21 ++++--
 drivers/pnp/resource.c         |   24 +++----
 drivers/pnp/system.c           |    2 
 include/linux/pnp.h            |   20 ++++-
 8 files changed, 211 insertions(+), 109 deletions(-)

Index: linux-2.6.23-rc2/drivers/pnp/manager.c
===================================================================
--- linux-2.6.23-rc2.orig/drivers/pnp/manager.c
+++ linux-2.6.23-rc2/drivers/pnp/manager.c
@@ -14,30 +14,96 @@
 #include <linux/bitmap.h>
 #include "base.h"
 
+/* Defines the amount of struct resources that will get (re-)alloced
+ * if the resource table runs out of allocated ports
+*/
+#define PNP_ALLOC_PORTS		8
+
 DECLARE_MUTEX(pnp_res_mutex);
 
+
+
+static void pnp_init_port (struct pnp_resource_table *res, int idx)
+{
+	if (idx < res->allocated_ports) {
+		(res->port_resource + idx)->start = 0;
+		(res->port_resource + idx)->end = 0;
+		(res->port_resource + idx)->flags =
+			IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
+	}
+}
+
+int pnp_port_alloc (struct pnp_resource_table *res)
+{
+	int ret = 0, i;
+	if (res->allocated_ports == 0) {
+		res->port_resource = kmalloc(sizeof(struct resource)
+						  * PNP_ALLOC_PORTS,
+						  GFP_KERNEL);
+		if (!res->port_resource) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	} else {
+		res->port_resource = krealloc(res->port_resource,
+					    (sizeof(struct resource)
+					     * res->allocated_ports)
+					    +
+					    (sizeof(struct resource)
+					     * PNP_ALLOC_PORTS),
+					    GFP_KERNEL);
+		if (!res->port_resource){
+			ret = -ENOMEM;
+			goto out;
+		}
+		pnp_dbg ("New ports reallocated, we now have: %d",
+			 res->allocated_ports + PNP_ALLOC_PORTS);
+	}
+
+	res->allocated_ports += PNP_ALLOC_PORTS;
+
+	for (i = res->allocated_ports - PNP_ALLOC_PORTS;
+	     i < res->allocated_ports; i++)
+		pnp_init_port (res, i);
+
+
+
+ out:
+	pnp_dbg ("%s: Allocated ports: %s\n", __FUNCTION__,
+		ret ? "FAILED" : "SUCCESS");
+	return ret;
+}
+
 static int pnp_assign_port(struct pnp_dev *dev, struct pnp_port *rule, int idx)
 {
 	resource_size_t *start, *end;
 	unsigned long *flags;
+	int ret;
 
 	if (!dev || !rule)
 		return -EINVAL;
 
-	if (idx >= PNP_MAX_PORT) {
-		pnp_err
-		    ("More than 4 ports is incompatible with pnp specifications.");
-		/* pretend we were successful so at least the manager won't try again */
-		return 1;
+	if (!pnp_port_res_pointer(dev, idx)) {
+		pnp_dbg ("%s: Try to allocate ports\n", __FUNCTION__);
+		ret = pnp_port_alloc(&dev->res);
+		if (ret) {
+			pnp_err ("%s: Cannot allocate port", __FUNCTION__);
+			/* pretend we were successful so at least the manager won't try again */
+			return 1;
+		}
+		if (idx >= dev->res.allocated_ports) {
+			pnp_err ("Bug in %s", __FUNCTION__);
+			return 1;
+		}
 	}
 
 	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.port_resource[idx].flags & IORESOURCE_AUTO))
+	if (!(pnp_port_flags(dev,idx) & IORESOURCE_AUTO))
 		return 1;
 
-	start = &dev->res.port_resource[idx].start;
-	end = &dev->res.port_resource[idx].end;
-	flags = &dev->res.port_resource[idx].flags;
+	start = &pnp_port_start(dev,idx);
+	end = &pnp_port_end(dev,idx);
+	flags = &pnp_port_flags(dev,idx);
 
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_IO;
@@ -219,44 +285,6 @@ static int pnp_assign_dma(struct pnp_dev
 }
 
 /**
- * pnp_init_resources - Resets a resource table to default values.
- * @table: pointer to the desired resource table
- */
-void pnp_init_resource_table(struct pnp_resource_table *table)
-{
-	int idx;
-
-	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
-		table->irq_resource[idx].name = NULL;
-		table->irq_resource[idx].start = -1;
-		table->irq_resource[idx].end = -1;
-		table->irq_resource[idx].flags =
-		    IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
-	}
-	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
-		table->dma_resource[idx].name = NULL;
-		table->dma_resource[idx].start = -1;
-		table->dma_resource[idx].end = -1;
-		table->dma_resource[idx].flags =
-		    IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
-	}
-	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
-		table->port_resource[idx].name = NULL;
-		table->port_resource[idx].start = 0;
-		table->port_resource[idx].end = 0;
-		table->port_resource[idx].flags =
-		    IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
-	}
-	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
-		table->mem_resource[idx].name = NULL;
-		table->mem_resource[idx].start = 0;
-		table->mem_resource[idx].end = 0;
-		table->mem_resource[idx].flags =
-		    IORESOURCE_MEM | IORESOURCE_AUTO | IORESOURCE_UNSET;
-	}
-}
-
-/**
  * pnp_clean_resources - clears resources that were not manually set
  * @res: the resources to clean
  */
@@ -280,14 +308,9 @@ static void pnp_clean_resource_table(str
 		res->dma_resource[idx].flags =
 		    IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
 	}
-	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
-		if (!(res->port_resource[idx].flags & IORESOURCE_AUTO))
-			continue;
-		res->port_resource[idx].start = 0;
-		res->port_resource[idx].end = 0;
-		res->port_resource[idx].flags =
-		    IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
-	}
+	kfree(res->port_resource);
+	res->allocated_ports = 0;
+
 	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
 		if (!(res->mem_resource[idx].flags & IORESOURCE_AUTO))
 			continue;
@@ -298,6 +321,11 @@ static void pnp_clean_resource_table(str
 	}
 }
 
+void pnp_init_resource_table(struct pnp_resource_table *table)
+{
+	pnp_clean_resource_table(table);
+}
+
 /**
  * pnp_assign_resources - assigns resources to the device based on the specified dependent number
  * @dev: pointer to the desired device
@@ -422,7 +450,7 @@ int pnp_manual_config_dev(struct pnp_dev
 	down(&pnp_res_mutex);
 	dev->res = *res;
 	if (!(mode & PNP_CONFIG_FORCE)) {
-		for (i = 0; i < PNP_MAX_PORT; i++) {
+		for (i = 0; pnp_port_res_pointer(dev,i); i++) {
 			if (!pnp_check_port(dev, i))
 				goto fail;
 		}
Index: linux-2.6.23-rc2/include/linux/pnp.h
===================================================================
--- linux-2.6.23-rc2.orig/include/linux/pnp.h
+++ linux-2.6.23-rc2/include/linux/pnp.h
@@ -13,7 +13,6 @@
 #include <linux/errno.h>
 #include <linux/mod_devicetable.h>
 
-#define PNP_MAX_PORT		8
 #define PNP_MAX_MEM		4
 #define PNP_MAX_IRQ		2
 #define PNP_MAX_DMA		2
@@ -27,12 +26,16 @@ struct pnp_dev;
  */
 
 /* Use these instead of directly reading pnp_dev to get resource information */
-#define pnp_port_start(dev,bar)   ((dev)->res.port_resource[(bar)].start)
-#define pnp_port_end(dev,bar)     ((dev)->res.port_resource[(bar)].end)
-#define pnp_port_flags(dev,bar)   ((dev)->res.port_resource[(bar)].flags)
+#define pnp_port_res_pointer(dev,bar)	((dev->res.allocated_ports > bar) \
+	? (dev->res.port_resource + bar) : NULL)
+#define pnp_port_start(dev,bar)		((dev->res.port_resource + bar)->start)
+#define pnp_port_end(dev,bar)		((dev->res.port_resource + bar)->end)
+#define pnp_port_flags(dev,bar)		((dev->res.port_resource + bar)->flags)
 #define pnp_port_valid(dev,bar) \
+	(pnp_port_res_pointer((dev),(bar)) ? \
 	((pnp_port_flags((dev),(bar)) & (IORESOURCE_IO | IORESOURCE_UNSET)) \
-		== IORESOURCE_IO)
+		== IORESOURCE_IO) : \
+	(0))
 #define pnp_port_len(dev,bar) \
 	((pnp_port_start((dev),(bar)) == 0 &&	\
 	  pnp_port_end((dev),(bar)) ==		\
@@ -119,7 +122,8 @@ struct pnp_option {
 };
 
 struct pnp_resource_table {
-	struct resource port_resource[PNP_MAX_PORT];
+	struct resource *port_resource;
+	int allocated_ports;
 	struct resource mem_resource[PNP_MAX_MEM];
 	struct resource dma_resource[PNP_MAX_DMA];
 	struct resource irq_resource[PNP_MAX_IRQ];
@@ -387,6 +391,7 @@ int pnp_register_dma_resource(struct pnp
 int pnp_register_port_resource(struct pnp_option *option,
 			       struct pnp_port *data);
 int pnp_register_mem_resource(struct pnp_option *option, struct pnp_mem *data);
+int pnp_port_alloc(struct pnp_resource_table *res_table);
 void pnp_init_resource_table(struct pnp_resource_table *table);
 int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res,
 			  int mode);
@@ -437,6 +442,7 @@ static inline int pnp_register_dma_resou
 static inline int pnp_register_port_resource(struct pnp_option *option, struct pnp_port *data) { return -ENODEV; }
 static inline int pnp_register_mem_resource(struct pnp_option *option, struct pnp_mem *data) { return -ENODEV; }
 static inline void pnp_init_resource_table(struct pnp_resource_table *table) { }
+static inline pnp_port_alloc(struct pnp_resource_table *res_table) { return -ENODEV }
 static inline int pnp_manual_config_dev(struct pnp_dev *dev, struct pnp_resource_table *res, int mode) { return -ENODEV; }
 static inline int pnp_auto_config_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_validate_config(struct pnp_dev *dev) { return -ENODEV; }
@@ -460,8 +466,10 @@ static inline void pnp_unregister_driver
 #define pnp_warn(format, arg...) printk(KERN_WARNING "pnp: " format "\n" , ## arg)
 
 #ifdef CONFIG_PNP_DEBUG
+extern void pnp_dump_ports (struct pnp_dev *dev);
 #define pnp_dbg(format, arg...) printk(KERN_DEBUG "pnp: " format "\n" , ## arg)
 #else
+static inline void pnp_dump_ports (struct pnp_dev *dev) { }
 #define pnp_dbg(format, arg...) do {} while (0)
 #endif
 
Index: linux-2.6.23-rc2/drivers/pnp/interface.c
===================================================================
--- linux-2.6.23-rc2.orig/drivers/pnp/interface.c
+++ linux-2.6.23-rc2/drivers/pnp/interface.c
@@ -28,6 +28,21 @@ struct pnp_info_buffer {
 
 typedef struct pnp_info_buffer pnp_info_buffer_t;
 
+#ifdef CONFIG_PNP_DEBUG
+void pnp_dump_ports (struct pnp_dev *dev) {
+
+	int i;
+	pnp_dbg ("Resource table dump:");
+	pnp_dbg ("Alloctad ports: %d", dev->res.allocated_ports);
+
+	for (i = 0; pnp_port_res_pointer(dev,i); i++) {
+		pnp_dbg ("Port %d: start: 0x%llx - end: 0x%llx - flags: %lu",
+			 i, pnp_port_start(dev,i), pnp_port_end(dev,i),
+			 pnp_port_flags(dev,i));
+	}
+}
+#endif
+
 static int pnp_printf(pnp_info_buffer_t * buffer, char *fmt, ...)
 {
 	va_list args;
@@ -264,7 +279,7 @@ static ssize_t pnp_show_current_resource
 	else
 		pnp_printf(buffer, "disabled\n");
 
-	for (i = 0; i < PNP_MAX_PORT; i++) {
+	for (i = 0; pnp_port_res_pointer(dev,i); i++) {
 		if (pnp_port_valid(dev, i)) {
 			pnp_printf(buffer, "io");
 			if (pnp_port_flags(dev, i) & IORESOURCE_DISABLED)
@@ -273,8 +288,8 @@ static ssize_t pnp_show_current_resource
 				pnp_printf(buffer, " 0x%llx-0x%llx\n",
 					   (unsigned long long)
 					   pnp_port_start(dev, i),
-					   (unsigned long long)pnp_port_end(dev,
-									    i));
+					   (unsigned long long)
+					   pnp_port_end(dev, i));
 		}
 	}
 	for (i = 0; i < PNP_MAX_MEM; i++) {
@@ -382,7 +397,17 @@ pnp_set_current_resources(struct device 
 				buf += 2;
 				while (isspace(*buf))
 					++buf;
-				dev->res.port_resource[nport].start =
+				/* Allocate new ports if necessary */
+				if (!pnp_port_res_pointer(dev, nport)) {
+					retval = pnp_port_alloc(&dev->res);
+					if (retval) {
+						pnp_err ("%s: Cannot allocate"
+							 " port", __FUNCTION__);
+						break;
+					}
+				}
+
+				pnp_port_start(dev,nport) =
 				    simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
@@ -390,15 +415,14 @@ pnp_set_current_resources(struct device 
 					buf += 1;
 					while (isspace(*buf))
 						++buf;
-					dev->res.port_resource[nport].end =
+					pnp_port_end(dev,nport) =
 					    simple_strtoul(buf, &buf, 0);
 				} else
-					dev->res.port_resource[nport].end =
-					    dev->res.port_resource[nport].start;
-				dev->res.port_resource[nport].flags =
-				    IORESOURCE_IO;
+					pnp_port_end(dev,nport) =
+						pnp_port_start(dev,nport);
+				pnp_port_flags(dev,nport) = IORESOURCE_IO;
 				nport++;
-				if (nport >= PNP_MAX_PORT)
+				if (!pnp_port_res_pointer(dev,nport))
 					break;
 				continue;
 			}
Index: linux-2.6.23-rc2/drivers/pnp/quirks.c
===================================================================
--- linux-2.6.23-rc2.orig/drivers/pnp/quirks.c
+++ linux-2.6.23-rc2/drivers/pnp/quirks.c
@@ -139,9 +139,16 @@ static void quirk_smc_enable(struct pnp_
 	struct resource fir, sir, irq;
 
 	pnp_activate_dev(dev);
+
 	if (quirk_smc_fir_enabled(dev))
 		return;
 
+	if (dev->res.allocated_ports <= 1) {
+		if (pnp_port_alloc(&dev->res)) {
+			pnp_err("Cannot allocate ports");
+			return;
+		}
+	}
 	/*
 	 * Sometimes the BIOS claims the device is enabled, but it reports
 	 * the wrong FIR resources or doesn't properly configure ISA or LPC
@@ -156,10 +163,14 @@ static void quirk_smc_enable(struct pnp_
 		(unsigned long)pnp_port_start(dev, 0),
 		(unsigned long)pnp_port_start(dev, 1));
 
+	/*
+	 * disable_dev calls pnp_clean_resource_table no need to call
+	 * pnp_init_resource_table which effectively does the same
+	*/
 	pnp_disable_dev(dev);
-	pnp_init_resource_table(&dev->res);
 	pnp_auto_config_dev(dev);
 	pnp_activate_dev(dev);
+
 	if (quirk_smc_fir_enabled(dev)) {
 		dev_err(&dev->dev, "responds at SIR 0x%lx, FIR 0x%lx\n",
 			(unsigned long)pnp_port_start(dev, 0),
@@ -182,8 +193,8 @@ static void quirk_smc_enable(struct pnp_
 	 * Clear IORESOURCE_AUTO so pnp_activate_dev() doesn't reassign
 	 * these resources any more.
 	 */
-	fir = dev->res.port_resource[0];
-	sir = dev->res.port_resource[1];
+	fir = *pnp_port_res_pointer(dev,0);
+	sir = *pnp_port_res_pointer(dev,1);
 	fir.flags &= ~IORESOURCE_AUTO;
 	sir.flags &= ~IORESOURCE_AUTO;
 
@@ -193,8 +204,8 @@ static void quirk_smc_enable(struct pnp_
 	irq.flags |= IORESOURCE_IRQ_LOWEDGE;
 
 	pnp_disable_dev(dev);
-	dev->res.port_resource[0] = sir;
-	dev->res.port_resource[1] = fir;
+	*pnp_port_res_pointer(dev,0) = sir;
+	*pnp_port_res_pointer(dev,1) = fir;
 	dev->res.irq_resource[0] = irq;
 	pnp_activate_dev(dev);
 
Index: linux-2.6.23-rc2/drivers/pnp/system.c
===================================================================
--- linux-2.6.23-rc2.orig/drivers/pnp/system.c
+++ linux-2.6.23-rc2/drivers/pnp/system.c
@@ -55,7 +55,7 @@ static void reserve_resources_of_dev(con
 {
 	int i;
 
-	for (i = 0; i < PNP_MAX_PORT; i++) {
+	for (i = 0; pnp_port_res_pointer(dev,i); i++) {
 		if (!pnp_port_valid(dev, i))
 			continue;
 		if (pnp_port_start(dev, i) == 0)
Index: linux-2.6.23-rc2/drivers/pnp/resource.c
===================================================================
--- linux-2.6.23-rc2.orig/drivers/pnp/resource.c
+++ linux-2.6.23-rc2/drivers/pnp/resource.c
@@ -245,11 +245,11 @@ int pnp_check_port(struct pnp_dev *dev, 
 	struct pnp_dev *tdev;
 	resource_size_t *port, *end, *tport, *tend;
 
-	port = &dev->res.port_resource[idx].start;
-	end = &dev->res.port_resource[idx].end;
+	port = &pnp_port_start(dev, idx);
+	end = &pnp_port_end(dev, idx);
 
 	/* if the resource doesn't exist, don't complain about it */
-	if (cannot_compare(dev->res.port_resource[idx].flags))
+	if (cannot_compare(pnp_port_flags(dev, idx)))
 		return 1;
 
 	/* check if the resource is already in use, skip if the
@@ -268,10 +268,10 @@ int pnp_check_port(struct pnp_dev *dev, 
 	}
 
 	/* check for internal conflicts */
-	for (tmp = 0; tmp < PNP_MAX_PORT && tmp != idx; tmp++) {
-		if (dev->res.port_resource[tmp].flags & IORESOURCE_IO) {
-			tport = &dev->res.port_resource[tmp].start;
-			tend = &dev->res.port_resource[tmp].end;
+	for (tmp = 0; pnp_port_res_pointer(dev, tmp) && tmp != idx; tmp++) {
+		if (pnp_port_flags(dev, tmp) & IORESOURCE_IO) {
+			tport = &pnp_port_start(dev, tmp);
+			tend = &pnp_port_end(dev, tmp);
 			if (ranged_conflict(port, end, tport, tend))
 				return 0;
 		}
@@ -281,13 +281,13 @@ int pnp_check_port(struct pnp_dev *dev, 
 	pnp_for_each_dev(tdev) {
 		if (tdev == dev)
 			continue;
-		for (tmp = 0; tmp < PNP_MAX_PORT; tmp++) {
-			if (tdev->res.port_resource[tmp].flags & IORESOURCE_IO) {
+		for (tmp = 0; pnp_port_res_pointer(tdev, tmp); tmp++) {
+			if (pnp_port_flags(tdev, tmp) & IORESOURCE_IO) {
 				if (cannot_compare
-				    (tdev->res.port_resource[tmp].flags))
+				    (pnp_port_flags(tdev, tmp)))
 					continue;
-				tport = &tdev->res.port_resource[tmp].start;
-				tend = &tdev->res.port_resource[tmp].end;
+				tport = &pnp_port_start(tdev, tmp);
+				tend = &pnp_port_end(tdev, tmp);
 				if (ranged_conflict(port, end, tport, tend))
 					return 0;
 			}
Index: linux-2.6.23-rc2/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- linux-2.6.23-rc2.orig/drivers/pnp/pnpbios/rsparser.c
+++ linux-2.6.23-rc2/drivers/pnp/pnpbios/rsparser.c
@@ -97,18 +97,31 @@ static void pnpbios_parse_allocated_iore
 {
 	int i = 0;
 
-	while (!(res->port_resource[i].flags & IORESOURCE_UNSET)
-	       && i < PNP_MAX_PORT)
+	while (i < res->allocated_ports &&
+	       !(pnp_port_flags(res, i) & IORESOURCE_UNSET))
 		i++;
-	if (i < PNP_MAX_PORT) {
-		res->port_resource[i].flags = IORESOURCE_IO;	// Also clears _UNSET flag
-		if (len <= 0 || (io + len - 1) >= 0x10003) {
-			res->port_resource[i].flags |= IORESOURCE_DISABLED;
+
+	if (res->allocated_ports <= i) {
+		ret = pnp_port_alloc(res);
+		if (ret) {
+			pnp_err ("%s: Cannot allocate port", __FUNCTION__);
+			/* pretend we were successful so at least the manager won't try again */
+			return;
+		}
+		/* Is this test needed at all? Maybe WARN_ON should be used? */
+		if (i >= dev->res.allocated_ports) {
+			pnp_err ("Bug in %s", __FUNCTION__);
 			return;
 		}
-		res->port_resource[i].start = (unsigned long)io;
-		res->port_resource[i].end = (unsigned long)(io + len - 1);
 	}
+
+	(res->port_resource + i)->flags) = IORESOURCE_IO;	// Also clears _UNSET flag
+	if (len <= 0 || (io + len - 1) >= 0x10003) {
+		(res->port_resource + i)->flags |= IORESOURCE_DISABLED;
+		return;
+	}
+	(res->port_resource + i)->start = (unsigned long)io;
+	(res->port_resource + i)->end = (unsigned long)(io + len - 1);
 }
 
 static void pnpbios_parse_allocated_memresource(struct pnp_resource_table *res,
Index: linux-2.6.23-rc2/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- linux-2.6.23-rc2.orig/drivers/pnp/pnpacpi/rsparser.c
+++ linux-2.6.23-rc2/drivers/pnp/pnpacpi/rsparser.c
@@ -171,22 +171,39 @@ static void pnpacpi_parse_allocated_dmar
 static void pnpacpi_parse_allocated_ioresource(struct pnp_resource_table *res,
 					       u64 io, u64 len, int io_decode)
 {
-	int i = 0;
+	int i = 0, ret;
 
-	while (!(res->port_resource[i].flags & IORESOURCE_UNSET) &&
-	       i < PNP_MAX_PORT)
+	while (i < res->allocated_ports &&
+	       !((res->port_resource + i)->flags & IORESOURCE_UNSET))
 		i++;
-	if (i < PNP_MAX_PORT) {
-		res->port_resource[i].flags = IORESOURCE_IO;	// Also clears _UNSET flag
-		if (io_decode == ACPI_DECODE_16)
-			res->port_resource[i].flags |= PNP_PORT_FLAG_16BITADDR;
-		if (len <= 0 || (io + len - 1) >= 0x10003) {
-			res->port_resource[i].flags |= IORESOURCE_DISABLED;
+
+	pnp_err ("%s: We want port %d - We have: %d free ports", __FUNCTION__, i,
+		 res->allocated_ports);
+
+	if (res->allocated_ports <= i) {
+		ret = pnp_port_alloc(res);
+		if (ret) {
+			pnp_err ("%s: Cannot allocate port", __FUNCTION__);
+			/* pretend we were successful so at least the manager won't try again */
 			return;
 		}
-		res->port_resource[i].start = io;
-		res->port_resource[i].end = io + len - 1;
+		/* Is this test needed at all? Maybe WARN_ON should be used? */
+		if (i >= res->allocated_ports) {
+			pnp_err ("Bug in %s - i: %d - allocated_ports: %d", __FUNCTION__,
+				 i, res->allocated_ports);
+			dump_stack();
+			return;
+		}
+	}
+	(res->port_resource + i)->flags = IORESOURCE_IO;	// Also clears _UNSET flag
+	if (io_decode == ACPI_DECODE_16)
+		(res->port_resource + i)->flags |= PNP_PORT_FLAG_16BITADDR;
+	if (len <= 0 || (io + len - 1) >= 0x10003) {
+		(res->port_resource + i)->flags |= IORESOURCE_DISABLED;
+		return;
 	}
+	(res->port_resource + i)->start = io;
+	(res->port_resource + i)->end = io + len - 1;
 }
 
 static void pnpacpi_parse_allocated_memresource(struct pnp_resource_table *res,
@@ -271,6 +288,7 @@ static acpi_status pnpacpi_allocated_res
 		break;
 
 	case ACPI_RESOURCE_TYPE_IO:
+		pnp_dbg("Adding resource: 0x%x", res->data.io.minimum);
 		pnpacpi_parse_allocated_ioresource(res_table,
 			res->data.io.minimum,
 			res->data.io.address_length,


