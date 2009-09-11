Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbZIKA34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbZIKA34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbZIKA3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:29:19 -0400
Received: from kroah.org ([198.145.64.141]:38117 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbZIKA3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:29:13 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:24:12 2009
Message-Id: <20090911002411.963437354@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:23:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 19/22] dm snapshot: refactor zero_disk_area to use chunk_io
References: <20090911002246.666327880@mini.kroah.org>
Content-Disposition: inline; filename=dm-snapshot-refactor-zero_disk_area-to-use-chunk_io.patch
In-Reply-To: <20090911002616.GA12087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mikulas Patocka <mpatocka@redhat.com>

commit 02d2fd31defce6ff77146ad0fef4f19006055d86 upstream.

Refactor chunk_io to prepare for the fix in the following patch.

Pass an area pointer to chunk_io and simplify zero_disk_area to use
chunk_io.  No functional change.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-snap-persistent.c |   26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -188,7 +188,8 @@ static void do_metadata(struct work_stru
 /*
  * Read or write a chunk aligned and sized block of data from a device.
  */
-static int chunk_io(struct pstore *ps, chunk_t chunk, int rw, int metadata)
+static int chunk_io(struct pstore *ps, void *area, chunk_t chunk, int rw,
+		    int metadata)
 {
 	struct dm_io_region where = {
 		.bdev = ps->store->cow->bdev,
@@ -198,7 +199,7 @@ static int chunk_io(struct pstore *ps, c
 	struct dm_io_request io_req = {
 		.bi_rw = rw,
 		.mem.type = DM_IO_VMA,
-		.mem.ptr.vma = ps->area,
+		.mem.ptr.vma = area,
 		.client = ps->io_client,
 		.notify.fn = NULL,
 	};
@@ -240,7 +241,7 @@ static int area_io(struct pstore *ps, in
 
 	chunk = area_location(ps, ps->current_area);
 
-	r = chunk_io(ps, chunk, rw, 0);
+	r = chunk_io(ps, ps->area, chunk, rw, 0);
 	if (r)
 		return r;
 
@@ -254,20 +255,7 @@ static void zero_memory_area(struct psto
 
 static int zero_disk_area(struct pstore *ps, chunk_t area)
 {
-	struct dm_io_region where = {
-		.bdev = ps->store->cow->bdev,
-		.sector = ps->store->chunk_size * area_location(ps, area),
-		.count = ps->store->chunk_size,
-	};
-	struct dm_io_request io_req = {
-		.bi_rw = WRITE,
-		.mem.type = DM_IO_VMA,
-		.mem.ptr.vma = ps->zero_area,
-		.client = ps->io_client,
-		.notify.fn = NULL,
-	};
-
-	return dm_io(&io_req, 1, &where, NULL);
+	return chunk_io(ps, ps->zero_area, area_location(ps, area), WRITE, 0);
 }
 
 static int read_header(struct pstore *ps, int *new_snapshot)
@@ -297,7 +285,7 @@ static int read_header(struct pstore *ps
 	if (r)
 		return r;
 
-	r = chunk_io(ps, 0, READ, 1);
+	r = chunk_io(ps, ps->area, 0, READ, 1);
 	if (r)
 		goto bad;
 
@@ -359,7 +347,7 @@ static int write_header(struct pstore *p
 	dh->version = cpu_to_le32(ps->version);
 	dh->chunk_size = cpu_to_le32(ps->store->chunk_size);
 
-	return chunk_io(ps, 0, WRITE, 1);
+	return chunk_io(ps, ps->area, 0, WRITE, 1);
 }
 
 /*


