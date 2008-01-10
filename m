Return-Path: <linux-kernel-owner+w=401wt.eu-S1757097AbYAJPAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbYAJPAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbYAJPAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:00:14 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:56935 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbYAJPAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:00:11 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hch@infradead.org, viro@ftp.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [UNIONFS] 00/29 Unionfs and related patches pre-merge review (v2)
Date: Thu, 10 Jan 2008 09:59:19 -0500
Message-Id: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear Linus, Al, Christoph, and Andrew,

As per your request, I'm posting for review the unionfs code (and related
code) that's in my korg tree against mainline (v2.6.24-rc7-71-gfd0b45d).
This is in preparation for merge in 2.6.25.  This code here is nearly
identical to what's in -mm (the mm code has a couple of additional things
that depend on mm-specific patches that aren't in mainline yet).

I've addressed *every* public/private comment I received on the first set of
patches I posted.  A summary of the changes from first set of patches (v1),
based on review feedback:

- several races/deadlocks fixed (thanks to lockdep)
- dropped the drop_pagecache_sb patch
- merged several logical patches together
- ensure that git-bisect works
- enhance user documentation
- assorted code cleanups (esp. removal of redundant/unnecessary code)

The rest of this message is nearly identical to the introductory text I used
in the first set of patchsets I posted for review, and is included here for
convenience.

BTW, I will be at LSF'08 to discuss/present stackable file system
VFS-support issues (together with Mike Halcrow, if he can make the trip).
So I hope to see some of you there for these important discussions.

Cheers,
Erez.

------------------------------------------------------------------------------

I really tried to keep this message short, by offering pointers to more
info, but still there's a bunch of info here.

Andrew, you've asked me to list the main issues that came about in
discussions regarding unionfs, and how were they addressed.  So I've
reviewed my notes from OLS'06, LSF'07, and OLS'07, as well as assorted
postings in mailing lists, and I came up with this prioritized list (in
descending priority order):

1. cache coherency
2. nameidata handling
3. namespace pollution
4. use of ioctls for branch management

(1) Cache coherency: by far, the biggest concern had been around cache
    coherency: what happens if someone modifies a lower object
    (file/dir/etc.).  I met with Mike Halcrow in October 2007 and we
    discussed stacking in general; Mike also emphasized that cache-coherency
    was one of his most pressing concerns in ecryptfs.

At OLS'06, several suggestions were made, including fancy tricks to hide the
lower namespace or "lock" it so users have readonly access.  None of these
solutions would have been able to easily handle the problem of an existing
open file descriptor on a lower file, and they might have required
significant VFS changes.  Moreover, unionfs users actually want to modify
lower branches directly, and then be able to see their changes reflected in
the union immediately.  So we explored a number of ideas.  We feel that the
VFS is complex enough so we tried our best to handle cache-coherency inside
unionfs.  The solution we have implemented is to compare the mtime/ctime of
upper/lower objects during revalidation (esp. of dentries); and if the lower
times are newer, we reconstruct the union object (drop the older objects,
and re-lookup them).  This time-based cache-coherency works well and is
similar to the NFS model.  Because Unionfs users tend to have a burst of
activity on lower branches, our current cache-coherency also defers the
revalidation actions until absolutely needed, so this idea tends to also be
more efficient for the common usage patterns.  More details about how we
handle cache-coherency are available in our
Documentation/filesystems/unionfs/concepts.txt file.

That said, we're now developing some VFS patches that would allow lower file
systems to more directly inform the upper objects about such (mtime)
changes.  We're exploring a couple of different options but our key goals
are to (a) minimize VFS changes and (b) avoid any changes to lower file
systems.

(2) nameidata handling.  Another important question raised (esp. by NFS
    people) was how we handle struct nameidata.  The VFS passes nameidata
    structs to file systems, and some file systems use that.  We used to
    either pass NULL or the upper nd to the lower f/s.  That caused NULL
    de-refs inside nfsv4, among other problems.  We now create our own
    nameidata structure, fill it up as needed (esp. for intent data), and
    pass it down.  We do this every time we call any VFS function that takes
    a nameidata (e.g., vfs_create).  This seems to work well.

