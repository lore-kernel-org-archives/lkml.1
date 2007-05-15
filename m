Return-Path: <linux-kernel-owner+w=401wt.eu-S1761960AbXEOHRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761960AbXEOHRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758712AbXEOHQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:16:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:56847 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757085AbXEOHQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:16:38 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 15 May 2007 17:16:29 +1000
Message-Id: <1070515071629.16300@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 004 of 8] knfsd: exportfs: remove CALL macro
References: <20070515170405.15621.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Christoph Hellwig <hch@infradead.org>

Currently exportfs uses a way to call methods very differently from
the rest of the kernel.  This patch changes it to the standard conventions
for method calls.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/exportfs/expfs.c |  128 ++++++++++++++++++++++++++++----------------------
 1 file changed, 72 insertions(+), 56 deletions(-)

diff .prev/fs/exportfs/expfs.c ./fs/exportfs/expfs.c
--- .prev/fs/exportfs/expfs.c	2007-05-14 11:15:31.000000000 +1000
+++ ./fs/exportfs/expfs.c	2007-05-14 11:15:34.000000000 +1000
@@ -6,11 +6,36 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 
-struct export_operations export_op_default;
+#define dprintk(fmt, args...) do{}while(0)
 
-#define	CALL(ops,fun) ((ops->fun)?(ops->fun):export_op_default.fun)
 
