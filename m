Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYD2Vmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYD2Vmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbYD2Vmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:42:35 -0400
Received: from mail.fieldses.org ([66.93.2.214]:57827 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbYD2Vme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:42:34 -0400
Date: Tue, 29 Apr 2008 17:42:31 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bryan Wu <cooloney@kernel.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, willy@debian.org,
       viro@zeniv.linux.org.uk, uclinux-dist-devel@blackfin.uclinux.org,
       richterd@citi.umich.edu
Subject: Re: [LTP/VFS] fcntl SETLEASE fails on ramfs/tmpfs
Message-ID: <20080429214231.GC26468@fieldses.org>
References: <386072610804282042y2dda4b52h927683a8a938ce1f@mail.gmail.com> <20080429135454.efebec8f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429135454.efebec8f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 01:54:54PM -0700, Andrew Morton wrote:
> On Tue, 29 Apr 2008 11:42:48 +0800
> "Bryan Wu" <cooloney@kernel.org> wrote:
> 
> > Hi folk,
> > 
> > This days I am digging into this LTP bug reported on our Blackfin test
> > machine, but I think it is general for other system.
> > https://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_id=141&tracker_item_id=3743
> > 
> > And I also found Kumar Gala reported this similar bug before.
> > http://lkml.org/lkml/2007/11/14/388
> > 
> > 1, when opening and creating a new on ramfs/tmpfs, the dentry->d_count
> > will be added one as below:
> > --
> > ramfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
> > {
> > |_______struct inode * inode = ramfs_get_inode(dir->i_sb, mode, dev);
> > |_______int error = -ENOSPC;
> > 
> > |_______if (inode) {
> > |_______|_______if (dir->i_mode & S_ISGID) {
> > |_______|_______|_______inode->i_gid = dir->i_gid;
> > |_______|_______|_______if (S_ISDIR(mode))
> > |_______|_______|_______|_______inode->i_mode |= S_ISGID;
> > |_______|_______}
> > |_______|_______d_instantiate(dentry, inode);
> > |_______|_______dget(dentry);|__/* Extra count - pin the dentry in core */
> > |_______|_______error = 0;
> > |_______|_______dir->i_mtime = dir->i_ctime = CURRENT_TIME;
> > |_______}
> > |_______return error;
> > }
> > --
> > The dget(dentry) call introduces an extra count, why?
> > it is the same in tmpfs.
> 
> Because those dentries have no backing store.  Their sole existance is in
> the dentry cache which is normally reclaimable.  But we can't reclaim these
> dentries because there is nowhere from where they can be reestablished.
> 
> > 2, when calling  fcntl(fd, F_SETLEASE,F_WRLCK), it will return -EAGAIN
> > --
> > |_______if ((arg == F_WRLCK)
> > |_______    && ((atomic_read(&dentry->d_count) > 1)
> > |_______|_______|| (atomic_read(&inode->i_count) > 1)))
> > |_______|_______goto out;
> > --
> 
> Sucky heuristic.

Yes.

> 
> > because the dentry->d_count will be 2 not 1. I tested ext2 on Blackfin, it is 1.
> > 
> > 3, so I guess maybe the dget(dentry) of ramfs_mknod is useless. But
> > after remove this dget(),
> > the ramfs can not be mounted as rootfs at all.
> 
> Interesting.  Presumably it got reclaimed synchronously somehow.
> 
> > Is the bug in generic_setlease() or in the ramfs/tmpfs inode create function?
> > 
> > Of course, simply remove the test '((atomic_read(&dentry->d_count) >
> > 1)' can workaround this issue.
> 
> I guess we should make the generic_setlease() heuristic smarter.
> 
> Of course the _reason_ for that heuristic is uncommented and lost in time. 
> And one wonders what locking prevents it from being totally racy, and if
> "none", what happens when the race hits.  Sigh.

Yes, I think the race is:

	1. generic_setlease(., F_WRLCK, .) checks d_count and i_count,
	   both are 1.

	2. a read open comes in, calls break_lease which finds no lease
	   and continues happily on.

	3. generic_setlease() sets the write lease.

The most likely consequences are that a local reader gets out-of-date
data for a file that a Samba client has modified.

I suppose that re-checking the d_count and i_count after step 3 might
close the race.

> I suppose a stupid fix would be to set (and later clear) a new flag in
> dentry.d_flags which means
> 
>   this dentry is pinned by a ram-backed device, so d_count==2 means
>   "unused""
> 
> But it would be better to work out exactly what generic_setlease() is
> trying to do there, and do it in a better way.

Yes.  What it's supposed to do is provide exclusion between opens and
write leases.

We already have a mechanism that provides exclusion between write opens
and exec, using the i_writecount, so we're using that for read leases.
I suppose it'd be possible to do something similar for write leases;
would there be smp scalability problems associated with counting all the
read opens of a given inode?  Other problems?

Even with this problem solved, I'm not convinced write leases are very
useful as implemented.  Their only current user is Samba, which uses
them to grant exclusive access to given files to allow clients to cache
writes.

Samba knows when to revoke that exclusive access because the lease
subsystem signals it on a read open of the file.  It doesn't revoke on
stat, however.  This causes problem.  E.g., say Samba takes out a lease
and tells some client it can now cache its writes indefinitely.
Meanwhile a local application (say, make) is polling that file for
changes using stat.  They never see those changes.

The NFSv2/v3 server for some reason has its own one-off hack that
reports the ctime as now for on any write-leased file, which leads
people to complain about spurious rebuilds:

	http://bugzilla.kernel.org/show_bug.cgi?id=9454

The one thing I suspect is *not* a really serious problem here is the
reported LTP failure, since probably the only user of this is Samba,
which probably doesn't do a lot of tmpfs exports, and in any case it can
probably soldier on (if with degraded performance--how badly I don't
know) without getting the write lease it wants.

--b.
