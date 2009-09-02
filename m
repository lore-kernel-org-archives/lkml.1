Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbZIBInZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbZIBInZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 04:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbZIBInY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 04:43:24 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42797 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbZIBInX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 04:43:23 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org, jack@suse.cz
Subject: [PATCH 0/8] Per-bdi writeback flusher threads v17
Date: Wed,  2 Sep 2009 10:42:39 +0200
Message-Id: <1251880967-1136-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Continuing the daily releases of this patchset to ensure it's in
solid shape for 2.6.32, here's version 17. Changes since v16:

- Looking at the callers of sb writeback, WB_SYNC_ALL (data integrity)
  writeback already has the super_block pinned and doesn't require
  any further actions. So go back to the down_read_trylock() method
  of pinning the sb and also check for sb->s_root for WB_SYNC_NONE
  writeout. This is all packaged into pin_sb_for_writeback() and
  unpin_sb_for_writeback().
- Get rid of exported generic_sync_sb_inodes() and export sync_inodes_sb()
  for non-integrity writeback and sync_inodes_sb_wait() for integrity
  writeback, as suggested by hch.
- Folded the 'move sb argument to wbc' into the main patch, with the
  addition of the above sync_inodes_sb()/sync_inodes_sb_wait() it
  didn't make sense to keep it separate anymore because wbc isn't
  passed in outside of the code.
- Update the changelog on the main patch, the one switching to per-bdi
  flushing.

Please review, thanks!

 b/block/blk-core.c                 |    1 
 b/drivers/block/aoe/aoeblk.c       |    1 
 b/drivers/char/mem.c               |    1 
 b/drivers/staging/pohmelfs/inode.c |    9 
 b/fs/btrfs/disk-io.c               |    1 
 b/fs/buffer.c                      |    2 
 b/fs/char_dev.c                    |    1 
 b/fs/configfs/inode.c              |    1 
 b/fs/fs-writeback.c                |  998 +++++++++++++++++++++--------
 b/fs/fuse/inode.c                  |    1 
 b/fs/hugetlbfs/inode.c             |    1 
 b/fs/nfs/client.c                  |    1 
 b/fs/ocfs2/dlm/dlmfs.c             |    1 
 b/fs/ramfs/inode.c                 |    1 
 b/fs/super.c                       |    3 
 b/fs/sync.c                        |   10 
 b/fs/sysfs/inode.c                 |    1 
 b/fs/ubifs/budget.c                |   16 
 b/fs/ubifs/super.c                 |    9 
 b/include/linux/backing-dev.h      |   56 +
 b/include/linux/fs.h               |    8 
 b/include/linux/writeback.h        |   23 
 b/kernel/cgroup.c                  |    1 
 b/kernel/sysctl.c                  |    8 
 b/mm/Makefile                      |    2 
 b/mm/backing-dev.c                 |  379 ++++++++++-
 b/mm/page-writeback.c              |  174 +----
 b/mm/swap_state.c                  |    1 
 b/mm/vmscan.c                      |    2 
 mm/pdflush.c                       |  269 -------
 30 files changed, 1238 insertions(+), 744 deletions(-)

-- 
Jens Axboe

