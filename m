Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbZDWHmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbZDWHmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbZDWHac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:30:32 -0400
Received: from sous-sol.org ([216.99.217.87]:50433 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756262AbZDWHaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:30:30 -0400
Message-Id: <20090423072458.312483349@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:58 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 038/100] dm snapshot: refactor __find_pending_exception
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=dm-snapshot-refactor-__find_pending_exception.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Mikulas Patocka <mpatocka@redhat.com>

upstream commit: 2913808eb56a6445a7b277eb8d17651c8defb035

Move looking-up of a pending exception from __find_pending_exception to another
function.

Cc: stable@kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/dm-snap.c |   52 +++++++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -972,6 +972,17 @@ static void start_copy(struct dm_snap_pe
 		    &src, 1, &dest, 0, copy_callback, pe);
 }
 
+static struct dm_snap_pending_exception *
+__lookup_pending_exception(struct dm_snapshot *s, chunk_t chunk)
+{
+	struct dm_snap_exception *e = lookup_exception(&s->pending, chunk);
+
+	if (!e)
+		return NULL;
+
+	return container_of(e, struct dm_snap_pending_exception, e);
+}
+
 /*
  * Looks to see if this snapshot already has a pending exception
  * for this chunk, otherwise it allocates a new one and inserts
@@ -983,21 +994,10 @@ static void start_copy(struct dm_snap_pe
 static struct dm_snap_pending_exception *
 __find_pending_exception(struct dm_snapshot *s, struct bio *bio)
 {
-	struct dm_snap_exception *e;
-	struct dm_snap_pending_exception *pe;
+	struct dm_snap_pending_exception *pe, *pe2;
 	chunk_t chunk = sector_to_chunk(s, bio->bi_sector);
 
 	/*
-	 * Is there a pending exception for this already ?
-	 */
-	e = lookup_exception(&s->pending, chunk);
-	if (e) {
-		/* cast the exception to a pending exception */
-		pe = container_of(e, struct dm_snap_pending_exception, e);
-		goto out;
-	}
-
-	/*
 	 * Create a new pending exception, we don't want
 	 * to hold the lock while we do this.
 	 */
@@ -1010,11 +1010,10 @@ __find_pending_exception(struct dm_snaps
 		return NULL;
 	}
 
-	e = lookup_exception(&s->pending, chunk);
-	if (e) {
+	pe2 = __lookup_pending_exception(s, chunk);
+	if (pe2) {
 		free_pending_exception(pe);
-		pe = container_of(e, struct dm_snap_pending_exception, e);
-		goto out;
+		return pe2;
 	}
 
 	pe->e.old_chunk = chunk;
@@ -1032,7 +1031,6 @@ __find_pending_exception(struct dm_snaps
 	get_pending_exception(pe);
 	insert_exception(&s->pending, &pe->e);
 
- out:
 	return pe;
 }
 
@@ -1083,11 +1081,14 @@ static int snapshot_map(struct dm_target
 	 * writeable.
 	 */
 	if (bio_rw(bio) == WRITE) {
-		pe = __find_pending_exception(s, bio);
+		pe = __lookup_pending_exception(s, chunk);
 		if (!pe) {
-			__invalidate_snapshot(s, -ENOMEM);
-			r = -EIO;
-			goto out_unlock;
+			pe = __find_pending_exception(s, bio);
+			if (!pe) {
+				__invalidate_snapshot(s, -ENOMEM);
+				r = -EIO;
+				goto out_unlock;
+			}
 		}
 
 		remap_exception(s, &pe->e, bio, chunk);
@@ -1217,10 +1218,13 @@ static int __origin_write(struct list_he
 		if (e)
 			goto next_snapshot;
 
-		pe = __find_pending_exception(snap, bio);
+		pe = __lookup_pending_exception(snap, chunk);
 		if (!pe) {
-			__invalidate_snapshot(snap, -ENOMEM);
-			goto next_snapshot;
+			pe = __find_pending_exception(snap, bio);
+			if (!pe) {
+				__invalidate_snapshot(snap, -ENOMEM);
+				goto next_snapshot;
+			}
 		}
 
 		if (!primary_pe) {

