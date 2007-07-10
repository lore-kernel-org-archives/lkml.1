Return-Path: <linux-kernel-owner+w=401wt.eu-S1764092AbXGJXfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764092AbXGJXfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 19:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763305AbXGJXb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 19:31:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39232 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763996AbXGJXby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 19:31:54 -0400
Date: Tue, 10 Jul 2007 16:31:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cmm@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 4][PATCH 5/5] i_version: noversion mount option to
 disable inode version updates
Message-Id: <20070710163144.21b739f9.akpm@linux-foundation.org>
In-Reply-To: <1183275474.4010.132.camel@localhost.localdomain>
References: <1183275474.4010.132.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Jul 2007 03:37:53 -0400
Mingming Cao <cmm@us.ibm.com> wrote:

> Add a "noversion" mount option to disable inode version updates.

Why is this option being offered to our users?  To reduce disk traffic,
like noatime?

If so, what are the implications of this?  What would the user lose?

> Index: linux-2.6.21/fs/ext4/super.c
> ===================================================================
> --- linux-2.6.21.orig/fs/ext4/super.c
> +++ linux-2.6.21/fs/ext4/super.c
> @@ -725,7 +725,7 @@ enum {
>  	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
>  	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
>  	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
> -	Opt_grpquota, Opt_extents, Opt_noextents,
> +	Opt_grpquota, Opt_extents, Opt_noextents, Opt_noversion,
>  };
> 
>  static match_table_t tokens = {
> @@ -777,6 +777,7 @@ static match_table_t tokens = {
>  	{Opt_barrier, "barrier=%u"},
>  	{Opt_extents, "extents"},
>  	{Opt_noextents, "noextents"},
> +	{Opt_noversion, "noversion"},
>  	{Opt_err, NULL},
>  	{Opt_resize, "resize"},
>  };
> @@ -1115,6 +1116,9 @@ clear_qf_name:
>  		case Opt_noextents:
>  			clear_opt (sbi->s_mount_opt, EXTENTS);
>  			break;
> +		case Opt_noversion:
> +			set_opt(sbi->s_mount_opt, NOVERSION);
> +			break;
>  		default:
>  			printk (KERN_ERR
>  				"EXT4-fs: Unrecognized mount option \"%s\" "
> Index: linux-2.6.21/include/linux/ext4_fs.h
> ===================================================================
> --- linux-2.6.21.orig/include/linux/ext4_fs.h
> +++ linux-2.6.21/include/linux/ext4_fs.h
> @@ -473,6 +473,7 @@ do {									       \
>  #define EXT4_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
>  #define EXT4_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
>  #define EXT4_MOUNT_EXTENTS		0x400000 /* Extents support */
> +#define EXT4_MOUNT_NOVERSION		0x800000 /* No inode version updates */
> 
>  /* Compatibility, for having both ext2_fs.h and ext4_fs.h included at once */
>  #ifndef _LINUX_EXT2_FS_H
> Index: linux-2.6.21/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.21.orig/fs/ext4/inode.c
> +++ linux-2.6.21/fs/ext4/inode.c
> @@ -3082,7 +3082,9 @@ int ext4_mark_iloc_dirty(handle_t *handl
>  {
>  	int err = 0;
> 
> -	inode->i_version++;
> +	if (!test_opt(inode->i_sb, NOVERSION))
> +		inode->i_version++;
> +
>  	/* the do_update_inode consumes one bh->b_count */
>  	get_bh(iloc->bh);

An update to Documentation/filesystems/ext4.txt would be an appropriate
way in which to address the above questions.

