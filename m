Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbXIXO3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbXIXO3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 10:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbXIXO3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 10:29:08 -0400
Received: from twin.jikos.cz ([213.151.79.26]:37899 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbXIXO3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 10:29:07 -0400
Date: Mon, 24 Sep 2007 16:28:45 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Miloslav Semler <majkls@prepere.com>, bunk@kernel.org
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: backport of sysfs_readdir fix from 2.6.22.y to
 2.6.16.y (CVE-2007-3104)
In-Reply-To: <46F698FC.4040304@prepere.com>
Message-ID: <Pine.LNX.4.64.0709241627510.22331@twin.jikos.cz>
References: <46F698FC.4040304@prepere.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Adrian should be CCed on things regarding 2.6.16.y kernel)

On Sun, 23 Sep 2007, Miloslav Semler wrote:

> This patch solves CVE-2007-3104  - sysfs_readdir oops.
> More can be found here:
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=commit;h=dc351252b33f8fede396d6173dba117bcb933607
> 
> Signed-off-by: Miloslav Semler
> ---
> diff -uprN linux-2.6.16.53/fs/sysfs/dir.c linux-2.6.16.53-new/fs/sysfs/dir.c
> --- linux-2.6.16.53/fs/sysfs/dir.c      2007-07-25 23:05:45.000000000 +0200
> +++ linux-2.6.16.53-new/fs/sysfs/dir.c  2007-09-23 18:18:09.000000000 +0200
> @@ -29,6 +29,14 @@ static struct dentry_operations sysfs_de
>        .d_iput         = sysfs_d_iput,
> };
> 
> +static unsigned int sysfs_inode_counter;
> +ino_t sysfs_get_inum(void)
> +{
> +       if (unlikely(sysfs_inode_counter < 3))
> +               sysfs_inode_counter = 3;
> +       return sysfs_inode_counter++;
> +}
> +
> /*
>  * Allocates a new sysfs_dirent and links it to the parent sysfs_dirent
>  */
> @@ -40,8 +48,10 @@ static struct sysfs_dirent * sysfs_new_d
>        sd = kmem_cache_alloc(sysfs_dir_cachep, GFP_KERNEL);
>        if (!sd)
>                return NULL;
> +
> 
>        memset(sd, 0, sizeof(*sd));
> +       sd->s_ino = sysfs_get_inum();
>        atomic_set(&sd->s_count, 1);
>        INIT_LIST_HEAD(&sd->s_children);
>        list_add(&sd->s_sibling, &parent_sd->s_children);
> @@ -385,7 +395,7 @@ static int sysfs_readdir(struct file * f
> 
>        switch (i) {
>                case 0:
> -                       ino = dentry->d_inode->i_ino;
> +                        ino = parent_sd->s_ino;
>                        if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
>                                break;
>                        filp->f_pos++;
> @@ -415,10 +425,7 @@ static int sysfs_readdir(struct file * f
> 
>                                name = sysfs_get_name(next);
>                                len = strlen(name);
> -                               if (next->s_dentry)
> -                                       ino = next->s_dentry->d_inode->i_ino;
> -                               else
> -                                       ino = iunique(sysfs_sb, 2);
> +                                ino = next->s_ino;
> 
>                                if (filldir(dirent, name, len, filp->f_pos,
> ino,
>                                                 dt_type(next)) < 0)
> diff -uprN linux-2.6.16.53/fs/sysfs/inode.c
> linux-2.6.16.53-new/fs/sysfs/inode.c
> --- linux-2.6.16.53/fs/sysfs/inode.c    2007-07-25 23:05:45.000000000 +0200
> +++ linux-2.6.16.53-new/fs/sysfs/inode.c        2007-09-23 18:18:09.000000000
> +0200
> @@ -119,6 +119,7 @@ struct inode * sysfs_new_inode(mode_t mo
>                inode->i_mapping->a_ops = &sysfs_aops;
>                inode->i_mapping->backing_dev_info = 
> &sysfs_backing_dev_info;
>                inode->i_op = &sysfs_inode_operations;
> +                inode->i_ino = sd->s_ino;
> 
>                if (sd->s_iattr) {
>                        /* sysfs_dirent has non-default attributes
> diff -uprN linux-2.6.16.53/fs/sysfs/mount.c
> linux-2.6.16.53-new/fs/sysfs/mount.c
> --- linux-2.6.16.53/fs/sysfs/mount.c    2007-07-25 23:05:45.000000000 +0200
> +++ linux-2.6.16.53-new/fs/sysfs/mount.c        2007-09-23 18:18:09.000000000
> +0200
> @@ -29,6 +29,7 @@ static struct sysfs_dirent sysfs_root =
>        .s_element      = NULL,
>        .s_type         = SYSFS_ROOT,
>        .s_iattr        = NULL,
> +        .s_ino          = 1,
> };
> 
> static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
> diff -uprN linux-2.6.16.53/include/linux/sysfs.h
> linux-2.6.16.53-new/include/linux/sysfs.h
> --- linux-2.6.16.53/include/linux/sysfs.h       2007-07-25 23:05:45.000000000
> +0200
> +++ linux-2.6.16.53-new/include/linux/sysfs.h   2007-09-23 18:18:09.000000000
> +0200
> @@ -72,6 +72,7 @@ struct sysfs_dirent {
>        void                    * s_element;
>        int                     s_type;
>        umode_t                 s_mode;
> +        ino_t                   s_ino;
>        struct dentry           * s_dentry;
>        struct iattr            * s_iattr;
> };
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
