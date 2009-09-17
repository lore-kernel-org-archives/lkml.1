Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZIQGJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZIQGJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 02:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZIQGJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 02:09:34 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49712 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbZIQGJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 02:09:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 17 Sep 2009 15:07:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, viro@zeniv.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       oleg@redhat.com, xiyou.wangcong@gmail.com
Subject: [RFC][PATCH][bugfix] more checks for negative f_pos handling v3
Message-Id: <20090917150726.9acb0f40.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090917145319.97f67737.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090914032901.GA16189@localhost>
	<20090915165852.032d164f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090916142956.9998ba71.kamezawa.hiroyu@jp.fujitsu.com>
	<20090917145319.97f67737.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very sorry...reflesh miss.
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, rw_verify_area() checsk f_pos is negative or not. And if
negative, returns -EINVAL.

But, some special files as /dev/(k)mem and /proc/<pid>/mem etc..
has negative offsets. And we can't do any access via read/write
to the file(device).

This patch introduce a flag S_VERYBIG and allow negative file
offsets.

Changelog:
 - fixed bug in rw_verify_area (it cannot be compiled)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 drivers/char/mem.c |   23 +++++++++++++----------
 fs/proc/base.c     |    2 ++
 fs/read_write.c    |   20 ++++++++++++++++++--
 include/linux/fs.h |    2 ++
 4 files changed, 35 insertions(+), 12 deletions(-)

Index: mmotm-2.6.31-Sep14/fs/read_write.c
===================================================================
--- mmotm-2.6.31-Sep14.orig/fs/read_write.c
+++ mmotm-2.6.31-Sep14/fs/read_write.c
@@ -205,6 +205,16 @@ bad:
 }
 #endif
 
+static bool
+__negative_fpos_check(struct inode *inode, loff_t pos, size_t count)
+{
+	if (pos + count < pos)
+		return -EOVERFLOW;
+	if (IS_VERYBIG(inode))
+		return 0;
+	return -EINVAL;
+}
+
 /*
  * rw_verify_area doesn't like huge counts. We limit
  * them to something that fits in "int" so that others
@@ -222,8 +232,11 @@ int rw_verify_area(int read_write, struc
 	if (unlikely((ssize_t) count < 0))
 		return retval;
 	pos = *ppos;
-	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0))
-		return retval;
+	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0)) {
+		retval = __negative_fpos_check(inode, pos, count);
+		if (retval)
+			return retval;
+	}
 
 	if (unlikely(inode->i_flock && mandatory_lock(inode))) {
 		retval = locks_mandatory_area(
Index: mmotm-2.6.31-Sep14/include/linux/fs.h
===================================================================
--- mmotm-2.6.31-Sep14.orig/include/linux/fs.h
+++ mmotm-2.6.31-Sep14/include/linux/fs.h
@@ -231,6 +231,7 @@ struct inodes_stat_t {
 #define S_NOCMTIME	128	/* Do not update file c/mtime */
 #define S_SWAPFILE	256	/* Do not truncate: swapon got its bmaps */
 #define S_PRIVATE	512	/* Inode is fs-internal */
+#define S_VERYBIG	1024	/* Allow file's loff_t can be negative */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
@@ -265,6 +266,7 @@ struct inodes_stat_t {
 #define IS_NOCMTIME(inode)	((inode)->i_flags & S_NOCMTIME)
 #define IS_SWAPFILE(inode)	((inode)->i_flags & S_SWAPFILE)
 #define IS_PRIVATE(inode)	((inode)->i_flags & S_PRIVATE)
+#define IS_VERYBIG(inode)	((inode)->i_flags & S_VERYBIG)
 
 /* the read-only stuff doesn't really belong here, but any other place is
    probably as bad and I don't want to create yet another include file. */
Index: mmotm-2.6.31-Sep14/drivers/char/mem.c
===================================================================
--- mmotm-2.6.31-Sep14.orig/drivers/char/mem.c
+++ mmotm-2.6.31-Sep14/drivers/char/mem.c
@@ -825,22 +825,23 @@ static const struct memdev {
 	const char *name;
 	const struct file_operations *fops;
 	struct backing_dev_info *dev_info;
+	bool	verybig;
 } devlist[] = {
-	[ 1] = { "mem", &mem_fops, &directly_mappable_cdev_bdi },
+	[1] = { "mem", &mem_fops, &directly_mappable_cdev_bdi, true },
 #ifdef CONFIG_DEVKMEM
-	[ 2] = { "kmem", &kmem_fops, &directly_mappable_cdev_bdi },
+	[2] = { "kmem", &kmem_fops, &directly_mappable_cdev_bdi, true },
 #endif
-	[ 3] = {"null", &null_fops, NULL },
+	[3] = {"null", &null_fops, NULL, false },
 #ifdef CONFIG_DEVPORT
-	[ 4] = { "port", &port_fops, NULL },
+	[4] = { "port", &port_fops, NULL, false },
 #endif
-	[ 5] = { "zero", &zero_fops, &zero_bdi },
-	[ 6] = { "full", &full_fops, NULL },
-	[ 7] = { "random", &random_fops, NULL },
-	[ 9] = { "urandom", &urandom_fops, NULL },
-	[11] = { "kmsg", &kmsg_fops, NULL },
+	[5] = { "zero", &zero_fops, &zero_bdi, false },
+	[6] = { "full", &full_fops, NULL, false },
+	[7] = { "random", &random_fops, NULL, false },
+	[9] = { "urandom", &urandom_fops, NULL, false },
+	[11] = { "kmsg", &kmsg_fops, NULL, false },
 #ifdef CONFIG_CRASH_DUMP
-	[12] = { "oldmem", &oldmem_fops, NULL },
+	[12] = { "oldmem", &oldmem_fops, NULL, false },
 #endif
 };
 
@@ -868,6 +869,8 @@ static int memory_open(struct inode *ino
 		ret = dev->fops->open(inode, filp);
 	else
 		ret = 0;
+	if (dev->verybig)
+		inode->i_flags |= S_VERYBIG;
 out:
 	unlock_kernel();
 	return ret;
Index: mmotm-2.6.31-Sep14/fs/proc/base.c
===================================================================
--- mmotm-2.6.31-Sep14.orig/fs/proc/base.c
+++ mmotm-2.6.31-Sep14/fs/proc/base.c
@@ -779,6 +779,8 @@ static const struct file_operations proc
 static int mem_open(struct inode* inode, struct file* file)
 {
 	file->private_data = (void*)((long)current->self_exec_id);
+	/* this file is read only and we can catch out-pf-range */
+	inode->i_flags |= S_VERYBIG;
 	return 0;
 }
 

