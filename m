Return-Path: <linux-kernel-owner+w=401wt.eu-S1761030AbXGEOii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761030AbXGEOii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757857AbXGEOia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:38:30 -0400
Received: from lixom.net ([66.141.50.11]:36029 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295AbXGEOi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:38:29 -0400
Date: Thu, 5 Jul 2007 09:49:14 -0500
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linuxppc-dev@ozlabs.org,
       miltonm@bga.com
Subject: [PATCH v3] pcmcia: CompactFlash driver for PA Semi Electra boards
Message-ID: <20070705144914.GA14284@lixom.net>
References: <20070625010311.GA31355@lixom.net> <20070625171221.GA6684@lixom.net> <20070625193909.GA26021@infradead.org> <20070625204341.GA8865@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625204341.GA8865@lixom.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for the CompactFlash slot on the PA Semi Electra eval board. It's
a simple device sitting on localbus, with interrupts and detect/voltage
control over GPIO.

The driver is implemented as an of_platform driver, and adds localbus
as a bus being probed by the of_platform framework.


Signed-off-by: Olof Johansson <olof@lixom.net>

---

On Mon, Jun 25, 2007 at 03:43:41PM -0500, olof wrote:

> The ifdef is needed since for CONFIG_PCMCIA=n builds, the bus notifier
> isn't available. I wanted to do the bus notifier registration explicitly
> before the of_platform bus probe to avoid later surprises due to reordered
> initcalls in case it was split up in it's own initcall.
> 
> I could add the code under ifdef as well, but it didn't seem too
> critical. Once the second major board comes along I'll probably move it
> out to a per-board file, there's no real need for it just yet.

Alright, turns out I still need to declare the extern bus type, which would mean
two #ifdefs in one function. Moving it out instead.

I've addressed Milton's comments as well.

Who's maintaining PCMCIA? MAINTAINERS only lists a mailing list, no person. Seems
weird for a component that's marked as maintained.


Index: mainline/drivers/pcmcia/Kconfig
===================================================================
--- mainline.orig/drivers/pcmcia/Kconfig
+++ mainline/drivers/pcmcia/Kconfig
@@ -270,6 +270,13 @@ config AT91_CF
 	  Say Y here to support the CompactFlash controller on AT91 chips.
 	  Or choose M to compile the driver as a module named "at91_cf".
 
+config ELECTRA_CF
+	bool "Electra CompactFlash Controller"
+	depends on PCMCIA=y && PPC_PASEMI
+	help
+	  Say Y here to support the CompactFlash controller on the
+	  PA Semi Electra eval board.
+
 config PCCARD_NONSTATIC
 	tristate
 
Index: mainline/drivers/pcmcia/Makefile
===================================================================
--- mainline.orig/drivers/pcmcia/Makefile
+++ mainline/drivers/pcmcia/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_PCMCIA_VRC4171)			+= vrc417
 obj-$(CONFIG_PCMCIA_VRC4173)			+= vrc4173_cardu.o
 obj-$(CONFIG_OMAP_CF)				+= omap_cf.o
 obj-$(CONFIG_AT91_CF)				+= at91_cf.o
+obj-$(CONFIG_ELECTRA_CF)			+= electra_cf.o
 
 sa11xx_core-y					+= soc_common.o sa11xx_base.o
 pxa2xx_core-y					+= soc_common.o pxa2xx_base.o
