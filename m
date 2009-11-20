Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZKTU3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZKTU3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050AbZKTU3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:29:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921AbZKTU1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:27:53 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v4 07/13] dm snapshot: do not allow more than one merging snapshot.
Date: Fri, 20 Nov 2009 15:27:47 -0500
Message-Id: <1258748873-24185-8-git-send-email-snitzer@redhat.com>
In-Reply-To: <1258748873-24185-1-git-send-email-snitzer@redhat.com>
References: <1258748873-24185-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

Merging more than one snapshot is not supported.
__find_merging_snapshot() will find the merging snapshot for a given
origin device.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   35 +++++++++++++++++++++++++++++++++--
 1 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index b8838e7..f4e9aa6 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -332,9 +332,29 @@ out:
 	return count;
 }
 
+static struct dm_snapshot *__find_merging_snapshot(struct block_device *origin)
+{
+	struct dm_snapshot *s, *merging_snap;
+	struct origin *o;
+
+	o = __lookup_origin(origin);
+	if (!o)
+		return NULL;
+
+	list_for_each_entry(s, &o->snapshots, list) {
+		if (is_merge(s->ti)) {
+			merging_snap = s;
+			break;
+		}
+	}
+
+	return merging_snap;
+}
+
 static int __validate_exception_handover(struct dm_snapshot *snap)
 {
 	struct dm_snapshot *snap_src = NULL, *snap_dest = NULL;
+	struct block_device *bdev = snap->origin->bdev;
 	int r = 0;
 
 	/* Does snapshot need exceptions handed over to it? */
@@ -346,8 +366,19 @@ static int __validate_exception_handover(struct dm_snapshot *snap)
 		goto out;
 	}
 
-	if (snap_src)
+	if (snap_src) {
+		if (is_merge(snap->ti)) {
+			/* Do not allow more than one merging snapshot */
+			if (__find_merging_snapshot(bdev)) {
+				snap->ti->error = "A snapshot is already "
+						  "merging.";
+				r = -EINVAL;
+				goto out;
+			}
+		}
+
 		r = 1;
+	}
 
 out:
 	return r;
@@ -1325,7 +1356,7 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
 	bio->bi_bdev = s->origin->bdev;
 
 	if (bio_rw(bio) == WRITE) {
-		up_write(&s->lock);
+		up_read(&s->lock);
 		return do_origin(s->origin, bio);
 	}
 
-- 
1.6.5.2

