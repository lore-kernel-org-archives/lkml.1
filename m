Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961Ab0AUAgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab0AUAgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 19:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565Ab0AUAgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 19:36:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab0AUAgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 19:36:20 -0500
Date: Wed, 20 Jan 2010 19:35:50 -0500
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
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 10/41] whiteout: Add vfs_whiteout() and whiteout inode operation
Message-ID: <20100121003550.GA26459@shell>
References: <1256152779-10054-11-git-send-email-vaurora@redhat.com> <200911300304.nAU34G18007753@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911300304.nAU34G18007753@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 29, 2009 at 10:04:16PM -0500, Erez Zadok wrote:
> In message <1256152779-10054-11-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> > From: Jan Blunck <jblunck@suse.de>
> > 
> > Simply white-out a given directory entry. This functionality is usually used
> > in the sense of unlink. Therefore the given dentry can still be in-use and
> > contains an in-use inode. The filesystems inode operation has to do what
> > unlink or rmdir would in that case. Since the dentry still might be in-use
> > we have to provide a fresh unhashed dentry that is used as the whiteout
> > dentry instead. The given dentry is dropped and the whiteout dentry is
> > rehashed instead.
> > 
> > Signed-off-by: Jan Blunck <jblunck@suse.de>
> > Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> > Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> > ---
> >  fs/dcache.c            |    4 +-
> >  fs/namei.c             |  104 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/dcache.h |    6 +++
> >  include/linux/fs.h     |    3 +
> >  4 files changed, 116 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index 3415e9e..0fcae4b 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -1076,8 +1076,10 @@ struct dentry *d_alloc_name(struct dentry *parent, const char *name)
> >  /* the caller must hold dcache_lock */
> >  static void __d_instantiate(struct dentry *dentry, struct inode *inode)
> >  {
> > -	if (inode)
> > +	if (inode) {
> > +		dentry->d_flags &= ~DCACHE_WHITEOUT;
> >  		list_add(&dentry->d_alias, &inode->i_dentry);
> > +	}
> >  	dentry->d_inode = inode;
> >  	fsnotify_d_instantiate(dentry, inode);
> >  }
> > diff --git a/fs/namei.c b/fs/namei.c
> > index 46cf1cb..d2fc8c9 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -2169,6 +2169,110 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathname, int, mode)
> >  	return sys_mkdirat(AT_FDCWD, pathname, mode);
> >  }
> >  
> > +
> > +/* Checks on the victim for whiteout */
> > +static inline int may_whiteout(struct inode *dir, struct dentry *victim,
> > +			       int isdir)
> 
> Why not make 'isdir' a boolean?
> 
> I'd prefer to see more documentation above this function: explain what each
> arg does, return value, etc.

Indeed!  I added descriptions of the new whiteout and fallthru VFS ops
to Documentation/filesystems/vfs.txt, where it belongs.

> > +/**
> > + * vfs_whiteout: creates a white-out for the given directory entry
> > + * @dir: parent inode
> > + * @dentry: directory entry to white-out
> 
> Nit: is it 'white-out' or 'whiteout'?  Whatever you choose is fine, but
> please use consistent hypenation/spelling everywhere (code, comments, and
> documentation).

Done, thanks.

> > + *
> > + * Simply white-out a given directory entry. This functionality is usually used
> > + * in the sense of unlink. Therefore the given dentry can still be in-use and
> > + * contains an in-use inode. The filesystem has to do what unlink or rmdir
> 
> Nit: other than the line of comment just above, the other two instances of
> "in-use" in this comment (and the patch header) should be changed to "in
> use" (no hyphen).
> 
> > + * would in that case. Since the dentry still might be in-use we have to
> > + * provide a fresh unhashed dentry that whiteout can fill the new inode into.
> > + * In that case the given dentry is dropped and the fresh dentry containing the
> > + * whiteout is rehashed instead. If the given dentry is unused, the whiteout
> > + * inode is instantiated into it instead.
> > + *
> > + * After this returns with success, don't make any assumptions about the inode.
> 
> What kinds of assumptions one should not make?  Perhaps it'd be better to
> document what you can/should assume, instead of what you shouldn't (or
> both?)
> 
> > + * Just dput() it dentry.
> 
> The last line is awkward: do you mean "its dentry"?

All rewritten to address the above comments.

Thanks,

-VAL
