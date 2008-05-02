Return-Path: <linux-kernel-owner+w=401wt.eu-S932284AbYEBQwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbYEBQwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 12:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759369AbYEBQwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 12:52:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62234 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbYEBQwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 12:52:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: LogFS merge
Date: Fri, 2 May 2008 18:52:21 +0200
User-Agent: KMail/1.9.9
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
References: <20080502133234.GA24080@logfs.org>
In-Reply-To: <20080502133234.GA24080@logfs.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805021852.22768.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19RfcV+HhCB+SpDICctVT1giEtL62FdDL7BnCc
 m7vGK/a4N1EnMt6I5q7k07byjUmUYLsEp7ISIeXL7nVt/zgh3M
 eVUXxt8BRCAVR4N1Zf/Xg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008, Jörn Engel wrote:
> not being familiar with either maintaining my own git tree or the -next
> process, I'd still like to get logfs into mainline.  It has gone through
> six rounds of reviews and the last has been mostly about crossing some
> i's here and dotting some t's there.
> 
> So should it simmer in -next and -mm for another month?  Should it go
> straight into -linus?
> 
> Either way, please pull from
> master.kernel.org:/pub/scm/linux/kernel/git/joern/logfs.git/

There are still a few i's and t's left to dot and cross:

* the changeset comments needs a Signed-off-by: line
* The MAINTAINERS file should list your name and logfs mailing list
* you have a few instances of '#if LINUX_VERSION_CODE > 
  KERNEL_VERSION(2, 6, 23)', that should go away for the merge
* The copyright notice says 2005-2007, it should probably be 2005-2008
* You may want to add a Documentation/filesystems/logfs.txt file explaining
  the supported mount options.
* CONFIG_LOGFS should be tristate, not bool. Unfortunately, you are still
  using three symbols that are not exported: swapper_space (through
  BUG_ON(!page_mapping(page)->a_ops->set_page_dirty)), add_to_page_cache_lru
 and inode_lock. Not sure what to do about this.
* You should really make sure the version you check in compiles, 
  fs/logfs/logfs.h is missing an #endif. ;-)

Otherwise, I don't see any reasons why logfs shouldn't go in. The code is
clean, feature-complete, and there is demand for it. The main question
I can still see is the timing with the merge window. It's almost closed,
so if logfs doesn't go in really soon, it should probably wait for the
2.6.27 window.

	Arnd <><

---

This patch fixes some of the problems mentined above.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/MAINTAINERS b/MAINTAINERS
index cae9001..4b45c5b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2570,6 +2570,15 @@ L:	linux-ntfs-dev@lists.sourceforge.net
 W:	http://www.linux-ntfs.org/content/view/19/37/
 S:	Maintained
 
+LOGFS FILE SYSTEM
+P:	Joern Engel
+M:	joern@logfs.org
+L:	logfs@logfs.org
+L:	linux-fsdevel@vger.kernel.org
+W:	http://www.logfs.org/
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/joern/logfs.git
+S:	Maintained
+
 LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
 P:	Eric Moore
 M:	Eric.Moore@lsi.com
diff --git a/fs/logfs/compr.c b/fs/logfs/compr.c
index 8f01943..44bbfd2 100644
--- a/fs/logfs/compr.c
+++ b/fs/logfs/compr.c
@@ -3,7 +3,7 @@
  *
  * As should be obvious for Linux kernel code, license is GPLv2
  *
- * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ * Copyright (c) 2005-2008 Joern Engel <joern@logfs.org>
  */
 #include "logfs.h"
 #include <linux/vmalloc.h>
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index c6c5b5f..65106d7 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -3,7 +3,7 @@
  *
  * As should be obvious for Linux kernel code, license is GPLv2
  *
- * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ * Copyright (c) 2005-2008 Joern Engel <joern@logfs.org>
  */
 #include "logfs.h"
 #include <linux/buffer_head.h>
diff --git a/fs/logfs/dev_mtd.c b/fs/logfs/dev_mtd.c
index ea606cf..86e0a6b 100644
--- a/fs/logfs/dev_mtd.c
+++ b/fs/logfs/dev_mtd.c
@@ -3,7 +3,7 @@
  *
  * As should be obvious for Linux kernel code, license is GPLv2
  *
- * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ * Copyright (c) 2005-2008 Joern Engel <joern@logfs.org>
  */
 #include "logfs.h"
 #include <linux/completion.h>
@@ -354,11 +354,7 @@ static int mtd_get_sb(struct file_system_type *fs_type, int flags,
 	return get_sb_pseudo(fs_type, "mtd:", NULL, 0x6D746400, mnt);
 }
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 23)
 static void init_once(struct kmem_cache *cache, void *_mi)
