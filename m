Return-Path: <linux-kernel-owner+w=401wt.eu-S1751792AbZK3Hvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbZK3Hvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 02:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZK3Hvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 02:51:31 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:42106 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbZK3Hva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 02:51:30 -0500
Date: Mon, 30 Nov 2009 02:51:05 -0500
Message-Id: <200911300751.nAU7p53e022740@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Valerie Aurora <vaurora@redhat.com>
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
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:14 PDT."
             <1256152779-10054-17-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-17-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Felix Fietkau <nbd@openwrt.org>
> 
> Add support for whiteout dentries to jffs2.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: linux-mtd@lists.infradead.org
> ---
>  fs/jffs2/dir.c        |   77 +++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/jffs2/fs.c         |    4 ++
>  fs/jffs2/super.c      |    2 +-
>  include/linux/jffs2.h |    2 +
>  4 files changed, 82 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
> index 6f60cc9..46a2e1b 100644
> --- a/fs/jffs2/dir.c
> +++ b/fs/jffs2/dir.c
> @@ -34,6 +34,8 @@ static int jffs2_mknod (struct inode *,struct dentry *,int,dev_t);
>  static int jffs2_rename (struct inode *, struct dentry *,
>  			 struct inode *, struct dentry *);
>  
> +static int jffs2_whiteout (struct inode *, struct dentry *, struct dentry *);
> +
>  const struct file_operations jffs2_dir_operations =
>  {
>  	.read =		generic_read_dir,
> @@ -55,6 +57,7 @@ const struct inode_operations jffs2_dir_inode_operations =
>  	.rmdir =	jffs2_rmdir,
>  	.mknod =	jffs2_mknod,
>  	.rename =	jffs2_rename,
> +	.whiteout =     jffs2_whiteout,
>  	.permission =	jffs2_permission,
>  	.setattr =	jffs2_setattr,
>  	.setxattr =	jffs2_setxattr,
> @@ -98,8 +101,18 @@ static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target,
>  			fd = fd_list;
>  		}
>  	}
> -	if (fd)
> -		ino = fd->ino;
> +	if (fd) {
> +		spin_lock(&target->d_lock);
> +		switch(fd->type) {
> +		case DT_WHT:
> +			target->d_flags |= DCACHE_WHITEOUT;
> +			break;
> +		default:
> +			ino = fd->ino;
> +			break;
> +		}
> +		spin_unlock(&target->d_lock);
> +	}

The switch statement above should be simplified into this:

 if (fd->type == DT_WHT)
	target->d_flags |= DCACHE_WHITEOUT;
 else
	ino = fd->ino;

> +	/* If it's a directory, then check whether it is really empty
> +	 */

Format above comment on one line.

Erez.
