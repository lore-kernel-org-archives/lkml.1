Return-Path: <linux-kernel-owner+w=401wt.eu-S1762771AbYB1VEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762771AbYB1VEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYB1VEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:04:20 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:64579 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbYB1VET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:04:19 -0500
Subject: Re: [PATCH 03/11] VFS: Add security label support to *notify
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20080228201004.GC32351@josefsipek.net>
References: <1204144786-3502-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1204144786-3502-4-git-send-email-dpquigl@tycho.nsa.gov>
	 <20080228201004.GC32351@josefsipek.net>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 15:39:30 -0500
Message-Id: <1204231170.24345.100.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 15:10 -0500, Josef 'Jeff' Sipek wrote:
> Ignoring the security parts of it, here are a few comments about the VFS and
> coding style related bits...
> 
> Josef 'Jeff' Sipek.
> 
> On Wed, Feb 27, 2008 at 03:39:38PM -0500, David P. Quigley wrote:
> > This patch adds two new fields to the iattr structure. The first field holds a
> > security label while the second contains the length of this label. In addition
> > the patch adds a new helper function inode_setsecurity which calls the LSM to
> > set the security label on the inode. Finally the patch modifies the necessary
> > functions such that fsnotify_change can handle notification requests for
> > dnotify and inotify.
> > 
> > Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
> > ---
> >  fs/attr.c                |   43 +++++++++++++++++++++++++++++++++++++++++++
> >  fs/xattr.c               |   33 +++++++++++++++++++++++++++------
> >  include/linux/fcntl.h    |    1 +
> >  include/linux/fs.h       |   11 +++++++++++
> >  include/linux/fsnotify.h |    6 ++++++
> >  include/linux/inotify.h  |    3 ++-
> >  include/linux/xattr.h    |    1 +
> >  7 files changed, 91 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/attr.c b/fs/attr.c
> > index 966b73e..1df6603 100644
> > --- a/fs/attr.c
> > +++ b/fs/attr.c
> > @@ -5,6 +5,7 @@
> >   *  changes by Thomas Schoebel-Theuer
> >   */
> >  
> > +#include <linux/fs.h>
> >  #include <linux/module.h>
> >  #include <linux/time.h>
> >  #include <linux/mm.h>
> > @@ -14,9 +15,35 @@
> >  #include <linux/fcntl.h>
> >  #include <linux/quotaops.h>
> >  #include <linux/security.h>
> > +#include <linux/xattr.h>
> >  
> >  /* Taken over from the old code... */
> >  
> > +#ifdef CONFIG_SECURITY
> > +/*
> > + * Update the in core label.
> > + */
> > +int inode_setsecurity(struct inode *inode, struct iattr *attr)
> > +{
> > +	const char *suffix = security_maclabel_getname() 
> > +				+ XATTR_SECURITY_PREFIX_LEN;
> > +	int error;
> > +
> > +	if (!attr->ia_valid & ATTR_SECURITY_LABEL)
> > +		return -EINVAL;
> 
> You most likely want:
> 
> 	if (!(attr->ia_valid & ATTR_SECURITY_LABEL))
> 
> IOW, watch out for operator precedence.

Already raised by James and fixed but thanks for catching it again.
> 
> > +
> > +	error = security_inode_setsecurity(inode, suffix, attr->ia_label,
> > +					   attr->ia_label_len, 0);
> > +	if (error)
> > +		printk(KERN_ERR "%s() %s %d security_inode_setsecurity() %d\n"
> > +			, __func__, (char *)attr->ia_label, attr->ia_label_len
> > +			, error);
> 
> The commas should really be on the previous line.

Fixed.

> 
> > +
> > +	return error;
> > +}
> > +EXPORT_SYMBOL(inode_setsecurity);
> > +#endif
> > +
> >  /* POSIX UID/GID verification for setting inode attributes. */
> >  int inode_change_ok(struct inode *inode, struct iattr *attr)
> >  {
> > @@ -94,6 +121,10 @@ int inode_setattr(struct inode * inode, struct iattr * attr)
> >  			mode &= ~S_ISGID;
> >  		inode->i_mode = mode;
> >  	}
> > +#ifdef CONFIG_SECURITY
> > +	if (ia_valid & ATTR_SECURITY_LABEL)
> > +		inode_setsecurity(inode, attr);
> > +#endif
> >  	mark_inode_dirty(inode);
> >  
> >  	return 0;
> > @@ -157,6 +188,18 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
> >  	if (ia_valid & ATTR_SIZE)
> >  		down_write(&dentry->d_inode->i_alloc_sem);
> >  
> > +#ifdef CONFIG_SECURITY
> > +	if (ia_valid & ATTR_SECURITY_LABEL) {
> > +		char *key = (char *)security_maclabel_getname();
> > +		vfs_setxattr_locked(dentry, key,
> > +			attr->ia_label, attr->ia_label_len, 0);
> > +		/* Avoid calling inode_setsecurity()
> > +		 * via inode_setattr() below
> > +		 */
> > +		attr->ia_valid &= ~ATTR_SECURITY_LABEL;
> > +	}
> > +#endif
> > +
> >  	if (inode->i_op && inode->i_op->setattr) {
> >  		error = security_inode_setattr(dentry, attr);
> >  		if (!error)
> > diff --git a/fs/xattr.c b/fs/xattr.c
> > index 3acab16..b5a91e1 100644
> > --- a/fs/xattr.c
> > +++ b/fs/xattr.c
> > @@ -67,9 +67,9 @@ xattr_permission(struct inode *inode, const char *name, int mask)
> >  	return permission(inode, mask, NULL);
> >  }
> >  
> > -int
> > -vfs_setxattr(struct dentry *dentry, char *name, void *value,
> > -		size_t size, int flags)
> > +static int
> > +_vfs_setxattr(struct dentry *dentry, char *name, void *value,
> > +		size_t size, int flags, int lock)
> 
> The convention is to use __ or do_ as the prefix.

