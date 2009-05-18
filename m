Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbZERQQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbZERQQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757944AbZERQNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:13:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:41518 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333AbZERQJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:31 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 00/32] VFS based Union Mount (V3)
Date: Mon, 18 May 2009 18:08:56 +0200
Message-Id: <1242662968-11684-1-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is another post of the VFS based union mount implementation.

Traditionally the mount operation is opaque, which means that the content of
the mount point, the directory where the file system is mounted on, is hidden
by the content of the mounted file system's root directory until the file
system is unmounted again. Unlike the traditional UNIX mount mechanism, that
hides the contents of the mount point, a union mount presents a view as if
both filesystems are merged together. Although only the topmost layer of the
mount stack can be altered, it appears as if transparent file system mounts
allow any file to be created, modified or deleted.

Most people know the concepts and features of union mounts from other
operating systems like Sun's Translucent Filesystem, Plan9 or BSD. For an
in-depth review of union mounts and other unioning file systems, see:

http://lwn.net/Articles/324291/
http://lwn.net/Articles/325369/
http://lwn.net/Articles/327738/

Here are the key features of this implementation:
- completely VFS based
- does not change the namespace stacking
- directory listings have duplicate entries removed in the kernel
- writable unions: only the topmost file system layer may be writable
- writable unions: new whiteout filetype handled inside the kernel

Major changes since last post:
- Updated the whiteout patches:
  - DCACHE_WHITEOUT flag set on a negative dentry
  - uses filetype instead of reserved inode number on EXT2
- Copy-up directories during lookup
- Implemented fallthru support for in-kernel readdir() as proposed by
  Valerie Aurora (Henson)
- Bugfixes

Valerie updated the HOWTO page and the UML disk image. You can find her
instruction how to testdrive the code here:

http://valerieaurora.org/union/

The following patches apply on 2.6.29. Comments are welcome!

Cheers,
Jan


Jan Blunck (26):
  atomic: Only take lock when the counter drops to zero on UP as well
  VFS: BUG() if somebody tries to rehash an already hashed dentry
  VFS: propagate mnt_flags into do_loopback
  VFS: Make lookup_hash() return a struct path
  VFS: Remove unnecessary micro-optimization in cached_lookup()
  VFS: Make real_lookup() return a struct path
  VFS: Introduce dput() variant that maintains a kill-list
  whiteout: Don't return information about whiteouts to userspace
  whiteout: Add vfs_whiteout() and whiteout inode operation
  whiteout: Set S_OPAQUE inode flag when creating directories
  whiteout: Add whiteout support to tmpfs
  whiteout: Split of ext2_append_link() from ext2_add_link()
  whiteout: Add whiteout support to ext2
  whiteout: Add path_whiteout() helper
  union-mount: Documentation
  union-mount: Introduce MNT_UNION and MS_UNION flags
  union-mount: Introduce union_mount structure
  union-mount: Drive the union cache via dcache
  union-mount: Some checks during namespace changes
  union-mount: Changes to the namespace handling
  union-mount: Make lookup work for union-mounted file systems
  union-mount: stop lookup when directory has S_OPAQUE flag set
  union-mount: stop lookup when finding a whiteout
  union-mount: in-kernel file copy between union mounted filesystems
  union-mount: check for logically empty directory (FIXME)
  union-mount: call do_whiteout() on unlink and rmdir

Valerie Aurora (Henson) (6):
  union-mount: Always create topmost directory on open
  union-mount: Basic fallthru definitions
  union mount: Support for fallthru entries in union mount lookup
  union mount: ext2 fallthru support
  union-mount: tmpfs fallthru support
  union-mount: Copy up directory entries on first readdir()

 Documentation/filesystems/union-mounts.txt |  187 +++++
 fs/Kconfig                                 |    8 +
 fs/Makefile                                |    2 +
 fs/compat.c                                |    9 +
 fs/dcache.c                                |  143 ++++-
 fs/ext2/dir.c                              |  242 ++++++-
 fs/ext2/ext2.h                             |    4 +
 fs/ext2/inode.c                            |   11 +-
 fs/ext2/namei.c                            |   85 +++-
 fs/ext2/super.c                            |    8 +
 fs/libfs.c                                 |   18 +-
 fs/namei.c                                 | 1009 +++++++++++++++++++++++++---
 fs/namespace.c                             |   54 ++-
 fs/nfsd/nfs3xdr.c                          |    5 +
 fs/nfsd/nfs4xdr.c                          |    2 +-
 fs/nfsd/nfsxdr.c                           |    4 +
 fs/readdir.c                               |   25 +
 fs/union.c                                 |  948 ++++++++++++++++++++++++++
 include/linux/dcache.h                     |   30 +-
 include/linux/ext2_fs.h                    |    5 +
 include/linux/fs.h                         |    7 +
 include/linux/mount.h                      |    4 +
 include/linux/namei.h                      |    6 +
 include/linux/union.h                      |   82 +++
 lib/dec_and_lock.c                         |    3 +-
 mm/shmem.c                                 |  195 +++++-
 26 files changed, 2927 insertions(+), 169 deletions(-)
 create mode 100644 Documentation/filesystems/union-mounts.txt
 create mode 100644 fs/union.c
 create mode 100644 include/linux/union.h

