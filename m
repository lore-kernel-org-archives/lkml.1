Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbYGWMke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbYGWMke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 08:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbYGWMkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 08:40:22 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:49023 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYGWMkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 08:40:20 -0400
X-Greylist: delayed 1638 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2008 08:40:20 EDT
Date: Wed, 23 Jul 2008 14:13:01 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [patch 04/14] hpfs: dont call notify_change
In-Reply-To: <20080722221322.168296561@szeredi.hu>
Message-ID: <Pine.LNX.4.64.0807231412070.1841@artax.karlin.mff.cuni.cz>
References: <20080722221259.866628660@szeredi.hu> <20080722221322.168296561@szeredi.hu>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What about down_write on i_alloc_sem --- notify change takes that and your 
patch bypasses that.

Mikulas

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> hpfs_unlink() calls notify_change() to truncate the file before
> deleting.  Replace with explicit call to hpfs_notify_change().
> 
> This is equivalent, except that:
>  - security_inode_setattr() is not called before hpfs_notify_change()
>  - fsnotify_change() is not called after hpfs_notify_change()
> 
> The truncation is just an implementation detail, so both the security
> check and the notification are unnecessary.
> 
> Possibly even the ctime modification is wrong?
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
> ---
>  fs/hpfs/namei.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/fs/hpfs/namei.c
> ===================================================================
> --- linux-2.6.orig/fs/hpfs/namei.c	2008-07-23 00:10:13.000000000 +0200
> +++ linux-2.6/fs/hpfs/namei.c	2008-07-23 00:10:22.000000000 +0200
> @@ -426,7 +426,8 @@ again:
>  			/*printk("HPFS: truncating file before delete.\n");*/
>  			newattrs.ia_size = 0;
>  			newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
> -			err = notify_change(dentry, &newattrs);
> +			newattrs.ia_ctime = current_fs_time(inode->i_sb);
> +			err = hpfs_notify_change(dentry, &newattrs);
>  			put_write_access(inode);
>  			if (!err)
>  				goto again;
> 
> --
> 
