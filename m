Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab0CEKZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 05:25:10 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44189 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab0CEKZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 05:25:08 -0500
MIME-Version: 1.0
Date: Fri, 5 Mar 2010 15:55:07 +0530
Message-ID: <d760cf2d1003050225t59cb3932t5b44835887225d50@mail.gmail.com>
Subject: [PATCH 3/3] Add handlers for swap events
From: Nitin Gupta <ngupta@vflare.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Pekka Enberg <penberg@gmail.com>, andi@firstfloor.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SWAPON handler sets callback which frees memory associated
with given swap slot, eliminating any stale data in corresponding
ramzswap device.

Without this callback, ramzswap device does not get any notification
when a swap slot is freed. Thus, stale data can quickly accumulate in
(compressed) memory which can defeat the whole purpose of such a device.
With this callback, the device can free memory as soon as corresponding
swap slot is freed.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/ramzswap/ramzswap_drv.c   |   91 +++++++++++++++++++++++++++++
 drivers/staging/ramzswap/ramzswap_drv.h   |    1 +
 drivers/staging/ramzswap/ramzswap_ioctl.h |    1 +
 3 files changed, 93 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ramzswap/ramzswap_drv.c
b/drivers/staging/ramzswap/ramzswap_drv.c
index 989fac5..89cc491 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.c
+++ b/drivers/staging/ramzswap/ramzswap_drv.c
@@ -254,6 +254,7 @@ void ramzswap_ioctl_get_stats(struct ramzswap *rzs,
 	s->failed_reads = rs->failed_reads;
 	s->failed_writes = rs->failed_writes;
 	s->invalid_io = rs->invalid_io;
+	s->notify_free = rs->notify_free;
 	s->pages_zero = rs->pages_zero;

 	s->good_compress_pct = good_compress_perc;
@@ -1334,6 +1335,69 @@ static void create_device(struct ramzswap *rzs,
int device_id)
 	rzs->init_done = 0;
 }

+static void ramzswap_slot_free_notify(struct file *swap_file,
+				unsigned long index)
+{
+	struct ramzswap *rzs;
+
+	rzs = ((struct file *)swap_file)->private_data;
+	ramzswap_free_page(rzs, index);
+	stat_inc(rzs->stats.notify_free);
+}
+
+/*
+ * Returns ramzswap device for the given swap file. Also caches
+ * struct ramzswap in file->private_data.
+ *
+ * Returns NULL if the given file is not a ramzswap device.
+ */
+static struct ramzswap *ramzswap_find_device(struct file *swap_file)
+{
+	int i;
+	struct file *file;
+	struct inode *inode;
+	struct ramzswap *rzs;
+	struct block_device *bdev;
+
+	file = (struct file *)swap_file;
+	inode = file->f_mapping->host;
+	bdev = I_BDEV(inode);
+	rzs = bdev->bd_disk->private_data;
+
+	for (i = 0; i < num_devices; i++) {
+		if (rzs == &devices[i])
+			break;
+	}
+
+	if (i == num_devices) {
+		rzs = NULL;
+		goto out;
+	}
+
+	file->private_data = rzs;
+
+out:
+	return rzs;
+}
+
+static int ramzswap_swapon_notify(struct notifier_block *self,
+			unsigned long type, void *swap_file)
+{
+	if (ramzswap_find_device(swap_file))
+		set_swap_free_notify(type, ramzswap_slot_free_notify);
+
+	return 0;
+}
+
+static int ramzswap_swapoff_notify(struct notifier_block *self,
+			unsigned long type, void *swap_file)
+{
+	if (ramzswap_find_device(swap_file))
+		set_swap_free_notify(type, NULL);
+
+	return 0;
+}
+
 static void destroy_device(struct ramzswap *rzs)
 {
 	if (rzs->disk) {
@@ -1345,6 +1409,14 @@ static void destroy_device(struct ramzswap *rzs)
 		blk_cleanup_queue(rzs->queue);
 }

+static struct notifier_block ramzswap_swapon_nb = {
+	.notifier_call = ramzswap_swapon_notify
+};
+
+static struct notifier_block ramzswap_swapoff_nb = {
+	.notifier_call = ramzswap_swapoff_notify
+};
+
 static int __init ramzswap_init(void)
 {
 	int i, ret;
@@ -1377,6 +1449,20 @@ static int __init ramzswap_init(void)
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
@@ -1388,6 +1474,11 @@ static void __exit ramzswap_exit(void)
 	int i;
 	struct ramzswap *rzs;

+	unregister_swap_event_notifier(&ramzswap_swapon_nb,
+				SWAP_EVENT_SWAPON, 0);
+	unregister_swap_event_notifier(&ramzswap_swapoff_nb,
+				SWAP_EVENT_SWAPOFF, 0);
+
 	for (i = 0; i < num_devices; i++) {
 		rzs = &devices[i];

diff --git a/drivers/staging/ramzswap/ramzswap_drv.h
b/drivers/staging/ramzswap/ramzswap_drv.h
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
diff --git a/drivers/staging/ramzswap/ramzswap_ioctl.h
b/drivers/staging/ramzswap/ramzswap_ioctl.h
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
