Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbXGIQZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbXGIQZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbXGIQXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756968AbXGIQXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:18 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Robert Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Addendum patch 2 for gfs2_grow
Date: Mon,  9 Jul 2007 17:02:12 +0100
Message-Id: <11839970032102-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970003764-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Peterson <rpeterso@redhat.com>

This addendum patch 2 corrects three things:

1. It fixes a stupid mistake in the previous addendum that broke gfs2.
   Ref: https://www.redhat.com/archives/cluster-devel/2007-May/msg00162.html
2. It fixes a problem that Dave Teigland pointed out regarding the
   external declarations in ops_address.h being in the wrong place.
3. It recasts a couple more %llu printks to (unsigned long long)
   as requested by Steve Whitehouse.

I would have loved to put this all in one revised patch, but there was
a rush to get some patches for RHEL5.	Therefore, the previous patches
were applied to the git tree "as is" and therefore, I'm posting another
addendum.  Sorry.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 1815429..c66c718 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1823,7 +1823,8 @@ static int dump_inode(struct glock_iter *gi, struct gfs2_inode *ip)
 
 	print_dbg(gi, "  Inode:\n");
 	print_dbg(gi, "    num = %llu/%llu\n",
-		    ip->i_num.no_formal_ino, ip->i_num.no_addr);
+		  (unsigned long long)ip->i_num.no_formal_ino,
+		  (unsigned long long)ip->i_num.no_addr);
 	print_dbg(gi, "    type = %u\n", IF2DT(ip->i_inode.i_mode));
 	print_dbg(gi, "    i_flags =");
 	for (x = 0; x < 32; x++)
@@ -1909,8 +1910,8 @@ static int dump_glock(struct glock_iter *gi, struct gfs2_glock *gl)
 	}
 	if (test_bit(GLF_DEMOTE, &gl->gl_flags)) {
 		print_dbg(gi, "  Demotion req to state %u (%llu uS ago)\n",
-			  gl->gl_demote_state,
-			  (u64)(jiffies - gl->gl_demote_time)*(1000000/HZ));
+			  gl->gl_demote_state, (unsigned long long)
+			  (jiffies - gl->gl_demote_time)*(1000000/HZ));
 	}
 	if (gl->gl_ops == &gfs2_inode_glops && gl->gl_object) {
 		if (!test_bit(GLF_LOCK, &gl->gl_flags) &&
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index e0b4e8c..4913ef5 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -32,6 +32,7 @@
 #include "trans.h"
 #include "rgrp.h"
 #include "ops_file.h"
+#include "super.h"
 #include "util.h"
 #include "glops.h"
 
diff --git a/fs/gfs2/ops_address.h b/fs/gfs2/ops_address.h
index 56c30da..fa1b5b3 100644
--- a/fs/gfs2/ops_address.h
+++ b/fs/gfs2/ops_address.h
@@ -18,8 +18,5 @@ extern const struct address_space_operations gfs2_file_aops;
 extern int gfs2_get_block(struct inode *inode, sector_t lblock,
 			  struct buffer_head *bh_result, int create);
 extern int gfs2_releasepage(struct page *page, gfp_t gfp_mask);
-extern u64 gfs2_ri_total(struct gfs2_sbd *sdp);
-extern void gfs2_statfs_change(struct gfs2_sbd *sdp, s64 total, s64 free,
-			       s64 dinodes);
 
 #endif /* __OPS_ADDRESS_DOT_H__ */
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 48a6461..a62c0f2 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -527,10 +527,10 @@ static int gfs2_ri_update(struct gfs2_inode *ip)
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct inode *inode = &ip->i_inode;
 	struct file_ra_state ra_state;
-	u64 junk = ip->i_di.di_size;
+	u64 rgrp_count = ip->i_di.di_size;
 	int error;
 
-	if (do_div(junk, sizeof(struct gfs2_rindex))) {
+	if (do_div(rgrp_count, sizeof(struct gfs2_rindex))) {
 		gfs2_consist_inode(ip);
 		return -EIO;
 	}
@@ -538,7 +538,7 @@ static int gfs2_ri_update(struct gfs2_inode *ip)
 	clear_rgrpdi(sdp);
 
 	file_ra_state_init(&ra_state, inode->i_mapping);
-	for (sdp->sd_rgrps = 0;; sdp->sd_rgrps++) {
+	for (sdp->sd_rgrps = 0; sdp->sd_rgrps < rgrp_count; sdp->sd_rgrps++) {
 		error = read_rindex_entry(ip, &ra_state);
 		if (error) {
 			clear_rgrpdi(sdp);
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index b01e0cf..b4c6adf 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -65,5 +65,6 @@ void gfs2_rlist_add(struct gfs2_sbd *sdp, struct gfs2_rgrp_list *rlist,
 void gfs2_rlist_alloc(struct gfs2_rgrp_list *rlist, unsigned int state,
 		      int flags);
 void gfs2_rlist_free(struct gfs2_rgrp_list *rlist);
+u64 gfs2_ri_total(struct gfs2_sbd *sdp);
 
 #endif /* __RGRP_DOT_H__ */
-- 
1.5.1.2

