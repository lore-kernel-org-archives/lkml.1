Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbXJZKpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbXJZKpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 06:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbXJZKpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 06:45:30 -0400
Received: from mx1.suse.de ([195.135.220.2]:51365 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbXJZKpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 06:45:25 -0400
Subject: Re: [PATCH 0/5] Detect hwmon and i2c bus drivers interfering with
	ACPI Operation Region resources
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@osdl.org>,
       Jean Delvare <khali@linux-fr.org>
In-Reply-To: <200710252159.11594.bjorn.helgaas@hp.com>
References: <1193236319.4590.225.camel@queen.suse.de>
	 <200710250906.23003.bjorn.helgaas@hp.com>
	 <1193352907.3665.37.camel@fanta4.site>
	 <200710252159.11594.bjorn.helgaas@hp.com>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Fri, 26 Oct 2007 12:45:20 +0200
Message-Id: <1193395520.4590.349.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 21:59 -0600, Bjorn Helgaas wrote:
> On Thursday 25 October 2007 4:55:07 pm Thomas Renninger wrote:
> > On Thu, 2007-10-25 at 09:06 -0600, Bjorn Helgaas wrote:
> > > Isn't the real problem that we have a bunch of drivers that use some of
> > > the same resources, and if ACPI reserved all the right resources, all
> > > those drivers would break?
> >
> > Yes, but:
> > It is really impossible to register them just like that.
> > I only tried on one machine I implemented on, Jean tested with more
> > machines. Even there the resources did not only interfere, but overlap.
> > The Operation Region declarations in ACPI don't belong to a real driver,
> > but may be used in all kind of functions.
> 
> Can we reserve the resources when we register the opregion?  Or does
> the opregion declaration just not tell us what resources it might use?
> 
> > E.g. the thermal driver can't know which operation regions it may use
> > later, e.g. by invoking _THM which in turn invokes a couple of other
> > functions where IO ports are addressed via operation regions.
> 
> I would think the opregion resources should be reserved in connection
> with the opregion, not with drivers that use the opregion.
Yes, I tried that.
> 
> > Also the BIOS developers seem to choose the regions in a very dump way
> > sometimes.
> > Just some imaginary values, but I saw similar (overlapping):
> >  - For a PNP device IO ports from 0x400-0x410 are reserved
> >  - A operation region is declared from 0x399-0x401
> 
> If we know the resources the opregion can use, we can at least
> reserve the union of those used by the opregion and by other
> PNP devices.  A little messy to deal with overlapping areas, I
> agree, but it should still be possible by shrinking the region
> or allocating a port at a time or something.
You mean merging them together to something like:
  0x400-0x410 pnp device
  0x399       ACPI Op region's name
This needs touching of kernel/resource.c and modification in a very ugly
way affecting all architectures...
Or working around it outside if possible, but it's everything but
nice/clean.
Maybe the list set up by this patch set should be similarly exported
like /proc/ioports /proc/iomem
to where ever appropriate (maybe /sys/devices/system/acpi/opreg_io
and /sys/devices/system/acpi/opreg_mem?) to get a better overview what
kind of devices are served by the Op regions on different machines.
Expect all kind of ugliness if you have a look at some more machines...

IMO the current approach is safe, easy and sufficient (maybe some more
drivers could get added later), covering most important potential
offenders, we can still add some more. It should be mainly/only small
devices accessed by Op regions, setting up and accessing complex devices
won't be done by Op region declared objects.
Maybe there should be a rule in ACPI spec that they must also pop up as
resources in the motherboard device for future, this would address your
concerns? The mixture of declaring some resources in devices and some in
Op regions, some in both and even let them overlap can IMO be called a
broken BIOS, but it's common. Doing a complex workaround to be somehow
able to request them is wrong.
 
> > Also the current request_resource interface (not the interface but the
> > callers), need to be polished up first.
> > 1) E.g. PNPACPI needs to dynamically allocate its resources (as we
> > already discussed, I hope to be able to send something soon. Already
> > works, but this will also affect PNPBIOS and ISAPNP, a lot old code and
> > this needs careful review/testing).
> 
> I have a patch for this (see below).  It is risky, and I'm nervous
> about it.  But the alternative (leaving PNP devices active but not
> reserving their resources, as we do today) is also risky.
> 
> If you have a similar patch in the works, I'd like to compare with mine.
I think I worked on something else.
Do I get this right:
This one is to request all active resources of all ACPI devices that
export resources via _CRS/_SRS?
As this is currently done for the motherboard devices only by
pnp/system.c?

What I meant is that the pnp_resource_table resource table is currently
statically declared to have 8 ports, but e.g. motherboard devices can
have more than 20.
I attached my patch at the end (two other cleanup patches are also
needed and this has just been written down to work, a lot cleanup and
careful review is still necessary, but I don't find the time for it
currently). The most interesting part is the beginning (pnp_port_alloc
and so on, that kreallocs in e.g. 8 port portions instead of using a
static array).
If you are interested I can try to fast cleanup and send you a
pre-version of all patches (but not before beginning of next week).

   Thomas

> > 2) I have no idea why e.g. i386/x86_64 kernel/setup.c code statically
> > requests some ports below 0x100 and whether it can be ripped out or gets
> > requested via the operation regions then in a sane way. I know they
> > interfere on some systems with operation regions.
> 
> You mean the stuff in request_standard_resources()?  I think that's
> legacy from before we had PNPBIOS and ACPI.  Theoretically, we should
> be able to remove it if we have PNPBIOS or ACPI.  But I think that
> would be too dangerous.
> 
> It should be safe to leave it -- it's OK if we reserve a little bit
> too much.  The problem is if we reserve too little.
> 
> Bjorn
> 
> 
> NOT FOR APPLICATION -- NOT FOR APPLICATION -- NOT FOR APPLICATION
> 
> PNP: request ioport and iomem resources used by active devices
> 
> For platform-type devices, PNP tells us what devices are present, whether
> they're active, and what resources they consume.  To prevent conflicts, the
> PNP core should request the resources used by active devices before we
> assign resources to any other devices.
> 
> This overlaps with request_standard_resources(), which requests resources
> for a built-in list of "standard PC devices" such as DMA controllers, PICs,
> timers, keyboard, etc.  PNP tells us which devices are actually present on
> a specific machine.
> 
> Sometimes the built-in standard resources are larger than what PNP reports,
> or they combine things that PNP reports separately, which makes things look
> a little funny:
> 
>     0000-001f : dma1		<-- built-in resource includes 2 controllers
>       0000-000f : 00:02		<-- PNP reports only one DMA controller
>     0020-0021 : pic1
>     002e-002f : 00:06
>     0040-0043 : timer0
>     0050-0053 : timer1
>     0060-006f : keyboard	<-- built-in resource groups several things
>       0060-0060 : 00:04		<-- PNP reports 8042 controller data register
>       0061-0061 : 00:03		<-- PNP reports AT-style speaker
>       0064-0064 : 00:04		<-- PNP reports 8042 controller status register
>     0070-0073 : 00:06
>       0070-0071 : rtc
> 
> This doesn't mark the resources busy; they should be marked busy when
> a driver claims them.  But if driver attempts to claim a region larger
> than what PNP reported, it will fail.
> 
> Index: w/drivers/pnp/core.c
> ===================================================================
> --- w.orig/drivers/pnp/core.c	2007-10-23 10:45:32.000000000 -0600
> +++ w/drivers/pnp/core.c	2007-10-23 16:07:28.000000000 -0600
> @@ -124,6 +124,9 @@
>  	list_add_tail(&dev->protocol_list, &dev->protocol->devices);
>  	spin_unlock(&pnp_lock);
>  
> +	if (dev->active)
> +		pnp_request_resources(dev);
> +
>  	ret = device_register(&dev->dev);
>  	if (ret)
>  		return ret;
> Index: w/drivers/pnp/resource.c
> ===================================================================
> --- w.orig/drivers/pnp/resource.c	2007-10-23 10:45:32.000000000 -0600
> +++ w/drivers/pnp/resource.c	2007-10-23 16:07:28.000000000 -0600
> @@ -459,6 +459,73 @@
>  #endif
>  }
>  
> +int pnp_request_resources(struct pnp_dev *dev)
> +{
> +	int i, ret;
> +	struct resource *res;
> +
> +	/*
> +	 * We use insert_resource() rather than request_resource() because
> +	 * request_standard_resources() has already requested some standard
> +	 * areas that are described by PNP.
> +	 */
> +	for (i = 0; i < PNP_MAX_PORT; i++) {
> +		if (pnp_port_valid(dev, i)) {
> +			res = &dev->res.port_resource[i];
> +			res->name = dev->dev.bus_id;
> +			ret = insert_resource(&ioport_resource, res);
> +			if (ret)
> +				dev_warn(&dev->dev,
> +					"can't allocate I/O ports at 0x%llx\n",
> +					(unsigned long long) res->start);
> +		}
> +	}
> +
> +	for (i = 0; i < PNP_MAX_MEM; i++) {
> +		if (pnp_mem_valid(dev, i)) {
> +			res = &dev->res.mem_resource[i];
> +			res->name = dev->dev.bus_id;
> +			ret = insert_resource(&iomem_resource, res);
> +			if (ret)
> +				dev_warn(&dev->dev,
> +					"can't allocate MMIO space at 0x%llx\n",
> +					(unsigned long long) res->start);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +int pnp_release_resources(struct pnp_dev *dev)
> +{
> +	int i, ret;
> +	struct resource *res;
> +
> +	for (i = 0; i < PNP_MAX_PORT; i++) {
> +		if (pnp_port_valid(dev, i)) {
> +			res = &dev->res.port_resource[i];
> +			ret = release_resource(res);
> +			if (ret)
> +				dev_warn(&dev->dev,
> +					"can't release I/O ports at 0x%llx\n",
> +					(unsigned long long) res->start);
> +		}
> +	}
> +
> +	for (i = 0; i < PNP_MAX_MEM; i++) {
> +		if (pnp_mem_valid(dev, i)) {
> +			res = &dev->res.mem_resource[i];
> +			ret = release_resource(res);
> +			if (ret)
> +				dev_warn(&dev->dev,
> +					"can't release MMIO space at 0x%llx\n",
> +					(unsigned long long) res->start);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  /* format is: pnp_reserve_irq=irq1[,irq2] .... */
>  static int __init pnp_setup_reserve_irq(char *str)
>  {
> Index: w/drivers/pnp/base.h
> ===================================================================
> --- w.orig/drivers/pnp/base.h	2007-10-23 10:45:32.000000000 -0600
> +++ w/drivers/pnp/base.h	2007-10-23 16:07:28.000000000 -0600
> @@ -5,6 +5,8 @@
>  void pnp_free_option(struct pnp_option *option);
>  int __pnp_add_device(struct pnp_dev *dev);
>  void __pnp_remove_device(struct pnp_dev *dev);
> +int pnp_request_resources(struct pnp_dev *dev);
> +int pnp_release_resources(struct pnp_dev *dev);
>  
>  int pnp_check_port(struct pnp_dev * dev, int idx);
>  int pnp_check_mem(struct pnp_dev * dev, int idx);
> Index: w/drivers/pnp/manager.c
> ===================================================================
> --- w.orig/drivers/pnp/manager.c	2007-10-23 16:00:54.000000000 -0600
> +++ w/drivers/pnp/manager.c	2007-10-23 16:08:04.000000000 -0600
> @@ -391,9 +391,11 @@
>  
>  	if (!pnp_can_configure(dev))
>  		return -ENODEV;
> +
>  	bak = pnp_alloc(sizeof(struct pnp_resource_table));
>  	if (!bak)
>  		return -ENOMEM;
> +
>  	*bak = dev->res;
>  
>  	down(&pnp_res_mutex);
> @@ -463,7 +465,7 @@
>   * pnp_start_dev - low-level start of the PnP device
>   * @dev: pointer to the desired device
>   *
> - * assumes that resources have already been allocated
> + * assumes that resources have already been assigned to the device
>   */
>  int pnp_start_dev(struct pnp_dev *dev)
>  {
> @@ -472,6 +474,9 @@
>  		return -EINVAL;
>  	}
>  
> +	if (pnp_request_resources(dev))
> +		dev_err(&dev->dev, "could not allocate resources\n");
> +
>  	if (dev->protocol->set(dev, &dev->res) < 0) {
>  		dev_err(&dev->dev, "activation failed\n");
>  		return -EIO;
> @@ -484,8 +489,6 @@
>  /**
>   * pnp_stop_dev - low-level disable of the PnP device
>   * @dev: pointer to the desired device
> - *
> - * does not free resources
>   */
>  int pnp_stop_dev(struct pnp_dev *dev)
>  {
> @@ -493,11 +496,14 @@
>  		dev_dbg(&dev->dev, "disabling not supported\n");
>  		return -EINVAL;
>  	}
> +
>  	if (dev->protocol->disable(dev) < 0) {
>  		dev_err(&dev->dev, "disable failed\n");
>  		return -EIO;
>  	}
>  
> +	pnp_release_resources(dev);
> +
>  	dev_info(&dev->dev, "disabled\n");
>  	return 0;
>  }

---
 drivers/pnp/core.c             |    4 
 drivers/pnp/interface.c        |   65 ++------
 drivers/pnp/manager.c          |  330 ++++++++++++++++++++++++++++-------------
 drivers/pnp/pnpacpi/rsparser.c |  214 ++++++++++++++------------
 drivers/pnp/pnpbios/rsparser.c |   99 ++++++------
 drivers/pnp/quirks.c           |   18 +-
 drivers/pnp/resource.c         |   25 +--
 drivers/pnp/system.c           |   10 -
 include/linux/pnp.h            |   50 ++++--
 9 files changed, 492 insertions(+), 323 deletions(-)

Index: linux-2.6.23-rc3/include/linux/pnp.h
===================================================================
--- linux-2.6.23-rc3.orig/include/linux/pnp.h
+++ linux-2.6.23-rc3/include/linux/pnp.h
@@ -13,10 +13,6 @@
 #include <linux/errno.h>
 #include <linux/mod_devicetable.h>
 
-#define PNP_MAX_PORT		8
-#define PNP_MAX_MEM		4
-#define PNP_MAX_IRQ		2
-#define PNP_MAX_DMA		2
 #define PNP_NAME_LEN		50
 
 struct pnp_protocol;
@@ -27,12 +23,16 @@ struct pnp_dev;
  */
 
 /* Use these instead of directly reading pnp_dev to get resource information */
+#define pnp_port(dev,bar)	((dev)->res.allocated_ports > (bar) \
+	? (&(dev)->res.port_resource[bar]) : NULL)
 #define pnp_port_start(dev,bar)   ((dev)->res.port_resource[(bar)].start)
 #define pnp_port_end(dev,bar)     ((dev)->res.port_resource[(bar)].end)
 #define pnp_port_flags(dev,bar)   ((dev)->res.port_resource[(bar)].flags)
 #define pnp_port_valid(dev,bar) \
+	(pnp_port((dev),(bar)) ? \
 	((pnp_port_flags((dev),(bar)) & (IORESOURCE_IO | IORESOURCE_UNSET)) \
-		== IORESOURCE_IO)
+		== IORESOURCE_IO) : \
+	 (0))
 #define pnp_port_len(dev,bar) \
 	((pnp_port_start((dev),(bar)) == 0 &&	\
 	  pnp_port_end((dev),(bar)) ==		\
@@ -41,12 +41,16 @@ struct pnp_dev;
 	 (pnp_port_end((dev),(bar)) -		\
 	  pnp_port_start((dev),(bar)) + 1))
 
+#define pnp_mem(dev,bar)	((dev)->res.allocated_mems > (bar) \
+	? (&(dev)->res.mem_resource[bar]) : NULL)
 #define pnp_mem_start(dev,bar)   ((dev)->res.mem_resource[(bar)].start)
 #define pnp_mem_end(dev,bar)     ((dev)->res.mem_resource[(bar)].end)
 #define pnp_mem_flags(dev,bar)   ((dev)->res.mem_resource[(bar)].flags)
 #define pnp_mem_valid(dev,bar) \
+	(pnp_mem((dev),(bar)) ? \
 	((pnp_mem_flags((dev),(bar)) & (IORESOURCE_MEM | IORESOURCE_UNSET)) \
-		== IORESOURCE_MEM)
+		== IORESOURCE_MEM) : \
+	 (0))
 #define pnp_mem_len(dev,bar) \
 	((pnp_mem_start((dev),(bar)) == 0 &&	\
 	  pnp_mem_end((dev),(bar)) ==		\
@@ -55,19 +59,27 @@ struct pnp_dev;
 	 (pnp_mem_end((dev),(bar)) -		\
 	  pnp_mem_start((dev),(bar)) + 1))
 
+#define pnp_irq(dev,bar)	((dev)->res.allocated_irqs > (bar) \
+	? (&(dev)->res.irq_resource[bar]) : NULL)
 #define pnp_irq_start(dev,bar)	 ((dev)->res.irq_resource[(bar)].start)
 #define pnp_irq_end(dev,bar)	 ((dev)->res.irq_resource[(bar)].end)
 #define pnp_irq_flags(dev,bar)	 ((dev)->res.irq_resource[(bar)].flags)
 #define pnp_irq_valid(dev,bar) \
+	(pnp_irq((dev),(bar)) ? \
 	((pnp_irq_flags((dev),(bar)) & (IORESOURCE_IRQ | IORESOURCE_UNSET)) \
-		== IORESOURCE_IRQ)
+		== IORESOURCE_IRQ) : \
+	 (0))
 
+#define pnp_dma(dev,bar)	((dev)->res.allocated_dmas > (bar) \
+	? ((dev)->res.dma_resource + (bar)) : NULL)
 #define pnp_dma_start(dev,bar)	 ((dev)->res.dma_resource[(bar)].start)
 #define pnp_dma_end(dev,bar)	 ((dev)->res.dma_resource[(bar)].end)
 #define pnp_dma_flags(dev,bar)	 ((dev)->res.dma_resource[(bar)].flags)
 #define pnp_dma_valid(dev,bar) \
+	(pnp_irq((dev),(bar)) ? \
 	((pnp_dma_flags((dev),(bar)) & (IORESOURCE_DMA | IORESOURCE_UNSET)) \
-		== IORESOURCE_DMA)
+		== IORESOURCE_DMA) : \
+	 (0))
 
 #define PNP_PORT_FLAG_16BITADDR	(1<<0)
 #define PNP_PORT_FLAG_FIXED	(1<<1)
@@ -121,10 +133,14 @@ struct pnp_option {
 };
 
 struct pnp_resource_table {
-	struct resource port_resource[PNP_MAX_PORT];
-	struct resource mem_resource[PNP_MAX_MEM];
-	struct resource dma_resource[PNP_MAX_DMA];
-	struct resource irq_resource[PNP_MAX_IRQ];
+	struct resource *port_resource;
+	unsigned int allocated_ports;
+	struct resource *mem_resource;
+	unsigned int allocated_mems;
+	struct resource *dma_resource;
+	unsigned int allocated_dmas;
+	struct resource *irq_resource;
+	unsigned int allocated_irqs;
 };
 
 /*
@@ -400,6 +416,7 @@ int pnp_activate_dev(struct pnp_dev *dev
 int pnp_disable_dev(struct pnp_dev *dev);
 void pnp_resource_change(struct resource *resource, resource_size_t start,
 			 resource_size_t size);
+int pnp_assign_resource(struct pnp_resource_table *table, struct resource *res);
 
 /* protocol helpers */
 int pnp_is_active(struct pnp_dev *dev);
@@ -447,6 +464,7 @@ static inline int pnp_stop_dev(struct pn
 static inline int pnp_activate_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_disable_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline void pnp_resource_change(struct resource *resource, resource_size_t start, resource_size_t size) { }
+static inline void int pnp_assign_resource(struct pnp_resource_table *table, struct resource *res) { }
 
 /* protocol helpers */
 static inline int pnp_is_active(struct pnp_dev *dev) { return 0; }
@@ -463,8 +481,16 @@ static inline void pnp_unregister_driver
 
 #ifdef CONFIG_PNP_DEBUG
 #define pnp_dbg(format, arg...) printk(KERN_DEBUG "pnp: " format "\n" , ## arg)
+void pnp_dump_ports (struct pnp_dev *dev);
+void pnp_dump_mems (struct pnp_dev *dev);
+void pnp_dump_irqs (struct pnp_dev *dev);
+void pnp_dump_dmas (struct pnp_dev *dev);
 #else
 #define pnp_dbg(format, arg...) do {} while (0)
+static inline void pnp_dump_ports (struct pnp_dev *dev) { }
+static inline void pnp_dump_mems  (struct pnp_dev *dev) { }
+static inline void pnp_dump_irqs  (struct pnp_dev *dev) { }
+static inline void pnp_dump_dmas  (struct pnp_dev *dev) { }
 #endif
 
 #endif /* __KERNEL__ */
Index: linux-2.6.23-rc3/drivers/pnp/manager.c
===================================================================
--- linux-2.6.23-rc3.orig/drivers/pnp/manager.c
+++ linux-2.6.23-rc3/drivers/pnp/manager.c
@@ -14,21 +14,187 @@
 #include <linux/bitmap.h>
 #include "base.h"
 
+/* Defines the amount of struct resources that will get (re-)alloced
+ * if the resource table runs out of allocated ports/irqs/dma/mems
+*/
+#define PNP_ALLOC_PORT		8
+#define PNP_ALLOC_MEM		4
+#define PNP_ALLOC_IRQ		2
+#define PNP_ALLOC_DMA		2
+
 DECLARE_MUTEX(pnp_res_mutex);
 
+#ifdef CONFIG_PNP_DEBUG
+#define pnp_dump_(type, dev)						\
+void pnp_dump_##type##s (struct pnp_dev *dev)				\
+{									\
+	int i;								\
+	pnp_dbg ("Resource table dump:");				\
+	pnp_dbg ("Allocted ##type: %d", dev->res.allocated_##type##s);	\
+	for (i = 0; pnp_##type(dev,i); i++) {				\
+		pnp_dbg ("##type %d: start: 0x%llx - end: 0x%llx "	\
+			 "- flags: %lu",				\
+			 i, pnp_##type##_start(dev,i),			\
+			 pnp_##type##_end(dev,i),			\
+			 pnp_##type##_flags(dev,i));			\
+	}								\
+}
+pnp_dump_(port, dev);
+pnp_dump_(mem, dev);
+pnp_dump_(irq, dev);
+pnp_dump_(dma, dev);
+#endif
+
+#define pnp_init(type, res)						\
+static void pnp_init_##type						\
+(struct resource *res)							\
+{									\
+	res->name = NULL;						\
+	res->start = -1;						\
+	res->end = -1;							\
+	res->flags = IORESOURCE_##type | IORESOURCE_AUTO |		\
+	IORESOURCE_UNSET;						\
+}
+pnp_init(IO, res);
+pnp_init(MEM, res);
+pnp_init(IRQ, res);
+pnp_init(DMA, res);
+
+int pnp_alloc_port(struct pnp_resource_table *res)
+{
+	int i;
+	res->port_resource = krealloc(res->port_resource,
+				      (sizeof(struct resource)
+				       * res->allocated_ports)
+				      + (sizeof(struct resource)
+					 * PNP_ALLOC_PORT), GFP_KERNEL);
+	if (!res->port_resource)
+		return -ENOMEM;
+
+	res->allocated_ports += PNP_ALLOC_PORT;
+	for (i = res->allocated_ports - PNP_ALLOC_PORT;
+	     i < res->allocated_ports; i++)
+		pnp_init_IO(&res->port_resource[i]);
+
+	pnp_dbg("Ports reallocated, we now have: %d", res->allocated_ports);
+	return 0;
+}
+
+int pnp_alloc_mem(struct pnp_resource_table *res)
+{
+	int i;
+	res->mem_resource = krealloc(res->mem_resource, (sizeof(struct resource)
+							 * res->allocated_mems)
+				     + (sizeof(struct resource)
+					* PNP_ALLOC_MEM), GFP_KERNEL);
+	if (!res->mem_resource)
+		return -ENOMEM;
+
+	res->allocated_mems += PNP_ALLOC_MEM;
+	for (i = res->allocated_mems - PNP_ALLOC_MEM;
+	     i < res->allocated_mems; i++)
+		pnp_init_MEM(&res->mem_resource[i]);
+
+	pnp_dbg("Mem resources reallocated, we now have: %d",
+		res->allocated_mems);
+	return 0;
+}
+
+int pnp_alloc_irq(struct pnp_resource_table *res)
+{
+	int i;
+	res->irq_resource = krealloc(res->irq_resource, (sizeof(struct resource)
+							 * res->allocated_irqs)
+				     + (sizeof(struct resource)
+					* PNP_ALLOC_IRQ), GFP_KERNEL);
+	if (!res->irq_resource)
+		return -ENOMEM;
+
+	res->allocated_irqs += PNP_ALLOC_IRQ;
+	for (i = res->allocated_irqs - PNP_ALLOC_IRQ;
+	     i < res->allocated_irqs; i++)
+		pnp_init_IRQ(&res->irq_resource[i]);
+
+	pnp_dbg("Irqs reallocated, we now have: %d", res->allocated_irqs);
+	return 0;
+}
+
+int pnp_alloc_dma(struct pnp_resource_table *res)
+{
+	int i;
+	res->dma_resource = krealloc(res->dma_resource, (sizeof(struct resource)
+							 * res->allocated_dmas)
+				     + (sizeof(struct resource)
+					* PNP_ALLOC_DMA), GFP_KERNEL);
+	if (!res->dma_resource)
+		return -ENOMEM;
+
+	res->allocated_dmas += PNP_ALLOC_DMA;
+	for (i = res->allocated_dmas - PNP_ALLOC_DMA;
+	     i < res->allocated_dmas; i++)
+		pnp_init_DMA(&res->dma_resource[i]);
+
+	pnp_dbg("Dma resources reallocated, we now have: %d",
+		res->allocated_dmas);
+	return 0;
+}
+
+/*
+ * Assign a resource (IO, MEM, IRQ, DMA) to a resource table.
+ * Searches for an IORESOURCE_UNSET resource entry in the table or reallocs
+ * new resource entries as needed and copies the given resource there.
+ *
+ * returns:
+ *   -EFAULT -> if table or res is NULL
+ *   -EINVAL -> if the resource has no io, mem, irq or dma flag set
+ *   -ENOMEM -> if memory could not get allocated
+ */
+int pnp_assign_resource(struct pnp_resource_table *table, struct resource *res)
+{
+	int i = 0, ret;
+
+	if (!table || !res)
+		return -EFAULT;
+	if (!res->flags & (IORESOURCE_IO | IORESOURCE_DMA | IORESOURCE_MEM |
+			   IORESOURCE_IRQ))
+		return -EINVAL;
+
+	while (i < table->allocated_ports &&
+	       !(table->port_resource[i].flags & IORESOURCE_UNSET))
+		i++;
+
+	if (table->allocated_ports <= i) {
+		ret = pnp_alloc_port(table);
+		if (ret) {
+			pnp_err("%s: Cannot allocate port", __FUNCTION__);
+			return ret;
+		}
+	}
+	memcpy(&table->port_resource[i], res, sizeof(struct resource));
+	return 0;
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
+	if (!pnp_port(dev, idx)) {
+		ret = pnp_alloc_port(&dev->res);
+		if (ret) {
+			pnp_err("Cannot allocate port resource");
+			/* pretend we were successful so at least the manager won't try again */
+			return 1;
+		}
+		if (idx >= dev->res.allocated_ports) {
+			pnp_err("Bug in %s for device: %s", __FUNCTION__,
+				dev->name);
+			return 1;
+		}
 	}
 
 	/* check if this resource has been manually set, if so skip */
@@ -65,24 +231,33 @@ static int pnp_assign_mem(struct pnp_dev
 {
 	resource_size_t *start, *end;
 	unsigned long *flags;
+	struct resource res;
+	int ret;
 
 	if (!dev || !rule)
 		return -EINVAL;
 
-	if (idx >= PNP_MAX_MEM) {
-		pnp_err
-		    ("More than 8 mems is incompatible with pnp specifications.");
-		/* pretend we were successful so at least the manager won't try again */
-		return 1;
+	if (!pnp_mem(dev, idx)) {
+		ret = pnp_alloc_mem(&dev->res);
+		if (ret) {
+			pnp_err("Cannot allocate mem resource");
+			/* pretend we were successful so at least the manager won't try again */
+			return 1;
+		}
+		if (idx >= dev->res.allocated_mems) {
+			pnp_err("Bug in %s for device: %s", __FUNCTION__,
+				dev->name);
+			return 1;
+		}
 	}
 
 	/* check if this resource has been manually set, if so skip */
 	if (!(dev->res.mem_resource[idx].flags & IORESOURCE_AUTO))
 		return 1;
 
-	start = &pnp_mem_start(dev, idx);
-	end = &pnp_mem_end(dev, idx);
-	flags = &pnp_mem_flags(dev, idx);
+	start = &res.start;
+	end = &res.end;
+	flags = &res.flags;
 
 	/* set the initial values */
 	*flags |= rule->flags | IORESOURCE_MEM;
@@ -120,7 +295,7 @@ static int pnp_assign_irq(struct pnp_dev
 {
 	resource_size_t *start, *end;
 	unsigned long *flags;
-	int i;
+	int i, ret;
 
 	/* IRQ priority: this table is good for i386 */
 	static unsigned short xtab[16] = {
@@ -130,11 +305,18 @@ static int pnp_assign_irq(struct pnp_dev
 	if (!dev || !rule)
 		return -EINVAL;
 
-	if (idx >= PNP_MAX_IRQ) {
-		pnp_err
-		    ("More than 2 irqs is incompatible with pnp specifications.");
-		/* pretend we were successful so at least the manager won't try again */
-		return 1;
+	if (!pnp_irq(dev, idx)) {
+		ret = pnp_alloc_irq(&dev->res);
+		if (ret) {
+			pnp_err("Cannot allocate irq resource");
+			/* pretend we were successful so at least the manager won't try again */
+			return 1;
+		}
+		if (idx >= dev->res.allocated_irqs) {
+			pnp_err("Bug in %s for device: %s", __FUNCTION__,
+				dev->name);
+			return 1;
+		}
 	}
 
 	/* check if this resource has been manually set, if so skip */
@@ -174,7 +356,7 @@ static int pnp_assign_dma(struct pnp_dev
 {
 	resource_size_t *start, *end;
 	unsigned long *flags;
-	int i;
+	int i, ret;
 
 	/* DMA priority: this table is good for i386 */
 	static unsigned short xtab[8] = {
@@ -184,11 +366,18 @@ static int pnp_assign_dma(struct pnp_dev
 	if (!dev || !rule)
 		return -EINVAL;
 
-	if (idx >= PNP_MAX_DMA) {
-		pnp_err
-		    ("More than 2 dmas is incompatible with pnp specifications.");
-		/* pretend we were successful so at least the manager won't try again */
-		return 1;
+	if (!pnp_dma(dev, idx)) {
+		ret = pnp_alloc_dma(&dev->res);
+		if (ret) {
+			pnp_err("Cannot allocate dma resource");
+			/* pretend we were successful so at least the manager won't try again */
+			return 1;
+		}
+		if (idx >= dev->res.allocated_dmas) {
+			pnp_err("Bug in %s for device: %s", __FUNCTION__,
+				dev->name);
+			return 1;
+		}
 	}
 
 	/* check if this resource has been manually set, if so skip */
@@ -224,78 +413,17 @@ static int pnp_assign_dma(struct pnp_dev
  */
 void pnp_init_resource_table(struct pnp_resource_table *table)
 {
-	int idx;
+	kfree(table->port_resource);
+	table->allocated_ports = 0;
 
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
+	kfree(table->mem_resource);
+	table->allocated_mems = 0;
 
-/**
- * pnp_clean_resources - clears resources that were not manually set
- * @res: the resources to clean
- */
-static void pnp_clean_resource_table(struct pnp_resource_table *res)
-{
-	int idx;
+	kfree(table->irq_resource);
+	table->allocated_irqs = 0;
 
-	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
-		if (!(res->irq_resource[idx].flags & IORESOURCE_AUTO))
-			continue;
-		res->irq_resource[idx].start = -1;
-		res->irq_resource[idx].end = -1;
-		res->irq_resource[idx].flags =
-		    IORESOURCE_IRQ | IORESOURCE_AUTO | IORESOURCE_UNSET;
-	}
-	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
-		if (!(res->dma_resource[idx].flags & IORESOURCE_AUTO))
-			continue;
-		res->dma_resource[idx].start = -1;
-		res->dma_resource[idx].end = -1;
-		res->dma_resource[idx].flags =
-		    IORESOURCE_DMA | IORESOURCE_AUTO | IORESOURCE_UNSET;
-	}
-	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
-		if (!(res->port_resource[idx].flags & IORESOURCE_AUTO))
-			continue;
-		res->port_resource[idx].start = 0;
-		res->port_resource[idx].end = 0;
-		res->port_resource[idx].flags =
-		    IORESOURCE_IO | IORESOURCE_AUTO | IORESOURCE_UNSET;
-	}
-	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
-		if (!(res->mem_resource[idx].flags & IORESOURCE_AUTO))
-			continue;
-		res->mem_resource[idx].start = 0;
-		res->mem_resource[idx].end = 0;
-		res->mem_resource[idx].flags =
-		    IORESOURCE_MEM | IORESOURCE_AUTO | IORESOURCE_UNSET;
-	}
+	kfree(table->dma_resource);
+	table->allocated_dmas = 0;
 }
 
 /**
@@ -317,7 +445,7 @@ static int pnp_assign_resources(struct p
 		return -ENODEV;
 
 	down(&pnp_res_mutex);
-	pnp_clean_resource_table(&dev->res);	/* start with a fresh slate */
+	pnp_init_resource_table(&dev->res);	/* start with a fresh slate */
 	if (dev->independent) {
 		port = dev->independent->port;
 		mem = dev->independent->mem;
@@ -391,7 +519,7 @@ static int pnp_assign_resources(struct p
 	return 1;
 
       fail:
-	pnp_clean_resource_table(&dev->res);
+	pnp_init_resource_table(&dev->res);
 	up(&pnp_res_mutex);
 	return 0;
 }
@@ -422,19 +550,19 @@ int pnp_manual_config_dev(struct pnp_dev
 	down(&pnp_res_mutex);
 	dev->res = *res;
 	if (!(mode & PNP_CONFIG_FORCE)) {
-		for (i = 0; i < PNP_MAX_PORT; i++) {
+		for (i = 0; pnp_port(dev, i); i++) {
 			if (!pnp_check_port(dev, i))
 				goto fail;
 		}
-		for (i = 0; i < PNP_MAX_MEM; i++) {
+		for (i = 0; pnp_mem(dev, i); i++) {
 			if (!pnp_check_mem(dev, i))
 				goto fail;
 		}
-		for (i = 0; i < PNP_MAX_IRQ; i++) {
+		for (i = 0; pnp_irq(dev, i); i++) {
 			if (!pnp_check_irq(dev, i))
 				goto fail;
 		}
-		for (i = 0; i < PNP_MAX_DMA; i++) {
+		for (i = 0; pnp_dma(dev, i); i++) {
 			if (!pnp_check_dma(dev, i))
 				goto fail;
 		}
@@ -581,7 +709,7 @@ int pnp_disable_dev(struct pnp_dev *dev)
 
 	/* release the resources so that other devices can use them */
 	down(&pnp_res_mutex);
-	pnp_clean_resource_table(&dev->res);
+	pnp_init_resource_table(&dev->res);
 	up(&pnp_res_mutex);
 
 	return 1;
Index: linux-2.6.23-rc3/drivers/pnp/interface.c
===================================================================
--- linux-2.6.23-rc3.orig/drivers/pnp/interface.c
+++ linux-2.6.23-rc3/drivers/pnp/interface.c
@@ -264,7 +264,7 @@ static ssize_t pnp_show_current_resource
 	else
 		pnp_printf(buffer, "disabled\n");
 
-	for (i = 0; i < PNP_MAX_PORT; i++) {
+	for (i = 0; pnp_port(dev, i); i++) {
 		if (pnp_port_valid(dev, i)) {
 			pnp_printf(buffer, "io");
 			if (pnp_port_flags(dev, i) & IORESOURCE_DISABLED)
@@ -277,7 +277,7 @@ static ssize_t pnp_show_current_resource
 									    i));
 		}
 	}
-	for (i = 0; i < PNP_MAX_MEM; i++) {
+	for (i = 0; pnp_mem(dev, i); i++) {
 		if (pnp_mem_valid(dev, i)) {
 			pnp_printf(buffer, "mem");
 			if (pnp_mem_flags(dev, i) & IORESOURCE_DISABLED)
@@ -290,7 +290,7 @@ static ssize_t pnp_show_current_resource
 									   i));
 		}
 	}
-	for (i = 0; i < PNP_MAX_IRQ; i++) {
+	for (i = 0; pnp_irq(dev, i); i++) {
 		if (pnp_irq_valid(dev, i)) {
 			pnp_printf(buffer, "irq");
 			if (pnp_irq_flags(dev, i) & IORESOURCE_DISABLED)
@@ -301,7 +301,7 @@ static ssize_t pnp_show_current_resource
 					   pnp_irq_start(dev, i));
 		}
 	}
-	for (i = 0; i < PNP_MAX_DMA; i++) {
+	for (i = 0; pnp_dma(dev, i); i++) {
 		if (pnp_dma_valid(dev, i)) {
 			pnp_printf(buffer, "dma");
 			if (pnp_dma_flags(dev, i) & IORESOURCE_DISABLED)
@@ -326,6 +326,7 @@ pnp_set_current_resources(struct device 
 	struct pnp_dev *dev = to_pnp_dev(dmdev);
 	char *buf = (void *)ubuf;
 	int retval = 0;
+	struct resource res;
 
 	if (dev->status & PNP_ATTACHED) {
 		retval = -EBUSY;
@@ -371,7 +372,6 @@ pnp_set_current_resources(struct device 
 		goto done;
 	}
 	if (!strnicmp(buf, "set", 3)) {
-		int nport = 0, nmem = 0, nirq = 0, ndma = 0;
 		if (dev->active)
 			goto done;
 		buf += 3;
@@ -384,76 +384,55 @@ pnp_set_current_resources(struct device 
 				buf += 2;
 				while (isspace(*buf))
 					++buf;
-				pnp_port_start(dev, nport) =
-				    simple_strtoul(buf, &buf, 0);
+				res.start = simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
 				if (*buf == '-') {
 					buf += 1;
 					while (isspace(*buf))
 						++buf;
-					pnp_port_end(dev, nport) =
-						simple_strtoul(buf, &buf, 0);
+					res.end = simple_strtoul(buf, &buf, 0);
 				} else
-					pnp_port_end(dev, nport) =
-						pnp_port_start(dev, nport);
-				pnp_port_flags(dev, nport) =
-				    IORESOURCE_IO;
-				nport++;
-				if (nport >= PNP_MAX_PORT)
-					break;
+					res.end = res.start;
+				res.flags = IORESOURCE_IO;
+				pnp_assign_resource(&dev->res, &res);
 				continue;
 			}
 			if (!strnicmp(buf, "mem", 3)) {
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				pnp_mem_start(dev, nmem) =
-					simple_strtoul(buf, &buf, 0);
+				res.start = simple_strtoul(buf, &buf, 0);
 				while (isspace(*buf))
 					++buf;
 				if (*buf == '-') {
 					buf += 1;
 					while (isspace(*buf))
 						++buf;
-					pnp_mem_end(dev, nmem) =
-						simple_strtoul(buf, &buf, 0);
+					res.end = simple_strtoul(buf, &buf, 0);
 				} else
-					pnp_mem_end(dev, nmem) =
-					    pnp_mem_start(dev, nmem);
-				pnp_mem_flags(dev, nmem) =
-					IORESOURCE_MEM;
-				nmem++;
-				if (nmem >= PNP_MAX_MEM)
-					break;
+					res.end = res.start;
+				res.flags = IORESOURCE_MEM;
+				pnp_assign_resource(&dev->res, &res);
 				continue;
 			}
 			if (!strnicmp(buf, "irq", 3)) {
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				pnp_irq_start(dev, nirq) =
-					pnp_irq_end(dev, nirq) =
-					simple_strtoul(buf, &buf, 0);
-				pnp_irq_flags(dev, nirq) =
-					IORESOURCE_IRQ;
-				nirq++;
-				if (nirq >= PNP_MAX_IRQ)
-					break;
+				res.start = res.end =
+				    simple_strtoul(buf, &buf, 0);
+				res.flags = IORESOURCE_IRQ;
+				pnp_assign_resource(&dev->res, &res);
 				continue;
 			}
 			if (!strnicmp(buf, "dma", 3)) {
 				buf += 3;
 				while (isspace(*buf))
 					++buf;
-				pnp_dma_start(dev, ndma) =
-					pnp_dma_end(dev, ndma) =
-					simple_strtoul(buf, &buf, 0);
-				pnp_dma_flags(dev, ndma) =
-					IORESOURCE_DMA;
-				ndma++;
-				if (ndma >= PNP_MAX_DMA)
-					break;
+				res.start = res.end =
+				    simple_strtoul(buf, &buf, 0);
+				res.flags = IORESOURCE_DMA;
 				continue;
 			}
 			break;
Index: linux-2.6.23-rc3/drivers/pnp/quirks.c
===================================================================
--- linux-2.6.23-rc3.orig/drivers/pnp/quirks.c
+++ linux-2.6.23-rc3/drivers/pnp/quirks.c
@@ -138,6 +138,11 @@ static void quirk_smc_enable(struct pnp_
 {
 	struct resource fir, sir, irq;
 
+	if (dev->res.allocated_ports <= 1 || dev->res.allocated_irqs <= 0) {
+		pnp_err("IRQ/Ports not assigned, quirk needs fixup, try"
+			" smsc_nopnp boot param");
+	}
+
 	pnp_activate_dev(dev);
 	if (quirk_smc_fir_enabled(dev))
 		return;
@@ -182,20 +187,21 @@ static void quirk_smc_enable(struct pnp_
 	 * Clear IORESOURCE_AUTO so pnp_activate_dev() doesn't reassign
 	 * these resources any more.
 	 */
-	fir = dev->res.port_resource[0];
-	sir = dev->res.port_resource[1];
+	fir = *pnp_port(dev, 0);
+	sir = *pnp_port(dev, 1);
 	fir.flags &= ~IORESOURCE_AUTO;
 	sir.flags &= ~IORESOURCE_AUTO;
 
-	irq = dev->res.irq_resource[0];
+	sir = *pnp_irq(dev, 0);
+	/* TBD: Why do we get a compile warning here but not above? */
 	irq.flags &= ~IORESOURCE_AUTO;
 	irq.flags &= ~IORESOURCE_BITS;
 	irq.flags |= IORESOURCE_IRQ_LOWEDGE;
 
 	pnp_disable_dev(dev);
-	dev->res.port_resource[0] = sir;
-	dev->res.port_resource[1] = fir;
-	dev->res.irq_resource[0] = irq;
+	*pnp_port(dev, 0) = sir;
+	*pnp_port(dev, 1) = fir;
+	*pnp_irq(dev, 0) = irq;
 	pnp_activate_dev(dev);
 
 	if (quirk_smc_fir_enabled(dev)) {
Index: linux-2.6.23-rc3/drivers/pnp/resource.c
===================================================================
--- linux-2.6.23-rc3.orig/drivers/pnp/resource.c
+++ linux-2.6.23-rc3/drivers/pnp/resource.c
@@ -19,10 +19,10 @@
 #include <linux/pnp.h>
 #include "base.h"
 
-static int pnp_reserve_irq[16] = {[0...15] = -1 };	/* reserve (don't use) some IRQ */
-static int pnp_reserve_dma[8] = {[0...7] = -1 };	/* reserve (don't use) some DMA */
-static int pnp_reserve_io[16] = {[0...15] = -1 };	/* reserve (don't use) some I/O region */
-static int pnp_reserve_mem[16] = {[0...15] = -1 };	/* reserve (don't use) some memory region */
+static int pnp_reserve_irq[16] = {[0 ... 15] = -1 };	/* reserve (don't use) some IRQ */
+static int pnp_reserve_dma[8] = {[0 ... 7] = -1 };	/* reserve (don't use) some DMA */
+static int pnp_reserve_io[16] = {[0 ... 15] = -1 };	/* reserve (don't use) some I/O region */
+static int pnp_reserve_mem[16] = {[0 ... 15] = -1 };	/* reserve (don't use) some memory region */
 
 /*
  * option registration
@@ -260,6 +260,7 @@ int pnp_check_port(struct pnp_dev *dev, 
 	}
 
 	/* check if the resource is reserved */
+	/* TBD: Check more as we now might have more than 8 ports? */
 	for (tmp = 0; tmp < 8; tmp++) {
 		int rport = pnp_reserve_io[tmp << 1];
 		int rend = pnp_reserve_io[(tmp << 1) + 1] + rport - 1;
@@ -268,7 +269,7 @@ int pnp_check_port(struct pnp_dev *dev, 
 	}
 
 	/* check for internal conflicts */
-	for (tmp = 0; tmp < PNP_MAX_PORT && tmp != idx; tmp++) {
+	for (tmp = 0; pnp_port(dev, tmp) && tmp != idx; tmp++) {
 		if (pnp_port_flags(dev, tmp) & IORESOURCE_IO) {
 			tport = &pnp_port_start(dev, tmp);
 			tend = &pnp_port_end(dev, tmp);
@@ -281,7 +282,7 @@ int pnp_check_port(struct pnp_dev *dev, 
 	pnp_for_each_dev(tdev) {
 		if (tdev == dev)
 			continue;
-		for (tmp = 0; tmp < PNP_MAX_PORT; tmp++) {
+		for (tmp = 0; pnp_port(tdev, tmp); tmp++) {
 			if (pnp_port_flags(tdev, tmp) & IORESOURCE_IO) {
 				if (cannot_compare(pnp_port_flags(tdev, tmp)))
 					continue;
@@ -325,7 +326,7 @@ int pnp_check_mem(struct pnp_dev *dev, i
 	}
 
 	/* check for internal conflicts */
-	for (tmp = 0; tmp < PNP_MAX_MEM && tmp != idx; tmp++) {
+	for (tmp = 0; pnp_mem(dev, tmp) && tmp != idx; tmp++) {
 		if (pnp_mem_flags(dev, tmp) & IORESOURCE_MEM) {
 			taddr = &pnp_mem_start(dev, tmp);
 			tend = &pnp_mem_end(dev, tmp);
@@ -338,7 +339,7 @@ int pnp_check_mem(struct pnp_dev *dev, i
 	pnp_for_each_dev(tdev) {
 		if (tdev == dev)
 			continue;
-		for (tmp = 0; tmp < PNP_MAX_MEM; tmp++) {
+		for (tmp = 0; pnp_mem(tdev, tmp); tmp++) {
 			if (pnp_mem_flags(tdev, tmp) & IORESOURCE_MEM) {
 				if (cannot_compare(pnp_mem_flags(tdev, tmp)))
 					continue;
@@ -379,7 +380,7 @@ int pnp_check_irq(struct pnp_dev *dev, i
 	}
 
 	/* check for internal conflicts */
-	for (tmp = 0; tmp < PNP_MAX_IRQ && tmp != idx; tmp++) {
+	for (tmp = 0; pnp_irq(dev, tmp) && tmp != idx; tmp++) {
 		if (pnp_irq_flags(dev, tmp) & IORESOURCE_IRQ) {
 			if (pnp_irq_start(dev, tmp) == *irq)
 				return 0;
@@ -410,7 +411,7 @@ int pnp_check_irq(struct pnp_dev *dev, i
 	pnp_for_each_dev(tdev) {
 		if (tdev == dev)
 			continue;
-		for (tmp = 0; tmp < PNP_MAX_IRQ; tmp++) {
+		for (tmp = 0; pnp_irq(tdev, tmp); tmp++) {
 			if (pnp_irq_flags(tdev, tmp) & IORESOURCE_IRQ) {
 				if (cannot_compare(pnp_irq_flags(tdev, tmp)))
 					continue;
@@ -445,7 +446,7 @@ int pnp_check_dma(struct pnp_dev *dev, i
 	}
 
 	/* check for internal conflicts */
-	for (tmp = 0; tmp < PNP_MAX_DMA && tmp != idx; tmp++) {
+	for (tmp = 0; pnp_mem(dev, tmp) && tmp != idx; tmp++) {
 		if (pnp_mem_flags(dev, tmp) & IORESOURCE_DMA) {
 			if (pnp_mem_start(dev, tmp) == *dma)
 				return 0;
@@ -464,7 +465,7 @@ int pnp_check_dma(struct pnp_dev *dev, i
 	pnp_for_each_dev(tdev) {
 		if (tdev == dev)
 			continue;
-		for (tmp = 0; tmp < PNP_MAX_DMA; tmp++) {
+		for (tmp = 0; pnp_mem(tdev, tmp); tmp++) {
 			if (pnp_mem_flags(tdev, tmp) & IORESOURCE_DMA) {
 				if (cannot_compare(pnp_mem_flags(tdev, tmp)))
 					continue;
Index: linux-2.6.23-rc3/drivers/pnp/system.c
===================================================================
--- linux-2.6.23-rc3.orig/drivers/pnp/system.c
+++ linux-2.6.23-rc3/drivers/pnp/system.c
@@ -55,7 +55,7 @@ static void reserve_resources_of_dev(con
 {
 	int i;
 
-	for (i = 0; i < PNP_MAX_PORT; i++) {
+	for (i = 0; pnp_port(dev, i); i++) {
 		if (!pnp_port_valid(dev, i))
 			continue;
 		if (pnp_port_start(dev, i) == 0)
@@ -77,7 +77,7 @@ static void reserve_resources_of_dev(con
 			      pnp_port_end(dev, i), 1);
 	}
 
-	for (i = 0; i < PNP_MAX_MEM; i++) {
+	for (i = 0; pnp_mem(dev, i); i++) {
 		if (!pnp_mem_valid(dev, i))
 			continue;
 
@@ -94,10 +94,10 @@ static int system_pnp_probe(struct pnp_d
 }
 
 static struct pnp_driver system_pnp_driver = {
-	.name     = "system",
+	.name = "system",
 	.id_table = pnp_dev_table,
-	.flags    = PNP_DRIVER_RES_DO_NOT_CHANGE,
-	.probe    = system_pnp_probe,
+	.flags = PNP_DRIVER_RES_DO_NOT_CHANGE,
+	.probe = system_pnp_probe,
 };
 
 static int __init pnp_system_init(void)
Index: linux-2.6.23-rc3/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- linux-2.6.23-rc3.orig/drivers/pnp/pnpacpi/rsparser.c
+++ linux-2.6.23-rc3/drivers/pnp/pnpacpi/rsparser.c
@@ -75,32 +75,31 @@ static void pnpacpi_parse_allocated_irqr
 						u32 gsi, int triggering,
 						int polarity, int shareable)
 {
-	int i = 0;
 	int irq;
+	struct resource new_res = {
+		.flags = IORESOURCE_IRQ,
+	};
 
 	if (!valid_IRQ(gsi))
 		return;
 
-	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET) &&
-	       i < PNP_MAX_IRQ)
-		i++;
-	if (i >= PNP_MAX_IRQ)
-		return;
-
-	res->irq_resource[i].flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
-	res->irq_resource[i].flags |= irq_flags(triggering, polarity);
+	new_res.flags |= irq_flags(triggering, polarity);
 	irq = acpi_register_gsi(gsi, triggering, polarity);
 	if (irq < 0) {
-		res->irq_resource[i].flags |= IORESOURCE_DISABLED;
+		new_res.flags |= IORESOURCE_DISABLED;
+		if (pnp_assign_resource(res, &new_res))
+			pnp_err("Bug in %s", __FUNCTION__);
 		return;
 	}
 
 	if (shareable)
-		res->irq_resource[i].flags |= IORESOURCE_IRQ_SHAREABLE;
+		new_res.flags |= IORESOURCE_IRQ_SHAREABLE;
 
-	res->irq_resource[i].start = irq;
-	res->irq_resource[i].end = irq;
+	new_res.start = irq;
+	new_res.end = irq;
 	pcibios_penalize_isa_irq(irq, 1);
+	if (pnp_assign_resource(res, &new_res))
+		pnp_err("Bug in %s", __FUNCTION__);
 }
 
 static int dma_flags(int type, int bus_master, int transfer)
@@ -150,69 +149,69 @@ static void pnpacpi_parse_allocated_dmar
 						u32 dma, int type,
 						int bus_master, int transfer)
 {
-	int i = 0;
-
-	while (i < PNP_MAX_DMA &&
-	       !(res->dma_resource[i].flags & IORESOURCE_UNSET))
-		i++;
-	if (i < PNP_MAX_DMA) {
-		res->dma_resource[i].flags = IORESOURCE_DMA;	// Also clears _UNSET flag
-		res->dma_resource[i].flags |=
-		    dma_flags(type, bus_master, transfer);
-		if (dma == -1) {
-			res->dma_resource[i].flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		res->dma_resource[i].start = dma;
-		res->dma_resource[i].end = dma;
+	struct resource new_res = {
+		.flags = IORESOURCE_DMA,
+	};
+
+	new_res.flags |= dma_flags(type, bus_master, transfer);
+	if (dma == -1) {
+		new_res.flags |= IORESOURCE_DISABLED;
+		if (pnp_assign_resource(res, &new_res))
+			pnp_err("Bug in %s", __FUNCTION__);
+		return;
 	}
+	new_res.start = dma;
+	new_res.end = dma;
+	if (pnp_assign_resource(res, &new_res))
+		pnp_err("Bug in %s", __FUNCTION__);
 }
 
 static void pnpacpi_parse_allocated_ioresource(struct pnp_resource_table *res,
 					       u64 io, u64 len, int io_decode)
 {
-	int i = 0;
-
-	while (!(res->port_resource[i].flags & IORESOURCE_UNSET) &&
-	       i < PNP_MAX_PORT)
-		i++;
-	if (i < PNP_MAX_PORT) {
-		res->port_resource[i].flags = IORESOURCE_IO;	// Also clears _UNSET flag
-		if (io_decode == ACPI_DECODE_16)
-			res->port_resource[i].flags |= PNP_PORT_FLAG_16BITADDR;
-		if (len <= 0 || (io + len - 1) >= 0x10003) {
-			res->port_resource[i].flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		res->port_resource[i].start = io;
-		res->port_resource[i].end = io + len - 1;
-	}
+	struct resource new_res = {
+		.flags = IORESOURCE_IO,
+	};
+
+	if (io_decode == ACPI_DECODE_16)
+		new_res.flags |= PNP_PORT_FLAG_16BITADDR;
+	if (len <= 0 || (io + len - 1) >= 0x10003) {
+		new_res.flags |= IORESOURCE_DISABLED;
+		if (pnp_assign_resource(res, &new_res))
+			pnp_err("Bug in %s", __FUNCTION__);
+		return;
+	}
+	new_res.start = io;
+	new_res.end = io + len - 1;
+	if (pnp_assign_resource(res, &new_res))
+		pnp_err("Bug in %s", __FUNCTION__);
 }
 
 static void pnpacpi_parse_allocated_memresource(struct pnp_resource_table *res,
 						u64 mem, u64 len,
 						int write_protect)
 {
-	int i = 0;
+	struct resource new_res = {
+		.flags = IORESOURCE_MEM,
+	};
 
-	while (!(res->mem_resource[i].flags & IORESOURCE_UNSET) &&
-	       (i < PNP_MAX_MEM))
-		i++;
-	if (i < PNP_MAX_MEM) {
-		res->mem_resource[i].flags = IORESOURCE_MEM;	// Also clears _UNSET flag
-		if (len <= 0) {
-			res->mem_resource[i].flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		if (write_protect == ACPI_READ_WRITE_MEMORY)
-			res->mem_resource[i].flags |= IORESOURCE_MEM_WRITEABLE;
-
-		res->mem_resource[i].start = mem;
-		res->mem_resource[i].end = mem + len - 1;
+	if (len <= 0) {
+		new_res.flags |= IORESOURCE_DISABLED;
+		if (pnp_assign_resource(res, &new_res))
+			pnp_err("Bug in %s", __FUNCTION__);
+		return;
 	}
+	if (write_protect == ACPI_READ_WRITE_MEMORY)
+		new_res.flags |= IORESOURCE_MEM_WRITEABLE;
+
+	new_res.start = mem;
+	new_res.end = mem + len - 1;
+	if (pnp_assign_resource(res, &new_res))
+		pnp_err("Bug in %s", __FUNCTION__);
 }
 
-static void pnpacpi_parse_allocated_address_space(struct pnp_resource_table *res_table,
+static void pnpacpi_parse_allocated_address_space(struct pnp_resource_table
+						  *res_table,
 						  struct acpi_resource *res)
 {
 	struct acpi_resource_address64 addr, *p = &addr;
@@ -230,13 +229,16 @@ static void pnpacpi_parse_allocated_addr
 
 	if (p->resource_type == ACPI_MEMORY_RANGE)
 		pnpacpi_parse_allocated_memresource(res_table,
-			p->minimum, p->address_length,
-			p->info.mem.write_protect);
+						    p->minimum,
+						    p->address_length,
+						    p->info.mem.write_protect);
 	else if (p->resource_type == ACPI_IO_RANGE)
 		pnpacpi_parse_allocated_ioresource(res_table,
-			p->minimum, p->address_length,
-			p->granularity == 0xfff ? ACPI_DECODE_10 :
-				ACPI_DECODE_16);
+						   p->minimum,
+						   p->address_length,
+						   p->granularity ==
+						   0xfff ? ACPI_DECODE_10 :
+						   ACPI_DECODE_16);
 }
 
 static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
@@ -254,27 +256,35 @@ static acpi_status pnpacpi_allocated_res
 		 */
 		for (i = 0; i < res->data.irq.interrupt_count; i++) {
 			pnpacpi_parse_allocated_irqresource(res_table,
-				res->data.irq.interrupts[i],
-				res->data.irq.triggering,
-				res->data.irq.polarity,
-				res->data.irq.sharable);
+							    res->data.irq.
+							    interrupts[i],
+							    res->data.irq.
+							    triggering,
+							    res->data.irq.
+							    polarity,
+							    res->data.irq.
+							    sharable);
 		}
 		break;
 
 	case ACPI_RESOURCE_TYPE_DMA:
 		if (res->data.dma.channel_count > 0)
 			pnpacpi_parse_allocated_dmaresource(res_table,
-				res->data.dma.channels[0],
-				res->data.dma.type,
-				res->data.dma.bus_master,
-				res->data.dma.transfer);
+							    res->data.dma.
+							    channels[0],
+							    res->data.dma.type,
+							    res->data.dma.
+							    bus_master,
+							    res->data.dma.
+							    transfer);
 		break;
 
 	case ACPI_RESOURCE_TYPE_IO:
+		pnp_dbg("Adding resource: 0x%x", res->data.io.minimum);
 		pnpacpi_parse_allocated_ioresource(res_table,
-			res->data.io.minimum,
-			res->data.io.address_length,
-			res->data.io.io_decode);
+						   res->data.io.minimum,
+						   res->data.io.address_length,
+						   res->data.io.io_decode);
 		break;
 
 	case ACPI_RESOURCE_TYPE_START_DEPENDENT:
@@ -283,9 +293,10 @@ static acpi_status pnpacpi_allocated_res
 
 	case ACPI_RESOURCE_TYPE_FIXED_IO:
 		pnpacpi_parse_allocated_ioresource(res_table,
-			res->data.fixed_io.address,
-			res->data.fixed_io.address_length,
-			ACPI_DECODE_10);
+						   res->data.fixed_io.address,
+						   res->data.fixed_io.
+						   address_length,
+						   ACPI_DECODE_10);
 		break;
 
 	case ACPI_RESOURCE_TYPE_VENDOR:
@@ -296,21 +307,28 @@ static acpi_status pnpacpi_allocated_res
 
 	case ACPI_RESOURCE_TYPE_MEMORY24:
 		pnpacpi_parse_allocated_memresource(res_table,
-			res->data.memory24.minimum,
-			res->data.memory24.address_length,
-			res->data.memory24.write_protect);
+						    res->data.memory24.minimum,
+						    res->data.memory24.
+						    address_length,
+						    res->data.memory24.
+						    write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_MEMORY32:
 		pnpacpi_parse_allocated_memresource(res_table,
-			res->data.memory32.minimum,
-			res->data.memory32.address_length,
-			res->data.memory32.write_protect);
+						    res->data.memory32.minimum,
+						    res->data.memory32.
+						    address_length,
+						    res->data.memory32.
+						    write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
 		pnpacpi_parse_allocated_memresource(res_table,
-			res->data.fixed_memory32.address,
-			res->data.fixed_memory32.address_length,
-			res->data.fixed_memory32.write_protect);
+						    res->data.fixed_memory32.
+						    address,
+						    res->data.fixed_memory32.
+						    address_length,
+						    res->data.fixed_memory32.
+						    write_protect);
 		break;
 	case ACPI_RESOURCE_TYPE_ADDRESS16:
 	case ACPI_RESOURCE_TYPE_ADDRESS32:
@@ -329,10 +347,18 @@ static acpi_status pnpacpi_allocated_res
 
 		for (i = 0; i < res->data.extended_irq.interrupt_count; i++) {
 			pnpacpi_parse_allocated_irqresource(res_table,
-				res->data.extended_irq.interrupts[i],
-				res->data.extended_irq.triggering,
-				res->data.extended_irq.polarity,
-				res->data.extended_irq.sharable);
+							    res->data.
+							    extended_irq.
+							    interrupts[i],
+							    res->data.
+							    extended_irq.
+							    triggering,
+							    res->data.
+							    extended_irq.
+							    polarity,
+							    res->data.
+							    extended_irq.
+							    sharable);
 		}
 		break;
 
@@ -495,8 +521,8 @@ static void pnpacpi_parse_mem32_option(s
 	pnp_register_mem_resource(option, mem);
 }
 
-static void pnpacpi_parse_fixed_mem32_option(struct pnp_option *option,
-					 struct acpi_resource_fixed_memory32 *p)
+static void pnpacpi_parse_fixed_mem32_option(struct pnp_option *option, struct acpi_resource_fixed_memory32
+					     *p)
 {
 	struct pnp_mem *mem;
 
Index: linux-2.6.23-rc3/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- linux-2.6.23-rc3.orig/drivers/pnp/pnpbios/rsparser.c
+++ linux-2.6.23-rc3/drivers/pnp/pnpbios/rsparser.c
@@ -14,7 +14,7 @@
 inline void pcibios_penalize_isa_irq(int irq, int active)
 {
 }
-#endif				/* CONFIG_PCI */
+#endif /* CONFIG_PCI */
 
 #include "pnpbios.h"
 
@@ -56,78 +56,77 @@ inline void pcibios_penalize_isa_irq(int
 static void pnpbios_parse_allocated_irqresource(struct pnp_resource_table *res,
 						int irq)
 {
-	int i = 0;
+	struct resource new_res = {
+		.flags = IORESOURCE_IRQ,
+	}
 
-	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET)
-	       && i < PNP_MAX_IRQ)
-		i++;
-	if (i < PNP_MAX_IRQ) {
-		res->irq_resource[i].flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
-		if (irq == -1) {
-			res->irq_resource[i].flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		res->irq_resource[i].start =
-		    res->irq_resource[i].end = (unsigned long)irq;
-		pcibios_penalize_isa_irq(irq, 1);
+	if (irq == -1) {
+		res->irq_resource[i].flags |= IORESOURCE_DISABLED;
+		if (pnp_assign_resource(res, &new_res))
+			pnp_err("Bug in %s", __FUNCTION__);
+		return;
 	}
+	res->irq_resource[i].start =
+	    res->irq_resource[i].end = (unsigned long)irq;
+	pcibios_penalize_isa_irq(irq, 1);
+	if (pnp_assign_resource(res, &new_res))
+		pnp_err("Bug in %s", __FUNCTION__);
 }
 
 static void pnpbios_parse_allocated_dmaresource(struct pnp_resource_table *res,
 						int dma)
 {
-	int i = 0;
+	struct resource new_res = {
+		.flags = IORESOURCE_DMA,
+	}
 
-	while (i < PNP_MAX_DMA &&
-	       !(res->dma_resource[i].flags & IORESOURCE_UNSET))
-		i++;
-	if (i < PNP_MAX_DMA) {
-		res->dma_resource[i].flags = IORESOURCE_DMA;	// Also clears _UNSET flag
-		if (dma == -1) {
-			res->dma_resource[i].flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		res->dma_resource[i].start =
-		    res->dma_resource[i].end = (unsigned long)dma;
+	if (dma == -1) {
+		new_res.flags |= IORESOURCE_DISABLED;
+		if (pnp_assign_resource(res, &new_res))
+			pnp_err("Bug in %s", __FUNCTION__);
+		return;
 	}
+	new_res.start = new_res.end = (unsigned long)dma;
+	if (pnp_assign_resource(res, &new_res))
+		pnp_err("Bug in %s", __FUNCTION__);
 }
 
 static void pnpbios_parse_allocated_ioresource(struct pnp_resource_table *res,
 					       int io, int len)
 {
-	int i = 0;
+	struct resource new_res = {
+		.flags = IORESOURCE_IO,
+	}
 
-	while (!(res->port_resource[i].flags & IORESOURCE_UNSET)
-	       && i < PNP_MAX_PORT)
-		i++;
-	if (i < PNP_MAX_PORT) {
-		res->port_resource[i].flags = IORESOURCE_IO;	// Also clears _UNSET flag
-		if (len <= 0 || (io + len - 1) >= 0x10003) {
-			res->port_resource[i].flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		res->port_resource[i].start = (unsigned long)io;
-		res->port_resource[i].end = (unsigned long)(io + len - 1);
+	if (len <= 0 || (io + len - 1) >= 0x10003) {
+		new_res.flags |= IORESOURCE_DISABLED;
+		if (pnp_assign_resource(res, &new_res))
+			pnp_err("Bug in %s", __FUNCTION__);
+		return;
 	}
+	new_res.start = (unsigned long)io;
+	new_res.end = (unsigned long)(io + len - 1);
+	if (pnp_assign_resource(res, &new_res))
+		pnp_err("Bug in %s", __FUNCTION__);
 }
 
 static void pnpbios_parse_allocated_memresource(struct pnp_resource_table *res,
 						int mem, int len)
 {
-	int i = 0;
+	struct resource new_res = {
+		.flags = IORESOURCE_MEM,
+	}
 
-	while (!(res->mem_resource[i].flags & IORESOURCE_UNSET)
-	       && i < PNP_MAX_MEM)
-		i++;
-	if (i < PNP_MAX_MEM) {
-		res->mem_resource[i].flags = IORESOURCE_MEM;	// Also clears _UNSET flag
-		if (len <= 0) {
-			res->mem_resource[i].flags |= IORESOURCE_DISABLED;
-			return;
-		}
-		res->mem_resource[i].start = (unsigned long)mem;
-		res->mem_resource[i].end = (unsigned long)(mem + len - 1);
+	if (len <= 0) {
+		new_res.flags |= IORESOURCE_DISABLED;
+		if (pnp_assign_resource(res, &new_res))
+			pnp_err("Bug in %s", __FUNCTION__);
+		return;
 	}
+	new_res.start = (unsigned long)mem;
+	new_res.end = (unsigned long)(mem + len - 1);
+	if (pnp_assign_resource(res, &new_res))
+		pnp_err("Bug in %s", __FUNCTION__);
 }
 
 static unsigned char *pnpbios_parse_allocated_resource_data(unsigned char *p,
Index: linux-2.6.23-rc3/drivers/pnp/core.c
===================================================================
--- linux-2.6.23-rc3.orig/drivers/pnp/core.c
+++ linux-2.6.23-rc3/drivers/pnp/core.c
@@ -132,6 +132,10 @@ int __pnp_add_device(struct pnp_dev *dev
 	ret = device_register(&dev->dev);
 	if (ret == 0)
 		pnp_interface_attach_device(dev);
+	pnp_dump_ports(dev);
+	pnp_dump_mems(dev);
+	pnp_dump_irqs(dev);
+	pnp_dump_dmas(dev);
 	return ret;
 }
 


