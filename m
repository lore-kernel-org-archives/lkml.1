Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbZIKA3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbZIKA3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZIKA3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:29:21 -0400
Received: from kroah.org ([198.145.64.141]:38131 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbZIKA3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:29:16 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:24:12 2009
Message-Id: <20090911002412.397568158@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:23:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 22/22] dm snapshot: fix on disk chunk size validation
References: <20090911002246.666327880@mini.kroah.org>
Content-Disposition: inline; filename=dm-snapshot-fix-on-disk-chunk-size-validation.patch
In-Reply-To: <20090911002616.GA12087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mikulas Patocka <mpatocka@redhat.com>

commit ae0b7448e91353ea5f821601a055aca6b58042cd upstream.

Fix some problems seen in the chunk size processing when activating a
pre-existing snapshot.

For a new snapshot, the chunk size can either be supplied by the creator
or a default value can be used.  For an existing snapshot, the
chunk size in the snapshot header on disk should always be used.

If someone attempts to load an existing snapshot and has the 'default
chunk size' option set, the kernel uses its default value even when it
is incorrect for the snapshot being loaded.  This patch ensures the
correct on-disk value is always used.

Secondly, when the code does use the chunk size stored on the disk it is
prudent to revalidate it, so the code can exit cleanly if it got
corrupted as happened in
https://bugzilla.redhat.com/show_bug.cgi?id=461506 .

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-exception-store.c |    5 +++++
 drivers/md/dm-snap-persistent.c |   22 ++++++++++++++--------
 2 files changed, 19 insertions(+), 8 deletions(-)

--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -191,6 +191,11 @@ int dm_exception_store_set_chunk_size(st
 		return -EINVAL;
 	}
 
+	if (chunk_size_ulong > INT_MAX >> SECTOR_SHIFT) {
+		*error = "Chunk size is too high";
+		return -EINVAL;
+	}
+
 	store->chunk_size = chunk_size_ulong;
 	store->chunk_mask = chunk_size_ulong - 1;
 	store->chunk_shift = ffs(chunk_size_ulong) - 1;
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -286,6 +286,7 @@ static int read_header(struct pstore *ps
 	struct disk_header *dh;
 	chunk_t chunk_size;
 	int chunk_size_supplied = 1;
+	char *chunk_err;
 
 	/*
 	 * Use default chunk size (or hardsect_size, if larger) if none supplied
@@ -329,20 +330,25 @@ static int read_header(struct pstore *ps
 	ps->version = le32_to_cpu(dh->version);
 	chunk_size = le32_to_cpu(dh->chunk_size);
 
-	if (!chunk_size_supplied || ps->store->chunk_size == chunk_size)
+	if (ps->store->chunk_size == chunk_size)
 		return 0;
 
-	DMWARN("chunk size %llu in device metadata overrides "
-	       "table chunk size of %llu.",
-	       (unsigned long long)chunk_size,
-	       (unsigned long long)ps->store->chunk_size);
+	if (chunk_size_supplied)
+		DMWARN("chunk size %llu in device metadata overrides "
+		       "table chunk size of %llu.",
+		       (unsigned long long)chunk_size,
+		       (unsigned long long)ps->store->chunk_size);
 
 	/* We had a bogus chunk_size. Fix stuff up. */
 	free_area(ps);
 
-	ps->store->chunk_size = chunk_size;
-	ps->store->chunk_mask = chunk_size - 1;
-	ps->store->chunk_shift = ffs(chunk_size) - 1;
+	r = dm_exception_store_set_chunk_size(ps->store, chunk_size,
+					      &chunk_err);
+	if (r) {
+		DMERR("invalid on-disk chunk size %llu: %s.",
+		      (unsigned long long)chunk_size, chunk_err);
+		return r;
+	}
 
 	r = dm_io_client_resize(sectors_to_pages(ps->store->chunk_size),
 				ps->io_client);


