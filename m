Return-Path: <linux-kernel-owner+w=401wt.eu-S1763114AbYD3Ruj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763114AbYD3Ruj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758718AbYD3Ru0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:50:26 -0400
Received: from mail.fieldses.org ([66.93.2.214]:47571 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758423AbYD3RuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:50:24 -0400
Date: Wed, 30 Apr 2008 13:50:21 -0400
To: "david m. richter" <richterd@citi.umich.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       willy@debian.org, viro@zeniv.linux.org.uk,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [LTP/VFS] fcntl SETLEASE fails on ramfs/tmpfs
Message-ID: <20080430175021.GC20377@fieldses.org>
References: <386072610804282042y2dda4b52h927683a8a938ce1f@mail.gmail.com> <20080429135454.efebec8f.akpm@linux-foundation.org> <20080429214231.GC26468@fieldses.org> <Pine.BSO.4.64.0804291821220.18333@citi.umich.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.BSO.4.64.0804291821220.18333@citi.umich.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 07:21:02PM -0400, david m. richter wrote:
> On Tue, 29 Apr 2008, J. Bruce Fields wrote:
> 
> > On Tue, Apr 29, 2008 at 01:54:54PM -0700, Andrew Morton wrote:
> > > On Tue, 29 Apr 2008 11:42:48 +0800
> > > "Bryan Wu" <cooloney@kernel.org> wrote:
> > > 
> > > > Hi folk,
> > > > 
> > > > This days I am digging into this LTP bug reported on our Blackfin test
> > > > machine, but I think it is general for other system.
> > > > https://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_id=141&tracker_item_id=3743
> > > > 
> > > > And I also found Kumar Gala reported this similar bug before.
> > > > http://lkml.org/lkml/2007/11/14/388
> > > > 
> > > > 1, when opening and creating a new on ramfs/tmpfs, the dentry->d_count
> > > > will be added one as below:
> > > > --
> > > > ramfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
> > > > {
> > > > |_______struct inode * inode = ramfs_get_inode(dir->i_sb, mode, dev);
> > > > |_______int error = -ENOSPC;
> > > > 
> > > > |_______if (inode) {
> > > > |_______|_______if (dir->i_mode & S_ISGID) {
> > > > |_______|_______|_______inode->i_gid = dir->i_gid;
> > > > |_______|_______|_______if (S_ISDIR(mode))
> > > > |_______|_______|_______|_______inode->i_mode |= S_ISGID;
> > > > |_______|_______}
> > > > |_______|_______d_instantiate(dentry, inode);
> > > > |_______|_______dget(dentry);|__/* Extra count - pin the dentry in core */
> > > > |_______|_______error = 0;
> > > > |_______|_______dir->i_mtime = dir->i_ctime = CURRENT_TIME;
> > > > |_______}
> > > > |_______return error;
> > > > }
> > > > --
> > > > The dget(dentry) call introduces an extra count, why?
> > > > it is the same in tmpfs.
> > > 
> > > Because those dentries have no backing store.  Their sole existance is in
> > > the dentry cache which is normally reclaimable.  But we can't reclaim these
> > > dentries because there is nowhere from where they can be reestablished.
> > > 
> > > > 2, when calling  fcntl(fd, F_SETLEASE,F_WRLCK), it will return -EAGAIN
> > > > --
> > > > |_______if ((arg == F_WRLCK)
> > > > |_______    && ((atomic_read(&dentry->d_count) > 1)
> > > > |_______|_______|| (atomic_read(&inode->i_count) > 1)))
> > > > |_______|_______goto out;
> > > > --
> > > 
> > > Sucky heuristic.
> > 
> > Yes.
> > 
> > > 
> > > > because the dentry->d_count will be 2 not 1. I tested ext2 on Blackfin, it is 1.
> > > > 
> > > > 3, so I guess maybe the dget(dentry) of ramfs_mknod is useless. But
> > > > after remove this dget(),
> > > > the ramfs can not be mounted as rootfs at all.
> > > 
> > > Interesting.  Presumably it got reclaimed synchronously somehow.
> > > 
> > > > Is the bug in generic_setlease() or in the ramfs/tmpfs inode create function?
> > > > 
> > > > Of course, simply remove the test '((atomic_read(&dentry->d_count) >
> > > > 1)' can workaround this issue.
> > > 
> > > I guess we should make the generic_setlease() heuristic smarter.
> > > 
> > > Of course the _reason_ for that heuristic is uncommented and lost in time. 
> > > And one wonders what locking prevents it from being totally racy, and if
> > > "none", what happens when the race hits.  Sigh.
> 
> 	i'm not sure which particular kernel version we're talking about, 
> but i think the intent was to rely on the BKL.  i noticed a couple cases 
> where this didn't actually hold -- e.g., bruce has a patch queued to move 
> the kmalloc in generic_setlease() so that it precedes the 
> d_count/i_writecount checks and covers the race he mentions below.  an 
> earlier patch closed a similar thing with get_write_access() when handling 
> a truncate, etc.
> 
> 	fyi (well, not you, bruce): relatedly, i have a set of patches to 
> introduce per-inode lease enabling/disabling (so we can fully implement 
> NFSv4.0 file delegations and v4.1 directory delegations) which expand the 
> cases where leases are broken (e.g. unlink) and which make it somewhat 
> more explicit when it's safe to lease/break.  perhaps the next merge 
> window for the first set of them.
> 
> 
> > Yes, I think the race is:
> > 
> > 	1. generic_setlease(., F_WRLCK, .) checks d_count and i_count,
> > 	   both are 1.
> > 
> > 	2. a read open comes in, calls break_lease which finds no lease
> > 	   and continues happily on.
> > 
> > 	3. generic_setlease() sets the write lease.
> > 
> > The most likely consequences are that a local reader gets out-of-date
> > data for a file that a Samba client has modified.
> >
> > I suppose that re-checking the d_count and i_count after step 3 might
> > close the race.
> 
> 	as things currently stand, i believe that race can only happen if 
> the leaser is blocking on the kmalloc.

