Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZEZJgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZEZJgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbZEZJeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:34:16 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54822 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308AbZEZJdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:33:55 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 10/12] writeback: add some debug inode list counters to bdi stats
Date: Tue, 26 May 2009 11:33:48 +0200
Message-Id: <1243330430-9964-11-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
References: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some debug entries to be able to inspect the internal state of
the writeback details.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 mm/backing-dev.c |   38 ++++++++++++++++++++++++++++++++++----
 1 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 977c171..e7b0283 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -43,9 +43,29 @@ static void bdi_debug_init(void)
 static int bdi_debug_stats_show(struct seq_file *m, void *v)
 {
 	struct backing_dev_info *bdi = m->private;
+	struct bdi_writeback *wb;
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
+	unsigned long nr_dirty, nr_io, nr_more_io, nr_wb;
+	struct inode *inode;
+
+	/*
+	 * inode lock is enough here, the bdi->wb_list is protected by
+	 * RCU on the reader side
+	 */
+	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
+	spin_lock(&inode_lock);
+	list_for_each_entry(wb, &bdi->wb_list, list) {
+		nr_wb++;
+		list_for_each_entry(inode, &wb->b_dirty, i_list)
+			nr_dirty++;
+		list_for_each_entry(inode, &wb->b_io, i_list)
+			nr_io++;
+		list_for_each_entry(inode, &wb->b_more_io, i_list)
+			nr_more_io++;
+	}
+	spin_unlock(&inode_lock);
 
 	get_dirty_limits(&background_thresh, &dirty_thresh, &bdi_thresh, bdi);
 
@@ -55,12 +75,22 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 		   "BdiReclaimable:   %8lu kB\n"
 		   "BdiDirtyThresh:   %8lu kB\n"
 		   "DirtyThresh:      %8lu kB\n"
-		   "BackgroundThresh: %8lu kB\n",
+		   "BackgroundThresh: %8lu kB\n"
+		   "WriteBack threads:%8lu\n"
+		   "b_dirty:          %8lu\n"
+		   "b_io:             %8lu\n"
+		   "b_more_io:        %8lu\n"
+		   "bdi_list:         %8u\n"
+		   "state:            %8lx\n"
+		   "wb_mask:          %8lx\n"
+		   "wb_list:          %8u\n"
+		   "wb_cnt:           %8u\n",
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
 		   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
-		   K(bdi_thresh),
-		   K(dirty_thresh),
-		   K(background_thresh));
+		   K(bdi_thresh), K(dirty_thresh),
+		   K(background_thresh), nr_wb, nr_dirty, nr_io, nr_more_io,
+		   !list_empty(&bdi->bdi_list), bdi->state, bdi->wb_mask,
+		   !list_empty(&bdi->wb_list), bdi->wb_cnt);
 #undef K
 
 	return 0;
-- 
1.6.3.rc0.1.gf800

