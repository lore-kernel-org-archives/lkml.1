Return-Path: <linux-kernel-owner+w=401wt.eu-S1760831AbZDHMMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831AbZDHMMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933434AbZDHMBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:01:17 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48972 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933279AbZDHMAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:00:31 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 10/13] writeback: add some debug inode list counters to bdi stats
Date: Wed,  8 Apr 2009 14:00:13 +0200
Message-Id: <1239192016-19857-11-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.2.446.gfbdc0
In-Reply-To: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
References: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not meant for inclusion, just to monitor what is going on while testing
this stuff.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 mm/backing-dev.c |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 9707545..a45b7d9 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -43,9 +43,33 @@ static void bdi_debug_init(void)
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
+
+	nr_dirty <<= (PAGE_CACHE_SHIFT - 10);
+	nr_io <<= (PAGE_CACHE_SHIFT - 10);
+	nr_more_io <<= (PAGE_CACHE_SHIFT - 10);
 
 	get_dirty_limits(&background_thresh, &dirty_thresh, &bdi_thresh, bdi);
 
@@ -55,12 +79,16 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 		   "BdiReclaimable:   %8lu kB\n"
 		   "BdiDirtyThresh:   %8lu kB\n"
 		   "DirtyThresh:      %8lu kB\n"
-		   "BackgroundThresh: %8lu kB\n",
+		   "BackgroundThresh: %8lu kB\n"
+		   "WriteBack threads:%8lu\n"
+		   "b_dirty:          %8lu kB\n"
+		   "b_io:             %8lu kB\n"
+		   "b_more_io:        %8lu kB\n",
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
 		   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
 		   K(bdi_thresh),
 		   K(dirty_thresh),
-		   K(background_thresh));
+		   K(background_thresh), nr_wb, nr_dirty, nr_io, nr_more_io);
 #undef K
 
 	return 0;
-- 
1.6.2.2.446.gfbdc0

