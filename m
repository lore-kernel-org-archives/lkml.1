Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbZDWHmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbZDWHmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbZDWHaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:30:39 -0400
Received: from sous-sol.org ([216.99.217.87]:50464 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756446AbZDWHai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:30:38 -0400
Message-Id: <20090423072508.899905102@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:00 -0700
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
Subject: [patch 040/100] dm snapshot: avoid having two exceptions for the same chunk
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=dm-snapshot-avoid-having-two-exceptions-for-the-same-chunk.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Mikulas Patocka <mpatocka@redhat.com>

upstream commit: 35bf659b008e83e725dcd30f542e38461dbb867c

We need to check if the exception was completed after dropping the lock.

After regaining the lock, __find_pending_exception checks if the exception
was already placed into &s->pending hash.

But we don't check if the exception was already completed and placed into
&s->complete hash. If the process waiting in alloc_pending_exception was
delayed at this point because of a scheduling latency and the exception
was meanwhile completed, we'd miss that and allocate another pending
exception for already completed chunk.

It would lead to a situation where two records for the same chunk exist
and potential data corruption because multiple snapshot I/Os to the
affected chunk could be redirected to different locations in the
snapshot.

Cc: stable@kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/dm-snap.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1080,6 +1080,13 @@ static int snapshot_map(struct dm_target
 				goto out_unlock;
 			}
 
+			e = lookup_exception(&s->complete, chunk);
+			if (e) {
+				free_pending_exception(pe);
+				remap_exception(s, e, bio, chunk);
+				goto out_unlock;
+			}
+
 			pe = __find_pending_exception(s, pe, chunk);
 			if (!pe) {
 				__invalidate_snapshot(s, -ENOMEM);
@@ -1226,6 +1233,12 @@ static int __origin_write(struct list_he
 				goto next_snapshot;
 			}
 
+			e = lookup_exception(&snap->complete, chunk);
+			if (e) {
+				free_pending_exception(pe);
+				goto next_snapshot;
+			}
+
 			pe = __find_pending_exception(snap, pe, chunk);
 			if (!pe) {
 				__invalidate_snapshot(snap, -ENOMEM);

