Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbYLKUho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbYLKUho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757223AbYLKUhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:37:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33088 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792AbYLKUhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:37:35 -0500
Message-ID: <494179EE.8060009@redhat.com>
Date: Thu, 11 Dec 2008 21:37:02 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH] loop: Flush possible running bios when loop device is released.
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flush possible running bios when loop device is released.

When there are still queued bios and reference count
drops to zero, loop device must flush all queued bios.

Otherwise it can lead to situation that caller
closes the device, but some bios are still running
and endio() function call later oopses when uses
unallocated mempool.

This happens for example when running dm-crypt over loop,
here is typical oops backtrace:

 Oops: 0000 [#1] PREEMPT SMP
 EIP is at mempool_free+0x12/0x6b
...
 crypt_dec_pending+0x50/0x54 [dm_crypt]
 crypt_endio+0x9f/0xa7 [dm_crypt]
 crypt_endio+0x0/0xa7 [dm_crypt]
 bio_endio+0x2b/0x2e
 loop_thread+0x37a/0x3b1
 do_lo_send_aops+0x0/0x165
 autoremove_wake_function+0x0/0x33
 loop_thread+0x0/0x3b1
 kthread+0x3b/0x61
 kthread+0x0/0x61
 kernel_thread_helper+0x7/0x10

(But crash is reproducible with different dm targets 
running over loop device too.)

Patch fixes it by flushing the bios in release call,
reusing the flush mechanism for switching backing store.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/block/loop.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 5c4ee70..0ccf2ae 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -624,20 +624,33 @@ static int loop_switch(struct loop_device *lo, struct file *file)
 }
 
 /*
+ * Helper to flush the IOs in loop, but keeping loop thread running
+ */
+static int loop_flush(struct loop_device *lo)
+{
+	return loop_switch(lo, NULL);
+}
+
+/*
  * Do the actual switch; called from the BIO completion routine
  */
 static void do_loop_switch(struct loop_device *lo, struct switch_request *p)
 {
 	struct file *file = p->file;
 	struct file *old_file = lo->lo_backing_file;
-	struct address_space *mapping = file->f_mapping;
+	struct address_space *mapping;
+
+	if (!file)
+		goto out;
 
+	mapping = file->f_mapping;
 	mapping_set_gfp_mask(old_file->f_mapping, lo->old_gfp_mask);
 	lo->lo_backing_file = file;
 	lo->lo_blocksize = S_ISBLK(mapping->host->i_mode) ?
 		mapping->host->i_bdev->bd_block_size : PAGE_SIZE;
 	lo->old_gfp_mask = mapping_gfp_mask(mapping);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
+out:
 	complete(&p->wait);
 }
 
@@ -1347,6 +1360,8 @@ static int lo_release(struct gendisk *disk, fmode_t mode)
 
 	if ((lo->lo_flags & LO_FLAGS_AUTOCLEAR) && !lo->lo_refcnt)
 		loop_clr_fd(lo, NULL);
+	else if (!lo->lo_refcnt && lo->lo_thread)
+		loop_flush(lo);
 
 	mutex_unlock(&lo->lo_ctl_mutex);
 


