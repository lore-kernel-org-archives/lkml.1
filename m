Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbZEYHcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbZEYHcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbZEYHcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:32:08 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38669 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbZEYHbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:31:17 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com
Subject: [PATCH 0/12] Per-bdi writeback flusher threads #5
Date: Mon, 25 May 2009 09:30:43 +0200
Message-Id: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's the 5th version of the writeback patches. Changes since v4:

- Missing memory barrier before wake_up_bit() could cause weird stalls,
  now fixed.
- Use dynamic bdi_work allocation in bdi_start_writeback(). We still
  fall back to the stack allocation if this should fail. But with the
  dynamic we don't have to wait for wb threads to have noticed the work,
  so the dynamic allocaiton avoids that (small) serialization point.
- Pass down wbc->sync_mode so queued work doesn't always use
  WB_SYNC_NONE in __wb_writeback() (Thanks Jan Kara).
- Don't check background threshold for WB_SYNC_ALL in __wb_writeback.
  This would sometimes leave dirty data around when the system became
  idle.
- Make bdi_writeback_all() and the write path from
  generic_sync_sb_inodes() write out in-line instead of punting to the
  wb threads. This retains the behaviour we have in the kernel now and
  also fixes the oops reported by Yanmin Zhang.
- Replace rcu/spin_lock_bh protected bdi_list and bdi_pending_list with
  a simple mutex. This both simplied the code (and allowed for the above
  fix easily) and made the locking there more trivial. This doesn't
  hurt the fast path, since that path is generally only done for full
  system sync.
- Let bdi_forker_task() wake up at dirty_writeback_interval like the wb
  threads, so that potential dirty data on the default_backing_dev_info
  gets flushed at the same intervals.
- When bdi_forker_task() wakes up, let it scan the bdi_list for bdi's
  with dirty data. If it finds one and it doesn't have an associated
  writeback thread, start one. Otherwise we could have to reach memory
  pressure conditions before some threads got started, meaning that
  dirty data for those almost idle devices sat around for a long time.
- Call try_to_freeze() in bdi_forker_task(). It's defined as freezable,
  so if we don't freeze then we get hangs on suspend.
- Pull out the ntfs sb_has_dirty_io() part and add it at the front as a
  preparatory patch. Ditto the btrfs bdi register patch.
- Shuffle some patches around for a cleaner series. Made sure it's all
  bisectable.

I ran performance testing again and compared to v4, and as expected it's
the same. The changes are mostly in the sync(1) or umount writeback
paths, so the general writeback functions like in v4.

This should be pretty much final and mergeable. So please run your
favorite performance benchmarks that exercise buffered writeout and
report any problems and/or performance differences (good as well as bad,
please). Thanks!

-- 
Jens Axboe

