Return-Path: <linux-kernel-owner+w=401wt.eu-S1760273AbXGRISy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273AbXGRISy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 04:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbXGRISj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 04:18:39 -0400
Received: from mx1.suse.de ([195.135.220.2]:46566 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbXGRISg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 04:18:36 -0400
Subject: Re: [PATCH] - Increase PNP_MAX_PORT. ACPI devices can have a lot
	IO resource declarations
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       Jean Delvare <khali@linux-fr.org>, Bernhard Walle <bwalle@suse.de>
In-Reply-To: <200707170949.47346.bjorn.helgaas@hp.com>
References: <1184595667.19959.312.camel@queen.suse.de>
	 <200707170949.47346.bjorn.helgaas@hp.com>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 10:21:14 +0200
Message-Id: <1184746874.4062.35.camel@fanta4.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 09:49 -0600, Bjorn Helgaas wrote:
> On Monday 16 July 2007 08:21:07 am Thomas Renninger wrote:
> > PNP0C02 devices normally have a lot more IO port declarations than
> > currently defined in PNP_MAX_PORT
> 
> Yes.
> 
> > I also wonder whether other limits like:
> >  #define PNP_MAX_MEM        4
> >  #define PNP_MAX_IRQ        2
> >  #define PNP_MAX_DMA        2
> > could get exceeded with pnpacpi?
> 
> Definitely.  I think the current limits come from the PNP ISA spec
> (sec 4.6).  I don't see similar limits in the PNPBIOS or ACPI specs,
> so ideally I think they should be dynamically allocated as you suggest.
> 
I wanted to implement the dynamic approach and used a dynamically
allocated array, filled up from beginning. While this is close to the
current implementation I thought this is the easiest sufficient way...
(I also only did this for io ports where most mem is wasted).
Now I am thinking about hotplug (e.g. if a SSDT with resources gets
hot-added, removed)... If a device can vanish, the array must get
reordered, not a really well fitting structure, a list (a pnp specific
set up, or from include/linux/list.h?) should be better?

I only have a half baken (even not compiling, I already saw several bugs
myself in this one while flying over...) patch. It shows what I wanted
to do.  The important part is in include/linux/pnp.h. After sleeping
over it, I fear I am doing this work for nothing...

As this is touching nearly every file in drivers/pnp I'd like to have
some advice/discussion, before I start (over and over) again...

If someone screams who knows that part well and wanted to add this
anyway..., I am busy enough :) (,but I can do it if not...)

Thanks,

   Thomas

---
 drivers/pnp/interface.c        |   16 ++++++++++------
 drivers/pnp/isapnp/core.c      |    9 +++++----
 drivers/pnp/manager.c          |   13 ++++++++-----
 drivers/pnp/pnpacpi/rsparser.c |   17 +++++++++--------
 drivers/pnp/pnpbios/rsparser.c |   14 ++++++++------
 drivers/pnp/resource.c         |   16 ++++++++--------
 drivers/pnp/system.c           |    2 +-
 include/linux/pnp.h            |   12 +++++++-----
 8 files changed, 56 insertions(+), 43 deletions(-)

Index: linux-2.6.22.1/drivers/pnp/interface.c
===================================================================
--- linux-2.6.22.1.orig/drivers/pnp/interface.c
+++ linux-2.6.22.1/drivers/pnp/interface.c
@@ -258,7 +258,7 @@ static ssize_t pnp_show_current_resource
 	else
 		pnp_printf(buffer,"disabled\n");
 
