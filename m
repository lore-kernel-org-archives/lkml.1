Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbYG0NFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbYG0NFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 09:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbYG0NF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 09:05:26 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41754 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757470AbYG0NFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:05:24 -0400
Date: Sun, 27 Jul 2008 16:04:48 +0300
From: Adrian Bunk <bunk@kernel.org>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] simplify MAX_HWIFS setting
Message-ID: <20080727130448.GK9301@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sh systemh_defconfig currently fails to build with the following 
error:

<--  snip  -->

...
  CC      arch/sh/boards/renesas/systemh/irq.o
In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/boards/renesas/systemh/irq.c:16:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/ide.h:645: error: 'CONFIG_IDE_MAX_HWIFS' undeclared here (not in a function)
make[2]: *** [arch/sh/boards/renesas/systemh/irq.o] Error 1

<--  snip  -->

Considering the little benefits of all this fiddling with IDE_MAX_HWIFS 
I decided to fix it through a simplification:
- always #define MAX_HWIFS      CONFIG_IDE_MAX_HWIFS
- always set CONFIG_IDE_MAX_HWIFS in kconfig
- let IDE_MAX_HWIFS default to 10
- allow changing the value of IDE_MAX_HWIFS only if IDE && EMBEDDED

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ide/Kconfig |    9 ++++-----
 include/linux/ide.h |   11 -----------
 2 files changed, 4 insertions(+), 16 deletions(-)

fd8ca9d5fefc48c04caa910adb753924454d9cfc 
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 130ef64..174b627 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -52,18 +52,17 @@ menuconfig IDE
 
 	  If unsure, say Y.
 
-if IDE
-
 config IDE_MAX_HWIFS
-	int "Max IDE interfaces"
-	depends on ALPHA || SUPERH || IA64 || EMBEDDED
+	int "Max IDE interfaces" if IDE && EMBEDDED
 	range 1 10
-	default 4
+	default 10
 	help
 	  This is the maximum number of IDE hardware interfaces that will
 	  be supported by the driver. Make sure it is at least as high as
 	  the number of IDE interfaces in your system.
 
+if IDE
+
 config BLK_DEV_IDE
 	tristate "Enhanced IDE/MFM/RLL disk/cdrom/tape/floppy support"
 	---help---
diff --git a/include/linux/ide.h b/include/linux/ide.h
index b846bc4..b5b84fe 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -219,18 +219,7 @@ static inline int __ide_default_irq(unsigned long base)
 #include <asm-generic/ide_iops.h>
 #endif
 
-#ifndef MAX_HWIFS
-#if defined(CONFIG_BLACKFIN) || defined(CONFIG_H8300) || defined(CONFIG_XTENSA)
-# define MAX_HWIFS	1
-#else
-# define MAX_HWIFS	10
-#endif
-#endif
-
-#if !defined(MAX_HWIFS) || defined(CONFIG_EMBEDDED)
-#undef MAX_HWIFS
 #define MAX_HWIFS	CONFIG_IDE_MAX_HWIFS
-#endif
 
 /* Currently only m68k, apus and m8xx need it */
 #ifndef IDE_ARCH_ACK_INTR

