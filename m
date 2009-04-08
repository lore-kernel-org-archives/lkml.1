Return-Path: <linux-kernel-owner+w=401wt.eu-S933601AbZDHMGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601AbZDHMGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933398AbZDHMAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:00:22 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48887 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933387AbZDHMAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:00:19 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: [PATCH 0/13] Per-bdi writeback flusher threads #3
Date: Wed,  8 Apr 2009 14:00:03 +0200
Message-Id: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.2.446.gfbdc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the third version of the patchset. Changes since v2:

- Dropped some of the prep patches, since they are now in mainline.
  Unfortunately we grew another pdflush_operation() user (emergency thaw),
  so I had to introduce a new prep patch for that.

- Fix the data consistency issue in generic_sync_sb_inodes() with
  WB_SYNC_ALL that Jan Kara pointed out. I had to switch bdi_list
  to SRCU protection for this. I pondered using a mutex for bdi_lock,
  but that does not work with the pending list <-> active list
  RCU callback scheme.

- Fix race in bdi task removal, we need to synchronize_rcu() before
  doing the wb task kill, not after. This ensures that once we do the
  task kill, nobody is accessing our bdi anymore.

- Separate default wb task creation from filesystem initiated task
  additions. The former can be racy and should check the pending bit
  only to see whether it should proceed, the latter should block waiting
  for previous task additions to finish.

- Move the bdi_cap_flusher_forker() back in the series to where the
  BDI_CAP_FLUSH_FORKER flag was introduced.

- Fix a problem where the first incremental step ended up writing back
  all the dirty inodes on a bdi, not just the ones belonging to a
  specific super_block. Only a problem after the first patch, the 2nd
  patch in the series got it right again. (Thanks Jan Kara).

- Allow writeback tasks to exit, if the bdi has been idle for a certain
  period of time. The lazy create will recreate them if we see dirty
  inodes on the bdi later on.

- btrfs must register its fs_info bdi, or direct writeback will not work
  as intended. Also kill capabilities inherit from
  default_backing_dev_info and fix failure to check bdi_init() return
  value.

The branch can be pulled from:

git://git.kernel.dk/linux-2.6-block.git writeback

Or these patches can be applied directly to 2.6.30-rc1.

-- 
Jens Axboe


