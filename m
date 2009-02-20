Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbZBTRRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbZBTRRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbZBTRRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:17:17 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:43866 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZBTRRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:17:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=ZN31dfhGuw2x8qNw6MzoEt5KCifCqdKqMILBcFmzKjTsrFsKy5xsDQRqZQKxvEuBSE
         qLxrOtGD2NXB0WDnz5RKzsR5fxaCbDPXruSQjuhfe6BVYYhTV8xG9MXRbZd75KuioSB9
         mKGriScBhAd160TR96wdbkKqG2NTYvdJq7hEU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/2] ide-generic: remove no longer needed sysfs interface
Date: Fri, 20 Feb 2009 18:18:12 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-next-20090219; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
       Alexander Schulz <alex@shark-linux.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902201818.12765.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-generic: remove no longer needed sysfs interface

Nowadays we have "ide_generic.probe_mask=" module parameter
and ide_platform host driver so sysfs interface for adding
IDE interfaces is no longer needed.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
on top of pata-2.6 tree

 drivers/ide/ide-generic.c |   68 ----------------------------------------------
 1 file changed, 1 insertion(+), 67 deletions(-)

Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -1,20 +1,12 @@
 /*
  * generic/default IDE host driver
  *
- * Copyright (C) 2004, 2008 Bartlomiej Zolnierkiewicz
+ * Copyright (C) 2004, 2008-2009 Bartlomiej Zolnierkiewicz
  * This code was split off from ide.c.  See it for original copyrights.
  *
  * May be copied or modified under the terms of the GNU General Public License.
  */
 
-/*
- * For special cases new interfaces may be added using sysfs, i.e.
- *
- *	echo -n "0x168:0x36e:10" > /sys/class/ide_generic/add
- *
- * will add an interface using I/O ports 0x168-0x16f/0x36e and IRQ 10.
- */
-
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -36,60 +28,6 @@ static const struct ide_port_info ide_ge
 	.host_flags		= IDE_HFLAG_NO_DMA,
 };
 
-static ssize_t store_add(struct class *cls, const char *buf, size_t n)
-{
-	unsigned int base, ctl;
-	int irq, rc;
-	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-
-	if (sscanf(buf, "%x:%x:%d", &base, &ctl, &irq) != 3)
-		return -EINVAL;
-
-	memset(&hw, 0, sizeof(hw));
-	ide_std_init_ports(&hw, base, ctl);
-	hw.irq = irq;
-	hw.chipset = ide_generic;
-
-	rc = ide_host_add(&ide_generic_port_info, hws, NULL);
-	if (rc)
-		return rc;
-
-	return n;
-};
-
-static struct class_attribute ide_generic_class_attrs[] = {
-	__ATTR(add, S_IWUSR, NULL, store_add),
-	__ATTR_NULL
-};
-
-static void ide_generic_class_release(struct class *cls)
-{
-	kfree(cls);
-}
-
-static int __init ide_generic_sysfs_init(void)
-{
-	struct class *cls;
-	int rc;
-
-	cls = kzalloc(sizeof(*cls), GFP_KERNEL);
-	if (!cls)
-		return -ENOMEM;
-
-	cls->name = DRV_NAME;
-	cls->owner = THIS_MODULE;
-	cls->class_release = ide_generic_class_release;
-	cls->class_attrs = ide_generic_class_attrs;
-
-	rc = class_register(cls);
-	if (rc) {
-		kfree(cls);
-		return rc;
-	}
-
-	return 0;
-}
-
 #if defined(CONFIG_PLAT_M32700UT) || defined(CONFIG_PLAT_MAPPI2) \
 	|| defined(CONFIG_PLAT_OPSPUT)
 static const u16 legacy_bases[] = { 0x1f0 };
@@ -196,10 +134,6 @@ static int __init ide_generic_init(void)
 		}
 	}
 
-	if (ide_generic_sysfs_init())
-		printk(KERN_ERR DRV_NAME ": failed to create ide_generic "
-					 "class\n");
-
 	return rc;
 }
 
