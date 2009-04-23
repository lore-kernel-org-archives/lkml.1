Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbZDWHpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbZDWHpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbZDWHbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:31:06 -0400
Received: from sous-sol.org ([216.99.217.87]:50548 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756537AbZDWHbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:31:02 -0400
Message-Id: <20090423072503.721622155@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:59 -0700
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
Subject: [patch 039/100] dm snapshot: avoid dropping lock in __find_pending_exception
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=dm-snapshot-avoid-dropping-lock-in-__find_pending_exception.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Mikulas Patocka <mpatocka@redhat.com>

upstream commit: c66213921c816f6b1b16a84911618ba9a363b134

It is uncommon and bug-prone to drop a lock in a function that is called with
the lock held, so this is moved to the caller.

Cc: stable@kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/dm-snap.c |   42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -992,23 +992,10 @@ __lookup_pending_exception(struct dm_sna
  * this.
  */
 static struct dm_snap_pending_exception *
-__find_pending_exception(struct dm_snapshot *s, struct bio *bio)
+__find_pending_exception(struct dm_snapshot *s,
+			 struct dm_snap_pending_exception *pe, chunk_t chunk)
 {
-	struct dm_snap_pending_exception *pe, *pe2;
-	chunk_t chunk = sector_to_chunk(s, bio->bi_sector);
-
-	/*
-	 * Create a new pending exception, we don't want
-	 * to hold the lock while we do this.
-	 */
-	up_write(&s->lock);
-	pe = alloc_pending_exception(s);
-	down_write(&s->lock);
-
-	if (!s->valid) {
-		free_pending_exception(pe);
-		return NULL;
-	}
+	struct dm_snap_pending_exception *pe2;
 
 	pe2 = __lookup_pending_exception(s, chunk);
 	if (pe2) {
@@ -1083,7 +1070,17 @@ static int snapshot_map(struct dm_target
 	if (bio_rw(bio) == WRITE) {
 		pe = __lookup_pending_exception(s, chunk);
 		if (!pe) {
-			pe = __find_pending_exception(s, bio);
+			up_write(&s->lock);
+			pe = alloc_pending_exception(s);
+			down_write(&s->lock);
+
+			if (!s->valid) {
+				free_pending_exception(pe);
+				r = -EIO;
+				goto out_unlock;
+			}
+
+			pe = __find_pending_exception(s, pe, chunk);
 			if (!pe) {
 				__invalidate_snapshot(s, -ENOMEM);
 				r = -EIO;
@@ -1220,7 +1217,16 @@ static int __origin_write(struct list_he
 
 		pe = __lookup_pending_exception(snap, chunk);
 		if (!pe) {
-			pe = __find_pending_exception(snap, bio);
+			up_write(&snap->lock);
+			pe = alloc_pending_exception(snap);
+			down_write(&snap->lock);
+
+			if (!snap->valid) {
+				free_pending_exception(pe);
+				goto next_snapshot;
+			}
+
+			pe = __find_pending_exception(snap, pe, chunk);
 			if (!pe) {
 				__invalidate_snapshot(snap, -ENOMEM);
 				goto next_snapshot;

