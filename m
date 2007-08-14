Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbXHNKSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbXHNKSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757328AbXHNKK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:10:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553AbXHNKKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:10:55 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Fix setting of inherit jdata attr
Date: Tue, 14 Aug 2007 10:47:15 +0100
Message-Id: <11870848603351-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11870848365-git-send-email-swhiteho@redhat.com>
References: <11870848365-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Due to a mix up between the jdata attribute and inherit jdata attribute
it has not been possible to set the inherit jdata attribute on
directories. This is now fixed and the ioctl will report the inherit
jdata attribute for directories rather than the jdata attribute as it
did previously. This stems from our need to have the one bit in the
ioctl attr flags mean two different things according to whether the
underlying inode is a directory or not.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index 7734211..94d76ac 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -177,8 +177,8 @@ static const u32 fsflags_to_gfs2[32] = {
 	[5] = GFS2_DIF_APPENDONLY,
 	[7] = GFS2_DIF_NOATIME,
 	[12] = GFS2_DIF_EXHASH,
-	[14] = GFS2_DIF_JDATA,
-	[20] = GFS2_DIF_DIRECTIO,
+	[14] = GFS2_DIF_INHERIT_JDATA,
+	[20] = GFS2_DIF_INHERIT_DIRECTIO,
 };
 
 static const u32 gfs2_to_fsflags[32] = {
@@ -187,8 +187,6 @@ static const u32 gfs2_to_fsflags[32] = {
 	[gfs2fl_AppendOnly] = FS_APPEND_FL,
 	[gfs2fl_NoAtime] = FS_NOATIME_FL,
 	[gfs2fl_ExHash] = FS_INDEX_FL,
-	[gfs2fl_Jdata] = FS_JOURNAL_DATA_FL,
-	[gfs2fl_Directio] = FS_DIRECTIO_FL,
 	[gfs2fl_InheritDirectio] = FS_DIRECTIO_FL,
 	[gfs2fl_InheritJdata] = FS_JOURNAL_DATA_FL,
 };
@@ -207,6 +205,12 @@ static int gfs2_get_flags(struct file *filp, u32 __user *ptr)
 		return error;
 
 	fsflags = fsflags_cvt(gfs2_to_fsflags, ip->i_di.di_flags);
+	if (!S_ISDIR(inode->i_mode)) {
+		if (ip->i_di.di_flags & GFS2_DIF_JDATA)
+			fsflags |= FS_JOURNAL_DATA_FL;
+		if (ip->i_di.di_flags & GFS2_DIF_DIRECTIO)
+			fsflags |= FS_DIRECTIO_FL;
+	}
 	if (put_user(fsflags, ptr))
 		error = -EFAULT;
 
@@ -270,13 +274,6 @@ static int do_gfs2_set_flags(struct file *filp, u32 reqflags, u32 mask)
 	if ((new_flags ^ flags) == 0)
 		goto out;
 
-	if (S_ISDIR(inode->i_mode)) {
-		if ((new_flags ^ flags) & GFS2_DIF_JDATA)
-			new_flags ^= (GFS2_DIF_JDATA|GFS2_DIF_INHERIT_JDATA);
-		if ((new_flags ^ flags) & GFS2_DIF_DIRECTIO)
-			new_flags ^= (GFS2_DIF_DIRECTIO|GFS2_DIF_INHERIT_DIRECTIO);
-	}
-
 	error = -EINVAL;
 	if ((new_flags ^ flags) & ~GFS2_FLAGS_USER_SET)
 		goto out;
@@ -315,11 +312,19 @@ out:
 
 static int gfs2_set_flags(struct file *filp, u32 __user *ptr)
 {
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	u32 fsflags, gfsflags;
 	if (get_user(fsflags, ptr))
 		return -EFAULT;
 	gfsflags = fsflags_cvt(fsflags_to_gfs2, fsflags);
-	return do_gfs2_set_flags(filp, gfsflags, ~0);
+	if (!S_ISDIR(inode->i_mode)) {
+		if (gfsflags & GFS2_DIF_INHERIT_JDATA)
+			gfsflags ^= (GFS2_DIF_JDATA | GFS2_DIF_INHERIT_JDATA);
+		if (gfsflags & GFS2_DIF_INHERIT_DIRECTIO)
+			gfsflags ^= (GFS2_DIF_DIRECTIO | GFS2_DIF_INHERIT_DIRECTIO);
+		return do_gfs2_set_flags(filp, gfsflags, ~0);
+	}
+	return do_gfs2_set_flags(filp, gfsflags, ~GFS2_DIF_JDATA);
 }
 
 static long gfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
-- 
1.5.1.2

