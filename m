Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbYCZKPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbYCZKPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbYCZKP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:15:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54276 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbYCZKP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:15:28 -0400
Date: Wed, 26 Mar 2008 11:14:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: David Miller <davem@davemloft.net>, jirislaby@gmail.com,
       viro@ZenIV.linux.org.uk, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: [patch] bkl2mtd: cleanup
Message-ID: <20080326101452.GA17176@elte.hu>
References: <20080323.032013.79276201.davem@davemloft.net> <47E647AC.1060906@gmail.com> <20080323.051929.267232495.davem@davemloft.net> <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org> <20080325122413.GA8729@elte.hu> <20080325131258.GC11359@logfs.org> <20080325133810.GA10044@elte.hu> <20080325134556.GA10424@elte.hu> <20080325160734.GA14583@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080325160734.GA14583@logfs.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jörn Engel <joern@logfs.org> wrote:

> >  ERROR: do not initialise statics to 0 or NULL
> 
> The last should and will be fixed.  The // I don't really care about. 
> Send a patch if you do.

sure, find clean-up patch below. (Some of the changes are for just tiny 
nuances, not mentioned in CodingStyle nor flagged by checkpatch)

	Ingo

------------------------>
Subject: bkl2mtd: cleanup
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Mar 26 10:40:47 CET 2008

Before:
   total: 10 errors, 4 warnings, 488 lines checked
After:
   total: 0 errors, 0 warnings, 497 lines checked

No code changed, except the small shrink due to the 
block2mtd_init_called initialization change:

drivers/mtd/devices/block2mtd.o:

   text	   data	    bss	    dec	    hex	filename
   3097	     16	    124	   3237	    ca5	block2mtd.o.before
   3093	     16	    124	   3233	    ca1	block2mtd.o.after

md5 changes only due to the different section that the
block2mtd_init_called got into:

   bacbb932ec90b514f8adf654afa29b44  block2mtd.o.before.asm
   05e1252749f7294f45c79c44554ec6ba  block2mtd.o.after.asm

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/mtd/devices/block2mtd.c |  151 +++++++++++++++++++++-------------------
 1 file changed, 80 insertions(+), 71 deletions(-)

Index: linux/drivers/mtd/devices/block2mtd.c
===================================================================
--- linux.orig/drivers/mtd/devices/block2mtd.c
+++ linux/drivers/mtd/devices/block2mtd.c
@@ -1,6 +1,4 @@
 /*
- * $Id: block2mtd.c,v 1.30 2005/11/29 14:48:32 gleixner Exp $
- *
  * block2mtd.c - create an mtd from a block device
  *
  * Copyright (C) 2001,2002	Simon Evans <spse@secret.org.uk>
@@ -20,7 +18,7 @@
 #include <linux/mutex.h>
 #include <linux/mount.h>
 
-#define VERSION "$Revision: 1.30 $"
+#define VERSION "Revision: 1.30"
 
 
 #define ERROR(fmt, args...) printk(KERN_ERR "block2mtd: " fmt "\n" , ## args)
@@ -29,13 +27,13 @@
 
 /* Info for the block device */
 struct block2mtd_dev {
-	struct list_head list;
-	struct block_device *blkdev;
-	struct mtd_info mtd;
-	struct mutex write_mutex;
+	struct list_head	list;
+	struct block_device	*blkdev;
+	struct mtd_info		mtd;
+	/* serializes writes with each other and also with erase: */
+	struct mutex		write_mutex;
 };
 
-
 /* Static info about the MTD, used in cleanup_module */
 static LIST_HEAD(blkmtd_device_list);
 
