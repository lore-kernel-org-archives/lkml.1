Return-Path: <linux-kernel-owner+w=401wt.eu-S1763885AbYAUKMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763885AbYAUKMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759898AbYAUKCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759828AbYAUKCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:41 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Wendy Cheng <wcheng@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 30/58] [GFS2] Remove lock methods for lock_nolock protocol
Date: Mon, 21 Jan 2008 09:21:48 +0000
Message-Id: <12009073933630-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073913676-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
 <12009073698-git-send-email-swhiteho@redhat.com>
 <12009073701982-git-send-email-swhiteho@redhat.com>
 <12009073722253-git-send-email-swhiteho@redhat.com>
 <1200907374616-git-send-email-swhiteho@redhat.com>
 <12009073753723-git-send-email-swhiteho@redhat.com>
 <12009073771883-git-send-email-swhiteho@redhat.com>
 <1200907378664-git-send-email-swhiteho@redhat.com>
 <12009073803732-git-send-email-swhiteho@redhat.com>
 <12009073823161-git-send-email-swhiteho@redhat.com>
 <12009073841692-git-send-email-swhiteho@redhat.com>
 <12009073862261-git-send-email-swhiteho@redhat.com>
 <12009073883125-git-send-email-swhiteho@redhat.com>
 <12009073891848-git-send-email-swhiteho@redhat.com>
 <12009073913676-git-send-email-swhiteho@redhat.com>
Message-Id: <227a0179e629becefe2057de1af20b1881226067.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wendy Cheng <wcheng@redhat.com>

GFS2 supports two modes of locking - lock_nolock for single node filesystem
and lock_dlm for cluster mode locking. The gfs2 lock methods are removed from
file operation table for lock_nolock protocol. This would allow VFS to handle
posix lock and flock logics just like other in-tree filesystems without
duplication.

Signed-off-by: S. Wendy Cheng <wcheng@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 92959d0..53bca99 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -131,14 +131,21 @@ static struct inode *gfs2_iget_skip(struct super_block *sb,
 
 void gfs2_set_iop(struct inode *inode)
 {
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	umode_t mode = inode->i_mode;
 
 	if (S_ISREG(mode)) {
 		inode->i_op = &gfs2_file_iops;
-		inode->i_fop = &gfs2_file_fops;
+		if (sdp->sd_args.ar_localflocks)
+			inode->i_fop = &gfs2_file_fops_nolock;
+		else
+			inode->i_fop = &gfs2_file_fops;
 	} else if (S_ISDIR(mode)) {
 		inode->i_op = &gfs2_dir_iops;
-		inode->i_fop = &gfs2_dir_fops;
+		if (sdp->sd_args.ar_localflocks)
+			inode->i_fop = &gfs2_dir_fops_nolock;
+		else
+			inode->i_fop = &gfs2_dir_fops;
 	} else if (S_ISLNK(mode)) {
 		inode->i_op = &gfs2_symlink_iops;
 	} else {
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index ad5daaa..db76ac1 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -615,15 +615,6 @@ static int gfs2_lock(struct file *file, int cmd, struct file_lock *fl)
 	if (__mandatory_lock(&ip->i_inode))
 		return -ENOLCK;
 
-	if (sdp->sd_args.ar_localflocks) {
-		if (IS_GETLK(cmd)) {
-			posix_test_lock(file, fl);
-			return 0;
-		} else {
-			return posix_lock_file_wait(file, fl);
-		}
-	}
-
 	if (cmd == F_CANCELLK) {
 		/* Hack: */
 		cmd = F_SETLK;
@@ -716,9 +707,6 @@ static int gfs2_flock(struct file *file, int cmd, struct file_lock *fl)
 	if (__mandatory_lock(&ip->i_inode))
 		return -ENOLCK;
 
-	if (sdp->sd_args.ar_localflocks)
-		return flock_lock_file_wait(file, fl);
-
 	if (fl->fl_type == F_UNLCK) {
 		do_unflock(file, fl);
 		return 0;
@@ -755,3 +743,27 @@ const struct file_operations gfs2_dir_fops = {
 	.flock		= gfs2_flock,
 };
 
+const struct file_operations gfs2_file_fops_nolock = {
+	.llseek		= gfs2_llseek,
+	.read		= do_sync_read,
+	.aio_read	= generic_file_aio_read,
+	.write		= do_sync_write,
+	.aio_write	= generic_file_aio_write,
+	.unlocked_ioctl	= gfs2_ioctl,
+	.mmap		= gfs2_mmap,
+	.open		= gfs2_open,
+	.release	= gfs2_close,
+	.fsync		= gfs2_fsync,
+	.splice_read	= generic_file_splice_read,
+	.splice_write	= generic_file_splice_write,
+	.setlease	= gfs2_setlease,
+};
+
+const struct file_operations gfs2_dir_fops_nolock = {
+	.readdir	= gfs2_readdir,
+	.unlocked_ioctl	= gfs2_ioctl,
+	.open		= gfs2_open,
+	.release	= gfs2_close,
+	.fsync		= gfs2_fsync,
+};
+
diff --git a/fs/gfs2/ops_inode.h b/fs/gfs2/ops_inode.h
index edb519c..fd8cee2 100644
--- a/fs/gfs2/ops_inode.h
+++ b/fs/gfs2/ops_inode.h
@@ -18,6 +18,8 @@ extern const struct inode_operations gfs2_symlink_iops;
 extern const struct inode_operations gfs2_dev_iops;
 extern const struct file_operations gfs2_file_fops;
 extern const struct file_operations gfs2_dir_fops;
+extern const struct file_operations gfs2_file_fops_nolock;
+extern const struct file_operations gfs2_dir_fops_nolock;
 
 extern void gfs2_set_inode_flags(struct inode *inode);
 
-- 
1.5.1.2

