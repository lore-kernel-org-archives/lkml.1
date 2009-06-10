Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbZFJJiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbZFJJiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZFJJh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:37:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40274 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbZFJJh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:37:58 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/24] GFS2: Update the rw flags
Date: Wed, 10 Jun 2009 09:30:42 +0100
Message-Id: <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After Jens recent updates:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a1f242524c3c1f5d40f1c9c343427e34d1aadd6e
et al. this is a patch to bring gfs2 uptodate with the core
code. Also I've managed to squash another call to ll_rw_block()
along the way.

There is still one part of the GFS2 I/O paths which are not correctly
annotated and that is due to the sharing of the writeback code between
the data and metadata address spaces. I would like to change that too,
but this patch is still worth doing on its own, I think.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 98918a7..aa62cf5 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -120,7 +120,7 @@ __acquires(&sdp->sd_log_lock)
 			lock_buffer(bh);
 			if (test_clear_buffer_dirty(bh)) {
 				bh->b_end_io = end_buffer_write_sync;
-				submit_bh(WRITE, bh);
+				submit_bh(WRITE_SYNC_PLUG, bh);
 			} else {
 				unlock_buffer(bh);
 				brelse(bh);
@@ -604,7 +604,7 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags, int pull)
 	if (test_bit(SDF_NOBARRIERS, &sdp->sd_flags))
 		goto skip_barrier;
 	get_bh(bh);
-	submit_bh(WRITE_BARRIER | (1 << BIO_RW_META), bh);
+	submit_bh(WRITE_SYNC | (1 << BIO_RW_BARRIER) | (1 << BIO_RW_META), bh);
 	wait_on_buffer(bh);
 	if (buffer_eopnotsupp(bh)) {
 		clear_buffer_eopnotsupp(bh);
@@ -664,7 +664,7 @@ static void gfs2_ordered_write(struct gfs2_sbd *sdp)
 		lock_buffer(bh);
 		if (buffer_mapped(bh) && test_clear_buffer_dirty(bh)) {
 			bh->b_end_io = end_buffer_write_sync;
-			submit_bh(WRITE, bh);
+			submit_bh(WRITE_SYNC_PLUG, bh);
 		} else {
 			unlock_buffer(bh);
 			brelse(bh);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 80e4f5f..00315f5 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -13,6 +13,8 @@
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
 #include <linux/gfs2_ondisk.h>
+#include <linux/bio.h>
+#include <linux/fs.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -189,7 +191,7 @@ static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 		}
 
 		gfs2_log_unlock(sdp);
-		submit_bh(WRITE, bh);
+		submit_bh(WRITE_SYNC_PLUG, bh);
 		gfs2_log_lock(sdp);
 
 		n = 0;
@@ -199,7 +201,7 @@ static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 			gfs2_log_unlock(sdp);
 			lock_buffer(bd2->bd_bh);
 			bh = gfs2_log_fake_buf(sdp, bd2->bd_bh);
-			submit_bh(WRITE, bh);
+			submit_bh(WRITE_SYNC_PLUG, bh);
 			gfs2_log_lock(sdp);
 			if (++n >= num)
 				break;
@@ -341,7 +343,7 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 		sdp->sd_log_num_revoke--;
 
 		if (offset + sizeof(u64) > sdp->sd_sb.sb_bsize) {
-			submit_bh(WRITE, bh);
+			submit_bh(WRITE_SYNC_PLUG, bh);
 
 			bh = gfs2_log_get_buf(sdp);
 			mh = (struct gfs2_meta_header *)bh->b_data;
@@ -358,7 +360,7 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 	}
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_revoke);
 
-	submit_bh(WRITE, bh);
+	submit_bh(WRITE_SYNC_PLUG, bh);
 }
 
 static void revoke_lo_before_scan(struct gfs2_jdesc *jd,
@@ -560,7 +562,7 @@ static void gfs2_write_blocks(struct gfs2_sbd *sdp, struct buffer_head *bh,
 	ptr = bh_log_ptr(bh);
 	
 	get_bh(bh);
-	submit_bh(WRITE, bh);
+	submit_bh(WRITE_SYNC_PLUG, bh);
 	gfs2_log_lock(sdp);
 	while(!list_empty(list)) {
 		bd = list_entry(list->next, struct gfs2_bufdata, bd_le.le_list);
@@ -586,7 +588,7 @@ static void gfs2_write_blocks(struct gfs2_sbd *sdp, struct buffer_head *bh,
 		} else {
 			bh1 = gfs2_log_fake_buf(sdp, bd->bd_bh);
 		}
-		submit_bh(WRITE, bh1);
+		submit_bh(WRITE_SYNC_PLUG, bh1);
 		gfs2_log_lock(sdp);
 		ptr += 2;
 	}
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 8d6f132..75b2aec 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -201,16 +201,32 @@ struct buffer_head *gfs2_meta_new(struct gfs2_glock *gl, u64 blkno)
 int gfs2_meta_read(struct gfs2_glock *gl, u64 blkno, int flags,
 		   struct buffer_head **bhp)
 {
-	*bhp = gfs2_getbuf(gl, blkno, CREATE);
-	if (!buffer_uptodate(*bhp)) {
-		ll_rw_block(READ_META, 1, bhp);
-		if (flags & DIO_WAIT) {
-			int error = gfs2_meta_wait(gl->gl_sbd, *bhp);
-			if (error) {
-				brelse(*bhp);
-				return error;
-			}
-		}
+	struct gfs2_sbd *sdp = gl->gl_sbd;
+	struct buffer_head *bh;
+
+	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+		return -EIO;
+
+	*bhp = bh = gfs2_getbuf(gl, blkno, CREATE);
+
+	lock_buffer(bh);
+	if (buffer_uptodate(bh)) {
+		unlock_buffer(bh);
+		return 0;
+	}
+	bh->b_end_io = end_buffer_read_sync;
+	get_bh(bh);
+	submit_bh(READ_SYNC | (1 << BIO_RW_META), bh);
+	if (!(flags & DIO_WAIT))
+		return 0;
+
+	wait_on_buffer(bh);
+	if (unlikely(!buffer_uptodate(bh))) {
+		struct gfs2_trans *tr = current->journal_info;
+		if (tr && tr->tr_touched)
+			gfs2_io_error_bh(sdp, bh);
+		brelse(bh);
+		return -EIO;
 	}
 
 	return 0;
@@ -404,7 +420,7 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
 	if (buffer_uptodate(first_bh))
 		goto out;
 	if (!buffer_locked(first_bh))
-		ll_rw_block(READ_META, 1, &first_bh);
+		ll_rw_block(READ_SYNC | (1 << BIO_RW_META), 1, &first_bh);
 
 	dblock++;
 	extlen--;
-- 
1.6.0.6

