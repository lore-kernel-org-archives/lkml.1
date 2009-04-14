Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbZDNLK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbZDNLK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 07:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbZDNLKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 07:10:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:39726 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbZDNLKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 07:10:01 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
Subject: [PATCH 1/6] Handle possible bio_alloc failure in md
Date: Tue, 14 Apr 2009 16:36:32 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
MIME-Version: 1.0
Content-Disposition: inline
To: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200904141636.32791.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle possible bio_alloc failure in md.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---


Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -532,6 +532,9 @@ void md_super_write(mddev_t *mddev, mdk_
 	struct bio *bio = bio_alloc(GFP_NOIO, 1);
 	int rw = (1<<BIO_RW) | (1<<BIO_RW_SYNCIO) | (1<<BIO_RW_UNPLUG);
 
+	if (unlikely(!bio))
+		md_error(rdev->mddev, rdev);
+
 	bio->bi_bdev = rdev->bdev;
 	bio->bi_sector = sector;
 	bio_add_page(bio, page, size, 0);
@@ -587,6 +590,9 @@ int sync_page_io(struct block_device *bd
 	struct completion event;
 	int ret;
 
+	if (unlikely(!bio))
+		return 0;
+
 	rw |= (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG);
 
 	bio->bi_bdev = bdev;


