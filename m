Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbYBWNjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbYBWNjW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 08:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbYBWNjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 08:39:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45507 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbYBWNjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 08:39:04 -0500
Date: Sat, 23 Feb 2008 13:38:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: haveblue@us.ibm.com, linux-kernel@vger.kernel.org, hch@lst.de,
       akpm@osdl.org
Subject: Re: [PATCH 09/30] r/o bind mounts: drop write during emergency remount
Message-ID: <20080223133854.GQ27894@ZenIV.linux.org.uk>
References: <20080215223721.9E0A088A@kernel> <20080215223732.42E46571@kernel> <E1JR8rj-0003ul-Di@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JR8rj-0003ul-Di@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 05:29:15PM +0100, Miklos Szeredi wrote:
> >  	file_list_lock();
> >  	list_for_each_entry(f, &sb->s_files, f_u.fu_list) {
> > -		if (S_ISREG(f->f_path.dentry->d_inode->i_mode) && file_count(f))
> > -			f->f_mode &= ~FMODE_WRITE;
> > +		struct vfsmount *mnt;
> > +		if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
> > +		       continue;
> > +		if (!file_count(f))
> > +			continue;
> > +		if (!(f->f_mode & FMODE_WRITE))
> > +			continue;
> > +		f->f_mode &= ~FMODE_WRITE;
> > +		mnt = f->f_path.mnt;
> 
> AFAICS an mntget() is needed here to make sure mnt doesn't go away
> after releasing file_list_lock.

	Good catch, but... that's not all.  We also have to move
drop_file_write_access() in __fput() past the file_kill(), or we'll
get a race here - CPU 1 enters that loop, sees ->f_count 1, checks
that file is writable, CPU 2 does final fput() and proceeds to
do drop_file_write_access() and mnt_drop_write().  CPU 1, in the
meanwhile, removes FMODE_WRITE and goes on to do mnt_drop_write()
itself.

	Oh, well...  Fixed.
