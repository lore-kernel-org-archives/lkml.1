Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbZKBKGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbZKBKGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbZKBKGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:06:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbZKBKGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:06:13 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Chris Mason <chris.mason@oracle.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/27] Push down BKL to the filesystems (v2)
Date: Mon,  2 Nov 2009 11:04:40 +0100
Message-Id: <1257156307-24175-1-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the realtime preemption mini-summit we discussed the entire removal of
the big kernel lock. I've started working on this for some filesystems. My plan
is to push the BKL down to the implementations first and remove it from there
later.

This series is pushing the BKL from do_new_mount() down to the filesystems and
removes it from ext series of filesystems and one other trivial use: if the BKL
is only used in get_sb/fill_super due to the push-down, we just need to make
sure that parallel calls to get_sb/fill_super would race against each other.

I addressed the feedback from Matthew Wilcox and tried to be more verbose about
why I think it is safe to remove the BKL. In most cases there is no shared
resource accessed anyway so it is trivially safe to remove the lock.

There are two filesystems where I'm not 100% sure if the proposed patch is
enough, namely btrfs and xfs. Chris(+toph), could you help me here?

I left out the patch to remove default_llseek() on purpose. This indeed needs
some more lovin'.

Comments?

Jan

Jan Blunck (27):
  BKL: Push down BKL from do_new_mount() to the filesystems
    get_sb/fill_super operation
  BKL: Remove outdated comment and include
  BKL: Remove BKL from simple_fill_super
  ext2: Add ext2_sb_info mutex
  BKL: Remove BKL from ext2 filesystem
  BKL: Remove BKL from ext3 fill_super()
  BKL: Remove BKL from ext3_put_super() and ext3_remount()
  BKL: Remove BKL from ext4 filesystem
  BKL: Remove BKL from 9p
  BKL: Remove BKL from autofs4
  BKL: Remove BKL from befs
  BKL: Remove BKL from btrfs
  BKL: Remove BKL from configfs
  BKL: Remove BKL from cramfs
  BKL: Remove BKL from devpts
  BKL: Remove BKL from efs
  BKL: Remove BKL from exofs
  BKL: Remove BKL from hostfs
  BKL: Remove BKL from hugetlbfs
  BKL: Remove BKL from minix
  BKL: Remove BKL from omfs
  BKL: Remove BKL from openpromfs
  BKL: Remove BKL from ramfs
  BKL: Remove BKL from romfs
  BKL: Remove BKL from sysfs
  BKL: Remove BKL from ubifs
  BKL: Remove BKL from xfs

 fs/adfs/super.c            |    8 ++++++-
 fs/affs/super.c            |    9 +++++++-
 fs/afs/super.c             |    5 ++++
 fs/bfs/inode.c             |    9 +++++++-
 fs/binfmt_misc.c           |    6 ++++-
 fs/cifs/cifsfs.c           |   12 +++++++++-
 fs/coda/inode.c            |    8 ++++++-
 fs/ecryptfs/main.c         |    3 ++
 fs/exofs/super.c           |    2 +-
 fs/ext2/inode.c            |    5 +--
 fs/ext2/super.c            |   48 ++++++++++++++++++++++++++++---------------
 fs/ext3/super.c            |   12 -----------
 fs/ext4/super.c            |   11 ----------
 fs/fat/namei_msdos.c       |    6 ++++-
 fs/fat/namei_vfat.c        |    6 ++++-
 fs/freevxfs/vxfs_super.c   |    7 +++++-
 fs/fuse/control.c          |    9 +++++++-
 fs/fuse/inode.c            |    5 ++++
 fs/gfs2/ops_fstype.c       |    9 ++++++++
 fs/hfs/super.c             |    8 ++++++-
 fs/hfsplus/super.c         |    8 ++++++-
 fs/hpfs/super.c            |    8 ++++++-
 fs/hppfs/hppfs.c           |    4 +++
 fs/isofs/inode.c           |    8 ++++++-
 fs/jffs2/super.c           |   11 ++++++++-
 fs/jfs/super.c             |   14 +++++++++++-
 fs/libfs.c                 |    1 +
 fs/namespace.c             |    2 -
 fs/ncpfs/inode.c           |    8 ++++++-
 fs/nfs/super.c             |   19 +++++++++++++++++
 fs/nfsd/nfsctl.c           |    7 +++++-
 fs/nilfs2/super.c          |    9 +++++++-
 fs/ntfs/super.c            |    5 ++++
 fs/ocfs2/dlm/dlmfs.c       |    8 ++++++-
 fs/ocfs2/super.c           |    5 ++++
 fs/proc/root.c             |    9 +++++++-
 fs/qnx4/inode.c            |    8 ++++++-
 fs/reiserfs/super.c        |    4 +++
 fs/smbfs/inode.c           |    5 ++++
 fs/squashfs/super.c        |    6 +++++
 fs/super.c                 |    3 --
 fs/sysfs/mount.c           |    2 +-
 fs/sysv/super.c            |   24 +++++++++++++++++----
 fs/udf/super.c             |    8 ++++++-
 fs/ufs/super.c             |    5 ++++
 include/linux/ext2_fs_sb.h |    2 +
 46 files changed, 300 insertions(+), 81 deletions(-)