Index: mainline/drivers/pcmcia/electra_cf.c
===================================================================
--- /dev/null
+++ mainline/drivers/pcmcia/electra_cf.c
@@ -0,0 +1,374 @@
+/*
+ * Copyright (C) 2007 PA Semi, Inc
+ *
+ * Maintained by: Olof Johansson <olof@lixom.net>
+ *
+ * Based on drivers/pcmcia/omap_cf.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/platform_device.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+
+#include <pcmcia/ss.h>
+#include <asm/of_platform.h>
+
+static const char driver_name[] = "electra-cf";
+
+struct electra_cf_socket {
+	struct pcmcia_socket	socket;
+
+	struct timer_list	timer;
+	unsigned		present:1;
+	unsigned		active:1;
+
+	struct of_device	*ofdev;
+	unsigned long		mem_phys;
+	void __iomem *		mem_base;
+	unsigned long		mem_size;
+	void __iomem *		io_virt;
+	unsigned int		io_base;
+	unsigned int		io_size;
+	u_int			irq;
+	struct resource		iomem;
+	void __iomem *		gpio_base;
+	int			gpio_detect;
+	int			gpio_vsense;
+	int			gpio_3v;
+	int			gpio_5v;
+};
+
+#define	POLL_INTERVAL		(2 * HZ)
+
+
+static int electra_cf_present(struct electra_cf_socket *cf)
+{
+	unsigned int gpio;
+
+	gpio = in_le32(cf->gpio_base+0x40);
+	return !(gpio & (1 << cf->gpio_detect));
+}
+
+static int electra_cf_ss_init(struct pcmcia_socket *s)
+{
+	return 0;
+}
+
+/* the timer is primarily to kick this socket's pccardd */
+static void electra_cf_timer(unsigned long _cf)
+{
+	struct electra_cf_socket *cf = (void *) _cf;
+	int present = electra_cf_present(cf);
+
+	if (present != cf->present) {
+		cf->present = present;
+		pcmcia_parse_events(&cf->socket, SS_DETECT);
+	}
+
+	if (cf->active)
+		mod_timer(&cf->timer, jiffies + POLL_INTERVAL);
+}
+
+static irqreturn_t electra_cf_irq(int irq, void *_cf)
+{
+	electra_cf_timer((unsigned long)_cf);
+	return IRQ_HANDLED;
+}
+
+static int electra_cf_get_status(struct pcmcia_socket *s, u_int *sp)
+{
+	struct electra_cf_socket *cf;
+
+	if (!sp)
+		return -EINVAL;
+
+	cf = container_of(s, struct electra_cf_socket, socket);
+
+	/* NOTE CF is always 3VCARD */
+	if (electra_cf_present(cf)) {
+		struct electra_cf_socket *cf;
+
+		*sp = SS_READY | SS_DETECT | SS_POWERON | SS_3VCARD;
+		cf = container_of(s, struct electra_cf_socket, socket);
+		s->pci_irq = cf->irq;
+	} else
+		*sp = 0;
+	return 0;
+}
+
+static int electra_cf_set_socket(struct pcmcia_socket *sock,
+				 struct socket_state_t *s)
+{
+	unsigned int gpio;
+	unsigned int vcc;
+	struct electra_cf_socket *cf;
+
+	cf = container_of(sock, struct electra_cf_socket, socket);
+
+	/* "reset" means no power in our case */
+	vcc = (s->flags & SS_RESET) ? 0 : s->Vcc;
+
+	switch (vcc) {
+	case 0:
+		gpio = 0;
+		break;
+	case 33:
+		gpio = (1 << cf->gpio_3v);
+		break;
+	default:
+		/* CF is 3.3V only */
+		return -EINVAL;
+	}
+
+	gpio |= 1 << (cf->gpio_3v + 16); /* enwr */
+	gpio |= 1 << (cf->gpio_5v + 16); /* enwr */
+	out_le32(cf->gpio_base+0x90, gpio);
+
+	pr_debug("%s: Vcc %d, io_irq %d, flags %04x csc %04x\n",
+		driver_name, s->Vcc, s->io_irq, s->flags, s->csc_mask);
+
+	return 0;
+}
+
+static int electra_cf_set_io_map(struct pcmcia_socket *s,
+				 struct pccard_io_map *io)
+{
+	return 0;
+}
+
+static int electra_cf_set_mem_map(struct pcmcia_socket *s,
+				  struct pccard_mem_map *map)
+{
+	struct electra_cf_socket *cf;
+
+	if (map->card_start)
+		return -EINVAL;
+	cf = container_of(s, struct electra_cf_socket, socket);
+	map->static_start = cf->mem_phys;
+	map->flags &= MAP_ACTIVE|MAP_ATTRIB;
+	if (!(map->flags & MAP_ATTRIB))
+		map->static_start += 0x800;
+	return 0;
+}
+
+static struct pccard_operations electra_cf_ops = {
+	.init			= electra_cf_ss_init,
+	.get_status		= electra_cf_get_status,
+	.set_socket		= electra_cf_set_socket,
+	.set_io_map		= electra_cf_set_io_map,
+	.set_mem_map		= electra_cf_set_mem_map,
+};
+
+static int __devinit electra_cf_probe(struct of_device *ofdev,
+				      const struct of_device_id *match)
+{
+	struct device *device = &ofdev->dev;
+	struct device_node *np = ofdev->node;
+	struct electra_cf_socket   *cf;
+	struct resource mem, io;
+	int status;
+	const unsigned int *prop;
+	int err;
+
+	err = of_address_to_resource(np, 0, &mem);
+	if (err)
+		return -EINVAL;
+
+	err = of_address_to_resource(np, 1, &io);
+	if (err)
+		return -EINVAL;
+
+	cf = kzalloc(sizeof *cf, GFP_KERNEL);
+	if (!cf)
+		return -ENOMEM;
+
+	init_timer(&cf->timer);
+	cf->timer.function = electra_cf_timer;
+	cf->timer.data = (unsigned long) cf;
+	cf->irq = NO_IRQ;
+
+	cf->ofdev = ofdev;
+	cf->mem_phys = mem.start;
+	cf->mem_base = ioremap(mem.start, mem.end - mem.start);
+	cf->io_size = PAGE_ALIGN(io.end - io.start);
+
+	cf->io_virt = reserve_phb_iospace(cf->io_size);
+
+	cf->gpio_base = ioremap(0xfc103000, 0x1000);
+	dev_set_drvdata(device, cf);
+
+	if (!cf->mem_base || !cf->io_virt || !cf->gpio_base) {
+		dev_err(device, "can't ioremap ranges\n");
+		status = -ENOMEM;
+		goto fail1;
+	}
+
+	__ioremap_explicit(io.start, (unsigned long)cf->io_virt, cf->io_size,
+			   _PAGE_NO_CACHE | _PAGE_GUARDED);
+
+	cf->io_base = (unsigned long)cf->io_virt - VMALLOC_END;
+
+	cf->iomem.start = (unsigned long)cf->mem_base;
+	cf->iomem.end = (unsigned long)cf->mem_base + (mem.end - mem.start);
+	cf->iomem.flags = IORESOURCE_MEM;
+
+	cf->irq = irq_of_parse_and_map(np, 0);
+
+	status = request_irq(cf->irq, electra_cf_irq, IRQF_SHARED,
+			     driver_name, cf);
+	if (status < 0) {
+		dev_err(device, "request_irq failed\n");
+		goto fail1;
+	}
+
+	cf->socket.pci_irq = cf->irq;
+
+	prop = of_get_property(np, "card-detect-gpio", NULL);
+	if (!prop)
+		goto fail1;
+	cf->gpio_detect = *prop;
+
+	prop = of_get_property(np, "card-vsense-gpio", NULL);
+	if (!prop)
+		goto fail1;
+	cf->gpio_vsense = *prop;
+
+	prop = of_get_property(np, "card-3v-gpio", NULL);
+	if (!prop)
+		goto fail1;
+	cf->gpio_3v = *prop;
+
+	prop = of_get_property(np, "card-5v-gpio", NULL);
+	if (!prop)
+		goto fail1;
+	cf->gpio_5v = *prop;
+
+	cf->socket.io_offset = cf->io_base;
+
+	/* reserve chip-select regions */
+	if (!request_mem_region(mem.start, mem.end + 1 - mem.start,
+				driver_name)) {
+		status = -ENXIO;
+		dev_err(device, "Can't claim memory region\n");
+		goto fail1;
+	}
+
+	if (!request_region(cf->io_base, cf->io_size, driver_name)) {
+		status = -ENXIO;
+		dev_err(device, "Can't claim I/O region\n");
+		goto fail2;
+	}
+
+	cf->socket.owner = THIS_MODULE;
+	cf->socket.dev.parent = &ofdev->dev;
+	cf->socket.ops = &electra_cf_ops;
+	cf->socket.resource_ops = &pccard_static_ops;
+	cf->socket.features = SS_CAP_PCCARD | SS_CAP_STATIC_MAP |
+				SS_CAP_MEM_ALIGN;
+	cf->socket.map_size = 0x800;
+
+	status = pcmcia_register_socket(&cf->socket);
+	if (status < 0) {
+		dev_err(device, "pcmcia_register_socket failed\n");
+		goto fail3;
+	}
+
+	dev_info(device, "at mem 0x%lx io 0x%lx irq %d\n",
+		 mem.start, io.start, cf->irq);
+
+	cf->active = 1;
+	electra_cf_timer((unsigned long)cf);
+	return 0;
+
+fail3:
+	release_mem_region(io.start, io.end + 1 - io.start);
+fail2:
+	release_mem_region(mem.start, mem.end + 1 - mem.start);
+fail1:
+	if (cf->irq != NO_IRQ)
+		free_irq(cf->irq, cf);
+
+	/* XXX No way to undo the ioremap_explicit at this time */
+	if (cf->mem_base)
+		iounmap(cf->mem_base);
+	if (cf->gpio_base)
+		iounmap(cf->gpio_base);
+	device_init_wakeup(&ofdev->dev, 0);
+	kfree(cf);
+	return status;
+
+}
+
+static int __devexit electra_cf_remove(struct of_device *ofdev)
+{
+	struct device *device = &ofdev->dev;
+	struct electra_cf_socket *cf;
+
+	cf = dev_get_drvdata(device);
+
+	cf->active = 0;
+	pcmcia_unregister_socket(&cf->socket);
+	free_irq(cf->irq, cf);
+	del_timer_sync(&cf->timer);
+
+	iounmap(cf->mem_base);
+	iounmap(cf->gpio_base);
+	release_mem_region(cf->mem_phys, cf->mem_size);
+	release_region(cf->io_base, cf->io_size);
+
+	kfree(cf);
+
+	return 0;
+}
+
+static struct of_device_id electra_cf_match[] =
+{
+	{
+		.compatible   = "electra-cf",
+	},
+	{},
+};
+
+static struct of_platform_driver electra_cf_driver =
+{
+	.name	   = (char *)driver_name,
+	.match_table    = electra_cf_match,
+	.probe	  = electra_cf_probe,
+	.remove   = electra_cf_remove,
+};
+
+static int __init electra_cf_init(void)
+{
+	return of_register_platform_driver(&electra_cf_driver);
+}
+module_init(electra_cf_init);
+
+static void __exit electra_cf_exit(void)
+{
+	of_unregister_platform_driver(&electra_cf_driver);
+}
+module_exit(electra_cf_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR ("Olof Johansson <olof@lixom.net>");
+MODULE_DESCRIPTION("PA Semi Electra CF driver");
+
Index: mainline/arch/powerpc/platforms/pasemi/setup.c
===================================================================
--- mainline.orig/arch/powerpc/platforms/pasemi/setup.c
+++ mainline/arch/powerpc/platforms/pasemi/setup.c
@@ -37,6 +37,10 @@
 #include <asm/time.h>
 #include <asm/of_platform.h>
 
+#include <pcmcia/ss.h>
+#include <pcmcia/cistpl.h>
+#include <pcmcia/ds.h>
+
 #include "pasemi.h"
 
 static void __iomem *reset_reg;
@@ -204,7 +208,57 @@ static void __init pas_init_early(void)
 	iommu_init_early_pasemi();
 }
 
