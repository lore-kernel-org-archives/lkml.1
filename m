Return-Path: <linux-kernel-owner+w=401wt.eu-S1761421AbYB2VVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761421AbYB2VVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933743AbYB2VUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:20:50 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:40360 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933574AbYB2VUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:20:49 -0500
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
Date: Fri, 29 Feb 2008 15:19:12 -0500
Message-Id: <1204316352.2715.105.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this method will work on the server side and I will probably switch
to it. However while working on switching over I found that the client
side uses an iattr to pass inode information down into the protocol
calls. So there are two options. Add this to the iattr structure and do
this properly in a clean way. Or add additional params down the call
chain into these protocol handlers for NFS. Which is the better option
for this?

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

