Return-Path: <linux-kernel-owner+w=401wt.eu-S1751258AbZL1BWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbZL1BWB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 20:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbZL1BV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 20:21:59 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:62990 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZL1BV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 20:21:56 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] [mmotm] ramzswap: add handlers for various swap events
Date: Mon, 28 Dec 2009 06:50:00 +0530
Message-Id: <1261963200-7136-2-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1261963200-7136-1-git-send-email-ngupta@vflare.org>
References: <1261963200-7136-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In particular, add handler for SWAP_EVENT_SLOT_FREE event.
The handler frees memory associated with given swap slot,
eliminating any stale data in corresponding ramzswap device.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/ramzswap/ramzswap_drv.c   |   69 +++++++++++++++++++++++++++++
 drivers/staging/ramzswap/ramzswap_drv.h   |    1 +
 drivers/staging/ramzswap/ramzswap_ioctl.h |    1 +
 3 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ramzswap/ramzswap_drv.c b/drivers/staging/ramzswap/ramzswap_drv.c
index b839f05..1808fdb 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.c
+++ b/drivers/staging/ramzswap/ramzswap_drv.c
@@ -276,6 +276,7 @@ void ramzswap_ioctl_get_stats(struct ramzswap *rzs,
 	s->failed_reads = rs->failed_reads;
 	s->failed_writes = rs->failed_writes;
 	s->invalid_io = rs->invalid_io;
+	s->notify_free = rs->notify_free;
 	s->pages_zero = rs->pages_zero;
 
 	s->good_compress_pct = good_compress_perc;
@@ -1366,6 +1367,60 @@ static void destroy_device(struct ramzswap *rzs)
 	if (rzs->queue)
 		blk_cleanup_queue(rzs->queue);
 }
+static int ramzswap_slot_free_notify(struct notifier_block *self,
+			unsigned long index, void *swap_file)
+{
+	struct ramzswap *rzs;
+
+	rzs = ((struct file *)swap_file)->private_data;
+	ramzswap_free_page(rzs, index);
+	stat_inc(rzs->stats.notify_free);
+	return 0;
+}
+
+static struct notifier_block ramzswap_slot_free_nb = {
+	.notifier_call = ramzswap_slot_free_notify
+};
+
+static int ramzswap_swapon_notify(struct notifier_block *self,
+			unsigned long swap_id, void *swap_file)
+{
+	int ret = 0;
+	struct block_device *bdev;
+	struct file *file;
+	struct inode *inode;
+	struct ramzswap *rzs;
+
+	/* cache ramzswap struct associated with this swap_file */
+	file = (struct file *)swap_file;
+	inode = file->f_mapping->host;
+	bdev = I_BDEV(inode);
+	rzs = bdev->bd_disk->private_data;
+	file->private_data = rzs;
+
+	ret = register_swap_event_notifier(&ramzswap_slot_free_nb,
+				SWAP_EVENT_SLOT_FREE, swap_id);
+	if (ret)
+		pr_err("Error registering swap free notifier\n");
+	return ret;
+}
+
+static int ramzswap_swapoff_notify(struct notifier_block *self,
+			unsigned long swap_id, void *swap_file)
+{
+	unregister_swap_event_notifier(&ramzswap_slot_free_nb,
+				SWAP_EVENT_SLOT_FREE, swap_id);
+	return 0;
+}
+
+
+static struct notifier_block ramzswap_swapon_nb = {
+	.notifier_call = ramzswap_swapon_notify
+};
+
+static struct notifier_block ramzswap_swapoff_nb = {
+	.notifier_call = ramzswap_swapoff_notify
+};
 
 static int __init ramzswap_init(void)
 {
@@ -1399,6 +1454,20 @@ static int __init ramzswap_init(void)
 	for (i = 0; i < num_devices; i++)
 		create_device(&devices[i], i);
 
+	ret = register_swap_event_notifier(&ramzswap_swapon_nb,
+				SWAP_EVENT_SWAPON, 0);
+	if (ret) {
+		pr_err("Error registering swapon notifier\n");
+		goto out;
+	}
+
+	ret = register_swap_event_notifier(&ramzswap_swapoff_nb,
+				SWAP_EVENT_SWAPOFF, 0);
+	if (ret) {
+		pr_err("Error registering swapoff notifier\n");
+		goto out;
+	}
+
 	return 0;
 out:
 	unregister_blkdev(ramzswap_major, "ramzswap");
diff --git a/drivers/staging/ramzswap/ramzswap_drv.h b/drivers/staging/ramzswap/ramzswap_drv.h
index a6ea240..adc841a 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.h
+++ b/drivers/staging/ramzswap/ramzswap_drv.h
@@ -124,6 +124,7 @@ struct ramzswap_stats {
 	u64 failed_reads;	/* can happen when memory is too low */
 	u64 failed_writes;	/* should NEVER! happen */
 	u64 invalid_io;		/* non-swap I/O requests */
+	u64 notify_free;	/* no. of swap slot free notifications */
 	u32 pages_zero;		/* no. of zero filled pages */
 	u32 pages_stored;	/* no. of pages currently stored */
 	u32 good_compress;	/* % of pages with compression ratio<=50% */
diff --git a/drivers/staging/ramzswap/ramzswap_ioctl.h b/drivers/staging/ramzswap/ramzswap_ioctl.h
index c713a09..ec50416 100644
--- a/drivers/staging/ramzswap/ramzswap_ioctl.h
+++ b/drivers/staging/ramzswap/ramzswap_ioctl.h
@@ -27,6 +27,7 @@ struct ramzswap_ioctl_stats {
 	u64 failed_reads;	/* can happen when memory is too low */
 	u64 failed_writes;	/* should NEVER! happen */
 	u64 invalid_io;		/* non-swap I/O requests */
+	u64 notify_free;	/* no. of swap slot free notifications */
 	u32 pages_zero;		/* no. of zero filled pages */
 	u32 good_compress_pct;	/* no. of pages with compression ratio<=50% */
 	u32 pages_expand_pct;	/* no. of incompressible pages */
-- 
1.6.2.5

