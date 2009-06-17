Return-Path: <linux-kernel-owner+w=401wt.eu-S1765960AbZFQLJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765960AbZFQLJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 07:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764824AbZFQLH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 07:07:58 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50632 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763211AbZFQLHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 07:07:30 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, fweisbec@gmail.com,
       Alan.Brunelle@hp.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 10/10] writeback: use spin_trylock() in bdi_writeback_all() for WB_SYNC_NONE
Date: Wed, 17 Jun 2009 13:07:22 +0200
Message-Id: <1245236842-3141-11-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1245236842-3141-1-git-send-email-jens.axboe@oracle.com>
References: <1245236842-3141-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure whether this is a good idea, hence it's at the back of the
series as a separate patch. In theory it should be fine, since all
WB_SYNC_NONE writeback is best-effort. No guarentees are made.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index de5f7ef..d589db3 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -506,9 +506,17 @@ void bdi_writeback_all(struct super_block *sb, struct writeback_control *wbc)
 	struct bdi_work *work;
 	LIST_HEAD(list);
 
-restart:
-	spin_lock(&bdi_lock);
+	/*
+	 * If this isn't a data integrity writeback, just drop it if
+	 * someone is already holding the bdi_lock
+	 */
+	if (!spin_trylock(&bdi_lock)) {
+		if (!must_wait)
+			return;
+		spin_lock(&bdi_lock);
+	}
 
+restart:
 	list_for_each_entry(bdi, &bdi_list, bdi_list) {
 		struct bdi_work *work;
 
@@ -535,6 +543,7 @@ restart:
 			__wbc = *wbc;
 			__wbc.bdi = bdi;
 			generic_sync_bdi_inodes(sb, &__wbc);
+			spin_lock(&bdi_lock);
 			goto restart;
 		}
 		if (must_wait)
-- 
1.6.3.rc0.1.gf800

