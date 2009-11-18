Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbZKRJYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbZKRJYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZKRJYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:24:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:42186 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbZKRJYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:24:52 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 00/20] BKL pushdown from do_new_mount() to the filesystems (v3)
Date: Wed, 18 Nov 2009 10:24:33 +0100
Message-Id: <1258536293-7762-1-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the realtime preemption mini-summit we discussed the entire removal of
the big kernel lock. I've started working on this for some filesystems. My plan
is to push the BKL down to the implementations first and remove it from there
later.

This series is pushing the BKL from do_new_mount() down to the filesystems.
If the filesystem wasn't using the BKL at all before, it gets removed instead.
If removing is trivial (e.g. because it is obviously already protected by an
existing lock) it gets removed by a follow up patch in the series.

Later on in the series the big kernel lock is removed from EXT2. Instead, a new
lock that protects the modification of some of the superblocks fields is
introduced.

Version 2 of the series addressed the feedback from Matthew Wilcox and I tried
to be more verbose about why I think it is safe to remove the BKL. In most
cases there is no shared resource accessed anyway or the superblock s_umount
rwsemaphore is used so it is trivially safe to remove the big kernel lock.

Version 3 of the series addressed the feedback from Christoph Hellwig and Arnd
Bergmann to not push down the BKL to filesystems that don't use it anyway. I've
changed the ext2 s_lock usage in ext2_sync_super() to address Jan Kara's
comments.

If all affected maintainers acknowledge their parts of the patches it should
get merged through one of the bkl branches in the tip tree.

Jan Blunck (20):
  JFS: Free sbi memory in error path
  AFFS: Free sbi memory in error path
  BKL: Explicitly add BKL around get_sb/fill_super
  BKL: Remove outdated comment and include
  BKL: Remove BKL from Amiga FFS
  BKL: Remove BKL from BFS
  BKL: Remove BKL from CifsFS
  BKL: Remove BKL from ext3 fill_super()
  BKL: Remove BKL from ext3_put_super() and ext3_remount()
  BKL: Remove BKL from ext4 filesystem
  BKL: Remove BKL from exofs
  BKL: Remove BKL from HFS
  BKL: Remove BKL from HFS+
  BKL: Remove BKL from JFS
  BKL: Remove BKL from NILFS2
  BKL: Remove BKL from NTFS
  BKL: Remove BKL from cgroup
  BKL: Remove BKL from do_new_mount()
  ext2: Add ext2_sb_info s_lock spinlock
  BKL: Remove BKL from ext2 filesystem

 drivers/isdn/capi/capifs.c |   10 ++++++-
 drivers/usb/core/inode.c   |    5 +++
 drivers/usb/gadget/inode.c |   12 +++++++-
 fs/adfs/super.c            |    8 +++++-
 fs/affs/super.c            |   17 ++++--------
 fs/afs/super.c             |    5 +++
 fs/bfs/inode.c             |    8 +----
 fs/cifs/cifsfs.c           |    9 ++----
 fs/coda/inode.c            |    8 +++++-
 fs/ecryptfs/main.c         |    4 +++
 fs/exofs/super.c           |    1 -
 fs/ext2/inode.c            |    5 +--
 fs/ext2/super.c            |   60 ++++++++++++++++++++++++++++++--------------
 fs/ext3/super.c            |   12 ---------
 fs/ext4/super.c            |   11 --------
 fs/fat/namei_msdos.c       |    7 ++++-
 fs/fat/namei_vfat.c        |    7 ++++-
 fs/freevxfs/vxfs_super.c   |    7 ++++-
 fs/hfs/super.c             |    6 +---
 fs/hfsplus/super.c         |    5 ---
 fs/hpfs/super.c            |    8 +++++-
 fs/isofs/inode.c           |    8 +++++-
 fs/jffs2/super.c           |   11 ++++++-
 fs/jfs/super.c             |   23 ++++------------
 fs/namespace.c             |    2 -
 fs/ncpfs/inode.c           |    8 +++++-
 fs/nfs/super.c             |   24 +++++++++++++++++
 fs/nilfs2/ioctl.c          |    1 -
 fs/nilfs2/super.c          |   10 -------
 fs/ntfs/super.c            |   24 +----------------
 fs/ocfs2/dlm/dlmfs.c       |    9 ++++++-
 fs/ocfs2/super.c           |    5 +++
 fs/qnx4/inode.c            |    8 +++++-
 fs/reiserfs/super.c        |    4 +++
 fs/smbfs/inode.c           |    5 +++
 fs/squashfs/super.c        |    6 ++++
 fs/super.c                 |    3 --
 fs/udf/super.c             |    8 +++++-
 fs/ufs/super.c             |    5 +++
 include/linux/ext2_fs_sb.h |    6 ++++
 kernel/cgroup.c            |    4 ---
 41 files changed, 234 insertions(+), 155 deletions(-)

