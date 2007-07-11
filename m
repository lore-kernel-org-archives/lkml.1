Return-Path: <linux-kernel-owner+w=401wt.eu-S932629AbXGKVB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629AbXGKVB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933652AbXGKU75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:59:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933430AbXGKU7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:59:55 -0400
Date: Wed, 11 Jul 2007 21:59:13 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Milan Broz <mbroz@redhat.com>
Subject: [2.6.23 PATCH 08/18] dm snapshot: fix invalidation deadlock
Message-ID: <20070711205913.GZ24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Milan Broz <mbroz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milan Broz <mbroz@redhat.com>

Process persistent exception store metadata IOs in a separate thread.

A snapshot may become invalid while inside generic_make_request().
A synchronous write is then needed to update the metadata while still
inside that function.  Since the introduction of
md-dm-reduce-stack-usage-with-stacked-block-devices.patch this has to
be performed by a separate thread to avoid deadlock.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---

 drivers/md/dm-exception-store.c |   48 +++++++++++++++++++++++++++++++++++-----
 1 files changed, 43 insertions(+), 5 deletions(-)

Index: linux/drivers/md/dm-exception-store.c
===================================================================
--- linux.orig/drivers/md/dm-exception-store.c	2007-07-11 21:37:38.000000000 +0100
+++ linux/drivers/md/dm-exception-store.c	2007-07-11 21:37:44.000000000 +0100
@@ -125,6 +125,8 @@ struct pstore {
 	uint32_t callback_count;
 	struct commit_callback *callbacks;
 	struct dm_io_client *io_client;
+
+	struct workqueue_struct *metadata_wq;
 };
 
 static unsigned sectors_to_pages(unsigned sectors)
@@ -156,10 +158,24 @@ static void free_area(struct pstore *ps)
 	ps->area = NULL;
 }
 
+struct mdata_req {
+	struct io_region *where;
+	struct dm_io_request *io_req;
+	struct work_struct work;
+	int result;
+};
+
+static void do_metadata(struct work_struct *work)
+{
+	struct mdata_req *req = container_of(work, struct mdata_req, work);
+
+	req->result = dm_io(req->io_req, 1, req->where, NULL);
+}
+
 /*
  * Read or write a chunk aligned and sized block of data from a device.
  */
-static int chunk_io(struct pstore *ps, uint32_t chunk, int rw)
+static int chunk_io(struct pstore *ps, uint32_t chunk, int rw, int metadata)
 {
 	struct io_region where = {
 		.bdev = ps->snap->cow->bdev,
@@ -173,8 +189,23 @@ static int chunk_io(struct pstore *ps, u
 		.client = ps->io_client,
 		.notify.fn = NULL,
 	};
+	struct mdata_req req;
+
+	if (!metadata)
+		return dm_io(&io_req, 1, &where, NULL);
 
-	return dm_io(&io_req, 1, &where, NULL);
+	req.where = &where;
+	req.io_req = &io_req;
+
+	/*
+	 * Issue the synchronous I/O from a different thread
+	 * to avoid generic_make_request recursion.
+	 */
+	INIT_WORK(&req.work, do_metadata);
+	queue_work(ps->metadata_wq, &req.work);
+	flush_workqueue(ps->metadata_wq);
+
+	return req.result;
 }
 
 /*
@@ -189,7 +220,7 @@ static int area_io(struct pstore *ps, ui
 	/* convert a metadata area index to a chunk index */
 	chunk = 1 + ((ps->exceptions_per_area + 1) * area);
 
-	r = chunk_io(ps, chunk, rw);
+	r = chunk_io(ps, chunk, rw, 0);
 	if (r)
 		return r;
 
@@ -230,7 +261,7 @@ static int read_header(struct pstore *ps
 	if (r)
 		return r;
 
-	r = chunk_io(ps, 0, READ);
+	r = chunk_io(ps, 0, READ, 1);
 	if (r)
 		goto bad;
 
@@ -292,7 +323,7 @@ static int write_header(struct pstore *p
 	dh->version = cpu_to_le32(ps->version);
 	dh->chunk_size = cpu_to_le32(ps->snap->chunk_size);
 
-	return chunk_io(ps, 0, WRITE);
+	return chunk_io(ps, 0, WRITE, 1);
 }
 
 /*
@@ -409,6 +440,7 @@ static void persistent_destroy(struct ex
 {
 	struct pstore *ps = get_info(store);
 
+	destroy_workqueue(ps->metadata_wq);
 	dm_io_client_destroy(ps->io_client);
 	vfree(ps->callbacks);
 	free_area(ps);
@@ -588,6 +620,12 @@ int dm_create_persistent(struct exceptio
 	atomic_set(&ps->pending_count, 0);
 	ps->callbacks = NULL;
 
+	ps->metadata_wq = create_singlethread_workqueue("ksnaphd");
+	if (!ps->metadata_wq) {
+		DMERR("couldn't start header metadata update thread");
+		return -ENOMEM;
+	}
+
 	store->destroy = persistent_destroy;
 	store->read_metadata = persistent_read_metadata;
 	store->prepare_exception = persistent_prepare;
