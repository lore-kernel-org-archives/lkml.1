Return-Path: <linux-kernel-owner+w=401wt.eu-S1758377AbYG0BWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbYG0BWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 21:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756820AbYG0BWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 21:22:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44782 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbYG0BWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 21:22:13 -0400
Date: Sun, 27 Jul 2008 02:22:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] VFS patches, the first series
Message-ID: <20080727012212.GW28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first part of huge pile.  Mostly it's untangling nameidata handling,
digging towards the pieces that kill intents and cleaning pathname
resolution in general.  ->permission() sanitizing and sysctl procfs
treatment rewrite needed for it.  A bunch of descriptor handling fixes.
Plus part of assorted patched from the last cycle sent by other folks.
A _lot_ more is still pending; this is what I'd managed to pull into
a series by this point.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (24):
      beginning of sysctl cleanup - ctl_table_set
      allow delayed freeing of ctl_table_header
      sysctl: make sure that /proc/sys/net/ipv4 appears before per-ns ones
      sysctl: keep track of tree relationships
      sanitize proc_sysctl
      sanitize ->permission() prototype
      permission checks for chdir need special treatment only on the last step
      kill altroot
      fix MAY_CHDIR/MAY_ACCESS/LOOKUP_ACCESS mess
      pass MAY_OPEN to vfs_permission() explicitly
      more nameidata removal: exec_permission_lite() doesn't need it
      take noexec checks to very few callers that care
      kill nameidata passing to permission(), rename to inode_permission()
      preparation to __user_walk_fd cleanup
      sanitize __user_walk_fd() et.al.
      new (local) helper: user_path_parent()
      don't pass nameidata to gfs2_lookupi()
      don't pass nameidata to __ncp_lookup_validate()
      f_count may wrap around
      get rid of __user_path_lookup_open
      get rid of indirect users of namei.h
      remove remaining namei_{32,64}.h crap
      get rid of corner case in dup3() entirely
      fix RLIM_NOFILE handling

Christoph Hellwig (1):
      Re: [PATCH 3/6] vfs: open_exec cleanup

Denys Vlasenko (1):
      reuse xxx_fifo_fops for xxx_pipe_fops

Li Zefan (1):
      vfs: use kstrdup() and check failing allocation

Miklos Szeredi (10):
      [patch] vfs: fix lookup on deleted directory
      [patch] hppfs: remove hppfs_permission
      [patch 05/14] hpfs: dont call permission()
      [patch 1/5] vfs: truncate: dont check immutable twice
      [patch 3/5] vfs: change remove_suid() to file_remove_suid()
      [patch 5/5] vfs: remove mode parameter from vfs_symlink()
      [patch 1/4] vfs: utimes: move owner check into inode_change_ok()
      [patch 2/4] vfs: utimes cleanup
      [patch 3/4] fat: dont call notify_change
      [patch 4/4] vfs: immutable inode checking cleanup

Tetsuo Handa (1):
      [patch 4/5] vfs: reuse local variable in vfs_link()

Ulrich Drepper (1):
      dup3 fix

