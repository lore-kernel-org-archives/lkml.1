Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbYFJWwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbYFJWwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbYFJWvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:51:55 -0400
Received: from the2masters.de ([213.146.113.64]:43030 "EHLO
	smtp.the2masters.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbYFJWvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:51:54 -0400
Subject: [patch 1/1] Add driver for GPIO on Via Epia-SN - vt8251
From: Stefan Hellermann <stefan@the2masters.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Bart Van Assche <bart.vanassche@gmail.com>
In-Reply-To: <20080610122732.1fabdf05@core>
References: <1213034405.2592.22.camel@hel-stefan.lan>
	 <20080610122732.1fabdf05@core>
Content-Type: text/plain; charset=utf8
Date: Wed, 11 Jun 2008 00:51:45 +0200
Message-Id: <1213138305.18629.31.camel@hel-stefan.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a first version which probably doesn't work. I wrote a small
userspace tool which uses the same ioports and it works. I can't test
this driver yet, because I don't know how to set or check bits with the
GPIO-framework.

Signed-off-by: Stefan Hellermann <stefan@the2masters.de>

---

> > Can anybody help me writing a small kernel-driver for this? I heard of
> > the GPIO-framework, but I have no clue where to start with. I simply
> > want to switch these ports to 0 or 1 :).
> > 
> This is a 5 minute hack on the Nat Semi Geode GPIO driver so you might
> need to debug it a bit as its untested.
> 

Thanks a lot for your work! It's so much easier to start with something
existing ...

I changed some lines and rewrote epiapd_gpio_set() because the output
bits are at position 1,4,6,7, not 0-3.

This is my first patch so please check everything! I already corrected
most errors spotted by scripts/checkpatch.pl.

My only problem: How to use this? Are there any sysfs-files I can use to
send bits to the device? Probably I have to enable the GPIO-framework
for the x86-architecture first. I tried some changes from ﻿David
Brownell to use gpiolib with x86 but these crashed my machine with
irq-failures (or maybe I simply sent the wrong bytes to the wrong
registers and then got crashes)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index d307bf2..fc4fbec 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -932,6 +932,12 @@ config GPIO_TB0219
 	depends on TANBAC_TB022X
 	select GPIO_VR41XX
 
+config GPIO_EPIAPD
+       tristate "EPIA-PD VT8251 GPIO support"
+       ---help---
+         This driver provides access to the GPI/GPO pins on the VT8251
+         EPIA-PD board.
+
 source "drivers/char/pcmcia/Kconfig"
 
 config MWAVE
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 4c1c584..b1e3234 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -96,6 +96,7 @@ obj-$(CONFIG_PC8736x_GPIO)	+= pc8736x_gpio.o
 obj-$(CONFIG_NSC_GPIO)		+= nsc_gpio.o
 obj-$(CONFIG_CS5535_GPIO)	+= cs5535_gpio.o
 obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
+obj-$(CONFIG_GPIO_EPIAPD)      += epiapd_gpio.o
 obj-$(CONFIG_GPIO_TB0219)	+= tb0219.o
 obj-$(CONFIG_TELCLOCK)		+= tlclk.o
 
