Return-Path: <linux-kernel-owner+w=401wt.eu-S932913AbZIDHrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913AbZIDHrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933014AbZIDHr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:47:29 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44483 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932674AbZIDHr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:47:27 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org, jack@suse.cz
Subject: [PATCH 0/8] Per-bdi writeback flusher threads v18
Date: Fri,  4 Sep 2009 09:46:38 +0200
Message-Id: <1252050406-22467-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the 18th release of the writeback patchset. Changes since
v17 include:

- Change the naming of sync_sb_inodes() and sync_sb_inodes_wait(). It's
  now writeback_inodes_sb() to start writeback on dirty sb inodes, and
  sync_inodes_sb() to start and wait on writeback. Suggestion from Jan
  Kara, and I agree it better explains what the code does.
- Fix compile error in pohmelfs.
- Update Ted's MAX_WRITEBACK_PAGES patch to be MB based instead of in
  pages.
- Integrate the suggestions from Christoph:
	- Move wakeup_flusher_threads() into fs/fs-writeback.c, it fits
	  better there and allows us to make bdi_writeback_all() static.
	- Get rid of generic_sync_sb_inodes(). Move the issue and wait
	  into the two callers instead, making the old function now
	  wait_sb_inodes() and only concerned with waiting on already
	  issued IO.
	- wbc->nr_to_write was mistakenly set to LLONG_MAX instead of
	  LONG_MAX.

Please review, thanks!

 b/block/blk-core.c                 |    1 
 b/drivers/block/aoe/aoeblk.c       |    1 
 b/drivers/char/mem.c               |    1 
 b/drivers/staging/pohmelfs/inode.c |    9 
 b/fs/btrfs/disk-io.c               |    1 
 b/fs/buffer.c                      |    2 
 b/fs/char_dev.c                    |    1 
 b/fs/configfs/inode.c              |    1 
 b/fs/fs-writeback.c                | 1042 +++++++++++++++++++++--------
 b/fs/fuse/inode.c                  |    1 
 b/fs/hugetlbfs/inode.c             |    1 
 b/fs/nfs/client.c                  |    1 
 b/fs/ocfs2/dlm/dlmfs.c             |    1 
 b/fs/ramfs/inode.c                 |    1 
 b/fs/super.c                       |    3 
 b/fs/sync.c                        |   20 
 b/fs/sysfs/inode.c                 |    1 
 b/fs/ubifs/budget.c                |   16 
 b/fs/ubifs/super.c                 |    9 
 b/include/linux/backing-dev.h      |   55 +
 b/include/linux/fs.h               |    8 
 b/include/linux/writeback.h        |   24 
 b/kernel/cgroup.c                  |    1 
 b/kernel/sysctl.c                  |    8 
 b/mm/Makefile                      |    2 
 b/mm/backing-dev.c                 |  379 ++++++++++
 b/mm/page-writeback.c              |  183 -----
 b/mm/swap_state.c                  |    1 
 b/mm/vmscan.c                      |    2 
 mm/pdflush.c                       |  269 -------
 30 files changed, 1267 insertions(+), 778 deletions(-)

-- 
Jens Axboe

