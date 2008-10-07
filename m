Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbYJGJQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbYJGJQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 05:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYJGJQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 05:16:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:46773 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbYJGJQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 05:16:33 -0400
Message-ID: <48EB27FE.2090009@kernel.org>
Date: Tue, 07 Oct 2008 18:12:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Thery <benjamin.thery@bull.net>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sysfs: tagged directories not merged completely yet
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com> <48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org> <20081003101331.GH28946@ZenIV.linux.org.uk>
In-Reply-To: <20081003101331.GH28946@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Oct 2008 09:14:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Al.

Thanks for reviewing.  I'll reply to what I can from the top of my
head for now.

Al Viro wrote:
> c) You do *not* change dentry tree topology without s_vfs_rename_mutex on
> affected superblock.  That, BTW, is broken in mainline sysfs as well.

Hmmm...

	/*
	 * The next field is for VFS *only*. No filesystems have any business
	 * even looking at it. You had been warned.
	 */
	struct mutex s_vfs_rename_mutex;	/* Kludge */

How is a distributed filesystem supposed to do this?

> In addition to that, there are interesting internal problems:
> * inumbers are released by final sysfs_put(); that can happen before the
> final iput() on corresponding inode.  Guess what happens if new entry is
> created in the meanwhile, reuses the same inumber and lookup gets to
> sysfs_get_inode() on it?

Heh... right.  Will fix.

> * may I politely suggest that
> again:
> 	mutex_lock(&A);
> 	if (!mutex_trylock(&B)) {
> 		mutex_unlock(&A);
> 		goto again;
> 	}
> is somewhat, er, deficient way to deal with buggered locking hierarchy?
> Not to mention anything else, that's obviously FUBAR on UP box - if we
> have B contended, we've just killed the box dead since we'll never give
> the CPU back to whoever happens to hold B.  See sysfs_mv_dir() for a lovely
> example.

Yeah, that was dumb.  I should have just used inode_double_lock()
there.

> * sysfs_count_nlink() is called from sysfs_fill_super() without sysfs_mutex;
> now this sucker can get called at any moment.

In mainline, being single sb fs, it was okay.  Yeah, it now needs to
be fixed.

> * __sysfs_remove_dir() appears to assume that subdirectories are possible;
> AFAICS, if we *do* get them, we get very screwed after remove_dir().

sysfs currently requires its users to remove all the children before
removing a directory, which is a bit dumb.  I once posted patches to
make remove recursive and am still planning on refreshing and posting
them.

> * everything else aside, the internal locking is extremely heavy.  For
> fsck sake, guys, a single system-wide mutex that can be grabbed for the
> duration of readdir on any directory and block just about anything
> in the filesystem?  Just mmap() something over NFS on a slow link and
> do getdents() to such buffer.  Watch a *lot* of stuff getting buggered.
> Hell, you can't even do ifconfig up while that sucker is held...

Ah.. right, filler can be an issue but all other operations are from
memory to memory, there just isn't much point in elaborating its
locking.  Memory usage has been a much bigger problem and making
locking per sysfs_dirent increases memory consumption and on
crazy-large irons things like that become quite noticeable.

If the filler is a real concern, I think it's better to just decouple
it rather than making sysfs locking fine-grained.  sysfs metadata
might as well be protected by a single spinlock if it can be decoupled
from vfs locking and stuff.  It's just an in-memory tree which isn't
used too often.

> Seriously, people, it's getting worse than devfs had ever been ;-/

I don't know about devfs either but sysfs today is in much better
shape than say about one and half year ago.  Triggering deadlocks and
oopses from userland was quite easy back then.

Generally, the VFS layer isn't too easy for sysfs which is a bit like
distributed filesystem but has more strict here-and-now rule (all
changes should be visible instantaneously).  At the beginning, sysfs
didn't have much metadata itself, it just used the VFS data structures
but that was too large so sysfs_dirent got introduced and it tried to
update VFS data structures as necessary and (this is when I started
working on it) the current code and Eric's patcheset evolved from
there.

Maybe it can be done better by taking more traditional distributed
filesystem approach - re/invalidation on access.  I don't know whether
it will fit sysfs's needs but if it can be done, sysfs would be able
to ride along with other distributed filesystems and become much more
conventional in its interfacing with VFS.

Thanks.

-- 
tejun
