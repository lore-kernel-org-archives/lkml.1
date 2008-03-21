Return-Path: <linux-kernel-owner+w=401wt.eu-S932309AbYCUXPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbYCUXPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763643AbYCUWzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:55:55 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:57070 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763644AbYCUWzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:55:51 -0400
Date: Fri, 21 Mar 2008 23:54:50 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc: use sysfs groups to handle conditional attributes
Message-ID: <20080321235450.733c7f81@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suppressing uevents turned out to be a bad idea as it screws up the
order of events, making user space very confused. Change the system to
use sysfs groups instead.

Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
--

This is a regression that, for some odd reason, has gone unnoticed for
some time. It confuses hal so that the block devices (which have the
mmc device as a parent) are not registered. End result being that
desktop magic when cards are inserted won't work.

I don't know how clever git is when it comes to file changes in a diff,
but drivers/mmc/core/sysfs.{c,h} are supposed to be removed.

diff --git a/drivers/mmc/core/Makefile b/drivers/mmc/core/Makefile
index 4985807..19a1a25 100644
--- a/drivers/mmc/core/Makefile
+++ b/drivers/mmc/core/Makefile
@@ -7,7 +7,7 @@ ifeq ($(CONFIG_MMC_DEBUG),y)
 endif
 
 obj-$(CONFIG_MMC)		+= mmc_core.o
-mmc_core-y			:= core.o sysfs.o bus.o host.o \
+mmc_core-y			:= core.o bus.o host.o \
 				   mmc.o mmc_ops.o sd.o sd_ops.o \
 				   sdio.o sdio_ops.o sdio_bus.o \
 				   sdio_cis.o sdio_io.o sdio_irq.o
diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index b0c22ca..fd95b18 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -17,7 +17,6 @@
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
 
-#include "sysfs.h"
 #include "core.h"
 #include "sdio_cis.h"
 #include "bus.h"
@@ -43,7 +42,7 @@ static ssize_t mmc_type_show(struct device *dev,
 }
 
 static struct device_attribute mmc_dev_attrs[] = {
-	MMC_ATTR_RO(type),
+	__ATTR(type, S_IRUGO, mmc_type_show, NULL),
 	__ATTR_NULL,
 };
 
@@ -189,7 +188,7 @@ static void mmc_release_card(struct device *dev)
 /*
  * Allocate and initialise a new MMC card structure.
  */
-struct mmc_card *mmc_alloc_card(struct mmc_host *host)
+struct mmc_card *mmc_alloc_card(struct mmc_host *host, struct device_type *type)
 {
 	struct mmc_card *card;
 
@@ -204,6 +203,7 @@ struct mmc_card *mmc_alloc_card(struct mmc_host *host)
 	card->dev.parent = mmc_classdev(host);
 	card->dev.bus = &mmc_bus_type;
 	card->dev.release = mmc_release_card;
+	card->dev.type = type;
 
 	return card;
 }
@@ -248,24 +248,10 @@ int mmc_add_card(struct mmc_card *card)
 			type, card->rca);
 	}
 
-	card->dev.uevent_suppress = 1;
-
 	ret = device_add(&card->dev);
 	if (ret)
 		return ret;
 
-	if (card->host->bus_ops->sysfs_add) {
-		ret = card->host->bus_ops->sysfs_add(card->host, card);
-		if (ret) {
-			device_del(&card->dev);
-			return ret;
-		 }
-	}
-
-	card->dev.uevent_suppress = 0;
-
-	kobject_uevent(&card->dev.kobj, KOBJ_ADD);
-
 	mmc_card_set_present(card);
 
 	return 0;
@@ -285,9 +271,6 @@ void mmc_remove_card(struct mmc_card *card)
 			printk(KERN_INFO "%s: card %04x removed\n",
 				mmc_hostname(card->host), card->rca);
 		}
-
-		if (card->host->bus_ops->sysfs_remove)
-			card->host->bus_ops->sysfs_remove(card->host, card);
 		device_del(&card->dev);
 	}
 
diff --git a/drivers/mmc/core/bus.h b/drivers/mmc/core/bus.h
index 4f35431..1817876 100644
--- a/drivers/mmc/core/bus.h
+++ b/drivers/mmc/core/bus.h
@@ -11,7 +11,16 @@
 #ifndef _MMC_CORE_BUS_H
 #define _MMC_CORE_BUS_H
 
