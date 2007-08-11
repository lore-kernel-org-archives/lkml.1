Return-Path: <linux-kernel-owner+w=401wt.eu-S1762322AbXHKS7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762322AbXHKS7r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 14:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762332AbXHKS6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:58:12 -0400
Received: from 1wt.eu ([62.212.114.60]:1492 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762222AbXHKS6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:58:08 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184829.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:47:54 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: "Jeff Zheng" <Jeff.Zheng@endace.com>, Neil Brown <neilb@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 02/28] md: Avoid overflow in raid0 calculation with large components.
Content-Disposition: inline; filename=0002-PATCH-md-Avoid-overflow-in-raid0-calculation-with.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If a raid0 has a component device larger than 4TB, and is accessed on
a 32bit machines, then as 'chunk' is unsigned lock,
   chunk << chunksize_bits
can overflow (this can be as high as the size of the device in KB).
chunk itself will not overflow (without triggering a BUG).

So change 'chunk' to be 'sector_t, and get rid of the 'BUG' as it becomes
impossible to hit.

Cc: "Jeff Zheng" <Jeff.Zheng@endace.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/md/raid0.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index dfe3214..2c404f7 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -415,7 +415,7 @@ static int raid0_make_request (request_queue_t *q, struct bio *bio)
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 	struct strip_zone *zone;
 	mdk_rdev_t *tmp_dev;
-	unsigned long chunk;
+	sector_t chunk;
 	sector_t block, rsect;
 	const int rw = bio_data_dir(bio);
 
@@ -470,7 +470,6 @@ static int raid0_make_request (request_queue_t *q, struct bio *bio)
 
 		sector_div(x, zone->nb_dev);
 		chunk = x;
-		BUG_ON(x != (sector_t)chunk);
 
 		x = block >> chunksize_bits;
 		tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
-- 
1.5.2.4

-- 
