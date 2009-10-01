Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbZJAC23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbZJAC23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 22:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbZJAC23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 22:28:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40125 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbZJAC22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 22:28:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 1 Oct 2009 11:26:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, fengguang.wu@intel.com,
       hugh.dickins@tiscali.co.uk, viro@zeniv.linux.org.uk
Subject: [PATCH] a fix for too big f_pos handling
Message-Id: <20091001112616.970931bb.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe there are several ways to handle this...this is an idea.

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, rw_verify_area() checsk f_pos is negative or not. And if
negative, returns -EINVAL.

But, some special files as /dev/(k)mem and /proc/<pid>/mem etc..
has negative offsets. And we can't do any access via read/write
to the file(device).

This patch introduce a flag S_VERYBIG and allow negative file
offsets.

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

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 drivers/char/mem.c |    3 +++
 fs/proc/base.c     |    2 ++
 fs/read_write.c    |   22 ++++++++++++++++++++--
 include/linux/fs.h |    2 ++
 4 files changed, 27 insertions(+), 2 deletions(-)

Index: linux-2.6.32-rc1/fs/read_write.c
===================================================================
--- linux-2.6.32-rc1.orig/fs/read_write.c
+++ linux-2.6.32-rc1/fs/read_write.c
@@ -205,6 +205,21 @@ bad:
 }
 #endif
 
+static int
+__negative_fpos_check(struct inode *inode, loff_t pos, size_t count)
+{
+	/*
+	 * pos or pos+count is negative here, check overflow.
+	 * too big "count" will be caught in rw_verify_area().
+	 */
+	if ((pos < 0) && (pos + count < pos))
+		return -EOVERFLOW;
+	/* If !VERYBIG inode, negative pos(pos+count) is not allowed */
+	if (!IS_VERYBIG(inode))
+		return -EINVAL;
+	return 0;
+}
+
 /*
  * rw_verify_area doesn't like huge counts. We limit
  * them to something that fits in "int" so that others
@@ -222,8 +237,11 @@ int rw_verify_area(int read_write, struc
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
Index: linux-2.6.32-rc1/include/linux/fs.h
===================================================================
--- linux-2.6.32-rc1.orig/include/linux/fs.h
+++ linux-2.6.32-rc1/include/linux/fs.h
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
Index: linux-2.6.32-rc1/drivers/char/mem.c
===================================================================
--- linux-2.6.32-rc1.orig/drivers/char/mem.c
+++ linux-2.6.32-rc1/drivers/char/mem.c
@@ -912,6 +912,9 @@ static int memory_open(struct inode *ino
 		ret = dev->fops->open(inode, filp);
 	else
 		ret = 0;
+	/* Is /dev/mem or /dev/kmem ? */
+	if (dev->dev_info == &directly_mappable_cdev_bdi)
+		inode->i_flags |= S_VERYBIG;
 out:
 	unlock_kernel();
 	return ret;
Index: linux-2.6.32-rc1/fs/proc/base.c
===================================================================
--- linux-2.6.32-rc1.orig/fs/proc/base.c
+++ linux-2.6.32-rc1/fs/proc/base.c
@@ -778,6 +778,8 @@ static const struct file_operations proc
 static int mem_open(struct inode* inode, struct file* file)
 {
 	file->private_data = (void*)((long)current->self_exec_id);
+	/* this file is read only and we can catch out-pf-range */
+	inode->i_flags |= S_VERYBIG;
 	return 0;
 }
 

