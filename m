Return-Path: <linux-kernel-owner+w=401wt.eu-S1759327AbYB2CRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327AbYB2CRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 21:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbYB2CR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 21:17:28 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:41300 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbYB2CR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 21:17:26 -0500
Subject: Re: [PATCH 03/11] VFS: Add security label support to *notify
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20080229002312.GA9198@infradead.org>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1204150294-4678-4-git-send-email-dpquigl@tycho.nsa.gov>
	 <20080228235427.GA17757@infradead.org>
	 <1204242283.2715.9.camel@moss-terrapins.epoch.ncsc.mil>
	 <20080229002312.GA9198@infradead.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 20:52:57 -0500
Message-Id: <1204249977.2715.69.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So after looking at this it seems that this is going to be a far more
changes to NFS to set something that is an inode attribute. I can keep
looking into it but it seems like it can be done much cleaner as an
inode_setattr extension rather than adding new structures all over the
nfs code.

Dave

On Thu, 2008-02-28 at 19:23 -0500, Christoph Hellwig wrote:
> On Thu, Feb 28, 2008 at 06:44:43PM -0500, Dave Quigley wrote:
> > The main reason for this was the way that NFS passes information it
> > receives around. If you look in patch 11 you will see that
> > nfsd4_decode_fattr doesn't give us access to an inode to use for
> > security_inode_setsecurity and it doesn't give us a dentry to use the
> > xattr helpers with. The only thing we get here is an iattr structure
> > which is then passed back up to fill in the inode fields. Also without
> > functionality provided by patch 1 we don't even know where to put the
> > security blob we are getting from the wire. 
> 
> Take a look at how ACLs are handled.  They're passed up from the _decode
> operations into a small structure that is referenced by struct
> nfsd4_<operation> and pass it up until the level where the dentry
> is available.
> 
> > 
> > > 
> > > > +#define DN_LABEL        0x00000040      /* File (re)labeled */
> > > 
> > > An any inotify/dnotify additions should be separate from the vfs to
> > > filesystem interface.  Please make it a separate patch and describe
> > > properly why it's needed in it's description.
> > 
> > Will do. We added them to conform to the functionality provided for
> > other elements in the iattr structure. We will add a more robust
> > explanation in the patch.
> > 
> > > 
> > > > index df6b95d..1169963 100644
> > > > --- a/include/linux/xattr.h
> > > > +++ b/include/linux/xattr.h
> > > > @@ -50,6 +50,7 @@ ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
> > > >  ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
> > > >  ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
> > > >  int vfs_setxattr(struct dentry *, char *, void *, size_t, int);
> > > > +int vfs_setxattr_locked(struct dentry *, char *, void *, size_t, int);
> > > >  int vfs_removexattr(struct dentry *, char *);
> > > >  
> > > >  ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);
> > > > -- 
> > > > 1.5.3.8
> > > > 
> > > > -
> > > > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > ---end quoted text---
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> ---end quoted text---