-struct mmc_card *mmc_alloc_card(struct mmc_host *host);
+#define MMC_DEV_ATTR(name, fmt, args...)					\
+static ssize_t mmc_##name##_show (struct device *dev, struct device_attribute *attr, char *buf)	\
+{										\
+	struct mmc_card *card = container_of(dev, struct mmc_card, dev);	\
+	return sprintf(buf, fmt, args);						\
+}										\
+static DEVICE_ATTR(name, S_IRUGO, mmc_##name##_show, NULL)
+
+struct mmc_card *mmc_alloc_card(struct mmc_host *host,
+	struct device_type *type);
 int mmc_add_card(struct mmc_card *card);
 void mmc_remove_card(struct mmc_card *card);
 
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index 39daf2f..cfa8e15 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -18,8 +18,6 @@
 struct mmc_bus_ops {
 	void (*remove)(struct mmc_host *);
 	void (*detect)(struct mmc_host *);
-	int (*sysfs_add)(struct mmc_host *, struct mmc_card *card);
-	void (*sysfs_remove)(struct mmc_host *, struct mmc_card *card);
 	void (*suspend)(struct mmc_host *);
 	void (*resume)(struct mmc_host *);
 };
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 68c0e3b..3da29ee 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -17,7 +17,6 @@
 #include <linux/mmc/mmc.h>
 
 #include "core.h"
-#include "sysfs.h"
 #include "bus.h"
 #include "mmc_ops.h"
 
@@ -248,6 +247,44 @@ out:
 	return err;
 }
 
+MMC_DEV_ATTR(cid, "%08x%08x%08x%08x\n", card->raw_cid[0], card->raw_cid[1],
+	card->raw_cid[2], card->raw_cid[3]);
+MMC_DEV_ATTR(csd, "%08x%08x%08x%08x\n", card->raw_csd[0], card->raw_csd[1],
+	card->raw_csd[2], card->raw_csd[3]);
+MMC_DEV_ATTR(date, "%02d/%04d\n", card->cid.month, card->cid.year);
+MMC_DEV_ATTR(fwrev, "0x%x\n", card->cid.fwrev);
+MMC_DEV_ATTR(hwrev, "0x%x\n", card->cid.hwrev);
+MMC_DEV_ATTR(manfid, "0x%06x\n", card->cid.manfid);
+MMC_DEV_ATTR(name, "%s\n", card->cid.prod_name);
+MMC_DEV_ATTR(oemid, "0x%04x\n", card->cid.oemid);
+MMC_DEV_ATTR(serial, "0x%08x\n", card->cid.serial);
+
+static struct attribute *mmc_std_attrs[] = {
+	&dev_attr_cid.attr,
+	&dev_attr_csd.attr,
+	&dev_attr_date.attr,
+	&dev_attr_fwrev.attr,
+	&dev_attr_hwrev.attr,
+	&dev_attr_manfid.attr,
+	&dev_attr_name.attr,
+	&dev_attr_oemid.attr,
+	&dev_attr_serial.attr,
+	NULL,
+};
+
+static struct attribute_group mmc_std_attr_group = {
+	.attrs = mmc_std_attrs,
+};
+
+static struct attribute_group *mmc_attr_groups[] = {
+	&mmc_std_attr_group,
+	NULL,
+};
+
+static struct device_type mmc_type = {
+	.groups = mmc_attr_groups,
+};
+
 /*
  * Handle the detection and initialisation of a card.
  *
@@ -308,7 +345,7 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 		/*
 		 * Allocate card structure.
 		 */
-		card = mmc_alloc_card(host);
+		card = mmc_alloc_card(host, &mmc_type);
 		if (IS_ERR(card)) {
 			err = PTR_ERR(card);
 			goto err;
@@ -459,53 +496,6 @@ static void mmc_detect(struct mmc_host *host)
 	}
 }
 
