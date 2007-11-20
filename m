Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbXKTJvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbXKTJvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 04:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbXKTJvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 04:51:17 -0500
Received: from mx1.suse.de ([195.135.220.2]:46016 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845AbXKTJvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 04:51:15 -0500
Subject: [PATCH 1/3] PNP cleanups - Make use of
	pnp_{port,mem,irq,dma}_{start,end,flags} macros wherever possible
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>,
       Rene Herman <rene.herman@keyaccess.nl>,
       akpm <akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Tue, 20 Nov 2007 10:51:13 +0100
Message-Id: <1195552273.23700.164.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of pnp_{port,mem,irq,dma}_{start,end,flags} macros wherever possible

The macros to access the resource table in pnp sublayer was not used
consequently.
This patch makes use of these macros instead of accessing the resource
arrays directly.

For dma and irq also pnp_{dma,irq}_{start,end} macros have been introduced
to unify the access to the different resource types.

The pnp_{irq,dma} macros has now the same functionality than the:
pnp_{irq,dma}_start macros. This will be cleaned up by the next patch.

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/pnp/interface.c    |   52 +++++++++++++++-----------------
 drivers/pnp/manager.c      |   28 ++++++++---------
 drivers/pnp/pnpacpi/core.c |    2 -
 drivers/pnp/resource.c     |   72 +++++++++++++++++++++------------------------
 drivers/pnp/support.c      |    2 -
 include/linux/pnp.h        |    4 ++
 6 files changed, 79 insertions(+), 81 deletions(-)

Index: torvalds.current/include/linux/pnp.h
===================================================================
--- torvalds.current.orig/include/linux/pnp.h
+++ torvalds.current/include/linux/pnp.h
@@ -56,12 +56,16 @@ struct pnp_dev;
 	  pnp_mem_start((dev),(bar)) + 1))
 
 #define pnp_irq(dev,bar)	 ((dev)->res.irq_resource[(bar)].start)
+#define pnp_irq_start(dev,bar)	 ((dev)->res.irq_resource[(bar)].start)
+#define pnp_irq_end(dev,bar)	 ((dev)->res.irq_resource[(bar)].end)
 #define pnp_irq_flags(dev,bar)	 ((dev)->res.irq_resource[(bar)].flags)
 #define pnp_irq_valid(dev,bar) \
 	((pnp_irq_flags((dev),(bar)) & (IORESOURCE_IRQ | IORESOURCE_UNSET)) \
 		== IORESOURCE_IRQ)
 
 #define pnp_dma(dev,bar)	 ((dev)->res.dma_resource[(bar)].start)
+#define pnp_dma_start(dev,bar)	 ((dev)->res.dma_resource[(bar)].start)
+#define pnp_dma_end(dev,bar)	 ((dev)->res.dma_resource[(bar)].end)
 #define pnp_dma_flags(dev,bar)	 ((dev)->res.dma_resource[(bar)].flags)
 #define pnp_dma_valid(dev,bar) \
 	((pnp_dma_flags((dev),(bar)) & (IORESOURCE_DMA | IORESOURCE_UNSET)) \
Index: torvalds.current/drivers/pnp/manager.c
===================================================================
--- torvalds.current.orig/drivers/pnp/manager.c
+++ torvalds.current/drivers/pnp/manager.c
@@ -28,12 +28,12 @@ static int pnp_assign_port(struct pnp_de
 	}
 
 	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.port_resource[idx].flags & IORESOURCE_AUTO))
+	if (!(pnp_port_flags(dev, idx) & IORESOURCE_AUTO))
 		return 1;
 
