Return-Path: <linux-kernel-owner+w=401wt.eu-S1760797AbYA1QE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760797AbYA1QE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYA1QEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:04:48 -0500
Received: from ns.suse.de ([195.135.220.2]:42583 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbYA1QEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:04:46 -0500
Subject: Re: [PATCH] Allocate pnp resources dynamically via krealloc	-
	working version - Addon patch 1
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>, Jaroslav Kysela <perex@perex.cz>
In-Reply-To: <479DEE10.6060203@keyaccess.nl>
References: <1200772810.3708.42.camel@queen>
	 <84144f020801191623i2ad344a8t1c40969578793d13@mail.gmail.com>
	 <1201109917.20940.214.camel@queen.suse.de> <479CD935.3070906@keyaccess.nl>
	 <1201530103.20940.413.camel@queen.suse.de> <479DEE10.6060203@keyaccess.nl>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Mon, 28 Jan 2008 17:04:44 +0100
Message-Id: <1201536284.20940.424.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-28 at 16:00 +0100, Rene Herman wrote:
> On 28-01-08 15:21, Thomas Renninger wrote:
> 
> > I think I know what is going on.
> > While pnpbios and pnpacpi theoretically do not have limits, isapnp has
> > spec restrictions (AFAIK, I have not read this up, but taken over from
> > previous implementation...).
> > Therefore in isapnp I wanted to stay with:
> > #define PNP_MAX_PORT            8
> > #define PNP_MAX_MEM             4
> > #define PNP_MAX_IRQ             2
> > #define PNP_MAX_DMA             2
> > but I have forgotten to malloc one portion for each at init time, or
> > even better one portion as soon as one is needed.
> 
> Yup.
> 
> > As said, isapnp is more or less untested, thanks a lot for trying out.
> > I will send an updated version soon.
> 
> I"m not sure of the flow of things by the way but if it makes better/nicer 
> code to just pretend that ISAPnP is also unlimited then I'd say to simply do 
> so. ISAPnP is getting obsolete anyway, not anything to optimise for...
Can you try these two "on top" patches pls.
This one should fix the real cause (the "pnp: Port resource 0 not
allocated, cannot assign value" messages). The next should avoid the
NULL pointer in error case:

Also allocate memory for dependent/independent resource lists

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/pnp/manager.c |  138 ++++++++++++++++++++++----------------------------
 1 file changed, 61 insertions(+), 77 deletions(-)

Index: linux-2.6.23/drivers/pnp/manager.c
===================================================================
--- linux-2.6.23.orig/drivers/pnp/manager.c
+++ linux-2.6.23/drivers/pnp/manager.c
@@ -341,99 +341,89 @@ int pnp_assign_resource(struct pnp_resou
 
 static int pnp_assign_port(struct pnp_dev *dev, struct pnp_port *rule, int idx)
 {
-	resource_size_t *start, *end;
-	unsigned long *flags;
-
-	if (!pnp_port_ok(dev, idx)) {
-		pnp_print_assign_err("Port", idx);
-		/* pretend we were successful so at least the manager won't try again */
-		return 1;
-	}
+	struct resource res;
 
 	/* check if this resource has been manually set, if so skip */
 	if (!(dev->res.port_resource[idx].flags & IORESOURCE_AUTO))
 		return 1;
 
-	start = &dev->res.port_resource[idx].start;
-	end = &dev->res.port_resource[idx].end;
-	flags = &dev->res.port_resource[idx].flags;
+	res.start = dev->res.port_resource[idx].start;
+	res.end = dev->res.port_resource[idx].end;
+	res.flags = dev->res.port_resource[idx].flags;
 
 	/* set the initial values */
-	*flags |= rule->flags | IORESOURCE_IO;
-	*flags &= ~IORESOURCE_UNSET;
+	res.flags |= rule->flags | IORESOURCE_IO;
+	res.flags &= ~IORESOURCE_UNSET;
 
 	if (!rule->size) {
-		*flags |= IORESOURCE_DISABLED;
+		res.flags |= IORESOURCE_DISABLED;
+		pnp_assign_resource(&dev->res, &res);
 		return 1;	/* skip disabled resource requests */
 	}
 
-	*start = rule->min;
-	*end = *start + rule->size - 1;
+	res.start = rule->min;
+	res.end = res.start + rule->size - 1;
 
 	/* run through until pnp_check_port is happy */
 	while (!pnp_check_port(dev, idx)) {
-		*start += rule->align;
-		*end = *start + rule->size - 1;
-		if (*start > rule->max || !rule->align)
-			return 0;
+		res.start += rule->align;
+		res.end = res.start + rule->size - 1;
+		if (res.start > rule->max || !rule->align)
+			return pnp_assign_resource(&dev->res, &res);
 	}
+	pnp_assign_resource(&dev->res, &res);
 	return 1;
 }
 
 static int pnp_assign_mem(struct pnp_dev *dev, struct pnp_mem *rule, int idx)
 {
-	resource_size_t *start, *end;
-	unsigned long *flags;
-
-	if (!pnp_mem_ok(dev, idx)) {
-		pnp_print_assign_err("System Memory", idx);
-		return 1;
-	}
+	struct resource res;
 
 	/* check if this resource has been manually set, if so skip */
 	if (!(dev->res.mem_resource[idx].flags & IORESOURCE_AUTO))
 		return 1;
 
-	start = &dev->res.mem_resource[idx].start;
-	end = &dev->res.mem_resource[idx].end;
-	flags = &dev->res.mem_resource[idx].flags;
+	res.start = dev->res.mem_resource[idx].start;
+	res.end = dev->res.mem_resource[idx].end;
+	res.flags = dev->res.mem_resource[idx].flags;
 
 	/* set the initial values */
-	*flags |= rule->flags | IORESOURCE_MEM;
-	*flags &= ~IORESOURCE_UNSET;
+	res.flags |= rule->flags | IORESOURCE_MEM;
+	res.flags &= ~IORESOURCE_UNSET;
 
 	/* convert pnp flags to standard Linux flags */
 	if (!(rule->flags & IORESOURCE_MEM_WRITEABLE))
-		*flags |= IORESOURCE_READONLY;
+		res.flags |= IORESOURCE_READONLY;
 	if (rule->flags & IORESOURCE_MEM_CACHEABLE)
-		*flags |= IORESOURCE_CACHEABLE;
+		res.flags |= IORESOURCE_CACHEABLE;
 	if (rule->flags & IORESOURCE_MEM_RANGELENGTH)
-		*flags |= IORESOURCE_RANGELENGTH;
+		res.flags |= IORESOURCE_RANGELENGTH;
 	if (rule->flags & IORESOURCE_MEM_SHADOWABLE)
-		*flags |= IORESOURCE_SHADOWABLE;
+		res.flags |= IORESOURCE_SHADOWABLE;
 
 	if (!rule->size) {
-		*flags |= IORESOURCE_DISABLED;
+		res.flags |= IORESOURCE_DISABLED;
+		pnp_assign_resource(&dev->res, &res);
 		return 1;	/* skip disabled resource requests */
 	}
 
-	*start = rule->min;
-	*end = *start + rule->size - 1;
+	res.start = rule->min;
+	res.end = res.start + rule->size - 1;
 
 	/* run through until pnp_check_mem is happy */
 	while (!pnp_check_mem(dev, idx)) {
-		*start += rule->align;
-		*end = *start + rule->size - 1;
-		if (*start > rule->max || !rule->align)
-			return 0;
+		res.start += rule->align;
+		res.end = res.start + rule->size - 1;
+		if (res.start > rule->max || !rule->align)
+			return pnp_assign_resource(&dev->res, &res);
 	}
+	pnp_assign_resource(&dev->res, &res);
 	return 1;
 }
 
 static int pnp_assign_irq(struct pnp_dev *dev, struct pnp_irq *rule, int idx)
 {
-	resource_size_t *start, *end;
-	unsigned long *flags;
+	struct resource res;
 	int i;
 
 	/* IRQ priority: this table is good for i386 */
@@ -441,48 +431,44 @@ static int pnp_assign_irq(struct pnp_dev
 		5, 10, 11, 12, 9, 14, 15, 7, 3, 4, 13, 0, 1, 6, 8, 2
 	};
 
-	if (!pnp_irq_ok(dev, idx)) {
-		pnp_print_assign_err("Irq", idx);
-		return 1;
-	}
-
 	/* check if this resource has been manually set, if so skip */
 	if (!(dev->res.irq_resource[idx].flags & IORESOURCE_AUTO))
 		return 1;
 
-	start = &dev->res.irq_resource[idx].start;
-	end = &dev->res.irq_resource[idx].end;
-	flags = &dev->res.irq_resource[idx].flags;
+	res.start = dev->res.irq_resource[idx].start;
+	res.end = dev->res.irq_resource[idx].end;
+	res.flags = dev->res.irq_resource[idx].flags;
 
 	/* set the initial values */
-	*flags |= rule->flags | IORESOURCE_IRQ;
-	*flags &= ~IORESOURCE_UNSET;
+	res.flags |= rule->flags | IORESOURCE_IRQ;
+	res.flags &= ~IORESOURCE_UNSET;
 
 	if (bitmap_empty(rule->map, PNP_IRQ_NR)) {
-		*flags |= IORESOURCE_DISABLED;
+		res.flags |= IORESOURCE_DISABLED;
+		pnp_assign_resource(&dev->res, &res);
 		return 1;	/* skip disabled resource requests */
 	}
 
 	/* TBD: need check for >16 IRQ */
-	*start = find_next_bit(rule->map, PNP_IRQ_NR, 16);
-	if (*start < PNP_IRQ_NR) {
-		*end = *start;
+	res.start = find_next_bit(rule->map, PNP_IRQ_NR, 16);
+	if (res.start < PNP_IRQ_NR) {
+		res.end = res.start;
+		pnp_assign_resource(&dev->res, &res);
 		return 1;
 	}
 	for (i = 0; i < 16; i++) {
 		if (test_bit(xtab[i], rule->map)) {
-			*start = *end = xtab[i];
+			res.start = res.end = xtab[i];
 			if (pnp_check_irq(dev, idx))
 				return 1;
 		}
 	}
-	return 0;
+	return pnp_assign_resource(&dev->res, &res);
 }
 
 static void pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
 {
-	resource_size_t *start, *end;
-	unsigned long *flags;
+	struct resource res;
 	int i;
 
 	/* DMA priority: this table is good for i386 */
@@ -490,34 +476,32 @@ static void pnp_assign_dma(struct pnp_de
 		1, 3, 5, 6, 7, 0, 2, 4
 	};
 
-	if (!pnp_dma_ok(dev, idx)) {
-		pnp_print_assign_err("DMA", idx);
-		return;
-	}
-
 	/* check if this resource has been manually set, if so skip */
 	if (!(dev->res.dma_resource[idx].flags & IORESOURCE_AUTO))
 		return;
 
-	start = &dev->res.dma_resource[idx].start;
-	end = &dev->res.dma_resource[idx].end;
-	flags = &dev->res.dma_resource[idx].flags;
+	res.start = dev->res.dma_resource[idx].start;
+	res.end = dev->res.dma_resource[idx].end;
+	res.flags = dev->res.dma_resource[idx].flags;
 
 	/* set the initial values */
-	*flags |= rule->flags | IORESOURCE_DMA;
-	*flags &= ~IORESOURCE_UNSET;
+	res.flags |= rule->flags | IORESOURCE_DMA;
+	res.flags &= ~IORESOURCE_UNSET;
 
 	for (i = 0; i < 8; i++) {
 		if (rule->map & (1 << xtab[i])) {
-			*start = *end = xtab[i];
-			if (pnp_check_dma(dev, idx))
+			res.start = res.end = xtab[i];
+			if (pnp_check_dma(dev, idx)){
+				pnp_assign_resource(&dev->res, &res);
 				return;
+			}
 		}
 	}
 #ifdef MAX_DMA_CHANNELS
-	*start = *end = MAX_DMA_CHANNELS;
+	res.start = res.end = MAX_DMA_CHANNELS;
 #endif
-	*flags |= IORESOURCE_UNSET | IORESOURCE_DISABLED;
+	res.flags |= IORESOURCE_UNSET | IORESOURCE_DISABLED;
+	pnp_assign_resource(&dev->res, &res);
 }
 
 /**




