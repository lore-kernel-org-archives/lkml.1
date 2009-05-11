Return-Path: <linux-kernel-owner+w=401wt.eu-S1760742AbZEKXQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760742AbZEKXQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758997AbZEKXQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:16:47 -0400
Received: from mail.fieldses.org ([141.211.133.115]:36039 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbZEKXQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:16:46 -0400
Date: Mon, 11 May 2009 19:16:34 -0400
To: David Woodhouse <dwmw2@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, hooanon05@yahoo.co.jp,
       hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Fix i_mutex handling in nfsd readdir
Message-ID: <20090511231634.GN793@fieldses.org>
References: <8913.1237476890@jrobl> <1239960739.3428.33.camel@macbook.infradead.org> <20090417193233.GM26366@ZenIV.linux.org.uk> <1240006620.19059.41.camel@macbook.infradead.org> <20090417224350.GN26366@ZenIV.linux.org.uk> <20090417225306.GO26366@ZenIV.linux.org.uk> <1240013753.21423.86.camel@macbook.infradead.org> <1240144069.3589.156.camel@macbook.infradead.org> <20090419205154.GA18110@fieldses.org> <20090420195008.GE1823@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420195008.GE1823@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 03:50:08PM -0400, bfields wrote:
> On Sun, Apr 19, 2009 at 04:51:54PM -0400, bfields wrote:
> > On Sun, Apr 19, 2009 at 01:27:49PM +0100, David Woodhouse wrote:
> > > Commit 14f7dd63 ("Copy XFS readdir hack into nfsd code") introduced a
> > > bug to generic code which had been extant for a long time in the XFS
> > > version -- it started to call through into lookup_one_len() and hence
> > > into the file systems' ->lookup() methods without i_mutex held on the
> > > directory.
> > > 
> > > This patch fixes it by locking the directory's i_mutex again before
> > > calling the filldir functions. The original deadlocks which commit
> > > 14f7dd63 was designed to avoid are still avoided, because they were due
> > > to fs-internal locking, not i_mutex.
> > > 
> > > Commit 05f4f678 ("nfsd4: don't do lookup within readdir in recovery
> > > code") introduced a similar problem there, which this also addresses.
> > > 
> > > While we're at it, fix the return type of nfsd_buffered_readdir() which
> > > should be a __be32 not an int -- it's an NFS errno, not a Linux errno.
> > > And return nfserrno(-ENOMEM) when allocation fails, not just -ENOMEM.
> > > Sparse would have caught both of those if it wasn't so busy bitching
> > > about __cold__.
> > > 
> > > Commit 05f4f678 ("nfsd4: don't do lookup within readdir in recovery
> > > code") introduced a similar problem with calling lookup_one_len()
> > > without i_mutex, which this patch also addresses.
> > > 
> > > Reported-by: J. R. Okajima <hooanon05@yahoo.co.jp>
> > > Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> > > Umm-I-can-live-with-that-by: Al Viro <viro@zeniv.linux.org.uk>
> > > ---
> > > Still haven't tested the NFSv4 bit -- Bruce?
> > 
> > Thanks, there's an iterator in there that calls a passed-in function,
> > some examples of which were taking the i_mutex--so some fixing up is
> > needed.  I'll follow up with a patch once I've got one tested.
> 
> Sorry for the delay.  Simpler might be just to drop and reacquire the
> mutex each time through nfsd4_list_rec_dir()'s loop, but I'd just as
> soon rework the called functions to expect the mutex be held (and get
> rid of the unused, probably fragile, clear_clid_dir() in the process).
> 
> So the following could be folded in to your patch.
> 
> I tested the combined patch over 2.6.30-rc2.  I also tested 2.6.29 +
> 05f4f678 + the combined patch.  Both look  OK.  Feel free to add a
> tested-by or acked-by for "J. Bruce Fields" <bfields@citi.umich.edu> as
> appropriate.  Or happy to add a s-o-b and shepherd it along myself if
> it's easier....

Unfortunately, I wasn't watching my logs carefully enough, and missed a
lockdep warning.

(Stupid policy question: is this for stable, current, or next (.29, .30,
or .31?)  On the one hand, it's just a warning.  On the other hand,
people freak out when they see backtraces in their logs.  But I don't
know how common it is to have lockdep on.)

--b.

commit 8daed1e549b55827758b3af7b8132a73fc51526f
Author: J. Bruce Fields <bfields@citi.umich.edu>
Date:   Mon May 11 16:10:19 2009 -0400

    nfsd: silence lockdep warning
    
    Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 5275097..b534840 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -229,7 +229,7 @@ nfsd4_list_rec_dir(struct dentry *dir, recdir_func *f)
 		goto out;
 	status = vfs_readdir(filp, nfsd4_build_namelist, &names);
 	fput(filp);
-	mutex_lock(&dir->d_inode->i_mutex);
+	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
 	while (!list_empty(&names)) {
 		entry = list_entry(names.next, struct name_list, list);
 
@@ -264,7 +264,7 @@ nfsd4_unlink_clid_dir(char *name, int namlen)
 
 	dprintk("NFSD: nfsd4_unlink_clid_dir. name %.*s\n", namlen, name);
 
-	mutex_lock(&rec_dir.dentry->d_inode->i_mutex);
+	mutex_lock_nested(&rec_dir.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	dentry = lookup_one_len(name, rec_dir.dentry, namlen);
 	if (IS_ERR(dentry)) {
 		status = PTR_ERR(dentry);
