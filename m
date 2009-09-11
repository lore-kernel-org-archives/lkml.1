Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbZIKLuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbZIKLuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 07:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZIKLub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 07:50:31 -0400
Received: from brick.kernel.dk ([93.163.65.50]:53684 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbZIKLub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 07:50:31 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no
Subject: [PATCH 0/4] Post merge per-bdi writeback patches
Date: Fri, 11 Sep 2009 13:50:28 +0200
Message-Id: <1252669832-13553-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is what I currently have queued up for post merge of the
writeback patchset. It contains:

- The bdi work allocation and queue cleanup from Christoph.
- An sb->s_bdi pointer that gets assigned in get_sb_bdev(), OR
  from the fs ->fill_super() if the file system doesn't use
  get_sb_bdev(). It is required for WB_SYNC_ALL writeback. Someone
  more familiar with this code should check that it is done in the
  right place. As usual, I'm unsure of NFS...
- Once the ->s_bdi is in place, we can get rid of bdi_writeback_all()
  for WB_SYNC_ALL. WB_SYNC_ALL now has to use bdi_start_writeback().
  This cleans up bdi_writeback_all() nicely.
- With bdi_writeback_all() only doing WB_SYNC_NONE, we can drop
  the bdi_lock requirement and move to RCU for bdi_list.

Please take a good look and review/comment, thanks! This patchset
is based on top of writeback-v20. It boots and works fine for me.

 fs/btrfs/disk-io.c          |    1 
 fs/fs-writeback.c           |  111 ++++++++----------------------------
 fs/fuse/inode.c             |    2 
 fs/super.c                  |    6 +
 fs/sync.c                   |    9 ++
 fs/ubifs/super.c            |    1 
 include/linux/backing-dev.h |    1 
 include/linux/fs.h          |    1 
 mm/backing-dev.c            |   76 +++++++++++++++++-------
 mm/page-writeback.c         |    8 +-
 10 files changed, 105 insertions(+), 111 deletions(-)

-- 
Jens Axboe

