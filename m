Return-Path: <linux-kernel-owner+w=401wt.eu-S1760557AbXKTRwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760557AbXKTRwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 12:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760129AbXKTRwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 12:52:05 -0500
Received: from mail.suse.de ([195.135.220.2]:60957 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760112AbXKTRwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 12:52:02 -0500
Subject: [PATCH 1/3] PNP cleanups - Version 2 - Make use of
	pnp_{port,mem,irq,dma}_{start,end,flags} macros wherever possible
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Rene Herman <rene.herman@keyaccess.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Tue, 20 Nov 2007 18:52:00 +0100
Message-Id: <1195581120.23700.260.camel@queen.suse.de>
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
 drivers/pnp/interface.c        |   50 +++++++++++++---------------
 drivers/pnp/isapnp/core.c      |    6 +--
 drivers/pnp/manager.c          |   44 ++++++++++---------------
 drivers/pnp/pnpacpi/core.c     |    2 -
 drivers/pnp/pnpacpi/rsparser.c |    2 -
 drivers/pnp/pnpbios/rsparser.c |    6 +--
 drivers/pnp/resource.c         |   72 +++++++++++++++++++----------------------
 drivers/pnp/support.c          |    2 -
 include/linux/pnp.h            |    2 +
 9 files changed, 83 insertions(+), 103 deletions(-)

Index: linux-2.6.24-rc2-mm1/include/linux/pnp.h
===================================================================
--- linux-2.6.24-rc2-mm1.orig/include/linux/pnp.h
+++ linux-2.6.24-rc2-mm1/include/linux/pnp.h
@@ -56,12 +56,14 @@ struct pnp_dev;
 	  pnp_mem_start((dev),(bar)) + 1))
 
 #define pnp_irq(dev,bar)	 ((dev)->res.irq_resource[(bar)].start)
+#define pnp_irq_no(dev,bar)	 ((dev)->res.irq_resource[(bar)].start)
 #define pnp_irq_flags(dev,bar)	 ((dev)->res.irq_resource[(bar)].flags)
 #define pnp_irq_valid(dev,bar) \
 	((pnp_irq_flags((dev),(bar)) & (IORESOURCE_IRQ | IORESOURCE_UNSET)) \
 		== IORESOURCE_IRQ)
 
 #define pnp_dma(dev,bar)	 ((dev)->res.dma_resource[(bar)].start)
