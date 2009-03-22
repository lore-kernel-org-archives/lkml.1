Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZCVT2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZCVT2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbZCVT0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:26:22 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52616 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570AbZCVT0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:26:11 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de,
       hch@infradead.org, akpm@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 12/12] writeback: check for registered bdi in flusher add
Date: Sun, 22 Mar 2009 20:26:04 +0100
Message-Id: <1237749964-8343-13-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.12.g83676
In-Reply-To: <1237749964-8343-1-git-send-email-jens.axboe@oracle.com>
References: <1237749964-8343-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also a debugging aid.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/backing-dev.h |    1 +
 mm/backing-dev.c            |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 3d373d4..c65b219 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -29,6 +29,7 @@ enum bdi_state {
 	BDI_wblist_lock,	/* bdi->wb_list now needs locking */
 	BDI_write_congested,	/* The write queue is getting full */
 	BDI_read_congested,	/* The read queue is getting full */
+	BDI_registered,
 	BDI_unused,		/* Available bits start here */
 };
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 981e8e8..18faf79 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -474,6 +474,11 @@ void bdi_add_flusher_task(struct backing_dev_info *bdi)
 	if (!bdi_cap_writeback_dirty(bdi))
 		return;
 
+	if (!test_bit(BDI_registered, &bdi->state)) {
+		printk("bdi %p/%s is not registered!\n", bdi, bdi->name);
+		return;
+	}
+
 	/*
 	 * Someone already marked this pending for task creation
 	 */
@@ -541,6 +546,7 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 
 	bdi->dev = dev;
 	bdi_debug_register(bdi, dev_name(dev));
+	set_bit(BDI_registered, &bdi->state);
 
 exit:
 	return ret;
-- 
1.6.2.12.g83676

