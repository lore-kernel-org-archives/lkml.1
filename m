Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997Ab0AZOMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0AZOMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 09:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414Ab0AZOMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 09:12:47 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:48740 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826Ab0AZOMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 09:12:46 -0500
Subject: [PATCH] fs: re-order super_block to remove 16 bytes of padding on
 64bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Matthew Wilcox <matthew@wil.cx>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jan 2010 14:12:43 +0000
Message-ID: <1264515163.2047.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

re-order structure super_block to remove 16 bytes of alignment padding
on 64bit builds.

This shrinks the size of super_block from 712 to 696 bytes so requiring
one fewer 64 byte cache lines.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

-----
patch against 2.6.33-rc5
compiled & tested on x86_64 AMDX2 desktop machine.

I've been running with this patch applied for several weeks with no
problems.

regards
Richard
 


diff --git a/include/linux/fs.h b/include/linux/fs.h
index b1bcb27..a2f87ea 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1314,9 +1314,9 @@ extern spinlock_t sb_lock;
 struct super_block {
 	struct list_head	s_list;		/* Keep this first */
 	dev_t			s_dev;		/* search index; _not_ kdev_t */
-	unsigned long		s_blocksize;
-	unsigned char		s_blocksize_bits;
 	unsigned char		s_dirt;
+	unsigned char		s_blocksize_bits;
+	unsigned long		s_blocksize;
 	loff_t			s_maxbytes;	/* Max file size */
 	struct file_system_type	*s_type;
 	const struct super_operations	*s_op;
@@ -1357,16 +1357,16 @@ struct super_block {
 	void 			*s_fs_info;	/* Filesystem private info */
 	fmode_t			s_mode;
 
+	/* Granularity of c/m/atime in ns.
+	   Cannot be worse than a second */
+	u32		   s_time_gran;
+
 	/*
 	 * The next field is for VFS *only*. No filesystems have any business
 	 * even looking at it. You had been warned.
 	 */
 	struct mutex s_vfs_rename_mutex;	/* Kludge */
 
-	/* Granularity of c/m/atime in ns.
-	   Cannot be worse than a second */
-	u32		   s_time_gran;
-
 	/*
 	 * Filesystem subtype.  If non-empty the filesystem type field
 	 * in /proc/mounts will be "type.subtype"


