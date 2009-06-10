Return-Path: <linux-kernel-owner+w=401wt.eu-S1759721AbZFJJoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721AbZFJJoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758854AbZFJJik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40356 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758260AbZFJJid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:33 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 23/24] GFS2: Fix locking issue mounting gfs2meta fs
Date: Wed, 10 Jun 2009 09:31:04 +0100
Message-Id: <1244622665-7470-24-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-23-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-7-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-8-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-9-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-10-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-11-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-12-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-13-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-14-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-15-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-16-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-17-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-18-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-19-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-20-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-21-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-22-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-23-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses sget() to get a reference to the
existing gfs2 sb when mouting the gfs2meta filesystem
(in fact thats just another mount of the gfs2
filesystem with a different root and this interface
is for backward compatibility).

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reported-by: Benjamin Marzinski <bmarzins@redhat.com>
Tested-by: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 2cd1164..9da161c 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1273,9 +1273,20 @@ static int gfs2_get_sb(struct file_system_type *fs_type, int flags,
 	return get_sb_bdev(fs_type, flags, dev_name, data, fill_super, mnt);
 }
 
+static int test_meta_super(struct super_block *s, void *ptr)
+{
+	struct block_device *bdev = ptr;
+	return (bdev == s->s_bdev);
+}
+
+static int set_meta_super(struct super_block *s, void *ptr)
+{
+	return -EINVAL;
+}
+
 static struct super_block *get_gfs2_sb(const char *dev_name)
 {
-	struct super_block *sb;
+	struct super_block *s;
 	struct path path;
 	int error;
 
@@ -1283,30 +1294,27 @@ static struct super_block *get_gfs2_sb(const char *dev_name)
 	if (error) {
 		printk(KERN_WARNING "GFS2: path_lookup on %s returned error %d\n",
 		       dev_name, error);
-		return NULL;
+		return ERR_PTR(-ENOENT);
 	}
-	sb = path.dentry->d_inode->i_sb;
-	if (sb && (sb->s_type == &gfs2_fs_type))
-		atomic_inc(&sb->s_active);
-	else
-		sb = NULL;
+	s = sget(&gfs2_fs_type, test_meta_super, set_meta_super,
+		 path.dentry->d_inode->i_sb->s_bdev);
 	path_put(&path);
-	return sb;
+	return s;
 }
 
 static int gfs2_get_sb_meta(struct file_system_type *fs_type, int flags,
 			    const char *dev_name, void *data, struct vfsmount *mnt)
 {
-	struct super_block *sb = NULL;
+	struct super_block *s;
 	struct gfs2_sbd *sdp;
 
-	sb = get_gfs2_sb(dev_name);
-	if (!sb) {
+	s = get_gfs2_sb(dev_name);
+	if (IS_ERR(s)) {
 		printk(KERN_WARNING "GFS2: gfs2 mount does not exist\n");
-		return -ENOENT;
+		return PTR_ERR(s);
 	}
-	sdp = sb->s_fs_info;
-	mnt->mnt_sb = sb;
+	sdp = s->s_fs_info;
+	mnt->mnt_sb = s;
 	mnt->mnt_root = dget(sdp->sd_master_dir);
 	return 0;
 }
-- 
1.6.0.6

