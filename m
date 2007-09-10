Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbXIJXRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbXIJXRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 19:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbXIJXQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 19:16:53 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:58655 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761802AbXIJXQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 19:16:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ioeowkBOCriz0Mxdphjw7eKCeJLz9+3c3suacbQSl6TnuxxHO0Vr4l+6Ff5VpZ24kvVyvQiHGMi5lBBzVS12F1wpwKAn39LOBAZaDeGDir1Uft0yIAj5guiOoHTVfVEuycGLw/B0EdGzve6fBvnCzxosCq2x6JjPszRjKfZpIV0=
Message-ID: <8b67d60709101616p7430a572w3ed0921a846805@mail.gmail.com>
Date: Tue, 11 Sep 2007 00:16:48 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net
Subject: [PATCH 1/2] Maple Bus support for SEGA Dreamcast
Cc: "Arjan van de Ven" <arjan@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the Maple Bus - Sega's proprietary serial if
with peripherals - for the Dreamcast.

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 54878f0..c1771b7 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -702,6 +702,17 @@ config CF_BASE_ADDR
 	default "0xb8000000" if CF_AREA6
 	default "0xb4000000" if CF_AREA5

+config MAPLE
+	tristate "Maple Bus Support"
+	depends on SH_DREAMCAST
+	help
+	  The Maple Bus is SEGA's serial communication bus for peripherals
+	  on the Dreamcast. Without this bus support you won't be able to
+	  get your Dreamcast keyboard etc to work, so most users
+	  probably want to say 'Y' here, unless you are only using the
+	  Dreamcast with a serial line terminal or a remote network
+	  connection.
+
 source "arch/sh/drivers/pci/Kconfig"

 source "drivers/pci/Kconfig"
diff --git a/drivers/sh/Makefile b/drivers/sh/Makefile
index 8a14389..f0a1f4f 100644
--- a/drivers/sh/Makefile
+++ b/drivers/sh/Makefile
@@ -3,4 +3,5 @@
 #

 obj-$(CONFIG_SUPERHYWAY) += superhyway/
+obj-$(CONFIG_MAPLE) += maple/

