Return-Path: <linux-kernel-owner+w=401wt.eu-S1760827AbZFLM5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760827AbZFLM5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758317AbZFLMyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:54:46 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52308 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757353AbZFLMyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:54:22 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, dedekind1@gmail.com,
       fweisbec@gmail.com
Subject: [PATCH 0/15] Per-bdi writeback flusher threads v10
Date: Fri, 12 Jun 2009 14:54:00 +0200
Message-Id: <1244811255-5391-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's the 10th version of the writeback patches. Changes since v9:

- Fix bdi task exit race leaving work on the list, flush it after we
  know we cannot be found anymore.
- Rename flusher tasks from bdi-foo to flush-foo. Should make it more
  clear to the casual observer.
- Fix a problem with the btrfs bdi register patch that would spew
  warnings for > 1 mounted btrfs file system.
- Rebase to current -git, there were some conflicts with the latest work
  from viro/hch.
- Fix a block layer core problem were stacked devices would overwrite
  the bdi state, causing problems and warning spew.
- In bdi_writeback_all(), in the race occurence of a work allocation
  failure, restart scanning from the beginning. Then we can drop the
  bdi_lock mutex before diving into bdi specific writeback.
- Convert bdi_lock to a spinlock.
- Use spin_trylock() in bdi_writeback_all(), if this isn't a data
  integrity writeback. Debatable, I kind of like it...
- Get rid of BDI_CAP_FLUSH_FORKER, just check for match with the
  default_backing_dev_info.
- Fix race in list checking in bdi_forker_task().


For ease of patching, I've put the full diff here:

  http://kernel.dk/writeback-v10.patch

and also stored this in a writeback-v10 branch that will not change,
you can pull that into Linus tree from here:

  git://git.kernel.dk/linux-2.6-block.git writeback-v10

Please test and report results/interesting finds. Thanks!

 b/block/blk-core.c            |    6 
 b/block/blk-settings.c        |    4 
 b/drivers/block/aoe/aoeblk.c  |    1 
 b/drivers/char/mem.c          |    1 
 b/fs/btrfs/disk-io.c          |   27 -
 b/fs/buffer.c                 |    2 
 b/fs/char_dev.c               |    1 
 b/fs/configfs/inode.c         |    1 
 b/fs/fs-writeback.c           |  818 +++++++++++++++++++++++++++-------
 b/fs/fuse/inode.c             |    1 
 b/fs/hugetlbfs/inode.c        |    1 
 b/fs/nfs/client.c             |    1 
 b/fs/ocfs2/dlm/dlmfs.c        |    1 
 b/fs/ramfs/inode.c            |    1 
 b/fs/super.c                  |    3 
 b/fs/sysfs/inode.c            |    1 
 b/fs/ubifs/super.c            |    4 
 b/include/linux/backing-dev.h |   72 ++
 b/include/linux/fs.h          |   11 
 b/include/linux/writeback.h   |   15 
 b/kernel/cgroup.c             |    1 
 b/mm/Makefile                 |    2 
 b/mm/backing-dev.c            |  519 +++++++++++++++++++++
 b/mm/page-writeback.c         |  157 ------
 b/mm/swap_state.c             |    1 
 b/mm/vmscan.c                 |    2 
 mm/pdflush.c                  |  269 -----------
 27 files changed, 1317 insertions(+), 606 deletions(-)

-- 
Jens Axboe

