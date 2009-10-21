Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbZJUTUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbZJUTUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZJUTUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:20:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812AbZJUTUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:20:10 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 00/40] Writable overlays (union mounts)
Date: Wed, 21 Oct 2009 12:18:58 -0700
Message-Id: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the current patch set for writable overlays (union mounts).
It needs lots of review!  Especially the bits where we do nasty things
with readdir().

Writable overlays let you mount one read-write file system
transparently over another read-only file system.  This is useful for
things like LiveCDs.  Detailed documentation and HOWTO here:

http://valerieaurora.org/union/

The git version is in branch "overlay" of:

http://git.kernel.org/?p=linux/kernel/git/val/linux-2.6.git;a=summary

Call for maintainer: Neither Jan nor I can give this patch set the
long term love that it needs.  If you are interested in becoming the
maintainer for union mounts at some point in the future, please drop
me an email.

-VAL

Felix Fietkau (2):
  whiteout: jffs2 whiteout support
  fallthru: jffs2 fallthru support

Jan Blunck (25):
  VFS: BUG() if somebody tries to rehash an already hashed dentry
  VFS: propagate mnt_flags into do_loopback
  VFS: Make lookup_hash() return a struct path
  VFS: Remove unnecessary micro-optimization in cached_lookup()
  VFS: Make real_lookup() return a struct path
  VFS: Introduce dput() variant that maintains a kill-list
  Don't replace nameidata path when following links
  whiteout: Don't return information about whiteouts to userspace
  whiteout: Add vfs_whiteout() and whiteout inode operation
  whiteout: Set S_OPAQUE inode flag when creating directories
  union-mount: Allow removal of a directory
  whiteout: tmpfs whiteout support
  whiteout: Split of ext2_append_link() from ext2_add_link()
  whiteout: ext2 whiteout support
  whiteout: Add path_whiteout() helper
  union-mount: Introduce MNT_UNION and MS_UNION flags
  union-mount: Introduce union_mount structure
  union-mount: Drive the union cache via dcache
  union-mount: Some checks during namespace changes
  union-mount: Changes to the namespace handling
  union-mount: Make lookup work for union-mounted file systems
  union-mount: stop lookup when directory has S_OPAQUE flag set
  union-mount: stop lookup when finding a whiteout
  union-mount: call do_whiteout() on unlink and rmdir
  union-mount: Add support for rename by __union_copyup()

Valerie Aurora (14):
  VFS: Add read-only users count to superblock
  union-mount: Documentation
  union-mount: in-kernel file copy between union mounted filesystems
  union-mount: Always create topmost directory on open
  fallthru: Basic fallthru definitions
  fallthru: Support for fallthru entries in union mount lookup
  fallthru: ext2 fallthru support
  fallthru: tmpfs fallthru support
  union-mount: Copy up directory entries on first readdir()
  union-mount: Increment read-only users count for read-only layer
  union-mount: Check read-only/read-write status of layers
  union-mount: Make pivot_root work with union mounts
  union-mount: Ignore read-only file system in permission checks
  union-mount: Make truncate work in all its glorious UNIX variations

 Documentation/filesystems/union-mounts.txt |  708 ++++++++++++++
 fs/Kconfig                                 |   13 +
 fs/Makefile                                |    1 +
 fs/autofs4/autofs_i.h                      |    1 +
 fs/autofs4/init.c                          |   11 +-
 fs/autofs4/root.c                          |    6 +
 fs/compat.c                                |    9 +
 fs/dcache.c                                |  143 +++-
 fs/ext2/dir.c                              |  248 +++++-
 fs/ext2/ext2.h                             |    4 +
 fs/ext2/inode.c                            |   11 +-
 fs/ext2/namei.c                            |   85 ++-
 fs/ext2/super.c                            |    7 +
 fs/jffs2/dir.c                             |  108 ++-
 fs/jffs2/fs.c                              |    4 +
 fs/jffs2/super.c                           |    2 +-
 fs/libfs.c                                 |   21 +-
 fs/namei.c                                 | 1424 +++++++++++++++++++++++++---
 fs/namespace.c                             |  120 +++-
 fs/nfsctl.c                                |    6 +-
 fs/nfsd/nfs3xdr.c                          |    5 +
 fs/nfsd/nfs4xdr.c                          |    2 +-
 fs/nfsd/nfsxdr.c                           |    4 +
 fs/open.c                                  |  130 +--
 fs/readdir.c                               |   26 +
 fs/super.c                                 |   14 +
 fs/union.c                                 |  978 +++++++++++++++++++
 include/linux/dcache.h                     |   29 +
 include/linux/ext2_fs.h                    |    5 +
 include/linux/fs.h                         |   15 +-
 include/linux/jffs2.h                      |    8 +
 include/linux/mount.h                      |    4 +
 include/linux/namei.h                      |    6 +
 include/linux/union.h                      |   84 ++
 mm/shmem.c                                 |  195 ++++-
 35 files changed, 4172 insertions(+), 265 deletions(-)
 create mode 100644 Documentation/filesystems/union-mounts.txt
 create mode 100644 fs/union.c
 create mode 100644 include/linux/union.h

