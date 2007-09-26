Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbXIZDcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbXIZDcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbXIZDbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:31:24 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35311 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259AbXIZDbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:31:22 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 17/25] Unionfs: add un/likely conditionals on lookup ops
Date: Tue, 25 Sep 2007 23:09:56 -0400
Message-Id: <1190776212879-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
References: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/lookup.c |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 2109714..92b5e0a 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -59,7 +59,7 @@ static noinline int is_opaque_dir(struct dentry *dentry, int bindex)
 
 	mutex_unlock(&lower_inode->i_mutex);
 
-	if (IS_ERR(wh_lower_dentry)) {
+	if (unlikely(IS_ERR(wh_lower_dentry))) {
 		err = PTR_ERR(wh_lower_dentry);
 		goto out;
 	}
@@ -119,12 +119,12 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 	case INTERPOSE_PARTIAL:
 		break;
 	case INTERPOSE_LOOKUP:
-		if ((err = new_dentry_private_data(dentry)))
+		if (unlikely((err = new_dentry_private_data(dentry))))
 			goto out;
 		break;
 	default:
 		/* default: can only be INTERPOSE_REVAL/REVAL_NEG */
-		if ((err = realloc_dentry_private_data(dentry)))
+		if (unlikely((err = realloc_dentry_private_data(dentry))))
 			goto out;
 		break;
 	}
@@ -147,7 +147,7 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 	namelen = dentry->d_name.len;
 
 	/* No dentries should get created for possible whiteout names. */
