Return-Path: <linux-kernel-owner+w=401wt.eu-S1761649AbYHHVhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649AbYHHVhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbYHHVhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:37:39 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:59254 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbYHHVhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:37:38 -0400
Date: Fri, 8 Aug 2008 23:37:37 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [patch 04/14] hpfs: dont call notify_change
In-Reply-To: <E1KLhkW-0004y4-Ge@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0808082332580.28286@artax.karlin.mff.cuni.cz>
References: <20080722221259.866628660@szeredi.hu> <20080722221322.168296561@szeredi.hu>
 <Pine.LNX.4.64.0807231412070.1841@artax.karlin.mff.cuni.cz>
 <E1KLhkW-0004y4-Ge@pomaz-ex.szeredi.hu>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Jul 2008, Miklos Szeredi wrote:

> On Wed, 23 Jul 2008, Mikulas Patocka wrote:
>
> > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > 
> > > hpfs_unlink() calls notify_change() to truncate the file before
> > > deleting.  Replace with explicit call to hpfs_notify_change().
> > > 
> > > This is equivalent, except that:
> > >  - security_inode_setattr() is not called before hpfs_notify_change()
> > >  - fsnotify_change() is not called after hpfs_notify_change()
> > > 
> > > The truncation is just an implementation detail, so both the security
> > > check and the notification are unnecessary.
> > > 
> > > Possibly even the ctime modification is wrong?
> > > 
> > > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > > CC: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
> > > ---
> > >  fs/hpfs/namei.c |    3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > Index: linux-2.6/fs/hpfs/namei.c
> > > ===================================================================
> > > --- linux-2.6.orig/fs/hpfs/namei.c	2008-07-23 00:10:13.000000000 +0200
> > > +++ linux-2.6/fs/hpfs/namei.c	2008-07-23 00:10:22.000000000 +0200
> > > @@ -426,7 +426,8 @@ again:
> > >  			/*printk("HPFS: truncating file before delete.\n");*/
> > >  			newattrs.ia_size = 0;
> > >  			newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
> > > -			err = notify_change(dentry, &newattrs);
> > > +			newattrs.ia_ctime = current_fs_time(inode->i_sb);
> > > +			err = hpfs_notify_change(dentry, &newattrs);
> > >  			put_write_access(inode);
> > >  			if (!err)
> > >  				goto again;
> > > 
> > > --

> > What about down_write on i_alloc_sem --- notify change takes that and your 
> > patch bypasses that.
> 
> i_alloc_sem is only relevant if filesystem uses blockdev_direct_IO()
> and friends.  It is not used for anything else, so for hpfs there's no
> need to surround take that lock.
> 
> Thanks,
> Miklos
> 

I don't care much about this part anyway. This piece of code is not 
supposed to work reliably (what if the file has zero size or has fragments 
less then 2kb?), and if you change it to make it work more reliably under 
a circumstance when someone is deleting file he doesn't own, so what.

This is just design flaw of hpfs.

If you are certain about correctness of your patch, change it (but test 
it --- I placed a test partition at 
http://artax.karlin.mff.cuni.cz/~mikulas/vyplody/hpfs/test-hpfs-partition.gz). 

Or, the alternative is to remove the truncate code at all.

Mikulas
