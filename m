Return-Path: <linux-kernel-owner+w=401wt.eu-S932799AbZLKSyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799AbZLKSyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 13:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758950AbZLKSyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 13:54:06 -0500
Received: from sh.osrg.net ([192.16.179.4]:38154 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758941AbZLKSyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 13:54:05 -0500
Date: Sat, 12 Dec 2009 03:54:04 +0900 (JST)
Message-Id: <20091212.035404.62943290.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 updates for 2.6.33
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 12 Dec 2009 03:54:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the for-linus branch from

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to receive the following updates of nilfs for v2.6.33.

Several optimization tweaks, a mount option discussed by users, and
some cleanup work are included:

    - Reduce recovery time after unclean unmount by read-ahead. (60-65
      percent reduction is measured).

    - Shorten the time taken for large file removal by reducing
      redundant inode updates (about 18 percent cutdown measured if
      metadata is cached on memory).  Jiro SEKIBA made a relevant
      contribution for directory operations (thanks, Jiro).

    - Improved log creation which partially applied double buffering
      to hide io latency.

    - Add "norecovery" mount option which skips roll-forward recovery
      and fully avoids disk write for read-only mounts.

    - Reduce latency in block allocation due to DAT metadata updates,
      remove unnecessary locking, and other smaller improvements.

Thanks!

Ryusuke Konishi

--
The following changes since commit 648f4e3e50c4793d9dbf9a09afa193631f76fa26:
  Linus Torvalds (1):
        Linux 2.6.32-rc8

Jiro SEKIBA (12):
      nilfs2: move definition of struct nilfs_btree_node
      nilfs2: Using nobarrier option instead of barrier=off
      nilfs2: cleanup unused match_bool function
      nilfs2: delete mark_inode_dirty in nilfs_new_inode
      nilfs2: delete mark_inode_dirty from nilfs_set_link
      nilfs2: expand inode_inc_link_count and inode_dec_link_count
      nilfs2: delete redundant mark_inode_dirty
      nilfs2: split nilfs_unlink as nilfs_do_unlink and nilfs_unlink
      nilfs2: change return type of nilfs_commit_chunk
      nilfs2: delete mark_inode_dirty in nilfs_commit_chunk
      nilfs2: delete mark_inode_dirty in nilfs_delete_entry
      nilfs2: replace mark_inode_dirty as nilfs_mark_inode_dirty

Ryusuke Konishi (37):
      nilfs2: get rid of BUG_ON use in btree lookup routines
      nilfs2: remove buffer locking in nilfs_mark_inode_dirty
      nilfs2: remove buffer locking from btree code
      nilfs2: stop marking metadata inode dirty within btree operations
      nilfs2: move out mark_inode_dirty calls from bmap routines
      nilfs2: add size option of private object to metadata file allocator
      nilfs2: separate constructor of metadata files
      nilfs2: separate read method of meta data files on super root block
      nilfs2: eliminate inlines to directly read/write inode of metadata files
      nilfs2: hide nilfs_mdt_clear calls in nilfs_mdt_destroy
      nilfs2: unfold nilfs_sufile_block_get_header function
      nilfs2: add local variable to cache the number of clean segments
      nilfs2: simplify nilfs_sufile_get_ncleansegs function
      nilfs2: avoid readahead on metadata file for create mode
      nilfs2: separate function for creating new btree node block
      nilfs2: use nilfs_btnode_create_block function
      nilfs2: remove newblk argument from nilfs_btnode_submit_block
      nilfs2: eliminate nilfs_btnode_get function
      nilfs2: unfold nilfs_palloc_block_get_bitmap function
      nilfs2: add cache framework for persistent object allocator
      nilfs2: add palloc cache to dat
      nilfs2: flush palloc cache before manipulating data pages of GC dat
      nilfs2: add palloc cache to ifile
      nilfs2: insert cache operation in palloc get block routines
      nilfs2: move routine marking segment usage dirty into sufile
      nilfs2: move routine to set segment usage into sufile
      nilfs2: clean up get/put function of a segment usage
      nilfs2: apply readahead for recovery on mount
      nilfs2: move recovery completion into load_nilfs function
      nilfs2: add helper to get if volume is in a valid state
      nilfs2: add norecovery mount option
      nilfs2: use list_splice_tail or list_splice_tail_init
      nilfs2: do not return io error for bio allocation failure
      nilfs2: relocate io status variables to segment buffer
      nilfs2: hide nilfs_write_info struct in segment buffer code
      nilfs2: add iterator for segment buffers
      nilfs2: separate wait function from nilfs_segctor_write

 Documentation/filesystems/nilfs2.txt |    7 +-
 fs/nilfs2/alloc.c                    |  108 ++++++++--
 fs/nilfs2/alloc.h                    |   21 ++
 fs/nilfs2/bmap.c                     |    8 -
 fs/nilfs2/btnode.c                   |   76 +++----
 fs/nilfs2/btnode.h                   |    6 +-
 fs/nilfs2/btree.c                    |  106 ++++-------
 fs/nilfs2/btree.h                    |   22 --
 fs/nilfs2/cpfile.c                   |   26 +++
 fs/nilfs2/cpfile.h                   |    3 +
 fs/nilfs2/dat.c                      |   47 +++++
 fs/nilfs2/dat.h                      |    3 +
 fs/nilfs2/dir.c                      |   24 +--
 fs/nilfs2/gcdat.c                    |    3 +
 fs/nilfs2/gcinode.c                  |    6 +-
 fs/nilfs2/ifile.c                    |   35 ++++
 fs/nilfs2/ifile.h                    |    2 +
 fs/nilfs2/inode.c                    |    7 +-
 fs/nilfs2/mdt.c                      |   56 ++++--
 fs/nilfs2/mdt.h                      |   25 +--
 fs/nilfs2/namei.c                    |   83 +++++---
 fs/nilfs2/recovery.c                 |   34 ++--
 fs/nilfs2/segbuf.c                   |  185 ++++++++++++-----
 fs/nilfs2/segbuf.h                   |   54 ++----
 fs/nilfs2/segment.c                  |  369 ++++++++++++++++------------------
 fs/nilfs2/segment.h                  |    2 +
 fs/nilfs2/sufile.c                   |  203 ++++++++++---------
 fs/nilfs2/sufile.h                   |   14 +-
 fs/nilfs2/super.c                    |   88 +++------
 fs/nilfs2/the_nilfs.c                |  157 ++++++++-------
 fs/nilfs2/the_nilfs.h                |   10 +
 include/linux/nilfs2_fs.h            |   24 +++
 32 files changed, 1026 insertions(+), 788 deletions(-)
