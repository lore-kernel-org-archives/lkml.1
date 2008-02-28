Return-Path: <linux-kernel-owner+w=401wt.eu-S1760541AbYB2AJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760541AbYB2AJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 19:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYB2AJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:09:18 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:59420 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbYB2AJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:09:17 -0500
Subject: Re: [PATCH 03/11] VFS: Add security label support to *notify
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20080228235427.GA17757@infradead.org>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1204150294-4678-4-git-send-email-dpquigl@tycho.nsa.gov>
	 <20080228235427.GA17757@infradead.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 18:44:43 -0500
Message-Id: <1204242283.2715.9.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 18:54 -0500, Christoph Hellwig wrote:
> On Wed, Feb 27, 2008 at 05:11:26PM -0500, David P. Quigley wrote:
> > This patch adds two new fields to the iattr structure. The first field holds a
> > security label while the second contains the length of this label. In addition
> > the patch adds a new helper function inode_setsecurity which calls the LSM to
> > set the security label on the inode. Finally the patch modifies the necessary
> > functions such that fsnotify_change can handle notification requests for
> > dnotify and inotify.
> 
> Please don't overload setattr with this.  Just looking at your callers
> shows that it's much cleaner as a separate method.
> 
> Now what's really lacking is a desciption _why_ you actually need it
> to start with.  The current method to set security labels is through
> the security.* xattrs.  Now if we want to clean up that somewhat
> messy method that might be a good idea, but we should do it for all
> callers and not just some.

The main reason for this was the way that NFS passes information it
receives around. If you look in patch 11 you will see that
nfsd4_decode_fattr doesn't give us access to an inode to use for
security_inode_setsecurity and it doesn't give us a dentry to use the
xattr helpers with. The only thing we get here is an iattr structure
which is then passed back up to fill in the inode fields. Also without
functionality provided by patch 1 we don't even know where to put the
security blob we are getting from the wire. 

> 
> > +#define DN_LABEL        0x00000040      /* File (re)labeled */
> 
> An any inotify/dnotify additions should be separate from the vfs to
> filesystem interface.  Please make it a separate patch and describe
> properly why it's needed in it's description.

Will do. We added them to conform to the functionality provided for
other elements in the iattr structure. We will add a more robust
explanation in the patch.

> 
> > index df6b95d..1169963 100644
> > --- a/include/linux/xattr.h
> > +++ b/include/linux/xattr.h
> > @@ -50,6 +50,7 @@ ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
> >  ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
> >  ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
> >  int vfs_setxattr(struct dentry *, char *, void *, size_t, int);
> > +int vfs_setxattr_locked(struct dentry *, char *, void *, size_t, int);
> >  int vfs_removexattr(struct dentry *, char *);
> >  
> >  ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);
> > -- 
> > 1.5.3.8
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> ---end quoted text---