@@ -49,11 +47,11 @@ static struct page *page_read(struct add
 static int _block2mtd_erase(struct block2mtd_dev *dev, loff_t to, size_t len)
 {
 	struct address_space *mapping = dev->blkdev->bd_inode->i_mapping;
-	struct page *page;
-	int index = to >> PAGE_SHIFT;	// page index
+	int index = to >> PAGE_SHIFT;	/* page index */
 	int pages = len >> PAGE_SHIFT;
-	u_long *p;
+	struct page *page;
 	u_long *max;
+	u_long *p;
 
 	while (pages) {
 		page = page_read(mapping, index);
@@ -63,7 +61,7 @@ static int _block2mtd_erase(struct block
 			return PTR_ERR(page);
 
 		max = page_address(page) + PAGE_SIZE;
-		for (p=page_address(page); p<max; p++)
+		for (p = page_address(page); p < max; p++) {
 			if (*p != -1UL) {
 				lock_page(page);
 				memset(page_address(page), 0xff, PAGE_SIZE);
@@ -71,6 +69,7 @@ static int _block2mtd_erase(struct block
 				unlock_page(page);
 				break;
 			}
+		}
 
 		page_cache_release(page);
 		pages--;
@@ -78,6 +77,7 @@ static int _block2mtd_erase(struct block
 	}
 	return 0;
 }
+
 static int block2mtd_erase(struct mtd_info *mtd, struct erase_info *instr)
 {
 	struct block2mtd_dev *dev = mtd->priv;
@@ -86,17 +86,21 @@ static int block2mtd_erase(struct mtd_in
 	int err;
 
 	instr->state = MTD_ERASING;
+
 	mutex_lock(&dev->write_mutex);
 	err = _block2mtd_erase(dev, from, len);
 	mutex_unlock(&dev->write_mutex);
+
 	if (err) {
 		ERROR("erase failed err = %d", err);
 		instr->state = MTD_ERASE_FAILED;
-	} else
+	} else {
 		instr->state = MTD_ERASE_DONE;
+	}
 
 	instr->state = MTD_ERASE_DONE;
 	mtd_erase_callback(instr);
+
 	return err;
 }
 
@@ -105,13 +109,14 @@ static int block2mtd_read(struct mtd_inf
 		size_t *retlen, u_char *buf)
 {
 	struct block2mtd_dev *dev = mtd->priv;
-	struct page *page;
 	int index = from >> PAGE_SHIFT;
 	int offset = from & (PAGE_SIZE-1);
+	struct page *page;
 	int cpylen;
 
 	if (from > mtd->size)
 		return -EINVAL;
+
 	if (from + len > mtd->size)
 		len = mtd->size - from;
 
@@ -120,9 +125,9 @@ static int block2mtd_read(struct mtd_inf
 
 	while (len) {
 		if ((offset + len) > PAGE_SIZE)
-			cpylen = PAGE_SIZE - offset;	// multiple pages
+			cpylen = PAGE_SIZE - offset;	/* multiple pages */
 		else
-			cpylen = len;	// this page
+			cpylen = len;			/* this page */
 		len = len - cpylen;
 
 		page = page_read(dev->blkdev->bd_inode->i_mapping, index);
@@ -145,22 +150,23 @@ static int block2mtd_read(struct mtd_inf
 
 
 /* write data to the underlying device */
-static int _block2mtd_write(struct block2mtd_dev *dev, const u_char *buf,
-		loff_t to, size_t len, size_t *retlen)
+static int
+_block2mtd_write(struct block2mtd_dev *dev, const u_char *buf, loff_t to,
+		 size_t len, size_t *retlen)
 {
-	struct page *page;
 	struct address_space *mapping = dev->blkdev->bd_inode->i_mapping;
-	int index = to >> PAGE_SHIFT;	// page index
-	int offset = to & ~PAGE_MASK;	// page offset
+	int index = to >> PAGE_SHIFT;	/* page index */
+	int offset = to & ~PAGE_MASK;	/* page offset */
+	struct page *page;
 	int cpylen;
 
 	if (retlen)
 		*retlen = 0;
 	while (len) {
 		if ((offset+len) > PAGE_SIZE)
-			cpylen = PAGE_SIZE - offset;	// multiple pages
+			cpylen = PAGE_SIZE - offset;	/* multiple pages */
 		else
-			cpylen = len;			// this page
+			cpylen = len;			/* this page */
 		len = len - cpylen;
 
 		page = page_read(mapping, index);
@@ -187,8 +193,8 @@ static int _block2mtd_write(struct block
 	return 0;
 }
 
-
-static int block2mtd_write(struct mtd_info *mtd, loff_t to, size_t len,
+static int
+block2mtd_write(struct mtd_info *mtd, loff_t to, size_t len,
 		size_t *retlen, const u_char *buf)
 {
 	struct block2mtd_dev *dev = mtd->priv;
@@ -198,12 +204,14 @@ static int block2mtd_write(struct mtd_in
 		return 0;
 	if (to >= mtd->size)
 		return -ENOSPC;
+
 	if (to + len > mtd->size)
 		len = mtd->size - to;
 
 	mutex_lock(&dev->write_mutex);
 	err = _block2mtd_write(dev, buf, to, len, retlen);
 	mutex_unlock(&dev->write_mutex);
+
 	if (err > 0)
 		err = 0;
 	return err;
@@ -214,8 +222,8 @@ static int block2mtd_write(struct mtd_in
 static void block2mtd_sync(struct mtd_info *mtd)
 {
 	struct block2mtd_dev *dev = mtd->priv;
+
 	sync_blockdev(dev->blkdev);
-	return;
 }
 
 
@@ -253,14 +261,14 @@ static struct block2mtd_dev *add_device(
 	bdev = open_bdev_excl(devname, O_RDWR, NULL);
 #ifndef MODULE
 	if (IS_ERR(bdev)) {
-
-		/* We might not have rootfs mounted at this point. Try
-		   to resolve the device name by other means. */
-
+		/*
+		 * We might not have rootfs mounted at this point. Try
+		 * to resolve the device name by other means.
+		 */
 		dev_t devt = name_to_dev_t(devname);
-		if (devt) {
+
+		if (devt)
 			bdev = open_by_devnum(devt, FMODE_WRITE | FMODE_READ);
-		}
 	}
 #endif
 
@@ -286,18 +294,18 @@ static struct block2mtd_dev *add_device(
 
 	sprintf(dev->mtd.name, "block2mtd: %s", devname);
 
-	dev->mtd.size = dev->blkdev->bd_inode->i_size & PAGE_MASK;
-	dev->mtd.erasesize = erase_size;
-	dev->mtd.writesize = 1;
-	dev->mtd.type = MTD_RAM;
-	dev->mtd.flags = MTD_CAP_RAM;
-	dev->mtd.erase = block2mtd_erase;
-	dev->mtd.write = block2mtd_write;
-	dev->mtd.writev = default_mtd_writev;
-	dev->mtd.sync = block2mtd_sync;
-	dev->mtd.read = block2mtd_read;
-	dev->mtd.priv = dev;
-	dev->mtd.owner = THIS_MODULE;
+	dev->mtd.size		= dev->blkdev->bd_inode->i_size & PAGE_MASK;
+	dev->mtd.erasesize	= erase_size;
+	dev->mtd.writesize	= 1;
+	dev->mtd.type		= MTD_RAM;
+	dev->mtd.flags		= MTD_CAP_RAM;
+	dev->mtd.erase		= block2mtd_erase;
+	dev->mtd.write		= block2mtd_write;
+	dev->mtd.writev		= default_mtd_writev;
+	dev->mtd.sync		= block2mtd_sync;
+	dev->mtd.read		= block2mtd_read;
+	dev->mtd.priv		= dev;
+	dev->mtd.owner		= THIS_MODULE;
 
 	if (add_mtd_device(&dev->mtd)) {
 		/* Device didnt get added, so free the entry */
@@ -311,11 +319,12 @@ static struct block2mtd_dev *add_device(
 
 devinit_err:
 	block2mtd_free_device(dev);
+
 	return NULL;
 }
 
-
-/* This function works similar to reguler strtoul.  In addition, it
+/*
+ * This function works similar to reguler strtoul.  In addition, it
  * allows some suffixes for a more human-readable number format:
  * ki, Ki, kiB, KiB	- multiply result with 1024
  * Mi, MiB		- multiply result with 1024^2
@@ -324,6 +333,7 @@ devinit_err:
 static int ustrtoul(const char *cp, char **endp, unsigned int base)
 {
 	unsigned long result = simple_strtoul(cp, endp, base);
+
 	switch (**endp) {
 	case 'G' :
 		result *= 1024;
@@ -343,7 +353,6 @@ static int ustrtoul(const char *cp, char
 	return result;
 }
 
-
 static int parse_num(size_t *num, const char *token)
 {
 	char *endp;
@@ -354,10 +363,10 @@ static int parse_num(size_t *num, const 
 		return -EINVAL;
 
 	*num = n;
+
 	return 0;
 }
 
-
 static inline void kill_final_newline(char *str)
 {
 	char *newline = strrchr(str, '\n');
@@ -365,25 +374,25 @@ static inline void kill_final_newline(ch
 		*newline = 0;
 }
 
-
 #define parse_err(fmt, args...) do {		\
 	ERROR("block2mtd: " fmt "\n", ## args);	\
 	return 0;				\
 } while (0)
 
+#define BLK2MTD_PARAM_SIZE (80 + 12) /* 80 for device, 12 for erase size */
+
 #ifndef MODULE
-static int block2mtd_init_called = 0;
-static char block2mtd_paramline[80 + 12]; /* 80 for device, 12 for erase size */
+static int block2mtd_init_called;
+static char block2mtd_paramline[BLK2MTD_PARAM_SIZE];
 #endif
 
-
 static int block2mtd_setup2(const char *val)
 {
-	char buf[80 + 12]; /* 80 for device, 12 for erase size */
+	size_t erase_size = PAGE_SIZE;
+	char buf[BLK2MTD_PARAM_SIZE];
 	char *str = buf;
 	char *token[2];
 	char *name;
-	size_t erase_size = PAGE_SIZE;
 	int i, ret;
 
 	if (strnlen(val, sizeof(buf)) >= sizeof(buf))
@@ -407,9 +416,8 @@ static int block2mtd_setup2(const char *
 
 	if (token[1]) {
 		ret = parse_num(&erase_size, token[1]);
-		if (ret) {
+		if (ret)
 			parse_err("illegal erase size");
-		}
 	}
 
 	add_device(name, erase_size);
@@ -423,34 +431,36 @@ static int block2mtd_setup(const char *v
 #ifdef MODULE
 	return block2mtd_setup2(val);
 #else
-	/* If more parameters are later passed in via
-	   /sys/module/block2mtd/parameters/block2mtd
-	   and block2mtd_init() has already been called,
-	   we can parse the argument now. */
-
+	/*
+	 * If more parameters are later passed in via
+	 * /sys/module/block2mtd/parameters/block2mtd
+	 * and block2mtd_init() has already been called,
+	 * we can parse the argument now:
+	 */
 	if (block2mtd_init_called)
 		return block2mtd_setup2(val);
 
-	/* During early boot stage, we only save the parameters
-	   here. We must parse them later: if the param passed
-	   from kernel boot command line, block2mtd_setup() is
-	   called so early that it is not possible to resolve
-	   the device (even kmalloc() fails). Deter that work to
-	   block2mtd_setup2(). */
-
+	/*
+	 * During early boot stage, we only save the parameters
+	 * here. We must parse them later: if the param passed
+	 * from kernel boot command line, block2mtd_setup() is
+	 * called so early that it is not possible to resolve
+	 * the device (even kmalloc() fails). Deter that work to
+	 * block2mtd_setup2():
+	 */
 	strlcpy(block2mtd_paramline, val, sizeof(block2mtd_paramline));
 
 	return 0;
 #endif
 }
 
-
 module_param_call(block2mtd, block2mtd_setup, NULL, NULL, 0200);
 MODULE_PARM_DESC(block2mtd, "Device to use. \"block2mtd=<dev>[,<erasesize>]\"");
 
 static int __init block2mtd_init(void)
 {
 	int ret = 0;
+
 	INFO("version " VERSION);
 
 #ifndef MODULE
@@ -462,7 +472,6 @@ static int __init block2mtd_init(void)
 	return ret;
 }
 
-
 static void __devexit block2mtd_exit(void)
 {
 	struct list_head *pos, *next;
@@ -470,6 +479,7 @@ static void __devexit block2mtd_exit(voi
 	/* Remove the MTD devices */
 	list_for_each_safe(pos, next, &blkmtd_device_list) {
 		struct block2mtd_dev *dev = list_entry(pos, typeof(*dev), list);
+
 		block2mtd_sync(&dev->mtd);
 		del_mtd_device(&dev->mtd);
 		INFO("mtd%d: [%s] removed", dev->mtd.index,
@@ -479,7 +489,6 @@ static void __devexit block2mtd_exit(voi
 	}
 }
 
-
 module_init(block2mtd_init);
 module_exit(block2mtd_exit);
 
