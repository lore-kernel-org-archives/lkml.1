Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbYEETp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbYEETp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYEETpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:45:19 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:50310 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYEETpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:45:17 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 08/15] fat: dont call notify_change
References: <20080505095440.820370974@szeredi.hu>
	<20080505095518.844178123@szeredi.hu>
Date: Tue, 06 May 2008 04:45:02 +0900
In-Reply-To: <20080505095518.844178123@szeredi.hu> (Miklos Szeredi's message
	of "Mon, 05 May 2008 11:54:49 +0200")
Message-ID: <87myn4lem9.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> From: Miklos Szeredi <mszeredi@suse.cz>
>
> The FAT_IOCTL_SET_ATTRIBUTES ioctl() calls notify_change() to change
> the file mode before changing the inode attributes.  Replace with
> explicit call to fat_setattr().
>
> This is equivalent, except that security_inode_setattr() is not called
> before fat_setattr().  I think this is not needed, since the mode
> change is just a side effect of the attribute change.
>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Looks good. I'm not sure about the intent of security_inode_setattr()
though.

> Index: linux-2.6/fs/fat/file.c
> ===================================================================
> --- linux-2.6.orig/fs/fat/file.c	2008-05-05 11:29:20.000000000 +0200
> +++ linux-2.6/fs/fat/file.c	2008-05-05 11:29:26.000000000 +0200
> @@ -16,6 +16,7 @@
>  #include <linux/writeback.h>
>  #include <linux/backing-dev.h>
>  #include <linux/blkdev.h>
> +#include <linux/fsnotify.h>
>  
>  int fat_generic_ioctl(struct inode *inode, struct file *filp,
>  		      unsigned int cmd, unsigned long arg)
> @@ -65,6 +66,7 @@ int fat_generic_ioctl(struct inode *inod
>  
>  		/* Equivalent to a chmod() */
>  		ia.ia_valid = ATTR_MODE | ATTR_CTIME;
> +		ia.ia_ctime = current_fs_time(inode->i_sb);
>  		if (is_dir) {
>  			ia.ia_mode = MSDOS_MKMODE(attr,
>  				S_IRWXUGO & ~sbi->options.fs_dmask)
> @@ -92,10 +94,11 @@ int fat_generic_ioctl(struct inode *inod
>  		}
>  
>  		/* This MUST be done before doing anything irreversible... */
> -		err = notify_change(filp->f_path.dentry, &ia);
> +		err = fat_setattr(filp->f_path.dentry, &ia);
>  		if (err)
>  			goto up;
>  
> +		fsnotify_change(filp->f_path.dentry, ia.ia_valid);
>  		if (sbi->options.sys_immutable) {
>  			if (attr & ATTR_SYS)
>  				inode->i_flags |= S_IMMUTABLE;
>
> --

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
