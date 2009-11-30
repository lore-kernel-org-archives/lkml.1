Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZK3Cdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZK3Cdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 21:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZK3Cde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 21:33:34 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34562 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZK3Cdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 21:33:33 -0500
Date: Sun, 29 Nov 2009 21:33:05 -0500
Message-Id: <200911300233.nAU2X5jp007432@agora.fsl.cs.sunysb.edu>
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
Subject: Re: [PATCH 07/41] VFS: Add read-only users count to superblock 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:05 PDT."
             <1256152779-10054-8-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-8-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> While we can check if a file system is currently read-only, we can't
> guarantee that it will stay read-only.  The file system can be
> remounted read-write at any time; it's also conceivable that a file
> system can be mounted a second time and converted to read-write if the
> underlying fs allows it.  This is a problem for union mounts, which
> require the underlying file system be read-only.  Add a read-only
> users count and don't allow remounts to change the file system to
> read-write or read-write mounts if there are any read-only users.
> 
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/super.c         |   14 ++++++++++++++
>  include/linux/fs.h |    5 +++++
>  2 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 2761d3e..c8140ac 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -553,6 +553,15 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
>  	}
>  	remount_rw = !(flags & MS_RDONLY) && (sb->s_flags & MS_RDONLY);
>  
> +	/* If we are remounting read/write, make sure that none of the
> +	   users require read-only for correct operation (such as
> +	   union mounts). */

Minor nit: but I think multi-line comments look better like this:

      /*
       * text
       */

> +	if (remount_rw && sb->s_readonly_users) {
> +		printk(KERN_INFO "%s: In use by %d read-only user(s)\n",
> +		       sb->s_id, sb->s_readonly_users);
> +		return -EROFS;
> +	}
> +
>  	if (sb->s_op->remount_fs) {
>  		retval = sb->s_op->remount_fs(sb, &flags, data);
>  		if (retval)
> @@ -889,6 +898,11 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
>   	if (error)
>   		goto out_sb;
>  
> +	error = -EROFS;
> +	if (!(flags & MS_RDONLY) &&
> +	    (mnt->mnt_sb->s_readonly_users))

Minor nit: two parts of '&&' in the above 'if' can go on same line and not
violate checkpatch.

> +		goto out_sb;
> +
>  	mnt->mnt_mountpoint = mnt->mnt_root;
>  	mnt->mnt_parent = mnt;
>  	up_write(&mnt->mnt_sb->s_umount);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 73e9b64..5fb7343 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1379,6 +1379,11 @@ struct super_block {
>  	 * generic_show_options()
>  	 */
>  	char *s_options;
> +
> +	/*
> +	 * Users who require read-only access - e.g., union mounts
> +	 */

Minor nit: for short one-line comments I prefer to save LoC:

      /* text */

> +	int s_readonly_users;
>  };
>  
>  extern struct timespec current_fs_time(struct super_block *sb);
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Erez.
