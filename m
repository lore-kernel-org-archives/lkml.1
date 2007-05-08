Return-Path: <linux-kernel-owner+w=401wt.eu-S1031751AbXEHTsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031751AbXEHTsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031725AbXEHTrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:47:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031699AbXEHTrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:47:48 -0400
Date: Tue, 8 May 2007 20:46:51 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jonathan E Brassow <jbrassow@redhat.com>
Subject: [2.6.22 PATCH 12/26] dm log: report fault status
Message-ID: <20070508194651.GS24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Jonathan E Brassow <jbrassow@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan E Brassow <jbrassow@redhat.com>

This patch reports the status of the log device so that userspace
can detect the error and take appropriate action.

Signed-off-by: Jonathan E Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-log.c   |    7 ++++---
 drivers/md/dm-raid1.c |   11 +++++++----
 2 files changed, 11 insertions(+), 7 deletions(-)

Index: linux-2.6.21/drivers/md/dm-log.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-log.c	2007-05-01 17:40:51.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-log.c	2007-05-01 17:40:51.000000000 +0100
@@ -615,6 +615,7 @@ static int core_status(struct dirty_log 
 
 	switch(status) {
 	case STATUSTYPE_INFO:
+		DMEMIT("1 %s", log->type->name);
 		break;
 
 	case STATUSTYPE_TABLE:
@@ -630,17 +631,17 @@ static int disk_status(struct dirty_log 
 		       char *result, unsigned int maxlen)
 {
 	int sz = 0;
-	char buffer[16];
 	struct log_c *lc = log->context;
 
 	switch(status) {
 	case STATUSTYPE_INFO:
+		DMEMIT("3 %s %s %c", log->type->name, lc->log_dev->name,
+		       lc->log_dev_failed ? 'D' : 'A');
 		break;
 
 	case STATUSTYPE_TABLE:
-		format_dev_t(buffer, lc->log_dev->bdev->bd_dev);
 		DMEMIT("%s %u %s %u ", log->type->name,
-		       lc->sync == DEFAULTSYNC ? 2 : 3, buffer,
+		       lc->sync == DEFAULTSYNC ? 2 : 3, lc->log_dev->name,
 		       lc->region_size);
 		DMEMIT_SYNC;
 	}
Index: linux-2.6.21/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-raid1.c	2007-05-01 17:40:46.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-raid1.c	2007-05-01 17:40:51.000000000 +0100
@@ -1205,11 +1205,9 @@ static void mirror_resume(struct dm_targ
 static int mirror_status(struct dm_target *ti, status_type_t type,
 			 char *result, unsigned int maxlen)
 {
-	unsigned int m, sz;
+	unsigned int m, sz = 0;
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
 
-	sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
-
 	switch (type) {
 	case STATUSTYPE_INFO:
 		DMEMIT("%d ", ms->nr_mirrors);
@@ -1220,9 +1218,14 @@ static int mirror_status(struct dm_targe
 			(unsigned long long)ms->rh.log->type->
 				get_sync_count(ms->rh.log),
 			(unsigned long long)ms->nr_regions);
+
+		sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
+
 		break;
 
 	case STATUSTYPE_TABLE:
+		sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
+
 		DMEMIT("%d", ms->nr_mirrors);
 		for (m = 0; m < ms->nr_mirrors; m++)
 			DMEMIT(" %s %llu", ms->mirror[m].dev->name,
@@ -1234,7 +1237,7 @@ static int mirror_status(struct dm_targe
 
 static struct target_type mirror_target = {
 	.name	 = "mirror",
-	.version = {1, 0, 2},
+	.version = {1, 0, 3},
 	.module	 = THIS_MODULE,
 	.ctr	 = mirror_ctr,
 	.dtr	 = mirror_dtr,
