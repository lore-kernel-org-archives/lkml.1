Return-Path: <linux-kernel-owner+w=401wt.eu-S948091AbXHMPLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S948091AbXHMPLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943669AbXHMMwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:52:44 -0400
Received: from wip-cdc-wd.wipro.com ([203.91.201.26]:58151 "EHLO
	wip-cdc-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S945726AbXHMMwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:52:41 -0400
Subject: [kj] is_power_of_2 in drivers/md/dm-raid1.c
From: vignesh babu <vignesh.babu@wipro.com>
Reply-To: vigneshbabu@gmail.com
To: mingo@redhat.com, neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: WIPRO Technologies
Date: Mon, 13 Aug 2007 18:22:06 +0530
Message-Id: <1187009526.7273.2.camel@merlin.linuxcoe.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
X-OriginalArrivalTime: 13 Aug 2007 12:52:53.0575 (UTC) FILETIME=[DD05FD70:01C7DDA8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing n & (n - 1) for power of 2 check by is_power_of_2(n)

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
---
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 144071e..969b398 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -19,6 +19,7 @@
 #include <linux/time.h>
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
+#include <linux/log2.h>
 
 #define DM_MSG_PREFIX "raid1"
 #define DM_IO_PAGES 64
@@ -994,7 +995,7 @@ static void free_context(struct mirror_set *ms, struct dm_target *ti,
 
 static inline int _check_region_size(struct dm_target *ti, uint32_t size)
 {
-	return !(size % (PAGE_SIZE >> 9) || (size & (size - 1)) ||
+	return !(size % (PAGE_SIZE >> 9) || !is_power_of_2(size) ||
 		 size > ti->len);
 }
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 83ddbfe..ad2836a 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/log2.h>
 
 #include "dm-snap.h"
 #include "dm-bio-list.h"
@@ -415,7 +416,7 @@ static int set_chunk_size(struct dm_snapshot *s, const char *chunk_size_arg,
 	chunk_size = round_up(chunk_size, PAGE_SIZE >> 9);
 
 	/* Check chunk_size is a power of 2 */
-	if (chunk_size & (chunk_size - 1)) {
+	if (!is_power_of_2(chunk_size)) {
 		*error = "Chunk size is not a power of 2";
 		return -EINVAL;
 	}
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 51f5e07..969944a 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -11,6 +11,7 @@
 #include <linux/blkdev.h>
 #include <linux/bio.h>
 #include <linux/slab.h>
+#include <linux/log2.h>
 
 #define DM_MSG_PREFIX "striped"
 
@@ -99,7 +100,7 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	/*
 	 * chunk_size is a power of two
 	 */
-	if (!chunk_size || (chunk_size & (chunk_size - 1)) ||
+	if (!is_power_of_2(chunk_size) ||
 	    (chunk_size < (PAGE_SIZE >> SECTOR_SHIFT))) {
 		ti->error = "Invalid chunk size";
 		return -EINVAL;

-- 
Vignesh Babu BM 
_____________________________________________________________ 
"Why is it that every time I'm with you, makes me believe in magic?"

