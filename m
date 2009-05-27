Return-Path: <linux-kernel-owner+w=401wt.eu-S1761359AbZE0JmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761359AbZE0JmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759634AbZE0Jly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:41:54 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41892 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbZE0Jlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:41:53 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: [PATCH 0/11] Per-bdi writeback flusher threads v8
Date: Wed, 27 May 2009 11:41:41 +0200
Message-Id: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's the 8th version of the writeback patches. Changes since v7:

- Fold the "include default_backing_dev_info in writeback" patch into
  the core, we should just do it from the beginning.
- More series cleanup, I think it should be mostly complete now. No
  hunks are split between patches now (things like comments for
  functions added earlier, and so on).
- Fix hang with calling bdi_wait_on_work_clear() inside the bdi_lock
  mutex when the default wb thread had exited.
- Fix hang with queuing work on exited wb thread, it would have no
  receipients since the default wb thread wrongly cleared the bit
  from the register mask on exit. It must be persistent, which is
  why it gets initialized on bdi_register() already.

For ease of patching, I've put the full diff here:

  http://kernel.dk/writeback-v8.patch

and also stored this in a writeback-v7 branch that will not change,
you can pull that into Linus tree from here:

  git://git.kernel.dk/linux-2.6-block.git writeback-v8

 b/block/blk-core.c            |    1 
 b/drivers/block/aoe/aoeblk.c  |    1 
 b/drivers/char/mem.c          |    1 
 b/fs/btrfs/disk-io.c          |   24 -
 b/fs/buffer.c                 |    2 
 b/fs/char_dev.c               |    1 
 b/fs/configfs/inode.c         |    1 
 b/fs/fs-writeback.c           |  807 +++++++++++++++++++++++++++-------
 b/fs/fuse/inode.c             |    1 
 b/fs/hugetlbfs/inode.c        |    1 
 b/fs/nfs/client.c             |    1 
 b/fs/ntfs/super.c             |   33 -
 b/fs/ocfs2/dlm/dlmfs.c        |    1 
 b/fs/ramfs/inode.c            |    1 
 b/fs/super.c                  |    3 
 b/fs/sync.c                   |    2 
 b/fs/sysfs/inode.c            |    1 
 b/fs/ubifs/super.c            |    1 
 b/include/linux/backing-dev.h |   74 +++
 b/include/linux/fs.h          |   11 
 b/include/linux/writeback.h   |   15 
 b/kernel/cgroup.c             |    1 
 b/mm/Makefile                 |    2 
 b/mm/backing-dev.c            |  476 +++++++++++++++++++-
 b/mm/page-writeback.c         |  151 ------
 b/mm/swap_state.c             |    1 
 b/mm/vmscan.c                 |    2 
 mm/pdflush.c                  |  269 -----------
 28 files changed, 1248 insertions(+), 637 deletions(-)

-- 
Jens Axboe

