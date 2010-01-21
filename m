Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187Ab0AUAxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab0AUAxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 19:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661Ab0AUAxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 19:53:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab0AUAxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 19:53:32 -0500
Date: Wed, 20 Jan 2010 19:52:59 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/41] union-mount: Allow removal of a directory
Message-ID: <20100121005259.GB26459@shell>
References: <1256152779-10054-13-git-send-email-vaurora@redhat.com> <200911300613.nAU6Da0Z022008@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911300613.nAU6Da0Z022008@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 01:13:36AM -0500, Erez Zadok wrote:
> In message <1256152779-10054-13-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> > From: Jan Blunck <jblunck@suse.de>
> > 
> > do_whiteout() allows removal of a directory when it has whiteouts but
> > is logically empty.
> > 
> > XXX - This patch abuses readdir() to check if the union directory is
> > logically empty - that is, all the entries are whiteouts (or "." or
> > "..").  Currently, we have no clean VFS interface to ask the lower
> > file system if a directory is empty.
> > 
> > Fixes:
> >  - Add ->is_directory_empty() op
> >  - Add is_directory_empty flag to dentry (ugly dcache populate)
> >  - Ask underlying fs to remove it and look for an error return
> >  - (your idea here)
> 
> Yeah, this is a difficult issue.  I think the best way would be to
> 
> 1. add an OPTIONAL ->is_directory_empty() inode op.
> 
> 2. have the VFS use some default/generic behavior ala filldir_is_empty()
>    below if inode->i_op->is_directory_empty is NULL.  I assume this behavior
>    will only need to be checked for file systems that support whiteouts in
>    the first place.
> 
> This'll provide some working behavior for all whiteout-supporting file
> systems, but allow anyone who wants to develop a more efficient method to
> provide one.

I hear you, but I'm reluctant to keep a generic version of
is_directory_empty() because, (1) you have to add support for
whiteouts and fallthrus anyway, you might as well require support for
is_directory_empty() op at the same time, (2) per-fs versions would be
undoubtedly more efficient than bouncing up and down through
readdir(), and (3) it's such an abuse. :)

> > Signed-off-by: Jan Blunck <jblunck@suse.de>
> > Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> > ---
> >  fs/namei.c |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 85 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/namei.c b/fs/namei.c
> > index 5da1635..9a62c75 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -2284,6 +2284,91 @@ int vfs_whiteout(struct inode *dir, struct dentry *dentry, int isdir)
> >  }
> >  
> >  /*
> > + * This is abusing readdir to check if a union directory is logically empty.
> > + * Al Viro barfed when he saw this, but Val said: "Well, at this point I'm
> > + * aiming for working, pretty can come later"
> > + */
> > +static int filldir_is_empty(void *__buf, const char *name, int namlen,
> > +			    loff_t offset, u64 ino, unsigned int d_type)
> > +{
> 
> Why not make filldir_is_empty() return a bool?  That explains more clearly
> the function's return code.
> 
> > +static int directory_is_empty(struct dentry *dentry, struct vfsmount *mnt)
> > +{
> 
> This can also return a bool.
> 
> > +static int do_whiteout(struct nameidata *nd, struct path *path, int isdir)
> > +{
> 
> 'isdir' can be bool.

In general, I'm not using bools because it doesn't fit in with the
coding style of the rest of the VFS.

> > +	struct path safe = { .dentry = dget(nd->path.dentry),
> > +			     .mnt = mntget(nd->path.mnt) };
> > +	struct dentry *dentry = path->dentry;
> > +	int err;
> 
> You might want to move the initialization of 'struct path safe' down below,
> and add a BUG_ON(!nd) before that.  I think during the development phases of
> UM, it's a good idea to have a few more debugging BUG_ON's.

I'd rather get rid of the need for struct path safe entirely...

-VAL
