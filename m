Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab0BRPP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 10:15:26 -0500
Received: from compulab.co.il ([67.18.134.219]:59591 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133Ab0BRPPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 10:15:24 -0500
Message-ID: <4B7D59B9.2070406@compulab.co.il>
Date: Thu, 18 Feb 2010 17:16:09 +0200
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: David Brownell <dbrownell@users.sourceforge.net>
Subject: gpio: introduce it8761e_gpio driver for IT8761E Super I/O chip
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Turischev <denis@compulab.co.il>

diff -Nru linux-2.6.33-rc7.orig/drivers/gpio/it8761e_gpio.c linux-2.6.33-rc7/drivers/gpio/it8761e_gpio.c
--- linux-2.6.33-rc7.orig/drivers/gpio/it8761e_gpio.c	1970-01-01 02:00:00.000000000 +0200
+++ linux-2.6.33-rc7/drivers/gpio/it8761e_gpio.c	2010-02-18 17:04:15.000000000 +0200
@@ -0,0 +1,231 @@
+/*
+ *  it8761_gpio.c - GPIO interface for IT8761E Super I/O chip
+ *
+ *  Author: Denis Turischev <denis@compulab.co.il>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License 2 as published
+ *  by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/errno.h>
+#include <linux/ioport.h>
+
+#include <linux/gpio.h>
+
+#define SIO_CHIP_ID		0x8761
+#define CHIP_ID_HIGH_BYTE	0x20
+#define CHIP_ID_LOW_BYTE	0x21
+
+static u8 ports[2] = { 0x2e, 0x4e };
+static u8 port;
+
+static DEFINE_SPINLOCK(sio_lock);
+
+#define GPIO_NAME		"it8761-gpio"
+#define GPIO_BA_HIGH_BYTE	0x60
+#define GPIO_BA_LOW_BYTE	0x61
+#define GPIO_IOSIZE		4
+#define GPIO1X_IO		0xf0
+#define GPIO2X_IO		0xf1
+
+static u16 gpio_ba;
+
+static u8 read_reg(u8 addr, u8 port)
+{
+	outb(addr, port);
+	return inb(port + 1);
+}
+
+static void write_reg(u8 data, u8 addr, u8 port)
+{
+	outb(addr, port);
+	outb(data, port + 1);
+}
+
+static void enter_conf_mode(u8 port)
+{
+	outb(0x87, port);
+	outb(0x61, port);
+	outb(0x55, port);
+	outb((port == 0x2e) ? 0x55 : 0xaa, port);
+}
+
+static void exit_conf_mode(u8 port)
+{
+	outb(0x2, port);
+	outb(0x2, port + 1);
+}
+
+static void enter_gpio_mode(u8 port)
+{
+	write_reg(0x2, 0x7, port);
+}
+
+static int it8761e_gpio_get(struct gpio_chip *gc, unsigned gpio_num)
+{
+	u16 reg;
+	u8 bit;
+
+	bit = gpio_num % 7;
+	reg = (gpio_num >= 7) ? gpio_ba + 1 : gpio_ba;
+
+	return !!(inb(reg) & (1 << bit));
+}
+
+static int it8761e_gpio_direction_in(struct gpio_chip *gc, unsigned gpio_num)
+{
+	u8 curr_dirs;
+	u8 io_reg, bit;
+
+	bit = gpio_num % 7;
+	io_reg = (gpio_num >= 7) ? GPIO2X_IO : GPIO1X_IO;
+
+	spin_lock(&sio_lock);
+
+	enter_conf_mode(port);
+	enter_gpio_mode(port);
+
+	curr_dirs = read_reg(io_reg, port);
+
+	if (curr_dirs & (1 << bit))
+		write_reg(curr_dirs & ~(1 << bit), io_reg, port);
+
+	exit_conf_mode(port);
+
+	spin_unlock(&sio_lock);
+	return 0;
+}
+
+static void it8761e_gpio_set(struct gpio_chip *gc,
+				unsigned gpio_num, int val)
+{
+	u8 curr_vals, bit;
+	u16 reg;
+
+	bit = gpio_num % 7;
+	reg = (gpio_num >= 7) ? gpio_ba + 1 : gpio_ba;
+
+	spin_lock(&sio_lock);
+
+	curr_vals = inb(reg);
+	if (val)
+		outb(curr_vals | (1 << bit) , reg);
+	else
+		outb(curr_vals & ~(1 << bit), reg);
+
+	spin_unlock(&sio_lock);
+}
+
+static int it8761e_gpio_direction_out(struct gpio_chip *gc,
+					unsigned gpio_num, int val)
+{
+	u8 curr_dirs, io_reg, bit;
+
+	bit = gpio_num % 7;
+	io_reg = (gpio_num >= 7) ? GPIO2X_IO : GPIO1X_IO;
+
+	it8761e_gpio_set(gc, gpio_num, val);
+
+	spin_lock(&sio_lock);
+
+	enter_conf_mode(port);
+	enter_gpio_mode(port);
+
+	curr_dirs = read_reg(io_reg, port);
+
+	if (!(curr_dirs & (1 << bit)))
+		write_reg(curr_dirs | (1 << bit), io_reg, port);
+
+	exit_conf_mode(port);
+
+	spin_unlock(&sio_lock);
+	return 0;
+}
+
+static struct gpio_chip it8761e_gpio_chip = {
+	.label			= GPIO_NAME,
+	.owner			= THIS_MODULE,
+	.get			= it8761e_gpio_get,
+	.direction_input	= it8761e_gpio_direction_in,
+	.set			= it8761e_gpio_set,
+	.direction_output	= it8761e_gpio_direction_out,
+};
+
+static int __init it8761e_gpio_init(void)
+{
+	int i, id, err;
+
+	/* chip and port detection */
+	for (i = 0; i < ARRAY_SIZE(ports); i++) {
+		spin_lock(&sio_lock);
+		enter_conf_mode(ports[i]);
+
+		id = (read_reg(CHIP_ID_HIGH_BYTE, ports[i]) << 8) +
+				read_reg(CHIP_ID_LOW_BYTE, ports[i]);
+
+		exit_conf_mode(ports[i]);
+		spin_unlock(&sio_lock);
+
+		if (id == SIO_CHIP_ID) {
+			port = ports[i];
+			break;
+		}
+	}
+
+	if (!port)
+		return -ENODEV;
+
+	/* fetch GPIO base address */
+	enter_conf_mode(port);
+	enter_gpio_mode(port);
+	gpio_ba = (read_reg(GPIO_BA_HIGH_BYTE, port) << 8) +
+				read_reg(GPIO_BA_LOW_BYTE, port);
+	exit_conf_mode(port);
+
+	if (!request_region(gpio_ba, GPIO_IOSIZE, GPIO_NAME))
+		return -EBUSY;
+
+	it8761e_gpio_chip.base = -1;
+	it8761e_gpio_chip.ngpio = 14;
+
+	err = gpiochip_add(&it8761e_gpio_chip);
+	if (err < 0)
+		goto gpiochip_add_err;
+
+	return 0;
+
+gpiochip_add_err:
+	release_region(gpio_ba, GPIO_IOSIZE);
+	gpio_ba = 0;
+	return err;
+}
+
+static void __exit it8761e_gpio_exit(void)
+{
+	if (gpio_ba) {
+		gpiochip_remove(&it8761e_gpio_chip);
+
+		release_region(gpio_ba, GPIO_IOSIZE);
+		gpio_ba = 0;
+	}
+}
+module_init(it8761e_gpio_init);
+module_exit(it8761e_gpio_exit);
+
+MODULE_AUTHOR("Denis Turischev <denis@compulab.co.il>");
+MODULE_DESCRIPTION("GPIO interface for IT8761E Super I/O chip");
+MODULE_LICENSE("GPL");
diff -Nru linux-2.6.33-rc7.orig/drivers/gpio/Kconfig linux-2.6.33-rc7/drivers/gpio/Kconfig
--- linux-2.6.33-rc7.orig/drivers/gpio/Kconfig	2010-02-07 00:17:12.000000000 +0200
+++ linux-2.6.33-rc7/drivers/gpio/Kconfig	2010-02-17 18:52:33.000000000 +0200
@@ -85,6 +85,12 @@
  	help
  	  Say yes here to support the NEC VR4100 series General-purpose I/O Uint

+config GPIO_IT8761E
+	tristate "IT8761E GPIO support"
+	depends on GPIOLIB
+	help
+	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
+
  comment "I2C GPIO expanders:"

  config GPIO_MAX732X
diff -Nru linux-2.6.33-rc7.orig/drivers/gpio/Makefile linux-2.6.33-rc7/drivers/gpio/Makefile
--- linux-2.6.33-rc7.orig/drivers/gpio/Makefile	2010-02-07 00:17:12.000000000 +0200
+++ linux-2.6.33-rc7/drivers/gpio/Makefile	2010-02-17 18:53:15.000000000 +0200
@@ -22,3 +22,4 @@
  obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
  obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
  obj-$(CONFIG_GPIO_WM831X)	+= wm831x-gpio.o
+obj-$(CONFIG_GPIO_IT8761E)	+= it8761e_gpio.o
