Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbZKTU1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbZKTU1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbZKTU1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:27:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473AbZKTU1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:27:50 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v4 04/13] dm exception store: snapshot-merge usage accounting
Date: Fri, 20 Nov 2009 15:27:44 -0500
Message-Id: <1258748873-24185-5-git-send-email-snitzer@redhat.com>
In-Reply-To: <1258748873-24185-1-git-send-email-snitzer@redhat.com>
References: <1258748873-24185-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conditionally adjust snapshot usage accounting if snapshot-merge is in
progress.  Care is taken to preserve the established kernel<->userspace
interface.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-snap-persistent.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 1f5752e..3cb609b 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -91,6 +91,7 @@ struct pstore {
 	struct dm_exception_store *store;
 	int version;
 	int valid;
+	int merging;	/* 1 if there is merging going on */
 	uint32_t exceptions_per_area;
 
 	/*
@@ -506,7 +507,20 @@ static void persistent_usage(struct dm_exception_store *store,
 {
 	struct pstore *ps = get_info(store);
 
-	*sectors_allocated = ps->next_free * store->chunk_size;
+	/*
+	 * Must maintain the fact that DM reports all metadata chunks
+	 * in 'sectors_allocated'
+	 * - preserves the established kernel<->userspace interface
+	 * - snapshot-merge must account for the first two metadata
+	 *   chunks in its 'sectors_allocated'
+	 */
+	if (!ps->merging) {
+		*sectors_allocated = ps->next_free * store->chunk_size;
+	} else {
+		*sectors_allocated =
+			(area_location(ps, ps->current_area) - 1 +
+			 ps->current_committed + 2) * store->chunk_size;
+	}
 	*total_sectors = get_dev_size(dm_snap_cow(store->snap)->bdev);
 
 	/*
@@ -608,6 +622,8 @@ static int persistent_prepare_exception(struct dm_exception_store *store,
 	chunk_t next_free;
 	sector_t size = get_dev_size(dm_snap_cow(store->snap)->bdev);
 
+	ps->merging = 0;
+
 	/* Is there enough room ? */
 	if (size < ((ps->next_free + 1) * store->chunk_size))
 		return -ENOSPC;
@@ -696,6 +712,8 @@ static int persistent_prepare_merge(struct dm_exception_store *store,
 	struct pstore *ps = get_info(store);
 	struct disk_exception de;
 
+	ps->merging = 1;
+
 	if (!ps->current_committed) {
 		if (!ps->current_area)
 			return 0;
@@ -767,6 +785,7 @@ static int persistent_ctr(struct dm_exception_store *store,
 
 	ps->store = store;
 	ps->valid = 1;
+	ps->merging = 0;
 	ps->version = SNAPSHOT_DISK_VERSION;
 	ps->area = NULL;
 	ps->zero_area = NULL;
-- 
1.6.5.2

