Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbZGNIrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbZGNIrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 04:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZGNIrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 04:47:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:52565 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbZGNIrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 04:47:45 -0400
Subject: Re: [PATCH] AFS: Fix compilation warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org,
       linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
In-Reply-To: <20090709094430.23882.46013.stgit@warthog.procyon.org.uk>
References: <20090709094430.23882.46013.stgit@warthog.procyon.org.uk>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 14:17:00 +0530
Message-Id: <1247561220.2473.0.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 10:44 +0100, David Howells wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> Fix the following warning:
> 
> fs/afs/dir.c: In function 'afs_d_revalidate':
> fs/afs/dir.c:567: warning: 'fid.vnode' may be used uninitialized in this function
> fs/afs/dir.c:567: warning: 'fid.unique' may be used uninitialized in this function
> 
> by marking the 'fid' variable as an uninitialized_var.  The problem is that gcc
> doesn't always manage to work out that fid is always set on the path through
> the function that uses it.
> 
> Cc: linux-afs@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 

Have you tried this approach :

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 9bd7577..09cb5bb 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -607,53 +607,56 @@ static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 
 	/* search the directory for this vnode */
 	ret = afs_do_lookup(&dir->vfs_inode, dentry, &fid, key);
-	switch (ret) {
-	case 0:
-		/* the filename maps to something */
-		if (!dentry->d_inode)
-			goto out_bad;
-		if (is_bad_inode(dentry->d_inode)) {
-			printk("kAFS: afs_d_revalidate: %s/%s has bad inode\n",
-			       parent->d_name.name, dentry->d_name.name);
+	if (ret < 0) {
+		switch (ret) {
+		case -ENOENT:
+			/* the filename is unknown */
+			_debug("%s: dirent not found", dentry->d_name.name);
+			if (dentry->d_inode)
+				goto not_found;
+			goto out_valid;
+
+		default:
+			_debug("failed to iterate dir %s: %d",
+			       parent->d_name.name, ret);
 			goto out_bad;
 		}
+	}
 
-		/* if the vnode ID has changed, then the dirent points to a
-		 * different file */
-		if (fid.vnode != vnode->fid.vnode) {
-			_debug("%s: dirent changed [%u != %u]",
-			       dentry->d_name.name, fid.vnode,
-			       vnode->fid.vnode);
-			goto not_found;
-		}
-
-		/* if the vnode ID uniqifier has changed, then the file has
-		 * been deleted and replaced, and the original vnode ID has
-		 * been reused */
-		if (fid.unique != vnode->fid.unique) {
-			_debug("%s: file deleted (uq %u -> %u I:%llu)",
-			       dentry->d_name.name, fid.unique,
-			       vnode->fid.unique,
-			       (unsigned long long)dentry->d_inode->i_version);
-			spin_lock(&vnode->lock);
-			set_bit(AFS_VNODE_DELETED, &vnode->flags);
-			spin_unlock(&vnode->lock);
-			goto not_found;
-		}
-		goto out_valid;
-
-	case -ENOENT:
-		/* the filename is unknown */
-		_debug("%s: dirent not found", dentry->d_name.name);
-		if (dentry->d_inode)
-			goto not_found;
-		goto out_valid;
-
-	default:
-		_debug("failed to iterate dir %s: %d",
-		       parent->d_name.name, ret);
+	/* the filename maps to something */
+	if (!dentry->d_inode)
 		goto out_bad;
+	if (is_bad_inode(dentry->d_inode)) {
+		printk("kAFS: afs_d_revalidate: %s/%s has bad inode\n",
+		       parent->d_name.name, dentry->d_name.name);
+		goto out_bad;
+	}
+
+	/*
+	 * if the vnode ID has changed, then the dirent points to a
+	 * different file
+	 */
+	if (fid.vnode != vnode->fid.vnode) {
+		_debug("%s: dirent changed [%u != %u]",
+		       dentry->d_name.name, fid.vnode, vnode->fid.vnode);
+		goto not_found;
+	}
+
+	/*
+	 * if the vnode ID uniqifier has changed, then the file has been
+	 * deleted and replaced, and the original vnode ID has been reused
+	 */
+	if (fid.unique != vnode->fid.unique) {
+		_debug("%s: file deleted (uq %u -> %u I:%llu)",
+		       dentry->d_name.name, fid.unique,
+		       vnode->fid.unique,
+		       (unsigned long long)dentry->d_inode->i_version);
+		spin_lock(&vnode->lock);
+		set_bit(AFS_VNODE_DELETED, &vnode->flags);
+		spin_unlock(&vnode->lock);
+		goto not_found;
 	}
+	goto out_valid;
 
 out_valid:
 	dentry->d_fsdata = dir_version;

>  fs/afs/dir.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/fs/afs/dir.c b/fs/afs/dir.c
> index 5272872..790ba9d 100644
> --- a/fs/afs/dir.c
> +++ b/fs/afs/dir.c
> @@ -566,7 +566,7 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
>  static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
>  {
>  	struct afs_vnode *vnode, *dir;
> -	struct afs_fid fid;
> +	struct afs_fid uninitialized_var(fid);
>  	struct dentry *parent;
>  	struct key *key;
>  	void *dir_version;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

