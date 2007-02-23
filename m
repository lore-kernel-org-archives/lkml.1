Return-Path: <linux-kernel-owner+w=401wt.eu-S932137AbXBWLaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbXBWLaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932162AbXBWLaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:30:55 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:51996 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137AbXBWLax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:30:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=heyzJdHFMTFPwcN8YtpS5/eJUcJMKO/lS7KkZigTjLTFCmDTxr6IWWnCc7zscDbWk+avN+P3mWiJYlXgJSdsJYm1lKBEcRvWSAYswe+Zqrjzbew+xjSBEYoG5ggD+M7tK9bsoPyz1fmKODz5SNufz2uz//uIFmqoryI5keI0VJA=
Date: Fri, 23 Feb 2007 14:31:01 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: reiserfs-dev@namesys.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] reiserfs: shrink superblock if no xattrs
Message-ID: <20070223113101.GA5527@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This makes in-core superblock fit into one cacheline here.

Before:
    struct dentry *            xattr_root;           /*   124     4 */
    /* --- cacheline 1 boundary (128 bytes) --- */
    struct rw_semaphore        xattr_dir_sem;        /*   128    12 */
    int                        j_errno;              /*   140     4 */
    }; /* size: 144, cachelines: 2 */
       /* sum members: 142, holes: 1, sum holes: 2 */
       /* last cacheline: 16 bytes */

After:
    int                        j_errno;              /*   124     4 */
    /* --- cacheline 1 boundary (128 bytes) --- */
    }; /* size: 128, cachelines: 1 */
       /* sum members: 126, holes: 1, sum holes: 2 */

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/reiserfs/super.c            |    6 ++++--
 include/linux/reiserfs_fs_sb.h |    3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -433,12 +433,13 @@ int remove_save_link(struct inode *inode
 static void reiserfs_kill_sb(struct super_block *s)
 {
 	if (REISERFS_SB(s)) {
+#ifdef CONFIG_REISERFS_FS_XATTR
 		if (REISERFS_SB(s)->xattr_root) {
 			d_invalidate(REISERFS_SB(s)->xattr_root);
 			dput(REISERFS_SB(s)->xattr_root);
 			REISERFS_SB(s)->xattr_root = NULL;
 		}
-
+#endif
 		if (REISERFS_SB(s)->priv_root) {
 			d_invalidate(REISERFS_SB(s)->priv_root);
 			dput(REISERFS_SB(s)->priv_root);
@@ -1563,9 +1564,10 @@ static int reiserfs_fill_super(struct su
 	REISERFS_SB(s)->s_alloc_options.preallocmin = 0;
 	/* Preallocate by 16 blocks (17-1) at once */
 	REISERFS_SB(s)->s_alloc_options.preallocsize = 17;
+#ifdef CONFIG_REISERFS_FS_XATTR
 	/* Initialize the rwsem for xattr dir */
 	init_rwsem(&REISERFS_SB(s)->xattr_dir_sem);
-
+#endif
 	/* setup default block allocator options */
 	reiserfs_init_alloc_options(s);
 
--- a/include/linux/reiserfs_fs_sb.h
+++ b/include/linux/reiserfs_fs_sb.h
@@ -401,9 +401,10 @@ struct reiserfs_sb_info {
 	int reserved_blocks;	/* amount of blocks reserved for further allocations */
 	spinlock_t bitmap_lock;	/* this lock on now only used to protect reserved_blocks variable */
 	struct dentry *priv_root;	/* root of /.reiserfs_priv */
+#ifdef CONFIG_REISERFS_FS_XATTR
 	struct dentry *xattr_root;	/* root of /.reiserfs_priv/.xa */
 	struct rw_semaphore xattr_dir_sem;
-
+#endif
 	int j_errno;
 #ifdef CONFIG_QUOTA
 	char *s_qf_names[MAXQUOTAS];

