Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbZKFWWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbZKFWWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760145AbZKFWWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:44 -0500
Received: from kroah.org ([198.145.64.141]:56766 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932366AbZKFWWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:40 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:42 2009
Message-Id: <20091106221542.080522228@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [26/99] dm snapshot: use unsigned integer chunk size
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=dm-snapshot-use-unsigned-integer-chunk-size.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mikulas Patocka <mpatocka@redhat.com>

commit df96eee679ba28c98cf722fa7c9f4286ee1ed0bd upstream.

Use unsigned integer chunk size.

Maximum chunk size is 512kB, there won't ever be need to use 4GB chunk size,
so the number can be 32-bit. This fixes compiler failure on 32-bit systems
with large block devices.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-exception-store.c |   20 +++++++++++---------
 drivers/md/dm-exception-store.h |    8 ++++----
 drivers/md/dm-snap-persistent.c |   16 ++++++++--------
 drivers/md/dm-snap.c            |    4 ++--
 4 files changed, 25 insertions(+), 23 deletions(-)

--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -155,7 +155,8 @@ static int set_chunk_size(struct dm_exce
 	char *value;
 
 	chunk_size_ulong = simple_strtoul(chunk_size_arg, &value, 10);
-	if (*chunk_size_arg == '\0' || *value != '\0') {
+	if (*chunk_size_arg == '\0' || *value != '\0' ||
+	    chunk_size_ulong > UINT_MAX) {
 		*error = "Invalid chunk size";
 		return -EINVAL;
 	}
@@ -171,34 +172,35 @@ static int set_chunk_size(struct dm_exce
 	 */
 	chunk_size_ulong = round_up(chunk_size_ulong, PAGE_SIZE >> 9);
 
-	return dm_exception_store_set_chunk_size(store, chunk_size_ulong,
+	return dm_exception_store_set_chunk_size(store,
+						 (unsigned) chunk_size_ulong,
 						 error);
 }
 
 int dm_exception_store_set_chunk_size(struct dm_exception_store *store,
-				      unsigned long chunk_size_ulong,
+				      unsigned chunk_size,
 				      char **error)
 {
 	/* Check chunk_size is a power of 2 */
-	if (!is_power_of_2(chunk_size_ulong)) {
+	if (!is_power_of_2(chunk_size)) {
 		*error = "Chunk size is not a power of 2";
 		return -EINVAL;
 	}
 
 	/* Validate the chunk size against the device block size */
-	if (chunk_size_ulong % (bdev_logical_block_size(store->cow->bdev) >> 9)) {
+	if (chunk_size % (bdev_logical_block_size(store->cow->bdev) >> 9)) {
 		*error = "Chunk size is not a multiple of device blocksize";
 		return -EINVAL;
 	}
 
-	if (chunk_size_ulong > INT_MAX >> SECTOR_SHIFT) {
+	if (chunk_size > INT_MAX >> SECTOR_SHIFT) {
 		*error = "Chunk size is too high";
 		return -EINVAL;
 	}
 
-	store->chunk_size = chunk_size_ulong;
-	store->chunk_mask = chunk_size_ulong - 1;
-	store->chunk_shift = ffs(chunk_size_ulong) - 1;
+	store->chunk_size = chunk_size;
+	store->chunk_mask = chunk_size - 1;
+	store->chunk_shift = ffs(chunk_size) - 1;
 
 	return 0;
 }
--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -101,9 +101,9 @@ struct dm_exception_store {
 	struct dm_dev *cow;
 
 	/* Size of data blocks saved - must be a power of 2 */
-	chunk_t chunk_size;
-	chunk_t chunk_mask;
-	chunk_t chunk_shift;
+	unsigned chunk_size;
+	unsigned chunk_mask;
+	unsigned chunk_shift;
 
 	void *context;
 };
@@ -169,7 +169,7 @@ int dm_exception_store_type_register(str
 int dm_exception_store_type_unregister(struct dm_exception_store_type *type);
 
 int dm_exception_store_set_chunk_size(struct dm_exception_store *store,
-				      unsigned long chunk_size_ulong,
+				      unsigned chunk_size,
 				      char **error);
 
 int dm_exception_store_create(struct dm_target *ti, int argc, char **argv,
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -961,7 +961,7 @@ static void start_copy(struct dm_snap_pe
 
 	src.bdev = bdev;
 	src.sector = chunk_to_sector(s->store, pe->e.old_chunk);
-	src.count = min(s->store->chunk_size, dev_size - src.sector);
+	src.count = min((sector_t)s->store->chunk_size, dev_size - src.sector);
 
 	dest.bdev = s->store->cow->bdev;
 	dest.sector = chunk_to_sector(s->store, pe->e.new_chunk);
@@ -1402,7 +1402,7 @@ static void origin_resume(struct dm_targ
 	struct dm_dev *dev = ti->private;
 	struct dm_snapshot *snap;
 	struct origin *o;
-	chunk_t chunk_size = 0;
+	unsigned chunk_size = 0;
 
 	down_read(&_origins_lock);
 	o = __lookup_origin(dev->bdev);
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -284,12 +284,13 @@ static int read_header(struct pstore *ps
 {
 	int r;
 	struct disk_header *dh;
-	chunk_t chunk_size;
+	unsigned chunk_size;
 	int chunk_size_supplied = 1;
 	char *chunk_err;
 
 	/*
-	 * Use default chunk size (or hardsect_size, if larger) if none supplied
+	 * Use default chunk size (or logical_block_size, if larger)
+	 * if none supplied
 	 */
 	if (!ps->store->chunk_size) {
 		ps->store->chunk_size = max(DM_CHUNK_SIZE_DEFAULT_SECTORS,
@@ -334,10 +335,9 @@ static int read_header(struct pstore *ps
 		return 0;
 
 	if (chunk_size_supplied)
-		DMWARN("chunk size %llu in device metadata overrides "
-		       "table chunk size of %llu.",
-		       (unsigned long long)chunk_size,
-		       (unsigned long long)ps->store->chunk_size);
+		DMWARN("chunk size %u in device metadata overrides "
+		       "table chunk size of %u.",
+		       chunk_size, ps->store->chunk_size);
 
 	/* We had a bogus chunk_size. Fix stuff up. */
 	free_area(ps);
@@ -345,8 +345,8 @@ static int read_header(struct pstore *ps
 	r = dm_exception_store_set_chunk_size(ps->store, chunk_size,
 					      &chunk_err);
 	if (r) {
-		DMERR("invalid on-disk chunk size %llu: %s.",
-		      (unsigned long long)chunk_size, chunk_err);
+		DMERR("invalid on-disk chunk size %u: %s.",
+		      chunk_size, chunk_err);
 		return r;
 	}
 


