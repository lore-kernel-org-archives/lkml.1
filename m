Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbZDTTu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbZDTTu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 15:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbZDTTuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 15:50:18 -0400
Received: from mail.fieldses.org ([141.211.133.115]:38562 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbZDTTuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 15:50:17 -0400
Date: Mon, 20 Apr 2009 15:50:08 -0400
To: David Woodhouse <dwmw2@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, hooanon05@yahoo.co.jp,
       hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Fix i_mutex handling in nfsd readdir
Message-ID: <20090420195008.GE1823@fieldses.org>
References: <1237475837.16359.106.camel@macbook.infradead.org> <8913.1237476890@jrobl> <1239960739.3428.33.camel@macbook.infradead.org> <20090417193233.GM26366@ZenIV.linux.org.uk> <1240006620.19059.41.camel@macbook.infradead.org> <20090417224350.GN26366@ZenIV.linux.org.uk> <20090417225306.GO26366@ZenIV.linux.org.uk> <1240013753.21423.86.camel@macbook.infradead.org> <1240144069.3589.156.camel@macbook.infradead.org> <20090419205154.GA18110@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090419205154.GA18110@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 04:51:54PM -0400, bfields wrote:
> On Sun, Apr 19, 2009 at 01:27:49PM +0100, David Woodhouse wrote:
> > Commit 14f7dd63 ("Copy XFS readdir hack into nfsd code") introduced a
> > bug to generic code which had been extant for a long time in the XFS
> > version -- it started to call through into lookup_one_len() and hence
> > into the file systems' ->lookup() methods without i_mutex held on the
> > directory.
> > 
> > This patch fixes it by locking the directory's i_mutex again before
> > calling the filldir functions. The original deadlocks which commit
> > 14f7dd63 was designed to avoid are still avoided, because they were due
> > to fs-internal locking, not i_mutex.
> > 
> > Commit 05f4f678 ("nfsd4: don't do lookup within readdir in recovery
> > code") introduced a similar problem there, which this also addresses.
> > 
> > While we're at it, fix the return type of nfsd_buffered_readdir() which
> > should be a __be32 not an int -- it's an NFS errno, not a Linux errno.
> > And return nfserrno(-ENOMEM) when allocation fails, not just -ENOMEM.
> > Sparse would have caught both of those if it wasn't so busy bitching
> > about __cold__.
> > 
> > Commit 05f4f678 ("nfsd4: don't do lookup within readdir in recovery
> > code") introduced a similar problem with calling lookup_one_len()
> > without i_mutex, which this patch also addresses.
> > 
> > Reported-by: J. R. Okajima <hooanon05@yahoo.co.jp>
> > Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> > Umm-I-can-live-with-that-by: Al Viro <viro@zeniv.linux.org.uk>
> > ---
> > Still haven't tested the NFSv4 bit -- Bruce?
> 
> Thanks, there's an iterator in there that calls a passed-in function,
> some examples of which were taking the i_mutex--so some fixing up is
> needed.  I'll follow up with a patch once I've got one tested.

Sorry for the delay.  Simpler might be just to drop and reacquire the
mutex each time through nfsd4_list_rec_dir()'s loop, but I'd just as
soon rework the called functions to expect the mutex be held (and get
rid of the unused, probably fragile, clear_clid_dir() in the process).

So the following could be folded in to your patch.

I tested the combined patch over 2.6.30-rc2.  I also tested 2.6.29 +
05f4f678 + the combined patch.  Both look  OK.  Feel free to add a
tested-by or acked-by for "J. Bruce Fields" <bfields@citi.umich.edu> as
appropriate.  Or happy to add a s-o-b and shepherd it along myself if
it's easier....

--b.

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 210709c..5275097 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -257,36 +257,6 @@ out:
 }
 
 static int
-nfsd4_remove_clid_file(struct dentry *dir, struct dentry *dentry)
-{
-	int status;
-
-	if (!S_ISREG(dir->d_inode->i_mode)) {
-		printk("nfsd4: non-file found in client recovery directory\n");
-		return -EINVAL;
-	}
-	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
-	status = vfs_unlink(dir->d_inode, dentry);
-	mutex_unlock(&dir->d_inode->i_mutex);
-	return status;
-}
-
-static int
-nfsd4_clear_clid_dir(struct dentry *dir, struct dentry *dentry)
-{
-	int status;
-
-	/* For now this directory should already be empty, but we empty it of
-	 * any regular files anyway, just in case the directory was created by
-	 * a kernel from the future.... */
-	nfsd4_list_rec_dir(dentry, nfsd4_remove_clid_file);
-	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
-	status = vfs_rmdir(dir->d_inode, dentry);
-	mutex_unlock(&dir->d_inode->i_mutex);
-	return status;
-}
-
-static int
 nfsd4_unlink_clid_dir(char *name, int namlen)
 {
 	struct dentry *dentry;
@@ -296,18 +266,18 @@ nfsd4_unlink_clid_dir(char *name, int namlen)
 
 	mutex_lock(&rec_dir.dentry->d_inode->i_mutex);
 	dentry = lookup_one_len(name, rec_dir.dentry, namlen);
-	mutex_unlock(&rec_dir.dentry->d_inode->i_mutex);
 	if (IS_ERR(dentry)) {
 		status = PTR_ERR(dentry);
-		return status;
+		goto out_unlock;
 	}
 	status = -ENOENT;
 	if (!dentry->d_inode)
 		goto out;
-
-	status = nfsd4_clear_clid_dir(rec_dir.dentry, dentry);
+	status = vfs_rmdir(rec_dir.dentry->d_inode, dentry);
 out:
 	dput(dentry);
+out_unlock:
+	mutex_unlock(&rec_dir.dentry->d_inode->i_mutex);
 	return status;
 }
 
@@ -350,7 +320,7 @@ purge_old(struct dentry *parent, struct dentry *child)
 	if (nfs4_has_reclaimed_state(child->d_name.name, false))
 		return 0;
 
-	status = nfsd4_clear_clid_dir(parent, child);
+	status = vfs_rmdir(parent->d_inode, child);
 	if (status)
 		printk("failed to remove client recovery directory %s\n",
 				child->d_name.name);
