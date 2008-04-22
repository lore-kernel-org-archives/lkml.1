Return-Path: <linux-kernel-owner+w=401wt.eu-S1765690AbYDVNzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765690AbYDVNzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759255AbYDVNzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:55:18 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:38968 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932854AbYDVNzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:55:16 -0400
Date: Tue, 22 Apr 2008 22:55:15 +0900 (JST)
Message-Id: <20080422.225515.128486479.taka@valinux.co.jp>
To: jens.axboe@oracle.com, agk@sourceware.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 5/10] I/O context inheritance
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080422.224935.00673711.taka@valinux.co.jp>
References: <20080422.224935.00673711.taka@valinux.co.jp>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The raid1 module makes use of temporary bios to sync physical disks
under the same md device. Make the bios point the iocontext of one of
the kernel threads in the module.

Meanwhile, regular read/write I/O requests will be cloned and may be
handled by one of the kernel threads in the modules. In this case,
the iocontext will be inherited from the source bio.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>


--- linux-2.6.25.bio0/include/linux/raid/raid1.h	2008-04-22 15:48:32.000000000 +0900
+++ linux-2.6.25/include/linux/raid/raid1.h	2008-04-22 15:52:38.000000000 +0900
@@ -100,6 +100,7 @@ struct r1bio_s {
 
 	struct list_head	retry_list;
 	struct bitmap_update	*bitmap_update;
+	struct io_context	*io_context;
 	/*
 	 * if the IO is in WRITE direction, then multiple bios are used.
 	 * We choose the number when they are allocated.
--- linux-2.6.25.bio0/drivers/md/raid1.c	2008-04-22 15:48:36.000000000 +0900
+++ linux-2.6.25/drivers/md/raid1.c	2008-04-22 17:18:08.000000000 +0900
@@ -200,6 +200,8 @@ static void put_buf(r1bio_t *r1_bio)
 		if (bio->bi_end_io)
 			rdev_dec_pending(conf->mirrors[i].rdev, r1_bio->mddev);
 	}
+	put_io_context(r1_bio->io_context);
+	r1_bio->io_context = NULL;
 
 	mempool_free(r1_bio, conf->r1buf_pool);
 
@@ -1731,6 +1733,7 @@ static sector_t sync_request(mddev_t *md
 	r1_bio->sector = sector_nr;
 	r1_bio->state = 0;
 	set_bit(R1BIO_IsSync, &r1_bio->state);
+	r1_bio->io_context = ioc_object_link(current->io_context);
 
 	for (i=0; i < conf->raid_disks; i++) {
 		mdk_rdev_t *rdev;
@@ -1747,6 +1750,7 @@ static sector_t sync_request(mddev_t *md
 		bio->bi_size = 0;
 		bio->bi_end_io = NULL;
 		bio->bi_private = NULL;
+		bio->bi_io_context = r1_bio->io_context;
 
 		rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev == NULL ||
--- linux-2.6.25.bio0/drivers/md/md.c	2008-04-22 15:48:33.000000000 +0900
+++ linux-2.6.25/drivers/md/md.c	2008-04-22 15:52:38.000000000 +0900
@@ -5451,6 +5451,8 @@ void md_do_sync(mddev_t *mddev)
 	else
 		desc = "recovery";
 
+	current->io_context = alloc_io_context(GFP_KERNEL, -1); /*XXX*/
+
 	/* we overload curr_resync somewhat here.
 	 * 0 == not engaged in resync at all
 	 * 2 == checking that there is no conflict with another sync
