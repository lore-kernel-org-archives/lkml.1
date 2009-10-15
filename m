Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZJOGqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZJOGqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbZJOGqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:46:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497AbZJOGqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:46:04 -0400
Date: Thu, 15 Oct 2009 02:45:23 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Krzysztof Helt <krzysztof.h1@wp.pl>,
       Amerigo Wang <amwang@redhat.com>, Jean Delvare <khali@linux-fr.org>
Message-Id: <20091015064805.4448.50695.sendpatchset@localhost.localdomain>
Subject: [Patch] i2c: remove deprecated i2c-voodoo3 driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This driver is scheduled to be removed now.

Cc: Jean Delvare <khali@linux-fr.org>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: WANG Cong <amwang@redhat.com>


---
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 04e6c81..6bf9a76 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -404,15 +404,6 @@ Who:	Alex Chiang <achiang@hp.com>
 
 ---------------------------
 
-What:	i2c-voodoo3 driver
-When:	October 2009
-Why:	Superseded by tdfxfb. I2C/DDC support used to live in a separate
-	driver but this caused driver conflicts.
-Who:	Jean Delvare <khali@linux-fr.org>
-	Krzysztof Helt <krzysztof.h1@wp.pl>
-
----------------------------
-
 What:	CONFIG_RFKILL_INPUT
 When:	2.6.33
 Why:	Should be implemented in userspace, policy daemon.
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 737335f..bc81700 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -640,22 +640,6 @@ config I2C_TINY_USB
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-tiny-usb.
 
-comment "Graphics adapter I2C/DDC channel drivers"
-	depends on PCI
-
-config I2C_VOODOO3
-	tristate "Voodoo 3 (DEPRECATED)"
-	depends on PCI
-	select I2C_ALGOBIT
-	help
-	  If you say yes to this option, support will be included for the
-	  Voodoo 3 I2C interface. This driver is deprecated and you should
-	  use the tdfxfb driver instead, which additionally provides
-	  framebuffer support.
-
-	  This driver can also be built as a module.  If so, the module
-	  will be called i2c-voodoo3.
-
 comment "Other I2C/SMBus bus drivers"
 
 config I2C_ACORN
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index ff937ac..302c551 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -61,9 +61,6 @@ obj-$(CONFIG_I2C_PARPORT_LIGHT)	+= i2c-parport-light.o
 obj-$(CONFIG_I2C_TAOS_EVM)	+= i2c-taos-evm.o
 obj-$(CONFIG_I2C_TINY_USB)	+= i2c-tiny-usb.o
 
-# Graphics adapter I2C/DDC channel drivers
-obj-$(CONFIG_I2C_VOODOO3)	+= i2c-voodoo3.o
-
 # Other I2C/SMBus bus drivers
 obj-$(CONFIG_I2C_ACORN)		+= i2c-acorn.o
 obj-$(CONFIG_I2C_ELEKTOR)	+= i2c-elektor.o
