Return-Path: <linux-kernel-owner+w=401wt.eu-S1760978AbXJDJbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978AbXJDJbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758903AbXJDJS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759424AbXJDJSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:20 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 36/51] [GFS2] Clean up ordered write code
Date: Thu,  4 Oct 2007 09:49:29 +0100
Message-Id: <11914878551328-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <119148785427-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The following patch removes the ordered write processing from
databuf_lo_before_commit() and moves it to log.c. This has the effect of
greatly simplyfying databuf_lo_before_commit() and well as potentially
making the ordered write code more efficient.

As a side effect of this, its now possible to remove ordered buffers
from the ordered buffer list at any time, so we now make use of this in
invalidatepage and releasepage to ensure timely release of these
buffers.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 23b611a..388dc1b 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -612,13 +612,13 @@ struct gfs2_sbd {
 	unsigned int sd_log_num_revoke;
 	unsigned int sd_log_num_rg;
 	unsigned int sd_log_num_databuf;
-	unsigned int sd_log_num_jdata;
 
 	struct list_head sd_log_le_gl;
 	struct list_head sd_log_le_buf;
 	struct list_head sd_log_le_revoke;
 	struct list_head sd_log_le_rg;
 	struct list_head sd_log_le_databuf;
+	struct list_head sd_log_le_ordered;
 
 	unsigned int sd_log_blks_free;
 	struct mutex sd_log_reserve_mutex;
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index d8232ec..20fa528 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -620,6 +620,57 @@ static void log_flush_commit(struct gfs2_sbd *sdp)
 	}
 }
 
+static void gfs2_ordered_write(struct gfs2_sbd *sdp)
+{
+	struct gfs2_bufdata *bd;
+	struct buffer_head *bh;
+	LIST_HEAD(written);
+
+	gfs2_log_lock(sdp);
+	while (!list_empty(&sdp->sd_log_le_ordered)) {
+		bd = list_entry(sdp->sd_log_le_ordered.next, struct gfs2_bufdata, bd_le.le_list);
+		list_move(&bd->bd_le.le_list, &written);
+		bh = bd->bd_bh;
+		if (!buffer_dirty(bh))
+			continue;
+		get_bh(bh);
+		gfs2_log_unlock(sdp);
+		lock_buffer(bh);
+		if (test_clear_buffer_dirty(bh)) {
+			bh->b_end_io = end_buffer_write_sync;
+			submit_bh(WRITE, bh);
+		} else {
+			unlock_buffer(bh);
+			brelse(bh);
+		}
+		gfs2_log_lock(sdp);
+	}
+	list_splice(&written, &sdp->sd_log_le_ordered);
+	gfs2_log_unlock(sdp);
+}
+
+static void gfs2_ordered_wait(struct gfs2_sbd *sdp)
+{
+	struct gfs2_bufdata *bd;
+	struct buffer_head *bh;
+
+	gfs2_log_lock(sdp);
+	while (!list_empty(&sdp->sd_log_le_ordered)) {
+		bd = list_entry(sdp->sd_log_le_ordered.prev, struct gfs2_bufdata, bd_le.le_list);
+		bh = bd->bd_bh;
+		if (buffer_locked(bh)) {
+			get_bh(bh);
+			gfs2_log_unlock(sdp);
+			wait_on_buffer(bh);
+			brelse(bh);
+			gfs2_log_lock(sdp);
+			continue;
+		}
+		list_del_init(&bd->bd_le.le_list);
+	}
+	gfs2_log_unlock(sdp);
+}
+
 /**
  * gfs2_log_flush - flush incore transaction(s)
  * @sdp: the filesystem
@@ -648,7 +699,7 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	INIT_LIST_HEAD(&ai->ai_ail2_list);
 
 	gfs2_assert_withdraw(sdp,
-			     sdp->sd_log_num_buf + sdp->sd_log_num_jdata ==
+			     sdp->sd_log_num_buf + sdp->sd_log_num_databuf ==
 			     sdp->sd_log_commited_buf +
 			     sdp->sd_log_commited_databuf);
 	gfs2_assert_withdraw(sdp,
@@ -658,7 +709,10 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	sdp->sd_log_flush_wrapped = 0;
 	ai->ai_first = sdp->sd_log_flush_head;
 
+	gfs2_ordered_write(sdp);
 	lops_before_commit(sdp);
+	gfs2_ordered_wait(sdp);
+
 	if (!list_empty(&sdp->sd_log_flush_list))
 		log_flush_commit(sdp);
 	else if (sdp->sd_log_tail != current_tail(sdp) && !sdp->sd_log_idle){
@@ -751,7 +805,6 @@ void gfs2_log_shutdown(struct gfs2_sbd *sdp)
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_blks_reserved);
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_gl);
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_buf);
-	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_jdata);
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_revoke);
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_rg);
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_databuf);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 3ec5871..7e2d4e6 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -555,10 +555,11 @@ static void databuf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
 	if (gfs2_is_jdata(ip)) {
 		gfs2_pin(sdp, bd->bd_bh);
 		tr->tr_num_databuf_new++;
-		sdp->sd_log_num_jdata++;
+		sdp->sd_log_num_databuf++;
+		list_add(&le->le_list, &sdp->sd_log_le_databuf);
+	} else {
+		list_add(&le->le_list, &sdp->sd_log_le_ordered);
 	}
-	sdp->sd_log_num_databuf++;
-	list_add(&le->le_list, &sdp->sd_log_le_databuf);
 out:
 	gfs2_log_unlock(sdp);
 	unlock_buffer(bd->bd_bh);
@@ -583,114 +584,59 @@ static int gfs2_check_magic(struct buffer_head *bh)
 /**
  * databuf_lo_before_commit - Scan the data buffers, writing as we go
  *
- * Here we scan through the lists of buffers and make the assumption
- * that any buffer thats been pinned is being journaled, and that
- * any unpinned buffer is an ordered write data buffer and therefore
- * will be written back rather than journaled.
  */
