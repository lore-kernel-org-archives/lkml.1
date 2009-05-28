Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbZE1LrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbZE1LrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756971AbZE1Lqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:46:46 -0400
Received: from brick.kernel.dk ([93.163.65.50]:58653 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbZE1Lqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:46:45 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: [PATCH 0/11] Per-bdi writeback flusher threads v9
Date: Thu, 28 May 2009 13:46:33 +0200
Message-Id: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's the 9th version of the writeback patches. Changes since v8:

- Fix a bdi_work on-stack allocation hang. I hope this fixes Ted's
  issue.
- Get rid of the explicit wait queues, we can just use wake_up_process()
  since it's just for that one task.
- Add separate "sync_supers" thread that makes sure that the dirty
  super blocks get written. We cannot safely do this from bdi_forker_task(),
  as that risks deadlocking on ->s_umount. Artem, I implemented this
  by doing the wake ups from a timer so that it would be easier for you
  to just deactivate the timer when there are no super blocks.

For ease of patching, I've put the full diff here:

  http://kernel.dk/writeback-v9.patch

and also stored this in a writeback-v9 branch that will not change,
you can pull that into Linus tree from here:

  git://git.kernel.dk/linux-2.6-block.git writeback-v9

 block/blk-core.c            |    1 +
 drivers/block/aoe/aoeblk.c  |    1 +
 drivers/char/mem.c          |    1 +
 fs/btrfs/disk-io.c          |   24 +-
 fs/buffer.c                 |    2 +-
 fs/char_dev.c               |    1 +
 fs/configfs/inode.c         |    1 +
 fs/fs-writeback.c           |  804 ++++++++++++++++++++++++++++-------
 fs/fuse/inode.c             |    1 +
 fs/hugetlbfs/inode.c        |    1 +
 fs/nfs/client.c             |    1 +
 fs/ntfs/super.c             |   33 +--
 fs/ocfs2/dlm/dlmfs.c        |    1 +
 fs/ramfs/inode.c            |    1 +
 fs/super.c                  |    3 -
 fs/sync.c                   |    2 +-
 fs/sysfs/inode.c            |    1 +
 fs/ubifs/super.c            |    1 +
 include/linux/backing-dev.h |   73 ++++-
 include/linux/fs.h          |   11 +-
 include/linux/writeback.h   |   15 +-
 kernel/cgroup.c             |    1 +
 mm/Makefile                 |    2 +-
 mm/backing-dev.c            |  518 ++++++++++++++++++++++-
 mm/page-writeback.c         |  151 +------
 mm/pdflush.c                |  269 ------------
 mm/swap_state.c             |    1 +
 mm/vmscan.c                 |    2 +-
 28 files changed, 1286 insertions(+), 637 deletions(-)

-- 
Jens Axboe


