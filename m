Return-Path: <linux-kernel-owner+w=401wt.eu-S1031585AbXEHTsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031585AbXEHTsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031772AbXEHTse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:48:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031761AbXEHTsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:48:25 -0400
Date: Tue, 8 May 2007 20:48:16 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Milan Broz <mbroz@redhat.com>
Subject: [2.6.22 PATCH 20/26] dm raid1: update dm io interface
Message-ID: <20070508194816.GA24114@agk.fab.redhat.com>
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

This patch ports dm-raid1.c to the new dm-io interface.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-raid1.c |   25 +++++++++++++++++++++----
 1 files changed, 21 insertions(+), 4 deletions(-)

Index: linux-2.6.21/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-raid1.c	2007-05-01 17:40:51.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-raid1.c	2007-05-01 17:40:54.000000000 +0100
@@ -21,6 +21,7 @@
 #include <linux/workqueue.h>
 
 #define DM_MSG_PREFIX "raid1"
+#define DM_IO_PAGES 64
 
 #define DM_RAID1_HANDLE_ERRORS 0x01
 
@@ -126,6 +127,8 @@ struct mirror_set {
 	struct bio_list reads;
 	struct bio_list writes;
 
+	struct dm_io_client *io_client;
+
 	/* recovery */
 	region_t nr_regions;
 	int in_sync;
@@ -796,6 +799,14 @@ static void do_write(struct mirror_set *
 	unsigned int i;
 	struct io_region io[KCOPYD_MAX_REGIONS+1];
 	struct mirror *m;
+	struct dm_io_request io_req = {
+		.bi_rw = WRITE,
+		.mem.type = DM_IO_BVEC,
+		.mem.ptr.bvec = bio->bi_io_vec + bio->bi_idx,
+		.notify.fn = write_callback,
+		.notify.context = bio,
+		.client = ms->io_client,
+	};
 
 	for (i = 0; i < ms->nr_mirrors; i++) {
 		m = ms->mirror + i;
@@ -806,9 +817,8 @@ static void do_write(struct mirror_set *
 	}
 
 	bio_set_ms(bio, ms);
-	dm_io_async_bvec(ms->nr_mirrors, io, WRITE,
-			 bio->bi_io_vec + bio->bi_idx,
-			 write_callback, bio);
+
+	(void) dm_io(&io_req, ms->nr_mirrors, io, NULL);
 }
 
 static void do_writes(struct mirror_set *ms, struct bio_list *writes)
@@ -924,6 +934,13 @@ static struct mirror_set *alloc_context(
 	ms->in_sync = 0;
 	ms->default_mirror = &ms->mirror[DEFAULT_MIRROR];
 
+	ms->io_client = dm_io_client_create(DM_IO_PAGES);
+	if (IS_ERR(ms->io_client)) {
+		ti->error = "Error creating dm_io client";
+		kfree(ms);
+ 		return NULL;
+	}
+
 	if (rh_init(&ms->rh, ms, dl, region_size, ms->nr_regions)) {
 		ti->error = "Error creating dirty region hash";
 		kfree(ms);
@@ -939,6 +956,7 @@ static void free_context(struct mirror_s
 	while (m--)
 		dm_put_device(ti, ms->mirror[m].dev);
 
+	dm_io_client_destroy(ms->io_client);
 	rh_exit(&ms->rh);
 	kfree(ms);
 }
@@ -1062,7 +1080,6 @@ static int parse_features(struct mirror_
  *
  * If present, features must be "handle_errors".
  */
-#define DM_IO_PAGES 64
 static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	int r;
