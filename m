Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbZFYKm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbZFYKm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbZFYKmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:42:07 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59685 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZFYKmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:42:05 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, fweisbec@gmail.com,
       Alan.Brunelle@hp.com
Subject: [PATCH 0/10] Per-bdi writeback flusher threads v12
Date: Thu, 25 Jun 2009 12:41:53 +0200
Message-Id: <1245926523-21959-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's the 12th version of the writeback patches. Changes since v11:

- Fixup kthread_run() error check, it should use IS_ERR() instead of
  checking for NULL. Thanks Andrew.
- Fix a silly buglet that would quickly respawn otherwise idle threads
  once they had exited. This was due to an inverted if test. Didn't cause
  any harm except potentially too many writeback threads setting idle in
  the system.
- Integrate kupdate periodic writeback with the explicit writeback. Cleans
  that part up.
- Update to 2.6.31-rc1. With the recent patches from viro and hch, v11
  did not apply cleanly at all to 2.6.31-rc1.

For ease of patching, I've put the full diff here:

  http://kernel.dk/writeback-v12.patch

and also stored this in a writeback-v12 branch that will not change,
you can pull that into Linus tree from here:

  git://git.kernel.dk/linux-2.6-block.git writeback-v12

Please test and report results/interesting finds. Thanks! The target
for this patchset is 2.6.32 and it'll be sitting (and has been for the past
week approx) in -next until then.

 b/block/blk-core.c            |    1 
 b/drivers/block/aoe/aoeblk.c  |    1 
 b/drivers/char/mem.c          |    1 
 b/fs/btrfs/disk-io.c          |    1 
 b/fs/buffer.c                 |    2 
 b/fs/char_dev.c               |    1 
 b/fs/configfs/inode.c         |    1 
 b/fs/fs-writeback.c           |  775 +++++++++++++++++++++++++++-------
 b/fs/fuse/inode.c             |    1 
 b/fs/hugetlbfs/inode.c        |    1 
 b/fs/nfs/client.c             |    1 
 b/fs/ocfs2/dlm/dlmfs.c        |    1 
 b/fs/ramfs/inode.c            |    1 
 b/fs/super.c                  |    3 
 b/fs/sysfs/inode.c            |    1 
 b/fs/ubifs/super.c            |    1 
 b/include/linux/backing-dev.h |   71 +++
 b/include/linux/fs.h          |   11 
 b/include/linux/writeback.h   |   15 
 b/kernel/cgroup.c             |    1 
 b/mm/Makefile                 |    2 
 b/mm/backing-dev.c            |  533 +++++++++++++++++++++++
 b/mm/page-writeback.c         |  157 ------
 b/mm/swap_state.c             |    1 
 b/mm/vmscan.c                 |    2 
 mm/pdflush.c                  |  269 -----------
 26 files changed, 1259 insertions(+), 596 deletions(-)

-- 
Jens Axboe