Fixed (added another _ to the beginning.)
> 
> >  {
> >  	struct inode *inode = dentry->d_inode;
> >  	int error;
> > @@ -78,7 +78,8 @@ vfs_setxattr(struct dentry *dentry, char *name, void *value,
> >  	if (error)
> >  		return error;
> >  
> > -	mutex_lock(&inode->i_mutex);
> > +	if (lock)
> > +		mutex_lock(&inode->i_mutex);
> >  	error = security_inode_setxattr(dentry, name, value, size, flags);
> >  	if (error)
> >  		goto out;
> > @@ -95,15 +96,35 @@ vfs_setxattr(struct dentry *dentry, char *name, void *value,
> >  		const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
> >  		error = security_inode_setsecurity(inode, suffix, value,
> >  						   size, flags);
> > -		if (!error)
> > +		if (!error) {
> > +#ifdef CONFIG_SECURITY
> > +			fsnotify_change(dentry, ATTR_SECURITY_LABEL);
> > +#endif
> >  			fsnotify_xattr(dentry);
> > +		}
> >  	}
> >  out:
> > -	mutex_unlock(&inode->i_mutex);
> > +	if (lock)
> > +		mutex_unlock(&inode->i_mutex);
> >  	return error;
> >  }
> > +
> > +int
> > +vfs_setxattr(struct dentry *dentry, char *name, void *value,
> > +		size_t size, int flags)
> > +{
> > +	return _vfs_setxattr(dentry, name, value, size, flags, 1);
> > +}
> >  EXPORT_SYMBOL_GPL(vfs_setxattr);
> >  
> > +int
> > +vfs_setxattr_locked(struct dentry *dentry, char *name, void *value,
> > +			size_t size, int flags)
> > +{
> > +	return _vfs_setxattr(dentry, name, value, size, flags, 0);
> > +}
> > +EXPORT_SYMBOL_GPL(vfs_setxattr_locked);
> 
> Alright...so, few things...
> 
> 1) why do you need the locked/unlocked versions?
> 
> 2) instead of passing a flag to a common function, why not have:
> 
> vfs_setxattr_locked(....)
> {
> 	// original code minus the lock/unlock calls
> }
> 
> vfs_setxattr(....)
> {
> 	mutex_lock(...);
> 	vfs_setxattr_locked(...);
> 	mutex_unlock(...);
> }

What we do and what you propose aren't logically equivalent. There is a
permission check inside vfs_setxattr before the mutex lock. However
looking at through the xattr_permission function and its call chain it
doesn't seem like we would create a deadlock by locking the inode before
it is called; so it is possible to do what you propose. Since setting of
xattrs (at least from our perspective) is a less common operation I
don't think putting locking around the entire call would make that large
of a difference.

Dave

