Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbYG2QtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbYG2QtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 12:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYG2Qsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 12:48:50 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36483 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbYG2Qst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 12:48:49 -0400
Date: Tue, 29 Jul 2008 19:48:01 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove CONFIG_IDE_MAX_HWIFS
Message-ID: <20080729164801.GB23951@cs181140183.pp.htv.fi>
References: <20080727130448.GK9301@cs181140183.pp.htv.fi> <200807271632.16417.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200807271632.16417.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 04:32:16PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 27 July 2008, Adrian Bunk wrote:
>...
> > <--  snip  -->
> > 
> > Considering the little benefits of all this fiddling with IDE_MAX_HWIFS 
> > I decided to fix it through a simplification:
> > - always #define MAX_HWIFS      CONFIG_IDE_MAX_HWIFS
> > - always set CONFIG_IDE_MAX_HWIFS in kconfig
> > - let IDE_MAX_HWIFS default to 10
> > - allow changing the value of IDE_MAX_HWIFS only if IDE && EMBEDDED
> 
> I was actually wondering whether it is worth to keep IDE_MAX_HWIFS
> now that ide_hwif_t instances are allocated dynamically.
> 
> [ The difference between MAX_HWIFS == 10 and MAX_HWIFS == 2 is now
>   ~100 bytes (x86_32) and between MAX_HWIFS == 10 and MAX_HWIFS == 1
>   it is ~1kb (IIRC). ]
> 
> Since there were also many other improvements in shrinking drivers/ide/
> code size which should keep embedded users happy and compensate for
> the above 1kB-worst-case I would prefer to have IDE_MAX_HWIFS removed
> completely.
>...

Patch below.

cu
Adrian


<--  snip  -->


The benefits of a user settable CONFIG_IDE_MAX_HWIFS have become pretty 
tiny and are no longer considered worth the trouble of an own option.

Simply always #define MAX_HWIFS to 10.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ide/Kconfig |   10 ----------
 include/linux/ide.h |   13 +------------
 2 files changed, 1 insertion(+), 22 deletions(-)

f09c0c4e445dff712ad883c173e4da02ce943e5d 
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 130ef64..a34758d 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -54,16 +54,6 @@ menuconfig IDE
 
 if IDE
 
-config IDE_MAX_HWIFS
-	int "Max IDE interfaces"
-	depends on ALPHA || SUPERH || IA64 || EMBEDDED
-	range 1 10
-	default 4
-	help
-	  This is the maximum number of IDE hardware interfaces that will
-	  be supported by the driver. Make sure it is at least as high as
-	  the number of IDE interfaces in your system.
-
 config BLK_DEV_IDE
 	tristate "Enhanced IDE/MFM/RLL disk/cdrom/tape/floppy support"
 	---help---
diff --git a/include/linux/ide.h b/include/linux/ide.h
index b846bc4..1347c82 100644
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
-#define MAX_HWIFS	CONFIG_IDE_MAX_HWIFS
-#endif
+#define MAX_HWIFS	10
 
 /* Currently only m68k, apus and m8xx need it */
 #ifndef IDE_ARCH_ACK_INTR