+#define pnp_dma_no(dev,bar)	 ((dev)->res.dma_resource[(bar)].start)
 #define pnp_dma_flags(dev,bar)	 ((dev)->res.dma_resource[(bar)].flags)
 #define pnp_dma_valid(dev,bar) \
 	((pnp_dma_flags((dev),(bar)) & (IORESOURCE_DMA | IORESOURCE_UNSET)) \
Index: linux-2.6.24-rc2-mm1/drivers/pnp/manager.c
===================================================================
--- linux-2.6.24-rc2-mm1.orig/drivers/pnp/manager.c
+++ linux-2.6.24-rc2-mm1/drivers/pnp/manager.c
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
@@ -110,7 +110,7 @@ static int pnp_assign_mem(struct pnp_dev
 
 static int pnp_assign_irq(struct pnp_dev *dev, struct pnp_irq *rule, int idx)
 {
-	resource_size_t *start, *end;
+	resource_size_t *start;
 	unsigned long *flags;
 	int i;
 
@@ -129,9 +129,8 @@ static int pnp_assign_irq(struct pnp_dev
 	if (!(dev->res.irq_resource[idx].flags & IORESOURCE_AUTO))
 		return 1;
 
-	start = &dev->res.irq_resource[idx].start;
-	end = &dev->res.irq_resource[idx].end;
-	flags = &dev->res.irq_resource[idx].flags;
+	start = &pnp_irq_no(dev, idx);
+	flags = &pnp_irq_flags(dev, idx);
 
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_IRQ;
@@ -144,13 +143,11 @@ static int pnp_assign_irq(struct pnp_dev
 
 	/* TBD: need check for >16 IRQ */
 	*start = find_next_bit(rule->map, PNP_IRQ_NR, 16);
-	if (*start < PNP_IRQ_NR) {
-		*end = *start;
+	if (*start < PNP_IRQ_NR)
 		return 1;
-	}
 	for (i = 0; i < 16; i++) {
 		if (test_bit(xtab[i], rule->map)) {
-			*start = *end = xtab[i];
+			*start = xtab[i];
 			if (pnp_check_irq(dev, idx))
 				return 1;
 		}
@@ -160,7 +157,7 @@ static int pnp_assign_irq(struct pnp_dev
 
 static void pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
 {
-	resource_size_t *start, *end;
+	resource_size_t *start;
 	unsigned long *flags;
 	int i;
 
@@ -175,12 +172,11 @@ static void pnp_assign_dma(struct pnp_de
 	}
 
 	/* check if this resource has been manually set, if so skip */
-	if (!(dev->res.dma_resource[idx].flags & IORESOURCE_AUTO))
+	if (!(pnp_dma_flags(dev, idx) & IORESOURCE_AUTO))
 		return;
 
-	start = &dev->res.dma_resource[idx].start;
-	end = &dev->res.dma_resource[idx].end;
-	flags = &dev->res.dma_resource[idx].flags;
+	start = &pnp_dma_no(dev, idx);
+	flags = &pnp_dma_flags(dev, idx);
 
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_DMA;
@@ -188,13 +184,13 @@ static void pnp_assign_dma(struct pnp_de
 
 	for (i = 0; i < 8; i++) {
 		if (rule->map & (1 << xtab[i])) {
-			*start = *end = xtab[i];
+			*start = xtab[i];
 			if (pnp_check_dma(dev, idx))
 				return;
 		}
 	}
 #ifdef MAX_DMA_CHANNELS
-	*start = *end = MAX_DMA_CHANNELS;
+	*start = MAX_DMA_CHANNELS;
 #endif
 	*flags |= IORESOURCE_UNSET | IORESOURCE_DISABLED;
 }
@@ -210,14 +206,12 @@ void pnp_init_resource_table(struct pnp_
 	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
 		table->irq_resource[idx].name = NULL;
 		table->irq_resource[idx].start = -1;
-		table->irq_resource[idx].end = -1;
 		table->irq_resource[idx].flags =
 		    IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
 	}
 	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
 		table->dma_resource[idx].name = NULL;
 		table->dma_resource[idx].start = -1;
-		table->dma_resource[idx].end = -1;
 		table->dma_resource[idx].flags =
 		    IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
 	}
@@ -249,7 +243,6 @@ static void pnp_clean_resource_table(str
 		if (!(res->irq_resource[idx].flags & IORESOURCE_AUTO))
 			continue;
 		res->irq_resource[idx].start = -1;
-		res->irq_resource[idx].end = -1;
 		res->irq_resource[idx].flags =
 		    IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
 	}
@@ -257,7 +250,6 @@ static void pnp_clean_resource_table(str
 		if (!(res->dma_resource[idx].flags & IORESOURCE_AUTO))
 			continue;
 		res->dma_resource[idx].start = -1;
-		res->dma_resource[idx].end = -1;
 		res->dma_resource[idx].flags =
 		    IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
 	}
Index: linux-2.6.24-rc2-mm1/drivers/pnp/interface.c
===================================================================
--- linux-2.6.24-rc2-mm1.orig/drivers/pnp/interface.c
+++ linux-2.6.24-rc2-mm1/drivers/pnp/interface.c
@@ -297,7 +297,8 @@ static ssize_t pnp_show_current_resource
 				pnp_printf(buffer, " disabled\n");
 			else
 				pnp_printf(buffer, " %lld\n",
-					   (unsigned long long)pnp_irq(dev, i));
+					   (unsigned long long)
+					   pnp_irq_no(dev, i));
 		}
 	}
 	for (i = 0; i < PNP_MAX_DMA; i++) {
@@ -307,7 +308,8 @@ static ssize_t pnp_show_current_resource
 				pnp_printf(buffer, " disabled\n");
 			else
 				pnp_printf(buffer, " %lld\n",
-					   (unsigned long long)pnp_dma(dev, i));
+					   (unsigned long long)
+					   pnp_dma_no(dev, i));
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
@@ -429,11 +429,9 @@ pnp_set_current_resources(struct device 
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				dev->res.irq_resource[nirq].start =
-				    dev->res.irq_resource[nirq].end =
-				    simple_strtoul(buf, &buf, 0);
-				dev->res.irq_resource[nirq].flags =
-				    IORESOURCE_IRQ;
+				pnp_irq_no(dev, nirq) =
+					simple_strtoul(buf, &buf, 0);
+				pnp_irq_flags(dev, nirq) = IORESOURCE_IRQ;
 				nirq++;
 				if (nirq >= PNP_MAX_IRQ)
 					break;
@@ -443,11 +441,9 @@ pnp_set_current_resources(struct device 
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				dev->res.dma_resource[ndma].start =
-				    dev->res.dma_resource[ndma].end =
-				    simple_strtoul(buf, &buf, 0);
-				dev->res.dma_resource[ndma].flags =
-				    IORESOURCE_DMA;
+				pnp_dma_no(dev, ndma) =
+					simple_strtoul(buf, &buf, 0);
+				pnp_dma_flags(dev, ndma) = IORESOURCE_DMA;
 				ndma++;
 				if (ndma >= PNP_MAX_DMA)
 					break;
Index: linux-2.6.24-rc2-mm1/drivers/pnp/resource.c
===================================================================
--- linux-2.6.24-rc2-mm1.orig/drivers/pnp/resource.c
+++ linux-2.6.24-rc2-mm1/drivers/pnp/resource.c
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
+	resource_size_t *irq = &pnp_irq_no(dev, idx);
 
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
+			if (pnp_irq_no(dev, tmp) == *irq)
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
+				if ((pnp_irq_no(tdev, tmp) == *irq))
 					return 0;
 			}
 		}
@@ -406,10 +403,10 @@ int pnp_check_dma(struct pnp_dev *dev, i
 #ifndef CONFIG_IA64
 	int tmp;
 	struct pnp_dev *tdev;
-	resource_size_t *dma = &dev->res.dma_resource[idx].start;
+	resource_size_t *dma = &pnp_dma_no(dev, idx);
 
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
+			if (pnp_dma_no(dev, tmp) == *dma)
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
+				if ((pnp_dma_no(tdev, tmp) == *dma))
 					return 0;
 			}
 		}
Index: linux-2.6.24-rc2-mm1/drivers/pnp/support.c
===================================================================
--- linux-2.6.24-rc2-mm1.orig/drivers/pnp/support.c
+++ linux-2.6.24-rc2-mm1/drivers/pnp/support.c
@@ -18,7 +18,7 @@ int pnp_is_active(struct pnp_dev *dev)
 {
 	if (!pnp_port_start(dev, 0) && pnp_port_len(dev, 0) <= 1 &&
 	    !pnp_mem_start(dev, 0) && pnp_mem_len(dev, 0) <= 1 &&
-	    pnp_irq(dev, 0) == -1 && pnp_dma(dev, 0) == -1)
+	    pnp_irq_no(dev, 0) == -1 && pnp_dma_no(dev, 0) == -1)
 		return 0;
 	else
 		return 1;
Index: linux-2.6.24-rc2-mm1/drivers/pnp/pnpacpi/core.c
===================================================================
--- linux-2.6.24-rc2-mm1.orig/drivers/pnp/pnpacpi/core.c
+++ linux-2.6.24-rc2-mm1/drivers/pnp/pnpacpi/core.c
@@ -121,7 +121,7 @@ static int pnpacpi_disable_resources(str
 {
 	acpi_status status;
 
-	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */
+	/* acpi_unregister_gsi(pnp_irq_no(dev, 0)); */
 	status = acpi_evaluate_object((acpi_handle) dev->data,
 				      "_DIS", NULL, NULL);
 	return ACPI_FAILURE(status) ? -ENODEV : 0;
Index: linux-2.6.24-rc2-mm1/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- linux-2.6.24-rc2-mm1.orig/drivers/pnp/pnpacpi/rsparser.c
+++ linux-2.6.24-rc2-mm1/drivers/pnp/pnpacpi/rsparser.c
@@ -107,7 +107,6 @@ static void pnpacpi_parse_allocated_irqr
 		res->irq_resource[i].flags |= IORESOURCE_IRQ_SHAREABLE;
 
 	res->irq_resource[i].start = irq;
-	res->irq_resource[i].end = irq;
 	pcibios_penalize_isa_irq(irq, 1);
 }
 
@@ -172,7 +171,6 @@ static void pnpacpi_parse_allocated_dmar
 			return;
 		}
 		res->dma_resource[i].start = dma;
-		res->dma_resource[i].end = dma;
 	}
 }
 
Index: linux-2.6.24-rc2-mm1/drivers/pnp/isapnp/core.c
===================================================================
--- linux-2.6.24-rc2-mm1.orig/drivers/pnp/isapnp/core.c
+++ linux-2.6.24-rc2-mm1/drivers/pnp/isapnp/core.c
@@ -966,16 +966,14 @@ static int isapnp_read_resources(struct 
 			     8);
 			if (!ret)
 				continue;
-			res->irq_resource[tmp].start =
-			    res->irq_resource[tmp].end = ret;
+			res->irq_resource[tmp].start = ret;
 			res->irq_resource[tmp].flags = IORESOURCE_IRQ;
 		}
 		for (tmp = 0; tmp < PNP_MAX_DMA; tmp++) {
 			ret = isapnp_read_byte(ISAPNP_CFG_DMA + tmp);
 			if (ret == 4)
 				continue;
-			res->dma_resource[tmp].start =
-			    res->dma_resource[tmp].end = ret;
+			res->dma_resource[tmp].start = ret;
 			res->dma_resource[tmp].flags = IORESOURCE_DMA;
 		}
 	}
Index: linux-2.6.24-rc2-mm1/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- linux-2.6.24-rc2-mm1.orig/drivers/pnp/pnpbios/rsparser.c
+++ linux-2.6.24-rc2-mm1/drivers/pnp/pnpbios/rsparser.c
@@ -67,8 +67,7 @@ static void pnpbios_parse_allocated_irqr
 			res->irq_resource[i].flags |= IORESOURCE_DISABLED;
 			return;
 		}
-		res->irq_resource[i].start =
-		    res->irq_resource[i].end = (unsigned long)irq;
+		res->irq_resource[i].start = (unsigned long)irq;
 		pcibios_penalize_isa_irq(irq, 1);
 	}
 }
@@ -87,8 +86,7 @@ static void pnpbios_parse_allocated_dmar
 			res->dma_resource[i].flags |= IORESOURCE_DISABLED;
 			return;
 		}
-		res->dma_resource[i].start =
-		    res->dma_resource[i].end = (unsigned long)dma;
+		res->dma_resource[i].start = (unsigned long)dma;
 	}
 }
 


