Return-Path: <linux-kernel-owner+w=401wt.eu-S1161703AbXEAKYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161703AbXEAKYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161698AbXEAKYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:24:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161703AbXEAKYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:24:41 -0400
Subject: [GFS2] lockdump improvements [26/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Robert Peterson <rpeterso@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:20:07 +0100
Message-Id: <1178014808.5462.182.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5f8820960cf4fb621483d4a37c24939ad831bfe7 Mon Sep 17 00:00:00 2001
From: Robert Peterson <rpeterso@redhat.com>
Date: Wed, 18 Apr 2007 11:41:11 -0500
Subject: [PATCH] [GFS2] lockdump improvements

The patch below consists of the following changes (in code order):

1. I fixed a minor compiler warning regarding the printing of
   a kernel symbol address.
2. I implemented a suggestion from Dave Teigland that moves
   the debugfs information for gfs2 into a subdirectory so
   we can easily expand our use of debugfs in the future.
   The current code keeps the glock information in:
   /debug/gfs2/<fs>
   With the patch, the new code keeps the glock information in:
   /debug/gfs2/<fs>/glock
   That will allow us to create more debugfs files in the future.
3. This fixes a bug whereby a failed mount attempt causes the
   debugfs file to not be deleted.  Failed mount attempts should
   always clean up after themselves, including deleting the
   debugfs file and/or directory.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index b075f93..7988715 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1774,7 +1774,7 @@ static void gfs2_print_symbol(struct glock_iter *gi, const char *fmt,
 
 	if (gi) {
 		memset(buffer, 0, sizeof(buffer));
-		sprintf(buffer, "%p", address);
+		sprintf(buffer, "0x%08lx", address);
 		print_dbg(gi, fmt, buffer);
 	}
 	else
@@ -2146,11 +2146,14 @@ static const struct file_operations gfs2_debug_fops = {
 
 int gfs2_create_debugfs_file(struct gfs2_sbd *sdp)
 {
-	sdp->debugfs_dentry = debugfs_create_file(sdp->sd_table_name,
-						  S_IFREG | S_IRUGO,
-						  gfs2_root, sdp,
-						  &gfs2_debug_fops);
-	if (!sdp->debugfs_dentry)
+	sdp->debugfs_dir = debugfs_create_dir(sdp->sd_table_name, gfs2_root);
+	if (!sdp->debugfs_dir)
+		return -ENOMEM;
+	sdp->debugfs_dentry_glocks = debugfs_create_file("glocks",
+							 S_IFREG | S_IRUGO,
+							 sdp->debugfs_dir, sdp,
+							 &gfs2_debug_fops);
+	if (!sdp->debugfs_dentry_glocks)
 		return -ENOMEM;
 
 	return 0;
@@ -2158,8 +2161,14 @@ int gfs2_create_debugfs_file(struct gfs2_sbd *sdp)
 
 void gfs2_delete_debugfs_file(struct gfs2_sbd *sdp)
 {
-	if (sdp && sdp->debugfs_dentry)
-		debugfs_remove(sdp->debugfs_dentry);
+	if (sdp && sdp->debugfs_dir) {
+		if (sdp->debugfs_dentry_glocks) {
+			debugfs_remove(sdp->debugfs_dentry_glocks);
+			sdp->debugfs_dentry_glocks = NULL;
+		}
+		debugfs_remove(sdp->debugfs_dir);
+		sdp->debugfs_dir = NULL;
+	}
 }
 
 int gfs2_register_debugfs(void)
@@ -2171,4 +2180,5 @@ int gfs2_register_debugfs(void)
 void gfs2_unregister_debugfs(void)
 {
 	debugfs_remove(gfs2_root);
+	gfs2_root = NULL;
 }
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index fdf0470..d995441 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -609,7 +609,8 @@ struct gfs2_sbd {
 
 	unsigned long sd_last_warning;
 	struct vfsmount *sd_gfs2mnt;
-	struct dentry *debugfs_dentry; /* for debugfs */
+	struct dentry *debugfs_dir;    /* debugfs directory */
+	struct dentry *debugfs_dentry_glocks; /* for debugfs */
 };
 
 #endif /* __INCORE_DOT_H__ */
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index ecb8b18..2c5f8e7 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -756,6 +756,7 @@ fail_lm:
 fail_sys:
 	gfs2_sys_fs_del(sdp);
 fail:
+	gfs2_delete_debugfs_file(sdp);
 	kfree(sdp);
 	sb->s_fs_info = NULL;
 	return error;
-- 
1.5.1.2