There's been some discussion on lkml about splitting struct nameidata in
two, one of which would handle just the intent information.  I'd like to see
that happen, maybe even help, because right now we pass a whole large-ish
struct nameidata for just a couple of intent bits of information that the
lower f/s needs.

(3) namespace pollution.  Unioning readonly and readwrite directories
    requires the ability to mask, or white-out, files that are being deleted
    from a readonly directory.  Unionfs does this in a portable way, by
    creating .wh.XXX files to indicate that file XXX has been whited-out.
    This works well on many file systems, but it tends to clutter lower
    branches with these .wh.* files.  We recently optimized our whiteout
    creation algorithm so it minimizes the number of conditions in which
    whiteouts are created, and that helped some people a lot.  But still, if
    you unify a readonly and writeable branch, and you try to delete a file
    from the readonly branch/medium, there's no way to avoid creating some
    sort of a whiteout.  BTW, of course, these whiteouts are completely
    hidden from the view of the user who accesses files/dirs via the union.

In the long run, we really hope to see native whiteout support in Linux (ala
BSD).  Of course, this would require a change to the VFS and several native
file systems (possibly even a change to the on-disk format), so we realize
that this isn't likely to happen soon.  If/when native whiteout support was
available, unionfs could easily use it.  Until that time, we have lots of
users who want to use unionfs on top of numerous different file systems, and
so we have to do the next best thing wrt whiteouts.

This is a good point to mention that the version of unionfs in -mm is 2.2.x.
We have been working on a newer and still experimental version of Unionfs,
called "Unionfs with On-Disk Format" or Unionfs-ODF.  Unionfs-ODF uses a
small persistent store (e.g., a small ext2 partition) to store whiteouts in,
among other info; this moves the union-level meta-data (e.g., whiteouts),
outside the lower file systems, and thus eliminates the need to create .wh.*
files.  Unionfs-ODF has other useful benefits, and you can get more detail
about it here: <http://www.filesystems.org/unionfs-odf.txt>.  We recently
sync'ed up our unionfs 2.2 and unionfs-odf releases and we're tracking
Linus's tree for both.  IOW, every fix and user-visible feature that has
gone into unionfs in -mm, is now also in unionfs-odf.  Our intent is to
continue to develop both versions, and gradually move features from
unionfs-odf into unionfs 2.2; this would be possible even if/after
unionfs-2.2 gets merged, because the changes will all be internal to the
implementation, and users won't need to change the way they, say, mount a
union or manipulate its branches.

(4) branch management.  One of the most useful features of unioning is to be
    able to add/remove branches from the union.  We used to do this via
    ioctl's, which was considered racy, unclean, and non-atomic (only one
    branch-manipulation operation at a time).  We now do that via the
    remount interface, and allow users to pass multiple branch-manipulation
    commands, which are handled as one action.


* GENERAL

I should note that my philosophy in developing any stackable file system had
been to minimize changes to the VFS, and to not change any lower file system
whatsoever: that ensures that unionfs couldn't affect the stability of
performance of the rest of the kernel.  Still, some of the things unionfs
does could possibly be done more cleanly and easily at the VFS level (e.g.,
better hooks for cache coherency).

Unionfs 2.2.x is currently maintained on 2.6.9 and all major kernels since
2.6.18, all the way to Linus's latest 2.6.24-rc tree and -mm.  We've got a
lot users who use unionfs in more creative ways than even we could think of,
and this has helped us find the RIGHT set of features to please the users,
as well as stabilize the code.  Before every new release, we test the new
code on all versions using ltp-full, parallel compiles, and our own
unionfs-aware regression suite which exercises unionfs's unique features
(e.g., copy-up).

I therefore believe that unionfs is in a good enough shape now to be
considered for merging in 2.6.25.  (Heck, using Unionfs I've managed to
find, report, and in most cases fix bugs I found in nfsv2/3/4, xfs, jffs2,
and ext3/jbd :-) The user-visible unionfs behavior isn't likely to change;
and any changes to the VFS to better support stacking, could be handled
internally in subsequent kernels without affecting how users use unionfs.
Aside from greater exposure to stackable file systems and unionfs, I think
one of the other important benefits of a merge could be that we'd have more
than one stackable f/s in the kernel (i.e., ecryptfs and unionfs); this
would allow us to slowly and gradually generalize the VFS so it can better
support stackable file systems.


