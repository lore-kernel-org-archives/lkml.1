Return-Path: <linux-kernel-owner+w=401wt.eu-S1031808AbXEHTt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031808AbXEHTt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031779AbXEHTs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:48:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031224AbXEHTsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:48:47 -0400
Date: Tue, 8 May 2007 20:47:44 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Milan Broz <mbroz@redhat.com>
Subject: [2.6.22 PATCH 17/26] dm kcopyd: update dm io interface
Message-ID: <20070508194744.GX24114@agk.fab.redhat.com>
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

This patch ports kcopyd.c to the new, scalable dm_io() interface.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/kcopyd.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

Index: linux-2.6.21/drivers/md/kcopyd.c
===================================================================
--- linux-2.6.21.orig/drivers/md/kcopyd.c	2007-05-01 17:38:32.000000000 +0100
+++ linux-2.6.21/drivers/md/kcopyd.c	2007-05-01 17:40:53.000000000 +0100
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2002 Sistina Software (UK) Limited.
+ * Copyright (C) 2006 Red Hat GmbH
  *
  * This file is released under the GPL.
  *
@@ -45,6 +46,8 @@ struct kcopyd_client {
 	unsigned int nr_pages;
 	unsigned int nr_free_pages;
 
+	struct dm_io_client *io_client;
+
 	wait_queue_head_t destroyq;
 	atomic_t nr_jobs;
 };
@@ -342,16 +345,20 @@ static void complete_io(unsigned long er
 static int run_io_job(struct kcopyd_job *job)
 {
 	int r;
+	struct dm_io_request io_req = {
+		.bi_rw = job->rw,
+		.mem.type = DM_IO_PAGE_LIST,
+		.mem.ptr.pl = job->pages,
+		.mem.offset = job->offset,
+		.notify.fn = complete_io,
+		.notify.context = job,
+		.client = job->kc->io_client,
+	};
 
 	if (job->rw == READ)
-		r = dm_io_async(1, &job->source, job->rw,
-				job->pages,
-				job->offset, complete_io, job);
-
+		r = dm_io(&io_req, 1, &job->source, NULL);
 	else
-		r = dm_io_async(job->num_dests, job->dests, job->rw,
-				job->pages,
-				job->offset, complete_io, job);
+		r = dm_io(&io_req, job->num_dests, job->dests, NULL);
 
 	return r;
 }
@@ -670,8 +677,9 @@ int kcopyd_client_create(unsigned int nr
 		return r;
 	}
 
-	r = dm_io_get(nr_pages);
-	if (r) {
+	kc->io_client = dm_io_client_create(nr_pages);
+	if (IS_ERR(kc->io_client)) {
+		r = PTR_ERR(kc->io_client);
 		client_free_pages(kc);
 		kfree(kc);
 		kcopyd_exit();
@@ -691,7 +699,7 @@ void kcopyd_client_destroy(struct kcopyd
 	/* Wait for completion of all jobs submitted by this client. */
 	wait_event(kc->destroyq, !atomic_read(&kc->nr_jobs));
 
-	dm_io_put(kc->nr_pages);
+	dm_io_client_destroy(kc->io_client);
 	client_free_pages(kc);
 	client_del(kc);
 	kfree(kc);
