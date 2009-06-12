Return-Path: <linux-kernel-owner+w=401wt.eu-S1762608AbZFLM7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762608AbZFLM7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758395AbZFLMzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:55:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52316 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742AbZFLMyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:54:20 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, dedekind1@gmail.com,
       fweisbec@gmail.com, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 15/15] writeback: use spin_trylock() in bdi_writeback_all() for WB_SYNC_NONE
Date: Fri, 12 Jun 2009 14:54:15 +0200
Message-Id: <1244811255-5391-16-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1244811255-5391-1-git-send-email-jens.axboe@oracle.com>
References: <1244811255-5391-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e15a3fa..98bac71 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -517,9 +517,17 @@ void bdi_writeback_all(struct super_block *sb, struct writeback_control *wbc)
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
 	list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
 		struct bdi_work *work;
 
@@ -540,6 +548,7 @@ restart:
 			spin_unlock(&bdi_lock);
 			wbc->bdi = bdi;
 			generic_sync_bdi_inodes(sb, wbc);
+			spin_lock(&bdi_lock);
 			goto restart;
 		}
 		if (must_wait)
-- 
1.6.3.rc0.1.gf800

