Return-Path: <linux-kernel-owner+w=401wt.eu-S933195AbZKFWqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195AbZKFWqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932292AbZKFWqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:46:13 -0500
Received: from kroah.org ([198.145.64.141]:56723 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257AbZKFWWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:34 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:41 2009
Message-Id: <20091106221541.185278978@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [19/99] dm snapshot: sort by chunk size to fix race
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=dm-snapshot-sort-by-chunk-size-to-fix-race.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mikulas Patocka <mpatocka@redhat.com>

commit 6d45d93ead319423099b82a4efd775bc0f159121 upstream.

Avoid a race causing corruption when snapshots of the same origin have
different chunk sizes by sorting the internal list of snapshots by chunk
size, largest first.
  https://bugzilla.redhat.com/show_bug.cgi?id=182659

For example, let's have two snapshots with different chunk sizes. The
first snapshot (1) has small chunk size and the second snapshot (2) has
large chunk size.  Let's have chunks A, B, C in these snapshots:
snapshot1: ====A====   ====B====
snapshot2: ==========C==========

(Chunk size is a power of 2. Chunks are aligned.)

A write to the origin at a position within A and C comes along. It
triggers reallocation of A, then reallocation of C and links them
together using A as the 'primary' exception.

Then another write to the origin comes along at a position within B and
C.  It creates pending exception for B.  C already has a reallocation in
progress and it already has a primary exception (A), so nothing is done
to it: B and C are not linked.

If the reallocation of B finishes before the reallocation of C, because
there is no link with the pending exception for C it does not know to
wait for it and, the second write is dispatched to the origin and causes
data corruption in the chunk C in snapshot2.

To avoid this situation, we maintain snapshots sorted in descending
order of chunk size.  This leads to a guaranteed ordering on the links
between the pending exceptions and avoids the problem explained above -
both A and B now get linked to C.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-snap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -296,6 +296,7 @@ static void __insert_origin(struct origi
  */
 static int register_snapshot(struct dm_snapshot *snap)
 {
+	struct dm_snapshot *l;
 	struct origin *o, *new_o;
 	struct block_device *bdev = snap->origin->bdev;
 
@@ -319,7 +320,11 @@ static int register_snapshot(struct dm_s
 		__insert_origin(o);
 	}
 
-	list_add_tail(&snap->list, &o->snapshots);
+	/* Sort the list according to chunk size, largest-first smallest-last */
+	list_for_each_entry(l, &o->snapshots, list)
+		if (l->store->chunk_size < snap->store->chunk_size)
+			break;
+	list_add_tail(&snap->list, &l->list);
 
 	up_write(&_origins_lock);
 	return 0;


