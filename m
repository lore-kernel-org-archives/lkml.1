Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbZIOTZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbZIOTZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758646AbZIOTZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:25:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46258 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758535AbZIOTZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:25:39 -0400
Message-Id: <20090915192243.247202587@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Wed, 16 Sep 2009 05:19:08 +1000
From: npiggin@suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch 5/5] fs: fix bdi writeback use after free 2
References: <20090915191903.290006007@suse.de>
Content-Disposition: inline; filename=fs-bdiwb-rcu-fix-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

work can be gone after wb_clear_pending, so load the sb from it first.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/fs-writeback.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -783,6 +783,7 @@ long wb_do_writeback(struct bdi_writebac
 
 	while ((work = get_next_work_item(bdi, wb)) != NULL) {
 		enum writeback_sync_modes sync_mode;
+		struct super_block *sb;
 
 		nr_pages = work->nr_pages;
 
@@ -794,6 +795,8 @@ long wb_do_writeback(struct bdi_writebac
 		else
 			sync_mode = work->sync_mode;
 
+		sb = work->sb;
+
 		/*
 		 * If this isn't a data integrity operation, just notify
 		 * that we have seen this work and we are now starting it.
@@ -801,7 +804,7 @@ long wb_do_writeback(struct bdi_writebac
 		if (sync_mode == WB_SYNC_NONE)
 			wb_clear_pending(wb, work);
 
-		wrote += wb_writeback(wb, nr_pages, work->sb, sync_mode, 0);
+		wrote += wb_writeback(wb, nr_pages, sb, sync_mode, 0);
 
 		/*
 		 * This is a data integrity writeback, so only do the