-	for (i = 0; i < PNP_MAX_PORT; i++) {
+	for (i = 0; pnp_port_res_pointer(dev, i); i++) {
 		if (pnp_port_valid(dev, i)) {
 			pnp_printf(buffer,"io");
 			if (pnp_port_flags(dev, i) & IORESOURCE_DISABLED)
@@ -370,19 +370,23 @@ pnp_set_current_resources(struct device 
 				buf += 2;
 				while (isspace(*buf))
 					++buf;
-				dev->res.port_resource[nport].start = simple_strtoul(buf,&buf,0);
+				pnp_port_start(dev,nport) =
+					simple_strtoul(buf,&buf,0);
 				while (isspace(*buf))
 					++buf;
 				if(*buf == '-') {
 					buf += 1;
 					while (isspace(*buf))
 						++buf;
-					dev->res.port_resource[nport].end = simple_strtoul(buf,&buf,0);
+					pnp_port_end(dev,nport) =
+						simple_strtoul(buf,&buf,0);
 				} else
-					dev->res.port_resource[nport].end = dev->res.port_resource[nport].start;
-				dev->res.port_resource[nport].flags = IORESOURCE_IO;
+					pnp_port_end(dev,nport) =
+						pnp_port_start(dev,nport);
+				pnp_port_flags(dev,nport) = IORESOURCE_IO;
 				nport++;
-				if (nport >= PNP_MAX_PORT)
+				if (!pnp_port_res_pointer(dev,nport) ||
+				    nport >= PNP_MAX_PORT)
 					break;
 				continue;
 			}
Index: linux-2.6.22.1/drivers/pnp/manager.c
===================================================================
--- linux-2.6.22.1.orig/drivers/pnp/manager.c
+++ linux-2.6.22.1/drivers/pnp/manager.c
@@ -26,18 +26,21 @@ static int pnp_assign_port(struct pnp_de
 		return -EINVAL;
 
 	if (idx >= PNP_MAX_PORT) {
-		pnp_err("More than 4 ports is incompatible with pnp specifications.");
+		pnp_err("Run out of pnp ports\n");
 		/* pretend we were successful so at least the manager won't try again */
 		return 1;
 	}
 
 	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.port_resource[idx].flags & IORESOURCE_AUTO))
+	if (pnp_port_res_pointer(dev, idx) && !(dev->res.port_resource[idx].flags & IORESOURCE_AUTO))
 		return 1;
 
-	start = &dev->res.port_resource[idx].start;
-	end = &dev->res.port_resource[idx].end;
-	flags = &dev->res.port_resource[idx].flags;
+	if (!pnp_port_res_pointer(dev, idx))
+		pnp_port_res_pointer(dev, idx) = kzalloc(sizeof(struct resource), GFP_KERNEL);
+
+	start = &pnp_port_res_pointer(dev, idx)->start;
+	end =   &pnp_port_res_pointer(dev, idx)->end;
+	flags = &pnp_port_res_pointer(dev, idx)->flags;
 
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_IO;
Index: linux-2.6.22.1/drivers/pnp/resource.c
===================================================================
--- linux-2.6.22.1.orig/drivers/pnp/resource.c
+++ linux-2.6.22.1/drivers/pnp/resource.c
@@ -241,11 +241,11 @@ int pnp_check_port(struct pnp_dev * dev,
 	int tmp;
 	struct pnp_dev *tdev;
 	resource_size_t *port, *end, *tport, *tend;
-	port = &dev->res.port_resource[idx].start;
-	end = &dev->res.port_resource[idx].end;
+	port = &(pnp_port_start(dev,idx));
+	end = &(pnp_port_end(dev,idx));
 
 	/* if the resource doesn't exist, don't complain about it */
-	if (cannot_compare(dev->res.port_resource[idx].flags))
+	if (cannot_compare(pnp_port_flags(dev,idx)))
 		return 1;
 
 	/* check if the resource is already in use, skip if the
@@ -264,10 +264,10 @@ int pnp_check_port(struct pnp_dev * dev,
 	}
 
 	/* check for internal conflicts */
-	for (tmp = 0; tmp < PNP_MAX_PORT && tmp != idx; tmp++) {
-		if (dev->res.port_resource[tmp].flags & IORESOURCE_IO) {
-			tport = &dev->res.port_resource[tmp].start;
-			tend = &dev->res.port_resource[tmp].end;
+	for (tmp = 0; pnp_port_res_pointer(dev, tmp) && tmp != idx; tmp++) {
+		if (pnp_port_flags(dev,tmp) & IORESOURCE_IO) {
+			tport = &(pnp_port_start(dev,tmp));
+			tend = &(pnp_port_end(dev,tmp));
 			if (ranged_conflict(port,end,tport,tend))
 				return 0;
 		}
@@ -277,7 +277,7 @@ int pnp_check_port(struct pnp_dev * dev,
 	pnp_for_each_dev(tdev) {
 		if (tdev == dev)
 			continue;
-		for (tmp = 0; tmp < PNP_MAX_PORT; tmp++) {
+		for (tmp = 0;  pnp_port_res_pointer(dev, tmp); tmp++) {
 			if (tdev->res.port_resource[tmp].flags & IORESOURCE_IO) {
 				if (cannot_compare(tdev->res.port_resource[tmp].flags))
 					continue;
Index: linux-2.6.22.1/drivers/pnp/system.c
===================================================================
--- linux-2.6.22.1.orig/drivers/pnp/system.c
+++ linux-2.6.22.1/drivers/pnp/system.c
@@ -55,7 +55,7 @@ static void reserve_resources_of_dev(con
 {
 	int i;
 
-	for (i = 0; i < PNP_MAX_PORT; i++) {
+	for (i = 0; pnp_port_res_pointer(dev, i); i++) {
 		if (!pnp_port_valid(dev, i))
 			continue;
 		if (pnp_port_start(dev, i) == 0)
Index: linux-2.6.22.1/include/linux/pnp.h
===================================================================
--- linux-2.6.22.1.orig/include/linux/pnp.h
+++ linux-2.6.22.1/include/linux/pnp.h
@@ -14,7 +14,7 @@
 #include <linux/errno.h>
 #include <linux/mod_devicetable.h>
 
-#define PNP_MAX_PORT		8
+#define PNP_MAX_PORT		256
 #define PNP_MAX_MEM		4
 #define PNP_MAX_IRQ		2
 #define PNP_MAX_DMA		2
@@ -29,9 +29,11 @@ struct pnp_dev;
  */
 
 /* Use these instead of directly reading pnp_dev to get resource information */
-#define pnp_port_start(dev,bar)   ((dev)->res.port_resource[(bar)].start)
-#define pnp_port_end(dev,bar)     ((dev)->res.port_resource[(bar)].end)
-#define pnp_port_flags(dev,bar)   ((dev)->res.port_resource[(bar)].flags)
+#define pnp_port_res_pointer(dev,bar)   (bar >= PNP_MAX_PORT ? NULL : \
+					 (dev)->res.port_resource[(bar)])
+#define pnp_port_start(dev,bar)   ((dev)->res.port_resource[(bar)]->start)
+#define pnp_port_end(dev,bar)     ((dev)->res.port_resource[(bar)]->end)
+#define pnp_port_flags(dev,bar)   ((dev)->res.port_resource[(bar)]->flags)
 #define pnp_port_valid(dev,bar) \
 	((pnp_port_flags((dev),(bar)) & (IORESOURCE_IO | IORESOURCE_UNSET)) \
 		== IORESOURCE_IO)
@@ -121,7 +123,7 @@ struct pnp_option {
 };
 
 struct pnp_resource_table {
-	struct resource port_resource[PNP_MAX_PORT];
+	struct resource *port_resource[PNP_MAX_PORT];
 	struct resource mem_resource[PNP_MAX_MEM];
 	struct resource dma_resource[PNP_MAX_DMA];
 	struct resource irq_resource[PNP_MAX_IRQ];
Index: linux-2.6.22.1/drivers/pnp/isapnp/core.c
===================================================================
--- linux-2.6.22.1.orig/drivers/pnp/isapnp/core.c
+++ linux-2.6.22.1/drivers/pnp/isapnp/core.c
@@ -954,12 +954,13 @@ static int isapnp_read_resources(struct 
 
 	dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
 	if (dev->active) {
-		for (tmp = 0; tmp < PNP_MAX_PORT; tmp++) {
+		for (tmp = 0; res->port_resource[tmp] && tmp < PNP_MAX_PORT;
+		     tmp++) {
 			ret = isapnp_read_word(ISAPNP_CFG_PORT + (tmp << 1));
 			if (!ret)
 				continue;
-			res->port_resource[tmp].start = ret;
-			res->port_resource[tmp].flags = IORESOURCE_IO;
+			res->port_resource[tmp]->start = ret;
+			res->port_resource[tmp]->flags = IORESOURCE_IO;
 		}
 		for (tmp = 0; tmp < PNP_MAX_MEM; tmp++) {
 			ret = isapnp_read_word(ISAPNP_CFG_MEM + (tmp << 3)) << 8;
@@ -1002,7 +1003,7 @@ static int isapnp_set_resources(struct p
 
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	dev->active = 1;
-	for (tmp = 0; tmp < PNP_MAX_PORT && (res->port_resource[tmp].flags & (IORESOURCE_IO | IORESOURCE_UNSET)) == IORESOURCE_IO; tmp++)
+	for (tmp = 0; res->port_resource[tmp] && tmp < PNP_MAX_PORT && (res->port_resource[tmp].flags & (IORESOURCE_IO | IORESOURCE_UNSET)) == IORESOURCE_IO; tmp++)
 		isapnp_write_word(ISAPNP_CFG_PORT+(tmp<<1), res->port_resource[tmp].start);
 	for (tmp = 0; tmp < PNP_MAX_IRQ && (res->irq_resource[tmp].flags & (IORESOURCE_IRQ | IORESOURCE_UNSET)) == IORESOURCE_IRQ; tmp++) {
 		int irq = res->irq_resource[tmp].start;
Index: linux-2.6.22.1/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- linux-2.6.22.1.orig/drivers/pnp/pnpacpi/rsparser.c
+++ linux-2.6.22.1/drivers/pnp/pnpacpi/rsparser.c
@@ -172,19 +172,20 @@ pnpacpi_parse_allocated_ioresource(struc
 	u64 io, u64 len, int io_decode)
 {
 	int i = 0;
-	while (!(res->port_resource[i].flags & IORESOURCE_UNSET) &&
-			i < PNP_MAX_PORT)
+	while (res->port_resource[i] &&
+	       !(res->port_resource[i]->flags & IORESOURCE_UNSET) &&
+	       i < PNP_MAX_PORT)
 		i++;
-	if (i < PNP_MAX_PORT) {
-		res->port_resource[i].flags = IORESOURCE_IO;  // Also clears _UNSET flag
+	if (res->port_resource[i] && i < PNP_MAX_PORT) {
+		res->port_resource[i]->flags = IORESOURCE_IO;  // Also clears _UNSET flag
 		if (io_decode == ACPI_DECODE_16)
-			res->port_resource[i].flags |= PNP_PORT_FLAG_16BITADDR;
+			res->port_resource[i]->flags |= PNP_PORT_FLAG_16BITADDR;
 		if (len <= 0 || (io + len -1) >= 0x10003) {
-			res->port_resource[i].flags |= IORESOURCE_DISABLED;
+			res->port_resource[i]->flags |= IORESOURCE_DISABLED;
 			return;
 		}
-		res->port_resource[i].start = io;
-		res->port_resource[i].end = io + len - 1;
+		res->port_resource[i]->start = io;
+		res->port_resource[i]->end = io + len - 1;
 	}
 }
 
Index: linux-2.6.22.1/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- linux-2.6.22.1.orig/drivers/pnp/pnpbios/rsparser.c
+++ linux-2.6.22.1/drivers/pnp/pnpbios/rsparser.c
@@ -91,15 +91,17 @@ static void
 pnpbios_parse_allocated_ioresource(struct pnp_resource_table * res, int io, int len)
 {
 	int i = 0;
-	while (!(res->port_resource[i].flags & IORESOURCE_UNSET) && i < PNP_MAX_PORT) i++;
-	if (i < PNP_MAX_PORT) {
-		res->port_resource[i].flags = IORESOURCE_IO;  // Also clears _UNSET flag
+	while (res->port_resource[i] &&
+	       !(res->port_resource[i]->flags & IORESOURCE_UNSET) &&
+	       i < PNP_MAX_PORT) i++;
+	if (res->port_resource[i] && i < PNP_MAX_PORT) {
+		res->port_resource[i]->flags = IORESOURCE_IO;  // Also clears _UNSET flag
 		if (len <= 0 || (io + len -1) >= 0x10003) {
-			res->port_resource[i].flags |= IORESOURCE_DISABLED;
+			res->port_resource[i]->flags |= IORESOURCE_DISABLED;
 			return;
 		}
-		res->port_resource[i].start = (unsigned long) io;
-		res->port_resource[i].end = (unsigned long)(io + len - 1);
+		res->port_resource[i]->start = (unsigned long) io;
+		res->port_resource[i]->end = (unsigned long)(io + len - 1);
 	}
 }
 