-	if (!is_validname(name)) {
+	if (unlikely(!is_validname(name))) {
 		err = -EPERM;
 		goto out_free;
 	}
@@ -179,7 +179,7 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 			unionfs_lower_dentry_idx(parent_dentry, bindex);
 
 		/* if the parent lower dentry does not exist skip this */
-		if (!(lower_dir_dentry && lower_dir_dentry->d_inode))
+		if (unlikely(!(lower_dir_dentry && lower_dir_dentry->d_inode)))
 			continue;
 
 		/* also skip it if the parent isn't a directory. */
@@ -189,7 +189,7 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 		/* Reuse the whiteout name because its value doesn't change. */
 		if (!whname) {
 			whname = alloc_whname(name, namelen);
-			if (IS_ERR(whname)) {
+			if (unlikely(IS_ERR(whname))) {
 				err = PTR_ERR(whname);
 				goto out_free;
 			}
@@ -198,7 +198,7 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 		/* check if whiteout exists in this branch: lookup .wh.foo */
 		wh_lower_dentry = lookup_one_len(whname, lower_dir_dentry,
 						 namelen + UNIONFS_WHLEN);
-		if (IS_ERR(wh_lower_dentry)) {
+		if (unlikely(IS_ERR(wh_lower_dentry))) {
 			dput(first_lower_dentry);
 			unionfs_mntput(first_dentry, first_dentry_offset);
 			err = PTR_ERR(wh_lower_dentry);
@@ -207,7 +207,7 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 
 		if (wh_lower_dentry->d_inode) {
 			/* We found a whiteout so lets give up. */
-			if (S_ISREG(wh_lower_dentry->d_inode->i_mode)) {
+			if (likely(S_ISREG(wh_lower_dentry->d_inode->i_mode))) {
 				set_dbend(dentry, bindex);
 				set_dbopaque(dentry, bindex);
 				dput(wh_lower_dentry);
@@ -228,7 +228,7 @@ struct dentry *unionfs_lookup_backend(struct dentry *dentry,
 
 		/* Now do regular lookup; lookup foo */
 		lower_dentry = lookup_one_len(name, lower_dir_dentry, namelen);
-		if (IS_ERR(lower_dentry)) {
+		if (unlikely(IS_ERR(lower_dentry))) {
 			dput(first_lower_dentry);
 			unionfs_mntput(first_dentry, first_dentry_offset);
 			err = PTR_ERR(lower_dentry);
@@ -321,7 +321,7 @@ out_negative:
 		first_lower_dentry = lookup_one_len(name, lower_dir_dentry,
 						    namelen);
 		first_dentry_offset = bindex;
-		if (IS_ERR(first_lower_dentry)) {
+		if (unlikely(IS_ERR(first_lower_dentry))) {
 			err = PTR_ERR(first_lower_dentry);
 			goto out;
 		}
@@ -381,12 +381,12 @@ out_positive:
 	 * dentry.
 	 */
 	d_interposed = unionfs_interpose(dentry, dentry->d_sb, lookupmode);
-	if (IS_ERR(d_interposed))
+	if (unlikely(IS_ERR(d_interposed)))
 		err = PTR_ERR(d_interposed);
 	else if (d_interposed)
 		dentry = d_interposed;
 
-	if (err)
+	if (unlikely(err))
 		goto out_drop;
 
 	goto out;
@@ -452,7 +452,7 @@ int unionfs_partial_lookup(struct dentry *dentry)
 		err = 0;
 		goto out;
 	}
-	if (IS_ERR(tmp)) {
+	if (unlikely(IS_ERR(tmp))) {
 		err = PTR_ERR(tmp);
 		goto out;
 	}
@@ -476,13 +476,13 @@ int unionfs_init_dentry_cache(void)
 
 void unionfs_destroy_dentry_cache(void)
 {
-	if (unionfs_dentry_cachep)
+	if (likely(unionfs_dentry_cachep))
 		kmem_cache_destroy(unionfs_dentry_cachep);
 }
 
 void free_dentry_private_data(struct dentry *dentry)
 {
-	if (!dentry || !dentry->d_fsdata)
+	if (unlikely(!dentry || !dentry->d_fsdata))
 		return;
 	kmem_cache_free(unionfs_dentry_cachep, dentry->d_fsdata);
 	dentry->d_fsdata = NULL;
@@ -498,7 +498,7 @@ static inline int __realloc_dentry_private_data(struct dentry *dentry)
 
 	size = sizeof(struct path) * sbmax(dentry->d_sb);
 	p = krealloc(info->lower_paths, size, GFP_ATOMIC);
-	if (!p)
+	if (unlikely(!p))
 		return -ENOMEM;
 
 	info->lower_paths = p;
@@ -518,7 +518,7 @@ static inline int __realloc_dentry_private_data(struct dentry *dentry)
 /* UNIONFS_D(dentry)->lock must be locked */
 static int realloc_dentry_private_data(struct dentry *dentry)
 {
-	if (!__realloc_dentry_private_data(dentry))
+	if (likely(!__realloc_dentry_private_data(dentry)))
 		return 0;
 
 	kfree(UNIONFS_D(dentry)->lower_paths);
@@ -534,7 +534,7 @@ int new_dentry_private_data(struct dentry *dentry)
 	BUG_ON(info);
 
 	info = kmem_cache_alloc(unionfs_dentry_cachep, GFP_ATOMIC);
-	if (!info)
+	if (unlikely(!info))
 		return -ENOMEM;
 
 	mutex_init(&info->lock);
@@ -544,7 +544,7 @@ int new_dentry_private_data(struct dentry *dentry)
 
 	dentry->d_fsdata = info;
 
-	if (!__realloc_dentry_private_data(dentry))
+	if (likely(!__realloc_dentry_private_data(dentry)))
 		return 0;
 
 	mutex_unlock(&info->lock);
@@ -602,7 +602,7 @@ int init_lower_nd(struct nameidata *nd, unsigned int flags)
 #endif /* ALLOC_LOWER_ND_FILE */
 
 	memset(nd, 0, sizeof(struct nameidata));
-	if (!flags)
+	if (unlikely(!flags))
 		return err;
 
 	switch (flags) {
@@ -614,7 +614,7 @@ int init_lower_nd(struct nameidata *nd, unsigned int flags)
 		nd->intent.open.flags |= (FMODE_READ | FMODE_WRITE);
 #ifdef ALLOC_LOWER_ND_FILE
 		file = kzalloc(sizeof(struct file), GFP_KERNEL);
-		if (!file) {
+		if (unlikely(!file)) {
 			err = -ENOMEM;
 			break; /* exit switch statement and thus return */
 		}
@@ -641,7 +641,7 @@ void release_lower_nd(struct nameidata *nd, int err)
 {
 	if (!nd->intent.open.file)
 		return;
-	else if (!err)
+	else if (likely(!err))
 		release_open_intent(nd);
 #ifdef ALLOC_LOWER_ND_FILE
 	kfree(nd->intent.open.file);
-- 
1.5.2.2

