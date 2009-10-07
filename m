Return-Path: <linux-kernel-owner+w=401wt.eu-S934107AbZJGIDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934107AbZJGIDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934088AbZJGID1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:03:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:1895 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934071AbZJGIDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:03:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,518,1249282800"; 
   d="scan'208";a="195972054"
Message-Id: <20091007074903.029403960@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 15:38:33 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li Shaohua" <shaohua.li@intel.com>,
       "Myklebust Trond" <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       <linux-fsdevel@vger.kernel.org>, Martin Bligh <mbligh@google.com>,
       Michael Rubin <mrubin@google.com>,
       Peter Zijlstra <peterz@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/45] writeback: fix queue_io() ordering
References: <20091007073818.318088777@intel.com>
Content-Disposition: inline; filename=queue_io-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was not a bug, since b_io is empty for kupdate writeback.
The next patch will do requeue_io() for non-kupdate writeback,
so let's fix it.

CC: Dave Chinner <david@fromorbit.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-10-06 23:38:28.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-06 23:38:42.000000000 +0800
@@ -375,11 +375,14 @@ static void move_expired_inodes(struct l
 }
 
 /*
- * Queue all expired dirty inodes for io, eldest first.
+ * Queue all expired dirty inodes for io, eldest first:
+ * (newly dirtied) => b_dirty inodes
+ *                 => b_more_io inodes
+ *                 => remaining inodes in b_io => (dequeue for sync)
  */
 static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
 {
-	list_splice_init(&wb->b_more_io, wb->b_io.prev);
+	list_splice_init(&wb->b_more_io, &wb->b_io);
 	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
 }
 


