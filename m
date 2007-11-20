Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbXKTOTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbXKTOTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbXKTOTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:19:23 -0500
Received: from ns1.suse.de ([195.135.220.2]:51643 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbXKTOTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:19:22 -0500
Subject: Re: [PATCH 2/3] PNP cleanups - Unify the pnp macros to access
	resources in the pnp resource table
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Rene Herman <rene.herman@keyaccess.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>, akpm <akpm@linux-foundation.org>
In-Reply-To: <20071120123102.03bdaa67@the-village.bc.nu>
References: <1195552283.23700.166.camel@queen.suse.de>
	 <20071120123102.03bdaa67@the-village.bc.nu>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Tue, 20 Nov 2007 15:19:20 +0100
Message-Id: <1195568360.23700.202.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-20 at 12:31 +0000, Alan Cox wrote:
> On Tue, 20 Nov 2007 10:51:23 +0100
> Thomas Renninger <trenn@suse.de> wrote:
> 
> > Unify the pnp macros to access resources in the pnp resource table
> 
> NAK
> 
> > port, mem, dma and irq resource macros are now all used in the same
> > way. This is the basis (or makes it at least easier) for changing how
> > the resources are allocated for memory optimizations.
> > 
> > Signed-off-by: Thomas Renninger <trenn@suse.de>
> 
> I really don't like this change.
> 
> _start implies an _end and an _len. IRQs have none of those features, nor
> are they ranges.

Ok.
To do this properly irq and dma should use their own structs in the pnp
resource table, IMO.
The struct resource with start, end, size and list pointers make only
sense for port and mem resources which are registered at
kernel/resource.c:insert_resource(..)

However, one useless exported symbol (why does this exist at all, have I
overseen something?) needs to get removed for that and I could imagine
this is making things worse as some externally built old drivers might
break?

At the end is some example code how things could get even more cleaned
up. It shows how I think pnp layer and one example driver would get
adjusted. There are not that much drivers making use of
pnp_resource_change..., but still (I am also not sure whether there is
more to adjust in drivers, but I expect the rest can be covered by the
macros...).

If this is not an option, please advise how to move on here:
Still use struct resources for dma and irq, but just do not name it
_start, but name the macro pnp_irq_no?

Thanks,

   Thomas

---
 drivers/pnp/manager.c |   15 --------------
 include/linux/pnp.h   |   19 +++++++++++-------
 sound/isa/als100.c    |   52 ++++++++++++++++++++++++++++++++++++--------------
 3 files changed, 50 insertions(+), 36 deletions(-)

Index: linux-2.6.24-rc2_mm1/include/linux/pnp.h
===================================================================
--- linux-2.6.24-rc2_mm1.orig/include/linux/pnp.h
+++ linux-2.6.24-rc2_mm1/include/linux/pnp.h
@@ -55,13 +55,13 @@ struct pnp_dev;
 	 (pnp_mem_end((dev),(bar)) -		\
 	  pnp_mem_start((dev),(bar)) + 1))
 
-#define pnp_irq(dev,bar)	 ((dev)->res.irq_resource[(bar)].start)
+#define pnp_irq(dev,bar)	 ((dev)->res.irq_resource[(bar)].no)
 #define pnp_irq_flags(dev,bar)	 ((dev)->res.irq_resource[(bar)].flags)
 #define pnp_irq_valid(dev,bar) \
 	((pnp_irq_flags((dev),(bar)) & (IORESOURCE_IRQ | IORESOURCE_UNSET)) \
 		== IORESOURCE_IRQ)
 
