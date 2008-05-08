Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbYEHAlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbYEHAlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbYEHAl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:41:26 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:52544 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbYEHAlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:41:25 -0400
Date: Thu, 8 May 2008 02:41:24 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 06/24] hpfs: dont call notify_change
In-Reply-To: <20080506091413.165665963@szeredi.hu>
Message-ID: <Pine.LNX.4.64.0805080240470.11247@artax.karlin.mff.cuni.cz>
References: <20080506091327.259950960@szeredi.hu> <20080506091413.165665963@szeredi.hu>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

OK, commit the patch.

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

Mikulas

> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
> ---
>  fs/hpfs/namei.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/fs/hpfs/namei.c
> ===================================================================
> --- linux-2.6.orig/fs/hpfs/namei.c	2008-05-06 11:04:29.000000000 +0200
> +++ linux-2.6/fs/hpfs/namei.c	2008-05-06 11:04:34.000000000 +0200
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
