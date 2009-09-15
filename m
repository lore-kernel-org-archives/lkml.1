Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbZIOSTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbZIOSTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258AbZIOSS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:18:28 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59585 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984AbZIOSQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:16:54 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 10/11] writeback: splice dirty inode entries to default bdi on bdi_destroy()
Date: Tue, 15 Sep 2009 20:16:56 +0200
Message-Id: <1253038617-30204-11-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1253038617-30204-1-git-send-email-jens.axboe@oracle.com>
References: <1253038617-30204-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot safely ensure that the inodes are all gone at this point
in time, and we must not destroy this bdi with inodes having off it.
So just splice our entries to the default bdi since that one will
always persist.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 mm/backing-dev.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index fd93566..3d3accb 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -668,7 +668,19 @@ void bdi_destroy(struct backing_dev_info *bdi)
 {
 	int i;
 
-	WARN_ON(bdi_has_dirty_io(bdi));
+	/*
+	 * Splice our entries to the default_backing_dev_info, if this
+	 * bdi disappears
+	 */
+	if (bdi_has_dirty_io(bdi)) {
+		struct bdi_writeback *dst = &default_backing_dev_info.wb;
+
+		spin_lock(&inode_lock);
+		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
+		list_splice(&bdi->wb.b_io, &dst->b_io);
+		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
+		spin_unlock(&inode_lock);
+	}
 
 	bdi_unregister(bdi);
 
-- 
1.6.4.1.207.g68ea

