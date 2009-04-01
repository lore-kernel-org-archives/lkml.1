Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZDALFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZDALFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbZDALE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:04:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:35183 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbZDALE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:04:56 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org
Subject: [GIT PATCHSET block#for-linus] block: blk-map related fixes
Date: Wed,  1 Apr 2009 20:04:36 +0900
Message-Id: <1238583884-13517-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 11:04:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jens.

Upon ack, please pull from the following git tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blk-map-fixes
 http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=blk-map-fixes

This patchset contains the following eight patches to fix subtle bugs
in scatterlist and blk-map and are candidates for 2.6.30 inclusion.

 0001-scatterlist-make-sure-sg_miter_next-doesn-t-retur.patch
 0002-block-fix-SG_IO-vector-request-data-length-handling.patch
 0003-block-fix-queue-bounce-limit-setting.patch
 0004-bio-actually-inline-inline-bvecs-into-bio.patch
 0005-bio-fix-bio_kmalloc.patch
 0006-bio-remove-size-segments-limit-on-bio_-copy-map-_-u.patch
 0007-blk-map-let-blk_rq_map_user_iov-support-null-mapp.patch
 0008-blk-map-reimplement-blk_rq_map_user-using-blk_rq_.patch

0001 fixes a subtle bug in sg mapping iterator where zero-size maps
were returned.  The bug isn't critical but can sometimes lead to
unexpected results (when testing for full consumption for example).

0002 is visible to userland.  It fixes block iovec SG_IOs such that
when sghdr->dxfer_len and the data length in the iovec disagrees, the
shorter one wins instead of failing as described in the SG_IO howto.

0003 is pretty critical.  The bug means that GFP_DMA is set in
q->bounce_gfp for many ATA controllers on x86_64 which leads to OOM if
large SG_IO is issued.

0004-0008 fixes bio_kmalloc(), removes bio-imposed segment and length
limit when using bio_kmalloc() and makes blk_rq_map_{user|kern}*()
functions always use single bio instead of chain of bios.  It's not
only simpler but also makes sure the resulting request falls inside
queue limits as a whole.  Previously, only each bio was checked for
limits, so the whole request could go over the limits.

This patchset is on top of the current linux-2.6-block#for-linus[1]
and contains the following changes.

 block/blk-map.c            |  119 +++------------------------------------------
 block/blk-settings.c       |   20 ++++---
 block/scsi_ioctl.c         |   13 ++++
 drivers/md/dm-io.c         |    4 -
 drivers/md/dm.c            |    4 -
 drivers/scsi/scsi_lib.c    |    3 -
 fs/bio.c                   |   97 +++++++++++++++++++-----------------
 fs/btrfs/extent_io.c       |    2 
 fs/ext4/extents.c          |    4 -
 fs/xfs/linux-2.6/xfs_buf.c |    2 
 include/linux/bio.h        |   16 +++---
 lib/scatterlist.c          |    9 ++-
 12 files changed, 109 insertions(+), 184 deletions(-)

Thanks.

--
tejun

[1] 714ed0cf62319b14dc327273a7339a9a199fe046
