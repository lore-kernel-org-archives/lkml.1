Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbZINJgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbZINJgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbZINJgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:36:38 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38667 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbZINJgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:36:31 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 7/7] writeback: splice dirty inode entries to default bdi on bdi_destroy()
Date: Mon, 14 Sep 2009 11:36:34 +0200
Message-Id: <1252920994-11141-8-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com>
References: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot safely ensure that the inodes are all gone at this point
in time, and we must not destroy this bdi with inodes having off it.
So just splice our entries to the default bdi since that one will
always persist.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 mm/backing-dev.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index fd93566..27f82dc 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -668,7 +668,17 @@ void bdi_destroy(struct backing_dev_info *bdi)
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
+		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
+		list_splice(&bdi->wb.b_io, &dst->b_io);
+		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
+	}
 
 	bdi_unregister(bdi);
 
-- 
1.6.4.1.207.g68ea

