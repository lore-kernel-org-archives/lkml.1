Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbZKTVEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbZKTVEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbZKTVEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:04:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZKTVEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:04:43 -0500
Date: Fri, 20 Nov 2009 16:04:48 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 07/13] dm snapshot: do not allow more than one merging
 snapshot.
Message-ID: <20091120210447.GD9458@redhat.com>
References: <1258748873-24185-1-git-send-email-snitzer@redhat.com>
 <1258748873-24185-8-git-send-email-snitzer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258748873-24185-8-git-send-email-snitzer@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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
 drivers/md/dm-snap.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
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
@@ -346,8 +366,19 @@ static int __validate_exception_handover
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
