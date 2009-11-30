Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbZK3JFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbZK3JFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZK3JFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:05:23 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55223 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbZK3JFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:05:19 -0500
Date: Mon, 30 Nov 2009 04:04:50 -0500
Message-Id: <200911300904.nAU94o0k025981@agora.fsl.cs.sunysb.edu>
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
       linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [PATCH 22/41] union-mount: Some checks during namespace changes 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:20 PDT."
             <1256152779-10054-23-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-23-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Jan Blunck <jblunck@suse.de>
> 
> Add some additional checks when mounting something into an union.

The text "add some additional checks" seems to imply "code I forgot to add
earlier".  If this patch is better merged with some other one, then do so;
otherwise, the subject line and patch header need to give this patch more
credit than this: better explain what the checks are more precisely.

> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/namespace.c |   34 ++++++++++++++++++++++++++++++++++
>  1 files changed, 34 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 81b3188..dc01385 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -29,6 +29,7 @@
>  #include <linux/log2.h>
>  #include <linux/idr.h>
>  #include <linux/fs_struct.h>
> +#include <linux/union.h>
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
>  #include "pnode.h"
> @@ -1427,6 +1428,10 @@ static int do_change_type(struct path *path, int flag)
>  	if (path->dentry != path->mnt->mnt_root)
>  		return -EINVAL;
>  
> +	/* Don't change the type of union mounts */
> +	if (IS_MNT_UNION(path->mnt))
> +		return -EINVAL;
> +
>  	down_write(&namespace_sem);
>  	if (type == MS_SHARED) {
>  		err = invent_group_ids(mnt, recurse);
> @@ -1478,6 +1483,18 @@ static int do_loopback(struct path *path, char *old_name, int recurse,
>  	if (!mnt)
>  		goto out;
>  
> +	/*
> +	 * Unions couldn't be writable if the filesystem doesn't know about
> +	 * whiteouts
> +	 */
> +	err = -ENOTSUPP;
> +	if ((mnt_flags & MNT_UNION) &&
> +	    !(mnt->mnt_sb->s_flags & (MS_WHITEOUT|MS_RDONLY)))
> +		goto out;
> +
> +	if (mnt_flags & MNT_UNION)
> +		mnt->mnt_flags |= MNT_UNION;
> +
>  	err = graft_tree(mnt, path);
>  	if (err) {
>  		LIST_HEAD(umount_list);
> @@ -1571,6 +1588,13 @@ static int do_move_mount(struct path *path, char *old_name)
>  	if (err)
>  		return err;
>  
> +	/* moving to or from a union mount is not supported */
> +	err = -EINVAL;
> +	if (IS_MNT_UNION(path->mnt))
> +		goto exit;
> +	if (IS_MNT_UNION(old_path.mnt))
> +		goto exit;
> +
>  	down_write(&namespace_sem);
>  	while (d_mountpoint(path->dentry) &&
>  	       follow_down(path))
> @@ -1628,6 +1652,7 @@ out:
>  	up_write(&namespace_sem);
>  	if (!err)
>  		path_put(&parent_path);
> +exit:
>  	path_put(&old_path);
>  	return err;
>  }

I'd avoid using 'exit' as a label and goto name; use "out_err" or some other
out_XXX label.  'exit' is almost a reserved word in C. :-)

> @@ -1685,6 +1710,15 @@ int do_add_mount(struct vfsmount *newmnt, struct path *path,
>  	if (S_ISLNK(newmnt->mnt_root->d_inode->i_mode))
>  		goto unlock;
>  
> +	/*
> +	 * Unions couldn't be writable if the filesystem doesn't know about
> +	 * whiteouts
> +	 */
> +	err = -ENOTSUPP;
> +	if ((mnt_flags & MNT_UNION) &&
> +	    !(newmnt->mnt_sb->s_flags & (MS_WHITEOUT|MS_RDONLY)))
> +		goto unlock;
> +
>  	newmnt->mnt_flags = mnt_flags;
>  	if ((err = graft_tree(newmnt, path)))
>  		goto unlock;
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Erez.
