Return-Path: <linux-kernel-owner+w=401wt.eu-S1761996AbXJDJen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761996AbXJDJen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759703AbXJDJSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759624AbXJDJSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:36 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 45/51] [GFS2] Clean up journaled data writing
Date: Thu,  4 Oct 2007 09:49:38 +0100
Message-Id: <1191487872941-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1191487870444-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
 <11914878141625-git-send-email-swhiteho@redhat.com>
 <1191487815172-git-send-email-swhiteho@redhat.com>
 <11914878173677-git-send-email-swhiteho@redhat.com>
 <11914878191964-git-send-email-swhiteho@redhat.com>
 <11914878214113-git-send-email-swhiteho@redhat.com>
 <11914878231394-git-send-email-swhiteho@redhat.com>
 <11914878252873-git-send-email-swhiteho@redhat.com>
 <11914878271468-git-send-email-swhiteho@redhat.com>
 <11914878283252-git-send-email-swhiteho@redhat.com>
 <11914878304004-git-send-email-swhiteho@redhat.com>
 <11914878323899-git-send-email-swhiteho@redhat.com>
 <11914878342921-git-send-email-swhiteho@redhat.com>
 <11914878361239-git-send-email-swhiteho@redhat.com>
 <11914878383633-git-send-email-swhiteho@redhat.com>
 <11914878401428-git-send-email-swhiteho@redhat.com>
 <11914878422398-git-send-email-swhiteho@redhat.com>
 <1191487844772-git-send-email-swhiteho@redhat.com>
 <1191487846406-git-send-email-swhiteho@redhat.com>
 <11914878472056-git-send-email-swhiteho@redhat.com>
 <11914878492645-git-send-email-swhiteho@redhat.com>
 <11914878513555-git-send-email-swhiteho@redhat.com>
 <11914878521254-git-send-email-swhiteho@redhat.com>
 <119148785427-git-send-email-swhiteho@redhat.com>
 <11914878551328-git-send-email-swhiteho@redhat.com>
 <11914878571888-git-send-email-swhiteho@redhat.com>
 <11914878592314-git-send-email-swhiteho@redhat.com>
 <1191487861683-git-send-email-swhiteho@redhat.com>
 <11914878632211-git-send-email-swhiteho@redhat.com>
 <1191487864951-git-send-email-swhiteho@redhat.com>
 <11914878661743-git-send-email-swhiteho@redhat.com>
 <11914878683674-git-send-email-swhiteho@redhat.com>
 <1191487870444-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch cleans up the code for writing journaled data into the log.
It also removes the need to allocate a small "tag" structure for each
block written into the log. Instead we just keep count of the outstanding
I/O so that we can be sure that its all been written at the correct time.
Another result of this patch is that a number of ll_rw_block() calls
have become submit_bh() calls, closing some races at the same time.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 8aa5780..eaddfb5 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -341,12 +341,6 @@ struct gfs2_quota_data {
 	unsigned long qd_last_touched;
 };
 
