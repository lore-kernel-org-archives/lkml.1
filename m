Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbYKYXrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbYKYXrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 18:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbYKYXrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 18:47:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:4507 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbYKYXrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 18:47:12 -0500
Date: Wed, 26 Nov 2008 00:47:07 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [resend take 3 0/4] Distributed storage.
Message-ID: <20081125234707.GG5324@gambetta>
References: <12276238703113-git-send-email-zbr@ioremap.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <12276238703113-git-send-email-zbr@ioremap.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Evgeniy,

The attached patch is needed to compile against 2.6.28-rc6 (changes in
block_devices_operations), I added a few cleanups as well.

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=dst

diff --git a/drivers/block/dst/dcore.c b/drivers/block/dst/dcore.c
index fea201b..cd84435 100644
--- a/drivers/block/dst/dcore.c
+++ b/drivers/block/dst/dcore.c
@@ -109,17 +109,17 @@ static int dst_request(struct request_queue *q, struct bio *bio)
 /*
  * Open/close callbacks for appropriate block device.
  */
-static int dst_bdev_open(struct inode *inode, struct file *filp)
+static int dst_bdev_open(struct block_device *bdev, fmode_t mode)
 {
-	struct dst_node *n = inode->i_bdev->bd_disk->private_data;
+	struct dst_node *n = bdev->bd_disk->private_data;
 
 	dst_node_get(n);
 	return 0;
 }
 
-static int dst_bdev_release(struct inode *inode, struct file *filp)
+static int dst_bdev_release(struct gendisk *disk, fmode_t mode)
 {
-	struct dst_node *n = inode->i_bdev->bd_disk->private_data;
+	struct dst_node *n = disk->private_data;
 
 	dst_node_put(n);
 	return 0;
@@ -377,7 +377,7 @@ static void dst_node_cleanup(struct dst_node *n)
 
 	if (n->bdev) {
 		sync_blockdev(n->bdev);
-		blkdev_put(n->bdev);
+		blkdev_put(n->bdev, FMODE_READ|FMODE_WRITE);
 	}
 
 	dst_state_lock(st);
@@ -502,7 +502,7 @@ static int dst_setup_export(struct dst_node *n, struct dst_ctl *ctl,
 	return 0;
 
 err_out_cleanup:
-	blkdev_put(n->bdev);
+	blkdev_put(n->bdev, FMODE_READ|FMODE_WRITE);
 	n->bdev = NULL;
 
 	return err;
diff --git a/drivers/block/dst/export.c b/drivers/block/dst/export.c
index c6bb0a5..122fe75 100644
--- a/drivers/block/dst/export.c
+++ b/drivers/block/dst/export.c
@@ -271,13 +271,13 @@ static void dst_state_cleanup_export(struct dst_state *st)
 
 			if (p)
 				bio_put(p->bio);
-			
+
 			dprintk("%s: st: %p, refcnt: %d, list_empty: %d, p: %p.\n",
 				__func__, st, atomic_read(&st->refcnt),
 				list_empty(&st->request_list), p);
 		}
 	}
-	
+
 	dst_state_put(st);
 }
 
@@ -288,14 +288,14 @@ static void dst_state_cleanup_export(struct dst_state *st)
  */
 static int dst_accept(void *init_data, void *schedule_data)
 {
-	struct dst_state *main = schedule_data;
+	struct dst_state *main_st = schedule_data;
 	struct dst_node *n = init_data;
 	struct dst_state *st;
 	int err;
 
-	while (n->trans_scan_timeout && !main->need_exit) {
-		dprintk("%s: main: %p, n: %p.\n", __func__, main, n);
-		st = dst_accept_client(main);
+	while (n->trans_scan_timeout && !main_st->need_exit) {
+		dprintk("%s: main_st: %p, n: %p.\n", __func__, main_st, n);
+		st = dst_accept_client(main_st);
 		if (IS_ERR(st))
 			continue;
 
@@ -326,14 +326,14 @@ static int dst_accept(void *init_data, void *schedule_data)
 		dst_state_cleanup_export(st);
 	}
 
-	dprintk("%s: freeing listening socket st: %p.\n", __func__, main);
-	
-	dst_state_lock(main);
-	dst_poll_exit(main);
-	dst_state_socket_release(main);
-	dst_state_unlock(main);
-	dst_state_put(main);
-	dprintk("%s: freed listening socket st: %p.\n", __func__, main);
+	dprintk("%s: freeing listening socket st: %p.\n", __func__, main_st);
+
+	dst_state_lock(main_st);
+	dst_poll_exit(main_st);
+	dst_state_socket_release(main_st);
+	dst_state_unlock(main_st);
+	dst_state_put(main_st);
+	dprintk("%s: freed listening socket st: %p.\n", __func__, main_st);
 
 	return 0;
 }

--FL5UXtIhxfXey3p5--
