Return-Path: <linux-kernel-owner+w=401wt.eu-S1762080AbZCXQG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762080AbZCXQG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758908AbZCXQGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:06:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:41793 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761399AbZCXQG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:06:29 -0400
From: Tejun Heo <tj@kernel.org>
To: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: [PATCHSET pata-2.6] ide: rq->buffer, data, special and misc cleanups
Date: Wed, 25 Mar 2009 01:06:02 +0900
Message-Id: <1237910776-10983-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 16:06:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Bartlomiej, Jens.

This patchset contains mostly IDE cleanups around rq->buffer, data and
special usage.  Over time, the meanings of those three fields became
blurry.  Be default, they mean

->buffer  : kernel address of the current bio segment, NULL for !bio
	    requests and could be NULL if the address is high

->data    : direct data pointer specified by LLD for !fs requests

->special : LLD-specific pointer for special requests, opaque to block
	    layer, also used as general opaque pointer

Currently, IDE is the biggest offender to the above conventions and
uses all three fields as opaque pointers depending on situation.  This
complicates both IDE and block layer.  Also, with SCSI completely
switched over to bio for everything, there only very few places which
still use direct pointer for !fs requests.  This patchset updates IDE
such that it only uses special for opaque pointer and always uses bio
for data handling.

This patchset contains the following patches.

 0001-block-clear-req-errors-on-bio-completion-only-for.patch
 0002-block-reorganize-__-bio_map_kern.patch
 0003-block-implement-blk_rq_map_kern_prealloc.patch
 0004-ide-use-blk_run_queue-instead-of-blk_start_queuei.patch
 0005-ide-don-t-set-REQ_SOFTBARRIER.patch
 0006-ide-kill-unused-ide_cmd-special.patch
 0007-ide-cd-clear-sense-buffer-before-issuing-request-se.patch
 0008-ide-floppy-block-pc-always-uses-bio.patch
 0009-ide-taskfile-don-t-abuse-rq-buffer.patch
 0010-ide-atapi-don-t-abuse-rq-buffer.patch
 0011-ide-cd-don-t-abuse-rq-buffer.patch
 0012-ide-pm-don-t-abuse-rq-data.patch
 0013-ide-atapi-use-bio-for-request-sense.patch
 0014-ide-cd-use-bio-for-request-sense.patch

0001-0003 are block layer ones.  As IDE uses data requests which
aren't either FS or PC, 0001 update rq completion such that rq->errors
is not cleared accidentally for those requests.  0002-0003 implements
blk_rq_map_kern_prealloc() which will be used for bio-mapping sense
buffer.  This is necessary because IDE issues request sense from IRQ
context.  I think it would be best if this first three patches can go
through pata-2.6 as impact on other blk users is minimal (0001 has
possbility of affecting other users but all the current few users look
okay).  Jens, what do you think?

0004-0007 are misc cleanup patches.

0008 drops unnecessary rq->data handling path from
idefloppy_blockpc_cmd() as block PCs always use bio for data transfer.

0009-0014 clean up rq->buffer and data usages.  If it's used for
opaque pointer, rq->special is used instead.  If for data, the data is
mapped using either blk_rq_map_kern() or blk_rq_map_kern_prealloc().

ide-cd and floppy are tested.  I don't have access to ide tape device,
so it hasn't been tested but given that atapi changes are shared
between floppy and tape, I don't think too much could be broken for
tape.  I'm trying to get a IDE tape drive but it's quite difficult to
come by over here.  :-(

This patchset will allow further IDE and block layer cleanup and ease
future improvements to block layer.

This patchset is on top of linux-next pata-2.6 tree as of 2009-03-23.
Git tree is available at the following vector but please DO NOT pull
from the following git tree as pata-2.6 tree is quilt-based and the
base tree I used isn't the one which is gonna go upstream.  The
following tree is for review only.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git ide-phase1

Bartlomiej, if you're okay with the changes and Jens acks the patches
and pushing the first three patches via pata-2.6, please feel free to
include these patches into your tree.

This patchset contains the following changes.

 block/blk-core.c           |   10 +++--
 block/blk-map.c            |   50 ++++++++++++++++++++++++++++
 drivers/ide/ide-atapi.c    |   42 +++++++++++++----------
 drivers/ide/ide-cd.c       |   51 ++++++++++++++---------------
 drivers/ide/ide-disk.c     |    1
 drivers/ide/ide-floppy.c   |   16 +++------
 drivers/ide/ide-io.c       |    7 +--
 drivers/ide/ide-ioctls.c   |    1
 drivers/ide/ide-park.c     |    7 +--
 drivers/ide/ide-pm.c       |   36 +++++++-------------
 drivers/ide/ide-tape.c     |   10 +++--
 drivers/ide/ide-taskfile.c |   18 ++++++----
 fs/bio.c                   |   79 ++++++++++++++++++++++++++-------------------
 include/linux/bio.h        |    3 +
 include/linux/blkdev.h     |    4 ++
 include/linux/ide.h        |    4 +-
 16 files changed, 205 insertions(+), 134 deletions(-)

Thanks.

--
tejun
