Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbXKAKyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbXKAKyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 06:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbXKAKyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 06:54:00 -0400
Received: from brick.kernel.dk ([87.55.233.238]:7547 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769AbXKAKx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 06:53:59 -0400
Date: Thu, 1 Nov 2007 11:51:09 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       lkml@ml.breakpoint.cc
Subject: Re: 2.4.24-rc1-git: crash on shutdown/unmount?
Message-ID: <20071101105108.GD5037@kernel.dk>
References: <200710311917.21441.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710311917.21441.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31 2007, Alistair John Strachan wrote:
> Hi Jens,
> 
> I guessed from the oops that you might have an idea what's causing this oops 
> on shutdown/unmount. The git version (describe), a screenshot showing the 
> oops, a config, and dmesg for a booted kernel are available from:
> 
> http://devzero.co.uk/~alistair/oops-20071031/
> 
> I went back to -rc1 and it still happens there too. If you need any more 
> information or want me to bisect it, please let me know.

Does this work for you?

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 54fd385..75c98d5 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -3221,6 +3221,7 @@ static inline void __generic_make_request(struct bio *bio)
 	sector_t old_sector;
 	int ret, nr_sectors = bio_sectors(bio);
 	dev_t old_dev;
+	int err = -EIO;
 
 	might_sleep();
 
@@ -3248,7 +3249,7 @@ static inline void __generic_make_request(struct bio *bio)
 				bdevname(bio->bi_bdev, b),
 				(long long) bio->bi_sector);
 end_io:
-			bio_endio(bio, -EIO);
+			bio_endio(bio, err);
 			break;
 		}
 
@@ -3283,6 +3284,10 @@ end_io:
 
 		if (bio_check_eod(bio, nr_sectors))
 			goto end_io;
+		if (bio_empty_barrier(bio) && !q->prepare_flush_fn) {
+			err = -EOPNOTSUPP;
+			goto end_io;
+		}
 
 		ret = q->make_request_fn(q, bio);
 	} while (ret);

-- 
Jens Axboe