+
 static void databuf_lo_before_commit(struct gfs2_sbd *sdp)
 {
-	LIST_HEAD(started);
-	struct gfs2_bufdata *bd1 = NULL, *bd2, *bdt;
+	struct gfs2_bufdata *bd1 = NULL, *bd2;
 	struct buffer_head *bh = NULL,*bh1 = NULL;
 	struct gfs2_log_descriptor *ld;
 	unsigned int limit;
-	unsigned int total_dbuf;
-	unsigned int total_jdata;
+	unsigned int total;
 	unsigned int num, n;
 	__be64 *ptr = NULL;
+	int magic;
+
 
 	limit = databuf_limit(sdp);
 
-	/*
-	 * Start writing ordered buffers, write journaled buffers
-	 * into the log along with a header
-	 */
 	gfs2_log_lock(sdp);
-	total_dbuf = sdp->sd_log_num_databuf;
-	total_jdata = sdp->sd_log_num_jdata;
+	total = sdp->sd_log_num_databuf;
 	bd2 = bd1 = list_prepare_entry(bd1, &sdp->sd_log_le_databuf,
 				       bd_le.le_list);
-	while(total_dbuf) {
-		num = total_jdata;
+	while(total) {
+		num = total;
 		if (num > limit)
 			num = limit;
+
+		gfs2_log_unlock(sdp);
+		bh = gfs2_log_get_buf(sdp);
+		gfs2_log_lock(sdp);
+
+		ld = (struct gfs2_log_descriptor *)bh->b_data;
+		ptr = (__be64 *)(bh->b_data + DATABUF_OFFSET);
+		ld->ld_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
+		ld->ld_header.mh_type = cpu_to_be32(GFS2_METATYPE_LD);
+		ld->ld_header.mh_format = cpu_to_be32(GFS2_FORMAT_LD);
+		ld->ld_type = cpu_to_be32(GFS2_LOG_DESC_JDATA);
+		ld->ld_length = cpu_to_be32(num + 1);
+		ld->ld_data1 = cpu_to_be32(num);
+		ld->ld_data2 = cpu_to_be32(0);
+		memset(ld->ld_reserved, 0, sizeof(ld->ld_reserved));
+
 		n = 0;
-		list_for_each_entry_safe_continue(bd1, bdt,
-						  &sdp->sd_log_le_databuf,
-						  bd_le.le_list) {
-			/* store off the buffer head in a local ptr since
-			 * gfs2_bufdata might change when we drop the log lock
-			 */
+		list_for_each_entry_continue(bd1, &sdp->sd_log_le_databuf,
+					     bd_le.le_list) {
 			bh1 = bd1->bd_bh;
 
-			/* An ordered write buffer */
-			if (bh1 && !buffer_pinned(bh1)) {
-				list_move(&bd1->bd_le.le_list, &started);
-				if (bd1 == bd2) {
-					bd2 = NULL;
-					bd2 = list_prepare_entry(bd2,
-							&sdp->sd_log_le_databuf,
-							bd_le.le_list);
-				}
-				total_dbuf--;
-				if (bh1) {
-					if (buffer_dirty(bh1)) {
-						get_bh(bh1);
-
-						gfs2_log_unlock(sdp);
-
-						ll_rw_block(SWRITE, 1, &bh1);
-						brelse(bh1);
-
-						gfs2_log_lock(sdp);
-					}
-					continue;
-				}
-				continue;
-			} else if (bh1) { /* A journaled buffer */
-				int magic;
-				gfs2_log_unlock(sdp);
-				if (!bh) {
-					bh = gfs2_log_get_buf(sdp);
-					ld = (struct gfs2_log_descriptor *)
-					     bh->b_data;
-					ptr = (__be64 *)(bh->b_data +
-							 DATABUF_OFFSET);
-					ld->ld_header.mh_magic =
-						cpu_to_be32(GFS2_MAGIC);
-					ld->ld_header.mh_type =
-						cpu_to_be32(GFS2_METATYPE_LD);
-					ld->ld_header.mh_format =
-						cpu_to_be32(GFS2_FORMAT_LD);
-					ld->ld_type =
-						cpu_to_be32(GFS2_LOG_DESC_JDATA);
-					ld->ld_length = cpu_to_be32(num + 1);
-					ld->ld_data1 = cpu_to_be32(num);
-					ld->ld_data2 = cpu_to_be32(0);
-					memset(ld->ld_reserved, 0, sizeof(ld->ld_reserved));
-				}
-				magic = gfs2_check_magic(bh1);
-				*ptr++ = cpu_to_be64(bh1->b_blocknr);
-				*ptr++ = cpu_to_be64((__u64)magic);
-				clear_buffer_escaped(bh1);
-				if (unlikely(magic != 0))
-					set_buffer_escaped(bh1);
-				gfs2_log_lock(sdp);
-				if (++n >= num)
-					break;
-			} else if (!bh1) {
-				total_dbuf--;
-				sdp->sd_log_num_databuf--;
-				list_del_init(&bd1->bd_le.le_list);
-				if (bd1 == bd2) {
-					bd2 = NULL;
-					bd2 = list_prepare_entry(bd2,
-						&sdp->sd_log_le_databuf,
-						bd_le.le_list);
-                                }
-				kmem_cache_free(gfs2_bufdata_cachep, bd1);
-			}
+			magic = gfs2_check_magic(bh1);
+			*ptr++ = cpu_to_be64(bh1->b_blocknr);
+			*ptr++ = cpu_to_be64((__u64)magic);
+			clear_buffer_escaped(bh1);
+			if (unlikely(magic != 0))
+				set_buffer_escaped(bh1);
+			if (++n >= num)
+				break;
 		}
 		gfs2_log_unlock(sdp);
 		if (bh) {
@@ -727,34 +673,10 @@ static void databuf_lo_before_commit(struct gfs2_sbd *sdp)
 				break;
 		}
 		bh = NULL;
-		BUG_ON(total_dbuf < num);
-		total_dbuf -= num;
-		total_jdata -= num;
+		BUG_ON(total < num);
+		total -= num;
 	}
 	gfs2_log_unlock(sdp);
-
-	/* Wait on all ordered buffers */
-	while (!list_empty(&started)) {
-		gfs2_log_lock(sdp);
-		bd1 = list_entry(started.next, struct gfs2_bufdata,
-				 bd_le.le_list);
-		list_del_init(&bd1->bd_le.le_list);
-		sdp->sd_log_num_databuf--;
-		bh = bd1->bd_bh;
-		if (bh) {
-			bh->b_private = NULL;
-			get_bh(bh);
-			gfs2_log_unlock(sdp);
-			wait_on_buffer(bh);
-			brelse(bh);
-		} else
-			gfs2_log_unlock(sdp);
-
-		kmem_cache_free(gfs2_bufdata_cachep, bd1);
-	}
-
-	/* We've removed all the ordered write bufs here, so only jdata left */
-	gfs2_assert_warn(sdp, sdp->sd_log_num_databuf == sdp->sd_log_num_jdata);
 }
 
 static int databuf_lo_scan_elements(struct gfs2_jdesc *jd, unsigned int start,
@@ -838,11 +760,9 @@ static void databuf_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 		bd = list_entry(head->next, struct gfs2_bufdata, bd_le.le_list);
 		list_del_init(&bd->bd_le.le_list);
 		sdp->sd_log_num_databuf--;
-		sdp->sd_log_num_jdata--;
 		gfs2_unpin(sdp, bd->bd_bh, ai);
 	}
 	gfs2_assert_warn(sdp, !sdp->sd_log_num_databuf);
-	gfs2_assert_warn(sdp, !sdp->sd_log_num_jdata);
 }
 
 
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 8407d1d..dd1ea49 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -616,13 +616,50 @@ static sector_t gfs2_bmap(struct address_space *mapping, sector_t lblock)
 	return dblock;
 }
 