-	start = &dev->res.port_resource[idx].start;
-	end = &dev->res.port_resource[idx].end;
-	flags = &dev->res.port_resource[idx].flags;
+	start = &pnp_port_start(dev, idx);
+	end = &pnp_port_end(dev, idx);
+	flags = &pnp_port_flags(dev, idx);
 
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_IO;
@@ -72,9 +72,9 @@ static int pnp_assign_mem(struct pnp_dev
 	if (!(dev->res.mem_resource[idx].flags & IORESOURCE_AUTO))
 		return 1;
 
-	start = &dev->res.mem_resource[idx].start;
-	end = &dev->res.mem_resource[idx].end;
-	flags = &dev->res.mem_resource[idx].flags;
+	start = &pnp_mem_start(dev, idx);
+	end = &pnp_mem_end(dev, idx);
+	flags = &pnp_mem_flags(dev, idx);
 
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_MEM;
@@ -129,9 +129,9 @@ static int pnp_assign_irq(struct pnp_dev
 	if (!(dev->res.irq_resource[idx].flags & IORESOURCE_AUTO))
 		return 1;
 
-	start = &dev->res.irq_resource[idx].start;
-	end = &dev->res.irq_resource[idx].end;
-	flags = &dev->res.irq_resource[idx].flags;
+	start = &pnp_irq_start(dev, idx);
+	end = &pnp_irq_end(dev, idx);
+	flags = &pnp_irq_flags(dev, idx);
 
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_IRQ;
@@ -175,12 +175,12 @@ static void pnp_assign_dma(struct pnp_de
 	}
 
 	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.dma_resource[idx].flags & IORESOURCE_AUTO))
+	if (!(pnp_dma_flags(dev, idx) & IORESOURCE_AUTO))
 		return;
 
-	start = &dev->res.dma_resource[idx].start;
-	end = &dev->res.dma_resource[idx].end;
-	flags = &dev->res.dma_resource[idx].flags;
+	start = &pnp_dma_start(dev, idx);
+	end = &pnp_dma_end(dev, idx);
+	flags = &pnp_dma_flags(dev, idx);
 
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_DMA;
Index: torvalds.current/drivers/pnp/interface.c
===================================================================
--- torvalds.current.orig/drivers/pnp/interface.c
+++ torvalds.current/drivers/pnp/interface.c
@@ -297,7 +297,8 @@ static ssize_t pnp_show_current_resource
 				pnp_printf(buffer, " disabled\n");
 			else
 				pnp_printf(buffer, " %lld\n",
-					   (unsigned long long)pnp_irq(dev, i));
+					   (unsigned long long)
+					   pnp_irq_start(dev, i));
 		}
 	}
 	for (i = 0; i < PNP_MAX_DMA; i++) {
@@ -307,7 +308,8 @@ static ssize_t pnp_show_current_resource
 				pnp_printf(buffer, " disabled\n");
 			else
 				pnp_printf(buffer, " %lld\n",
-					   (unsigned long long)pnp_dma(dev, i));
+					   (unsigned long long)
+					   pnp_dma_start(dev, i));
 		}
 	}
 	ret = (buffer->curr - buf);