diff --git a/drivers/i2c/busses/i2c-voodoo3.c b/drivers/i2c/busses/i2c-voodoo3.c
deleted file mode 100644
index 7663d57..0000000
--- a/drivers/i2c/busses/i2c-voodoo3.c
+++ /dev/null
@@ -1,248 +0,0 @@
-/*
-    Copyright (c) 1998, 1999  Frodo Looijaard <frodol@dds.nl>,
-    Philip Edelbrock <phil@netroedge.com>,
-    Ralph Metzler <rjkm@thp.uni-koeln.de>, and
-    Mark D. Studebaker <mdsxyz123@yahoo.com>
-    
-    Based on code written by Ralph Metzler <rjkm@thp.uni-koeln.de> and
-    Simon Vogl
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-
-/* This interfaces to the I2C bus of the Voodoo3 to gain access to
-    the BT869 and possibly other I2C devices. */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/i2c.h>
-#include <linux/i2c-algo-bit.h>
-#include <asm/io.h>
-
-/* the only registers we use */
-#define REG		0x78
-#define REG2 		0x70
-
-/* bit locations in the register */
-#define DDC_ENAB	0x00040000
-#define DDC_SCL_OUT	0x00080000
-#define DDC_SDA_OUT	0x00100000
-#define DDC_SCL_IN	0x00200000
-#define DDC_SDA_IN	0x00400000
-#define I2C_ENAB	0x00800000
-#define I2C_SCL_OUT	0x01000000
-#define I2C_SDA_OUT	0x02000000
-#define I2C_SCL_IN	0x04000000
-#define I2C_SDA_IN	0x08000000
-
-/* initialization states */
-#define INIT2		0x2
-#define INIT3		0x4
-
-/* delays */
-#define CYCLE_DELAY	10
-#define TIMEOUT		(HZ / 2)
-
-
-static void __iomem *ioaddr;
-
-/* The voo GPIO registers don't have individual masks for each bit
-   so we always have to read before writing. */
-
-static void bit_vooi2c_setscl(void *data, int val)
-{
-	unsigned int r;
-	r = readl(ioaddr + REG);
-	if (val)
-		r |= I2C_SCL_OUT;
-	else
-		r &= ~I2C_SCL_OUT;
-	writel(r, ioaddr + REG);
-	readl(ioaddr + REG);	/* flush posted write */
-}
-
-static void bit_vooi2c_setsda(void *data, int val)
-{
-	unsigned int r;
-	r = readl(ioaddr + REG);
-	if (val)
-		r |= I2C_SDA_OUT;
-	else
-		r &= ~I2C_SDA_OUT;
-	writel(r, ioaddr + REG);
-	readl(ioaddr + REG);	/* flush posted write */
-}
-
-/* The GPIO pins are open drain, so the pins always remain outputs.
-   We rely on the i2c-algo-bit routines to set the pins high before
-   reading the input from other chips. */
-
-static int bit_vooi2c_getscl(void *data)
-{
-	return (0 != (readl(ioaddr + REG) & I2C_SCL_IN));
-}
-
-static int bit_vooi2c_getsda(void *data)
-{
-	return (0 != (readl(ioaddr + REG) & I2C_SDA_IN));
-}
-
-static void bit_vooddc_setscl(void *data, int val)
-{
-	unsigned int r;
-	r = readl(ioaddr + REG);
-	if (val)
-		r |= DDC_SCL_OUT;
-	else
-		r &= ~DDC_SCL_OUT;
-	writel(r, ioaddr + REG);
-	readl(ioaddr + REG);	/* flush posted write */
-}
-
-static void bit_vooddc_setsda(void *data, int val)
-{
-	unsigned int r;
-	r = readl(ioaddr + REG);
-	if (val)
-		r |= DDC_SDA_OUT;
-	else
-		r &= ~DDC_SDA_OUT;
-	writel(r, ioaddr + REG);
-	readl(ioaddr + REG);	/* flush posted write */
-}
-
-static int bit_vooddc_getscl(void *data)
-{
-	return (0 != (readl(ioaddr + REG) & DDC_SCL_IN));
-}
-
-static int bit_vooddc_getsda(void *data)
-{
-	return (0 != (readl(ioaddr + REG) & DDC_SDA_IN));
-}
-
-static int config_v3(struct pci_dev *dev)
-{
-	unsigned long cadr;
-
-	/* map Voodoo3 memory */
-	cadr = dev->resource[0].start;
-	cadr &= PCI_BASE_ADDRESS_MEM_MASK;
-	ioaddr = ioremap_nocache(cadr, 0x1000);
-	if (ioaddr) {
-		writel(0x8160, ioaddr + REG2);
-		writel(0xcffc0020, ioaddr + REG);
-		dev_info(&dev->dev, "Using Banshee/Voodoo3 I2C device at %p\n", ioaddr);
-		return 0;
-	}
-	return -ENODEV;
-}
-
-static struct i2c_algo_bit_data voo_i2c_bit_data = {
-	.setsda		= bit_vooi2c_setsda,
-	.setscl		= bit_vooi2c_setscl,
-	.getsda		= bit_vooi2c_getsda,
-	.getscl		= bit_vooi2c_getscl,
-	.udelay		= CYCLE_DELAY,
-	.timeout	= TIMEOUT
-};
-
-static struct i2c_adapter voodoo3_i2c_adapter = {
-	.owner		= THIS_MODULE,
-	.name		= "I2C Voodoo3/Banshee adapter",
-	.algo_data	= &voo_i2c_bit_data,
-};
-
-static struct i2c_algo_bit_data voo_ddc_bit_data = {
-	.setsda		= bit_vooddc_setsda,
-	.setscl		= bit_vooddc_setscl,
-	.getsda		= bit_vooddc_getsda,
-	.getscl		= bit_vooddc_getscl,
-	.udelay		= CYCLE_DELAY,
-	.timeout	= TIMEOUT
-};
-
-static struct i2c_adapter voodoo3_ddc_adapter = {
-	.owner		= THIS_MODULE,
-	.class		= I2C_CLASS_DDC, 
-	.name		= "DDC Voodoo3/Banshee adapter",
-	.algo_data	= &voo_ddc_bit_data,
-};
-
-static struct pci_device_id voodoo3_ids[] __devinitdata = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_3DFX, PCI_DEVICE_ID_3DFX_VOODOO3) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_3DFX, PCI_DEVICE_ID_3DFX_BANSHEE) },
-	{ 0, }
-};
-
-MODULE_DEVICE_TABLE (pci, voodoo3_ids);
-
-static int __devinit voodoo3_probe(struct pci_dev *dev, const struct pci_device_id *id)
-{
-	int retval;
-
-	retval = config_v3(dev);
-	if (retval)
-		return retval;
-
-	/* set up the sysfs linkage to our parent device */
-	voodoo3_i2c_adapter.dev.parent = &dev->dev;
-	voodoo3_ddc_adapter.dev.parent = &dev->dev;
-
-	retval = i2c_bit_add_bus(&voodoo3_i2c_adapter);
-	if (retval)
-		return retval;
-	retval = i2c_bit_add_bus(&voodoo3_ddc_adapter);
-	if (retval)
-		i2c_del_adapter(&voodoo3_i2c_adapter);
-	return retval;
-}
-
-static void __devexit voodoo3_remove(struct pci_dev *dev)
-{
-	i2c_del_adapter(&voodoo3_i2c_adapter);
-	i2c_del_adapter(&voodoo3_ddc_adapter);
-	iounmap(ioaddr);
-}
-
-static struct pci_driver voodoo3_driver = {
-	.name		= "voodoo3_smbus",
-	.id_table	= voodoo3_ids,
-	.probe		= voodoo3_probe,
-	.remove		= __devexit_p(voodoo3_remove),
-};
-
-static int __init i2c_voodoo3_init(void)
-{
-	return pci_register_driver(&voodoo3_driver);
-}
-
-static void __exit i2c_voodoo3_exit(void)
-{
-	pci_unregister_driver(&voodoo3_driver);
-}
-
-
-MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl>, "
-		"Philip Edelbrock <phil@netroedge.com>, "
-		"Ralph Metzler <rjkm@thp.uni-koeln.de>, "
-		"and Mark D. Studebaker <mdsxyz123@yahoo.com>");
-MODULE_DESCRIPTION("Voodoo3 I2C/SMBus driver");
-MODULE_LICENSE("GPL");
-
-module_init(i2c_voodoo3_init);
-module_exit(i2c_voodoo3_exit);
