Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbXKWVUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbXKWVUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 16:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbXKWVUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 16:20:22 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34774 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbXKWVUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 16:20:20 -0500
Date: Fri, 23 Nov 2007 16:20:06 -0500
Message-Id: <200711232120.lANLK6YO028507@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org
Subject: Re: unionfs: several more problems 
In-reply-to: Your message of "Tue, 20 Nov 2007 19:14:59 GMT."
             <Pine.LNX.4.64.0711201802480.9934@blonde.wat.veritas.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0711201802480.9934@blonde.wat.veritas.com>, Hugh Dickins writes:
[...]
> > I deceived myself for a while that the danger of shmem_writepage
> > hitting its BUG_ON(entry->val) was dealt with too; but that's wrong,
> > I must go back to working out an escape from that one (despite never
> > seeing it).
> 
> Once I tried a more appropriate test (fsx while swapping) I hit that
> easily.  After some thought and testing, I'm happy with the mm/shmem.c
> +mm/swap_state.c fixes I've arrived at for that; but since it's not
> easy to reproduce in normal usage, and hasn't been holding you up,
> I'd prefer for the moment to hold on to that patch.  I need to make
> changes around the same pagecache<->swapcache area to solve some mem
> cgroup issues: there might turn out to be some interaction, so I'd
> rather finalize both patches in the same series if I can.
[...]

If you want, send me those patches and I'll run them w/ my tests, even if
they're not finalized; my testing can give you another useful point of
reference.

> But perhaps before fixing up the several LTP tests, you'll want
> to concentrate on a more directed test.  Please try this sequence:
> 
> 			# Running with mem=512M, probably irrelevant
> swapoff -a		# Merely to rule out one potential confusion
> mkfs -t ext2 /dev/sdb1
> mount -t ext2 /dev/sdb1 /mnt
> df /mnt			# I have 2280 Used out of 1517920 KB
> cp -a 2.6.24-rc3 /mnt	# Copy a kernel source tree into ext2
> rm -rf /mnt/2.6.24-rc3	# Delete the copy
> df /mnt			# Again 2280 Used, just as you'd expect
> mount -t unionfs -o dirs=/mnt unionfs /tmp
> cp -a 2.6.24-rc3 /tmp	# Copy a kernel source tree into unionfs
> rm -rf /tmp/2.6.24-rc3	# Generates 176 unionfs: filldir error messages
> df /mnt			# Now 68380 Used (df /tmp shows the same)
> ls -a /mnt		# Shows .  ..  .wh.2.6.24-rc3  lost+found
> echo 1 >/proc/sys/vm/drop_caches	# to free pagecache
> df /mnt			# Still 68380 Used (df /tmp shows the same)
> echo 2 >/proc/sys/vm/drop_caches	# to free dentries and inodes
> df /mnt			# Now 2280 Used as it should be (df /tmp same)
> ls -a /mnt		# But still shows that .wh.2.6.24-rc3
> umount /tmp		# Restore
> umount /mnt		# Restore
> swapon -a		# Restore
> 
> Three different problems there:
> 
> 1. Whiteouts seem to get left behind (at this top level anyway):
> I'm getting an increasing number of .wh.run-crons.????? files there.
> I'm not familiar with the correct behaviour for whiteouts (and it's
> not clear to me why whiteouts are needed at all in this degenerate
> case of a single directory in the union, but never mind).

I could spend a lot of time explaining the history of whiteouts in unioning
file systems, and all the different techniques and algorithms we've tried
ourselves over the years.  But suffice to say that I'd be very happy the day
every Linux f/s has a native whiteout support. :-)

Our current policy for when/where to create whiteouts has evolved after much
experience with users.  The most common use case for unionfs is one or more
read-only branches, plus a high-priority writable branch (for copyup).
Therefore, in the most common case we cannot remove the objects from the
readonly branches, and have to create a whiteout instead.

Using a single branch with unionfs is very uncommon among unionfs users, but
it serves nicely as a useful "null layer" testing (ala BSD's Nullfs or my
fistgen's wrapfs).

Anyway, upon further thinking about this issue I realized that whiteouts in
the single-branch situation are just a generalization of a possibly more
common case -- when the object being unlink'ed (or rmdir'ed) is on the
rightmost, lowest priority branch in which it is known to exist.  In that
case, there's no need to create a whiteout there, b/c there's no chance that
a readonly file by the same name could exist below that branch.  The same is
true if you try to rmdir a directory anywhere in one of the union's
branches: if we know (thanks to ->lookup) that there is no dir by the same
name anywhere else, then we can safely skip creating a whiteout if the
least-priority dir is being rmdir'ed.

I've got a small patch that does just that.

> 2. Why does copying then deleting a tree leave blocks allocated,
> which remain allocated indefinitely, until memory pressure or
> drop_caches removes them?  Hmm, I should have done "df -i" instead,
> that would be more revealing.  This may well be the same as the LTP
> mkdir problem - inodes remaining half-allocated after they're unlinked.

Turns out we weren't releasing the ref's on the lower directory being
rmdir'ed as early as we could.  We'd have done it in delete/clear_inode,
upon memory pressure, or unmount -- so those resources wouldn't have stuck
around forever.

I now have a small patch that releases those resources on rmdir and the
space (df and df -i) is reclaimed right away.

And, with the above patch to not create whiteouts on least-priority
branches, even that one ".wh.2.6.24-rc3" is gone in your case.

> 3. The unionfs filldir error messages:
> unionfs: filldir: possible I/O error: a file is duplicated in the same
>  branch 0: page_offset.h
> <... 174 more include/asm-* header files named until ...>
> unionfs: filldir: possible I/O error: a file is duplicated in the same
>  branch 0: sfafsr.h
> It's tempting to suppose these are related to the unfreed inodes, but
> retrying again gives me 176 messages, whereas inodes fall from 2672
> to 30.  And I didn't see those messages with tmpfs, just with ext2.

This had to do with a special case in processing readdir, when we find a
whiteout file (e.g., ".wh.foo.c"), and we want to know if we've already seen
the same file by it's non-whiteout name (e.g., "foo.c").  In both cases we
were looking for cached entries named "foo.c", but if we found the name
twice in the readdir cache, we considered it a serious error (EIO, perhaps
even a bug).  After all, a duplicate elimination algorithm should not find
duplicates after eliminating them. :-)

Anyway, the message which you saw was a false positive, and should have been
printed only if we were not looking for a whiteout.  I've got a small fix
for that as well.

> Hugh

Hugh, if you want the fixes for the above problems I already solved, let me
know and I'll post them.  Otherwise I'll probably wait until I finish LTP
testing as you suggested, then post everything.

Cheers,
Erez.