-MMC_ATTR_FN(cid, "%08x%08x%08x%08x\n", card->raw_cid[0], card->raw_cid[1],
-	card->raw_cid[2], card->raw_cid[3]);
-MMC_ATTR_FN(csd, "%08x%08x%08x%08x\n", card->raw_csd[0], card->raw_csd[1],
-	card->raw_csd[2], card->raw_csd[3]);
-MMC_ATTR_FN(date, "%02d/%04d\n", card->cid.month, card->cid.year);
-MMC_ATTR_FN(fwrev, "0x%x\n", card->cid.fwrev);
-MMC_ATTR_FN(hwrev, "0x%x\n", card->cid.hwrev);
-MMC_ATTR_FN(manfid, "0x%06x\n", card->cid.manfid);
-MMC_ATTR_FN(name, "%s\n", card->cid.prod_name);
-MMC_ATTR_FN(oemid, "0x%04x\n", card->cid.oemid);
-MMC_ATTR_FN(serial, "0x%08x\n", card->cid.serial);
-
-static struct device_attribute mmc_dev_attrs[] = {
-	MMC_ATTR_RO(cid),
-	MMC_ATTR_RO(csd),
-	MMC_ATTR_RO(date),
-	MMC_ATTR_RO(fwrev),
-	MMC_ATTR_RO(hwrev),
-	MMC_ATTR_RO(manfid),
-	MMC_ATTR_RO(name),
-	MMC_ATTR_RO(oemid),
-	MMC_ATTR_RO(serial),
-	__ATTR_NULL,
-};
-
-/*
- * Adds sysfs entries as relevant.
- */
-static int mmc_sysfs_add(struct mmc_host *host, struct mmc_card *card)
-{
-	int ret;
-
-	ret = mmc_add_attrs(card, mmc_dev_attrs);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-/*
- * Removes the sysfs entries added by mmc_sysfs_add().
- */
-static void mmc_sysfs_remove(struct mmc_host *host, struct mmc_card *card)
-{
-	mmc_remove_attrs(card, mmc_dev_attrs);
-}
-
 #ifdef CONFIG_MMC_UNSAFE_RESUME
 
 /*
@@ -560,8 +550,6 @@ static void mmc_resume(struct mmc_host *host)
 static const struct mmc_bus_ops mmc_ops = {
 	.remove = mmc_remove,
 	.detect = mmc_detect,
-	.sysfs_add = mmc_sysfs_add,
-	.sysfs_remove = mmc_sysfs_remove,
 	.suspend = mmc_suspend,
 	.resume = mmc_resume,
 };
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index d1c1e0f..7ef3b15 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -18,7 +18,6 @@
 #include <linux/mmc/sd.h>
 
 #include "core.h"
-#include "sysfs.h"
 #include "bus.h"
 #include "mmc_ops.h"
 #include "sd_ops.h"
@@ -283,6 +282,47 @@ out:
 	return err;
 }
 
+MMC_DEV_ATTR(cid, "%08x%08x%08x%08x\n", card->raw_cid[0], card->raw_cid[1],
+	card->raw_cid[2], card->raw_cid[3]);
+MMC_DEV_ATTR(csd, "%08x%08x%08x%08x\n", card->raw_csd[0], card->raw_csd[1],
+	card->raw_csd[2], card->raw_csd[3]);
+MMC_DEV_ATTR(scr, "%08x%08x\n", card->raw_scr[0], card->raw_scr[1]);
+MMC_DEV_ATTR(date, "%02d/%04d\n", card->cid.month, card->cid.year);
+MMC_DEV_ATTR(fwrev, "0x%x\n", card->cid.fwrev);
+MMC_DEV_ATTR(hwrev, "0x%x\n", card->cid.hwrev);
+MMC_DEV_ATTR(manfid, "0x%06x\n", card->cid.manfid);
+MMC_DEV_ATTR(name, "%s\n", card->cid.prod_name);
+MMC_DEV_ATTR(oemid, "0x%04x\n", card->cid.oemid);
+MMC_DEV_ATTR(serial, "0x%08x\n", card->cid.serial);
+
+
+static struct attribute *sd_std_attrs[] = {
+	&dev_attr_cid.attr,
+	&dev_attr_csd.attr,
+	&dev_attr_scr.attr,
+	&dev_attr_date.attr,
+	&dev_attr_fwrev.attr,
+	&dev_attr_hwrev.attr,
+	&dev_attr_manfid.attr,
+	&dev_attr_name.attr,
+	&dev_attr_oemid.attr,
+	&dev_attr_serial.attr,
+	NULL,
+};
+
+static struct attribute_group sd_std_attr_group = {
+	.attrs = sd_std_attrs,
+};
+
+static struct attribute_group *sd_attr_groups[] = {
+	&sd_std_attr_group,
+	NULL,
+};
+
+static struct device_type sd_type = {
+	.groups = sd_attr_groups,
+};
+
 /*
  * Handle the detection and initialisation of a card.
  *
@@ -352,7 +392,7 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 		/*
 		 * Allocate card structure.
 		 */
-		card = mmc_alloc_card(host);
+		card = mmc_alloc_card(host, &sd_type);
 		if (IS_ERR(card)) {
 			err = PTR_ERR(card);
 			goto err;
@@ -518,55 +558,6 @@ static void mmc_sd_detect(struct mmc_host *host)
 	}
 }
 
