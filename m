Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbZLPSwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbZLPSwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbZLPSwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:52:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60661 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZLPSv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:51:59 -0500
Date: Wed, 16 Dec 2009 18:51:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] VFS stuff, part 1
Message-ID: <20091216185157.GL14381@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This ought to get rid of the bulk of namei.c patches affecting the
areas where my and Nick's series step on the same code.  There's
also some struct file work, plus a bunch of fixes all over the place
(in particular, Eric's series dealing with IMA horrors, partially
modified to merge), but most of that stuff is fighting the call
graph in fs/namei.c and massaging things into more or less sane shape
there.

Please, pull from
git.kernel.org//pub/scm/linux/kernel/git/viro/vfs-2.6.git/

Shortlog:
Al Viro (25):
      sanitize do_pipe_flags() callers in arch
      switch shmem_file_setup() to alloc_file()
      switched inotify_init1() to alloc_file()
      unexport get_empty_filp()
      reorder alloc_fd/attach_fd in socketpair()
      merge sock_alloc_fd/sock_attach_fd into a new helper
      9p connect fixes
      switch sock_alloc_file() to alloc_file()
      get rid of init_file()
      switch nilfs2 to deactivate_locked_super()
      switch alloc_file() to passing struct path
      switch create_read_pipe() to alloc_file()
      lift path_put(path) to callers of __do_follow_link()
      kill __link_path_walk()/link_path_walk() distinction
      fix the crap in dst/dcore
      switch cachefiles to kern_path()
      fix mismerge with Trond's stuff (create_mnt_ns() export is gone now)
      Take hash recalculation into do_lookup()
      Kill path_lookup_open()
      Kill cached_lookup() and real_lookup()
      Sanitize exec_permission_lite()
      O_TRUNC open shouldn't fail after file truncation
      Untangling ima mess, part 1: alloc_file()
      Untangling ima mess, part 2: deal with counters
      Untangling ima mess, part 3: kill dead code in ima

Christoph Hellwig (5):
      sanitize xattr handler prototypes
      make generic_acl slightly more generic
      cleanup blockdev_direct_IO locking
      ocfs: stop using do_sync_mapping_range
      direct I/O fallback sync simplification

Eric Paris (5):
      fs: move get_empty_filp() deffinition to internal.h
      ima: valid return code from ima_inode_alloc
      ima: only insert at inode creation time
      IMA: clean up the IMA counts updating code
      ima: call ima_inode_free ima_inode_free

H Hartley Sweeten (1):
      libfs: move EXPORT_SYMBOL for d_alloc_name

Jeff Layton (1):
      vfs: force reval of target when following LAST_BIND symlinks (try #7)

Mimi Zohar (1):
      ima: limit imbalance msg

Diffstat:
 arch/ia64/kernel/perfmon.c            |   15 +-
 arch/parisc/hpux/sys_hpux.c           |    7 +-
 arch/x86/include/asm/sys_ia32.h       |    1 -
 arch/xtensa/include/asm/syscall.h     |    1 -
 arch/xtensa/include/asm/unistd.h      |    2 +-
 arch/xtensa/kernel/syscall.c          |   18 --
 drivers/infiniband/core/uverbs_main.c |    9 +-
 drivers/staging/dst/dcore.c           |   46 +---
 fs/anon_inodes.c                      |   18 +-
 fs/btrfs/acl.c                        |   47 +---
 fs/cachefiles/bind.c                  |   11 +-
 fs/cachefiles/rdwr.c                  |    2 -
 fs/dcache.c                           |    1 +
 fs/direct-io.c                        |  129 ++++------
 fs/ecryptfs/main.c                    |    7 +-
 fs/ext2/acl.c                         |   79 ++----
 fs/ext2/xattr.c                       |   11 +-
 fs/ext2/xattr_security.c              |   16 +-
 fs/ext2/xattr_trusted.c               |   16 +-
 fs/ext2/xattr_user.c                  |   25 +-
 fs/ext3/acl.c                         |   74 ++----
 fs/ext3/xattr.c                       |   31 ++-
 fs/ext3/xattr_security.c              |   20 +-
 fs/ext3/xattr_trusted.c               |   18 +-
 fs/ext3/xattr_user.c                  |   25 +-
 fs/ext4/acl.c                         |   74 ++----
 fs/ext4/xattr.c                       |   31 ++-
 fs/ext4/xattr_security.c              |   20 +-
 fs/ext4/xattr_trusted.c               |   20 +-
 fs/ext4/xattr_user.c                  |   25 +-
 fs/file_table.c                       |   49 +---
 fs/generic_acl.c                      |  158 +++++++-----
 fs/gfs2/acl.c                         |   16 +-
 fs/gfs2/inode.c                       |    3 +-
 fs/gfs2/xattr.c                       |   69 ++---
 fs/gfs2/xattr.h                       |    7 +-
 fs/hugetlbfs/inode.c                  |   17 +-
 fs/internal.h                         |    1 +
 fs/jffs2/acl.c                        |   65 ++---
 fs/jffs2/security.c                   |   18 +-
 fs/jffs2/xattr.c                      |    6 +-
 fs/jffs2/xattr_trusted.c              |   18 +-
 fs/jffs2/xattr_user.c                 |   18 +-
 fs/libfs.c                            |    1 -
 fs/namei.c                            |  466 ++++++++++++++++----------------
 fs/namespace.c                        |    3 +-
 fs/nfs/super.c                        |    8 -
 fs/nfsd/vfs.c                         |    5 +-
 fs/nilfs2/super.c                     |    3 +-
 fs/notify/inotify/inotify_user.c      |   29 +-
 fs/ocfs2/acl.c                        |   87 ++-----
 fs/ocfs2/alloc.c                      |    4 +-
 fs/ocfs2/aops.c                       |   34 +--
 fs/ocfs2/xattr.c                      |   72 +++---
 fs/open.c                             |    4 +
 fs/pipe.c                             |   29 +--
 fs/reiserfs/xattr.c                   |   36 ++--
 fs/reiserfs/xattr_acl.c               |   69 ++----
 fs/reiserfs/xattr_security.c          |   21 +-
 fs/reiserfs/xattr_trusted.c           |   21 +-
 fs/reiserfs/xattr_user.c              |   21 +-
 fs/xattr.c                            |   28 +-
 fs/xfs/linux-2.6/xfs_acl.c            |   57 ++---
 fs/xfs/linux-2.6/xfs_aops.c           |   20 +-
 fs/xfs/linux-2.6/xfs_xattr.c          |   71 +----
 fs/xfs/xfs_acl.h                      |    3 +-
 include/linux/file.h                  |    8 +-
 include/linux/fs.h                    |   23 +-
 include/linux/generic_acl.h           |   41 +---
 include/linux/ima.h                   |   12 +-
 include/linux/mnt_namespace.h         |    1 -
 include/linux/shmem_fs.h              |   16 --
 include/linux/xattr.h                 |   13 +-
 ipc/mqueue.c                          |    2 -
 ipc/shm.c                             |   12 +-
 mm/Makefile                           |    1 -
 mm/filemap.c                          |   15 +-
 mm/shmem.c                            |   71 +++---
 mm/shmem_acl.c                        |  171 ------------
 net/9p/trans_fd.c                     |  112 ++++-----
 net/socket.c                          |  108 +++-----
 security/integrity/ima/ima.h          |    3 -
 security/integrity/ima/ima_iint.c     |   79 +-----
 security/integrity/ima/ima_main.c     |  184 ++++++++------
 84 files changed, 1243 insertions(+), 1965 deletions(-)