+#ifdef CONFIG_PCMCIA
+static int pcmcia_notify(struct notifier_block *nb, unsigned long action,
+			 void *data)
+{
+	struct device *dev = data;
+	struct device *parent;
+	struct pcmcia_device *pdev = to_pcmcia_dev(dev);
+
+	/* We are only intereted in device addition */
+	if (action != BUS_NOTIFY_ADD_DEVICE)
+		return 0;
+
+	parent = pdev->socket->dev.parent;
+
+	/* We know electra_cf devices will always have of_node set, since
+	 * electra_cf is an of_platform driver.
+	 */
+	if (!parent->archdata.of_node)
+		return 0;
+
+	if (!of_device_is_compatible(parent->archdata.of_node, "electra-cf"))
+		return 0;
+
+	/* We use the direct ops for localbus */
+	dev->archdata.dma_ops = &dma_direct_ops;
+
+	return 0;
+}
+
+static struct notifier_block pcmcia_notifier = {
+	.notifier_call = pcmcia_notify,
+};
+
+static inline void pasemi_pcmcia_init(void)
+{
+	extern struct bus_type pcmcia_bus_type;
+
+	bus_register_notifier(&pcmcia_bus_type, &pcmcia_notifier);
+}
+
+#else
+
+static inline void pasemi_pcmcia_init(void)
+{
+}
+
+#endif
+
+
 static struct of_device_id pasemi_bus_ids[] = {
+	{ .type = "localbus", },
 	{ .type = "sdc", },
 	{},
 };
@@ -214,6 +268,8 @@ static int __init pasemi_publish_devices
 	if (!machine_is(pasemi))
 		return 0;
 
+	pasemi_pcmcia_init();
+
 	/* Publish OF platform devices for SDC and other non-PCI devices */
 	of_platform_bus_probe(NULL, pasemi_bus_ids, NULL);
 
