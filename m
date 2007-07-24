Return-Path: <linux-kernel-owner+w=401wt.eu-S935078AbXGXI44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935078AbXGXI44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933261AbXGXI4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:56:44 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:43209 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932439AbXGXI4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:56:43 -0400
Date: Tue, 24 Jul 2007 12:57:11 +0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>
Subject: [PATCH 3/8] dm: dm-raid1 resource leaks fixes.
Message-ID: <20070724085711.GC16507@dnb.sw.ru>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	device-mapper development <dm-devel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724085106.GD20538@dnb.sw.ru>
Organization: SWsoft
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- Add missing 'dm_io_client_destroy' to alloc_context error path.
- Reorganize mirror constructor error path in order to prevent
  workqueue leakage.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/md/dm-raid1.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 144071e..58b9f1a 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -974,6 +974,7 @@ static struct mirror_set *alloc_context(unsigned int nr_mirrors,
 
 	if (rh_init(&ms->rh, ms, dl, region_size, ms->nr_regions)) {
 		ti->error = "Error creating dirty region hash";
+		dm_io_client_destroy(ms->io_client);
 		kfree(ms);
 		return NULL;
 	}
@@ -1163,16 +1164,14 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ms->kmirrord_wq = create_singlethread_workqueue("kmirrord");
 	if (!ms->kmirrord_wq) {
 		DMERR("couldn't start kmirrord");
-		free_context(ms, ti, m);
-		return -ENOMEM;
+		r = -ENOMEM;
+		goto out_free_context;
 	}
 	INIT_WORK(&ms->kmirrord_work, do_mirror);
 
 	r = parse_features(ms, argc, argv, &args_used);
-	if (r) {
-		free_context(ms, ti, ms->nr_mirrors);
-		return r;
-	}
+	if (r)
+		goto out_destroy_wq;
 
 	argv += args_used;
 	argc -= args_used;
@@ -1188,19 +1187,22 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	if (argc) {
 		ti->error = "Too many mirror arguments";
-		free_context(ms, ti, ms->nr_mirrors);
-		return -EINVAL;
+		r = -EINVAL;
+		goto out_destroy_wq;
 	}
 
 	r = kcopyd_client_create(DM_IO_PAGES, &ms->kcopyd_client);
-	if (r) {
-		destroy_workqueue(ms->kmirrord_wq);
-		free_context(ms, ti, ms->nr_mirrors);
-		return r;
-	}
+	if (r)
+		goto out_destroy_wq;
 
 	wake(ms);
 	return 0;
+
+out_destroy_wq:
+	destroy_workqueue(ms->kmirrord_wq);
+out_free_context:
+	free_context(ms, ti, ms->nr_mirrors);
+	return r;
 }
 
 static void mirror_dtr(struct dm_target *ti)
-- 
1.5.2.2


