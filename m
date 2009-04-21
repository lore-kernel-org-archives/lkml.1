Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbZDUQiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbZDUQiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbZDUQiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:38:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:40085 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755188AbZDUQiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:38:10 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Subject: [GIT PATCH linux-2.6-block] block: cleanup patches, take#3
Date: Wed, 22 Apr 2009 01:37:47 +0900
Message-Id: <1240331881-28218-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 16:38:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Upon ack, please pull from the following git tree, which pulls in
linux-2.6-ide#for-next into linux-2.6-block#for-next and applies this
patchset on top of it.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-cleanup

This is the third take of block-cleanup-patches.  Changes from the
last take[L] are

* All ide changes including L0001-0003 are separated out and merged
  through linux-2.6-ide#for-next and pulled into
  linux-2.6-block#for-next.

* L0015-block-kill-end_request.patch replaced with
  0012-block-replace-end_request-with-__-blk_end_reques.patch.

* L0016-ubd-simplify-block-request-completion.patch
  L0017-block-clean-up-unnecessary-stuff-from-block-drivers.patch are
  postponed to later patchset.

* 0013-0014 to kill rq->data added.

* Updated to the current #for-next.

 0001-block-merge-blk_invoke_request_fn-into-__blk_run_.patch
 0002-block-kill-blk_start_queueing.patch
 0003-block-don-t-set-REQ_NOMERGE-unnecessarily.patch
 0004-block-cleanup-REQ_SOFTBARRIER-usages.patch
 0005-block-clean-up-misc-stuff-after-block-layer-timeout.patch
 0006-block-reorder-request-completion-functions.patch
 0007-block-reorganize-request-fetching-functions.patch
 0008-block-kill-blk_end_request_callback.patch
 0009-block-clean-up-request-completion-API.patch
 0010-block-move-rq-start_time-initialization-to-blk_rq_.patch
 0011-block-implement-and-use-__-blk_end_request_all.patch
 0012-block-replace-end_request-with-__-blk_end_reques.patch
 0013-block-don-t-abuse-rq-data.patch
 0014-block-kill-data.patch

0001-0011 are mostly identical to L0004-0014.  L0015 incorrectly
replaced end_request() with __blk_end_request_all().  0012 adds
[__]blk_end_request_cur() and replaces end_request() with it.

With ide changes pulled in, omap is the only user of rq->data, 0013
makes it use only rq->special and 0014 kills rq->data.

This patchset is on top of

linux-2.6-block#for-next(a95320f3ede3f028837a621715cd352e83ffe7c2)
+ linux-2.6-ide#for-next(2ecf0a57c60dcb588f310d94412118e15c510532)

and contains the following changes.

 arch/arm/plat-omap/mailbox.c        |   54 ++--
 block/as-iosched.c                  |    6 
 block/blk-barrier.c                 |    9 
 block/blk-core.c                    |  486 ++++++++++++++----------------------
 block/blk-exec.c                    |    1 
 block/blk-map.c                     |    6 
 block/blk-timeout.c                 |   22 -
 block/blk.h                         |   37 ++
 block/cfq-iosched.c                 |    6 
 block/elevator.c                    |  137 ----------
 block/scsi_ioctl.c                  |    1 
 drivers/block/amiflop.c             |   10 
 drivers/block/ataflop.c             |   14 -
 drivers/block/cpqarray.c            |    3 
 drivers/block/hd.c                  |   14 -
 drivers/block/mg_disk.c             |   16 -
 drivers/block/paride/pcd.c          |   12 
 drivers/block/paride/pd.c           |    5 
 drivers/block/paride/pf.c           |   28 +-
 drivers/block/ps3disk.c             |    6 
 drivers/block/swim.c                |   14 -
 drivers/block/swim3.c               |   26 -
 drivers/block/sx8.c                 |    3 
 drivers/block/virtio_blk.c          |    2 
 drivers/block/xd.c                  |   15 -
 drivers/block/xen-blkfront.c        |    6 
 drivers/block/xsysace.c             |    4 
 drivers/block/z2ram.c               |    4 
 drivers/cdrom/gdrom.c               |    8 
 drivers/cdrom/viocd.c               |   25 -
 drivers/memstick/core/mspro_block.c |    2 
 drivers/message/i2o/i2o_block.c     |    2 
 drivers/mtd/mtd_blkdevs.c           |   22 -
 drivers/s390/block/dasd.c           |   17 -
 drivers/s390/char/tape_block.c      |   15 -
 drivers/sbus/char/jsflash.c         |    8 
 drivers/scsi/scsi_lib.c             |    3 
 include/linux/blkdev.h              |  173 ++++++++++--
 38 files changed, 559 insertions(+), 663 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/807554
