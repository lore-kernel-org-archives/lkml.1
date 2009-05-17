Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbZEQFGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbZEQFGQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 01:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbZEQFEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 01:04:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbZEQFEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 01:04:36 -0400
Message-Id: <20090517050331.993181046@suse.com>
User-Agent: quilt/0.47-14.9
Date: Sun, 17 May 2009 01:02:02 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: [patch 2/4] [PATCH] reiserfs: deal with NULL xattr root w/ xattrs disabled
References: <20090517050200.786752018@suse.com>
Content-Disposition: inline; filename=patches.fixes/reiserfs-xattr-root-fixup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch avoids an Oops in open_xa_root that can occur when deleting a
 file with xattrs disabled. It assumes that the xattr root will be there,
 and that is not guaranteed.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/reiserfs/super.c |    2 --
 fs/reiserfs/xattr.c |    4 +++-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -448,13 +448,11 @@ int remove_save_link(struct inode *inode
 static void reiserfs_kill_sb(struct super_block *s)
 {
 	if (REISERFS_SB(s)) {
-#ifdef CONFIG_REISERFS_FS_XATTR
 		if (REISERFS_SB(s)->xattr_root) {
 			d_invalidate(REISERFS_SB(s)->xattr_root);
 			dput(REISERFS_SB(s)->xattr_root);
 			REISERFS_SB(s)->xattr_root = NULL;
 		}
-#endif
 		if (REISERFS_SB(s)->priv_root) {
 			d_invalidate(REISERFS_SB(s)->priv_root);
 			dput(REISERFS_SB(s)->priv_root);
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -123,7 +123,9 @@ static struct dentry *open_xa_root(struc
 	mutex_lock_nested(&privroot->d_inode->i_mutex, I_MUTEX_XATTR);
 
 	xaroot = dget(REISERFS_SB(sb)->xattr_root);
-	if (!xaroot->d_inode) {
+	if (!xaroot)
+		xaroot = ERR_PTR(-ENODATA);
+	else if (!xaroot->d_inode) {
 		int err = -ENODATA;
 		if (xattr_may_create(flags))
 			err = xattr_mkdir(privroot->d_inode, xaroot, 0700);

