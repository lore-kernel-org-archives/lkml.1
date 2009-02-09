Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbZBIREo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbZBIREo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZBIREf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:04:35 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:11752 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbZBIREd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:04:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FCm2b35vDftpc++yBz74P0yOqoLLNYYZmRr7U2ifuZlsG8EteG9L2LlnZwhudECmlu
         CcVTlO86ZzRtlKKNXh/Lu3h4Xo4k6CwcSeZJDzC4EJtJDHN99A+jvJ6PTMOaJ7Zha++4
         Y88uT5XH/zoGZpJbOeWvbE9G6Zywny8W1RIRc=
MIME-Version: 1.0
Date: Mon, 9 Feb 2009 18:04:29 +0100
Message-ID: <8447d6730902090904y138af9c6r3d64278bc7a30811@mail.gmail.com>
Subject: [PATCH 1/2] User access to internal clocks
From: Davide Rizzo <elpa.rizzo@gmail.com>
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Cc: ben-linux@fluff.org, "Hans J. Koch" <hjk@linutronix.de>,
       Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To: Greg KH <gregkh@suse.de>
Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
ben-linux@fluff.org, linux-api@vger.kernel.org

This driver is for user level programs to interact with system clocks.
It allows to read and modify rates and parents, using virtual files.
It requires the implementation of 2 additional functions in the clk interface:
 clk_for_each() and clk_name().
Actually I implemented that functions only for Samsung S3C24xx platform.

Signed-off-by: Davide Rizzo <elpa.rizzo@gmail.com>
---
diff -urpN linux-2.6.29-rc2/drivers/misc/Kconfig
linux-2.6.29-rc2.elpa/drivers/misc/Kconfig
--- linux-2.6.29-rc2/drivers/misc/Kconfig       2009-01-17
11:32:40.000000000 +0100
+++ linux-2.6.29-rc2.elpa/drivers/misc/Kconfig  2009-01-28
19:21:43.000000000 +0100
@@ -232,4 +232,19 @@ config DELL_LAPTOP

 source "drivers/misc/c2port/Kconfig"

+config UM_CLOCK
+       bool "User mode clock driver"
+       depends on SYSFS
+       default n
+       ---help---
+       Allows user mode programs to configure and control internal clocks'
+        rates and parents through virtual files in sysfs.
+       This driver requires implementation of some additional functions
+        in architecture specific low-level drivers: clk_for_each() and
+        clk_get_name(). Moreover, it requires clk_get() to recognize the
+        "name.id" format
+       Currently they're implemented only on Samsung S3C24xx platforms.
+
+       If unsure, say N.
+
 endif # MISC_DEVICES
diff -urpN linux-2.6.29-rc2/drivers/misc/Makefile
linux-2.6.29-rc2.elpa/drivers/misc/Makefile
--- linux-2.6.29-rc2/drivers/misc/Makefile      2009-01-17
11:32:40.000000000 +0100
+++ linux-2.6.29-rc2.elpa/drivers/misc/Makefile 2009-01-28
19:21:43.000000000 +0100
@@ -20,3 +20,4 @@ obj-$(CONFIG_SGI_XP)          += sgi-xp/
 obj-$(CONFIG_SGI_GRU)          += sgi-gru/
 obj-$(CONFIG_HP_ILO)           += hpilo.o
 obj-$(CONFIG_C2PORT)           += c2port/
