Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbYEHAmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbYEHAmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYEHAmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:42:21 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:43752 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbYEHAmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:42:20 -0400
Date: Thu, 8 May 2008 02:42:09 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 07/15] hpfs: dont call notify_change
In-Reply-To: <20080505095517.214430823@szeredi.hu>
Message-ID: <Pine.LNX.4.64.0805080241490.11247@artax.karlin.mff.cuni.cz>
References: <20080505095440.820370974@szeredi.hu> <20080505095517.214430823@szeredi.hu>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 May 2008, Miklos Szeredi wrote:

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

Ok, commit it.

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
> ---
>  fs/hpfs/namei.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/fs/hpfs/namei.c
> ===================================================================
> --- linux-2.6.orig/fs/hpfs/namei.c	2008-05-05 11:29:20.000000000 +0200
> +++ linux-2.6/fs/hpfs/namei.c	2008-05-05 11:29:26.000000000 +0200
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