-#define pnp_dma(dev,bar)	 ((dev)->res.dma_resource[(bar)].start)
+#define pnp_dma(dev,bar)	 ((dev)->res.dma_resource[(bar)].no)
 #define pnp_dma_flags(dev,bar)	 ((dev)->res.dma_resource[(bar)].flags)
 #define pnp_dma_valid(dev,bar) \
 	((pnp_dma_flags((dev),(bar)) & (IORESOURCE_DMA | IORESOURCE_UNSET)) \
@@ -118,11 +118,16 @@ struct pnp_option {
 	struct pnp_option *next;	/* used to chain dependent resources */
 };
 
+struct pnp_irq_dma_res {
+	unsigned no;
+	unsigned long flags;
+};
+
 struct pnp_resource_table {
 	struct resource port_resource[PNP_MAX_PORT];
 	struct resource mem_resource[PNP_MAX_MEM];
-	struct resource dma_resource[PNP_MAX_DMA];
-	struct resource irq_resource[PNP_MAX_IRQ];
+	struct pnp_irq_dma_res dma_resource[PNP_MAX_DMA];
+	struct pnp_irq_dma_res irq_resource[PNP_MAX_IRQ];
 };
 
 /*
@@ -396,8 +401,8 @@ int pnp_start_dev(struct pnp_dev *dev);
 int pnp_stop_dev(struct pnp_dev *dev);
 int pnp_activate_dev(struct pnp_dev *dev);
 int pnp_disable_dev(struct pnp_dev *dev);
-void pnp_resource_change(struct resource *resource, resource_size_t start,
-			 resource_size_t size);
+//void pnp_resource_change(struct resource *resource, resource_size_t start,
+//			 resource_size_t size);
 
 /* protocol helpers */
 int pnp_is_active(struct pnp_dev *dev);
@@ -444,7 +449,7 @@ static inline int pnp_start_dev(struct p
 static inline int pnp_stop_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_activate_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_disable_dev(struct pnp_dev *dev) { return -ENODEV; }
-static inline void pnp_resource_change(struct resource *resource, resource_size_t start, resource_size_t size) { }
+//static inline void pnp_resource_change(struct resource *resource, resource_size_t start, resource_size_t size) { }
 
 /* protocol helpers */
 static inline int pnp_is_active(struct pnp_dev *dev) { return 0; }
Index: linux-2.6.24-rc2_mm1/drivers/pnp/manager.c
===================================================================
--- linux-2.6.24-rc2_mm1.orig/drivers/pnp/manager.c
+++ linux-2.6.24-rc2_mm1/drivers/pnp/manager.c
@@ -560,24 +560,9 @@ int pnp_disable_dev(struct pnp_dev *dev)
 	return 0;
 }
 
-/**
- * pnp_resource_change - change one resource
- * @resource: pointer to resource to be changed
- * @start: start of region
- * @size: size of region
- */
-void pnp_resource_change(struct resource *resource, resource_size_t start,
-			 resource_size_t size)
-{
-	resource->flags &= ~(IORESOURCE_AUTO | IORESOURCE_UNSET);
-	resource->start = start;
-	resource->end = start + size - 1;
-}
-
 EXPORT_SYMBOL(pnp_manual_config_dev);
 EXPORT_SYMBOL(pnp_start_dev);
 EXPORT_SYMBOL(pnp_stop_dev);
 EXPORT_SYMBOL(pnp_activate_dev);
 EXPORT_SYMBOL(pnp_disable_dev);
-EXPORT_SYMBOL(pnp_resource_change);
 EXPORT_SYMBOL(pnp_init_resource_table);
Index: linux-2.6.24-rc2_mm1/sound/isa/als100.c
===================================================================
--- linux-2.6.24-rc2_mm1.orig/sound/isa/als100.c
+++ linux-2.6.24-rc2_mm1/sound/isa/als100.c
@@ -129,14 +129,27 @@ static int __devinit snd_card_als100_pnp
 	pnp_init_resource_table(cfg);
 
 	/* override resources */
-	if (port[dev] != SNDRV_AUTO_PORT)
-		pnp_resource_change(&cfg->port_resource[0], port[dev], 16);
-	if (dma8[dev] != SNDRV_AUTO_DMA)
-		pnp_resource_change(&cfg->dma_resource[0], dma8[dev], 1);
-	if (dma16[dev] != SNDRV_AUTO_DMA)
-		pnp_resource_change(&cfg->dma_resource[1], dma16[dev], 1);
-	if (irq[dev] != SNDRV_AUTO_IRQ)
-		pnp_resource_change(&cfg->irq_resource[0], irq[dev], 1);
+	if (port[dev] != SNDRV_AUTO_PORT) {
+		cfg->port_resource[0].flags &=
+			~(IORESOURCE_AUTO | IORESOURCE_UNSET);
+		cfg->port_resource[0].start = port[dev];
+		cfg->port_resource[0].end = port[dev] + 16 - 1;
+	}
+	if (dma8[dev] != SNDRV_AUTO_DMA) {
+		cfg->dma_resource[0].flags &=
+			~(IORESOURCE_AUTO | IORESOURCE_UNSET);
+		cfg->dma_resource[0].no = dma8[dev];
+	}
+	if (dma16[dev] != SNDRV_AUTO_DMA) {
+		cfg->dma_resource[1].flags &=
+			~(IORESOURCE_AUTO | IORESOURCE_UNSET);
+		cfg->dma_resource[1].no = dma16[dev];
+	}
+	if (irq[dev] != SNDRV_AUTO_IRQ) {
+		cfg->irq_resource[0].flags &=
+			~(IORESOURCE_AUTO | IORESOURCE_UNSET);
+		cfg->irq_resource[0].no = irq[dev];
+	}
 	if (pnp_manual_config_dev(pdev, cfg, 0) < 0)
 		snd_printk(KERN_ERR PFX "AUDIO the requested resources are invalid, using auto config\n");
 	err = pnp_activate_dev(pdev);
@@ -153,10 +166,17 @@ static int __devinit snd_card_als100_pnp
 	pdev = acard->devmpu;
 	if (pdev != NULL) {
 		pnp_init_resource_table(cfg);
-		if (mpu_port[dev] != SNDRV_AUTO_PORT)
-			pnp_resource_change(&cfg->port_resource[0], mpu_port[dev], 2);
-		if (mpu_irq[dev] != SNDRV_AUTO_IRQ)
-			pnp_resource_change(&cfg->irq_resource[0], mpu_irq[dev], 1);
+		if (mpu_port[dev] != SNDRV_AUTO_PORT) {
+			cfg->port_resource[0].flags &=
+				~(IORESOURCE_AUTO | IORESOURCE_UNSET);
+			cfg->port_resource[0].start = mpu_port[dev];
+			cfg->port_resource[0].end = mpu_port[dev] + 2 - 1;
+		}
+		if (mpu_irq[dev] != SNDRV_AUTO_IRQ) {
+			cfg->irq_resource[0].flags &=
+				~(IORESOURCE_AUTO | IORESOURCE_UNSET);
+			cfg->irq_resource[0].no = mpu_irq[dev];
+		}
 		if ((pnp_manual_config_dev(pdev, cfg, 0)) < 0)
 			snd_printk(KERN_ERR PFX "MPU401 the requested resources are invalid, using auto config\n");
 		err = pnp_activate_dev(pdev);
@@ -177,8 +197,12 @@ static int __devinit snd_card_als100_pnp
 	pdev = acard->devopl;
 	if (pdev != NULL) {
 		pnp_init_resource_table(cfg);
-		if (fm_port[dev] != SNDRV_AUTO_PORT)
-			pnp_resource_change(&cfg->port_resource[0], fm_port[dev], 4);
+		if (fm_port[dev] != SNDRV_AUTO_PORT) {
+			cfg->port_resource[0].flags &=
+				~(IORESOURCE_AUTO | IORESOURCE_UNSET);
+			cfg->port_resource[0].start = fm_port[dev];
+			cfg->port_resource[0].end = fm_port[dev] + 4 - 1;
+		}
 		if ((pnp_manual_config_dev(pdev, cfg, 0)) < 0)
 			snd_printk(KERN_ERR PFX "OPL3 the requested resources are invalid, using auto config\n");
 		err = pnp_activate_dev(pdev);


