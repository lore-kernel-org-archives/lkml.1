Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbXEUBdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbXEUBdx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 21:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbXEUBdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 21:33:20 -0400
Received: from mail.suse.de ([195.135.220.2]:56600 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbXEUBdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 21:33:16 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 21 May 2007 11:33:03 +1000
Message-Id: <1070521013303.6655@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Jeff Zheng" <Jeff.Zheng@endace.com>
Cc: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org
Subject: [PATCH 001 of 7] md: Avoid overflow in raid0 calculation with large components.
References: <20070521111837.20906.patches@notabene>
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
Cc: stable@kernel.org

### Diffstat output
 ./drivers/md/raid0.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff .prev/drivers/md/raid0.c ./drivers/md/raid0.c
--- .prev/drivers/md/raid0.c	2007-05-18 11:48:57.000000000 +1000
+++ ./drivers/md/raid0.c	2007-05-18 11:48:57.000000000 +1000
@@ -415,7 +415,7 @@ static int raid0_make_request (request_q
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 	struct strip_zone *zone;
 	mdk_rdev_t *tmp_dev;
-	unsigned long chunk;
+	sector_t chunk;
 	sector_t block, rsect;
 	const int rw = bio_data_dir(bio);
 
@@ -470,7 +470,6 @@ static int raid0_make_request (request_q
 
 		sector_div(x, zone->nb_dev);
 		chunk = x;
-		BUG_ON(x != (sector_t)chunk);
 
 		x = block >> chunksize_bits;
 		tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
