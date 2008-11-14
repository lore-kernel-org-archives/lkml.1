Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbYKNTKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbYKNTKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYKNTKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:10:34 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58772 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbYKNTKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:10:33 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Bryan Wu <Bryan.Wu@analog.com>
Subject: [PATCH] mtd/physmap: make physmap compat explicit
Date: Fri, 14 Nov 2008 14:10:32 -0500
Message-Id: <1226689832-21362-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current method for always showing physmap compat address, size, and
width is a bit confusing.  If length is set to 0, then the address and width
are still shown but silently unused.  The physmap code itself already has
logic which sets compat based on length, so just pull that out and into the
Kconfig to make everything clear.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Bryan Wu <Bryan.Wu@analog.com>
---
 drivers/mtd/maps/Kconfig   |   17 ++++++++++++++---
 drivers/mtd/maps/physmap.c |   16 ++++------------
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 5ea1693..3788a54 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -23,9 +23,20 @@ config MTD_PHYSMAP
 	  To compile this driver as a module, choose M here: the
 	  module will be called physmap.
 
+config MTD_PHYSMAP_COMPAT
+	bool "Physmap compat support"
+	depends on MTD_PHYSMAP
+	default n
+	help
+	  Setup a simple mapping via the Kconfig options.  Normally the
+	  physmap configuration options are done via your board's
+	  resource file.
+
+	  If unsure, say N here.
+
 config MTD_PHYSMAP_START
 	hex "Physical start address of flash mapping"
-	depends on MTD_PHYSMAP
+	depends on MTD_PHYSMAP_COMPAT
 	default "0x8000000"
 	help
 	  This is the physical memory location at which the flash chips
@@ -37,7 +48,7 @@ config MTD_PHYSMAP_START
 
 config MTD_PHYSMAP_LEN
 	hex "Physical length of flash mapping"
-	depends on MTD_PHYSMAP
+	depends on MTD_PHYSMAP_COMPAT
 	default "0"
 	help
 	  This is the total length of the mapping of the flash chips on
@@ -51,7 +62,7 @@ config MTD_PHYSMAP_LEN
 
 config MTD_PHYSMAP_BANKWIDTH
 	int "Bank width in octets"
-	depends on MTD_PHYSMAP
+	depends on MTD_PHYSMAP_COMPAT
 	default "2"
 	help
 	  This is the total width of the data bus of the flash devices
diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index 42d844f..e2f99b7 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -259,14 +259,7 @@ static struct platform_driver physmap_flash_driver = {
 };
 
 
-#ifdef CONFIG_MTD_PHYSMAP_LEN
-#if CONFIG_MTD_PHYSMAP_LEN != 0
-#warning using PHYSMAP compat code
-#define PHYSMAP_COMPAT
-#endif
-#endif
-
-#ifdef PHYSMAP_COMPAT
+#ifdef CONFIG_MTD_PHYSMAP_COMPAT
 static struct physmap_flash_data physmap_flash_data = {
 	.width		= CONFIG_MTD_PHYSMAP_BANKWIDTH,
 };
@@ -310,7 +303,7 @@ static int __init physmap_init(void)
 	int err;
 
 	err = platform_driver_register(&physmap_flash_driver);
-#ifdef PHYSMAP_COMPAT
+#ifdef CONFIG_MTD_PHYSMAP_COMPAT
 	if (err == 0)
 		platform_device_register(&physmap_flash);
 #endif
@@ -320,7 +313,7 @@ static int __init physmap_init(void)
 
 static void __exit physmap_exit(void)
 {
-#ifdef PHYSMAP_COMPAT
+#ifdef CONFIG_MTD_PHYSMAP_COMPAT
 	platform_device_unregister(&physmap_flash);
 #endif
 	platform_driver_unregister(&physmap_flash_driver);
@@ -334,8 +327,7 @@ MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
 MODULE_DESCRIPTION("Generic configurable MTD map driver");
 
 /* legacy platform drivers can't hotplug or coldplg */
-#ifndef PHYSMAP_COMPAT
+#ifndef CONFIG_MTD_PHYSMAP_COMPAT
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:physmap-flash");
 #endif
-
-- 
1.6.0.3

