Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbYFJLoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbYFJLoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 07:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYFJLoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 07:44:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54113 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751937AbYFJLoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 07:44:14 -0400
Date: Tue, 10 Jun 2008 12:27:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stefan Hellermann <stefan@the2masters.de>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: GPIO-Ports on VIA EPIA-SN
Message-ID: <20080610122732.1fabdf05@core>
In-Reply-To: <1213034405.2592.22.camel@hel-stefan.lan>
References: <1213034405.2592.22.camel@hel-stefan.lan>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can anybody help me writing a small kernel-driver for this? I heard of
> the GPIO-framework, but I have no clue where to start with. I simply
> want to switch these ports to 0 or 1 :).
> 
> I don't know under what license this documentation is, I simply got
> these 6 pages with sample source code.

This is a 5 minute hack on the Nat Semi Geode GPIO driver so you might
need to debug it a bit as its untested.

epiapd_gpio:  driver for EPIA-PD

From: Alan Cox <alan@redhat.com>

This is a simple driver for the EPIA-PD GPIO lines
---

 drivers/char/Kconfig       |    6 +
 drivers/char/Makefile      |    1 
 drivers/char/epiapd_gpio.c |  182 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 189 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/epiapd_gpio.c


diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 595a925..c308e15 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -932,6 +932,12 @@ config GPIO_TB0219
 	depends on TANBAC_TB022X
 	select GPIO_VR41XX
 
+config GPIO_EPIAPD
+	tristate "EPIA-PD VT8251 GPIO support"
+	---help---
+	  This driver provides access to the GPI/GPO pins on the VT8251
+	  EPIA-PD board.
+
 source "drivers/char/pcmcia/Kconfig"
 
 config MWAVE
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 4c1c584..237ebfc 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -96,6 +96,7 @@ obj-$(CONFIG_PC8736x_GPIO)	+= pc8736x_gpio.o
 obj-$(CONFIG_NSC_GPIO)		+= nsc_gpio.o
 obj-$(CONFIG_CS5535_GPIO)	+= cs5535_gpio.o
 obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
+obj-$(CONFIG_GPIO_EPIAPD)	+= epiapd_gpio.o
 obj-$(CONFIG_GPIO_TB0219)	+= tb0219.o
 obj-$(CONFIG_TELCLOCK)		+= tlclk.o
 
diff --git a/drivers/char/epiapd_gpio.c b/drivers/char/epiapd_gpio.c
new file mode 100644
index 0000000..eedb4ae
--- /dev/null
+++ b/drivers/char/epiapd_gpio.c
@@ -0,0 +1,182 @@
+/* linux/drivers/char/epiapd_gpio.c
+
+   EPIA-PD GPIO driver.  Allows a user space process to play with the GPIO pins.
+
+   based on the Nat Semi GPIO driver
+   Copyright (c) 2001,2002 Christer Weinigel <wingel@nano-system.com> 
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
+MODULE_DESCRIPTION("EPIA PD VIA VT8251 GPIO Pin Driver");
+MODULE_LICENSE("GPL");
+
+static int major = 0;		/* default to dynamic major */
+module_param(major, int, 0);
+MODULE_PARM_DESC(major, "Major device number");
+
+#define MAX_PINS 8
+
+static unsigned long pmio;
+
+static void epiapd_gpio_set(int m, int v)
+{
+	u8 r = inb(pmio + 0x4C);
+	r &= ~ (1 << m);
+	r |= (v << m);
+	outb(r, pmio + 0x4C);
+}
+
+ssize_t epiapd_gpio_write(struct file *file, const char __user *data,
+		       size_t len, loff_t *ppos)
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
+	if (err) {
+		if(i == 0)
+			return err;
+		else
+			return i;
+	}
+	return len;
+}
+
+ssize_t epiapd_gpio_read(struct file *file, char __user * buf,
+		      size_t len, loff_t * ppos)
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
+	.owner   = THIS_MODULE,
+	.write   = epiapd_gpio_write,
+	.read    = epiapd_gpio_read,
+	.open    = epiapd_gpio_open,
+	.release = epiapd_gpio_release,
+};
+
+static struct cdev epiapd_gpio_cdev;  /* use 1 cdev for all pins */
+
+static int __init epiapd_gpio_configure(void)
+{
+	struct pci_dev *pdev = pci_get_device(PCI_VENDOR_ID_VIA, 
+					PCI_DEVICE_ID_VIA_8251, NULL);
+	u32 v;
+	u8 r;
+	if (pdev == NULL)
+		return -ENODEV;
+	pci_read_config_dword(pdev, 0x8B, &v);
+	v &= 0xFFFE;
+	if (v == 0)
+		return -ENODEV;
+	pmio = v;
+	
+	/* Program the GPIO direction bits */
+	pci_read_config_byte(pdev, 0xE4, &r);
+	r &= 0x08;
+	pci_write_config_byte(pdev, 0xE4, r);
+	pci_read_config_byte(pdev, 0x95, &r);
+	r |= 0x02;
+	pci_write_config_byte(pdev, 0x95, r);
+	pci_read_config_byte(pdev, 0xE4, &r);
+	r |= 0x06;
+	pci_write_config_byte(pdev, 0xE4, r);
+	
+	pci_dev_put(pdev);
+	return 0;
+}
+
+static int __init epiapd_gpio_init(void)
+{
+	int rc;
+	dev_t devid;
+
+	if (epiapd_gpio_configure() < 0) {
+		printk(KERN_ERR DRVNAME ": no VT8251 gpio present\n");
+		return -ENODEV;
+	}
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
+	cdev_init(&epiapd_gpio_cdev, &epiapd_gpio_fileops);
+	cdev_add(&epiapd_gpio_cdev, devid, MAX_PINS);
+ 	return 0; /* succeed */
+}
+
+static void __exit epiapd_gpio_cleanup(void)
+{
+	cdev_del(&epiapd_gpio_cdev);
+	/* cdev_put(&epiapd_gpio_cdev); */
+	unregister_chrdev_region(MKDEV(major, 0), MAX_PINS);
+}
+
+module_init(epiapd_gpio_init);
+module_exit(epiapd_gpio_cleanup);
