Return-Path: <linux-kernel-owner+w=401wt.eu-S1751863AbZKMMYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbZKMMYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 07:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZKMMYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 07:24:33 -0500
Received: from mail.windriver.com ([147.11.1.11]:35806 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZKMMYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 07:24:31 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] GPIO driver for ST Microelectronics ConneXt (STA2X11/STA2X10), PCIe I/O Hub
Date: Fri, 13 Nov 2009 13:23:26 +0100
Message-ID: <D87B22B1FE8C0F479CA9BEAD6C25AAE8043659AF@ism-mail03.corp.ad.wrs.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] GPIO driver for ST Microelectronics ConneXt (STA2X11/STA2X10), PCIe I/O Hub
thread-index: AcpkXBnkvDqOvuuXTMOBPtK3N8wrEw==
From: "Meng, Chen" <Chen.Meng@windriver.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-pci@vger.kernel.org>,
       "Wallin, Anders" <Anders.Wallin@windriver.com>,
       "Feng, Xiaobing" <Xiaobing.Feng@windriver.com>,
       "Li, Li" <Li.Li@windriver.com>, <giancarlo.asnaghi@st.com>
X-OriginalArrivalTime: 13 Nov 2009 12:23:31.0490 (UTC) FILETIME=[1CB56820:01CA645C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    This patch is a GPIO driver for  ST Microelectronics ConneXt
(STA2X11/STA2X10), PCIe I/O Hub.
    It's derived from pl061.c and compatible with GPIOLIB.
 

>From 1b5659d16fb08d7fd579f88d12f3c785a5be70c1 Mon Sep 17 00:00:00 2001
From: Chen Meng <chen.meng@windriver.com>
Date: Fri, 13 Nov 2009 19:39:26 +0800
Subject: [PATCH]   Add GPIO driver for ST Microelectronics ConneXt
(STA2X11/STA2X10),
   PCIe I/O Hub.
 
  Signed-off-by: Chen Meng <chen.meng@windriver.com>
  Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 drivers/gpio/Kconfig     |    7 +
 drivers/gpio/Makefile    |    1 +
 drivers/gpio/pl061_pci.c |  572
++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 580 insertions(+), 0 deletions(-)  create mode 100644
drivers/gpio/pl061_pci.c
 
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig index
2ad0128..8447f7a 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -230,4 +230,11 @@ config GPIO_UCB1400
    To compile this driver as a module, choose M here: the
    module will be called ucb1400_gpio.
 
+config GPIO_PL061_PCI
+ tristate "ConneXt PL061_PCI GPIO support"
+ depends on PCI
+ help
+   Say yes here to support the ST Microelectronics ConneXt
(STA2X11/STA2X10),
+   PCIe I/O Hub.
+
 endif
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile index
00a532c..1e8658a 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_GPIO_XILINX) += xilinx_gpio.o
 obj-$(CONFIG_GPIO_BT8XX) += bt8xxgpio.o
 obj-$(CONFIG_GPIO_VR41XX) += vr41xx_giu.o
 obj-$(CONFIG_GPIO_WM831X) += wm831x-gpio.o
