Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZIPNZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZIPNZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZIPNZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:25:01 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57963 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbZIPNYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:24:49 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 14/16] writeback: improve scalability of bdi writeback work queues
Date: Wed, 16 Sep 2009 15:24:52 +0200
Message-Id: <1253107494-20160-15-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
References: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

If you're going to do an atomic RMW on each list entry, there's not much
point in all the RCU complexities of the list walking. This is only going
to help the multi-thread case I guess, but it doesn't hurt to do now.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 59c99e7..6bca6f8 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -772,8 +772,9 @@ static struct bdi_work *get_next_work_item(struct backing_dev_info *bdi,
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(work, &bdi->work_list, list) {
-		if (!test_and_clear_bit(wb->nr, &work->seen))
+		if (!test_bit(wb->nr, &work->seen))
 			continue;
+		clear_bit(wb->nr, &work->seen);
 
 		ret = work;
 		break;
-- 
1.6.4.1.207.g68ea

