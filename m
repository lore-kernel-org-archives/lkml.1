Return-Path: <linux-kernel-owner+w=401wt.eu-S1030314AbXCJJ3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030314AbXCJJ3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 04:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030321AbXCJJ3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 04:29:22 -0500
Received: from mx2-2.mail.ru ([194.67.23.122]:18246 "EHLO mx2.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030314AbXCJJ3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 04:29:21 -0500
Date: Sat, 10 Mar 2007 12:30:02 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: bjoern@j3e.de, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/4]: ufs2 more correct work with time
Message-ID: <20070310093002.GA757@rain>
Mail-Followup-To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	bjoern@j3e.de, linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects work with time in UFS2 case.

1)According to UFS2 disk layout modification/access and so on "time"
should be hold in two variables one 64bit for seconds and another
32bit for nanoseconds,

at now for some unknown reason we suppose
that "inode time" holds in three variables 32bit for seconds, 32bit for
milliseconds and 32bit for nanoseconds.

2)We set amount of nanoseconds in "VFS inode" to 0 during read, instead
of getting values from "on disk inode"(this should close
http://bugzilla.kernel.org/show_bug.cgi?id=7991).

Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Björn Jacke<bjoern@j3e.de>

---

Index: linux-2.6.21-rc3-git6/fs/ufs/inode.c
===================================================================
--- linux-2.6.21-rc3-git6.orig/fs/ufs/inode.c
+++ linux-2.6.21-rc3-git6/fs/ufs/inode.c
@@ -668,12 +668,12 @@ static void ufs2_read_inode(struct inode
 	inode->i_gid = fs32_to_cpu(sb, ufs2_inode->ui_gid);
 
 	inode->i_size = fs64_to_cpu(sb, ufs2_inode->ui_size);
-	inode->i_atime.tv_sec = fs32_to_cpu(sb, ufs2_inode->ui_atime.tv_sec);
-	inode->i_ctime.tv_sec = fs32_to_cpu(sb, ufs2_inode->ui_ctime.tv_sec);
-	inode->i_mtime.tv_sec = fs32_to_cpu(sb, ufs2_inode->ui_mtime.tv_sec);
-	inode->i_mtime.tv_nsec = 0;
-	inode->i_atime.tv_nsec = 0;
-	inode->i_ctime.tv_nsec = 0;
+	inode->i_atime.tv_sec = fs64_to_cpu(sb, ufs2_inode->ui_atime);
+	inode->i_ctime.tv_sec = fs64_to_cpu(sb, ufs2_inode->ui_ctime);
+	inode->i_mtime.tv_sec = fs64_to_cpu(sb, ufs2_inode->ui_mtime);
+	inode->i_atime.tv_nsec = fs32_to_cpu(sb, ufs2_inode->ui_atimensec);
+	inode->i_ctime.tv_nsec = fs32_to_cpu(sb, ufs2_inode->ui_ctimensec);
+	inode->i_mtime.tv_nsec = fs32_to_cpu(sb, ufs2_inode->ui_mtimensec);
 	inode->i_blocks = fs64_to_cpu(sb, ufs2_inode->ui_blocks);
 	inode->i_generation = fs32_to_cpu(sb, ufs2_inode->ui_gen);
 	ufsi->i_flags = fs32_to_cpu(sb, ufs2_inode->ui_flags);
@@ -803,12 +803,12 @@ static void ufs2_update_inode(struct ino
 	ufs_inode->ui_gid = cpu_to_fs32(sb, inode->i_gid);
 
 	ufs_inode->ui_size = cpu_to_fs64(sb, inode->i_size);
-	ufs_inode->ui_atime.tv_sec = cpu_to_fs32(sb, inode->i_atime.tv_sec);
-	ufs_inode->ui_atime.tv_usec = 0;
-	ufs_inode->ui_ctime.tv_sec = cpu_to_fs32(sb, inode->i_ctime.tv_sec);
-	ufs_inode->ui_ctime.tv_usec = 0;
-	ufs_inode->ui_mtime.tv_sec = cpu_to_fs32(sb, inode->i_mtime.tv_sec);
-	ufs_inode->ui_mtime.tv_usec = 0;
+	ufs_inode->ui_atime = cpu_to_fs64(sb, inode->i_atime.tv_sec);
+	ufs_inode->ui_atimensec = cpu_to_fs32(sb, inode->i_atime.tv_nsec);
+	ufs_inode->ui_ctime = cpu_to_fs64(sb, inode->i_ctime.tv_sec);
+	ufs_inode->ui_ctimensec = cpu_to_fs32(sb, inode->i_ctime.tv_nsec);
+	ufs_inode->ui_mtime = cpu_to_fs64(sb, inode->i_mtime.tv_sec);
+	ufs_inode->ui_mtimensec = cpu_to_fs32(sb, inode->i_mtime.tv_nsec);
 
 	ufs_inode->ui_blocks = cpu_to_fs64(sb, inode->i_blocks);
 	ufs_inode->ui_flags = cpu_to_fs32(sb, ufsi->i_flags);
Index: linux-2.6.21-rc3-git6/fs/ufs/ialloc.c
===================================================================
--- linux-2.6.21-rc3-git6.orig/fs/ufs/ialloc.c
+++ linux-2.6.21-rc3-git6/fs/ufs/ialloc.c
@@ -343,9 +343,8 @@ cg_found:
 		lock_buffer(bh);
 		ufs2_inode = (struct ufs2_inode *)bh->b_data;
 		ufs2_inode += ufs_inotofsbo(inode->i_ino);
-		ufs2_inode->ui_birthtime.tv_sec =
-			cpu_to_fs32(sb, CURRENT_TIME_SEC.tv_sec);
-		ufs2_inode->ui_birthtime.tv_usec = 0;
+		ufs2_inode->ui_birthtime = cpu_to_fs64(sb, CURRENT_TIME.tv_sec);
+		ufs2_inode->ui_birthnsec = cpu_to_fs32(sb, CURRENT_TIME.tv_nsec);
 		mark_buffer_dirty(bh);
 		unlock_buffer(bh);
 		if (sb->s_flags & MS_SYNCHRONOUS)
Index: linux-2.6.21-rc3-git6/include/linux/ufs_fs.h
===================================================================
--- linux-2.6.21-rc3-git6.orig/include/linux/ufs_fs.h
+++ linux-2.6.21-rc3-git6/include/linux/ufs_fs.h
@@ -649,10 +649,10 @@ struct ufs2_inode {
 	__fs32     ui_blksize;     /*  12: Inode blocksize. */
 	__fs64     ui_size;        /*  16: File byte count. */
 	__fs64     ui_blocks;      /*  24: Bytes actually held. */
-	struct ufs_timeval   ui_atime;       /*  32: Last access time. */
-	struct ufs_timeval   ui_mtime;       /*  40: Last modified time. */
-	struct ufs_timeval   ui_ctime;       /*  48: Last inode change time. */
-	struct ufs_timeval   ui_birthtime;   /*  56: Inode creation time. */
+	__fs64   ui_atime;       /*  32: Last access time. */
+	__fs64   ui_mtime;       /*  40: Last modified time. */
+	__fs64   ui_ctime;       /*  48: Last inode change time. */
+	__fs64   ui_birthtime;   /*  56: Inode creation time. */
 	__fs32     ui_mtimensec;   /*  64: Last modified time. */
 	__fs32     ui_atimensec;   /*  68: Last access time. */
 	__fs32     ui_ctimensec;   /*  72: Last inode change time. */
-- 
/Evgeniy