@@ -381,7 +383,7 @@ pnp_set_current_resources(struct device 
 				buf += 2;
 				while (isspace(*buf))
 					++buf;
-				dev->res.port_resource[nport].start =
+				pnp_port_start(dev, nport) =
 				    simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
@@ -389,13 +391,12 @@ pnp_set_current_resources(struct device 
 					buf += 1;
 					while (isspace(*buf))
 						++buf;
-					dev->res.port_resource[nport].end =
-					    simple_strtoul(buf, &buf, 0);
+					pnp_port_end(dev, nport) =
+						simple_strtoul(buf, &buf, 0);
 				} else
-					dev->res.port_resource[nport].end =
-					    dev->res.port_resource[nport].start;
-				dev->res.port_resource[nport].flags =
-				    IORESOURCE_IO;
+					pnp_port_end(dev, nport) =
+						pnp_port_start(dev, nport);
+				pnp_port_flags(dev, nport) = IORESOURCE_IO;
 				nport++;
 				if (nport >= PNP_MAX_PORT)
 					break;
@@ -405,21 +406,20 @@ pnp_set_current_resources(struct device 
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				dev->res.mem_resource[nmem].start =
-				    simple_strtoul(buf, &buf, 0);
+				pnp_mem_start(dev, nmem) =
+					simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
 				if (*buf == '-') {
 					buf += 1;
 					while (isspace(*buf))
 						++buf;
-					dev->res.mem_resource[nmem].end =
-					    simple_strtoul(buf, &buf, 0);
+					pnp_mem_end(dev, nmem) =
+						simple_strtoul(buf, &buf, 0);
 				} else
-					dev->res.mem_resource[nmem].end =
-					    dev->res.mem_resource[nmem].start;
-				dev->res.mem_resource[nmem].flags =
-				    IORESOURCE_MEM;
+					pnp_mem_end(dev, nmem) =
+					    pnp_mem_start(dev, nmem);
+				pnp_mem_flags(dev, nmem) = IORESOURCE_MEM;
 				nmem++;
 				if (nmem >= PNP_MAX_MEM)
 					break;
@@ -429,11 +429,10 @@ pnp_set_current_resources(struct device 
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				dev->res.irq_resource[nirq].start =
-				    dev->res.irq_resource[nirq].end =
-				    simple_strtoul(buf, &buf, 0);
-				dev->res.irq_resource[nirq].flags =
-				    IORESOURCE_IRQ;
+				pnp_irq_start(dev, nirq) =
+					pnp_irq_end(dev, nirq) =
+					simple_strtoul(buf, &buf, 0);
+				pnp_irq_flags(dev, nirq) = IORESOURCE_IRQ;
 				nirq++;
 				if (nirq >= PNP_MAX_IRQ)
 					break;
@@ -443,11 +442,10 @@ pnp_set_current_resources(struct device 
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				dev->res.dma_resource[ndma].start =
-				    dev->res.dma_resource[ndma].end =
-				    simple_strtoul(buf, &buf, 0);
-				dev->res.dma_resource[ndma].flags =
-				    IORESOURCE_DMA;
+				pnp_dma_start(dev, ndma) =
+					pnp_dma_end(dev, ndma) =
+					simple_strtoul(buf, &buf, 0);
+				pnp_dma_flags(dev, ndma) = IORESOURCE_DMA;
 				ndma++;
 				if (ndma >= PNP_MAX_DMA)
 					break;
Index: torvalds.current/drivers/pnp/resource.c
===================================================================
--- torvalds.current.orig/drivers/pnp/resource.c
+++ torvalds.current/drivers/pnp/resource.c
@@ -220,11 +220,11 @@ int pnp_check_port(struct pnp_dev *dev, 
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
@@ -244,9 +244,9 @@ int pnp_check_port(struct pnp_dev *dev, 
 
 	/* check for internal conflicts */
 	for (tmp = 0; tmp < PNP_MAX_PORT && tmp != idx; tmp++) {
-		if (dev->res.port_resource[tmp].flags & IORESOURCE_IO) {
-			tport = &dev->res.port_resource[tmp].start;
-			tend = &dev->res.port_resource[tmp].end;
+		if (pnp_port_flags(dev, tmp) & IORESOURCE_IO) {
+			tport = &pnp_port_start(dev, tmp);
+			tend = &pnp_port_end(dev, tmp);
 			if (ranged_conflict(port, end, tport, tend))
 				return 0;
 		}
@@ -257,12 +257,11 @@ int pnp_check_port(struct pnp_dev *dev, 
 		if (tdev == dev)
 			continue;
 		for (tmp = 0; tmp < PNP_MAX_PORT; tmp++) {
-			if (tdev->res.port_resource[tmp].flags & IORESOURCE_IO) {
-				if (cannot_compare
-				    (tdev->res.port_resource[tmp].flags))
+			if (pnp_port_flags(tdev, tmp) & IORESOURCE_IO) {
+				if (cannot_compare(pnp_port_flags(tdev, tmp)))
 					continue;
-				tport = &tdev->res.port_resource[tmp].start;
-				tend = &tdev->res.port_resource[tmp].end;
+				tport = &pnp_port_start(tdev, tmp);
+				tend = &pnp_port_end(tdev, tmp);
 				if (ranged_conflict(port, end, tport, tend))
 					return 0;
 			}
@@ -278,11 +277,11 @@ int pnp_check_mem(struct pnp_dev *dev, i
 	struct pnp_dev *tdev;
 	resource_size_t *addr, *end, *taddr, *tend;
 
-	addr = &dev->res.mem_resource[idx].start;
-	end = &dev->res.mem_resource[idx].end;
+	addr = &pnp_mem_start(dev, idx);
+	end = &pnp_mem_end(dev, idx);
 
 	/* if the resource doesn't exist, don't complain about it */
-	if (cannot_compare(dev->res.mem_resource[idx].flags))
+	if (cannot_compare(pnp_mem_flags(dev, idx)))
 		return 1;
 
 	/* check if the resource is already in use, skip if the
@@ -302,9 +301,9 @@ int pnp_check_mem(struct pnp_dev *dev, i
 
 	/* check for internal conflicts */
 	for (tmp = 0; tmp < PNP_MAX_MEM && tmp != idx; tmp++) {
-		if (dev->res.mem_resource[tmp].flags & IORESOURCE_MEM) {
-			taddr = &dev->res.mem_resource[tmp].start;
-			tend = &dev->res.mem_resource[tmp].end;
+		if (pnp_mem_flags(dev, tmp) & IORESOURCE_MEM) {
+			taddr = &pnp_mem_start(dev, tmp);
+			tend = &pnp_mem_end(dev, tmp);
 			if (ranged_conflict(addr, end, taddr, tend))
 				return 0;
 		}
@@ -315,12 +314,11 @@ int pnp_check_mem(struct pnp_dev *dev, i
 		if (tdev == dev)
 			continue;
 		for (tmp = 0; tmp < PNP_MAX_MEM; tmp++) {
-			if (tdev->res.mem_resource[tmp].flags & IORESOURCE_MEM) {
-				if (cannot_compare
-				    (tdev->res.mem_resource[tmp].flags))
+			if (pnp_mem_flags(tdev, tmp) & IORESOURCE_MEM) {
+				if (cannot_compare(pnp_mem_flags(tdev, tmp)))
 					continue;
-				taddr = &tdev->res.mem_resource[tmp].start;
-				tend = &tdev->res.mem_resource[tmp].end;
+				taddr = &pnp_mem_start(tdev, tmp);
+				tend = &pnp_mem_end(tdev, tmp);
 				if (ranged_conflict(addr, end, taddr, tend))
 					return 0;
 			}
@@ -339,10 +337,10 @@ int pnp_check_irq(struct pnp_dev *dev, i
 {
 	int tmp;
 	struct pnp_dev *tdev;
-	resource_size_t *irq = &dev->res.irq_resource[idx].start;
+	resource_size_t *irq = &pnp_irq_start(dev, idx);
 
 	/* if the resource doesn't exist, don't complain about it */
-	if (cannot_compare(dev->res.irq_resource[idx].flags))
+	if (cannot_compare(pnp_irq_flags(dev, idx)))
 		return 1;
 
 	/* check if the resource is valid */
@@ -357,8 +355,8 @@ int pnp_check_irq(struct pnp_dev *dev, i
 
 	/* check for internal conflicts */
 	for (tmp = 0; tmp < PNP_MAX_IRQ && tmp != idx; tmp++) {
-		if (dev->res.irq_resource[tmp].flags & IORESOURCE_IRQ) {
-			if (dev->res.irq_resource[tmp].start == *irq)
+		if (pnp_irq_flags(dev, tmp) & IORESOURCE_IRQ) {
+			if (pnp_irq_start(dev, tmp) == *irq)
 				return 0;
 		}
 	}
@@ -388,11 +386,10 @@ int pnp_check_irq(struct pnp_dev *dev, i
 		if (tdev == dev)
 			continue;
 		for (tmp = 0; tmp < PNP_MAX_IRQ; tmp++) {
-			if (tdev->res.irq_resource[tmp].flags & IORESOURCE_IRQ) {
-				if (cannot_compare
-				    (tdev->res.irq_resource[tmp].flags))
+			if (pnp_irq_flags(tdev, tmp) & IORESOURCE_IRQ) {
+				if (cannot_compare(pnp_irq_flags(tdev, tmp)))
 					continue;
-				if ((tdev->res.irq_resource[tmp].start == *irq))
+				if ((pnp_irq_start(tdev, tmp) == *irq))
 					return 0;
 			}
 		}
@@ -406,10 +403,10 @@ int pnp_check_dma(struct pnp_dev *dev, i
 #ifndef CONFIG_IA64
 	int tmp;
 	struct pnp_dev *tdev;
-	resource_size_t *dma = &dev->res.dma_resource[idx].start;
+	resource_size_t *dma = &pnp_dma_start(dev, idx);
 
 	/* if the resource doesn't exist, don't complain about it */
-	if (cannot_compare(dev->res.dma_resource[idx].flags))
+	if (cannot_compare(pnp_dma_flags(dev, idx)))
 		return 1;
 
 	/* check if the resource is valid */
@@ -424,8 +421,8 @@ int pnp_check_dma(struct pnp_dev *dev, i
 
 	/* check for internal conflicts */
 	for (tmp = 0; tmp < PNP_MAX_DMA && tmp != idx; tmp++) {
-		if (dev->res.dma_resource[tmp].flags & IORESOURCE_DMA) {
-			if (dev->res.dma_resource[tmp].start == *dma)
+		if (pnp_dma_flags(dev, tmp) & IORESOURCE_DMA) {
+			if (pnp_dma_start(dev, tmp) == *dma)
 				return 0;
 		}
 	}
@@ -443,11 +440,10 @@ int pnp_check_dma(struct pnp_dev *dev, i
 		if (tdev == dev)
 			continue;
 		for (tmp = 0; tmp < PNP_MAX_DMA; tmp++) {
-			if (tdev->res.dma_resource[tmp].flags & IORESOURCE_DMA) {
-				if (cannot_compare
-				    (tdev->res.dma_resource[tmp].flags))
+			if (pnp_dma_flags(tdev, tmp) & IORESOURCE_DMA) {
+				if (cannot_compare(pnp_dma_flags(tdev, tmp)))
 					continue;
-				if ((tdev->res.dma_resource[tmp].start == *dma))
+				if ((pnp_dma_start(tdev, tmp) == *dma))
 					return 0;
 			}
 		}
Index: torvalds.current/drivers/pnp/support.c
===================================================================
--- torvalds.current.orig/drivers/pnp/support.c
+++ torvalds.current/drivers/pnp/support.c
@@ -18,7 +18,7 @@ int pnp_is_active(struct pnp_dev *dev)
 {
 	if (!pnp_port_start(dev, 0) && pnp_port_len(dev, 0) <= 1 &&
 	    !pnp_mem_start(dev, 0) && pnp_mem_len(dev, 0) <= 1 &&
-	    pnp_irq(dev, 0) == -1 && pnp_dma(dev, 0) == -1)
+	    pnp_irq_start(dev, 0) == -1 && pnp_dma_start(dev, 0) == -1)
 		return 0;
 	else
 		return 1;
Index: torvalds.current/drivers/pnp/pnpacpi/core.c
===================================================================
--- torvalds.current.orig/drivers/pnp/pnpacpi/core.c
+++ torvalds.current/drivers/pnp/pnpacpi/core.c
@@ -121,7 +121,7 @@ static int pnpacpi_disable_resources(str
 {
 	acpi_status status;
 
-	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */
+	/* acpi_unregister_gsi(pnp_irq_start(dev, 0)); */
 	status = acpi_evaluate_object((acpi_handle) dev->data,
 				      "_DIS", NULL, NULL);
 	return ACPI_FAILURE(status) ? -ENODEV : 0;


