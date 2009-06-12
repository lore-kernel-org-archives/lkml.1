Return-Path: <linux-kernel-owner+w=401wt.eu-S1760639AbZFLM64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639AbZFLM64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758865AbZFLMzC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:55:02 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52317 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756947AbZFLMyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:54:20 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, dedekind1@gmail.com,
       fweisbec@gmail.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 13/15] writeback: restart bdi list scan on allocation failure
Date: Fri, 12 Jun 2009 14:54:13 +0200
Message-Id: <1244811255-5391-14-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1244811255-5391-1-git-send-email-jens.axboe@oracle.com>
References: <1244811255-5391-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's should essentially almost never trigger, so it doesn't matter
if we just restart the scan and potentially do a bit more IO in
this case. And then we can drop bdi_lock before going into inode
sync.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 65ca410..d646e02 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -517,6 +517,7 @@ void bdi_writeback_all(struct super_block *sb, struct writeback_control *wbc)
 	struct bdi_work *work;
 	LIST_HEAD(list);
 
+restart:
 	mutex_lock(&bdi_lock);
 
 	list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
@@ -533,9 +534,13 @@ void bdi_writeback_all(struct super_block *sb, struct writeback_control *wbc)
 		 */
 		work = bdi_alloc_work(sb, wbc->nr_to_write, wbc->sync_mode);
 		if (!work) {
+			if (!must_wait)
+				continue;
+
+			mutex_unlock(&bdi_lock);
 			wbc->bdi = bdi;
 			generic_sync_bdi_inodes(sb, wbc);
-			continue;
+			goto restart;
 		}
 		if (must_wait)
 			list_add_tail(&work->wait_list, &list);
-- 
1.6.3.rc0.1.gf800

