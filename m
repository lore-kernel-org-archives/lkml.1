Return-Path: <linux-kernel-owner+w=401wt.eu-S1761969AbXHGSrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761969AbXHGSrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 14:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbXHGSrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 14:47:10 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:43815 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbXHGSrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 14:47:09 -0400
Date: Tue, 7 Aug 2007 20:47:22 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] remove genhd.h from header exports
Message-ID: <20070807184722.GA31015@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


remove linux/genhd.h from make headers_install

It contains no userinterfaces, only the msdos partition table layout and some
numbers. And it became finally unusable with the CONFIG_BLOCK addition.

Remove it from the Kconfig list, and remove the __KERNEL__ checks.
Move #include block up
remove unused inclusion of linux/major.h

compile tested with ppc64_defconfig


Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 include/linux/Kbuild  |    1 -
 include/linux/genhd.h |   37 ++++++-------------------------------
 2 files changed, 6 insertions(+), 32 deletions(-)

--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -204,7 +204,6 @@ unifdef-y += futex.h
 unifdef-y += fs.h
 unifdef-y += gameport.h
 unifdef-y += generic_serial.h
-unifdef-y += genhd.h
 unifdef-y += gfs2_ondisk.h
 unifdef-y += hayesesp.h
 unifdef-y += hdlcdrv.h
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -9,9 +9,14 @@
  *		<drew@colorado.edu>
  */
 
+#ifdef CONFIG_BLOCK
 #include <linux/types.h>
+#include <linux/device.h>
+#include <linux/smp.h>
+#include <linux/string.h>
+#include <linux/fs.h>
+#include <linux/workqueue.h>
 
-#ifdef CONFIG_BLOCK
 
 enum {
 /* These three have identical behaviour; use the second one if DOS FDISK gets
@@ -43,31 +48,6 @@ enum {
 	UNIXWARE_PARTITION = 0x63,	/* Same as GNU_HURD and SCO Unix */
 };
 
-#ifndef __KERNEL__
-
-struct partition {
-	unsigned char boot_ind;		/* 0x80 - active */
-	unsigned char head;		/* starting head */
-	unsigned char sector;		/* starting sector */
-	unsigned char cyl;		/* starting cylinder */
-	unsigned char sys_ind;		/* What partition type */
-	unsigned char end_head;		/* end head */
-	unsigned char end_sector;	/* end sector */
-	unsigned char end_cyl;		/* end cylinder */
-	unsigned int start_sect;	/* starting sector counting from 0 */
-	unsigned int nr_sects;		/* nr of sectors in partition */
-} __attribute__((packed));
-
-#endif
-
-#ifdef __KERNEL__
-#include <linux/major.h>
-#include <linux/device.h>
-#include <linux/smp.h>
-#include <linux/string.h>
-#include <linux/fs.h>
-#include <linux/workqueue.h>
-
 struct partition {
 	unsigned char boot_ind;		/* 0x80 - active */
 	unsigned char head;		/* starting head */
@@ -260,8 +240,6 @@ static inline void set_capacity(struct g
 	disk->capacity = size;
 }
 
-#endif  /*  __KERNEL__  */
-
 #ifdef CONFIG_SOLARIS_X86_PARTITION
 
 #define SOLARIS_X86_NUMSLICE	16
@@ -405,7 +383,6 @@ struct unixware_disklabel {
 #   define MINIX_NR_SUBPARTITIONS  4
 #endif /* CONFIG_MINIX_SUBPARTITION */
 
-#ifdef __KERNEL__
 
 #define ADDPART_FLAG_NONE	0
 #define ADDPART_FLAG_RAID	1
@@ -435,8 +412,6 @@ static inline struct block_device *bdget
 	return bdget(MKDEV(disk->major, disk->first_minor) + index);
 }
 
-#endif
-
 #else /* CONFIG_BLOCK */
 
 static inline void printk_all_partitions(void) { }
