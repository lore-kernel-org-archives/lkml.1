Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbZDNLLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbZDNLLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 07:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbZDNLKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 07:10:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbZDNLKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 07:10:04 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
Subject: [PATCH 5/6] Handle possible bio_alloc failure in xfs
Date: Tue, 14 Apr 2009 16:36:45 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
MIME-Version: 1.0
Content-Disposition: inline
To: xfs-masters@oss.sgi.com
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200904141636.45463.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle bio_alloc failure in xfs.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
@@ -1196,6 +1196,8 @@ _xfs_buf_ioapply(
 	      (XBF_READ|_XBF_PAGE_LOCKED)) &&
 	    (blocksize >= PAGE_CACHE_SIZE)) {
 		bio = bio_alloc(GFP_NOIO, 1);
+		if (unlikely(!bio))
+			goto out_enomem;
 
 		bio->bi_bdev = bp->b_target->bt_bdev;
 		bio->bi_sector = sector - (offset >> BBSHIFT);
@@ -1217,6 +1219,9 @@ next_chunk:
 		nr_pages = total_nr_pages;
 
 	bio = bio_alloc(GFP_NOIO, nr_pages);
+	if (unlikely(!bio))
+		goto out_enomem;
+
 	bio->bi_bdev = bp->b_target->bt_bdev;
 	bio->bi_sector = sector;
 	bio->bi_end_io = xfs_buf_bio_end_io;
@@ -1247,6 +1252,11 @@ submit_io:
 		bio_put(bio);
 		xfs_buf_ioerror(bp, EIO);
 	}
+	return;
+
+out_enomem:
+	xfs_buf_ioerror(bp, ENOMEM);
+	
 }
 
 int