-struct gfs2_log_buf {
-	struct list_head lb_list;
-	struct buffer_head *lb_bh;
-	struct buffer_head *lb_real;
-};
-
 struct gfs2_trans {
 	unsigned long tr_ip;
 
@@ -631,7 +625,8 @@ struct gfs2_sbd {
 
 	unsigned long sd_log_flush_time;
 	struct rw_semaphore sd_log_flush_lock;
-	struct list_head sd_log_flush_list;
+	atomic_t sd_log_in_flight;
+	wait_queue_head_t sd_log_flush_wait;
 
 	unsigned int sd_log_flush_head;
 	u64 sd_log_flush_wrapped;
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 4d04e6f..ee70467 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -104,11 +104,8 @@ static void gfs2_ail1_start_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 			gfs2_assert(sdp, bd->bd_ail == ai);
 
 			if (!buffer_busy(bh)) {
-				if (!buffer_uptodate(bh)) {
-					gfs2_log_unlock(sdp);
+				if (!buffer_uptodate(bh))
 					gfs2_io_error_bh(sdp, bh);
-					gfs2_log_lock(sdp);
-				}
 				list_move(&bd->bd_ail_st_list, &ai->ai_ail2_list);
 				continue;
 			}
@@ -118,9 +115,16 @@ static void gfs2_ail1_start_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 
 			list_move(&bd->bd_ail_st_list, &ai->ai_ail1_list);
 
+			get_bh(bh);
 			gfs2_log_unlock(sdp);
-			wait_on_buffer(bh);
-			ll_rw_block(WRITE, 1, &bh);
+			lock_buffer(bh);
+			if (test_clear_buffer_dirty(bh)) {
+				bh->b_end_io = end_buffer_write_sync;
+				submit_bh(WRITE, bh);
+			} else {
+				unlock_buffer(bh);
+				brelse(bh);
+			}
 			gfs2_log_lock(sdp);
 
 			retry = 1;
@@ -446,10 +450,10 @@ static unsigned int current_tail(struct gfs2_sbd *sdp)
 	return tail;
 }
 
-static inline void log_incr_head(struct gfs2_sbd *sdp)
+void gfs2_log_incr_head(struct gfs2_sbd *sdp)
 {
 	if (sdp->sd_log_flush_head == sdp->sd_log_tail)
-		gfs2_assert_withdraw(sdp, sdp->sd_log_flush_head == sdp->sd_log_head);
+		BUG_ON(sdp->sd_log_flush_head != sdp->sd_log_head);
 
 	if (++sdp->sd_log_flush_head == sdp->sd_jdesc->jd_blocks) {
 		sdp->sd_log_flush_head = 0;
@@ -458,6 +462,23 @@ static inline void log_incr_head(struct gfs2_sbd *sdp)
 }
 
 /**
+ * gfs2_log_write_endio - End of I/O for a log buffer
+ * @bh: The buffer head
+ * @uptodate: I/O Status
+ *
+ */
+
+static void gfs2_log_write_endio(struct buffer_head *bh, int uptodate)
+{
+	struct gfs2_sbd *sdp = bh->b_private;
+	bh->b_private = NULL;
+
+	end_buffer_write_sync(bh, uptodate);
+	if (atomic_dec_and_test(&sdp->sd_log_in_flight))
+		wake_up(&sdp->sd_log_flush_wait);
+}
+
+/**
  * gfs2_log_get_buf - Get and initialize a buffer to use for log control data
  * @sdp: The GFS2 superblock
  *
@@ -467,25 +488,42 @@ static inline void log_incr_head(struct gfs2_sbd *sdp)
 struct buffer_head *gfs2_log_get_buf(struct gfs2_sbd *sdp)
 {
 	u64 blkno = log_bmap(sdp, sdp->sd_log_flush_head);
-	struct gfs2_log_buf *lb;
 	struct buffer_head *bh;
 
-	lb = kzalloc(sizeof(struct gfs2_log_buf), GFP_NOFS | __GFP_NOFAIL);
-	list_add(&lb->lb_list, &sdp->sd_log_flush_list);
-
-	bh = lb->lb_bh = sb_getblk(sdp->sd_vfs, blkno);
+	bh = sb_getblk(sdp->sd_vfs, blkno);
 	lock_buffer(bh);
 	memset(bh->b_data, 0, bh->b_size);
 	set_buffer_uptodate(bh);
 	clear_buffer_dirty(bh);
-	unlock_buffer(bh);
-
-	log_incr_head(sdp);
+	gfs2_log_incr_head(sdp);
+	atomic_inc(&sdp->sd_log_in_flight);
+	bh->b_private = sdp;
+	bh->b_end_io = gfs2_log_write_endio;
 
 	return bh;
 }
 
 /**
+ * gfs2_fake_write_endio - 
+ * @bh: The buffer head
+ * @uptodate: The I/O Status
+ *
+ */
+
+static void gfs2_fake_write_endio(struct buffer_head *bh, int uptodate)
+{
+	struct buffer_head *real_bh = bh->b_private;
+	struct gfs2_sbd *sdp = GFS2_SB(real_bh->b_page->mapping->host);
+
+	end_buffer_write_sync(bh, uptodate);
+	free_buffer_head(bh);
+	unlock_buffer(real_bh);
+	brelse(real_bh);
+	if (atomic_dec_and_test(&sdp->sd_log_in_flight))
+		wake_up(&sdp->sd_log_flush_wait);
+}
+
+/**
  * gfs2_log_fake_buf - Build a fake buffer head to write metadata buffer to log
  * @sdp: the filesystem
  * @data: the data the buffer_head should point to
@@ -497,22 +535,20 @@ struct buffer_head *gfs2_log_fake_buf(struct gfs2_sbd *sdp,
 				      struct buffer_head *real)
 {
 	u64 blkno = log_bmap(sdp, sdp->sd_log_flush_head);
-	struct gfs2_log_buf *lb;
 	struct buffer_head *bh;
 
-	lb = kzalloc(sizeof(struct gfs2_log_buf), GFP_NOFS | __GFP_NOFAIL);
-	list_add(&lb->lb_list, &sdp->sd_log_flush_list);
-	lb->lb_real = real;
-
-	bh = lb->lb_bh = alloc_buffer_head(GFP_NOFS | __GFP_NOFAIL);
+	bh = alloc_buffer_head(GFP_NOFS | __GFP_NOFAIL);
 	atomic_set(&bh->b_count, 1);
-	bh->b_state = (1 << BH_Mapped) | (1 << BH_Uptodate);
+	bh->b_state = (1 << BH_Mapped) | (1 << BH_Uptodate) | (1 << BH_Lock);
 	set_bh_page(bh, real->b_page, bh_offset(real));
 	bh->b_blocknr = blkno;
 	bh->b_size = sdp->sd_sb.sb_bsize;
 	bh->b_bdev = sdp->sd_vfs->s_bdev;
+	bh->b_private = real;
+	bh->b_end_io = gfs2_fake_write_endio;
 
-	log_incr_head(sdp);
+	gfs2_log_incr_head(sdp);
+	atomic_inc(&sdp->sd_log_in_flight);
 
 	return bh;
 }
@@ -579,45 +615,24 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags, int pull)
 		gfs2_assert_withdraw(sdp, !pull);
 
 	sdp->sd_log_idle = (tail == sdp->sd_log_flush_head);
-	log_incr_head(sdp);
+	gfs2_log_incr_head(sdp);
 }
 
 static void log_flush_commit(struct gfs2_sbd *sdp)
 {
-	struct list_head *head = &sdp->sd_log_flush_list;
-	struct gfs2_log_buf *lb;
-	struct buffer_head *bh;
-	int flushcount = 0;
-
-	while (!list_empty(head)) {
-		lb = list_entry(head->next, struct gfs2_log_buf, lb_list);
-		list_del(&lb->lb_list);
-		bh = lb->lb_bh;
-
-		wait_on_buffer(bh);
-		if (!buffer_uptodate(bh))
-			gfs2_io_error_bh(sdp, bh);
-		if (lb->lb_real) {
-			while (atomic_read(&bh->b_count) != 1)  /* Grrrr... */
-				schedule();
-			free_buffer_head(bh);
-		} else
-			brelse(bh);
-		kfree(lb);
-		flushcount++;
+	DEFINE_WAIT(wait);
+
+	if (atomic_read(&sdp->sd_log_in_flight)) {
+		do {
+			prepare_to_wait(&sdp->sd_log_flush_wait, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (atomic_read(&sdp->sd_log_in_flight))
+				io_schedule();
+		} while(atomic_read(&sdp->sd_log_in_flight));
+		finish_wait(&sdp->sd_log_flush_wait, &wait);
 	}
 
-	/* If nothing was journaled, the header is unplanned and unwanted. */
-	if (flushcount) {
-		log_write_header(sdp, 0, 0);
-	} else {
-		unsigned int tail;
-		tail = current_tail(sdp);
-
-		gfs2_ail1_empty(sdp, 0);
-		if (sdp->sd_log_tail != tail)
-			log_pull_tail(sdp, tail);
-	}
+	log_write_header(sdp, 0, 0);
 }
 
 static void gfs2_ordered_write(struct gfs2_sbd *sdp)
@@ -698,10 +713,16 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	INIT_LIST_HEAD(&ai->ai_ail1_list);
 	INIT_LIST_HEAD(&ai->ai_ail2_list);
 
-	gfs2_assert_withdraw(sdp,
-			     sdp->sd_log_num_buf + sdp->sd_log_num_databuf ==
-			     sdp->sd_log_commited_buf +
-			     sdp->sd_log_commited_databuf);
+	if (sdp->sd_log_num_buf != sdp->sd_log_commited_buf) {
+		printk(KERN_INFO "GFS2: log buf %u %u\n", sdp->sd_log_num_buf,
+		       sdp->sd_log_commited_buf);
+		gfs2_assert_withdraw(sdp, 0);
+	}
+	if (sdp->sd_log_num_databuf != sdp->sd_log_commited_databuf) {
+		printk(KERN_INFO "GFS2: log databuf %u %u\n",
+		       sdp->sd_log_num_databuf, sdp->sd_log_commited_databuf);
+		gfs2_assert_withdraw(sdp, 0);
+	}
 	gfs2_assert_withdraw(sdp,
 			sdp->sd_log_num_revoke == sdp->sd_log_commited_revoke);
 
@@ -713,7 +734,7 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	lops_before_commit(sdp);
 	gfs2_ordered_wait(sdp);
 
-	if (!list_empty(&sdp->sd_log_flush_list))
+	if (sdp->sd_log_head != sdp->sd_log_flush_head)
 		log_flush_commit(sdp);
 	else if (sdp->sd_log_tail != current_tail(sdp) && !sdp->sd_log_idle){
 		gfs2_log_lock(sdp);
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index 6394235..dae2824 100644
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -52,6 +52,7 @@ int gfs2_ail1_empty(struct gfs2_sbd *sdp, int flags);
 
 int gfs2_log_reserve(struct gfs2_sbd *sdp, unsigned int blks);
 void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks);
+void gfs2_log_incr_head(struct gfs2_sbd *sdp);
 
 struct buffer_head *gfs2_log_get_buf(struct gfs2_sbd *sdp);
 struct buffer_head *gfs2_log_fake_buf(struct gfs2_sbd *sdp,
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 342c10e..6c27cea 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -91,6 +91,39 @@ static void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
 	unlock_buffer(bh);
 }
 
+
+static inline struct gfs2_log_descriptor *bh_log_desc(struct buffer_head *bh)
+{
+	return (struct gfs2_log_descriptor *)bh->b_data;
+}
+
+static inline __be64 *bh_log_ptr(struct buffer_head *bh)
+{
+	struct gfs2_log_descriptor *ld = bh_log_desc(bh);
+	return (__force __be64 *)(ld + 1);
+}
+
+static inline __be64 *bh_ptr_end(struct buffer_head *bh)
+{
+	return (__force __be64 *)(bh->b_data + bh->b_size);
+}
+
+
+static struct buffer_head *gfs2_get_log_desc(struct gfs2_sbd *sdp, u32 ld_type)
+{
+	struct buffer_head *bh = gfs2_log_get_buf(sdp);
+	struct gfs2_log_descriptor *ld = bh_log_desc(bh);
+	ld->ld_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
+	ld->ld_header.mh_type = cpu_to_be32(GFS2_METATYPE_LD);
+	ld->ld_header.mh_format = cpu_to_be32(GFS2_FORMAT_LD);
+	ld->ld_type = cpu_to_be32(ld_type);
+	ld->ld_length = 0;
+	ld->ld_data1 = 0;
+	ld->ld_data2 = 0;
+	memset(ld->ld_reserved, 0, sizeof(ld->ld_reserved));
+	return bh;
+}
+
 static void __glock_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 {
 	struct gfs2_glock *gl;
@@ -181,7 +214,6 @@ static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 	struct gfs2_log_descriptor *ld;
 	struct gfs2_bufdata *bd1 = NULL, *bd2;
 	unsigned int total;
-	unsigned int offset = BUF_OFFSET;
 	unsigned int limit;
 	unsigned int num;
 	unsigned n;
@@ -198,18 +230,12 @@ static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 		if (total > limit)
 			num = limit;
 		gfs2_log_unlock(sdp);
-		bh = gfs2_log_get_buf(sdp);
+		bh = gfs2_get_log_desc(sdp, GFS2_LOG_DESC_METADATA);
 		gfs2_log_lock(sdp);
-		ld = (struct gfs2_log_descriptor *)bh->b_data;
-		ptr = (__be64 *)(bh->b_data + offset);
-		ld->ld_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
-		ld->ld_header.mh_type = cpu_to_be32(GFS2_METATYPE_LD);
-		ld->ld_header.mh_format = cpu_to_be32(GFS2_FORMAT_LD);
-		ld->ld_type = cpu_to_be32(GFS2_LOG_DESC_METADATA);
+		ld = bh_log_desc(bh);
+		ptr = bh_log_ptr(bh);
 		ld->ld_length = cpu_to_be32(num + 1);
 		ld->ld_data1 = cpu_to_be32(num);
-		ld->ld_data2 = cpu_to_be32(0);
-		memset(ld->ld_reserved, 0, sizeof(ld->ld_reserved));
 
 		n = 0;
 		list_for_each_entry_continue(bd1, &sdp->sd_log_le_buf,
@@ -220,17 +246,17 @@ static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 		}
 
 		gfs2_log_unlock(sdp);
-		set_buffer_dirty(bh);
-		ll_rw_block(WRITE, 1, &bh);
+		submit_bh(WRITE, bh);
 		gfs2_log_lock(sdp);
 
 		n = 0;
 		list_for_each_entry_continue(bd2, &sdp->sd_log_le_buf,
 					     bd_le.le_list) {
+			get_bh(bd2->bd_bh);
 			gfs2_log_unlock(sdp);
+			lock_buffer(bd2->bd_bh);
 			bh = gfs2_log_fake_buf(sdp, bd2->bd_bh);
-			set_buffer_dirty(bh);
-			ll_rw_block(WRITE, 1, &bh);
+			submit_bh(WRITE, bh);
 			gfs2_log_lock(sdp);
 			if (++n >= num)
 				break;
@@ -359,17 +385,11 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 	if (!sdp->sd_log_num_revoke)
 		return;
 
-	bh = gfs2_log_get_buf(sdp);
-	ld = (struct gfs2_log_descriptor *)bh->b_data;
-	ld->ld_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
-	ld->ld_header.mh_type = cpu_to_be32(GFS2_METATYPE_LD);
-	ld->ld_header.mh_format = cpu_to_be32(GFS2_FORMAT_LD);
-	ld->ld_type = cpu_to_be32(GFS2_LOG_DESC_REVOKE);
+	bh = gfs2_get_log_desc(sdp, GFS2_LOG_DESC_REVOKE);
+	ld = bh_log_desc(bh);
 	ld->ld_length = cpu_to_be32(gfs2_struct2blk(sdp, sdp->sd_log_num_revoke,
 						    sizeof(u64)));
 	ld->ld_data1 = cpu_to_be32(sdp->sd_log_num_revoke);
-	ld->ld_data2 = cpu_to_be32(0);
-	memset(ld->ld_reserved, 0, sizeof(ld->ld_reserved));
 	offset = sizeof(struct gfs2_log_descriptor);
 
 	while (!list_empty(head)) {
@@ -378,8 +398,7 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 		sdp->sd_log_num_revoke--;
 
 		if (offset + sizeof(u64) > sdp->sd_sb.sb_bsize) {
-			set_buffer_dirty(bh);
-			ll_rw_block(WRITE, 1, &bh);
+			submit_bh(WRITE, bh);
 
 			bh = gfs2_log_get_buf(sdp);
 			mh = (struct gfs2_meta_header *)bh->b_data;
@@ -396,8 +415,7 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 	}
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_revoke);
 
-	set_buffer_dirty(bh);
-	ll_rw_block(WRITE, 1, &bh);
+	submit_bh(WRITE, bh);
 }
 
 static void revoke_lo_before_scan(struct gfs2_jdesc *jd,
@@ -562,118 +580,110 @@ out:
 	unlock_buffer(bd->bd_bh);
 }
 
-static int gfs2_check_magic(struct buffer_head *bh)
+static void gfs2_check_magic(struct buffer_head *bh)
 {
-	struct page *page = bh->b_page;
 	void *kaddr;
 	__be32 *ptr;
-	int rv = 0;
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	clear_buffer_escaped(bh);
+	kaddr = kmap_atomic(bh->b_page, KM_USER0);
 	ptr = kaddr + bh_offset(bh);
 	if (*ptr == cpu_to_be32(GFS2_MAGIC))
-		rv = 1;
+		set_buffer_escaped(bh);
 	kunmap_atomic(kaddr, KM_USER0);
-
-	return rv;
 }
 
-/**
- * databuf_lo_before_commit - Scan the data buffers, writing as we go
- *
- */
-
-static void databuf_lo_before_commit(struct gfs2_sbd *sdp)
+static void gfs2_write_blocks(struct gfs2_sbd *sdp, struct buffer_head *bh,
+			      struct list_head *list, struct list_head *done,
+			      unsigned int n)
 {
-	struct gfs2_bufdata *bd1 = NULL, *bd2;
-	struct buffer_head *bh = NULL,*bh1 = NULL;
+	struct buffer_head *bh1;
 	struct gfs2_log_descriptor *ld;
-	unsigned int limit;
-	unsigned int total;
-	unsigned int num, n;
-	__be64 *ptr = NULL;
-	int magic;
+	struct gfs2_bufdata *bd;
+	__be64 *ptr;
 
+	if (!bh)
+		return;
 
-	limit = databuf_limit(sdp);
+	ld = bh_log_desc(bh);
+	ld->ld_length = cpu_to_be32(n + 1);
+	ld->ld_data1 = cpu_to_be32(n);
 
+	ptr = bh_log_ptr(bh);
+	
+	get_bh(bh);
+	submit_bh(WRITE, bh);
 	gfs2_log_lock(sdp);
-	total = sdp->sd_log_num_databuf;
-	bd2 = bd1 = list_prepare_entry(bd1, &sdp->sd_log_le_databuf,
-				       bd_le.le_list);
-	while(total) {
-		num = total;
-		if (num > limit)
-			num = limit;
-
-		gfs2_log_unlock(sdp);
-		bh = gfs2_log_get_buf(sdp);
-		gfs2_log_lock(sdp);
-
-		ld = (struct gfs2_log_descriptor *)bh->b_data;
-		ptr = (__be64 *)(bh->b_data + DATABUF_OFFSET);
-		ld->ld_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
-		ld->ld_header.mh_type = cpu_to_be32(GFS2_METATYPE_LD);
-		ld->ld_header.mh_format = cpu_to_be32(GFS2_FORMAT_LD);
-		ld->ld_type = cpu_to_be32(GFS2_LOG_DESC_JDATA);
-		ld->ld_length = cpu_to_be32(num + 1);
-		ld->ld_data1 = cpu_to_be32(num);
-		ld->ld_data2 = cpu_to_be32(0);
-		memset(ld->ld_reserved, 0, sizeof(ld->ld_reserved));
-
-		n = 0;
-		list_for_each_entry_continue(bd1, &sdp->sd_log_le_databuf,
-					     bd_le.le_list) {
-			bh1 = bd1->bd_bh;
-
-			magic = gfs2_check_magic(bh1);
-			*ptr++ = cpu_to_be64(bh1->b_blocknr);
-			*ptr++ = cpu_to_be64((__u64)magic);
-			clear_buffer_escaped(bh1);
-			if (unlikely(magic != 0))
-				set_buffer_escaped(bh1);
-			if (++n >= num)
-				break;
+	while(!list_empty(list)) {
+		bd = list_entry(list->next, struct gfs2_bufdata, bd_le.le_list);
+		list_move_tail(&bd->bd_le.le_list, done);
+		get_bh(bd->bd_bh);
+		while (be64_to_cpu(*ptr) != bd->bd_bh->b_blocknr) {
+			gfs2_log_incr_head(sdp);
+			ptr += 2;
 		}
 		gfs2_log_unlock(sdp);
-		if (bh) {
-			set_buffer_dirty(bh);
-			ll_rw_block(WRITE, 1, &bh);
-			bh = NULL;
-			ptr = NULL;
+		lock_buffer(bd->bd_bh);
+		if (buffer_escaped(bd->bd_bh)) {
+			void *kaddr;
+			bh1 = gfs2_log_get_buf(sdp);
+			kaddr = kmap_atomic(bd->bd_bh->b_page, KM_USER0);
+			memcpy(bh1->b_data, kaddr + bh_offset(bd->bd_bh),
+			       bh1->b_size);
+			kunmap_atomic(kaddr, KM_USER0);
+			*(__be32 *)bh1->b_data = 0;
+			clear_buffer_escaped(bd->bd_bh);
+			unlock_buffer(bd->bd_bh);
+			brelse(bd->bd_bh);
+		} else {
+			bh1 = gfs2_log_fake_buf(sdp, bd->bd_bh);
 		}
-		n = 0;
+		submit_bh(WRITE, bh1);
 		gfs2_log_lock(sdp);
-		list_for_each_entry_continue(bd2, &sdp->sd_log_le_databuf,
-					     bd_le.le_list) {
-			if (!bd2->bd_bh)
-				continue;
-			/* copy buffer if it needs escaping */
+		ptr += 2;
+	}
+	gfs2_log_unlock(sdp);
+	brelse(bh);
+}
+
+/**
+ * databuf_lo_before_commit - Scan the data buffers, writing as we go
+ *
+ */
+
+static void databuf_lo_before_commit(struct gfs2_sbd *sdp)
+{
+	struct gfs2_bufdata *bd = NULL;
+	struct buffer_head *bh = NULL;
+	unsigned int n = 0;
+	__be64 *ptr = NULL, *end = NULL;
+	LIST_HEAD(processed);
+	LIST_HEAD(in_progress);
+
+	gfs2_log_lock(sdp);
+	while (!list_empty(&sdp->sd_log_le_databuf)) {
+		if (ptr == end) {
 			gfs2_log_unlock(sdp);
-			if (unlikely(buffer_escaped(bd2->bd_bh))) {
-				void *kaddr;
-				struct page *page = bd2->bd_bh->b_page;
-				bh = gfs2_log_get_buf(sdp);
-				kaddr = kmap_atomic(page, KM_USER0);
-				memcpy(bh->b_data,
-				       kaddr + bh_offset(bd2->bd_bh),
-				       sdp->sd_sb.sb_bsize);
-				kunmap_atomic(kaddr, KM_USER0);
-				*(__be32 *)bh->b_data = 0;
-			} else {
-				bh = gfs2_log_fake_buf(sdp, bd2->bd_bh);
-			}
-			set_buffer_dirty(bh);
-			ll_rw_block(WRITE, 1, &bh);
+			gfs2_write_blocks(sdp, bh, &in_progress, &processed, n);
+			n = 0;
+			bh = gfs2_get_log_desc(sdp, GFS2_LOG_DESC_JDATA);
+			ptr = bh_log_ptr(bh);
+			end = bh_ptr_end(bh) - 1;
 			gfs2_log_lock(sdp);
-			if (++n >= num)
-				break;
+			continue;
 		}
-		bh = NULL;
-		BUG_ON(total < num);
-		total -= num;
+		bd = list_entry(sdp->sd_log_le_databuf.next, struct gfs2_bufdata, bd_le.le_list);
+		list_move_tail(&bd->bd_le.le_list, &in_progress);
+		gfs2_check_magic(bd->bd_bh);
+		*ptr++ = cpu_to_be64(bd->bd_bh->b_blocknr);
+		*ptr++ = cpu_to_be64(buffer_escaped(bh) ? 1 : 0);
+		n++;
 	}
 	gfs2_log_unlock(sdp);
+	gfs2_write_blocks(sdp, bh, &in_progress, &processed, n);
+	gfs2_log_lock(sdp);
+	list_splice(&processed, &sdp->sd_log_le_databuf);
+	gfs2_log_unlock(sdp);
 }
 
 static int databuf_lo_scan_elements(struct gfs2_jdesc *jd, unsigned int start,
@@ -807,10 +817,10 @@ const struct gfs2_log_operations gfs2_databuf_lops = {
 
 const struct gfs2_log_operations *gfs2_log_ops[] = {
 	&gfs2_glock_lops,
+	&gfs2_databuf_lops,
 	&gfs2_buf_lops,
-	&gfs2_revoke_lops,
 	&gfs2_rg_lops,
-	&gfs2_databuf_lops,
+	&gfs2_revoke_lops,
 	NULL,
 };
 
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 19097bc..1d80f2d 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -297,6 +297,37 @@ void gfs2_attach_bufdata(struct gfs2_glock *gl, struct buffer_head *bh,
 		unlock_page(bh->b_page);
 }
 
+void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr, int meta)
+{
+	struct gfs2_sbd *sdp = GFS2_SB(bh->b_page->mapping->host);
+	struct gfs2_bufdata *bd = bh->b_private;
+	if (test_clear_buffer_pinned(bh)) {
+		list_del_init(&bd->bd_le.le_list);
+		if (meta) {
+			gfs2_assert_warn(sdp, sdp->sd_log_num_buf);
+			sdp->sd_log_num_buf--;
+			tr->tr_num_buf_rm++;
+		} else {
+			gfs2_assert_warn(sdp, sdp->sd_log_num_databuf);
+			sdp->sd_log_num_databuf--;
+			tr->tr_num_databuf_rm++;
+		}
+		tr->tr_touched = 1;
+		brelse(bh);
+	}
+	if (bd) {
+		if (bd->bd_ail) {
+			gfs2_remove_from_ail(NULL, bd);
+			bh->b_private = NULL;
+			bd->bd_bh = NULL;
+			bd->bd_blkno = bh->b_blocknr;
+			gfs2_trans_add_revoke(sdp, bd);
+		}
+	}
+	clear_buffer_dirty(bh);
+	clear_buffer_uptodate(bh);
+}
+
 /**
  * gfs2_meta_wipe - make inode's buffers so they aren't dirty/pinned anymore
  * @ip: the inode who owns the buffers
@@ -313,33 +344,11 @@ void gfs2_meta_wipe(struct gfs2_inode *ip, u64 bstart, u32 blen)
 	while (blen) {
 		bh = getbuf(ip->i_gl, bstart, NO_CREATE);
 		if (bh) {
-			struct gfs2_bufdata *bd;
-
 			lock_buffer(bh);
 			gfs2_log_lock(sdp);
-			bd = bh->b_private;
-			if (test_clear_buffer_pinned(bh)) {
-				struct gfs2_trans *tr = current->journal_info;
-				list_del_init(&bd->bd_le.le_list);
-				gfs2_assert_warn(sdp, sdp->sd_log_num_buf);
-				sdp->sd_log_num_buf--;
-				tr->tr_num_buf_rm++;
-				brelse(bh);
-			}
-			if (bd) {
-				if (bd->bd_ail) {
-					gfs2_remove_from_ail(NULL, bd);
-					bh->b_private = NULL;
-					bd->bd_bh = NULL;
-					bd->bd_blkno = bh->b_blocknr;
-					gfs2_trans_add_revoke(sdp, bd);
-				}
-			}
-			clear_buffer_dirty(bh);
-			clear_buffer_uptodate(bh);
+			gfs2_remove_from_journal(bh, current->journal_info, 1);
 			gfs2_log_unlock(sdp);
 			unlock_buffer(bh);
-
 			brelse(bh);
 		}
 
diff --git a/fs/gfs2/meta_io.h b/fs/gfs2/meta_io.h
index fd67f07..b704822 100644
--- a/fs/gfs2/meta_io.h
+++ b/fs/gfs2/meta_io.h
@@ -51,6 +51,9 @@ int gfs2_meta_wait(struct gfs2_sbd *sdp, struct buffer_head *bh);
 void gfs2_attach_bufdata(struct gfs2_glock *gl, struct buffer_head *bh,
 			 int meta);
 
+void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr,
+			      int meta);
+
 void gfs2_meta_wipe(struct gfs2_inode *ip, u64 bstart, u32 blen);
 
 void gfs2_meta_cache_flush(struct gfs2_inode *ip);
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index dd1ea49..b7baf18 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -414,7 +414,8 @@ static int gfs2_prepare_write(struct file *file, struct page *page,
 	if (ind_blocks || data_blocks)
 		rblocks += RES_STATFS + RES_QUOTA;
 
-	error = gfs2_trans_begin(sdp, rblocks, 0);
+	error = gfs2_trans_begin(sdp, rblocks,
+				 PAGE_CACHE_SIZE/sdp->sd_sb.sb_bsize);
 	if (error)
 		goto out_trans_fail;
 
@@ -625,10 +626,10 @@ static void gfs2_discard(struct gfs2_sbd *sdp, struct buffer_head *bh)
 	clear_buffer_dirty(bh);
 	bd = bh->b_private;
 	if (bd) {
-		if (!list_empty(&bd->bd_le.le_list)) {
-			if (!buffer_pinned(bh))
-				list_del_init(&bd->bd_le.le_list);
-		}
+		if (!list_empty(&bd->bd_le.le_list) && !buffer_pinned(bh))
+			list_del_init(&bd->bd_le.le_list);
+		else
+			gfs2_remove_from_journal(bh, current->journal_info, 0);
 	}
 	bh->b_bdev = NULL;
 	clear_buffer_mapped(bh);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 35f3dfa..1ac9afa 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -89,7 +89,8 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	INIT_LIST_HEAD(&sdp->sd_ail2_list);
 
 	init_rwsem(&sdp->sd_log_flush_lock);
-	INIT_LIST_HEAD(&sdp->sd_log_flush_list);
+	atomic_set(&sdp->sd_log_in_flight, 0);
+	init_waitqueue_head(&sdp->sd_log_flush_wait);
 
 	INIT_LIST_HEAD(&sdp->sd_revoke_list);
 
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 2cbe5a3..291f0c7 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -905,12 +905,17 @@ static int gfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
 static int setattr_size(struct inode *inode, struct iattr *attr)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	int error;
 
 	if (attr->ia_size != ip->i_di.di_size) {
-		error = vmtruncate(inode, attr->ia_size);
+		error = gfs2_trans_begin(sdp, 0, sdp->sd_jdesc->jd_blocks);
 		if (error)
 			return error;
+		error = vmtruncate(inode, attr->ia_size);
+		gfs2_trans_end(sdp);
+		if (error) 
+			return error;
 	}
 
 	error = gfs2_truncatei(ip, attr->ia_size);
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 4316690..950f314 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -455,12 +455,15 @@ static void gfs2_delete_inode(struct inode *inode)
 	}
 
 	error = gfs2_dinode_dealloc(ip);
-	/*
-	 * Must do this before unlock to avoid trying to write back
-	 * potentially dirty data now that inode no longer exists
-	 * on disk.
-	 */
+	if (error)
+		goto out_unlock;
+
+	error = gfs2_trans_begin(sdp, 0, sdp->sd_jdesc->jd_blocks);
+	if (error)
+		goto out_unlock;
+	/* Needs to be done before glock release & also in a transaction */
 	truncate_inode_pages(&inode->i_data, 0);
+	gfs2_trans_end(sdp);
 
 out_unlock:
 	gfs2_glock_dq(&ip->i_iopen_gh);
-- 
1.5.1.2

