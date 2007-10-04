Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbXJDJTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbXJDJTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759414AbXJDJR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759351AbXJDJR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:26 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/51] [GFS2] Revert part of earlier log.c changes
Date: Thu,  4 Oct 2007 09:49:00 +0100
Message-Id: <1191487802255-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878002186-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This is patch 2 of 5 for bug #248176.

The list_move code previously concocted in log.c for bug #238162
(see https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=238162#c23)
never runs as bh can now never be NULL at this point.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index f49a12e..f7c0608 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -83,11 +83,6 @@ static void gfs2_ail1_start_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 
 			gfs2_assert(sdp, bd->bd_ail == ai);
 
-			if (!bh){
-				list_move(&bd->bd_ail_st_list, &ai->ai_ail2_list);
-                                continue;
-                        }
-
 			if (!buffer_busy(bh)) {
 				if (!buffer_uptodate(bh)) {
 					gfs2_log_unlock(sdp);
@@ -130,11 +125,6 @@ static int gfs2_ail1_empty_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai, int fl
 					 bd_ail_st_list) {
 		bh = bd->bd_bh;
 
-		if (!bh){
-			list_move(&bd->bd_ail_st_list, &ai->ai_ail2_list);
-			continue;
-		}
-
 		gfs2_assert(sdp, bd->bd_ail == ai);
 
 		if (buffer_busy(bh)) {
@@ -155,13 +145,14 @@ static int gfs2_ail1_empty_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai, int fl
 
 static void gfs2_ail1_start(struct gfs2_sbd *sdp, int flags)
 {
-	struct list_head *head = &sdp->sd_ail1_list;
+	struct list_head *head;
 	u64 sync_gen;
 	struct list_head *first;
 	struct gfs2_ail *first_ai, *ai, *tmp;
 	int done = 0;
 
 	gfs2_log_lock(sdp);
+	head = &sdp->sd_ail1_list;
 	if (list_empty(head)) {
 		gfs2_log_unlock(sdp);
 		return;
-- 
1.5.1.2

