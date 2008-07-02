Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608AbYGBIPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbYGBIPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYGBIPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:15:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287AbYGBIPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:15:34 -0400
Date: Wed, 2 Jul 2008 01:14:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [-mmotm] some different buliding failures
Message-Id: <20080702011452.37bcec2f.akpm@linux-foundation.org>
In-Reply-To: <486B1EE0.9060303@cn.fujitsu.com>
References: <486B1EE0.9060303@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2008 14:23:28 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> drivers/mfd/sm501.c:39: error: field 'gpio' has incomplete type

OK, this monstrosity seems to make it compile:


diff -puN drivers/mfd/sm501.c~sm501-guess-n-giggle-build-fix drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-guess-n-giggle-build-fix
+++ a/drivers/mfd/sm501.c
@@ -19,7 +19,9 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/pci.h>
+#ifdef CONFIG_MFD_SM501_GPIO
 #include <linux/gpio.h>
+#endif
 #include <linux/i2c-gpio.h>
 
 #include <linux/sm501.h>
@@ -33,6 +35,7 @@ struct sm501_device {
 	struct platform_device		pdev;
 };
 
+#ifdef CONFIG_MFD_SM501_GPIO
 struct sm501_gpio;
 
 struct sm501_gpio_chip {
@@ -50,13 +53,15 @@ struct sm501_gpio {
 	void __iomem		*regs;
 	struct resource		*regs_res;
 };
+#endif
 
 struct sm501_devdata {
 	spinlock_t			 reg_lock;
 	struct mutex			 clock_lock;
 	struct list_head		 devices;
+#ifdef CONFIG_MFD_SM501_GPIO
 	struct sm501_gpio		 gpio;
-
+#endif
 	struct device			*dev;
 	struct resource			*io_res;
 	struct resource			*mem_res;
@@ -1116,6 +1121,7 @@ static inline int sm501_gpio_pin2nr(stru
 }
 #endif
 
+#ifdef CONFIG_MFD_SM501_GPIO
 static int sm501_register_gpio_i2c_instance(struct sm501_devdata *sm,
 					    struct sm501_platdata_gpio_i2c *iic)
 {
@@ -1168,6 +1174,7 @@ static int sm501_register_gpio_i2c(struc
 
 	return 0;
 }
+#endif
 
 /* sm501_dbg_regs
  *
@@ -1329,12 +1336,14 @@ static int sm501_init_dev(struct sm501_d
 			sm501_register_gpio(sm);
 	}
 
+#ifdef CONFIG_MFD_SM501_GPIO
 	if (pdata->gpio_i2c != NULL && pdata->gpio_i2c_nr > 0) {
 		if (!sm->gpio.registered)
 			dev_err(sm->dev, "no gpio registered for i2c gpio.\n");
 		else
 			sm501_register_gpio_i2c(sm, pdata);
 	}
+#endif
 
 	ret = sm501_check_clocks(sm);
 	if (ret) {
@@ -1643,8 +1652,10 @@ static void sm501_dev_remove(struct sm50
 
 	device_remove_file(sm->dev, &dev_attr_dbg_regs);
 
+#ifdef CONFIG_MFD_SM501_GPIO
 	if (sm->gpio.registered)
 		sm501_gpio_remove(sm);
+#endif
 }
 
 static void sm501_pci_remove(struct pci_dev *dev)
_

