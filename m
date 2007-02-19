Return-Path: <linux-kernel-owner+w=401wt.eu-S932264AbXBSOSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbXBSOSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932278AbXBSOSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:18:49 -0500
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:2596 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932264AbXBSOSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:18:48 -0500
Date: Mon, 19 Feb 2007 15:18:47 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [patch/rfc 2.6.20-git] parport reports physical devices
Message-Id: <20070219151847.853c7035.khali@linux-fr.org>
In-Reply-To: <200702182108.08217.david-b@pacbell.net>
References: <200702182108.08217.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sun, 18 Feb 2007 21:08:07 -0800, David Brownell wrote:
> Currently a parport_driver can't get a handle on the device node for the
> underlying parport (PNPACPI, PCI, etc).  That prevents correct placement
> of sysfs child nodes, which can affect things like power management.
> 
> This patch resolves that issue for non-legacy configurations:
> 
>     * "struct parport" now has a field pointing to that device node,
>       and non-legacy port drivers now initialize that device pointer:
> 	- parport_mfc3 (can't test or build; no Amiga + Zorro here)
> 	- parport_pc (and stop using only pci_device internally)

Only in the PCI and PNP cases. Super-I/O and legacy cases still don't
have a valid device pointer to pass. This annoys me because the laptop
I'm using for my daily work has such a legacy parallel port, which I
use with the i2c-parport driver. Right now your patch is a no-op for
me :( More on that below.

> 	- parport_serial
> 	- parport_sunbpp (can't test or build, no SPARC + SBUS here)
> 
>     * pnp now initializes device dma masks (24bits), preventing oopses
>       when generic dma calls are made using pnp device nodes

The patch is quite large and I fail to see the relation between the dma
mask bug and the original purpose of the patch. Can you possibly split
the dma fixes to a separate patch? So we can get this part in the
kernel faster.

> 
>     * some of the layered parport_driver code now uses that pointer:
> 	- i2c-parport (parent of i2c_adapter)
> 	- spi_butterfly (parent of spi_master, allowing cruft removal)

Yes, the cleanups in the spi_butterfly driver are quite nice :) They
didn't apply cleanly on my tree though, I guess you have some local
changes.

> 	- lp (creating class_device)
> 	- ppdev (parent of parportN device)
> 	- tipar (creating class_device)
> 
> Sanity tested on a PC, where PNPACPI provides the device to parport_pc,
> using spi_butterfly.  But I've got to wonder about parport DMA...

Tested on my other machine with has a PNP parallel port too, and it
worked fine. Great :)

> 
> There are still drivers that should be updated, like some of the input
> drivers; but they won't be any worse off than they are today.  And the
> legacy port drivers should, like all legacy drivers, be morphed into
> proper driver model code ... but until that happens, drivers need to
> be prepared for the device node to be null.

True.

> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> ---
>  drivers/char/lp.c                |    2 +-
>  drivers/char/ppdev.c             |    2 +-
>  drivers/char/tipar.c             |    2 +-
>  drivers/i2c/busses/i2c-parport.c |    3 ++-
>  drivers/parport/parport_mfc3.c   |    1 +
>  drivers/parport/parport_pc.c     |   31 +++++++++++++++++--------------
>  drivers/parport/parport_serial.c |    2 +-
>  drivers/parport/parport_sunbpp.c |    1 +
>  drivers/pnp/core.c               |    3 +++
>  drivers/spi/spi_butterfly.c      |   25 ++++++++-----------------
>  include/linux/parport.h          |    8 ++++++--
>  include/linux/parport_pc.h       |    3 +--
>  include/linux/pnp.h              |    1 +
>  13 files changed, 44 insertions(+), 40 deletions(-)
> 
> Index: g26/include/linux/parport.h
> ===================================================================
> --- g26.orig/include/linux/parport.h	2006-10-13 15:41:24.000000000 -0700
> +++ g26/include/linux/parport.h	2007-02-18 14:11:01.000000000 -0800
> @@ -279,6 +279,10 @@ struct parport {
>  	int dma;
>  	int muxport;		/* which muxport (if any) this is */
>  	int portnum;		/* which physical parallel port (not mux) */
> +	struct device *dev;	/* Physical device associated with IO/DMA.
> +				 * This may unfortulately be null if the
> +				 * port has a legacy driver.
> +				 */
>  
>  	struct parport *physport;
>  				/* If this is a non-default mux
> @@ -289,7 +293,7 @@ struct parport {
>  				   following structure members are
>  				   meaningless: devices, cad, muxsel,
>  				   waithead, waittail, flags, pdir,
> -				   ieee1284, *_lock.
> +				   dev, ieee1284, *_lock.
>  
>  				   It this is a default mux parport, or
>  				   there is no mux involved, this points to
> @@ -302,7 +306,7 @@ struct parport {
>  
>  	struct pardevice *waithead;
>  	struct pardevice *waittail;
> -	
> +
>  	struct list_head list;
>  	unsigned int flags;
>  
> Index: g26/include/linux/parport_pc.h
> ===================================================================
> --- g26.orig/include/linux/parport_pc.h	2006-01-14 18:12:27.000000000 -0800
> +++ g26/include/linux/parport_pc.h	2007-02-18 13:12:21.000000000 -0800
> @@ -38,7 +38,6 @@ struct parport_pc_private {
>  	/* buffer suitable for DMA, if DMA enabled */
>  	char *dma_buf;
>  	dma_addr_t dma_handle;
> -	struct pci_dev *dev;
>  	struct list_head list;
>  	struct parport *port;
>  };
> @@ -232,7 +231,7 @@ extern int parport_pc_claim_resources(st
>  extern struct parport *parport_pc_probe_port (unsigned long base,
>  					      unsigned long base_hi,
>  					      int irq, int dma,
> -					      struct pci_dev *dev);
> +					      struct device *dev);
>  extern void parport_pc_unregister_port (struct parport *p);
>  
>  #endif
> Index: g26/drivers/parport/parport_pc.c
> ===================================================================
> --- g26.orig/drivers/parport/parport_pc.c	2006-12-07 23:00:32.000000000 -0800
> +++ g26/drivers/parport/parport_pc.c	2007-02-18 20:43:02.000000000 -0800
> @@ -620,6 +620,7 @@ static size_t parport_pc_fifo_write_bloc
>  	unsigned long dmaflag;
>  	size_t left = length;
>  	const struct parport_pc_private *priv = port->physport->private_data;
> +	struct device *dev = port->physport->dev;
>  	dma_addr_t dma_addr, dma_handle;
>  	size_t maxlen = 0x10000; /* max 64k per DMA transfer */
>  	unsigned long start = (unsigned long) buf;
> @@ -631,8 +632,8 @@ dump_parport_state ("enter fifo_write_bl
>  		if ((start ^ end) & ~0xffffUL)
>  			maxlen = 0x10000 - (start & 0xffff);
>  
> -		dma_addr = dma_handle = pci_map_single(priv->dev, (void *)buf, length,
> -						       PCI_DMA_TODEVICE);
> +		dma_addr = dma_handle = dma_map_single(dev, (void *)buf, length,
> +						       DMA_TO_DEVICE);
>          } else {
>  		/* above 16 MB we use a bounce buffer as ISA-DMA is not possible */
>  		maxlen   = PAGE_SIZE;          /* sizeof(priv->dma_buf) */
> @@ -728,9 +729,9 @@ dump_parport_state ("enter fifo_write_bl
>  
>  	/* Turn off DMA mode */
>  	frob_econtrol (port, 1<<3, 0);
> -	
> +
>  	if (dma_handle)
> -		pci_unmap_single(priv->dev, dma_handle, length, PCI_DMA_TODEVICE);
> +		dma_unmap_single(dev, dma_handle, length, DMA_TO_DEVICE);
>  
>  dump_parport_state ("leave fifo_write_block_dma", port);
>  	return length - left;
> @@ -2146,7 +2147,7 @@ static DEFINE_SPINLOCK(ports_lock);
>  struct parport *parport_pc_probe_port (unsigned long int base,
>  				       unsigned long int base_hi,
>  				       int irq, int dma,
> -				       struct pci_dev *dev)
> +				       struct device *dev)
>  {
>  	struct parport_pc_private *priv;
>  	struct parport_operations *ops;
> @@ -2180,9 +2181,10 @@ struct parport *parport_pc_probe_port (u
>  	priv->fifo_depth = 0;
>  	priv->dma_buf = NULL;
>  	priv->dma_handle = 0;
> -	priv->dev = dev;
>  	INIT_LIST_HEAD(&priv->list);
>  	priv->port = p;
> +
> +	p->dev = dev;

This might be the right place to add some warning if dev == NULL, so
that the remaining drivers can be spotted and ported over time? Or even
lower in the stack, in parport_announce_port()?

>  	p->base_hi = base_hi;
>  	p->modes = PARPORT_MODE_PCSPP | PARPORT_MODE_SAFEININT;
>  	p->private_data = priv;
> @@ -2305,9 +2307,10 @@ struct parport *parport_pc_probe_port (u
>  				p->dma = PARPORT_DMA_NONE;
>  			} else {
>  				priv->dma_buf =
> -				  pci_alloc_consistent(priv->dev,
> +				  dma_alloc_coherent(dev,
>  						       PAGE_SIZE,
> -						       &priv->dma_handle);
> +						       &priv->dma_handle,
> +						       GFP_KERNEL);
>  				if (! priv->dma_buf) {
>  					printk (KERN_WARNING "%s: "
>  						"cannot get buffer for DMA, "
> @@ -2383,7 +2386,7 @@ void parport_pc_unregister_port (struct 
>  		release_region(p->base_hi, 3);
>  #if defined(CONFIG_PARPORT_PC_FIFO) && defined(HAS_DMA)
>  	if (priv->dma_buf)
> -		pci_free_consistent(priv->dev, PAGE_SIZE,
> +		dma_free_coherent(p->physport->dev, PAGE_SIZE,
>  				    priv->dma_buf,
>  				    priv->dma_handle);
>  #endif
> @@ -2489,7 +2492,7 @@ static int __devinit sio_ite_8872_probe 
>  	 */
>  	release_resource(base_res);
>  	if (parport_pc_probe_port (ite8872_lpt, ite8872_lpthi,
> -				   irq, PARPORT_DMA_NONE, NULL)) {
> +				   irq, PARPORT_DMA_NONE, &pdev->dev)) {
>  		printk (KERN_INFO
>  			"parport_pc: ITE 8872 parallel port: io=0x%X",
>  			ite8872_lpt);
> @@ -2672,7 +2675,7 @@ static int __devinit sio_via_probe (stru
>  	}
>  
>  	/* finally, do the probe with values obtained */
> -	if (parport_pc_probe_port (port1, port2, irq, dma, NULL)) {
> +	if (parport_pc_probe_port (port1, port2, irq, dma, &pdev->dev)) {
>  		printk (KERN_INFO
>  			"parport_pc: VIA parallel port: io=0x%X", port1);
>  		if (irq != PARPORT_IRQ_NONE)
> @@ -2970,7 +2973,7 @@ static int parport_pc_pci_probe (struct 
>  			parport_pc_pci_tbl[i + last_sio].device, io_lo, io_hi);
>  		data->ports[count] =
>  			parport_pc_probe_port (io_lo, io_hi, PARPORT_IRQ_NONE,
> -					       PARPORT_DMA_NONE, dev);
> +					       PARPORT_DMA_NONE, &dev->dev);
>  		if (data->ports[count])
>  			count++;
>  	}
> @@ -3077,8 +3080,8 @@ static int parport_pc_pnp_probe(struct p
>  	} else
>  		dma = PARPORT_DMA_NONE;
>  
> -	printk(KERN_INFO "parport: PnPBIOS parport detected.\n");
> -	if (!(pdata = parport_pc_probe_port (io_lo, io_hi, irq, dma, NULL)))
> +	dev_info(&dev->dev, "reported by %s\n", dev->protocol->name);
> +	if (!(pdata = parport_pc_probe_port (io_lo, io_hi, irq, dma, &dev->dev)))
>  		return -ENODEV;
>  
>  	pnp_set_drvdata(dev,pdata);
> Index: g26/drivers/parport/parport_mfc3.c
> ===================================================================
> --- g26.orig/drivers/parport/parport_mfc3.c	2006-10-13 15:41:08.000000000 -0700
> +++ g26/drivers/parport/parport_mfc3.c	2007-02-18 12:51:23.000000000 -0800
> @@ -356,6 +356,7 @@ static int __init parport_mfc3_init(void
>  				if (request_irq(IRQ_AMIGA_PORTS, mfc3_interrupt, IRQF_SHARED, p->name, &pp_mfc3_ops))
>  					goto out_irq;
>  		}
> +		p->dev = &z->dev;
>  
>  		this_port[pias++] = p;
>  		printk(KERN_INFO "%s: Multiface III port using irq\n", p->name);
> Index: g26/drivers/parport/parport_sunbpp.c
> ===================================================================
> --- g26.orig/drivers/parport/parport_sunbpp.c	2006-10-13 15:41:08.000000000 -0700
> +++ g26/drivers/parport/parport_sunbpp.c	2007-02-18 12:55:50.000000000 -0800
> @@ -320,6 +320,7 @@ static int __devinit init_one_port(struc
>  		goto out_free_ops;
>  
>  	p->size = size;
> +	p->dev = &sdev->ofdev.dev;
>  
>  	if ((err = request_irq(p->irq, parport_sunbpp_interrupt,
>  			       IRQF_SHARED, p->name, p)) != 0) {
> Index: g26/drivers/parport/parport_serial.c
> ===================================================================
> --- g26.orig/drivers/parport/parport_serial.c	2006-10-05 19:43:52.000000000 -0700
> +++ g26/drivers/parport/parport_serial.c	2007-02-18 12:53:07.000000000 -0800
> @@ -305,7 +305,7 @@ static int __devinit parport_register (s
>  		dev_dbg(&dev->dev, "PCI parallel port detected: I/O at "
>  			"%#lx(%#lx)\n", io_lo, io_hi);
>  		port = parport_pc_probe_port (io_lo, io_hi, PARPORT_IRQ_NONE,
> -					      PARPORT_DMA_NONE, dev);
> +					      PARPORT_DMA_NONE, &dev->dev);
>  		if (port) {
>  			priv->port[priv->num_par++] = port;
>  			success = 1;
> Index: g26/drivers/spi/spi_butterfly.c
> ===================================================================
> --- g26.orig/drivers/spi/spi_butterfly.c	2007-02-18 09:13:19.000000000 -0800
> +++ g26/drivers/spi/spi_butterfly.c	2007-02-18 09:20:14.000000000 -0800
> @@ -20,7 +20,7 @@
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/delay.h>
> -#include <linux/platform_device.h>
> +#include <linux/device.h>
>  #include <linux/parport.h>
>  
>  #include <linux/sched.h>
> @@ -237,24 +237,20 @@ static void butterfly_attach(struct parp
>  	int			status;
>  	struct butterfly	*pp;
>  	struct spi_master	*master;
> -	struct platform_device	*pdev;
> +	struct device		*dev = p->physport->dev;
>  
> -	if (butterfly)
> +	/* NOTE: this won't work with old legacy-style parport drivers,
> +	 * which have no driver model device node.  PNPACPI or PCI ones
> +	 * should however be just fine
> +	 */
> +	if (butterfly || !dev)
>  		return;
>  
>  	/* REVISIT:  this just _assumes_ a butterfly is there ... no probe,
>  	 * and no way to be selective about what it binds to.
>  	 */
>  
> -	/* FIXME where should master->dev come from?
> -	 * e.g. /sys/bus/pnp0/00:0b, some PCI thing, etc
> -	 * setting up a platform device like this is an ugly kluge...
> -	 */
> -	pdev = platform_device_register_simple("butterfly", -1, NULL, 0);
> -	if (IS_ERR(pdev))
> -		return;
> -
> -	master = spi_alloc_master(&pdev->dev, sizeof *pp);
> +	master = spi_alloc_master(dev, sizeof *pp);
>  	if (!master) {
>  		status = -ENOMEM;
>  		goto done;
> @@ -366,14 +362,12 @@ clean1:
>  clean0:
>  	(void) spi_master_put(pp->bitbang.master);
>  done:
> -	platform_device_unregister(pdev);
>  	pr_debug("%s: butterfly probe, fail %d\n", p->name, status);
>  }
>  
>  static void butterfly_detach(struct parport *p)
>  {
>  	struct butterfly	*pp;
> -	struct platform_device	*pdev;
>  	int			status;
>  
>  	/* FIXME this global is ugly ... but, how to quickly get from
> @@ -386,7 +380,6 @@ static void butterfly_detach(struct parp
>  	butterfly = NULL;
>  
>  	/* stop() unregisters child devices too */
> -	pdev = to_platform_device(pp->bitbang.master->dev);
>  	status = spi_bitbang_stop(&pp->bitbang);
>  
>  	/* turn off VCC */
> @@ -397,8 +390,6 @@ static void butterfly_detach(struct parp
>  	parport_unregister_device(pp->pd);
>  
>  	(void) spi_master_put(pp->bitbang.master);
> -
> -	platform_device_unregister(pdev);
>  }
>  
>  static struct parport_driver butterfly_driver = {
> Index: g26/drivers/i2c/busses/i2c-parport.c
> ===================================================================
> --- g26.orig/drivers/i2c/busses/i2c-parport.c	2006-12-12 19:25:43.000000000 -0800
> +++ g26/drivers/i2c/busses/i2c-parport.c	2007-02-18 09:13:34.000000000 -0800
> @@ -143,7 +143,7 @@ static struct i2c_algo_bit_data parport_
>  
>  /* ----- I2c and parallel port call-back functions and structures --------- */
>  
> -static struct i2c_adapter parport_adapter = {
> +static const struct i2c_adapter parport_adapter = {
>  	.owner		= THIS_MODULE,
>  	.class		= I2C_CLASS_HWMON,
>  	.id		= I2C_HW_B_LP,

This change doesn't belong to this patch at all, although it is
correct. I'll be happy to apply it if you send it to me separately.

(Or it might be even better to get rid of this static structure
altogether and intialize the fields of the dynamically allocated
structure individually instead. This would make the driver smaller.)

> @@ -175,6 +175,7 @@ static void i2c_parport_attach (struct p
>  		adapter->algo_data.getscl = NULL;
>  	adapter->algo_data.data = port;
>  	adapter->adapter.algo_data = &adapter->algo_data;
> +	adapter->adapter.dev.parent = port->physport->dev;
>  
>  	if (parport_claim_or_block(adapter->pdev) < 0) {
>  		printk(KERN_ERR "i2c-parport: Could not claim parallel port\n");

Maybe we should even fail if the physical device is missing, as you did
in spi_butterfly? As you know, some i2c subsystem changes are not
possible until all i2c-adapter drivers have a valid physical parent
device. I don't want to wait that all parport drivers have been
updating before we can clean up i2c-core itself.

Which means that I will have to fix the legacy parport_pc case right
now, otherwise I will no longer be able to use i2c-parport and this
isn't an option for me. What do you think would be the right way to do
it? A platform driver I guess, and we create a platform device for
every successful call to parport_pc_probe_port() with a NULL dev
pointer? That would be a fake driver, as the probe() and remove()
methods would do nothing as far as I can see, but that's all I can
think of at the moment.

> Index: g26/drivers/char/ppdev.c
> ===================================================================
> --- g26.orig/drivers/char/ppdev.c	2006-12-09 17:02:09.000000000 -0800
> +++ g26/drivers/char/ppdev.c	2007-02-18 13:45:40.000000000 -0800
> @@ -752,7 +752,7 @@ static const struct file_operations pp_f
>  
>  static void pp_attach(struct parport *port)
>  {
> -	device_create(ppdev_class, NULL, MKDEV(PP_MAJOR, port->number),
> +	device_create(ppdev_class, port->dev, MKDEV(PP_MAJOR, port->number),
>  			"parport%d", port->number);
>  }
>  
> Index: g26/drivers/char/lp.c
> ===================================================================
> --- g26.orig/drivers/char/lp.c	2006-12-14 06:00:30.000000000 -0800
> +++ g26/drivers/char/lp.c	2007-02-18 13:44:12.000000000 -0800
> @@ -803,7 +803,7 @@ static int lp_register(int nr, struct pa
>  	if (reset)
>  		lp_reset(nr);
>  
> -	class_device_create(lp_class, NULL, MKDEV(LP_MAJOR, nr), NULL,
> +	class_device_create(lp_class, NULL, MKDEV(LP_MAJOR, nr), port->dev,
>  				"lp%d", nr);
>  
>  	printk(KERN_INFO "lp%d: using %s (%s).\n", nr, port->name, 
> Index: g26/drivers/char/tipar.c
> ===================================================================
> --- g26.orig/drivers/char/tipar.c	2006-12-09 17:02:09.000000000 -0800
> +++ g26/drivers/char/tipar.c	2007-02-18 13:43:15.000000000 -0800
> @@ -442,7 +442,7 @@ tipar_register(int nr, struct parport *p
>  	}
>  
>  	class_device_create(tipar_class, NULL, MKDEV(TIPAR_MAJOR,
> -			TIPAR_MINOR + nr), NULL, "par%d", nr);
> +			TIPAR_MINOR + nr), port->dev, "par%d", nr);
>  
>  	/* Display informations */
>  	pr_info("tipar%d: using %s (%s)\n", nr, port->name, (port->irq ==
> Index: g26/include/linux/pnp.h
> ===================================================================
> --- g26.orig/include/linux/pnp.h	2007-02-12 00:31:26.000000000 -0800
> +++ g26/include/linux/pnp.h	2007-02-18 20:18:55.000000000 -0800
> @@ -177,6 +177,7 @@ static inline void pnp_set_card_drvdata 
>  
>  struct pnp_dev {
>  	struct device dev;		/* Driver Model device interface */
> +	u64 dma_mask;
>  	unsigned char number;		/* used as an index, must be unique */
>  	int status;
>  
> Index: g26/drivers/pnp/core.c
> ===================================================================
> --- g26.orig/drivers/pnp/core.c	2005-11-12 22:24:18.000000000 -0800
> +++ g26/drivers/pnp/core.c	2007-02-18 20:42:17.000000000 -0800
> @@ -14,6 +14,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  #include <linux/errno.h>
> +#include <linux/dma-mapping.h>
>  
>  #include "base.h"
>  
> @@ -114,6 +115,8 @@ int __pnp_add_device(struct pnp_dev *dev
>  	int ret;
>  	pnp_fixup_device(dev);
>  	dev->dev.bus = &pnp_bus_type;
> +	dev->dev.dma_mask = &dev->dma_mask;
> +	dev->dma_mask = dev->dev.coherent_dma_mask = DMA_24BIT_MASK;
>  	dev->dev.release = &pnp_release_device;
>  	dev->status = PNP_READY;
>  	spin_lock(&pnp_lock);

Thanks for doing this :)

-- 
Jean Delvare
