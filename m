Return-Path: <linux-kernel-owner+w=401wt.eu-S1762232AbXHaDhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762232AbXHaDhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 23:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757336AbXHaDg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 23:36:59 -0400
Received: from lixom.net ([66.141.50.11]:56536 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756337AbXHaDg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 23:36:58 -0400
Date: Thu, 30 Aug 2007 21:43:04 -0500
From: Olof Johansson <olof@lixom.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH -mm] pcmcia: Updates to electra_cf driver
Message-ID: <20070831024304.GA23580@lixom.net>
References: <20070625010311.GA31355@lixom.net> <20070625171221.GA6684@lixom.net> <20070625193909.GA26021@infradead.org> <20070625204341.GA8865@lixom.net> <20070705144914.GA14284@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070705144914.GA14284@lixom.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build of electra_cf, since the IO space setup interfaces were
changed when BenH rewrote it.

Also clean it up a bit, add 5V support, make it unloadable, remove some
dead variables, etc.


Signed-off-by: Olof Johansson <olof@lixom.net>

---

Andrew,

I did this as an incremental patch that you can just merge into the base
one that's already in -mm, but I could merge and resubmit the base patch
instead if you prefer.

(The base patch is
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch)


-Olof

Index: linux-2.6/drivers/pcmcia/electra_cf.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/electra_cf.c
+++ linux-2.6/drivers/pcmcia/electra_cf.c
@@ -28,6 +28,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/vmalloc.h>
 
 #include <pcmcia/ss.h>
 #include <asm/of_platform.h>
@@ -105,10 +106,8 @@ static int electra_cf_get_status(struct 
 
 	/* NOTE CF is always 3VCARD */
 	if (electra_cf_present(cf)) {
-		struct electra_cf_socket *cf;
-
 		*sp = SS_READY | SS_DETECT | SS_POWERON | SS_3VCARD;
-		cf = container_of(s, struct electra_cf_socket, socket);
+
 		s->pci_irq = cf->irq;
 	} else
 		*sp = 0;
@@ -134,8 +133,10 @@ static int electra_cf_set_socket(struct 
 	case 33:
 		gpio = (1 << cf->gpio_3v);
 		break;
+	case 5:
+		gpio = (1 << cf->gpio_5v);
+		break;
 	default:
-		/* CF is 3.3V only */
 		return -EINVAL;
 	}
 
@@ -188,6 +189,7 @@ static int __devinit electra_cf_probe(st
 	int status;
 	const unsigned int *prop;
 	int err;
+	struct vm_struct *area;
 
 	err = of_address_to_resource(np, 0, &mem);
 	if (err)
@@ -206,22 +208,27 @@ static int __devinit electra_cf_probe(st
 
 	cf->ofdev = ofdev;
 	cf->mem_phys = mem.start;
-	cf->mem_base = ioremap(mem.start, mem.end - mem.start);
+	cf->mem_size = PAGE_ALIGN(mem.end - mem.start);
+	cf->mem_base = ioremap(cf->mem_phys, cf->mem_size);
 	cf->io_size = PAGE_ALIGN(io.end - io.start);
 
-	cf->io_virt = reserve_phb_iospace(cf->io_size);
+	area = __get_vm_area(cf->io_size, 0, PHB_IO_BASE, PHB_IO_END);
+	if (area == NULL)
+		return -ENOMEM;
+
+	cf->io_virt = (void __iomem *)(area->addr);
 
 	cf->gpio_base = ioremap(0xfc103000, 0x1000);
 	dev_set_drvdata(device, cf);
 
-	if (!cf->mem_base || !cf->io_virt || !cf->gpio_base) {
+	if (!cf->mem_base || !cf->io_virt || !cf->gpio_base ||
+	    (__ioremap_at(io.start, cf->io_virt, cf->io_size,
+		_PAGE_NO_CACHE | _PAGE_GUARDED) == NULL)) {
 		dev_err(device, "can't ioremap ranges\n");
 		status = -ENOMEM;
 		goto fail1;
 	}
 
-	__ioremap_explicit(io.start, (unsigned long)cf->io_virt, cf->io_size,
-			   _PAGE_NO_CACHE | _PAGE_GUARDED);
 
 	cf->io_base = (unsigned long)cf->io_virt - VMALLOC_END;
 
@@ -263,8 +270,7 @@ static int __devinit electra_cf_probe(st
 	cf->socket.io_offset = cf->io_base;
 
 	/* reserve chip-select regions */
-	if (!request_mem_region(mem.start, mem.end + 1 - mem.start,
-				driver_name)) {
+	if (!request_mem_region(cf->mem_phys, cf->mem_size, driver_name)) {
 		status = -ENXIO;
 		dev_err(device, "Can't claim memory region\n");
 		goto fail1;
@@ -291,21 +297,22 @@ static int __devinit electra_cf_probe(st
 	}
 
 	dev_info(device, "at mem 0x%lx io 0x%lx irq %d\n",
-		 mem.start, io.start, cf->irq);
+		 cf->mem_phys, io.start, cf->irq);
 
 	cf->active = 1;
 	electra_cf_timer((unsigned long)cf);
 	return 0;
 
 fail3:
-	release_mem_region(io.start, io.end + 1 - io.start);
+	release_region(cf->io_base, cf->io_size);
 fail2:
-	release_mem_region(mem.start, mem.end + 1 - mem.start);
+	release_mem_region(cf->mem_phys, cf->mem_size);
 fail1:
 	if (cf->irq != NO_IRQ)
 		free_irq(cf->irq, cf);
 
-	/* XXX No way to undo the ioremap_explicit at this time */
+	if (cf->io_virt)
+		__iounmap_at(cf->io_virt, cf->io_size);
 	if (cf->mem_base)
 		iounmap(cf->mem_base);
 	if (cf->gpio_base)
@@ -328,6 +335,7 @@ static int __devexit electra_cf_remove(s
 	free_irq(cf->irq, cf);
 	del_timer_sync(&cf->timer);
 
+	__iounmap_at(cf->io_virt, cf->io_size);
 	iounmap(cf->mem_base);
 	iounmap(cf->gpio_base);
 	release_mem_region(cf->mem_phys, cf->mem_size);
Index: linux-2.6/drivers/pcmcia/Kconfig
===================================================================
--- linux-2.6.orig/drivers/pcmcia/Kconfig
+++ linux-2.6/drivers/pcmcia/Kconfig
@@ -272,8 +272,8 @@ config AT91_CF
 	  Or choose M to compile the driver as a module named "at91_cf".
 
 config ELECTRA_CF
-	bool "Electra CompactFlash Controller"
-	depends on PCMCIA=y && PPC_PASEMI
+	tristate "Electra CompactFlash Controller"
+	depends on PCMCIA && PPC_PASEMI
 	help
 	  Say Y here to support the CompactFlash controller on the
 	  PA Semi Electra eval board.
