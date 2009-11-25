Return-Path: <linux-kernel-owner+w=401wt.eu-S934756AbZKYNgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934756AbZKYNgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934714AbZKYNg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:36:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964834AbZKYNg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:36:27 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 29/30] GFS2: drop rindex glock to refresh rindex list
Date: Wed, 25 Nov 2009 14:31:01 +0000
Message-Id: <1259159462-28622-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259159462-28622-8-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-20-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-1-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-2-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-3-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-4-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-5-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-6-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-7-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-8-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

When a gfs2 filesystem is grown, it needs to rebuild the rindex list to be able
to use the new space.  gfs2 does this when the rindex is marked not uptodate,
which happens when the rindex glock is dropped.  However, on a single node
setup, there is never any reason to drop the rindex glock, so gfs2 never
invalidates the the rindex. This patch makes gfs2 automatically drop the
rindex glock after filesystem grows, so it can refresh the rindex list.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/aops.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 694b5d4..dce062a 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -819,8 +819,10 @@ static int gfs2_stuffed_write_end(struct inode *inode, struct buffer_head *dibh,
 		mark_inode_dirty(inode);
 	}
 
-	if (inode == sdp->sd_rindex)
+	if (inode == sdp->sd_rindex) {
 		adjust_fs_space(inode);
+		ip->i_gh.gh_flags |= GL_NOCACHE;
+	}
 
 	brelse(dibh);
 	gfs2_trans_end(sdp);
@@ -889,8 +891,10 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 		mark_inode_dirty(inode);
 	}
 
-	if (inode == sdp->sd_rindex)
+	if (inode == sdp->sd_rindex) {
 		adjust_fs_space(inode);
+		ip->i_gh.gh_flags |= GL_NOCACHE;
+	}
 
 	brelse(dibh);
 	gfs2_trans_end(sdp);
-- 
1.6.2.5