diff --git a/drivers/char/epiapd_gpio.c b/drivers/char/epiapd_gpio.c
new file mode 100644
index 0000000..ef4d08a
--- /dev/null
+++ b/drivers/char/epiapd_gpio.c
@@ -0,0 +1,202 @@
+/* linux/drivers/char/epiapd_gpio.c
+ *
+ * This driver provides access to the GPI/GPO pins on the VT8251
+ *
+ * based on the Nat Semi GPIO driver
+ * Copyright (c) 2001,2002 Christer Weinigel <wingel@nano-system.com> 
+*/
+
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/pci.h>
+#include <linux/types.h>
+#include <linux/cdev.h>
+
+#define DRVNAME "epiapd_gpio"
+
+MODULE_AUTHOR("Alan Cox <alan@redhat.com>");
+MODULE_DESCRIPTION("EPIA-PD VIA VT8251 GPIO Pin Driver");
+MODULE_LICENSE("GPL");
+
+static int major = 0;		/* default to dynamic major */
+module_param(major, int, 0);
+MODULE_PARM_DESC(major, "Major device number");
+
+#define MAX_PINS 4		/* 4 input and 4 output */
+
+static u32 pmio;
+
+static void
+epiapd_gpio_set(int m, int v)
+{
+	u8 r = inb(pmio + 0x4C);
+
+	BUG_ON(m > 3);
+	BUG_ON(v > 1 || v < 0);
+
+	switch (m) {
+	case 0:
+		m = 1;
+		break;
+	case 1:
+		m = 4;
+		break;
+	case 2:
+		m = 6;
+		break;
+	case 3:
+		m = 7;
+		break;
+	}
+	r &= ~(1 << m);
+	r |= (v << m);
+	outb(r, pmio + 0x4C);
+}
+
+ssize_t epiapd_gpio_write(struct file *file, const char __user *data,
+				size_t len, loff_t *ppos)
+{
+	unsigned m = iminor(file->f_path.dentry->d_inode);
+	size_t i;
+	int err = 0;
+
+	for (i = 0; i < len; ++i) {
+		char c;
+		if (get_user(c, data + i)) {
+			err = -EFAULT;
+			break;
+		}
+		switch (c) {
+		case '0':
+			epiapd_gpio_set(m, 0);
+			break;
+		case '1':
+			epiapd_gpio_set(m, 1);
+			break;
+		case '\n':
+			/* end of settings string, do nothing */
+			break;
+		default:
+			err = -EINVAL;
+			break;
+		}
+	}
+	if (err && (i == 0))
+		return err;
+	return i;
+}
+
+ssize_t epiapd_gpio_read(struct file *file, char __user *buf,
+				size_t len, loff_t *ppos)
+{
+	unsigned m = iminor(file->f_path.dentry->d_inode);
+	u8 r;
+	u8 c = '0';
+
+	r = inb(pmio + 0x47) & 7;
+	r |= (inb(pmio + 0x49) & 1) << 3;
+
+	if (r & (1 << m))
+		c = '1';
+
+	if (put_user(c, buf))
+		return -EFAULT;
+	return 1;
+}
+
+static int epiapd_gpio_open(struct inode *inode, struct file *file)
+{
+	unsigned m = iminor(inode);
+	if (m >= MAX_PINS)
+		return -EINVAL;
+	return nonseekable_open(inode, file);
+}
+
+static int epiapd_gpio_release(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static const struct file_operations epiapd_gpio_fileops = {
+	.owner = THIS_MODULE,
+	.write = epiapd_gpio_write,
+	.read = epiapd_gpio_read,
+	.open = epiapd_gpio_open,
+	.release = epiapd_gpio_release,
+};
+
+static struct cdev epiapd_gpio_cdev;	/* use 1 cdev for all pins */
+
+static int __init epiapd_gpio_configure(void)
+{
+	struct pci_dev *pdev = pci_get_device(PCI_VENDOR_ID_VIA,
+					PCI_DEVICE_ID_VIA_8251, NULL);
+	u8 r;
+	if (pdev == NULL)
+		return -ENODEV;
+
+	/* get vt8251 pmio base address */
+	pci_read_config_dword(pdev, 0x88, &pmio);
+	pmio &= 0xFFFE;
+	if (pmio == 0)
+		return -ENODEV;
+
+	printk(KERN_DEBUG DRVNAME " pmio baseaddress: 0x%x\n", pmio);
+
+	/* Program the GPIO enable bits */
+	pci_read_config_byte(pdev, 0xE4, &r);
+	r &= ~0x0c;			/* bit 3+2 = 0 */
+	r |= 0x02;			/* bit 1 = 1 */
+	pci_write_config_byte(pdev, 0xE4, r);
+	pci_read_config_byte(pdev, 0x95, &r);
+	r |= 0x02;			/* bit 1 = 1 */
+	pci_write_config_byte(pdev, 0x95, r);
+
+	/* is this the right position for pci_dev_put? */
+	pci_dev_put(pdev);
+
+	return 0;
+}
+
+static int __init epiapd_gpio_init(void)
+{
+	int rc;
+	dev_t devid;
+
+	return epiapd_gpio_configure();
+
+	if (major) {
+		devid = MKDEV(major, 0);
+		rc = register_chrdev_region(devid, MAX_PINS, "epiapd_gpio");
+	} else {
+		rc = alloc_chrdev_region(&devid, 0, MAX_PINS, "epiapd_gpio");
+		major = MAJOR(devid);
+	}
+	if (rc < 0)
+		return rc;
+
+	printk(KERN_DEBUG DRVNAME " major: %d\n", major);
+
+	cdev_init(&epiapd_gpio_cdev, &epiapd_gpio_fileops);
+	cdev_add(&epiapd_gpio_cdev, devid, MAX_PINS);
+
+	return 0;
+}
+
+static void __exit epiapd_gpio_cleanup(void)
+{
+	cdev_del(&epiapd_gpio_cdev);
+
+	/* I don't know why the next is a comment */
+	/* cdev_put(&epiapd_gpio_cdev); */
+	unregister_chrdev_region(MKDEV(major, 0), MAX_PINS);
+}
+
+module_init(epiapd_gpio_init);
+module_exit(epiapd_gpio_cleanup);


