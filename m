Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYGWRDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYGWRDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 13:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYGWRDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 13:03:39 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46138 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYGWRDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:03:39 -0400
To: mikulas@artax.karlin.mff.cuni.cz
CC: miklos@szeredi.hu, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
In-reply-to: <Pine.LNX.4.64.0807231412070.1841@artax.karlin.mff.cuni.cz>
	(message from Mikulas Patocka on Wed, 23 Jul 2008 14:13:01 +0200
	(CEST))
Subject: Re: [patch 04/14] hpfs: dont call notify_change
References: <20080722221259.866628660@szeredi.hu> <20080722221322.168296561@szeredi.hu> <Pine.LNX.4.64.0807231412070.1841@artax.karlin.mff.cuni.cz>
Message-Id: <E1KLhkW-0004y4-Ge@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 Jul 2008 19:03:36 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2008, Mikulas Patocka wrote:
> What about down_write on i_alloc_sem --- notify change takes that and your 
> patch bypasses that.

i_alloc_sem is only relevant if filesystem uses blockdev_direct_IO()
and friends.  It is not used for anything else, so for hpfs there's no
need to surround take that lock.

Thanks,
Miklos

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > hpfs_unlink() calls notify_change() to truncate the file before
> > deleting.  Replace with explicit call to hpfs_notify_change().
> > 
> > This is equivalent, except that:
> >  - security_inode_setattr() is not called before hpfs_notify_change()
> >  - fsnotify_change() is not called after hpfs_notify_change()
> > 
> > The truncation is just an implementation detail, so both the security
> > check and the notification are unnecessary.
> > 
> > Possibly even the ctime modification is wrong?
> > 
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > CC: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
> > ---
> >  fs/hpfs/namei.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6/fs/hpfs/namei.c
> > ===================================================================
> > --- linux-2.6.orig/fs/hpfs/namei.c	2008-07-23 00:10:13.000000000 +0200
> > +++ linux-2.6/fs/hpfs/namei.c	2008-07-23 00:10:22.000000000 +0200
> > @@ -426,7 +426,8 @@ again:
> >  			/*printk("HPFS: truncating file before delete.\n");*/
> >  			newattrs.ia_size = 0;
> >  			newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
> > -			err = notify_change(dentry, &newattrs);
> > +			newattrs.ia_ctime = current_fs_time(inode->i_sb);
> > +			err = hpfs_notify_change(dentry, &newattrs);
> >  			put_write_access(inode);
> >  			if (!err)
> >  				goto again;
> > 
> > --
> > 
> 
