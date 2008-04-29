Return-Path: <linux-kernel-owner+w=401wt.eu-S1762999AbYD2Uzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762999AbYD2Uzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762629AbYD2Uzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:55:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762529AbYD2Uzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:55:39 -0400
Date: Tue, 29 Apr 2008 13:54:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Bryan Wu" <cooloney@kernel.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       willy@debian.org, viro@zeniv.linux.org.uk,
       uclinux-dist-devel@blackfin.uclinux.org,
       "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [LTP/VFS] fcntl SETLEASE fails on ramfs/tmpfs
Message-Id: <20080429135454.efebec8f.akpm@linux-foundation.org>
In-Reply-To: <386072610804282042y2dda4b52h927683a8a938ce1f@mail.gmail.com>
References: <386072610804282042y2dda4b52h927683a8a938ce1f@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 11:42:48 +0800
"Bryan Wu" <cooloney@kernel.org> wrote:

> Hi folk,
> 
> This days I am digging into this LTP bug reported on our Blackfin test
> machine, but I think it is general for other system.
> https://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_id=141&tracker_item_id=3743
> 
> And I also found Kumar Gala reported this similar bug before.
> http://lkml.org/lkml/2007/11/14/388
> 
> 1, when opening and creating a new on ramfs/tmpfs, the dentry->d_count
> will be added one as below:
> --
> ramfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
> {
> |_______struct inode * inode = ramfs_get_inode(dir->i_sb, mode, dev);
> |_______int error = -ENOSPC;
> 
> |_______if (inode) {
> |_______|_______if (dir->i_mode & S_ISGID) {
> |_______|_______|_______inode->i_gid = dir->i_gid;
> |_______|_______|_______if (S_ISDIR(mode))
> |_______|_______|_______|_______inode->i_mode |= S_ISGID;
> |_______|_______}
> |_______|_______d_instantiate(dentry, inode);
> |_______|_______dget(dentry);|__/* Extra count - pin the dentry in core */
> |_______|_______error = 0;
> |_______|_______dir->i_mtime = dir->i_ctime = CURRENT_TIME;
> |_______}
> |_______return error;
> }
> --
> The dget(dentry) call introduces an extra count, why?
> it is the same in tmpfs.

Because those dentries have no backing store.  Their sole existance is in
the dentry cache which is normally reclaimable.  But we can't reclaim these
dentries because there is nowhere from where they can be reestablished.

> 2, when calling  fcntl(fd, F_SETLEASE,F_WRLCK), it will return -EAGAIN
> --
> |_______if ((arg == F_WRLCK)
> |_______    && ((atomic_read(&dentry->d_count) > 1)
> |_______|_______|| (atomic_read(&inode->i_count) > 1)))
> |_______|_______goto out;
> --

Sucky heuristic.

> because the dentry->d_count will be 2 not 1. I tested ext2 on Blackfin, it is 1.
> 
> 3, so I guess maybe the dget(dentry) of ramfs_mknod is useless. But
> after remove this dget(),
> the ramfs can not be mounted as rootfs at all.

Interesting.  Presumably it got reclaimed synchronously somehow.

> Is the bug in generic_setlease() or in the ramfs/tmpfs inode create function?
> 
> Of course, simply remove the test '((atomic_read(&dentry->d_count) >
> 1)' can workaround this issue.

I guess we should make the generic_setlease() heuristic smarter.

Of course the _reason_ for that heuristic is uncommented and lost in time. 
And one wonders what locking prevents it from being totally racy, and if
"none", what happens when the race hits.  Sigh.

I suppose a stupid fix would be to set (and later clear) a new flag in
dentry.d_flags which means

  this dentry is pinned by a ram-backed device, so d_count==2 means
  "unused""

But it would be better to work out exactly what generic_setlease() is
trying to do there, and do it in a better way.
