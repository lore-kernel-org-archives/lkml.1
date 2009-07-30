Return-Path: <linux-kernel-owner+w=401wt.eu-S1751764AbZG3Mqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbZG3Mqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbZG3Mqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:46:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46427 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbZG3Mqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:46:49 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 6/7] GFS2: Fix incorrent statfs consistency check
Date: Thu, 30 Jul 2009 14:45:23 +0100
Message-Id: <1248961524-30913-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1248961524-30913-6-git-send-email-swhiteho@redhat.com>
References: <1248961524-30913-1-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-2-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-3-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-4-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-5-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-6-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

Since both linked and unlinked inodes are counted by rgd->rd_dinodes, It
makes no sense to count them with the used data blocks (first check that
I changed), it makes sense to count them with the linked inodes (second
check), and it makes no sense to care if there are more unlinked inodes
than linked ones. This fixes these errors.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/rgrp.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 5e50741..fba7957 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -285,27 +285,19 @@ void gfs2_rgrp_verify(struct gfs2_rgrpd *rgd)
 	}
 
 	tmp = rgd->rd_data - rgd->rd_free - rgd->rd_dinodes;
-	if (count[1] + count[2] != tmp) {
+	if (count[1] != tmp) {
 		if (gfs2_consist_rgrpd(rgd))
 			fs_err(sdp, "used data mismatch:  %u != %u\n",
 			       count[1], tmp);
 		return;
 	}
 
-	if (count[3] != rgd->rd_dinodes) {
+	if (count[2] + count[3] != rgd->rd_dinodes) {
 		if (gfs2_consist_rgrpd(rgd))
 			fs_err(sdp, "used metadata mismatch:  %u != %u\n",
-			       count[3], rgd->rd_dinodes);
+			       count[2] + count[3], rgd->rd_dinodes);
 		return;
 	}
-
-	if (count[2] > count[3]) {
-		if (gfs2_consist_rgrpd(rgd))
-			fs_err(sdp, "unlinked inodes > inodes:  %u\n",
-			       count[2]);
-		return;
-	}
-
 }
 
 static inline int rgrp_contains_block(struct gfs2_rgrpd *rgd, u64 block)
-- 
1.6.2.2