diff --git a/drivers/sh/maple/Makefile b/drivers/sh/maple/Makefile
new file mode 100644
index 0000000..f8c39f2
--- /dev/null
+++ b/drivers/sh/maple/Makefile
@@ -0,0 +1,3 @@
+#Makefile for Maple Bus
+
+obj-y	:= maplebus.o
diff --git a/drivers/sh/maple/maplebus.c b/drivers/sh/maple/maplebus.c
new file mode 100644
index 0000000..4662463
--- /dev/null
+++ b/drivers/sh/maple/maplebus.c
@@ -0,0 +1,747 @@
+/* maplebus.c
+ * Core maple bus functionality
+ * Original 2.4 code used here copyright
+ * YAEGASHI Takeshi, Paul Mundt, M. R. Brown and others
+ * Porting to 2.6 Copyright Adrian McMenamin, 2007
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
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/moduleparam.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/maple.h>
+#include <asm/cacheflush.h>
+#include <asm/dma.h>
+#include <asm/mach/sysasic.h>
+
+MODULE_AUTHOR("Yaegshi Takeshi, Paul Mundt, MR Brown, Adrian McMenamin");
+MODULE_DESCRIPTION("Maple bus driver for Dreamcast");
+MODULE_LICENSE("GPL");
+MODULE_SUPPORTED_DEVICE("{{SEGA, Dreamcast/Maple}}");
+
+static void maple_dma_handler(struct work_struct *work);
+static void maple_vblank_handler(struct work_struct *work);
+
+static DECLARE_WORK(maple_dma_process, maple_dma_handler);
+static DECLARE_WORK(maple_vblank_process, maple_vblank_handler);
+
+static LIST_HEAD(maple_waitq);
+static LIST_HEAD(maple_sentq);
+
+static DEFINE_MUTEX(maple_list_lock);
+
+DEFINE_MUTEX(maple_dma_lock);
+EXPORT_SYMBOL_GPL(maple_dma_lock);
+
+static struct maple_driver maple_null_driver;
+static struct device maple_bus;
+static int subdevice_map[MAPLE_PORTS];
+static unsigned long *maple_sendbuf, *maple_sendptr, *maple_lastptr;
+static unsigned long maple_pnp_time;
+static int started, scanning, liststatus;
+static struct kmem_cache *maple_cache;
+
+int maple_driver_register(struct device_driver *drv)
+{
+	if (!drv)
+		return -EINVAL;
+	drv->bus = &maple_bus_type;
+	return driver_register(drv);
+}
+EXPORT_SYMBOL_GPL(maple_driver_register);
+
+void maplebus_init_hardware(void)
+{
+	mutex_lock(&maple_dma_lock);
+	ctrl_outl(MAPLE_MAGIC, MAPLE_RESET);
+	/* set trig type to 0 for software trigger, 1 for hardware (VBLANK) */
+	ctrl_outl(1, MAPLE_TRIGTYPE);
+	ctrl_outl(MAPLE_2MBPS | MAPLE_TIMEOUT(50000), MAPLE_SPEED);
+	ctrl_outl(PHYSADDR(maple_sendbuf), MAPLE_DMAADDR);
+	ctrl_outl(1, MAPLE_ENABLE);
+	mutex_unlock(&maple_dma_lock);
+}
+EXPORT_SYMBOL_GPL(maplebus_init_hardware);
+
+void maple_getcond_callback(struct maple_device *dev,
+			    void (*callback) (struct mapleq * mq),
+			    unsigned long interval, unsigned long function)
+{
+	dev->callback = callback;
+	dev->interval = interval;
+	dev->function = cpu_to_be32(function);
+	dev->when = 0;
+}
+EXPORT_SYMBOL_GPL(maple_getcond_callback);
+
+int maple_dma_done(void)
+{
+	return (ctrl_inl(MAPLE_STATE) & 1) == 0;
+}
+EXPORT_SYMBOL_GPL(maple_dma_done);
+
+static void maple_release_device(struct device *dev)
+{
+	if (dev->type) {
+		kfree(dev->type->name);
+		kfree(dev->type);
+	}
+}
+
+static void maple_add_packet(struct mapleq *mq)
+{
+	mutex_lock(&maple_list_lock);
+	list_add((struct list_head *) mq, &maple_waitq);
+	mutex_unlock(&maple_list_lock);
+}
+
+static struct mapleq *maple_allocq(struct maple_device *dev)
+{
+	struct mapleq *mq;
+
+	mq = kmalloc(sizeof(*mq), GFP_KERNEL);
+	if (!mq)
+		return NULL;
+
+	mq->dev = dev;
+	mq->recvbuf = kmem_cache_zalloc(maple_cache, GFP_KERNEL);
+	if (!mq->recvbuf){
+		kfree(mq);
+		return NULL;
+	}
+
+	return mq;
+}
+
+static struct maple_device *maple_alloc_dev(int port, int unit)
+{
+	struct maple_device *dev;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return NULL;
+
+	dev->port = port;
+	dev->unit = unit;
+	dev->mq = maple_allocq(dev);
+
+	if (!dev->mq) {
+		kfree(dev);
+		return NULL;
+	}
+
+	return dev;
+}
+
+static void maple_free_dev(struct maple_device *mdev)
+{
+	if (!mdev)
+		return;
+	kmem_cache_free(maple_cache, mdev->mq->recvbuf);
+	kfree(mdev->mq);
+	kfree(mdev);
+}
+
+static void maple_build_block(struct mapleq *mq)
+{
+	int port, unit, from, to, len;
+	unsigned long *lsendbuf = mq->sendbuf;
+
+	port = mq->dev->port & 3;
+	unit = mq->dev->unit;
+	len = mq->length;
+	from = port << 6;
+	to = (port << 6) | (unit > 0 ? (1 << (unit - 1)) & 0x1f : 0x20);
+
+	*maple_lastptr &= 0x7fffffff;
+	maple_lastptr = maple_sendptr;
+
+	*maple_sendptr++ = (port << 16) | len | 0x80000000;
+	*maple_sendptr++ = PHYSADDR(mq->recvbuf);
+	*maple_sendptr++ =
+	    mq->command | (to << 8) | (from << 16) | (len << 24);
+
+	while (len-- > 0)
+		*maple_sendptr++ = *lsendbuf++;
+}
+
+void maple_send(void)
+{
+	int i;
+	int maple_packets;
+	struct mapleq *mq, *nmq;
+
+	if (!list_empty(&maple_sentq))
+		return;
+	if (list_empty(&maple_waitq) || !maple_dma_done())
+		return;
+	maple_packets = 0;
+	maple_sendptr = maple_lastptr = maple_sendbuf;
+	list_for_each_entry_safe(mq, nmq, &maple_waitq, list) {
+		maple_build_block(mq);
+		list_move(&mq->list, &maple_sentq);
+		if (maple_packets++ > MAPLE_MAXPACKETS)
+			break;
+	}
+	if (maple_packets > 0) {
+		for (i = 0; i < (1 << MAPLE_DMA_PAGES); i++)
+			dma_cache_wback_inv(maple_sendbuf + i * PAGE_SIZE,
+					    PAGE_SIZE);
+	}
+}
+
+static int attach_matching_maple_driver(struct device_driver *driver,
+					void *devptr)
+{
+	struct maple_driver *maple_drv;
+	struct maple_device *mdev;
+
+	mdev = devptr;
+	maple_drv = to_maple_driver(driver);
+	if (mdev->devinfo.function & be32_to_cpu(maple_drv->function)) {
+		if (maple_drv->connect(mdev) == 0) {
+			mdev->driver = maple_drv;
+			return 1;
+		}
+	}
+	return 0;
+}
+
+static void maple_detach_driver(struct maple_device *mdev)
+{
+	if (!mdev)
+		return;
+	if (mdev->driver) {
+		if (mdev->driver->disconnect)
+			mdev->driver->disconnect(mdev);
+	}
+	mdev->driver = NULL;
+	if (mdev->registered) {
+		maple_release_device(&mdev->dev);
+		device_unregister(&mdev->dev);
+	}
+	mdev->registered = 0;
+	maple_free_dev(mdev);
+}
+
+static void maple_attach_driver(struct maple_device *dev)
+{
+	char *p;
+
+	char *recvbuf;
+	unsigned long function;
+	int matched, retval;
+
+	recvbuf = dev->mq->recvbuf;
+	memcpy(&dev->devinfo, recvbuf + 4, sizeof(dev->devinfo));
+	memcpy(dev->product_name, dev->devinfo.product_name, 30);
+	memcpy(dev->product_licence, dev->devinfo.product_licence, 60);
+	dev->product_name[30] = '\0';
+	dev->product_licence[60] = '\0';
+
+	for (p = dev->product_name + 29; dev->product_name <= p; p--)
+		if (*p == ' ')
+			*p = '\0';
+		else
+			break;
+
+	for (p = dev->product_licence + 59; dev->product_licence <= p; p--)
+		if (*p == ' ')
+			*p = '\0';
+		else
+			break;
+
+	function = be32_to_cpu(dev->devinfo.function);
+
+	if (function == 0xFFFFFFFF) {
+		/* Do this silently - as not a real device */
+		function = 0;
+		dev->driver = &maple_null_driver;
+		sprintf(dev->dev.bus_id, "%d:0.port", dev->port);
+	} else {
+		printk(KERN_INFO
+		       "Maple bus at (%d, %d): Connected function 0x%lX\n",
+		       dev->port, dev->unit, function);
+
+		matched =
+		    bus_for_each_drv(&maple_bus_type, NULL, dev,
+				     attach_matching_maple_driver);
+
+		if (matched == 0) {
+			/* Driver does not exist yet */
+			printk(KERN_INFO
+			       "No maple driver found for this device\n");
+			dev->driver = &maple_null_driver;
+		}
+
+		sprintf(dev->dev.bus_id, "%d:0%d.%lX", dev->port,
+			dev->unit, function);
+	}
+	dev->function = function;
+	dev->dev.bus = &maple_bus_type;
+	dev->dev.parent = &maple_bus;
+	dev->dev.release = &maple_release_device;
+	retval = device_register(&dev->dev);
+	if (retval) {
+		printk(KERN_INFO
+		       "Maple bus: Attempt to register device (%x, %x) failed.\n",
+		       dev->port, dev->unit);
+		maple_free_dev(dev);
+	}
+	dev->registered = 1;
+}
+
+/* if device has been registered for the given
+ * port and unit then return 1 - allows identification
+ * of which devices need to be attached or detached
+ */
+static int detach_maple_device(struct device *device, void *portptr)
+{
+	struct device_specify *ds;
+	struct maple_device *mdev;
+
+	ds = portptr;
+	mdev = to_maple_dev(device);
+	if (mdev->port == ds->port && mdev->unit == ds->unit)
+		return 1;
+	return 0;
+}
+
+static int setup_maple_commands(struct device *device, void *ignored)
+{
+	struct maple_device *maple_dev = to_maple_dev(device);
+
+	if  ((maple_dev->interval > 0) && (jiffies >maple_dev->when)) {
+			maple_dev->when = jiffies + maple_dev->interval;
+			maple_dev->mq->command = MAPLE_COMMAND_GETCOND;
+			maple_dev->mq->sendbuf = &maple_dev->function;
+			maple_dev->mq->length = 1;
+			maple_add_packet(maple_dev->mq);
+			liststatus++;
+	} else {
+		if (jiffies >= maple_pnp_time) {
+			maple_dev->mq->command = MAPLE_COMMAND_DEVINFO;
+			maple_dev->mq->length = 0;
+			maple_add_packet(maple_dev->mq);
+			liststatus++;
+		}
+	}
+
+	return 0;
+}
+
+static void maple_vblank_handler(struct work_struct *work)
+{
+	/* Turn off Maple DMA while we do this */
+	if (!maple_dma_done())
+		return;
+	if (!list_empty(&maple_sentq))
+		return;
+	mutex_lock(&maple_dma_lock);
+	ctrl_outl(0, MAPLE_ENABLE);
+	liststatus = 0;
+	bus_for_each_dev(&maple_bus_type, NULL, NULL,
+			 setup_maple_commands);
+	if (jiffies >= maple_pnp_time)
+		maple_pnp_time = jiffies + MAPLE_PNP_INTERVAL;
+	if (liststatus && list_empty(&maple_sentq)) {
+		INIT_LIST_HEAD(&maple_sentq);
+		maple_send();
+	}
+	mutex_unlock(&maple_dma_lock);
+	maplebus_init_hardware();
+}
+
+static void maple_map_subunits(struct maple_device *mdev, int submask)
+{
+	int retval, k, devcheck;
+	struct maple_device *mdev_add;
+	struct device_specify ds;
+
+	for (k = 0; k < 5; k++) {
+		ds.port = mdev->port;
+		ds.unit = k + 1;
+		retval =
+		    bus_for_each_dev(&maple_bus_type, NULL, &ds,
+				     detach_maple_device);
+		if (retval) {
+			submask = submask >> 1;
+			continue;
+		}
+		devcheck = submask & 0x01;
+		if (devcheck) {
+			mdev_add = maple_alloc_dev(mdev->port, k + 1);
+			if (!mdev_add)
+				return;
+			mdev_add->mq->command = MAPLE_COMMAND_DEVINFO;
+			mdev_add->mq->length = 0;
+			maple_add_packet(mdev_add->mq);
+			scanning = 1;
+		}
+		submask = submask >> 1;
+	}
+}
+
+static void maple_clean_submap(struct maple_device *mdev)
+{
+	int killbit;
+
+	killbit = (mdev->unit > 0 ? (1 << (mdev->unit - 1)) & 0x1f : 0x20);
+	killbit = ~killbit;
+	killbit &= 0xFF;
+	subdevice_map[mdev->port] = subdevice_map[mdev->port] & killbit;
+}
+
+static void maple_response_none(struct maple_device *mdev,
+				struct mapleq *mq)
+{
+	if (mdev->unit != 0) {
+		list_del(&mq->list);
+		maple_clean_submap(mdev);
+		printk(KERN_INFO "Maple bus detaching at (%d, %d)\n",
+			mdev->port, mdev->unit);
+		maple_detach_driver(mdev);
+		return;
+	}
+	if (!started) {
+		printk(KERN_INFO "No maple devices attached to port %d\n",
+		       mdev->port);
+		maple_attach_driver(mdev);
+		return;
+	}
+	maple_clean_submap(mdev);
+}
+
+static void maple_response_devinfo(struct maple_device *mdev,
+				   char *recvbuf)
+{
+	char submask;
+	if ((!started) || (scanning == 2)) {
+		maple_attach_driver(mdev);
+		return;
+	}
+	if (mdev->unit == 0) {
+		submask = recvbuf[2] & 0x1F;
+		if (submask ^ subdevice_map[mdev->port]) {
+			maple_map_subunits(mdev, submask);
+			subdevice_map[mdev->port] = submask;
+		}
+	}
+}
+
+static void maple_dma_handler(struct work_struct *work)
+{
+	struct mapleq *mq, *nmq;
+	struct maple_device *dev;
+	char *recvbuf;
+	enum maple_code code;
+
+	if (!maple_dma_done())
+		return;
+	mutex_lock(&maple_dma_lock);
+	ctrl_outl(0, MAPLE_ENABLE);
+
+	/* Be extra cautious and check new DMA cycle not already underway */
+	if (!list_empty(&maple_sentq)) {
+		list_for_each_entry_safe(mq, nmq, &maple_sentq, list) {
+			recvbuf = mq->recvbuf;
+			code = recvbuf[0];
+			dev = mq->dev;
+			switch (code) {
+			case MAPLE_RESPONSE_NONE:
+				maple_response_none(dev, mq);
+				break;
+
+			case MAPLE_RESPONSE_DEVINFO:
+				maple_response_devinfo(dev, recvbuf);
+				break;
+
+			case MAPLE_RESPONSE_DATATRF:
+				if (dev->callback)
+					dev->callback(mq);
+				break;
+
+			case MAPLE_RESPONSE_FILEERR:
+			case MAPLE_RESPONSE_AGAIN:
+			case MAPLE_RESPONSE_BADCMD:
+			case MAPLE_RESPONSE_BADFUNC:
+				printk(KERN_DEBUG
+				       "Maple non-fatal error 0x%X\n",
+				       code);
+				break;
+
+			case MAPLE_RESPONSE_ALLINFO:
+				printk(KERN_DEBUG
+				       "Maple - extended device information not supported\n");
+				break;
+
+			case MAPLE_RESPONSE_OK:
+				break;
+
+			default:
+				break;
+			}
+		}
+		INIT_LIST_HEAD(&maple_sentq);
+		if (scanning == 1) {
+			maple_send();
+			scanning = 2;
+		} else
+			scanning = 0;
+
+		if (started == 0)
+			started = 1;
+	}
+	mutex_unlock(&maple_dma_lock);
+	maplebus_init_hardware();
+}
+
+static irqreturn_t maplebus_dma_interrupt(int irq, void *dev_id)
+{
+	/* Load everything into the bottom half */
+	schedule_work(&maple_dma_process);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t maplebus_vblank_interrupt(int irq, void *dev_id)
+{
+	schedule_work(&maple_vblank_process);
+	return IRQ_HANDLED;
+}
+
+static struct irqaction maple_dma_irq = {
+	.name = "maple bus DMA handler",
+	.handler = maplebus_dma_interrupt,
+	.flags = IRQF_SHARED,
+};
+
+static struct irqaction maple_vblank_irq = {
+	.name = "maple bus VBLANK handler",
+	.handler = maplebus_vblank_interrupt,
+	.flags = IRQF_SHARED,
+};
+
+static int maple_set_dma_interrupt_handler(void)
+{
+	return setup_irq(HW_EVENT_MAPLE_DMA, &maple_dma_irq);
+}
+
+static int maple_set_vblank_interrupt_handler(void)
+{
+	return setup_irq(HW_EVENT_VSYNC, &maple_vblank_irq);
+}
+
+static int maple_get_dma_buffer(void)
+{
+	maple_sendbuf =
+	    (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
+				      MAPLE_DMA_PAGES);
+	if (!maple_sendbuf)
+		return -ENOMEM;
+	return 0;
+}
+
+static int match_maple_bus_driver(struct device *devptr,
+				  struct device_driver *drvptr)
+{
+	struct maple_driver *maple_drv;
+	struct maple_device *maple_dev;
+
+	maple_drv = container_of(drvptr, struct maple_driver, drv);
+	maple_dev = container_of(devptr, struct maple_device, dev);
+	/* Trap empty port case */
+	if (maple_dev->devinfo.function == 0xFFFFFFFF)
+		return 0;
+	else if (maple_dev->devinfo.function &
+			be32_to_cpu(maple_drv->function))
+		return 1;
+	return 0;
+}
+
+static int maple_bus_uevent(struct device *dev, char **envp,
+			    int num_envp, char *buffer, int buffer_size)
+{
+	return 0;
+}
+
+static void maple_bus_release(struct device *dev)
+{
+}
+
+static struct maple_driver maple_null_driver = {
+	.drv = {
+		.name = "Maple_bus_basic_driver",
+		.bus = 	&maple_bus_type,
+		},
+};
+
+struct bus_type maple_bus_type = {
+	.name = 	"maple",
+	.match = 	match_maple_bus_driver,
+	.uevent = 	maple_bus_uevent,
+};
+
+EXPORT_SYMBOL_GPL(maple_bus_type);
+
+static struct device maple_bus = {
+	.bus_id = "maple",
+	.release = maple_bus_release,
+};
+
+static int __init maple_bus_init(void)
+{
+	int retval, i;
+	struct maple_device *mdev[MAPLE_PORTS];
+	ctrl_outl(0, MAPLE_STATE);
+
+	retval = device_register(&maple_bus);
+	if (retval)
+		goto cleanup;
+
+	retval = bus_register(&maple_bus_type);
+	if (retval)
+		goto cleanup_device;
+
+	retval = driver_register(&maple_null_driver.drv);
+
+	if (retval)
+		goto cleanup_bus;
+
+	/* allocate memory for maple bus dma */
+	retval = maple_get_dma_buffer();
+	if (retval) {
+		printk(KERN_INFO
+		       "Maple bus: Failed to allocate Maple DMA buffers\n");
+		goto cleanup_basic;
+	}
+
+	/* set up DMA interrupt handler */
+	retval = maple_set_dma_interrupt_handler();
+	if (retval) {
+		printk(KERN_INFO
+		       "Maple bus: Failed to grab maple DMA IRQ\n");
+		goto cleanup_dma;
+	}
+
+	/* set up VBLANK interrupt handler */
+	retval = maple_set_vblank_interrupt_handler();
+	if (retval) {
+		printk(KERN_INFO "Maple bus: Failed to grab VBLANK IRQ\n");
+		goto cleanup_irq;
+	}
+
+	maple_cache =
+	    kmem_cache_create("Maplebus_cache", 0x400, 0,
+			      SLAB_HWCACHE_ALIGN, NULL);
+
+	if (!maple_cache)
+		goto cleanup_bothirqs;
+
+	/* setup maple ports */
+	for (i = 0; i < MAPLE_PORTS; i++) {
+		mdev[i] = maple_alloc_dev(i, 0);
+		if (!mdev[i]) {
+			while (i-- > 0)
+				maple_free_dev(mdev[i]);
+			goto cleanup_cache;
+		}
+		mdev[i]->registered = 0;
+		mdev[i]->mq->command = MAPLE_COMMAND_DEVINFO;
+		mdev[i]->mq->length = 0;
+		maple_add_packet(mdev[i]->mq);
+		subdevice_map[i] = 0;
+	}
+
+	/* setup maplebus hardware */
+	maplebus_init_hardware();
+
+	/* initial detection */
+	maple_send();
+
+	maple_pnp_time = 0;
+
+	printk(KERN_INFO "Maple bus core now registered.\n");
+
+	return 0;
+
+      cleanup_cache:
+	kmem_cache_destroy(maple_cache);
+
+      cleanup_bothirqs:
+	free_irq(HW_EVENT_VSYNC, 0);
+
+      cleanup_irq:
+	free_irq(HW_EVENT_MAPLE_DMA, 0);
+
+      cleanup_dma:
+	free_pages((unsigned long) maple_sendbuf, MAPLE_DMA_PAGES);
+
+      cleanup_basic:
+	driver_unregister(&maple_null_driver.drv);
+
+      cleanup_bus:
+	bus_unregister(&maple_bus_type);
+
+      cleanup_device:
+	device_unregister(&maple_bus);
+
+      cleanup:
+	printk(KERN_INFO "Maple bus registration failed\n");
+	return retval;
+}
+
+static int maple_remove_driver(struct device_driver *driver, void *ignored)
+{
+	driver_unregister(driver);
+	return 0;
+}
+
+static int maple_remove_device(struct device *dev, void *ignored)
+{
+	struct maple_device *mdev;
+	mdev = to_maple_dev(dev);
+	maple_detach_driver(mdev);
+	return 0;
+}
+
+static void __exit maple_bus_exit(void)
+{
+	int ignored;
+	free_irq(HW_EVENT_MAPLE_DMA, 0);
+	free_irq(HW_EVENT_VSYNC, 0);
+
+	ignored = bus_for_each_drv(&maple_bus_type, NULL, NULL,
+				   maple_remove_driver);
+	ignored = bus_for_each_dev(&maple_bus_type, NULL, NULL,
+				   maple_remove_device);
+
+	bus_unregister(&maple_bus_type);
+	device_unregister(&maple_bus);
+
+	kmem_cache_destroy(maple_cache);
+
+	if (maple_sendbuf)
+		free_pages((unsigned long) maple_sendbuf, MAPLE_DMA_PAGES);
+}
+
+/* use init call to ensure bus is registered ahead of devices */
+fs_initcall(maple_bus_init);
+module_exit(maple_bus_exit);
diff --git a/include/linux/maple.h b/include/linux/maple.h
new file mode 100644
index 0000000..8a37c7e
--- /dev/null
+++ b/include/linux/maple.h
@@ -0,0 +1,126 @@
+/**
+ * maple.h
+ *
+ * porting to 2.6 driver model
+ * copyright Adrian McMenamin, 2007
+ *
+ */
+
+extern struct bus_type maple_bus_type;
+extern struct mutex maple_dma_lock;
+
+#define MAPLE_PORTS 4
+#define MAPLE_PNP_INTERVAL HZ
+#define MAPLE_MAXPACKETS 8
+#define MAPLE_DMA_ORDER 14
+#define MAPLE_DMA_SIZE (1 << MAPLE_DMA_ORDER)
+#define MAPLE_DMA_PAGES ((MAPLE_DMA_ORDER > PAGE_SHIFT) ?
MAPLE_DMA_ORDER - PAGE_SHIFT : 0)
+
+/* Maple Bus registers */
+#define MAPLE_BASE	0xa05f6c00
+#define MAPLE_DMAADDR	(MAPLE_BASE+0x04)
+#define MAPLE_TRIGTYPE	(MAPLE_BASE+0x10)
+#define MAPLE_ENABLE	(MAPLE_BASE+0x14)
+#define MAPLE_STATE	(MAPLE_BASE+0x18)
+#define MAPLE_SPEED	(MAPLE_BASE+0x80)
+#define MAPLE_RESET	(MAPLE_BASE+0x8c)
+
+#define MAPLE_MAGIC	0x6155404f
+#define MAPLE_2MBPS	0
+#define	MAPLE_TIMEOUT(n) ((n)<<15)
+
+/* Maple Bus command and response codes */
+enum maple_code {
+	MAPLE_RESPONSE_FILEERR = -5,
+	MAPLE_RESPONSE_AGAIN = -4,	/* request should be retransmitted */
+	MAPLE_RESPONSE_BADCMD = -3,
+	MAPLE_RESPONSE_BADFUNC = -2,
+	MAPLE_RESPONSE_NONE = -1,	/* unit didn't respond at all */
+	MAPLE_COMMAND_DEVINFO = 1,
+	MAPLE_COMMAND_ALLINFO = 2,
+	MAPLE_COMMAND_RESET = 3,
+	MAPLE_COMMAND_KILL = 4,
+	MAPLE_RESPONSE_DEVINFO = 5,
+	MAPLE_RESPONSE_ALLINFO = 6,
+	MAPLE_RESPONSE_OK = 7,
+	MAPLE_RESPONSE_DATATRF = 8,
+	MAPLE_COMMAND_GETCOND = 9,
+	MAPLE_COMMAND_GETMINFO = 10,
+	MAPLE_COMMAND_BREAD = 11,
+	MAPLE_COMMAND_BWRITE = 12,
+	MAPLE_COMMAND_SETCOND = 14
+};
+
+/* Function codes */
+
+#define MAPLE_FUNC_CONTROLLER 0x001
+#define MAPLE_FUNC_MEMCARD    0x002
+#define MAPLE_FUNC_LCD        0x004
+#define MAPLE_FUNC_CLOCK      0x008
+#define MAPLE_FUNC_MICROPHONE 0x010
+#define MAPLE_FUNC_ARGUN      0x020
+#define MAPLE_FUNC_KEYBOARD   0x040
+#define MAPLE_FUNC_LIGHTGUN   0x080
+#define MAPLE_FUNC_PURUPURU   0x100
+#define MAPLE_FUNC_MOUSE      0x200
+
+struct mapleq {
+	struct list_head list;
+	struct maple_device *dev;
+	void *sendbuf, *recvbuf;
+	unsigned char length;
+	enum maple_code command;
+};
+
+struct maple_devinfo {
+	unsigned long function;
+	unsigned long function_data[3];
+	unsigned char area_code;
+	unsigned char connector_directon;
+	char product_name[31];
+	char product_licence[61];
+	unsigned short standby_power;
+	unsigned short max_power;
+};
+
+struct maple_device {
+	struct maple_driver *driver;
+	struct mapleq *mq;
+	void *private_data;
+	void (*callback) (struct mapleq * mq);
+	unsigned long when, interval, function;
+	struct maple_devinfo devinfo;
+	unsigned char port, unit;
+	char product_name[32];
+	char product_licence[64];
+	int registered;
+	struct device dev;
+};
+
+struct maple_driver {
+	unsigned long function;
+	int (*connect) (struct maple_device * dev);
+	void (*disconnect) (struct maple_device * dev);
+	struct device_driver drv;
+};
+
+struct device_specify {
+	int port;
+	int unit;
+};
+
+void maple_getcond_callback(struct maple_device *dev,
+			    void (*callback) (struct mapleq * mq),
+			    unsigned long interval,
+			    unsigned long function);
+
+void maple_setup_port_rescan(struct maple_device *mdev);
+
+void maplebus_init_hardware(void);
+
+int maple_dma_done(void);
+
+int maple_driver_register(struct device_driver *drv);
+
+#define to_maple_dev(n) container_of(n, struct maple_device, dev)
+#define to_maple_driver(n) container_of(n, struct maple_driver, drv)
