Return-Path: <linux-kernel-owner+w=401wt.eu-S932895AbXJLRIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbXJLRIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932705AbXJLRHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:07:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761039AbXJLRHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:07:13 -0400
Date: Fri, 12 Oct 2007 18:07:08 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [2.6.24 PATCH 05/25] dm raid1: fix leakage
Message-ID: <20071012170708.GP24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Monakhov <dmonakhov@openvz.org>

Add missing 'dm_io_client_destroy' to alloc_context error path.
Reorganize mirror constructor error path in order to prevent
workqueue leakage.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-raid1.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

Index: linux-2.6.23/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-raid1.c	2007-10-12 13:15:18.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-raid1.c	2007-10-12 13:15:32.000000000 +0100
@@ -974,6 +974,7 @@ static struct mirror_set *alloc_context(
 
 	if (rh_init(&ms->rh, ms, dl, region_size, ms->nr_regions)) {
 		ti->error = "Error creating dirty region hash";
+		dm_io_client_destroy(ms->io_client);
 		kfree(ms);
 		return NULL;
 	}
@@ -1163,16 +1164,14 @@ static int mirror_ctr(struct dm_target *
 	ms->kmirrord_wq = create_singlethread_workqueue("kmirrord");
 	if (!ms->kmirrord_wq) {
 		DMERR("couldn't start kmirrord");
-		free_context(ms, ti, m);
-		return -ENOMEM;
+		r = -ENOMEM;
+		goto err_free_context;
 	}
 	INIT_WORK(&ms->kmirrord_work, do_mirror);
 
 	r = parse_features(ms, argc, argv, &args_used);
-	if (r) {
-		free_context(ms, ti, ms->nr_mirrors);
-		return r;
-	}
+	if (r)
+		goto err_destroy_wq;
 
 	argv += args_used;
 	argc -= args_used;
@@ -1188,19 +1187,22 @@ static int mirror_ctr(struct dm_target *
 
 	if (argc) {
 		ti->error = "Too many mirror arguments";
-		free_context(ms, ti, ms->nr_mirrors);
-		return -EINVAL;
+		r = -EINVAL;
+		goto err_destroy_wq;
 	}
 
 	r = kcopyd_client_create(DM_IO_PAGES, &ms->kcopyd_client);
-	if (r) {
-		destroy_workqueue(ms->kmirrord_wq);
-		free_context(ms, ti, ms->nr_mirrors);
-		return r;
-	}
+	if (r)
+		goto err_destroy_wq;
 
 	wake(ms);
 	return 0;
+
+err_destroy_wq:
+	destroy_workqueue(ms->kmirrord_wq);
+err_free_context:
+	free_context(ms, ti, ms->nr_mirrors);
+	return r;
 }
 
 static void mirror_dtr(struct dm_target *ti)
