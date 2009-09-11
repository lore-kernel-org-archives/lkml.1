Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbZIKA3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbZIKA3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZIKA3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:29:17 -0400
Received: from kroah.org ([198.145.64.141]:38120 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbZIKA3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:29:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:24:12 2009
Message-Id: <20090911002412.104202809@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:23:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 20/22] dm snapshot: fix header corruption race on invalidation
References: <20090911002246.666327880@mini.kroah.org>
Content-Disposition: inline; filename=dm-snapshot-fix-header-corruption-race-on-invalidation.patch
In-Reply-To: <20090911002616.GA12087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mikulas Patocka <mpatocka@redhat.com>

commit 61578dcd3fafe6babd72e8db32110cc0b630a432 upstream.

If a persistent snapshot fills up, a race can corrupt the on-disk header
which causes a crash on any future attempt to activate the snapshot
(typically while booting).  This patch fixes the race.

When the snapshot overflows, __invalidate_snapshot is called, which calls
snapshot store method drop_snapshot. It goes to persistent_drop_snapshot that
calls write_header. write_header constructs the new header in the "area"
location.

Concurrently, an existing kcopyd job may finish, call copy_callback
and commit_exception method, that goes to persistent_commit_exception.
persistent_commit_exception doesn't do locking, relying on the fact that
callbacks are single-threaded, but it can race with snapshot invalidation and
overwrite the header that is just being written while the snapshot is being
invalidated.

The result of this race is a corrupted header being written that can
lead to a crash on further reactivation (if chunk_size is zero in the
corrupted header).

The fix is to use separate memory areas for each.

See the bug: https://bugzilla.redhat.com/show_bug.cgi?id=461506

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-snap-persistent.c |   44 ++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -106,6 +106,13 @@ struct pstore {
 	void *zero_area;
 
 	/*
+	 * An area used for header. The header can be written
+	 * concurrently with metadata (when invalidating the snapshot),
+	 * so it needs a separate buffer.
+	 */
+	void *header_area;
+
+	/*
 	 * Used to keep track of which metadata area the data in
 	 * 'chunk' refers to.
 	 */
@@ -148,16 +155,27 @@ static int alloc_area(struct pstore *ps)
 	 */
 	ps->area = vmalloc(len);
 	if (!ps->area)
-		return r;
+		goto err_area;
 
 	ps->zero_area = vmalloc(len);
-	if (!ps->zero_area) {
-		vfree(ps->area);
-		return r;
-	}
+	if (!ps->zero_area)
+		goto err_zero_area;
 	memset(ps->zero_area, 0, len);
 
+	ps->header_area = vmalloc(len);
+	if (!ps->header_area)
+		goto err_header_area;
+
 	return 0;
+
+err_header_area:
+	vfree(ps->zero_area);
+
+err_zero_area:
+	vfree(ps->area);
+
+err_area:
+	return r;
 }
 
 static void free_area(struct pstore *ps)
@@ -169,6 +187,10 @@ static void free_area(struct pstore *ps)
 	if (ps->zero_area)
 		vfree(ps->zero_area);
 	ps->zero_area = NULL;
+
+	if (ps->header_area)
+		vfree(ps->header_area);
+	ps->header_area = NULL;
 }
 
 struct mdata_req {
@@ -285,11 +307,11 @@ static int read_header(struct pstore *ps
 	if (r)
 		return r;
 
-	r = chunk_io(ps, ps->area, 0, READ, 1);
+	r = chunk_io(ps, ps->header_area, 0, READ, 1);
 	if (r)
 		goto bad;
 
-	dh = (struct disk_header *) ps->area;
+	dh = ps->header_area;
 
 	if (le32_to_cpu(dh->magic) == 0) {
 		*new_snapshot = 1;
@@ -339,15 +361,15 @@ static int write_header(struct pstore *p
 {
 	struct disk_header *dh;
 
-	memset(ps->area, 0, ps->store->chunk_size << SECTOR_SHIFT);
+	memset(ps->header_area, 0, ps->store->chunk_size << SECTOR_SHIFT);
 
-	dh = (struct disk_header *) ps->area;
+	dh = ps->header_area;
 	dh->magic = cpu_to_le32(SNAP_MAGIC);
 	dh->valid = cpu_to_le32(ps->valid);
 	dh->version = cpu_to_le32(ps->version);
 	dh->chunk_size = cpu_to_le32(ps->store->chunk_size);
 
-	return chunk_io(ps, ps->area, 0, WRITE, 1);
+	return chunk_io(ps, ps->header_area, 0, WRITE, 1);
 }
 
 /*
@@ -667,6 +689,8 @@ static int persistent_ctr(struct dm_exce
 	ps->valid = 1;
 	ps->version = SNAPSHOT_DISK_VERSION;
 	ps->area = NULL;
+	ps->zero_area = NULL;
+	ps->header_area = NULL;
 	ps->next_free = 2;	/* skipping the header and first area */
 	ps->current_committed = 0;
 


