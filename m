Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982Ab0AZTwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab0AZTwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653Ab0AZTwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:52:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538Ab0AZTwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:52:39 -0500
Date: Tue, 26 Jan 2010 14:52:09 -0500
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
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH 16/41] whiteout: jffs2 whiteout support
Message-ID: <20100126195208.GC32353@shell>
References: <1256152779-10054-17-git-send-email-vaurora@redhat.com> <200911300751.nAU7p53e022740@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911300751.nAU7p53e022740@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 02:51:05AM -0500, Erez Zadok wrote:
> In message <1256152779-10054-17-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> > From: Felix Fietkau <nbd@openwrt.org>
> > 
> > Add support for whiteout dentries to jffs2.
> > 
> > Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> > Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> > Cc: David Woodhouse <dwmw2@infradead.org>
> > Cc: linux-mtd@lists.infradead.org
> > ---
> >  fs/jffs2/dir.c        |   77 +++++++++++++++++++++++++++++++++++++++++++++++-
> >  fs/jffs2/fs.c         |    4 ++
> >  fs/jffs2/super.c      |    2 +-
> >  include/linux/jffs2.h |    2 +
> >  4 files changed, 82 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
> > index 6f60cc9..46a2e1b 100644
> > --- a/fs/jffs2/dir.c
> > +++ b/fs/jffs2/dir.c
> > @@ -34,6 +34,8 @@ static int jffs2_mknod (struct inode *,struct dentry *,int,dev_t);
> >  static int jffs2_rename (struct inode *, struct dentry *,
> >  			 struct inode *, struct dentry *);
> >  
> > +static int jffs2_whiteout (struct inode *, struct dentry *, struct dentry *);
> > +
> >  const struct file_operations jffs2_dir_operations =
> >  {
> >  	.read =		generic_read_dir,
> > @@ -55,6 +57,7 @@ const struct inode_operations jffs2_dir_inode_operations =
> >  	.rmdir =	jffs2_rmdir,
> >  	.mknod =	jffs2_mknod,
> >  	.rename =	jffs2_rename,
> > +	.whiteout =     jffs2_whiteout,
> >  	.permission =	jffs2_permission,
> >  	.setattr =	jffs2_setattr,
> >  	.setxattr =	jffs2_setxattr,
> > @@ -98,8 +101,18 @@ static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target,
> >  			fd = fd_list;
> >  		}
> >  	}
> > -	if (fd)
> > -		ino = fd->ino;
> > +	if (fd) {
> > +		spin_lock(&target->d_lock);
> > +		switch(fd->type) {
> > +		case DT_WHT:
> > +			target->d_flags |= DCACHE_WHITEOUT;
> > +			break;
> > +		default:
> > +			ino = fd->ino;
> > +			break;
> > +		}
> > +		spin_unlock(&target->d_lock);
> > +	}
> 
> The switch statement above should be simplified into this:
> 
>  if (fd->type == DT_WHT)
> 	target->d_flags |= DCACHE_WHITEOUT;
>  else
> 	ino = fd->ino;

This is because later we add a third case for fallthrus, at which
point a switch statement is easier to read.  But it is confusing and
distracting by itself in this patch, so I changed it as you suggested.


> > +	/* If it's a directory, then check whether it is really empty
> > +	 */
> 
> Format above comment on one line.

Fixxed, thanks.

-VAL