Lastly, shortlog and diffstats:

Erez Zadok (29):
      Unionfs: documentation
      VFS/eCryptfs: use simplified fs_stack API to fsstack_copy_attr_all
      Makefile: hook to compile unionfs
      Unionfs: main Makefile
      Unionfs: fanout header definitions
      Unionfs: main header file
      Unionfs: common file copyup/revalidation operations
      Unionfs: basic file operations
      Unionfs: lower-level copyup routines
      Unionfs: dentry revalidation
      Unionfs: lower-level lookup routines
      Unionfs: rename method and helpers
      Unionfs: directory reading file operations
      Unionfs: readdir helper functions
      Unionfs: readdir state helpers
      Unionfs: inode operations
      Unionfs: unlink/rmdir operations
      Unionfs: address-space operations
      Unionfs: mount-time and stacking-interposition functions
      Unionfs: super_block operations
      Unionfs: extended attributes operations
      Unionfs: async I/O queue
      Unionfs: miscellaneous helper routines
      Unionfs: debugging infrastructure
      Unionfs file system magic number
      Unionfs: common header file for user-land utilities and kernel
      VFS path get/put ops used by Unionfs
      VFS: export release_open_intent symbol
      Put Unionfs and eCryptfs under one layered filesystems menu

 Documentation/filesystems/00-INDEX             |    2
 Documentation/filesystems/unionfs/00-INDEX     |   10
 Documentation/filesystems/unionfs/concepts.txt |  213 ++++
 Documentation/filesystems/unionfs/issues.txt   |   28
 Documentation/filesystems/unionfs/rename.txt   |   31
 Documentation/filesystems/unionfs/usage.txt    |  134 ++
 MAINTAINERS                                    |    9
 fs/Kconfig                                     |   53 -
 fs/Makefile                                    |    1
 fs/ecryptfs/dentry.c                           |    2
 fs/ecryptfs/inode.c                            |    6
 fs/ecryptfs/main.c                             |    2
 fs/namei.c                                     |    1
 fs/stack.c                                     |   38
 fs/unionfs/Makefile                            |   13
 fs/unionfs/commonfops.c                        |  835 +++++++++++++++++
 fs/unionfs/copyup.c                            |  899 +++++++++++++++++++
 fs/unionfs/debug.c                             |  533 +++++++++++
 fs/unionfs/dentry.c                            |  548 +++++++++++
 fs/unionfs/dirfops.c                           |  290 ++++++
 fs/unionfs/dirhelper.c                         |  267 +++++
 fs/unionfs/fanout.h                            |  366 +++++++
 fs/unionfs/file.c                              |  184 +++
 fs/unionfs/inode.c                             | 1174 +++++++++++++++++++++++++
 fs/unionfs/lookup.c                            |  652 +++++++++++++
 fs/unionfs/main.c                              |  794 ++++++++++++++++
 fs/unionfs/mmap.c                              |  343 +++++++
 fs/unionfs/rdstate.c                           |  285 ++++++
 fs/unionfs/rename.c                            |  531 +++++++++++
 fs/unionfs/sioq.c                              |  119 ++
 fs/unionfs/sioq.h                              |   92 +
 fs/unionfs/subr.c                              |  242 +++++
 fs/unionfs/super.c                             | 1025 +++++++++++++++++++++
 fs/unionfs/union.h                             |  602 ++++++++++++
 fs/unionfs/unlink.c                            |  251 +++++
 fs/unionfs/xattr.c                             |  153 +++
 include/linux/fs_stack.h                       |   21
 include/linux/magic.h                          |    2
 include/linux/namei.h                          |   13
 include/linux/union_fs.h                       |   24
 40 files changed, 10752 insertions(+), 36 deletions(-)

Thanks,
Erez.
