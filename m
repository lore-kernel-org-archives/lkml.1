Return-Path: <linux-kernel-owner+w=401wt.eu-S1759187AbZFJJja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbZFJJja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757610AbZFJJiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40276 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600AbZFJJiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:01 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/24] GFS2: Move journal live test at transaction start
Date: Wed, 10 Jun 2009 09:30:46 +0100
Message-Id: <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There seems little point grabbing the transaction glock
only to have to release it again if the journal isn't
live. This moves the test earlier to avoid grabbing the lock
when we don't need it in the first place.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 053752d..4ef0e9f 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -33,6 +33,9 @@ int gfs2_trans_begin(struct gfs2_sbd *sdp, unsigned int blocks,
 	BUG_ON(current->journal_info);
 	BUG_ON(blocks == 0 && revokes == 0);
 
+	if (!test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags))
+		return -EROFS;
+
 	tr = kzalloc(sizeof(struct gfs2_trans), GFP_NOFS);
 	if (!tr)
 		return -ENOMEM;
@@ -54,12 +57,6 @@ int gfs2_trans_begin(struct gfs2_sbd *sdp, unsigned int blocks,
 	if (error)
 		goto fail_holder_uninit;
 
-	if (!test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags)) {
-		tr->tr_t_gh.gh_flags |= GL_NOCACHE;
-		error = -EROFS;
-		goto fail_gunlock;
-	}
-
 	error = gfs2_log_reserve(sdp, tr->tr_reserved);
 	if (error)
 		goto fail_gunlock;
-- 
1.6.0.6

