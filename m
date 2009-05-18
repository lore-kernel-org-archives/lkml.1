Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbZERMUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbZERMUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 08:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbZERMTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 08:19:55 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38013 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbZERMTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 08:19:53 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com
Subject: [PATCH 0/11] Per-bdi writeback flusher threads #4
Date: Mon, 18 May 2009 14:19:41 +0200
Message-Id: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the fourth version of this patchset. Chances since v3:

- Dropped a prep patch, it has been included in mainline since.

- Add a work-to-do list to the bdi. This is struct bdi_work. Each
  wb thread will notice and execute work on bdi->work_list. The arguments
  are which sb (or NULL for all) to flush and how many pages to flush.

- Fix a bug where not all bdi's would end up on the bdi_list, so potentially
  some data would not be flushed.

- Make wb_kupdated() pass on wbc->older_than_this so we maintain the same
  behaviour for kupdated flushes.

- Have the wb thread flush first before sleeping, to avoid losing the
  first flush on lazy register.

- Rebase to newer kernels.

- Little fixes here and there.

So generally not a lot of changes, the major one is using the ->work_list
and getting rid of writeback_acquire()/writeback_release(). This fixes
the concern Jan Kara had about missing sync/WB_SYNC_ALL, if writeback
was already in progress.

I've run a few benchmarks today:

1) Large file writes from a single process
2) Random file writes from multiple (16) processes.

Each benchmark was run 3 times on each kernel. The disk used was an
Intel X25-E and it was security erased before each run for consistency.
2.6.30-rc6 (22ef37eed673587ac984965dc88ba94c68873291) is the baseline
at 100. Filesystem was ext4 without barriers. The system was a Core 2
Quad with 2G of memory.

Kernel		Test		TPS		CPU
---------------------------------------------------
Baseline	1		100		100
Writeback	1		101		 95
Baseline	2		100		100
Writeback	2		105		 94

For the sequential test, speed is almost identical, but CPU usage is a
lot lower. For the random write case with 16 threads, transaction rate
is up for the writeback patches while the CPU usage is down as well.
So pretty good results for this initial test, I'd expect larger
improvements on systems with more disks. As soon as Intel sends me
4 more drives for testing, I'll update the results :-)

You can pull the patches from the block git repo, branch is 'writeback':

  git://git.kernel.dk/linux-2.6-block.git writeback

---

 b/block/blk-core.c            |    1 
 b/drivers/block/aoe/aoeblk.c  |    1 
 b/drivers/char/mem.c          |    1 
 b/fs/btrfs/disk-io.c          |   24 +
 b/fs/buffer.c                 |    2 
 b/fs/char_dev.c               |    1 
 b/fs/configfs/inode.c         |    1 
 b/fs/fs-writeback.c           |  689 ++++++++++++++++++++++++++++++++----------
 b/fs/fuse/inode.c             |    1 
 b/fs/hugetlbfs/inode.c        |    1 
 b/fs/nfs/client.c             |    1 
 b/fs/ntfs/super.c             |   32 -
 b/fs/ocfs2/dlm/dlmfs.c        |    1 
 b/fs/ramfs/inode.c            |    1 
 b/fs/super.c                  |    3 
 b/fs/sync.c                   |    2 
 b/fs/sysfs/inode.c            |    1 
 b/fs/ubifs/super.c            |    1 
 b/include/linux/backing-dev.h |   74 ++++
 b/include/linux/fs.h          |   11 
 b/include/linux/writeback.h   |   15 
 b/kernel/cgroup.c             |    1 
 b/mm/Makefile                 |    2 
 b/mm/backing-dev.c            |  481 ++++++++++++++++++++++++++++-
 b/mm/page-writeback.c         |  144 --------
 b/mm/swap_state.c             |    1 
 b/mm/vmscan.c                 |    2 
 mm/pdflush.c                  |  269 ----------------
 28 files changed, 1130 insertions(+), 634 deletions(-)

-- 
Jens Axboe

