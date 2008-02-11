Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbYBKDL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbYBKDL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 22:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYBKDLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 22:11:18 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:13129 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbYBKDLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 22:11:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=LbcVv7v4OZcQTFUlE0dAZEGzLGmx5FNDnPRKev/aXIkRA4X4W13xMnzGFMGFvuFfvTPWkl+3SKCnF3IN9SU9BCKGJY+JhZEU5PRQDCzvkq1wkMX0OQMgCOjptya8qWft+QeOkH9KueoqZDYMkVI+h5F8fxoaQYCzffDb63rBmqQ=
Message-ID: <76366b180802101911q2df5dc7i5d77840815252c88@mail.gmail.com>
Date: Sun, 10 Feb 2008 22:11:15 -0500
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [WATCHDOG] it8712f_wdt support for 16-bit timeout values, WDIOC_GETSTATUS
Cc: wim@iguana.be
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 576f5703aea9a3d3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for 16-bit watchdog timeout values which are
available in chip revisions >= 0x08. Values <= 65535 are seconds precision,
otherwise minutes precision is used up to a maximum value of 3932100. Added
implementation for WDIOC_GETSTATUS which checks the WDT status bit in the
WDT control register.

Signed-off-by: Andrew Paprocki <andrew@ishiboo.com>
---
  drivers/watchdog/it8712f_wdt.c |   82
++++++++++++++++++++++++++++++++--------
  1 files changed, 66 insertions(+), 16 deletions(-)

diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index 1b6d7d1..803c699 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -7,7 +7,8 @@
   *
   *	drivers/char/watchdog/scx200_wdt.c
   *	drivers/hwmon/it87.c
- *	IT8712F EC-LPC I/O Preliminary Specification 0.9.2.pdf
+ *	IT8712F EC-LPC I/O Preliminary Specification 0.8.2
+ *	IT8712F EC-LPC I/O Preliminary Specification 0.9.3
   *
   *	This program is free software; you can redistribute it and/or
   *	modify it under the terms of the GNU General Public License as
@@ -40,6 +41,7 @@ MODULE_DESCRIPTION("IT8712F Watchdog Driver");
  MODULE_LICENSE("GPL");
  MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);

+static int max_units = 255;
  static int margin = 60;		/* in seconds */
  module_param(margin, int, 0);
  MODULE_PARM_DESC(margin, "Watchdog margin in seconds");
@@ -51,6 +53,7 @@ MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown
on close");
  static struct semaphore it8712f_wdt_sem;
  static unsigned expect_close;
  static spinlock_t io_lock;
+static unsigned char revision;

  /* Dog Food address - We use the game port address */
  static unsigned short address;
@@ -108,6 +111,15 @@ superio_inw(int reg)
  	return val;
  }

+static void
+superio_outw(int val, int reg)
+{
+        outb(reg++, REG);
+        outb((val >> 8) & 0xff, VAL);
+        outb(reg, REG);
+        outb(val & 0xff, VAL);
+}
+
  static inline void
  superio_select(int ldn)
  {
@@ -143,15 +155,33 @@ static void
  it8712f_wdt_update_margin(void)
  {
  	int config = WDT_OUT_KRST | WDT_OUT_PWROK;
+        int units = margin;
+
+        /* Switch to minutes precision if the configured margin
+         * value does not fit within the register width.
+         */
+        if (units <= max_units) {
+                config |= WDT_UNIT_SEC; /* else UNIT is MINUTES */
+                printk(KERN_INFO NAME ": timer margin %d seconds\n",
units);
+        } else {
+                units /= 60;
+                printk(KERN_INFO NAME ": timer margin %d minutes\n",
units);
+        }
+        superio_outb(config, WDT_CONFIG);
+
+        if (revision >= 0x08)
+                superio_outw(units, WDT_TIMEOUT);
+        else
+                superio_outb(units, WDT_TIMEOUT);
+}

-	printk(KERN_INFO NAME ": timer margin %d seconds\n", margin);
-
-	/* The timeout register only has 8bits wide */
-	if (margin < 256)
-		config |= WDT_UNIT_SEC;	/* else UNIT are MINUTES */
-	superio_outb(config, WDT_CONFIG);
-
-	superio_outb((margin > 255) ? (margin / 60) : margin, WDT_TIMEOUT);
+static int
+it8712f_wdt_get_status(void)
+{
+        if (superio_inb(WDT_CONTROL) & 0x01)
+                return WDIOF_CARDRESET;
+        else
+                return 0;
  }

  static void
@@ -234,7 +264,7 @@ it8712f_wdt_ioctl(struct inode *inode, struct file
*file,
  		.firmware_version = 1,
  		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
  	};
-	int new_margin;
+	int value;

  	switch (cmd) {
  	default:
@@ -244,17 +274,27 @@ it8712f_wdt_ioctl(struct inode *inode, struct file
*file,
  			return -EFAULT;
  		return 0;
  	case WDIOC_GETSTATUS:
+                superio_enter();
+                superio_select(LDN_GPIO);
+
+                value = it8712f_wdt_get_status();
+
+                superio_exit();
+
+		return put_user(value, p);
  	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
+                return put_user(0, p);
  	case WDIOC_KEEPALIVE:
  		it8712f_wdt_ping();
  		return 0;
  	case WDIOC_SETTIMEOUT:
-		if (get_user(new_margin, p))
+		if (get_user(value, p))
  			return -EFAULT;
-		if (new_margin < 1)
+		if (value < 1)
  			return -EINVAL;
-		margin = new_margin;
+                if (value > (max_units * 60))
+                        return -EINVAL;
+		margin = value;
  		superio_enter();
  		superio_select(LDN_GPIO);

@@ -262,6 +302,7 @@ it8712f_wdt_ioctl(struct inode *inode, struct file
*file,

  		superio_exit();
  		it8712f_wdt_ping();
+                /* Fall through */
  	case WDIOC_GETTIMEOUT:
  		if (put_user(margin, p))
  			return -EFAULT;
@@ -336,9 +377,18 @@ it8712f_wdt_find(unsigned short *address)
  	}

  	err = 0;
-	printk(KERN_DEBUG NAME ": Found IT%04xF chip revision %d - "
+        revision = superio_inb(DEVREV) & 0x0f;
+
+        /* Later revisions have 16-bit values per datasheet 0.9.1 */
+        if (revision >= 0x08)
+                max_units = 65535;
+
+        if (margin > (max_units * 60))
+                margin = (max_units * 60);
+
+	printk(KERN_INFO NAME ": Found IT%04xF chip revision %d - "
  		"using DogFood address 0x%x\n",
-		chip_type, superio_inb(DEVREV) & 0x0f, *address);
+		chip_type, revision, *address);

  exit:
  	superio_exit();
