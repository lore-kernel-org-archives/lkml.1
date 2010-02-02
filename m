Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab0BBJ43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 04:56:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab0BBJ4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 04:56:16 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/4] GFS2: Don't withdraw on partial rindex entries
Date: Tue,  2 Feb 2010 09:47:23 +0000
Message-Id: <1265104045-15957-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1265104045-15957-2-git-send-email-swhiteho@redhat.com>
References: <1265104045-15957-1-git-send-email-swhiteho@redhat.com>
 <1265104045-15957-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

ince gfs2 writes the rindex file a block at a time, and releases the
exclusive lock after each block, it is possible that another process
will grab the lock in the middle of the write.  Since rindex entries are
not an even divisor of blocks, that other process may see partial
entries.  On grows, this is fine.  The process can simply ignore the the
partial entires. Previously, the code withdrew when it saw partial
entries. Now it simply ignores them.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/rgrp.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 0608f49..6702b82 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -591,11 +591,6 @@ static int gfs2_ri_update(struct gfs2_inode *ip)
 	u64 rgrp_count = ip->i_disksize;
 	int error;
 
-	if (do_div(rgrp_count, sizeof(struct gfs2_rindex))) {
-		gfs2_consist_inode(ip);
-		return -EIO;
-	}
-
 	clear_rgrpdi(sdp);
 
 	file_ra_state_init(&ra_state, inode->i_mapping);
-- 
1.6.2.5