-MMC_ATTR_FN(cid, "%08x%08x%08x%08x\n", card->raw_cid[0], card->raw_cid[1],
-	card->raw_cid[2], card->raw_cid[3]);
-MMC_ATTR_FN(csd, "%08x%08x%08x%08x\n", card->raw_csd[0], card->raw_csd[1],
-	card->raw_csd[2], card->raw_csd[3]);
-MMC_ATTR_FN(scr, "%08x%08x\n", card->raw_scr[0], card->raw_scr[1]);
-MMC_ATTR_FN(date, "%02d/%04d\n", card->cid.month, card->cid.year);
-MMC_ATTR_FN(fwrev, "0x%x\n", card->cid.fwrev);
-MMC_ATTR_FN(hwrev, "0x%x\n", card->cid.hwrev);
-MMC_ATTR_FN(manfid, "0x%06x\n", card->cid.manfid);
-MMC_ATTR_FN(name, "%s\n", card->cid.prod_name);
-MMC_ATTR_FN(oemid, "0x%04x\n", card->cid.oemid);
-MMC_ATTR_FN(serial, "0x%08x\n", card->cid.serial);
-
-static struct device_attribute mmc_sd_dev_attrs[] = {
-	MMC_ATTR_RO(cid),
-	MMC_ATTR_RO(csd),
-	MMC_ATTR_RO(scr),
-	MMC_ATTR_RO(date),
-	MMC_ATTR_RO(fwrev),
-	MMC_ATTR_RO(hwrev),
-	MMC_ATTR_RO(manfid),
-	MMC_ATTR_RO(name),
-	MMC_ATTR_RO(oemid),
-	MMC_ATTR_RO(serial),
-	__ATTR_NULL,
-};
-
-/*
- * Adds sysfs entries as relevant.
- */
-static int mmc_sd_sysfs_add(struct mmc_host *host, struct mmc_card *card)
-{
-	int ret;
-
-	ret = mmc_add_attrs(card, mmc_sd_dev_attrs);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-/*
- * Removes the sysfs entries added by mmc_sysfs_add().
- */
-static void mmc_sd_sysfs_remove(struct mmc_host *host, struct mmc_card *card)
-{
-	mmc_remove_attrs(card, mmc_sd_dev_attrs);
-}
-
 #ifdef CONFIG_MMC_UNSAFE_RESUME
 
 /*
@@ -621,8 +612,6 @@ static void mmc_sd_resume(struct mmc_host *host)
 static const struct mmc_bus_ops mmc_sd_ops = {
 	.remove = mmc_sd_remove,
 	.detect = mmc_sd_detect,
-	.sysfs_add = mmc_sd_sysfs_add,
-	.sysfs_remove = mmc_sd_sysfs_remove,
 	.suspend = mmc_sd_suspend,
 	.resume = mmc_sd_resume,
 };
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 87a50f4..4eab79e 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -287,7 +287,7 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
 	/*
 	 * Allocate card structure.
 	 */
-	card = mmc_alloc_card(host);
+	card = mmc_alloc_card(host, NULL);
 	if (IS_ERR(card)) {
 		err = PTR_ERR(card);
 		goto err;
diff --git a/drivers/mmc/core/sysfs.c b/drivers/mmc/core/sysfs.c
deleted file mode 100644
index 00a97e7..0000000
--- a/drivers/mmc/core/sysfs.c
+++ /dev/null
@@ -1,43 +0,0 @@
-/*
- *  linux/drivers/mmc/core/sysfs.c
- *
- *  Copyright (C) 2003 Russell King, All Rights Reserved.
- *  Copyright 2007 Pierre Ossman
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- *  MMC sysfs/driver model support.
- */
-#include <linux/device.h>
-
-#include <linux/mmc/card.h>
-
-#include "sysfs.h"
-
-int mmc_add_attrs(struct mmc_card *card, struct device_attribute *attrs)
-{
-	int error = 0;
-	int i;
-
-	for (i = 0; attr_name(attrs[i]); i++) {
-		error = device_create_file(&card->dev, &attrs[i]);
-		if (error) {
-			while (--i >= 0)
-				device_remove_file(&card->dev, &attrs[i]);
-			break;
-		}
-	}
-
-	return error;
-}
-
-void mmc_remove_attrs(struct mmc_card *card, struct device_attribute *attrs)
-{
-	int i;
-
-	for (i = 0; attr_name(attrs[i]); i++)
-		device_remove_file(&card->dev, &attrs[i]);
-}
-
diff --git a/drivers/mmc/core/sysfs.h b/drivers/mmc/core/sysfs.h
deleted file mode 100644
index 4b8f670..0000000
--- a/drivers/mmc/core/sysfs.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
- *  linux/drivers/mmc/core/sysfs.h
- *
- *  Copyright (C) 2003 Russell King, All Rights Reserved.
- *  Copyright 2007 Pierre Ossman
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#ifndef _MMC_CORE_SYSFS_H
-#define _MMC_CORE_SYSFS_H
-
-#define MMC_ATTR_FN(name, fmt, args...)					\
-static ssize_t mmc_##name##_show (struct device *dev, struct device_attribute *attr, char *buf)	\
-{									\
-	struct mmc_card *card = container_of(dev, struct mmc_card, dev);\
-	return sprintf(buf, fmt, args);					\
-}
-
-#define MMC_ATTR_RO(name) __ATTR(name, S_IRUGO, mmc_##name##_show, NULL)
-
-int mmc_add_attrs(struct mmc_card *card, struct device_attribute *attrs);
-void mmc_remove_attrs(struct mmc_card *card, struct device_attribute *attrs);
-
-#endif



-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
