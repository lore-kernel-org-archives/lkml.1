Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbZIKOjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbZIKOjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZIKOjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:39:43 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41826 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbZIKOjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:39:42 -0400
Date: Fri, 11 Sep 2009 16:39:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, hch@infradead.org,
       jack@suse.cz
Subject: [GIT PULL] writeback rewrite
Message-ID: <20090911143944.GJ14984@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is something that I have been working on for many months now.
Originally I wanted to merge it for .31, but it was a bit too early. At
least now Jan Kara and Christoph is happy with it, so it should be good
to go.

Essentially this gets rid of pdflush for writeback completely. pdflush
has a number of issues that largely stem from the fact that it has to
work multiple queues at once. So it has to back off on congestion, which
can cause queue access starvation and lumpy writeback. The latter is
very apparent on many setups.

This patchset adds a thread per backing device. The thread will exit if
it has been idle for too long, and will get re-created if we start
seeing dirty inodes on the bdi again. Care is taken to ensure that we
don't get stuck doing that.

Writeback intensive behaviour is much better. I recently generated a
graph with seekwatcher of XFS writing 2 20G files using normal buffered
writeout. The existing code does:

http://kernel.dk/dd-md0-xfs-pdflush.png

while with the patchset we get both a faster and more smooth writeout:

http://kernel.dk/dd-md0-xfs-flush.png

The patchset has been well tested and has been in -next for 3-4 months
or so.

I have a follow-up writeback-postmerge branch with some good cleanups
and performance enhancements too, but I'd like to get this in a day or
two first since I didn't want to mess with the core of these bits
without doing a lot more testing again. That testing can happen while
this is out in the wild.

So please pull this patchset, I think we should merge it early so we
have a good chance to ensure we fixup any regressions should they occur.

  git://git.kernel.dk/linux-2.6-block.git writeback

Jens Axboe (7):
      writeback: get rid of generic_sync_sb_inodes() export
      writeback: move dirty inodes from super_block to backing_dev_info
      writeback: switch to per-bdi threads for flushing data
      writeback: get rid of pdflush completely
      writeback: add some debug inode list counters to bdi stats
      writeback: add name to backing_dev_info
      writeback: check for registered bdi in flusher add and inode dirty

 block/blk-core.c                 |    1 +
 drivers/block/aoe/aoeblk.c       |    1 +
 drivers/char/mem.c               |    1 +
 drivers/staging/pohmelfs/inode.c |    9 +-
 fs/btrfs/disk-io.c               |    1 +
 fs/buffer.c                      |    2 +-
 fs/char_dev.c                    |    1 +
 fs/configfs/inode.c              |    1 +
 fs/fs-writeback.c                | 1065 ++++++++++++++++++++++++++++----------
 fs/fuse/inode.c                  |    1 +
 fs/hugetlbfs/inode.c             |    1 +
 fs/nfs/client.c                  |    1 +
 fs/ocfs2/dlm/dlmfs.c             |    1 +
 fs/ramfs/inode.c                 |    1 +
 fs/super.c                       |    5 +-
 fs/sync.c                        |   20 +-
 fs/sysfs/inode.c                 |    1 +
 fs/ubifs/budget.c                |   16 +-
 fs/ubifs/super.c                 |    9 +-
 include/linux/backing-dev.h      |   55 ++-
 include/linux/fs.h               |    9 +-
 include/linux/writeback.h        |   23 +-
 kernel/cgroup.c                  |    1 +
 mm/Makefile                      |    2 +-
 mm/backing-dev.c                 |  381 +++++++++++++-
 mm/page-writeback.c              |  182 +------
 mm/pdflush.c                     |  269 ----------
 mm/swap_state.c                  |    1 +
 mm/vmscan.c                      |    2 +-
 29 files changed, 1285 insertions(+), 778 deletions(-)
 delete mode 100644 mm/pdflush.c

-- 
Jens Axboe

