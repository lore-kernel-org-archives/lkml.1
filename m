Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYJXEn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYJXEn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYJXEjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:18 -0400
Received: from kroah.org ([198.145.64.141]:51743 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752393AbYJXEjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:15 -0400
Date: Thu, 23 Oct 2008 21:34:23 -0700
From: Greg KH <gregkh@suse.de>
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
       alan@lxorguk.ukuu.org.uk, Alasdair G Kergon <agk@redhat.com>,
       Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 11/27] dm exception store: refactor zero_area
Message-ID: <20081024043423.GL30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-exception-store-refactor-zero_area.patch"
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Alasdair G Kergon <agk@redhat.com>

commit 7c9e6c17325fab380fbe9c9787680ff7d4a51abd upstream

Use a separate buffer for writing zeroes to the on-disk snapshot
exception store, make the updating of ps->current_area explicit and
refactor the code in preparation for the fix in the next patch.

No functional change.

Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-exception-store.c |  103 ++++++++++++++++++++++++++--------------
 1 file changed, 69 insertions(+), 34 deletions(-)

--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -105,6 +105,11 @@ struct pstore {
 	void *area;
 
 	/*
+	 * An area of zeros used to clear the next area.
+	 */
+	void *zero_area;
+
+	/*
 	 * Used to keep track of which metadata area the data in
 	 * 'chunk' refers to.
 	 */
@@ -149,6 +154,13 @@ static int alloc_area(struct pstore *ps)
 	if (!ps->area)
 		return r;
 
+	ps->zero_area = vmalloc(len);
+	if (!ps->zero_area) {
+		vfree(ps->area);
+		return r;
+	}
+	memset(ps->zero_area, 0, len);
+
 	return 0;
 }
 
@@ -156,6 +168,8 @@ static void free_area(struct pstore *ps)
 {
 	vfree(ps->area);
 	ps->area = NULL;
+	vfree(ps->zero_area);
+	ps->zero_area = NULL;
 }
 
 struct mdata_req {
@@ -212,13 +226,13 @@ static int chunk_io(struct pstore *ps, u
  * Read or write a metadata area.  Remembering to skip the first
  * chunk which holds the header.
  */
-static int area_io(struct pstore *ps, uint32_t area, int rw)
+static int area_io(struct pstore *ps, int rw)
 {
 	int r;
 	uint32_t chunk;
 
 	/* convert a metadata area index to a chunk index */
-	chunk = 1 + ((ps->exceptions_per_area + 1) * area);
+	chunk = area_location(ps, ps->current_area);
 
 	r = chunk_io(ps, chunk, rw, 0);
 	if (r)
@@ -228,10 +242,27 @@ static int area_io(struct pstore *ps, ui
 	return 0;
 }
 
-static int zero_area(struct pstore *ps, uint32_t area)
+static void zero_memory_area(struct pstore *ps)
 {
 	memset(ps->area, 0, ps->snap->chunk_size << SECTOR_SHIFT);
-	return area_io(ps, area, WRITE);
+}
+
+static int zero_disk_area(struct pstore *ps, chunk_t area)
+{
+	struct dm_io_region where = {
+		.bdev = ps->snap->cow->bdev,
+		.sector = ps->snap->chunk_size * area_location(ps, area),
+		.count = ps->snap->chunk_size,
+	};
+	struct dm_io_request io_req = {
+		.bi_rw = WRITE,
+		.mem.type = DM_IO_VMA,
+		.mem.ptr.vma = ps->zero_area,
+		.client = ps->io_client,
+		.notify.fn = NULL,
+	};
+
+	return dm_io(&io_req, 1, &where, NULL);
 }
 
 static int read_header(struct pstore *ps, int *new_snapshot)
@@ -404,15 +435,14 @@ static int insert_exceptions(struct psto
 
 static int read_exceptions(struct pstore *ps)
 {
-	uint32_t area;
 	int r, full = 1;
 
 	/*
 	 * Keeping reading chunks and inserting exceptions until
 	 * we find a partially full area.
 	 */
-	for (area = 0; full; area++) {
-		r = area_io(ps, area, READ);
+	for (ps->current_area = 0; full; ps->current_area++) {
+		r = area_io(ps, READ);
 		if (r)
 			return r;
 
@@ -421,6 +451,8 @@ static int read_exceptions(struct pstore
 			return r;
 	}
 
+	ps->current_area--;
+
 	return 0;
 }
 
@@ -479,12 +511,13 @@ static int persistent_read_metadata(stru
 			return r;
 		}
 
-		r = zero_area(ps, 0);
+		ps->current_area = 0;
+		zero_memory_area(ps);
+		r = zero_disk_area(ps, 0);
 		if (r) {
-			DMWARN("zero_area(0) failed");
+			DMWARN("zero_disk_area(0) failed");
 			return r;
 		}
-
 	} else {
 		/*
 		 * Sanity checks.
@@ -542,7 +575,6 @@ static void persistent_commit(struct exc
 			      void (*callback) (void *, int success),
 			      void *callback_context)
 {
-	int r;
 	unsigned int i;
 	struct pstore *ps = get_info(store);
 	struct disk_exception de;
@@ -563,33 +595,36 @@ static void persistent_commit(struct exc
 	cb->context = callback_context;
 
 	/*
-	 * If there are no more exceptions in flight, or we have
-	 * filled this metadata area we commit the exceptions to
-	 * disk.
-	 */
-	if (atomic_dec_and_test(&ps->pending_count) ||
-	    (ps->current_committed == ps->exceptions_per_area)) {
-		r = area_io(ps, ps->current_area, WRITE);
-		if (r)
-			ps->valid = 0;
+	 * If there are exceptions in flight and we have not yet
+	 * filled this metadata area there's nothing more to do.
+	 */
+	if (!atomic_dec_and_test(&ps->pending_count) &&
+	    (ps->current_committed != ps->exceptions_per_area))
+		return;
 
-		/*
-		 * Have we completely filled the current area ?
-		 */
-		if (ps->current_committed == ps->exceptions_per_area) {
-			ps->current_committed = 0;
-			r = zero_area(ps, ps->current_area + 1);
-			if (r)
-				ps->valid = 0;
-		}
+	/*
+	 * Commit exceptions to disk.
+	 */
+	if (area_io(ps, WRITE))
+		ps->valid = 0;
 
-		for (i = 0; i < ps->callback_count; i++) {
-			cb = ps->callbacks + i;
-			cb->callback(cb->context, r == 0 ? 1 : 0);
-		}
+	/*
+	 * Advance to the next area if this one is full.
+	 */
+	if (ps->current_committed == ps->exceptions_per_area) {
+		if (zero_disk_area(ps, ps->current_area + 1))
+			ps->valid = 0;
+		ps->current_committed = 0;
+		ps->current_area++;
+		zero_memory_area(ps);
+	}
 
-		ps->callback_count = 0;
+	for (i = 0; i < ps->callback_count; i++) {
+		cb = ps->callbacks + i;
+		cb->callback(cb->context, ps->valid);
 	}
+
+	ps->callback_count = 0;
 }
 
 static void persistent_drop(struct exception_store *store)

-- 