Neither break_lease() (the shortcut inlined function, not the full
__break_lease()) nor any of the open code that I can see is under the
BKL, so unless I'm missing something, that code is racy.

--b.

> but yeah, the d_count check is 
> pretty frail anyway ...
> 
> 
> > > I suppose a stupid fix would be to set (and later clear) a new flag in
> > > dentry.d_flags which means
> > > 
> > >   this dentry is pinned by a ram-backed device, so d_count==2 means
> > >   "unused""
> > > 
> > > But it would be better to work out exactly what generic_setlease() is
> > > trying to do there, and do it in a better way.
> > 
> > Yes.  What it's supposed to do is provide exclusion between opens and
> > write leases.
> > 
> > We already have a mechanism that provides exclusion between write opens
> > and exec, using the i_writecount, so we're using that for read leases.
> > I suppose it'd be possible to do something similar for write leases;
> > would there be smp scalability problems associated with counting all the
> > read opens of a given inode?  Other problems?
> > 
> > Even with this problem solved, I'm not convinced write leases are very
> > useful as implemented.  Their only current user is Samba, which uses
> > them to grant exclusive access to given files to allow clients to cache
> > writes.
> > 
> > Samba knows when to revoke that exclusive access because the lease
> > subsystem signals it on a read open of the file.  It doesn't revoke on
> > stat, however.  This causes problem.  E.g., say Samba takes out a lease
> > and tells some client it can now cache its writes indefinitely.
> > Meanwhile a local application (say, make) is polling that file for
> > changes using stat.  They never see those changes.
> > 
> > The NFSv2/v3 server for some reason has its own one-off hack that
> > reports the ctime as now for on any write-leased file, which leads
> > people to complain about spurious rebuilds:
> > 
> > 	http://bugzilla.kernel.org/show_bug.cgi?id=9454
> > 
> > The one thing I suspect is *not* a really serious problem here is the
> > reported LTP failure, since probably the only user of this is Samba,
> > which probably doesn't do a lot of tmpfs exports, and in any case it can
> > probably soldier on (if with degraded performance--how badly I don't
> > know) without getting the write lease it wants.
> > 
> > --b.
> > 