+obj-$(CONFIG_GPIO_PL061_PCI) += pl061_pci.o
diff --git a/drivers/gpio/pl061_pci.c b/drivers/gpio/pl061_pci.c new
file mode 100644 index 0000000..3b3b036
--- /dev/null
+++ b/drivers/gpio/pl061_pci.c
@@ -0,0 +1,572 @@
+/*
+* linux/driver/gpio/pl061_pci.c, pl061 GPIO driver for conneXt
+*
+* ST Microelectronics ConneXt (STA2X11/STA2X10) GPIO file
+* derive from derived from linux/driver/gpio/pl061.c
+*
+* Copyright (c) 2009 Wind River Systems, Inc.
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+* See the GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 
+USA
+*
+*/
+
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/bitops.h>
+#include <linux/irq.h>
+#include <linux/gpio.h>
+
+#define DRV_VERSION "1.0"
+
+#define CHIP_REGS_LENGTH 0x1000 /* registers lenth for each GPIO */
+#define GPIO_BLOCKS  4 /* instances of GPIO blocks */
+#define PINS_PER_CHIP  32 /* pins for each GPIO */
+/* all gpio registers */
+#define GPIO_DAT  0x00
+#define GPIO_DATS 0x04
+#define GPIO_DATC 0x08
+#define GPIO_PDIS 0x0c
+#define GPIO_DIR  0x10
+#define GPIO_DIRS 0x14
+#define GPIO_DIRC 0x18
+#define GPIO_AFSELA 0x20
+#define GPIO_RIMSC 0x40
+#define GPIO_FIMSC 0x44
+#define GPIO_IS  0x48
+#define GPIO_IC  0x4c
+#define GPIOPeriphID0 0xfe0
+#define GPIOPeriphID1  0xfe4
+#define GPIOPeriphID2 0xfe8
+#define GPIOPeriphID3 0xfec
+#define GPIOPCellID0 0xff0
+#define GPIOPCellID1 0xff4
+#define GPIOPCellID2 0xff8
+#define GPIOPCellID3 0xffc
+
+#define PIN_NR (PINS_PER_CHIP * GPIO_BLOCKS) /* All pins */
+
+#define ppwrite(dat, base, adr) writel((dat), (base) + (adr))
+#define ppread(base, adr)  readl((base) + (adr))
+
+/** platform data for the PL061 PCI GPIO driver */ struct 
+pl061_pci_platform_data {
+ unsigned  gpio_base;
+ u32  directions; /* startup directions, 1: out, 0: in */
+ u32  values;
+};
+
+struct pl061_pci {
+ spinlock_t lock;
+ spinlock_t irq_lock;
+ /* base addr of each GPIO block */
+ void __iomem *reg_base[GPIO_BLOCKS];
+
+ unsigned irq_base;
+ unsigned char irq_type[PIN_NR];
+ u32 mutex[GPIO_BLOCKS];
+
+ /** save data for PM */
+ u32 saved_dat[GPIO_BLOCKS];
+ u32 saved_dir[GPIO_BLOCKS];
+ u32 saved_fimsc[GPIO_BLOCKS];
+ u32 saved_rimsc[GPIO_BLOCKS];
+
+ struct pci_dev *pdev;
+ struct gpio_chip gpio;
+ struct pl061_pci_platform_data pd;
+};
+
+int pl061_pci_gpio_request(struct gpio_chip *gpio, unsigned nr) {
+ struct pl061_pci *pp = container_of(gpio, struct pl061_pci, gpio);
+ u32 flag = 1 << (nr % PINS_PER_CHIP);
+ u32 *mutex = &pp->mutex[nr / PINS_PER_CHIP];
+
+ if (nr >= gpio->ngpio)
+  return -EINVAL;
+ if ((*mutex) & flag)
+  return -EBUSY;
+
+ *mutex |=  flag;
+
+ return 0;
+}
+
+void pl061_pci_gpio_free(struct gpio_chip *gpio, unsigned nr) {
+ struct pl061_pci *pp = container_of(gpio, struct pl061_pci, gpio);
+ u32 flag = 1 << (nr % PINS_PER_CHIP);
+ u32 *mutex = &pp->mutex[nr / PINS_PER_CHIP];
+
+ if (nr >= gpio->ngpio)
+  return;
+
+ *mutex &= ~flag;
+
+ return;
+}
+
+static int pl061_pci_gpio_direction_input(struct gpio_chip *gpio,
+     unsigned nr)
+{
+ struct pl061_pci *pp = container_of(gpio, struct pl061_pci, gpio);
+ unsigned long flags;
+ u32 gpio_dir;
+ void *base;
+
+ if (nr >= gpio->ngpio)
+  return -EINVAL;
+ base = pp->reg_base[nr / PINS_PER_CHIP];
+
+ spin_lock_irqsave(&pp->lock, flags);
+
+ gpio_dir = ppread(base, GPIO_DIR);
+ gpio_dir &= ~(1 << nr);
+ ppwrite(gpio_dir, base, GPIO_DIR);
+
+ spin_unlock_irqrestore(&pp->lock, flags);
+
+ return 0;
+}
+
+static int pl061_pci_gpio_direction_output(struct gpio_chip *gpio,
+     unsigned nr, int value)
+{
+ struct pl061_pci *pp = container_of(gpio, struct pl061_pci, gpio);
+ unsigned long flags;
+ u32 gpio_dir;
+ u32 data;
+ void *base;
+
+ if (nr >= gpio->ngpio)
+  return -EINVAL;
+ base = pp->reg_base[nr / PINS_PER_CHIP];
+
+ spin_lock_irqsave(&pp->lock, flags);
+
+ gpio_dir = ppread(base, GPIO_DIR);
+ gpio_dir |= 1 << nr;
+ ppwrite(gpio_dir, base, GPIO_DIR);
+ data = ppread(base, GPIO_DAT);
+ if (value)
+  data |= (1 << nr);
+ else
+  data &= ~(1 << nr);
+ ppwrite(data, base, GPIO_DAT);
+
+ spin_unlock_irqrestore(&pp->lock, flags);
+
+ return 0;
+}
+
+static int pl061_pci_gpio_get_value(struct gpio_chip *gpio, unsigned 
+nr) {
+ struct pl061_pci *pp = container_of(gpio, struct pl061_pci, gpio);
+ unsigned long flags;
+ u32 value;
+ void *base;
+
+ if (nr >= gpio->ngpio)
+  return -EINVAL;
+ base = pp->reg_base[nr / PINS_PER_CHIP];
+
+ spin_lock_irqsave(&pp->lock, flags);
+
+ value = ppread(base, GPIO_DAT);
+
+ spin_unlock_irqrestore(&pp->lock, flags);
+
+ return !!(value & (1 << nr));
+}
+
+static void pl061_pci_gpio_set_value(struct gpio_chip *gpio,
+    unsigned nr, int value)
+{
+ struct pl061_pci *pp = container_of(gpio, struct pl061_pci, gpio);
+ unsigned long flags;
+ u32 data;
+ void *base;
+
+ if (nr >= gpio->ngpio)
+  return;
+ base = pp->reg_base[nr / PINS_PER_CHIP];
+
+ spin_lock_irqsave(&pp->lock, flags);
+
+ data = ppread(base, GPIO_DAT);
+ if (value)
+  data |= (1 << nr);
+ else
+  data &= ~(1 << nr);
+ ppwrite(data, base, GPIO_DAT);
+
+ spin_unlock_irqrestore(&pp->lock, flags);
+ return;
+}
+
+static int pl061_pci_gpio_to_irq(struct gpio_chip *gpio, unsigned nr) {
+ struct pl061_pci *pp = container_of(gpio, struct pl061_pci, gpio);
+ void *base;
+
+ if (nr >= gpio->ngpio)
+  return -EINVAL;
+ base = pp->reg_base[nr / PINS_PER_CHIP];
+
+ if (pp->irq_base == (unsigned) -1)
+  return -EINVAL;
+
+ return pp->irq_base + nr;
+}
+
+/**
+ * PL061 GPIO IRQ
+ */
+static void pl061_pci_gpio_irq_disable(unsigned irq) {
+ struct pl061_pci *pp = get_irq_chip_data(irq);
+ unsigned nr = irq - pp->irq_base;
+ unsigned long flags;
+ u32 gpio_irq;
+ void *base;
+
+ if (nr >= pp->gpio.ngpio)
+  return;
+ base = pp->reg_base[nr / PINS_PER_CHIP];
+
+ spin_lock_irqsave(&pp->irq_lock, flags);
+
+ if (pp->irq_type[nr] & IRQ_TYPE_EDGE_RISING) {
+  gpio_irq = ppread(base, GPIO_RIMSC);
+  gpio_irq &= ~(1 << nr);
+  ppwrite(gpio_irq, base, GPIO_RIMSC);
+ }
+
+ if (pp->irq_type[nr] & IRQ_TYPE_EDGE_FALLING) {
+  gpio_irq = ppread(base, GPIO_FIMSC);
+  gpio_irq &= ~(1 << nr);
+  ppwrite(gpio_irq, base, GPIO_FIMSC);
+ }
+
+ spin_unlock_irqrestore(&pp->irq_lock, flags);
+ return;
+}
+
+static void pl061_pci_gpio_irq_enable(unsigned irq) {
+ struct pl061_pci *pp = get_irq_chip_data(irq);
+ unsigned nr = irq - pp->irq_base;
+ unsigned long flags;
+ u32 gpio_irq;
+ void *base;
+
+ if (nr >= pp->gpio.ngpio)
+  return;
+ base = pp->reg_base[nr / PINS_PER_CHIP];
+
+ spin_lock_irqsave(&pp->irq_lock, flags);
+
+ if (pp->irq_type[nr] & IRQ_TYPE_EDGE_RISING) {
+  gpio_irq = ppread(base, GPIO_RIMSC);
+  gpio_irq |= 1 << nr;
+  ppwrite(gpio_irq, base, GPIO_RIMSC);
+ }
+
+ if (pp->irq_type[nr] & IRQ_TYPE_EDGE_FALLING) {
+  gpio_irq = ppread(base, GPIO_FIMSC);
+  gpio_irq |= 1 << nr;
+  ppwrite(gpio_irq, base, GPIO_FIMSC);
+ }
+
+ spin_unlock_irqrestore(&pp->irq_lock, flags);
+ return;
+}
+
+static int pl061_pci_gpio_irq_type(unsigned irq, unsigned trigger) {
+ struct pl061_pci *pp = get_irq_chip_data(irq);
+ unsigned nr = irq - pp->irq_base;
+
+ if ((nr >= pp->gpio.ngpio)
+  || (trigger != IRQ_TYPE_EDGE_RISING
+   && trigger != IRQ_TYPE_EDGE_FALLING
+   && trigger != IRQ_TYPE_EDGE_BOTH))
+  return -EINVAL;
+
+ pp->irq_type[nr] = trigger;
+
+ return 0;
+}
+
+static struct irq_chip pl061_pci_gpio_irqchip = {
+ .name  = "GPIO",
+ .enable  = pl061_pci_gpio_irq_enable,
+ .disable = pl061_pci_gpio_irq_disable,
+ .set_type = pl061_pci_gpio_irq_type,
+};
+
+/** All GPIO pins share a hardware irq */ static void 
+pl061_pci_gpio_irq_handler(unsigned irq, struct irq_desc *desc) {
+ struct pl061_pci *pp = get_irq_chip_data(irq);
+ unsigned nr;
+ u32 gpio_is = 0;
+ int i;
+
+ for (i = 0; i < GPIO_BLOCKS; i++) {
+  gpio_is = ppread(pp->reg_base[i], GPIO_IS);
+  if (gpio_is == 0)
+   continue;
+  desc->chip->ack(irq);
+  for_each_bit(nr, (unsigned long *)&gpio_is, PINS_PER_CHIP)
+   generic_handle_irq(pl061_pci_gpio_to_irq(&pp->gpio,
+       nr));
+  desc->chip->unmask(irq);
+ }
+
+ return;
+}
+
+/** setup gpio chip */
+static void pl061_pci_gpio_setup(struct pl061_pci *pp) {
+ struct gpio_chip *chip = &(pp->gpio);
+
+ chip->request = pl061_pci_gpio_request;
+ chip->free = pl061_pci_gpio_free;
+ chip->direction_input = pl061_pci_gpio_direction_input;
+ chip->direction_output = pl061_pci_gpio_direction_output;
+ chip->get = pl061_pci_gpio_get_value;
+ chip->set = pl061_pci_gpio_set_value;
+ chip->to_irq = pl061_pci_gpio_to_irq;
+ chip->ngpio = PIN_NR;
+ chip->label = dev_name(&(pp->pdev->dev));
+ chip->dev = &(pp->pdev->dev);
+ chip->owner = THIS_MODULE;
+ chip->can_sleep = 1;
+ chip->base = pp->pd.gpio_base;
+
+ return;
+}
+
+static int pl061_pci_probe(struct pci_dev *pdev,
+   const struct pci_device_id *pci_id)
+{
+ struct pl061_pci *pp;
+ int err;
+ int i = 0;
+ unsigned int irq;
+
+ printk(KERN_INFO "pl061_pci: Module verison " DRV_VERSION "\n");
+ pp = kzalloc(sizeof(*pp), GFP_KERNEL);
+ if (!pp)
+  return -ENOMEM;
+
+ pp->pdev = pdev;
+ pp->pd.directions = 0x0;
+ pp->pd.values = 0x0;
+ pp->irq_base = NR_IRQS - PIN_NR;
+ pp->pd.gpio_base = 0;
+
+ spin_lock_init(&(pp->lock));
+ spin_lock_init(&(pp->irq_lock));
+
+ err = pci_enable_device(pdev);
+ if (err) {
+  printk(KERN_ERR "pl061_pci: Can't enable device.\n");
+  goto err_freepp;
+ }
+ if (pci_resource_len(pdev, 0) < CHIP_REGS_LENGTH * GPIO_BLOCKS) {
+  err = -ENOSPC;
+  goto err_freepp;
+ }
+ if (!request_mem_region(pci_resource_start(pdev, 0),
+    CHIP_REGS_LENGTH * GPIO_BLOCKS,
+    "pl061_pci")) {
+  printk(KERN_WARNING "pl061_pci: Can't request iomem (0x%llx).\n",
+         (unsigned long long)pci_resource_start(pdev, 0));
+  err = -EBUSY;
+  goto err_disable;
+ }
+ pci_set_master(pdev);
+ pci_set_drvdata(pdev, pp);
+
+ /** init register base for each GPIO */
+ pp->reg_base[0] = ioremap(pci_resource_start(pdev, 0),
+   CHIP_REGS_LENGTH * GPIO_BLOCKS);
+ if (!pp->reg_base[0]) {
+  printk(KERN_ERR "pl061_pci: ioremap() failed\n");
+  err = -EIO;
+  goto err_release_mem;
+ }
+
+ for (i = 1; i < GPIO_BLOCKS; i++)
+  pp->reg_base[i] =  pp->reg_base[i-1] + CHIP_REGS_LENGTH;
+
+ pl061_pci_gpio_setup(pp);
+ err = gpiochip_add(&pp->gpio);
+ if (err) {
+  printk(KERN_ERR "pl061_pci: Failed to register GPIOs\n");
+  goto err_release_mem;
+ }
+
+ printk(KERN_INFO "pl061_pci: Abusing pl061_pci card for GPIOs\n");
+
+ /** disable all irqs */
+ for (i = 0; i < GPIO_BLOCKS; i++)
+  ppwrite(0xffffffff, pp->reg_base[i], GPIO_IC);
+
+ irq = pdev->irq;
+ if (irq < 0) {
+  err = -ENODEV;
+  goto err_iounmap;
+ }
+
+ set_irq_chip_data(irq, pp);
+ set_irq_chained_handler(irq, pl061_pci_gpio_irq_handler);
+
+ for (i = 0; i < GPIO_BLOCKS * PINS_PER_CHIP; i++) {
+  if (pp->pd.directions & (1 << i))
+   pl061_pci_gpio_direction_output(&pp->gpio, i,
+     pp->pd.values & (1 << i));
+  else
+   pl061_pci_gpio_direction_input(&pp->gpio, i);
+
+  set_irq_chip(i+pp->irq_base, &pl061_pci_gpio_irqchip);
+  set_irq_handler(i+pp->irq_base, handle_simple_irq);
+  set_irq_chip_data(i+pp->irq_base, pp);
+ }
+
+ return 0;
+err_iounmap:
+ iounmap(pp->reg_base[0]);
+err_release_mem:
+ release_mem_region(pci_resource_start(pdev, 0),
+      CHIP_REGS_LENGTH * GPIO_BLOCKS);
+ pci_set_drvdata(pdev, NULL);
+err_disable:
+ pci_disable_device(pdev);
+err_freepp:
+ kfree(pp);
+
+ return err;
+}
+
+static void pl061_pci_remove(struct pci_dev *pdev) {
+ struct pl061_pci *pp = pci_get_drvdata(pdev);
+
+ if (gpiochip_remove(&pp->gpio) != 0)
+  printk(KERN_WARNING"pl061_pci: GPIO is busy\n");
+
+ iounmap(pp->reg_base[0]);
+ release_mem_region(pci_resource_start(pdev, 0),
+      CHIP_REGS_LENGTH * GPIO_BLOCKS);
+ pci_disable_device(pdev);
+ pci_set_drvdata(pdev, NULL);
+ kfree(pp);
+
+ return;
+}
+
+static int pl061_pci_suspend(struct pci_dev *pdev, pm_message_t state) 
+{
+ struct pl061_pci *pp = pci_get_drvdata(pdev);
+ unsigned long flags;
+ int i;
+
+ spin_lock_irqsave(&pp->lock, flags);
+
+ for (i = 0; i < GPIO_BLOCKS; i++) {
+  pp->saved_dat[i] = ppread(pp->reg_base[i], GPIO_DAT);
+  pp->saved_dir[i] = ppread(pp->reg_base[i], GPIO_DIRS);
+  pp->saved_fimsc[i] = ppread(pp->reg_base[i], GPIO_FIMSC);
+  pp->saved_rimsc[i] = ppread(pp->reg_base[i], GPIO_RIMSC);
+
+  ppwrite(0xffffffff, pp->reg_base[i], GPIO_IC);
+  ppwrite(0x0, pp->reg_base[i], GPIO_DIR);
+ }
+
+ spin_unlock_irqrestore(&pp->lock, flags);
+
+ pci_save_state(pdev);
+ pci_disable_device(pdev);
+ pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
+ return 0;
+}
+
+static int pl061_pci_resume(struct pci_dev *pdev) {
+ struct pl061_pci *pp = pci_get_drvdata(pdev);
+ unsigned long flags;
+ int err;
+ int i;
+
+ pci_set_power_state(pdev, 0);
+ err = pci_enable_device(pdev);
+ if (err)
+  return err;
+ pci_restore_state(pdev);
+
+ spin_lock_irqsave(&pp->lock, flags);
+
+ for (i = 0; i < GPIO_BLOCKS; i++) {
+  ppwrite(pp->saved_dat[i], pp->reg_base[i], GPIO_DAT);
+  ppwrite(pp->saved_dir[i], pp->reg_base[i], GPIO_DIRS);
+  ppwrite(pp->saved_fimsc[i], pp->reg_base[i], GPIO_FIMSC);
+  ppwrite(pp->saved_rimsc[i], pp->reg_base[i], GPIO_RIMSC);
+ }
+
+ spin_unlock_irqrestore(&pp->lock, flags);
+
+ return 0;
+}
+
+static struct pci_device_id pl061_pci_tbl[] = {
+ { PCI_DEVICE(PCI_VENDOR_ID_STMICRO, PCI_DEVICE_ID_STMICRO_GPIO) },
+ { 0, },
+};
+MODULE_DEVICE_TABLE(pci, pl061_pci_tbl);
+
+static struct pci_driver pl061_pci_driver = {
+ .name  = "pl061_pci",
+ .id_table  = pl061_pci_tbl,
+ .probe  = pl061_pci_probe,
+ .remove  = pl061_pci_remove,
+ .suspend  = pl061_pci_suspend,
+ .resume  = pl061_pci_resume,
+};
+
+static int pl061_pci_init(void)
+{
+ return pci_register_driver(&pl061_pci_driver);
+}
+module_init(pl061_pci_init);
+
+static void pl061_pci_exit(void)
+{
+ pci_unregister_driver(&pl061_pci_driver);
+ return;
+}
+module_exit(pl061_pci_exit);
+
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Chen Meng");
+MODULE_DESCRIPTION("pl061 GPIO driver for conneXt");
--
1.6.0.4
