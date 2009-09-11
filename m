Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZIKMlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZIKMlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 08:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbZIKMlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 08:41:06 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50462 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbZIKMlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 08:41:04 -0400
Date: Fri, 11 Sep 2009 14:41:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: What's in linux-2.6-block.git for 2.6.32
Message-ID: <20090911124106.GC14984@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is just the core block bits, I have other branches pending. And a
heads up that I had to rebase this branch today, something I haven't
done during the .31 cycle. This was due to the history being really odd,
with modified patches of for-2.6.32 patches being forwarded to mainline.
So I though it would be better to clean this history and merge fixups.
There was also a middle point that would break bisection.

Nothing really earth shattering in here, nor are there really big
changes for this cycle.

- Some updates to CFQ to improve interactiveness.
- Some cleanups and sanitization of the bio IO flags.
- blk-iopoll, an experimental API for doing NAPI like polled completions
  for really fast devices. In testing this has shown to be faster for
  some cases, while slower for others. The included patch is just the
  core bits, no driver support is being merged yet.
- Enable CPU IO completion by default. My testing has shown this to be
  faster, and independent testing by Intel confirms that as well.
- A fix to only issue a block queue trace when we actually intend to
  queue.
- A fix for splice to update mtime and atime on files.
- A cleanup of the failfast bits and merge fixups for the same.

The changes are availble at:

  git://git.kernel.dk/linux-2.6-block.git for-2.6.32

Ed L. Cashin (1):
      aoe: end barrier bios with EOPNOTSUPP

Eric Dumazet (1):
      cciss: memory leak in cciss_init_one()

Hannes Reinecke (1):
      Send uevents for write_protect changes

Jens Axboe (12):
      cfq-iosched: drain device queue before switching to a sync queue
      block: make bio_rw_flagged() return a bool
      bio: first step in sanitizing the bio->bi_rw flag testing
      block: improve queue_should_plug() by looking at IO depths
      block: add blk-iopoll, a NAPI like approach for block devices
      block: fix long lines in block/blk-iopoll.c
      block: adjust default budget for blk-iopoll
      block: fix comment in blk-iopoll.c
      block: use interrupts disabled version of raise_softirq_irqoff()
      cfq-iosched: get rid of must_alloc flag
      block: make blk_iopoll_prep_sched() follow normal 0/1 return convention
      block: enable rq CPU completion affinity by default

Marcin Slusarz (1):
      block: use printk_once

Miklos Szeredi (1):
      splice: update mtime and atime on files

Minchan Kim (1):
      block: trace bio queueing trial only when it occurs

Nikanth Karthikesan (1):
      Seperate read and write statistics of in_flight requests

Shan Wei (1):
      cfq: fix the log message after dispatched a request

Tejun Heo (3):
      block: use the same failfast bits for bio and request
      block: implement mixed merge of different failfast requests
      scsi,block: update SCSI to handle mixed merge failures

Vivek Goyal (1):
      cfq-iosched: no need to keep track of busy_rt_queues

 block/Makefile              |    2 +-
 block/blk-core.c            |  166 +++++++++++++++++++++++++------
 block/blk-iopoll.c          |  227 +++++++++++++++++++++++++++++++++++++++++++
 block/blk-merge.c           |   51 ++++++++--
 block/blk.h                 |    1 +
 block/cfq-iosched.c         |   71 ++++++--------
 block/elevator.c            |   16 +---
 block/genhd.c               |   22 ++++-
 drivers/block/aoe/aoeblk.c  |    3 +
 drivers/block/cciss.c       |    4 +-
 drivers/block/loop.c        |    2 +-
 drivers/block/paride/pcd.c  |   12 +--
 drivers/block/sx8.c         |    4 +-
 drivers/block/viodasd.c     |   12 +--
 drivers/md/dm-raid1.c       |    2 +-
 drivers/md/dm-stripe.c      |    2 +-
 drivers/md/dm.c             |   28 +++---
 drivers/md/linear.c         |    2 +-
 drivers/md/multipath.c      |    4 +-
 drivers/md/raid0.c          |    2 +-
 drivers/md/raid1.c          |   14 ++-
 drivers/md/raid10.c         |    6 +-
 drivers/md/raid5.c          |    2 +-
 drivers/scsi/scsi_lib.c     |    6 +-
 drivers/staging/dst/dcore.c |    5 +-
 fs/btrfs/volumes.c          |    4 +-
 fs/partitions/check.c       |   12 ++-
 fs/splice.c                 |    8 +-
 include/linux/bio.h         |   69 ++++++-------
 include/linux/blk-iopoll.h  |   48 +++++++++
 include/linux/blkdev.h      |   34 +++++--
 include/linux/genhd.h       |   21 +++--
 include/linux/interrupt.h   |    1 +
 kernel/sysctl.c             |   10 ++-
 34 files changed, 661 insertions(+), 212 deletions(-)
 create mode 100644 block/blk-iopoll.c
 create mode 100644 include/linux/blk-iopoll.h


-- 
Jens Axboe

