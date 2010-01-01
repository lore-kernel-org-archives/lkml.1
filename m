Return-Path: <linux-kernel-owner+w=401wt.eu-S1751170Ab0AAFKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170Ab0AAFKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 00:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770Ab0AAFKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 00:10:42 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:50874 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab0AAFKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 00:10:41 -0500
Message-ID: <4B3D835F.1090604@vflare.org>
Date: Fri, 01 Jan 2010 10:38:47 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2 repost] [mmotm v2] Add notifiers for various swap events
References: <1262232518-2841-1-git-send-email-ngupta@vflare.org>
In-Reply-To: <1262232518-2841-1-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(reposting with detailed description, no code changes)

ramzswap driver creates RAM backed block devices which are
used as swap disks. Pages swapped to these disks are compressed
and stored in memory itself. However, when a swap page becomes
stale i.e. it is no longer referenced by any process (say, when
owning process exits), the driver does not get any notification
about this. So, it has to keep such pages in memory until kernel
swaps to the same swap slot again thereby overwriting previous
(stale) page.

Often, a large number of such stale pages accumulate which defeats
the whole purpose of in-memory compressed swapping and it begins
to have a negative impact on system performance.

To overcome this problem, we now register a notification for the
event when a swap slot is no longer used. The registered callback
immediately frees corresponding memory, eliminating any stale data
in (compressed) memory.

v2: add calls to unregister all notifiers during module unload.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/ramzswap/ramzswap_drv.c   |   73 +++++++++++++++++++++++++++++
 drivers/staging/ramzswap/ramzswap_drv.h   |    1 +
 drivers/staging/ramzswap/ramzswap_ioctl.h |    1 +
 3 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ramzswap/ramzswap_drv.c b/drivers/staging/ramzswap/ramzswap_drv.c
index b839f05..fd4db0f 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.c
+++ b/drivers/staging/ramzswap/ramzswap_drv.c
@@ -276,6 +276,7 @@ void ramzswap_ioctl_get_stats(struct ramzswap *rzs,
 	s->failed_reads = rs->failed_reads;
 	s->failed_writes = rs->failed_writes;
 	s->invalid_io = rs->invalid_io;
+	s->notify_free = rs->notify_free;
 	s->pages_zero = rs->pages_zero;

 	s->good_compress_pct = good_compress_perc;
@@ -1355,6 +1356,51 @@ static void create_device(struct ramzswap *rzs, int device_id)

 	rzs->init_done = 0;
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

 static void destroy_device(struct ramzswap *rzs)
 {
@@ -1367,6 +1413,14 @@ static void destroy_device(struct ramzswap *rzs)
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
@@ -1399,6 +1453,20 @@ static int __init ramzswap_init(void)
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
@@ -1410,6 +1478,11 @@ static void __exit ramzswap_exit(void)
 	int i;
 	struct ramzswap *rzs;

+	unregister_swap_event_notifier(&ramzswap_swapon_nb,
+				SWAP_EVENT_SWAPON, 0);
+	unregister_swap_event_notifier(&ramzswap_swapoff_nb,
+				SWAP_EVENT_SWAPOFF, 0);
+
 	for (i = 0; i < num_devices; i++) {
 		rzs = &devices[i];

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


