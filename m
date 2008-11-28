Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbYK1Ed5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbYK1Ed5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 23:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbYK1Ech
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 23:32:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:45261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220AbYK1Ecg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 23:32:36 -0500
From: Tejun Heo <tj@kernel.org>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCHSET block#for-2.6.29] block: simplify and fix empty barrier
Date: Fri, 28 Nov 2008 13:32:01 +0900
Message-Id: <1227846727-24980-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Nov 2008 04:32:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello, Jens.

As it currently stands, empty barrier is being handled a little bit
differently from other types of barriers.  It wraps around the normal
barrier implementation but intercepts BAR issue and completes it in
elv_next_request() without letting the low level driver see it.  This
works but is a little bit hacky.

The barrier or ordered sequence implementation is already quite
flexible to accomodate different modes, it just needs small
adjustments to support empty barrier in similar way different barrier
modes are handled.

This patchset updates start_ordered() and ordered sequence completion
more flexible such that BAR itself can be made optional and
reimplements empty barrier by simply turning off DO_BAR and
DO_POSTFLUSH flags in start_ordered().

This patchset also fixes empty barrier on write-through (or no cache)
w/ ordered tag.  Previously, this basically desolved into noop and
without any command to issue, ordering by tag wasn't enforced at all.
This patchset promotes such empty barriers to DRAIN.

This patchset contains the following six patches.

 0001-block-reorganize-QUEUE_ORDERED_-constants.patch
 0002-block-remove-duplicate-or-unused-barrier-discard-er.patch
 0003-block-make-every-barrier-action-optional.patch
 0004-block-make-barrier-completion-more-robust.patch
 0005-block-simplify-empty-barrier-implementation.patch
 0006-block-fix-empty-barrier-on-write-through-w-ordered.patch

0001-0002 preps for the following changes.  0003-0004 makes ordered
sequence implementation more flexible.  0005 simplifies empty barrier
implementation and 0006 fixes the noop bug.

This patchset is on top of

  linux-2.6-block#for-2.6.29 (75f2e95a9641224c7077d5e677f2a5fe2fdd4f0e)
+ block-internal-dequeue-shouldnt-start-timer [1]

and contains the following changes.

 block/blk-barrier.c    |  120 +++++++++++++++++++++++++++++++------------------
 block/blk-core.c       |   44 ++++-------------
 block/elevator.c       |   18 ++-----
 include/linux/blkdev.h |   47 +++++++++++--------
 4 files changed, 122 insertions(+), 107 deletions(-)

Thanks.

--
tejun

[1] http://article.gmane.org/gmane.linux.kernel/763054
