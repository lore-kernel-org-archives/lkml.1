Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbZHaMPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbZHaMPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbZHaMPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:15:22 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41704 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbZHaMPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:15:21 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: [PATCH 0/10] Per-bdi writeback flusher threads v14
Date: Mon, 31 Aug 2009 14:14:41 +0200
Message-Id: <1251720891-19793-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's the 14th version of the writeback patches. Changes since v13:

- Integrate Jan Kara's cleaner flag handling for the bdi work items.
- Protect writeback_single_inode() with s_umount held, so that we don't
  race with umount or remount. Also from Jan Kara.
- Added Ted's patch for increasing the default ->nr_to_write and
  exposing a proc file to modify it from userspace.
- Sync with latest -git, should apply to -rc8 and current HEAD fine.

I think this is still cleaner than maintaining per-sb inode lists,
as it allows us easier flexibility with adding more threads per sb
and also more backing devices per sb.

For ease of patching, I've put the full diff here:

  http://kernel.dk/writeback-v14.patch

and also stored this in a writeback-v14 branch that will not change,
you can pull that into Linus tree from here:

  git://git.kernel.dk/linux-2.6-block.git writeback-v14

Please test and report results/interesting finds. Thanks! The target
for this patchset is 2.6.32 and it'll be sitting (and has been for the past
week approx) in -next until then. I've did a quick test on XFS, the results
are here:

  http://kernel.dk/dd-md0-xfs-flush.png

for this patchset, and:

  http://kernel.dk/dd-md0-xfs-pdflush.png

for stock mainline (-git). It's two apps, each writing a file with buffered
IO.  It was generated with seekwatcher kicking off a fio run, and it's
logging actual disk throughput. I think the results speak for themselves.
Note that the run was done WITHOUT increasing ->nr_to_write.

 b/block/blk-core.c            |    1 
 b/drivers/block/aoe/aoeblk.c  |    1 
 b/drivers/char/mem.c          |    1 
 b/fs/btrfs/disk-io.c          |    1 
 b/fs/buffer.c                 |    2 
 b/fs/char_dev.c               |    1 
 b/fs/configfs/inode.c         |    1 
 b/fs/fs-writeback.c           |  769 ++++++++++++++++++++++++++--------
 b/fs/fuse/inode.c             |    1 
 b/fs/hugetlbfs/inode.c        |    1 
 b/fs/nfs/client.c             |    1 
 b/fs/ocfs2/dlm/dlmfs.c        |    1 
 b/fs/ramfs/inode.c            |    1 
 b/fs/super.c                  |    3 
 b/fs/sync.c                   |    2 
 b/fs/sysfs/inode.c            |    1 
 b/fs/ubifs/super.c            |    1 
 b/include/linux/backing-dev.h |   71 +++
 b/include/linux/fs.h          |   11 
 b/include/linux/writeback.h   |   16 
 b/kernel/cgroup.c             |    1 
 b/kernel/sysctl.c             |    8 
 b/mm/Makefile                 |    2 
 b/mm/backing-dev.c            |  533 +++++++++++++++++++++++
 b/mm/page-writeback.c         |  165 +------
 b/mm/swap_state.c             |    1 
 b/mm/vmscan.c                 |    2 
 mm/pdflush.c                  |  269 -----------
 28 files changed, 1270 insertions(+), 598 deletions(-)

-- 
Jens Axboe


