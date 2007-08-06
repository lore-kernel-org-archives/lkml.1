Return-Path: <linux-kernel-owner+w=401wt.eu-S1764864AbXHFLIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764864AbXHFLIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764368AbXHFLIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:08:24 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37681 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764307AbXHFLIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:08:22 -0400
Date: Mon, 6 Aug 2007 16:38:18 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 20/26] union-mount: Simple union-mount readdir implementation
Message-ID: <20070806110818.GC7489@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161325.004086646@weierstrass.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730161325.004086646@weierstrass.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 06:13:43PM +0200, Jan Blunck wrote:
> --- a/include/linux/union.h
> +++ b/include/linux/union.h
> @@ -53,6 +53,7 @@ extern void __shrink_d_unions(struct den
>  extern int attach_mnt_union(struct vfsmount *, struct vfsmount *,
>  			    struct dentry *);
>  extern void detach_mnt_union(struct vfsmount *);
> +extern int readdir_union(struct file *, void *, filldir_t);
> 
>  #else /* CONFIG_UNION_MOUNT */
> 
> @@ -69,5 +70,29 @@ extern void detach_mnt_union(struct vfsm
>  #define detach_mnt_union(x)		do { } while (0)
> 
>  #endif	/* CONFIG_UNION_MOUNT */
> +
> +static inline int do_readdir(struct file *file, void *buf, filldir_t filler)
> +{
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +	int res;
> +
> +#ifdef CONFIG_UNION_MOUNT
> +	if (IS_MNT_UNION(file->f_path.mnt))
> +		res = readdir_union(file, buf, filler);
> +	else
> +#endif
> +	{
> +		mutex_lock(&inode->i_mutex);
> +		res = -ENOENT;
> +		if (!IS_DEADDIR(inode)) {
> +			res = file->f_op->readdir(file, buf, filler);
> +			file_accessed(file);
> +		}
> +		mutex_unlock(&inode->i_mutex);
> +	}
> +
> +	return res;
> +}

Here you are doing readdir_union for all the directories under a union
mount point, which is an overhead (building the readdir cache). Here is
the fix:

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

Within a union mount point, there can be directories which don't have a
union stack underneath them. And readdir() doesn't have to maintain a cache
of dirents for such directories. But the current patch maintains the cache
for such directories. Fix this.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/union.c            |   17 +++++++++++++++++
 include/linux/union.h |   11 ++++++-----
 2 files changed, 23 insertions(+), 5 deletions(-)

--- a/fs/union.c
+++ b/fs/union.c
@@ -366,6 +366,23 @@ int follow_union_mount(struct vfsmount *
 }
 
 /*
+ * is_dir_unioned - check if the directory represented by @mnt and @dentry
+ * has a union stack underneath.
+ *
+ * Returns true if a union stack exists at this directory level, else returns
+ * false.
+ */
+int is_dir_unioned(struct vfsmount *mnt, struct dentry *dentry)
+{
+	struct union_mount *um;
+
+	spin_lock(&union_lock);
+	um = union_lookup(dentry, mnt);
+	spin_unlock(&union_lock);
+	return um ? 1: 0;
+}
+
+/*
  * This must be called when unhashing a dentry. This is called with dcache_lock
  * and unhashes all unions this dentry is in.
  */
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -54,6 +54,7 @@ extern int attach_mnt_union(struct vfsmo
 			    struct dentry *);
 extern void detach_mnt_union(struct vfsmount *);
 extern int readdir_union(struct file *, void *, filldir_t);
+extern int is_dir_unioned(struct vfsmount *, struct dentry *);
 extern int union_relookup_topmost(struct nameidata *, int);
 extern struct dentry *union_create_topmost(struct nameidata *, struct qstr *,
 					   struct path *);
@@ -82,13 +83,14 @@ extern int union_copyup(struct nameidata
 
 static inline int do_readdir(struct file *file, void *buf, filldir_t filler)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
 	int res;
+	struct inode *inode = file->f_path.dentry->d_inode;
 
 #ifdef CONFIG_UNION_MOUNT
-	if (IS_MNT_UNION(file->f_path.mnt))
-		res = readdir_union(file, buf, filler);
-	else
+	if (IS_MNT_UNION(file->f_path.mnt)) {
+		if (is_dir_unioned(file->f_path.mnt, file->f_path.dentry))
+			res = readdir_union(file, buf, filler);
+	} else
 #endif
 	{
 		mutex_lock(&inode->i_mutex);
@@ -99,7 +101,6 @@ static inline int do_readdir(struct file
 		}
 		mutex_unlock(&inode->i_mutex);
 	}
-
 	return res;
 }
 
Regards,
Bharata.