-#else
-static void init_once(void *_mi, struct kmem_cache *cache, unsigned long flags)
-#endif
 {
 	struct mtd_inode *mi = _mi;
 
diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
index f0cf832..2a5ef8e 100644
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -3,7 +3,7 @@
  *
  * As should be obvious for Linux kernel code, license is GPLv2
  *
- * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ * Copyright (c) 2005-2008 Joern Engel <joern@logfs.org>
  */
 #include "logfs.h"
 
diff --git a/fs/logfs/file.c b/fs/logfs/file.c
index 17d2cde..105d470 100644
--- a/fs/logfs/file.c
+++ b/fs/logfs/file.c
@@ -3,7 +3,7 @@
  *
  * As should be obvious for Linux kernel code, license is GPLv2
  *
- * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ * Copyright (c) 2005-2008 Joern Engel <joern@logfs.org>
  */
 #include "logfs.h"
 #include <linux/sched.h>
diff --git a/fs/logfs/gc.c b/fs/logfs/gc.c
index 0767345..ee1c448 100644
--- a/fs/logfs/gc.c
+++ b/fs/logfs/gc.c
@@ -3,7 +3,7 @@
  *
  * As should be obvious for Linux kernel code, license is GPLv2
  *
- * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ * Copyright (c) 2005-2008 Joern Engel <joern@logfs.org>
  *
  * GC design as it should be (and isn't, as of 15.3.07):
  * 1. Pick a good candidate for GC, constrained by the number of currently
diff --git a/fs/logfs/inode.c b/fs/logfs/inode.c
index 0d2b9be..d8f7b66 100644
--- a/fs/logfs/inode.c
+++ b/fs/logfs/inode.c
@@ -3,7 +3,7 @@
  *
  * As should be obvious for Linux kernel code, license is GPLv2
  *
- * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ * Copyright (c) 2005-2008 Joern Engel <joern@logfs.org>
  */
 #include "logfs.h"
 #include <linux/writeback.h>
@@ -539,12 +539,7 @@ struct inode *logfs_new_inode(struct inode *dir, int mode)
 	return inode;
 }
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 23)
 static void logfs_init_once(struct kmem_cache *cachep, void *_li)
-#else
-static void logfs_init_once(void *_li, struct kmem_cache *cachep,
-		unsigned long flags)
-#endif
 {
 	struct logfs_inode *li = _li;
 	int i;
diff --git a/fs/logfs/journal.c b/fs/logfs/journal.c
index a4cde56..cf07646 100644
--- a/fs/logfs/journal.c
+++ b/fs/logfs/journal.c
@@ -3,7 +3,7 @@
  *
  * As should be obvious for Linux kernel code, license is GPLv2
  *
- * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ * Copyright (c) 2005-2008 Joern Engel <joern@logfs.org>
  */
 #include "logfs.h"
 
diff --git a/fs/logfs/logfs.h b/fs/logfs/logfs.h
index 471497f..48622b1 100644
--- a/fs/logfs/logfs.h
+++ b/fs/logfs/logfs.h
@@ -3,7 +3,7 @@
  *
  * As should be obvious for Linux kernel code, license is GPLv2
  *
- * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ * Copyright (c) 2005-2008 Joern Engel <joern@logfs.org>
  *
  * Private header for logfs.
  */
@@ -552,3 +552,4 @@ static inline struct logfs_block *logfs_block(struct page *page)
 {
 	return (void *)page->private;
 }
+#endif /* FS_LOGFS_LOGFS_H */
diff --git a/fs/logfs/logfs_abi.h b/fs/logfs/logfs_abi.h
index 1cfd588..ae8548f 100644
--- a/fs/logfs/logfs_abi.h
+++ b/fs/logfs/logfs_abi.h
@@ -3,7 +3,7 @@
  *
  * As should be obvious for Linux kernel code, license is GPLv2
  *
- * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ * Copyright (c) 2005-2008 Joern Engel <joern@logfs.org>
  *
  * Public header for logfs.
  */
diff --git a/fs/logfs/memtree.c b/fs/logfs/memtree.c
index 68fe7ce..604eea4 100644
--- a/fs/logfs/memtree.c
+++ b/fs/logfs/memtree.c
@@ -3,7 +3,7 @@
  *
  * As should be obvious for Linux kernel code, license is GPLv2
  *
- * Copyright (c) 2007 Joern Engel <joern@logfs.org>
+ * Copyright (c) 2007-2008 Joern Engel <joern@logfs.org>
  *
  *
  * This could possibly get moved to lib/.
diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
index ed1226f..b35c3dc 100644
--- a/fs/logfs/readwrite.c
+++ b/fs/logfs/readwrite.c
@@ -3,7 +3,7 @@
  *
  * As should be obvious for Linux kernel code, license is GPLv2
  *
- * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ * Copyright (c) 2005-2008 Joern Engel <joern@logfs.org>
  *
  *
  * Actually contains five sets of very similar functions:
diff --git a/fs/logfs/segment.c b/fs/logfs/segment.c
index 13d4301..77defd2 100644
--- a/fs/logfs/segment.c
+++ b/fs/logfs/segment.c
@@ -3,7 +3,7 @@
  *
  * As should be obvious for Linux kernel code, license is GPLv2
  *
- * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ * Copyright (c) 2005-2008 Joern Engel <joern@logfs.org>
  *
  * Object store or ostore makes up the complete device with exception of
  * the superblock and journal areas.  Apart from its own metadata it stores
diff --git a/fs/logfs/super.c b/fs/logfs/super.c
index 1f64494..d138a76 100644
--- a/fs/logfs/super.c
+++ b/fs/logfs/super.c
@@ -3,7 +3,7 @@
  *
  * As should be obvious for Linux kernel code, license is GPLv2
  *
- * Copyright (c) 2005-2007 Joern Engel <joern@logfs.org>
+ * Copyright (c) 2005-2008 Joern Engel <joern@logfs.org>
  *
  * Generally contains mount/umount code and also serves as a dump area for
  * any functions that don't fit elsewhere and neither justify a file of their
