Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbZIHHtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbZIHHtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 03:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZIHHtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 03:49:52 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:41174 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbZIHHtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 03:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=m0hmX+Xji4Thc5Fy5SnR0GjI8jPDykc0TLK4OHkWsEH/ipBvGuhIrBbMgwxqvvV35i
         RGVFMikfkMyvZE/fJfaiqG9pY3b0KM1nwtTwHWm9tRlE5/OHtmIhDQzwXeuTct4NSxu8
         DuWAmQ4GY6EH1i57jtP3gzerTMFq9oiBI5fDM=
Date: Tue, 8 Sep 2009 16:49:41 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH v2] [mmotm] trace bio queueing trial only when it occurs
Message-Id: <20090908164941.c4f51208.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 * Add history that why it is breaked in changelog.

Thanks for careful review, Wu, Li.

== CUT_HERE ==

If BIO is discarded or cross over end of device,
BIO queueing trial doesn't occur.

Actually the trace was called just before make_request at first:
[PATCH] Block queue IO tracing support (blktrace) as of 2006-03-23
      2056a782f8e7e65fd4bfd027506b4ce1c5e9ccd4

And then 2 patches added some checks between them:
[PATCH] md: check bio address after mapping through partitions
        5ddfe9691c91a244e8d1be597b6428fcefd58103,
[BLOCK] Don't allow empty barriers to be passed down to 
queues that don't grok them
        51fd77bd9f512ab6cc9df0733ba1caaab89eb957

It breaks original goal.
Let's trace it only when it happens.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 block/blk-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5b59592..1a0cfd5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1463,8 +1463,6 @@ static inline void __generic_make_request(struct bio *bio)
 		if (old_sector != -1)
 			trace_block_remap(q, bio, old_dev, old_sector);

-		trace_block_bio_queue(q, bio);
-
 		old_sector = bio->bi_sector;
 		old_dev = bio->bi_bdev->bd_dev;

@@ -1477,6 +1475,8 @@ static inline void __generic_make_request(struct bio *bio)
 			goto end_io;
 		}

+		trace_block_bio_queue(q, bio);
+
 		ret = q->make_request_fn(q, bio);
 	} while (ret);

--
1.6.4



-- 
Kind regards,
Minchan Kim