-#define dprintk(fmt, args...) do{}while(0)
+static int get_name(struct dentry *dentry, char *name,
+		struct dentry *child);
+
+
+static struct dentry *exportfs_get_dentry(struct super_block *sb, void *obj)
+{
+	struct dentry *result = ERR_PTR(-ESTALE);
+
+	if (sb->s_export_op->get_dentry) {
+		result = sb->s_export_op->get_dentry(sb, obj);
+		if (!result)
+			result = ERR_PTR(-ESTALE);
+	}
+
+	return result;
+}
+
+static int exportfs_get_name(struct dentry *dir, char *name,
+		struct dentry *child)
+{
+	struct export_operations *nop = dir->d_sb->s_export_op;
+
+	if (nop->get_name)
+		return nop->get_name(dir, name, child);
+	else
+		return get_name(dir, name, child);
+}
 
 static struct dentry *
 find_acceptable_alias(struct dentry *result,
@@ -78,7 +103,7 @@ find_exported_dentry(struct super_block 
 {
 	struct dentry *result = NULL;
 	struct dentry *target_dir;
-	int err;
+	int err = -ESTALE;
 	struct export_operations *nops = sb->s_export_op;
 	struct dentry *alias;
 	int noprogress;
@@ -87,14 +112,10 @@ find_exported_dentry(struct super_block 
 	/*
 	 * Attempt to find the inode.
 	 */
-	result = CALL(sb->s_export_op,get_dentry)(sb,obj);
-	err = -ESTALE;
-	if (result == NULL)
-		goto err_out;
-	if (IS_ERR(result)) {
-		err = PTR_ERR(result);
-		goto err_out;
-	}
+	result = exportfs_get_dentry(sb, obj);
+	if (IS_ERR(result))
+		return result;
+
 	if (S_ISDIR(result->d_inode->i_mode) &&
 	    (result->d_flags & DCACHE_DISCONNECTED)) {
 		/* it is an unconnected directory, we must connect it */
@@ -122,11 +143,11 @@ find_exported_dentry(struct super_block 
 		if (parent == NULL)
 			goto err_result;
 
-		target_dir = CALL(sb->s_export_op,get_dentry)(sb,parent);
-		if (IS_ERR(target_dir))
+		target_dir = exportfs_get_dentry(sb,parent);
+		if (IS_ERR(target_dir)) {
 			err = PTR_ERR(target_dir);
-		if (target_dir == NULL || IS_ERR(target_dir))
 			goto err_result;
+		}
 	}
 	/*
 	 * Now we need to make sure that target_dir is properly connected.
@@ -177,18 +198,27 @@ find_exported_dentry(struct super_block 
 			spin_unlock(&pd->d_lock);
 			noprogress = 0;
 		} else {
-			/* we have hit the top of a disconnected path.  Try
-			 * to find parent and connect
-			 * note: racing with some other process renaming a
-			 * directory isn't much of a problem here.  If someone
-			 * renames the directory, it will end up properly
-			 * connected, which is what we want
+			/*
+			 * We have hit the top of a disconnected path, try to
+			 * find parent and connect.
+			 *
+			 * Racing with some other process renaming a directory
+			 * isn't much of a problem here.  If someone renames
+			 * the directory, it will end up properly connected,
+			 * which is what we want
+			 *
+			 * Getting the parent can't be supported generically,
+			 * the locking is too icky.
+			 *
+			 * Instead we just return EACCES.  If server reboots
+			 * or inodes get flushed, you lose
 			 */
-			struct dentry *ppd;
+			struct dentry *ppd = ERR_PTR(-EACCES);
 			struct dentry *npd;
 
 			mutex_lock(&pd->d_inode->i_mutex);
-			ppd = CALL(nops,get_parent)(pd);
+			if (nops->get_parent)
+				ppd = nops->get_parent(pd);
 			mutex_unlock(&pd->d_inode->i_mutex);
 
 			if (IS_ERR(ppd)) {
@@ -199,7 +229,7 @@ find_exported_dentry(struct super_block 
 				break;
 			}
 			dprintk("find_exported_dentry: find name of %lu in %lu\n", pd->d_inode->i_ino, ppd->d_inode->i_ino);
-			err = CALL(nops,get_name)(ppd, nbuf, pd);
+			err = exportfs_get_name(ppd, nbuf, pd);
 			if (err) {
 				dput(ppd);
 				dput(pd);
@@ -250,7 +280,7 @@ find_exported_dentry(struct super_block 
 	/* if we weren't after a directory, have one more step to go */
 	if (result != target_dir) {
 		struct dentry *nresult;
-		err = CALL(nops,get_name)(target_dir, nbuf, result);
+		err = exportfs_get_name(target_dir, nbuf, result);
 		if (!err) {
 			mutex_lock(&target_dir->d_inode->i_mutex);
 			nresult = lookup_one_len(nbuf, target_dir, strlen(nbuf));
@@ -286,23 +316,9 @@ find_exported_dentry(struct super_block 
 	dput(target_dir);
  err_result:
 	dput(result);
- err_out:
 	return ERR_PTR(err);
 }
 
-
-
-static struct dentry *get_parent(struct dentry *child)
-{
-	/* get_parent cannot be supported generically, the locking
-	 * is too icky.
-	 * instead, we just return EACCES.  If server reboots or inodes
-	 * get flushed, you lose
-	 */
-	return ERR_PTR(-EACCES);
-}
-
-
 struct getdents_callback {
 	char *name;		/* name that was found. It already points to a
 				   buffer NAME_MAX+1 is size */
@@ -392,11 +408,6 @@ out:
 	return error;
 }
 
-static struct dentry *get_dentry(struct super_block *sb, void *vobjp)
-{
-	return ERR_PTR(-ESTALE);
-}
-
 /**
  * export_encode_fh - default export_operations->encode_fh function
  * @dentry:  the dentry to encode
@@ -472,9 +483,15 @@ static struct dentry *export_decode_fh(s
 int exportfs_encode_fh(struct dentry *dentry, __u32 *fh, int *max_len,
 		int connectable)
 {
-	struct export_operations *nop = dentry->d_sb->s_export_op;
+ 	struct export_operations *nop = dentry->d_sb->s_export_op;
+	int error;
+
+	if (nop->encode_fh)
+		error = nop->encode_fh(dentry, fh, max_len, connectable);
+	else
+		error = export_encode_fh(dentry, fh, max_len, connectable);
 
-	return CALL(nop, encode_fh)(dentry, fh, max_len, connectable);
+	return error;
 }
 EXPORT_SYMBOL_GPL(exportfs_encode_fh);
 
@@ -483,21 +500,20 @@ struct dentry *exportfs_decode_fh(struct
 		void *context)
 {
 	struct export_operations *nop = mnt->mnt_sb->s_export_op;
+	struct dentry *result;
 
-	return CALL(nop, decode_fh)(mnt->mnt_sb, fh, fh_len, fileid_type,
+	if (nop->decode_fh) {
+		result = nop->decode_fh(mnt->mnt_sb, fh, fh_len, fileid_type,
+			acceptable, context);
+	} else {
+		result = export_decode_fh(mnt->mnt_sb, fh, fh_len, fileid_type,
 			acceptable, context);
+	}
+
+	return result;
 }
 EXPORT_SYMBOL_GPL(exportfs_decode_fh);
 
-struct export_operations export_op_default = {
-	.decode_fh	= export_decode_fh,
-	.encode_fh	= export_encode_fh,
-
-	.get_name	= get_name,
-	.get_parent	= get_parent,
-	.get_dentry	= get_dentry,
-};
-
 EXPORT_SYMBOL(find_exported_dentry);
 
 MODULE_LICENSE("GPL");
