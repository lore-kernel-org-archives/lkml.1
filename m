Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab0AOBtk (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666Ab0AOBti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:49:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:36228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab0AOBte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:49:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,279,1262592000"; 
   d="scan'208";a="587305634"
Message-Id: <20100115014422.959401729@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Jan 2010 09:40:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
CC: Eric Paris <eparis@redhat.com>
CC: Nick Piggin <npiggin@suse.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: David Howells <dhowells@redhat.com>
CC: Jonathan Corbet <corbet@lwn.net>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 6/6] vfs: introduce FMODE_NEG_OFFSET for allowing negative f_pos
References: <20100115013954.311049665@intel.com>
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

--- linux.orig/fs/read_write.c	2010-01-14 21:28:00.000000000 +0800
+++ linux/fs/read_write.c	2010-01-14 21:30:41.000000000 +0800
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
--- linux.orig/include/linux/fs.h	2010-01-14 21:28:00.000000000 +0800
+++ linux/include/linux/fs.h	2010-01-14 21:32:24.000000000 +0800
@@ -93,6 +93,9 @@ struct inodes_stat_t {
 /* Expect random access pattern */
 #define FMODE_RANDOM		((__force fmode_t)0x1000)
 
+/* File is huge (eg. /dev/kmem): treat loff_t as unsigned */
+#define FMODE_NEG_OFFSET	((__force fmode_t)0x2000)
+
 /*
  * The below are the various read and write types that we support. Some of
  * them include behavioral modifiers that send information down to the
--- linux.orig/drivers/char/mem.c	2010-01-14 21:28:00.000000000 +0800
+++ linux/drivers/char/mem.c	2010-01-14 21:33:20.000000000 +0800
@@ -861,6 +861,10 @@ static int memory_open(struct inode *ino
 	if (dev->dev_info)
 		filp->f_mapping->backing_dev_info = dev->dev_info;
 
+	/* Is /dev/mem or /dev/kmem ? */
+	if (dev->dev_info == &directly_mappable_cdev_bdi)
+		filp->f_mode |= FMODE_NEG_OFFSET;
+
 	if (dev->fops->open)
 		return dev->fops->open(inode, filp);
 
--- linux.orig/fs/proc/base.c	2010-01-14 21:28:00.000000000 +0800
+++ linux/fs/proc/base.c	2010-01-14 21:37:08.000000000 +0800
@@ -861,6 +861,8 @@ static const struct file_operations proc
 static int mem_open(struct inode* inode, struct file* file)
 {
 	file->private_data = (void*)((long)current->self_exec_id);
+	/* OK to pass negative loff_t, we can catch out-of-range */
+	file->f_mode |= FMODE_NEG_OFFSET;
 	return 0;
 }
 