+obj-$(CONFIG_UM_CLOCK) += um_clock.o
diff -urpN linux-2.6.29-rc2/drivers/misc/um_clock.c
linux-2.6.29-rc2.elpa/drivers/misc/um_clock.c
--- linux-2.6.29-rc2/drivers/misc/um_clock.c    1970-01-01
01:00:00.000000000 +0100
+++ linux-2.6.29-rc2.elpa/drivers/misc/um_clock.c       2009-01-28
19:21:43.000000000 +0100
@@ -0,0 +1,174 @@
+/*
+ driver/misc/clock.c
+
+ Written Feb 2008 by Davide Rizzo <elpa.rizzo@gmail.com>
+
+ This driver allows to read and modify internal clocks' rates using
+  virtual files. User can also read and modify parents.
+
+ This driver requires implementation of clk_name() and clk_enum() functions
+  in architecture specific clock.c
+
+ This program is free software; you can redistribute it and/or modify
+ it under the terms of the GNU General Public License as published by
+ the Free Software Foundation; either version 2 of the License, or
+ (at your option) any later version.
+
+ This program is distributed in the hope that it will be useful,
+ but WITHOUT ANY WARRANTY; without even the implied warranty of
+ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ GNU General Public License for more details.
+
+ You should have received a copy of the GNU General Public License
+ along with this program; if not, write to the Free Software
+ Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+#include <linux/device.h>
+#include <linux/clk.h>
+#include <linux/kdev_t.h>
+#include <linux/err.h>
+
+static DEFINE_MUTEX(mutex);
+
+static ssize_t rate_show(struct device *dev, struct device_attribute *attr,
+       char *buffer)
+{
+       unsigned long rate;
+       struct clk *clk;
+
+       clk = dev_get_drvdata(dev);
+       rate = 0;
+
+       mutex_lock(&mutex);
+
+       rate = clk_get_rate(clk);
+
+       mutex_unlock(&mutex);
+
+       return sprintf(buffer, "%ld\n", rate);
+}
+
+static ssize_t rate_store(struct device *dev, struct device_attribute *attr,
+       const char *buffer, size_t count)
+{
+       unsigned long rate;
+       struct clk *clk;
+       int err;
+
+       clk = dev_get_drvdata(dev);
+       err = strict_strtoul(buffer, 10, &rate);
+       if (err)
+               return err;
+
+       mutex_lock(&mutex);
+
+       if (rate != 0) {
+               clk_set_rate(clk, clk_round_rate(clk, rate));
+               clk_enable(clk);
+       } else
+               clk_disable(clk);
+
+       mutex_unlock(&mutex);
+
+       return count;
+}
+
+static ssize_t parent_show(struct device *dev,
+       struct device_attribute *attr, char *buffer)
+{
+       struct clk *parent, *clk;
+
+       clk = dev_get_drvdata(dev);
+
+       mutex_lock(&mutex);
+
+       parent = clk_get_parent(clk);
+       if (parent && !IS_ERR(parent)) {
+               const char *name = clk_get_name(parent);
+               if (IS_ERR(name)) {
+                       mutex_unlock(&mutex);
+                       return PTR_ERR(name);
+               }
+               strlcpy(buffer, name, PAGE_SIZE);
+       } else
+               buffer[0] = '\0';
+       strlcat(buffer, "\n", PAGE_SIZE);
+
+       mutex_unlock(&mutex);
+
+       return strlen(buffer);
+}
+
+static ssize_t parent_store(struct device *dev,
+       struct device_attribute *attr, const char *buffer, size_t count)
+{
+       struct clk *parent;
+
+       char *s = kstrdup(buffer, GFP_KERNEL);
+
+       if (!s)
+               return -ENOMEM;
+       if (s[strlen(s) - 1] == '\n')
+               s[strlen(s) - 1] = '\0';
+       parent = clk_get(dev, s);
+       kfree(s);
+       if (IS_ERR(parent))
+               return PTR_ERR(parent);
+
+       mutex_lock(&mutex);
+
+       clk_set_parent(dev_get_drvdata(dev), parent);
+
+       mutex_unlock(&mutex);
+
+       clk_put(parent);
+       return count;
+}
+
+static DEVICE_ATTR(rate, S_IRUGO | S_IWUSR, rate_show, rate_store);
+static DEVICE_ATTR(parent, S_IRUGO | S_IWUSR, parent_show, parent_store);
+
+static const struct attribute *clock_attrs[] = {
+       &dev_attr_rate.attr,
+       &dev_attr_parent.attr,
+       NULL,
+};
+
+static const struct attribute_group clock_attr_group = {
+       .attrs = (struct attribute **) clock_attrs,
+};
+
+static struct class gpclock_class = {
+       .name =         "clock",
+       .owner =        THIS_MODULE,
+};
+
+static int create_clock_attr(struct clk *clk, void *data)
+{
+       struct device *dev;
+       const char *name;
+
+       name = clk_get_name(clk);
+       if (name == NULL || IS_ERR(name)) {
+               pr_debug("Invalid clock's name\n");
+               return PTR_ERR(name);
+       }
+       dev = device_create(&gpclock_class, (struct device *)data, MKDEV(0, 0),
+               clk, name);
+       if (!dev)
+               return -ENODEV;
+       return sysfs_create_group(&dev->kobj, &clock_attr_group);
+}
+
+static int __init gpclock_init(void)
+{
+       int ret;
+
+       ret = class_register(&gpclock_class);
+       if (ret >= 0)
+               ret = clk_for_each(create_clock_attr, NULL);
+       return ret;
+}
+subsys_initcall(gpclock_init);
+
diff -urpN linux-2.6.29-rc2/Documentation/ABI/testing/sysfs-class-clock
linux-2.6.29-rc2.elpa/Documentation/ABI/testing/sysfs-class-clock
--- linux-2.6.29-rc2/Documentation/ABI/testing/sysfs-class-clock
 1970-01-01
01:00:00.000000000 +0100
+++ linux-2.6.29-rc2.elpa/Documentation/ABI/testing/sysfs-class-clock
 2009-01-28
19:21:43.000000000 +0100
@@ -0,0 +1,20 @@
+What:          /sys/class/clock
+Date:          January 2009
+Contact:       Davide Rizzo <elpa.rizzo@gmail.com>
+Description:
+               The /sys/class/clock directory will consist of a group of
+               subdirectories each one describing an internal clock
in the kernel.
+               The name of the subdirectory is the clock's name.
+               If a clock is device specific, its name is in the form
"name.id".
+               In each directory there are 2 virtual files: rate and parent.
+               Both these files are r/w, but there can be some
architecture-dependent
+               limitations on write access on one or both of them.
+               For this interface to work, it needs some low-level
implementations (look
+               at include/linux/clk.h):
+               - clk_for_each()
+               - clk_name()
+               - clk_get() should recognize also the "name.id" format
+               Actually I implemented these only for Samsung S3C SoC in
+               arch/arm/plat-s3c/clock.c
+
+Users:
