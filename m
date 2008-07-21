Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbYGUK12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbYGUK12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 06:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757567AbYGUK1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 06:27:19 -0400
Received: from bu3sch.de ([62.75.166.246]:40140 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145AbYGUK1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 06:27:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] gpiommc: Fix for configfs API change
Date: Mon, 21 Jul 2008 12:25:31 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       openwrt-devel@lists.openwrt.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807211225.31834.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The configfs API changed in linux-next. This patch fixes gpiommc
to use the new API. This fixes a compiler warning.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Warning remained unoticed when porting the stuff from 2.6.25 to linux-next.

Index: linux-next/drivers/mmc/host/gpiommc.c
===================================================================
--- linux-next.orig/drivers/mmc/host/gpiommc.c	2008-07-21 12:10:55.000000000 +0200
+++ linux-next/drivers/mmc/host/gpiommc.c	2008-07-21 12:17:36.000000000 +0200
@@ -509,19 +509,20 @@ static struct config_item_type gpiommc_d
 	.ct_owner	= THIS_MODULE,
 };
 
-static struct config_item *gpiommc_make_item(struct config_group *group,
-					     const char *name)
+static int gpiommc_make_item(struct config_group *group,
+			     const char *name,
+			     struct config_item **new_item)
 {
 	struct gpiommc_configfs_device *dev;
 
 	if (strlen(name) > GPIOMMC_MAX_NAMELEN) {
 		printk(KERN_ERR PFX "configfs: device name too long\n");
-		return NULL;
+		return -E2BIG;
 	}
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
-		return NULL;
+		return -ENOMEM;
 
 	mutex_init(&dev->mutex);
 	config_item_init_type_name(&dev->item, name,
@@ -537,7 +538,9 @@ static struct config_item *gpiommc_make_
 	dev->pdata.no_spi_delay = 0;
 	dev->pdata.max_bus_speed = 5000000; /* 5 MHz */
 
-	return &(dev->item);
+	*new_item = &(dev->item);
+
+	return 0;
 }
 
 static void gpiommc_drop_item(struct config_group *group,

-- 
Greetings Michael.
