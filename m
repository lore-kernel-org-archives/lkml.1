Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0BGDoO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 22:44:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:16528 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab0BGDns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 22:43:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,420,1262592000"; 
   d="scan'208";a="770770380"
Message-Id: <20100207034223.754563814@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 07 Feb 2010 11:28:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Roland Dreier <rdreier@cisco.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@amd64.org>
CC: Jamie Lokier <jamie@shareable.org>
CC: Eric Paris <eparis@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] vfs: introduce FMODE_NEG_OFFSET for allowing negative f_pos
References: <20100207032805.769788305@intel.com>
Content-Disposition: inline; filename=f_pos-fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, rw_verify_area() checsk f_pos is negative or not. And if
negative, returns -EINVAL.

But, some special files as /dev/(k)mem and /proc/<pid>/mem etc..
has negative offsets. And we can't do any access via read/write
to the file(device).

So introduce FMODE_NEG_OFFSET to allow negative file offsets.

Changelog: v5->v6
 - use FMODE_NEG_OFFSET (suggested by Al)
 - rebased onto 2.6.33-rc1

Changelog: v4->v5
 - clean up patches dor /dev/mem.
 - rebased onto 2.6.32-rc1

Changelog: v3->v4
 - make changes in mem.c aligned.
 - change __negative_fpos_check() to return int. 
 - fixed bug in "pos" check.
 - added comments.

Changelog: v2->v3
 - fixed bug in rw_verify_area (it cannot be compiled)

CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 drivers/char/mem.c |    4 ++++
 fs/proc/base.c     |    2 ++
 fs/read_write.c    |   21 +++++++++++++++++++--
 include/linux/fs.h |    3 +++
 4 files changed, 28 insertions(+), 2 deletions(-)

--- linux.orig/fs/read_write.c	2010-02-02 21:58:08.000000000 +0800
+++ linux/fs/read_write.c	2010-02-07 11:18:07.000000000 +0800
@@ -205,6 +205,20 @@ bad:
 }
 #endif
 
+static int
+__negative_fpos_check(struct file *file, loff_t pos, size_t count)
+{
+	/*
+	 * pos or pos+count is negative here, check overflow.
+	 * too big "count" will be caught in rw_verify_area().
+	 */
+	if ((pos < 0) && (pos + count < pos))
+		return -EOVERFLOW;
+	if (file->f_mode & FMODE_NEG_OFFSET)
+		return 0;
+	return -EINVAL;
+}
+
 /*
  * rw_verify_area doesn't like huge counts. We limit
  * them to something that fits in "int" so that others
@@ -222,8 +236,11 @@ int rw_verify_area(int read_write, struc
 	if (unlikely((ssize_t) count < 0))
 		return retval;
 	pos = *ppos;
-	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0))
-		return retval;
+	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0)) {
+		retval = __negative_fpos_check(file, pos, count);
+		if (retval)
+			return retval;
+	}
 
 	if (unlikely(inode->i_flock && mandatory_lock(inode))) {
 		retval = locks_mandatory_area(
--- linux.orig/include/linux/fs.h	2010-02-07 11:17:04.000000000 +0800
+++ linux/include/linux/fs.h	2010-02-07 11:18:07.000000000 +0800
@@ -90,6 +90,9 @@ struct inodes_stat_t {
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
 
+/* File is huge (eg. /dev/kmem): treat loff_t as unsigned */
+#define FMODE_NEG_OFFSET	((__force fmode_t)0x2000)
+
 /*
  * The below are the various read and write types that we support. Some of
  * them include behavioral modifiers that send information down to the
--- linux.orig/drivers/char/mem.c	2010-01-30 17:39:15.000000000 +0800
+++ linux/drivers/char/mem.c	2010-02-07 11:18:07.000000000 +0800
@@ -861,6 +861,10 @@ static int memory_open(struct inode *ino
 	if (dev->dev_info)
 		filp->f_mapping->backing_dev_info = dev->dev_info;
 
+	/* Is /dev/mem or /dev/kmem ? */
+	if (dev->dev_info == &directly_mappable_cdev_bdi)
+		filp->f_mode |= FMODE_NEG_OFFSET;
+
 	if (dev->fops->open)
 		return dev->fops->open(inode, filp);
 
--- linux.orig/fs/proc/base.c	2010-01-30 17:39:15.000000000 +0800
+++ linux/fs/proc/base.c	2010-02-07 11:18:08.000000000 +0800
@@ -861,6 +861,8 @@ static const struct file_operations proc
 static int mem_open(struct inode* inode, struct file* file)
 {
 	file->private_data = (void*)((long)current->self_exec_id);
+	/* OK to pass negative loff_t, we can catch out-of-range */
+	file->f_mode |= FMODE_NEG_OFFSET;
 	return 0;
 }
 