+static void gfs2_discard(struct gfs2_sbd *sdp, struct buffer_head *bh)
+{
+	struct gfs2_bufdata *bd;
+
+	lock_buffer(bh);
+	gfs2_log_lock(sdp);
+	clear_buffer_dirty(bh);
+	bd = bh->b_private;
+	if (bd) {
+		if (!list_empty(&bd->bd_le.le_list)) {
+			if (!buffer_pinned(bh))
+				list_del_init(&bd->bd_le.le_list);
+		}
+	}
+	bh->b_bdev = NULL;
+	clear_buffer_mapped(bh);
+	clear_buffer_req(bh);
+	clear_buffer_new(bh);
+	gfs2_log_unlock(sdp);
+	unlock_buffer(bh);
+}
+
 static void gfs2_invalidatepage(struct page *page, unsigned long offset)
 {
+	struct gfs2_sbd *sdp = GFS2_SB(page->mapping->host);
+	struct buffer_head *bh, *head;
+	unsigned long pos = 0;
+
 	BUG_ON(!PageLocked(page));
 	if (offset == 0)
 		ClearPageChecked(page);
+	if (!page_has_buffers(page))
+		goto out;
 
-	block_invalidatepage(page, offset);
+	bh = head = page_buffers(page);
+	do {
+		if (offset <= pos)
+			gfs2_discard(sdp, bh);
+		pos += bh->b_size;
+		bh = bh->b_this_page;
+	} while (bh != head);
+out:
+	if (offset == 0)
+		try_to_release_page(page, 0);
 }
 
 /**
@@ -732,9 +769,14 @@ int gfs2_releasepage(struct page *page, gfp_t gfp_mask)
 		if (bd) {
 			gfs2_assert_warn(sdp, bd->bd_bh == bh);
 			gfs2_assert_warn(sdp, list_empty(&bd->bd_list_tr));
-			bd->bd_bh = NULL;
-			if (!list_empty(&bd->bd_le.le_list))
-				bd = NULL;
+			if (!list_empty(&bd->bd_le.le_list)) {
+				if (!buffer_pinned(bh))
+					list_del_init(&bd->bd_le.le_list);
+				else
+					bd = NULL;
+			}
+			if (bd)
+				bd->bd_bh = NULL;
 			bh->b_private = NULL;
 		}
 		gfs2_log_unlock(sdp);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 314c113..35f3dfa 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -82,6 +82,7 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	INIT_LIST_HEAD(&sdp->sd_log_le_revoke);
 	INIT_LIST_HEAD(&sdp->sd_log_le_rg);
 	INIT_LIST_HEAD(&sdp->sd_log_le_databuf);
+	INIT_LIST_HEAD(&sdp->sd_log_le_ordered);
 
 	mutex_init(&sdp->sd_log_reserve_mutex);
 	INIT_LIST_HEAD(&sdp->sd_ail1_list);
-- 
1.5.1.2

