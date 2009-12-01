Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZLAEPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZLAEPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 23:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZLAEPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 23:15:15 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:51137 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbZLAEPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 23:15:13 -0500
Date: Mon, 30 Nov 2009 23:14:48 -0500
Message-Id: <200912010414.nB14EmKH030404@agora.fsl.cs.sunysb.edu>
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
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 30/41] fallthru: Basic fallthru definitions 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:28 PDT."
             <1256152779-10054-31-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, your patch set has an awkward order: you have some vfs and ext2/tmpfs
patches, then UM patches, then fallthru patches for specific file systems,
then UM patches again.  Is it possible to order them so all UM patches go in
order; all lower-level F/S patches are also sequential; etc.?

In message <1256152779-10054-31-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> Define the fallthru dcache flag and file system op.
> 
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  include/linux/dcache.h |    6 ++++++
>  include/linux/fs.h     |    1 +
>  2 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index 730c432..a55f79f 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -193,6 +193,7 @@ d_iput:		no		no		no       yes
>  
>  #define DCACHE_COOKIE		0x0040	/* For use by dcookie subsystem */
>  #define DCACHE_WHITEOUT		0x0080	/* This negative dentry is a whiteout */
> +#define DCACHE_FALLTHRU		0x0100	/* Keep looking in the file system below */
>  
>  #define DCACHE_FSNOTIFY_PARENT_WATCHED	0x0080 /* Parent inode is watched by some fsnotify listener */
>  
> @@ -381,6 +382,11 @@ static inline int d_is_whiteout(struct dentry *dentry)
>  	return (dentry->d_flags & DCACHE_WHITEOUT);
>  }
>  
> +static inline int d_is_fallthru(struct dentry *dentry)
> +{
> +	return (dentry->d_flags & DCACHE_FALLTHRU);
> +}
> +
>  static inline struct dentry *dget_parent(struct dentry *dentry)
>  {
>  	struct dentry *ret;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index efea78c..57690ab 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1532,6 +1532,7 @@ struct inode_operations {
>  	int (*rmdir) (struct inode *,struct dentry *);
>  	int (*mknod) (struct inode *,struct dentry *,int,dev_t);
>  	int (*whiteout) (struct inode *, struct dentry *, struct dentry *);
> +	int (*fallthru) (struct inode *, struct dentry *);

Same nit I had before: why add ->fallthru in the middle of inode_operations
and not in the end?

>  	int (*rename) (struct inode *, struct dentry *,
>  			struct inode *, struct dentry *);
>  	int (*readlink) (struct dentry *, char __user *,int);
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Erez.