Diffstat:
 arch/alpha/kernel/osf_sys.c    |   10 +-
 arch/parisc/hpux/sys_hpux.c    |   10 +-
 drivers/net/ppp_generic.c      |    6 +-
 fs/affs/file.c                 |    4 -
 fs/afs/internal.h              |    4 +-
 fs/afs/security.c              |    2 +-
 fs/aio.c                       |    6 +-
 fs/attr.c                      |    7 +-
 fs/bad_inode.c                 |    3 +-
 fs/cifs/cifsfs.c               |    2 +-
 fs/coda/dir.c                  |    4 +-
 fs/coda/pioctl.c               |   20 +-
 fs/compat.c                    |   20 +-
 fs/ecryptfs/inode.c            |   21 +--
 fs/exec.c                      |   81 +++++---
 fs/ext2/acl.c                  |    2 +-
 fs/ext2/acl.h                  |    2 +-
 fs/ext3/acl.c                  |    2 +-
 fs/ext3/acl.h                  |    2 +-
 fs/ext4/acl.c                  |    2 +-
 fs/ext4/acl.h                  |    2 +-
 fs/fat/file.c                  |   15 ++-
 fs/fcntl.c                     |   33 ++--
 fs/fifo.c                      |    8 +-
 fs/file.c                      |    9 +
 fs/file_table.c                |   10 +-
 fs/fuse/dir.c                  |    6 +-
 fs/fuse/file.c                 |    2 +-
 fs/gfs2/inode.c                |    6 +-
 fs/gfs2/inode.h                |    2 +-
 fs/gfs2/ops_export.c           |    2 +-
 fs/gfs2/ops_inode.c            |   16 +-
 fs/gfs2/super.c                |    2 +-
 fs/hfs/inode.c                 |    7 +-
 fs/hfsplus/inode.c             |    6 +-
 fs/hostfs/hostfs_kern.c        |    2 +-
 fs/hpfs/namei.c                |    2 +-
 fs/hppfs/hppfs.c               |    7 -
 fs/inotify_user.c              |   22 +-
 fs/jffs2/acl.c                 |    2 +-
 fs/jffs2/acl.h                 |    2 +-
 fs/jfs/acl.c                   |    2 +-
 fs/jfs/jfs_acl.h               |    2 +-
 fs/namei.c                     |  354 +++++++++++----------------------
 fs/namespace.c                 |  106 +++++------
 fs/ncpfs/dir.c                 |    4 +-
 fs/nfs/dir.c                   |   11 +-
 fs/nfsd/nfsctl.c               |    1 +
 fs/nfsd/nfsfh.c                |    2 +-
 fs/nfsd/vfs.c                  |   14 +-
 fs/ntfs/file.c                 |    2 +-
 fs/ocfs2/file.c                |    2 +-
 fs/ocfs2/file.h                |    3 +-
 fs/open.c                      |  179 ++++++++---------
 fs/pipe.c                      |   51 +----
 fs/proc/base.c                 |    3 +-
 fs/proc/inode.c                |    5 +
 fs/proc/proc_sysctl.c          |  429 ++++++++++++++++++----------------------
 fs/reiserfs/xattr.c            |    2 +-
 fs/smbfs/file.c                |    4 +-
 fs/splice.c                    |    4 +-
 fs/stat.c                      |   32 ++--
 fs/ubifs/file.c                |    1 +
 fs/utimes.c                    |  139 +++++++-------
 fs/xattr.c                     |   98 +++++-----
 fs/xfs/linux-2.6/xfs_ioctl.c   |   14 +-
 fs/xfs/linux-2.6/xfs_iops.c    |    3 +-
 fs/xfs/linux-2.6/xfs_lrw.c     |    2 +-
 include/asm-alpha/namei.h      |   17 --
 include/asm-arm/namei.h        |   25 ---
 include/asm-avr32/namei.h      |    7 -
 include/asm-blackfin/namei.h   |   19 --
 include/asm-cris/namei.h       |   17 --
 include/asm-frv/namei.h        |   18 --
 include/asm-h8300/namei.h      |   17 --
 include/asm-ia64/namei.h       |   25 ---
 include/asm-m32r/namei.h       |   17 --
 include/asm-m68k/namei.h       |   17 --
 include/asm-m68knommu/namei.h  |    1 -
 include/asm-mips/namei.h       |   11 -
 include/asm-mn10300/namei.h    |   22 --
 include/asm-parisc/namei.h     |   17 --
 include/asm-powerpc/namei.h    |   20 --
 include/asm-s390/namei.h       |   21 --
 include/asm-sh/namei.h         |   17 --
 include/asm-sparc/namei.h      |    8 -
 include/asm-sparc/namei_32.h   |   13 --
 include/asm-sparc/namei_64.h   |   13 --
 include/asm-sparc64/namei.h    |    1 -
 include/asm-um/namei.h         |    6 -
 include/asm-v850/namei.h       |   17 --
 include/asm-x86/namei.h        |   11 -
 include/asm-xtensa/namei.h     |   26 ---
 include/linux/coda_linux.h     |    2 +-
 include/linux/fs.h             |   57 +++---
 include/linux/fs_struct.h      |    3 +-
 include/linux/mount.h          |    2 +-
 include/linux/namei.h          |   19 +-
 include/linux/nfs_fs.h         |    3 +-
 include/linux/proc_fs.h        |    5 +
 include/linux/reiserfs_xattr.h |    2 +-
 include/linux/security.h       |    7 +-
 include/linux/shmem_fs.h       |    2 +-
 include/linux/sysctl.h         |   25 +++-
 include/net/af_unix.h          |    2 +-
 include/net/ip.h               |    2 +
 include/net/net_namespace.h    |    4 +-
 ipc/mqueue.c                   |    2 +-
 kernel/cgroup.c                |    1 +
 kernel/exec_domain.c           |    1 -
 kernel/exit.c                  |    2 -
 kernel/fork.c                  |    7 -
 kernel/sysctl.c                |  166 ++++++++++++++--
 mm/filemap.c                   |    7 +-
 mm/filemap_xip.c               |    2 +-
 mm/shmem_acl.c                 |    2 +-
 net/ipv4/af_inet.c             |    4 +
 net/ipv4/sysctl_net_ipv4.c     |    7 +
 net/sched/sch_atm.c            |    4 +-
 net/sysctl_net.c               |   22 +--
 net/unix/af_unix.c             |    2 +-
 net/unix/garbage.c             |   18 +-
 security/capability.c          |    3 +-
 security/security.c            |    5 +-
 security/selinux/hooks.c       |    5 +-
 security/smack/smack_lsm.c     |    3 +-
 126 files changed, 1088 insertions(+), 1535 deletions(-)
 delete mode 100644 include/asm-alpha/namei.h
 delete mode 100644 include/asm-arm/namei.h
 delete mode 100644 include/asm-avr32/namei.h
 delete mode 100644 include/asm-blackfin/namei.h
 delete mode 100644 include/asm-cris/namei.h
 delete mode 100644 include/asm-frv/namei.h
 delete mode 100644 include/asm-h8300/namei.h
 delete mode 100644 include/asm-ia64/namei.h
 delete mode 100644 include/asm-m32r/namei.h
 delete mode 100644 include/asm-m68k/namei.h
 delete mode 100644 include/asm-m68knommu/namei.h
 delete mode 100644 include/asm-mips/namei.h
 delete mode 100644 include/asm-mn10300/namei.h
 delete mode 100644 include/asm-parisc/namei.h
 delete mode 100644 include/asm-powerpc/namei.h
 delete mode 100644 include/asm-s390/namei.h
 delete mode 100644 include/asm-sh/namei.h
 delete mode 100644 include/asm-sparc/namei.h
 delete mode 100644 include/asm-sparc/namei_32.h
 delete mode 100644 include/asm-sparc/namei_64.h
 delete mode 100644 include/asm-sparc64/namei.h
 delete mode 100644 include/asm-um/namei.h
 delete mode 100644 include/asm-v850/namei.h
 delete mode 100644 include/asm-x86/namei.h
 delete mode 100644 include/asm-xtensa/namei.h
