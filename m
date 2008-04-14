Return-Path: <linux-kernel-owner+w=401wt.eu-S932975AbYDNSUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975AbYDNSUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765334AbYDNSPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:15:34 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:57123 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762493AbYDNSPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:15:32 -0400
Date: Mon, 14 Apr 2008 21:14:26 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] minix: remove !NO_TRUNCATE code
Message-ID: <20080414181426.GS6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the !NO_TRUNCATE code that anyway required a manual 
editing of the code for being used.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008
- 27 Feb 2008
- 17 Feb 2008

 fs/minix/inode.c |    3 ---
 fs/minix/minix.h |    6 ------
 fs/minix/namei.c |   24 ------------------------
 3 files changed, 33 deletions(-)

baff7307cff10a969567e2c7b81af14259170906 diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 84f6242..523d737 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -256,9 +256,6 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
 	if (!s->s_root)
 		goto out_iput;
 
-	if (!NO_TRUNCATE)
-		s->s_root->d_op = &minix_dentry_operations;
-
 	if (!(s->s_flags & MS_RDONLY)) {
 		if (sbi->s_version != MINIX_V3) /* s_state is now out from V3 sb */
 			ms->s_state &= ~MINIX_VALID_FS;
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index 326edfe..e6a0b19 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -2,11 +2,6 @@
 #include <linux/pagemap.h>
 #include <linux/minix_fs.h>
 
-/*
- * change the define below to 0 if you want names > info->s_namelen chars to be
- * truncated. Else they will be disallowed (ENAMETOOLONG).
- */
-#define NO_TRUNCATE 1
 #define INODE_VERSION(inode)	minix_sb(inode->i_sb)->s_version
 #define MINIX_V1		0x0001		/* original minix fs */
 #define MINIX_V2		0x0002		/* minix V2 fs */
@@ -83,7 +78,6 @@ extern const struct inode_operations minix_file_inode_operations;
 extern const struct inode_operations minix_dir_inode_operations;
 extern const struct file_operations minix_file_operations;
 extern const struct file_operations minix_dir_operations;
-extern struct dentry_operations minix_dentry_operations;
 
 static inline struct minix_sb_info *minix_sb(struct super_block *sb)
 {
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index 102241b..32b131c 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -18,30 +18,6 @@ static int add_nondir(struct dentry *dentry, struct inode *inode)
 	return err;
 }
 
-static int minix_hash(struct dentry *dentry, struct qstr *qstr)
-{
-	unsigned long hash;
-	int i;
-	const unsigned char *name;
-
-	i = minix_sb(dentry->d_inode->i_sb)->s_namelen;
-	if (i >= qstr->len)
-		return 0;
-	/* Truncate the name in place, avoids having to define a compare
-	   function. */
-	qstr->len = i;
-	name = qstr->name;
-	hash = init_name_hash();
-	while (i--)
-		hash = partial_name_hash(*name++, hash);
-	qstr->hash = end_name_hash(hash);
-	return 0;
-}
-
-struct dentry_operations minix_dentry_operations = {
-	.d_hash		= minix_hash,
-};
-
 static struct dentry *minix_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode * inode = NULL;

