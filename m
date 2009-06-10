Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbZFJKlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbZFJKlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 06:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbZFJKls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 06:41:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44752 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbZFJKlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 06:41:47 -0400
Subject: GFS2: Merge gfs2_get_sb into gfs2_get_sb_meta
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <20090610095319.GC25527@infradead.org>
References: <1244622665-7470-15-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-16-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-17-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-18-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-19-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-20-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-21-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-22-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-23-git-send-email-swhiteho@redhat.com>
	 <1244622665-7470-24-git-send-email-swhiteho@redhat.com>
	 <20090610095319.GC25527@infradead.org>
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Wed, 10 Jun 2009 11:43:59 +0100
Message-Id: <1244630639.3355.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 003dec8913d6bebb4ecc989ec04a235cf38f5ea9 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 10 Jun 2009 10:31:45 +0100
Subject: [PATCH] GFS2: Merge gfs2_get_sb into gfs2_get_sb_meta

These don't need to be separate functions.

Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 9da161c..f234aba 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1284,9 +1284,11 @@ static int set_meta_super(struct super_block *s, void *ptr)
 	return -EINVAL;
 }
 
-static struct super_block *get_gfs2_sb(const char *dev_name)
+static int gfs2_get_sb_meta(struct file_system_type *fs_type, int flags,
+			    const char *dev_name, void *data, struct vfsmount *mnt)
 {
 	struct super_block *s;
+	struct gfs2_sbd *sdp;
 	struct path path;
 	int error;
 
@@ -1294,21 +1296,11 @@ static struct super_block *get_gfs2_sb(const char *dev_name)
 	if (error) {
 		printk(KERN_WARNING "GFS2: path_lookup on %s returned error %d\n",
 		       dev_name, error);
-		return ERR_PTR(-ENOENT);
+		return error;
 	}
 	s = sget(&gfs2_fs_type, test_meta_super, set_meta_super,
 		 path.dentry->d_inode->i_sb->s_bdev);
 	path_put(&path);
-	return s;
-}
-
-static int gfs2_get_sb_meta(struct file_system_type *fs_type, int flags,
-			    const char *dev_name, void *data, struct vfsmount *mnt)
-{
-	struct super_block *s;
-	struct gfs2_sbd *sdp;
-
-	s = get_gfs2_sb(dev_name);
 	if (IS_ERR(s)) {
 		printk(KERN_WARNING "GFS2: gfs2 mount does not exist\n");
 		return PTR_ERR(s);
-- 
1.6.0.6



