Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319AbYCLQx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbYCLQx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYCLQxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:53:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56836 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbYCLQxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:53:20 -0400
Subject: [PATCH] Remove <linux/genhd.h> from user-visible headers.
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, matthew@wil.cx,
       dhowells@redhat.com
Content-Type: text/plain
Date: Wed, 12 Mar 2008 17:52:56 +0100
Message-Id: <1205340777.2592.134.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was all wrapped in '#ifdef CONFIG_BLOCK' anyway, so userspace was
getting nothing useful out of it. And the special #ifndef __KERNEL__
version of 'struct partition' makes me inclined to promote an attitude
of violence...

Stick some comments on some of the #endifs too, while we're at it.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 994df37..0fac822 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -205,7 +205,6 @@ unifdef-y += futex.h
 unifdef-y += fs.h
 unifdef-y += gameport.h
 unifdef-y += generic_serial.h
-unifdef-y += genhd.h
 unifdef-y += gfs2_ondisk.h
 unifdef-y += hayesesp.h
 unifdef-y += hdlcdrv.h
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 32c2ac4..ecd2bf6 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -55,24 +55,6 @@ enum {
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
 #include <linux/major.h>
 #include <linux/device.h>
 #include <linux/smp.h>
@@ -228,7 +210,7 @@ static inline void part_stat_set_all(struct hd_struct *part, int value)	{
 		       sizeof(struct disk_stats));
 }
 				
-#else
+#else /* !CONFIG_SMP */
 #define __disk_stat_add(gendiskp, field, addnd) \
 				(gendiskp->dkstats.field += addnd)
 #define disk_stat_read(gendiskp, field)	(gendiskp->dkstats.field)
@@ -256,7 +238,7 @@ static inline void part_stat_set_all(struct hd_struct *part, int value)
 	memset(&part->dkstats, value, sizeof(struct disk_stats));
 }
 
-#endif
+#endif /* CONFIG_SMP */
 
 #define disk_stat_add(gendiskp, field, addnd)			\
 	do {							\
@@ -395,8 +377,6 @@ static inline void set_capacity(struct gendisk *disk, sector_t size)
 	disk->capacity = size;
 }
 
-#endif  /*  __KERNEL__  */
-
 #ifdef CONFIG_SOLARIS_X86_PARTITION
 
 #define SOLARIS_X86_NUMSLICE	16
@@ -540,8 +520,6 @@ struct unixware_disklabel {
 #   define MINIX_NR_SUBPARTITIONS  4
 #endif /* CONFIG_MINIX_SUBPARTITION */
 
-#ifdef __KERNEL__
-
 #define ADDPART_FLAG_NONE	0
 #define ADDPART_FLAG_RAID	1
 #define ADDPART_FLAG_WHOLEDISK	2
@@ -570,8 +548,6 @@ static inline struct block_device *bdget_disk(struct gendisk *disk, int index)
 	return bdget(MKDEV(disk->major, disk->first_minor) + index);
 }
 
-#endif
-
 #else /* CONFIG_BLOCK */
 
 static inline void printk_all_partitions(void) { }
@@ -584,4 +560,4 @@ static inline dev_t blk_lookup_devt(const char *name)
 
 #endif /* CONFIG_BLOCK */
 
-#endif
+#endif /* _LINUX_GENHD_H */


-- 
dwmw2

