Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbYGUKU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbYGUKU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 06:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbYGUKUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 06:20:50 -0400
Received: from bu3sch.de ([62.75.166.246]:38065 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917AbYGUKUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 06:20:49 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] gpiommc: Add locking
Date: Mon, 21 Jul 2008 12:19:46 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       openwrt-devel@lists.openwrt.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807211219.47181.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpiommc configfs context structure needs locking, as configfs
does not lock access between files (or if it does, we shouldn't
depend on this to magically happen).

Signed-off-by: Michael Buesch <mb@bu3sch.de>



Index: linux-next/drivers/mmc/host/gpiommc.c
===================================================================
--- linux-next.orig/drivers/mmc/host/gpiommc.c	2008-07-20 21:43:42.000000000 +0200
+++ linux-next/drivers/mmc/host/gpiommc.c	2008-07-21 12:10:55.000000000 +0200
@@ -143,6 +143,8 @@ struct gpiommc_configfs_device {
 	struct platform_device *pdev;
 	/* The configuration */
 	struct gpiommc_platform_data pdata;
+	/* Mutex to protect this structure */
+	struct mutex mutex;
 };
 
 #define GPIO_INVALID	-1
@@ -233,6 +235,8 @@ static ssize_t gpiommc_config_attr_show(
 	unsigned int gpio;
 	int err = 0;
 
+	mutex_lock(&dev->mutex);
+
 	if (attr == &gpiommc_attr_DI) {
 		gpio = dev->pdata.pins.gpio_di;
 		if (gpio == GPIO_INVALID)
@@ -293,6 +297,8 @@ static ssize_t gpiommc_config_attr_show(
 	WARN_ON(1);
 	err = -ENOSYS;
 out:
+	mutex_unlock(&dev->mutex);
+
 	return err ? err : count;
 }
 
@@ -352,6 +358,8 @@ static ssize_t gpiommc_config_attr_store
 	int err = -EINVAL;
 	unsigned long data;
 
+	mutex_lock(&dev->mutex);
+
 	if (attr == &gpiommc_attr_register) {
 		err = strict_strtoul(page, 10, &data);
 		if (err)
@@ -477,6 +485,8 @@ static ssize_t gpiommc_config_attr_store
 	WARN_ON(1);
 	err = -ENOSYS;
 out:
+	mutex_unlock(&dev->mutex);
+
 	return err ? err : count;
 }
 
@@ -513,6 +523,7 @@ static struct config_item *gpiommc_make_
 	if (!dev)
 		return NULL;
 
+	mutex_init(&dev->mutex);
 	config_item_init_type_name(&dev->item, name,
 				   &gpiommc_dev_ci_type);
 

-- 
Greetings Michael.
