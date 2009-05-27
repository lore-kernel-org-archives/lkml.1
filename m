Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbZE0BxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbZE0BxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbZE0BxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:53:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60281 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbZE0BxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:53:02 -0400
Date: Wed, 27 May 2009 11:52:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steven Whitehouse <swhiteho@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: linux-next: manual merge of the vfs tree with the gfs2 tree
Message-Id: <20090527115253.37abd576.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/gfs2/ops_super.c between commit
9e6e0a128bca0a151d8d3fbd9459b22fc21cfebb ("GFS2: Merge mount.c and
ops_super.c into super.c") from the gfs2 tree and commits
17af8f24a7750ea3d947904f97eb6dfacf9a88aa ("gfs2: remove ->write_super and
stop maintaining ->s_dirt") and 8123178eb9ca12cde31a95170746e15a79528a62
("push BKL down into ->put_super") from the vfs tree.

The former commit removed the file.  I have mechanically applied the
changes in the latter two commits to fs/gfs2/super.c (see below) and can
carry this as a merge fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 40bcc37..c8930b3 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -719,6 +719,8 @@ static void gfs2_put_super(struct super_block *sb)
 	int error;
 	struct gfs2_jdesc *jd;
 
+	lock_kernel();
+
 	/*  Unfreeze the filesystem, if we need to  */
 
 	mutex_lock(&sdp->sd_freeze_lock);
@@ -785,17 +787,8 @@ restart:
 
 	/*  At this point, we're through participating in the lockspace  */
 	gfs2_sys_fs_del(sdp);
-}
-
-/**
- * gfs2_write_super
- * @sb: the superblock
- *
- */
 
-static void gfs2_write_super(struct super_block *sb)
-{
-	sb->s_dirt = 0;
+	unlock_kernel();
 }
 
 /**
@@ -807,7 +800,6 @@ static void gfs2_write_super(struct super_block *sb)
 
 static int gfs2_sync_fs(struct super_block *sb, int wait)
 {
-	sb->s_dirt = 0;
 	if (wait && sb->s_fs_info)
 		gfs2_log_flush(sb->s_fs_info, NULL);
 	return 0;
@@ -1324,7 +1316,6 @@ const struct super_operations gfs2_super_ops = {
 	.write_inode		= gfs2_write_inode,
 	.delete_inode		= gfs2_delete_inode,
 	.put_super		= gfs2_put_super,
-	.write_super		= gfs2_write_super,
 	.sync_fs		= gfs2_sync_fs,
 	.freeze_fs 		= gfs2_freeze,
 	.unfreeze_fs		= gfs2_unfreeze,
-- 
1.6.3.1

