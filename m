Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbZCLOgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbZCLOgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756289AbZCLOeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:34:10 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40024 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027AbZCLOdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:33:52 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 7/7] writeback: add some debug inode list counters to bdi stats
Date: Thu, 12 Mar 2009 15:33:48 +0100
Message-Id: <1236868428-20408-8-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com>
References: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not meant for inclusion, just to monitor what is going on while testing
this stuff.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 mm/backing-dev.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 500d1fc..76a7809 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -46,6 +46,18 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
+	unsigned long nr_dirty, nr_io, nr_more_io;
+	struct inode *inode;
+
+	nr_dirty = nr_io = nr_more_io = 0;
+	spin_lock(&inode_lock);
+	list_for_each_entry(inode, &bdi->b_dirty, i_list)
+		nr_dirty++;
+	list_for_each_entry(inode, &bdi->b_io, i_list)
+		nr_io++;
+	list_for_each_entry(inode, &bdi->b_more_io, i_list)
+		nr_more_io++;
+	spin_unlock(&inode_lock);
 
 	get_dirty_limits(&background_thresh, &dirty_thresh, &bdi_thresh, bdi);
 
@@ -55,12 +67,15 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 		   "BdiReclaimable:   %8lu kB\n"
 		   "BdiDirtyThresh:   %8lu kB\n"
 		   "DirtyThresh:      %8lu kB\n"
-		   "BackgroundThresh: %8lu kB\n",
+		   "BackgroundThresh: %8lu kB\n"
+		   "b_dirty:          %8lu\n"
+		   "b_io:             %8lu\n"
+		   "b_more_io:        %8lu\n",
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
 		   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
 		   K(bdi_thresh),
 		   K(dirty_thresh),
-		   K(background_thresh));
+		   K(background_thresh), nr_dirty, nr_io, nr_more_io);
 #undef K
 
 	return 0;
-- 
1.6.2

