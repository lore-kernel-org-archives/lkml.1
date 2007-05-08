Return-Path: <linux-kernel-owner+w=401wt.eu-S1031819AbXEHTti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031819AbXEHTti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031803AbXEHTtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:49:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031801AbXEHTtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:49:06 -0400
Date: Tue, 8 May 2007 20:48:07 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Heinz Mauelshagen <heinzm@redhat.com>, Milan Broz <mbroz@redhat.com>
Subject: [2.6.22 PATCH 19/26] dm log: update dm io interface
Message-ID: <20070508194807.GZ24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Milan Broz <mbroz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

This patch ports dm-log.c to the new dm-io interface in order to make
it scalable to have a large number of persistent dirty logs active in
parallel.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-log.c |   31 ++++++++++++++++++++++++-------
 1 files changed, 24 insertions(+), 7 deletions(-)

Index: linux-2.6.21/drivers/md/dm-log.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-log.c	2007-05-01 17:40:51.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-log.c	2007-05-01 17:40:54.000000000 +0100
@@ -149,6 +149,8 @@ struct log_c {
 		FORCESYNC,	/* Force a sync to happen */
 	} sync;
 
+	struct dm_io_request io_req;
+
 	/*
 	 * Disk log fields
 	 */
@@ -200,13 +202,20 @@ static void header_from_disk(struct log_
 	core->nr_regions = le64_to_cpu(disk->nr_regions);
 }
 
+static int rw_header(struct log_c *lc, int rw)
+{
+	lc->io_req.bi_rw = rw;
+	lc->io_req.mem.ptr.vma = lc->disk_header;
+	lc->io_req.notify.fn = NULL;
+
+	return dm_io(&lc->io_req, 1, &lc->header_location, NULL);
+}
+
 static int read_header(struct log_c *log)
 {
 	int r;
-	unsigned long ebits;
 
-	r = dm_io_sync_vm(1, &log->header_location, READ,
-			  log->disk_header, &ebits);
+	r = rw_header(log, READ);
 	if (r)
 		return r;
 
@@ -234,11 +243,8 @@ static int read_header(struct log_c *log
 
 static inline int write_header(struct log_c *log)
 {
-	unsigned long ebits;
-
 	header_to_disk(&log->header, log->disk_header);
-	return dm_io_sync_vm(1, &log->header_location, WRITE,
-			     log->disk_header, &ebits);
+	return rw_header(log, WRITE);
 }
 
 /*----------------------------------------------------------------
@@ -257,6 +263,7 @@ static int create_log_context(struct dir
 	uint32_t region_size;
 	unsigned int region_count;
 	size_t bitset_size, buf_size;
+	int r;
 
 	if (argc < 1 || argc > 2) {
 		DMWARN("wrong number of arguments to mirror log");
@@ -326,6 +333,15 @@ static int create_log_context(struct dir
 		buf_size = dm_round_up((LOG_OFFSET << SECTOR_SHIFT) +
 				       bitset_size, ti->limits.hardsect_size);
 		lc->header_location.count = buf_size >> SECTOR_SHIFT;
+		lc->io_req.mem.type = DM_IO_VMA;
+		lc->io_req.client = dm_io_client_create(dm_div_up(buf_size,
+								   PAGE_SIZE));
+		if (IS_ERR(lc->io_req.client)) {
+			r = PTR_ERR(lc->io_req.client);
+			DMWARN("couldn't allocate disk io client");
+			kfree(lc);
+			return -ENOMEM;
+		}
 
 		lc->disk_header = vmalloc(buf_size);
 		if (!lc->disk_header) {
@@ -426,6 +442,7 @@ static void disk_dtr(struct dirty_log *l
 
 	dm_put_device(lc->ti, lc->log_dev);
 	vfree(lc->disk_header);
+	dm_io_client_destroy(lc->io_req.client);
 	destroy_log_context(lc);
 }
 
